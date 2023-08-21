local rsac = {}
rsac.convert = require("Convert")
rsac.prox = require("RSProxies")
rsac.mf = require("MainFunctions")
rsac.refs = rsac.mf.component.block_refinedstorage_cable
rsac.items = require("RSItems")
rsac.fluids = require("RSFluids")
rsac.storage = {items={}, fluids={}}
rsac.valid = {items={}, fluids={}}
rsac.prio = 1
rsac.firsttime = true

-- for index,item in pairs(rsac.storageitems) do
    -- rsac.items[rsac.convert.ItemToOName(item)] = {minCount=0, maxCount=0, RSChannel={}}
-- end

-- rsac.mf.WriteObjectFile(rsac.items, "/home/RSItems.lua")

function rsac.MergeItems()
    for i,typ in pairs({"items", "fluids"}) do
        local countname = "amount"
        if typ == "items" then
            countname = "size"
        end
        if typ == "items" then
            rsac.storage[typ] = rsac.refs.getItems()
        else
            rsac.storage[typ] = rsac.refs.getFluids()
        end
        for index,item in pairs(rsac.storage[typ]) do
            if index == "n" then
                goto continue
            end
            local citem = rsac.convert.ItemToOName(item)
            if rsac[typ][citem] then
                rsac[typ][citem].Count = item[countname]
                if rsac.firsttime then
                    rsac[typ][citem].Converted = citem
                    rsac[typ][citem].Name = citem
                    rsac[typ][citem].Label = item.label
                    rsac[typ][citem].Status = ""
                end
            elseif rsac.firsttime then
                print("StorageItem not found in ItemList: " .. citem .. " (" .. item.label .. ")")
            end
            local zindex = 2
            while true do
                local zitem = citem .. "_z" .. zindex
                if rsac[typ][zitem] ~= nil then
                    rsac[typ][zitem].Count = item[countname]
                    if rsac.firsttime then
                        rsac[typ][zitem].Converted = citem
                        rsac[typ][zitem].Name = zitem
                        rsac[typ][zitem].Label = item.label
                        rsac[typ][zitem].Status = ""
                    end
                else
                    break
                end
                zindex = zindex + 1
            end
            ::continue::
        end
        -- rsac.storage[typ] = {}
        if rsac.firsttime then
            local saved = require("RSItemsSaved")
            if typ ~= "items" then
                saved = require("RSFluidsSaved")
            end
            for index,item in pairs(rsac[typ]) do
                if rsac.ValidItem(item) then
                    if saved[index] ~= nil then
                        item.State = saved[index].State
                    end
                    if item.State == nil then
                        item.State = rsac.GetStateSwitch(item).OFF
                    end
                    if item.Count == nil then
                        item.Count = 0
                    end
                    for index2,prop in pairs({"Count","minCount","maxCount"}) do
                        if item[prop] == nil then
                            item[prop] = 0
                        end
                    end
                    for index2,prop in pairs({"Converted","Name","Label","Status"}) do
                        if item[prop] == nil then
                            item[prop] = ""
                        end
                    end
                    rsac.GetPrio(item, 1, typ)
                    table.insert(rsac.valid[typ], item)
                    rsac.CheckState(item)
                end
            end
            saved = nil
        end
    end
    rsac.firsttime = false
end

function rsac.GetPrio(item, initPrio, typ)
    if not item.Prio then
        item.Prio = 1
        local prio = initPrio
        for onI,onType in pairs({"DependsOn","DependsOff","StartsOn"}) do
            if item[onType] then
                if item[onType].Name then
                    item[onType] = {item[onType]}
                end
                for depI,dependItem in pairs(item[onType]) do
                    local typEx = typ
                    if dependItem.typ then
                        typEx = dependItem.typ
                    end
                    local itemEx = rsac[typEx][dependItem.Name]
                    if itemEx then
                        rsac.GetPrio(itemEx, 1, typEx)
                        if itemEx.Prio >= prio then
                            prio = itemEx.Prio + 1
                        end
                    end
                end
                item.Prio = prio
            end
        end
        if rsac.prio < prio then rsac.prio = prio end
    end
end

function rsac.ValidItem(item)
    local ok = true
    if rsac.mf.getCount(item.RSChannel) ~= 3 then
        ok = false
    elseif rsac.prox[item.RSChannel[1]] == nil then
        ok = false
    elseif rsac.prox[item.RSChannel[1]][item.RSChannel[2]] == nil then
        ok = false
    elseif rsac.mf.sides[item.RSChannel[3]] == nil then
        ok = false
    end
    return ok
end

function rsac.GetStateSwitch(item)
    local stateSwitch = {OFF = false, ON = true}
    if item.Reversed then
        stateSwitch = {OFF = true, ON = false}
    end
    return stateSwitch
end

function rsac.GetStateString(item, state)
    return rsac.mf.getIndex(rsac.GetStateSwitch(item), state)
end

function rsac.GetItemMinMax(item)
    local result = {min = item.minCount, max = item.maxCount}
    if result.min > result.max then
        result = {max = item.minCount, min = item.maxCount}
    end
    result.diff = result.max - result.min
    return result
end

function rsac.Check(item, typ)
    item.Status = ""
    local stateSwitch = rsac.GetStateSwitch(item)
    if item.StartsOn then
        for depI,dependItem in pairs(item.StartsOn) do
            local typEx = typ
            if dependItem.typ then
                typEx = dependItem.typ
            end
            if rsac[typEx][dependItem.Name].State == rsac.GetStateSwitch(item).ON then
                rsac.SwitchRS(item, stateSwitch.ON)
                return
            end
        end
        rsac.SwitchRS(item, stateSwitch.OFF)
        return
    end
    local depOnList = {}
    if item.DependsOn then
        for depI,dependItem in pairs(item.DependsOn) do
            local typEx = typ
            if dependItem.typ then
                typEx = dependItem.typ
            end
            local itemEx = rsac[typEx][dependItem.Name]
            if itemEx then
                local on = itemEx.State == rsac.GetStateSwitch(itemEx).ON
                local depending = itemEx.Status == "Depends"
                local minmax = rsac.GetItemMinMax(itemEx)
                local halfway = (itemEx.Count > (minmax.max - (minmax.diff / 2)))
                local almostFull = (itemEx.Count > (minmax.max - (minmax.diff / 10)))
                if (on and not halfway) or depending then
                    item.Status = "Depends"
                    return
                elseif not on and halfway and not almostFull then
                    table.insert(depOnList, itemEx)
                end
            end
        end
    end
    if item.DependsOff then
        for depI,dependItem in pairs(item.DependsOff) do
            local typEx = typ
            if dependItem.typ then
                typEx = dependItem.typ
            end
            local itemEx = rsac[typEx][dependItem.Name]
            if itemEx then
                local on = itemEx.State == rsac.GetStateSwitch(itemEx).ON
                local depending = itemEx.Status == "Depends"
                if on or depending then
                    item.Status = "Depends"
                    return
                end
            end
        end
    end
    local minmax = rsac.GetItemMinMax(item)
    if item.State == stateSwitch.OFF and minmax.min > item.Count then
        rsac.SwitchRS(item, stateSwitch.ON)
        for depI,dependItem in pairs(depOnList) do
            rsac.SwitchRS(dependItem, rsac.GetStateSwitch(dependItem).ON)
        end
    elseif item.State == stateSwitch.ON and minmax.max < item.Count then
        rsac.SwitchRS(item, stateSwitch.OFF)
    end
end

function rsac.SwitchRS(item, state)
    if item.State ~= nil and item.State == state then return end
    local strength = 0
    local switchString = rsac.GetStateString(item, state)
    if item.minCount > item.maxCount then
        switchString = rsac.GetStateString({}, state)
    end
    if state then strength = 15 end
    local proxy = rsac.mf.component.proxy(rsac.prox[item.RSChannel[1]][item.RSChannel[2]])
    local b = proxy.setOutput(rsac.mf.sides[item.RSChannel[3]], strength)
    item.State = state
    print("Turned " .. switchString .. ": " .. item.Label .. " (" .. item.Name .. ") (Strength: " .. strength .. ")")
end

function rsac.CheckState(item)
    if item.State == nil then
        return
    end
    local proxy = rsac.mf.component.proxy(rsac.prox[item.RSChannel[1]][item.RSChannel[2]])
    local strength = proxy.getOutput(rsac.mf.sides[item.RSChannel[3]])
    if (item.State and strength ~= 15) or (not item.State and strength ~= 0) then
        local stateTemp = item.State
        item.State = (not item.State)
        rsac.SwitchRS(item, stateTemp)
    end
end

function rsac.GoThruItems()
    rsac.MergeItems()
    for p=1,rsac.prio,1 do
        for i,typ in pairs({"items", "fluids"}) do
            for index,item in pairs(rsac.valid[typ]) do
                if item.Prio == p then
                    rsac.Check(item, typ)
                end
            end
        end
    end
end

function rsac.TurnOffAll()
    for index,item in pairs(rsac.items) do
        if rsac.ValidItem(item) == false then
            return
        end
        local stateSwitch = rsac.GetStateSwitch(item)
        rsac.SwitchRS(item, stateSwitch.OFF)
    end
end

function rsac.GetSysState(typeInt)
    local proxy = rsac.mf.component.proxy(rsac.prox[typeInt][1])
    local strength = proxy.getInput(rsac.mf.sides.down)
    if strength == 15 then return true end
    return false
end

function rsac.GetSystemState()
    return rsac.GetSysState(1)
end

function rsac.GetLoopState()
    return rsac.GetSysState(2)
end

function rsac.SaveItems()
    local temp = {}
    for index,item in pairs(rsac.valid.items) do
        temp[item.Name] = {State=item.State}
    end
    rsac.mf.WriteObjectFile(temp,"/home/RSItemsSaved.lua")
    temp = {}
    for index,item in pairs(rsac.valid.fluids) do
        temp[item.Name] = {State=item.State}
    end
    rsac.mf.WriteObjectFile(temp,"/home/RSFluidsSaved.lua")
    temp = nil
end

function rsac.Start()
    local save = false
    if rsac.GetLoopState() then
        save = true
    end
    while rsac.GetLoopState() do
        if rsac.GetSystemState() then
            rsac.GoThruItems()
        end
        rsac.mf.os.sleep(60)
    end
    if save then
        rsac.SaveItems()
    end
    print("RSAuto Loop End")
end

return rsac