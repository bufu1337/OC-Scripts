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
                rsac[typ][citem].Count = item.size
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
                    rsac[typ][zitem].Count = item.size
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
                    rsac.CheckState(item, typ)
                end
            end
            saved = nil
        end
    end
    rsac.firsttime = false
end

function rsac.GetPrio(item, initPrio, typ)
    if item.Prio == nil then
        if item.DependsOn ~= nil then
            local prio = initPrio
            for depI,dependItem in pairs(item.DependsOn) do
                if dependItem.typ ~= nil then
                    typEx = dependItem.typ
                else
                    typEx = typ
                end
                if rsac[typEx][dependItem.name] ~= nil then
                    rsac.GetPrio(rsac[typEx][dependItem.name], 1, typEx)
                    if rsac[typEx][dependItem.name].Prio >= prio then
                        prio = rsac[typEx][dependItem.name].Prio + 1
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
            if dependItem.typ ~= nil then
                typEx = dependItem.typ
            else
                typEx = typ
            end
            if rsac[typEx][dependItem.name] ~= nil then
                local on = rsac[typEx][dependItem.name].State == rsac.GetStateSwitch(rsac[typEx][dependItem.name]).ON
                local depending = rsac[typEx][dependItem.name].Status == "Depends"
                if on or depending then
                    item.Status = "Depends"
                    return
                end
            end
        end
    end
    local stateSwitch = rsac.GetStateSwitch(item)
    if item.State == stateSwitch.OFF and item.minCount > item.Count then
        rsac.SwitchRS(item, stateSwitch.ON, typ)
    elseif item.State == stateSwitch.ON and item.maxCount < item.Count then
        rsac.SwitchRS(item, stateSwitch.OFF, typ)
    end
end

function rsac.SwitchRS(item, state, typ)
    if item.State ~= nil and item.State == state then
        return
    end
    local strength = 0
    local switchString = "OFF"
    if (state == false and item.RSreversed ~= nil) or (state and item.RSreversed == nil) then
        strength = 15
        switchString = "ON"
    end
    local proxy = rsac.mf.component.proxy(rsac.prox[item.RSChannel[1]][item.RSChannel[2]])
    local b = proxy.setOutput(rsac.mf.sides[item.RSChannel[3]], strength)
    rsac[typ][item.Name].State = state
    print("Turned " .. switchString .. ": " .. item.Label .. " (" .. item.Name .. ")")
end

function rsac.CheckState(item, typ)
    if item.State == nil then
        return
    end
    local proxy = rsac.mf.component.proxy(rsac.prox[item.RSChannel[1]][item.RSChannel[2]])
    local strength = proxy.getOutput(rsac.mf.sides[item.RSChannel[3]])
    if (((item.State == false and item.RSreversed ~= nil) or (item.State and item.RSreversed == nil)) and strength ~= 15) or 
       (((item.State and item.RSreversed ~= nil) or (item.State == false and item.RSreversed == nil)) and strength ~= 0) then
        stateTemp = item.State
        rsac[typ][item.Name].State = (not item.State)
        rsac.SwitchRS(item, stateTemp, typ)
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
    local strength = proxy.getOutput(rsac.mf.sides.down)
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
    while rsac.GetLoopState() do
        if rsac.GetSystemState() then
            rsac.GoThruItems()
        end
        rsac.mf.os.sleep(60)
    end
    rsac.SaveItems()
    print("RSAuto Loop End")
end

return rsac