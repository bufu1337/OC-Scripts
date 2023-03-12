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
            if rsac[typ][citem] ~= nil then
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
                        item.State = false
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
    if item.Prio == nil then
        print("GetPrio: " .. item.Name)
        if item.DependsOn ~= nil then
            local prio = initPrio
            for depI,dependItem in pairs(item.DependsOn) do
                if dependItem.typ ~= nil then
                    typEx = dependItem.typ
                else
                    typEx = typ
                end
                itemEx = rsac[typEx][dependItem.Name]
                if itemEx ~= nil then
                    rsac.GetPrio(itemEx, 1, typEx)
                    if itemEx.Prio >= prio then
                        prio = itemEx.Prio + 1
                    end
                end
            end
            if rsac.prio < prio then
                rsac.prio = prio
            end
            item.Prio = prio
        else
            item.Prio = 1
        end
    end
end

function rsac.ValidItem(item)
    local ok = true
    for i,j in pairs({"minCount", "maxCount", "Count", "RSChannel", "Label"}) do
        if item[j] == nil then
            ok = false
        end
    end
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
    if item.Reversed ~= nil then
        stateSwitch = {OFF = true, ON = false}
    end
    return stateSwitch
end

function rsac.GetStateString(item, state)
    return rsac.mf.getIndex(rsac.GetStateSwitch(item), state)
end

function rsac.Check(item, typ)
    item.Status = ""
    if item.DependsOn ~= nil then
        for depI,dependItem in pairs(item.DependsOn) do
            local typEx = typ
            if dependItem.typ ~= nil then
                typEx = dependItem.typ
            end
            local itemEx = rsac[typEx][dependItem.Name]
            if itemEx ~= nil then
                local on = itemEx.State == rsac.GetStateSwitch(itemEx).ON
                local depending = itemEx.Status == "Depends"
                if on or depending then
                    item.Status = "Depends"
                    return
                end
            end
        end
    end
    local stateSwitch = rsac.GetStateSwitch(item)
    local min = item.minCount
    local max = item.maxCount
    if min > max then
        min = item.maxCount
        max = item.minCount
    end
    if item.State == stateSwitch.OFF and item.minCount > item.Count then
        rsac.SwitchRS(item, stateSwitch.ON)
    elseif item.State == stateSwitch.ON and item.maxCount < item.Count then
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