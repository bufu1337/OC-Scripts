local rsac = {}
rsac.convert = require("Convert")
rsac.prox = require("RSProxies")
rsac.mf = require("MainFunctions")
rsac.refs = rsac.mf.component.block_refinedstorage_cable
rsac.items = require("RSItems")
rsac.storageitems = {}
rsac.validitems = {}
rsac.prio = 1
rsac.firsttime = true

-- for index,item in pairs(rsac.storageitems) do
    -- rsac.items[rsac.convert.ItemToOName(item)] = {minCount=0, maxCount=0, RSChannel={}}
-- end

-- rsac.mf.WriteObjectFile(rsac.items, "/home/RSItems.lua")

function rsac.MergeItems()
    rsac.storageitems = rsac.refs.getItems()
    for index,item in pairs(rsac.storageitems) do
        if index == "n" then
            goto continue
        end
        local citem = rsac.convert.ItemToOName(item)
        if rsac.items[citem] ~= nil then
            rsac.items[citem].Count = item.size
            if rsac.firsttime then
                rsac.items[citem].Converted = citem
                rsac.items[citem].Name = citem
                rsac.items[citem].Label = item.label
                rsac.items[citem].Status = ""
            end
        elseif rsac.firsttime then
            print("StorageItem not found in ItemList: " .. citem .. " (" .. item.label .. ")")
        end
        local zindex = 2
        while true do
            local zitem = citem .. "_z" .. zindex
            if rsac.items[zitem] ~= nil then
                rsac.items[zitem].Count = item.size
                if rsac.firsttime then
                    rsac.items[zitem].Converted = citem
                    rsac.items[zitem].Name = zitem
                    rsac.items[zitem].Label = item.label
                    rsac.items[zitem].Status = ""
                end
            else
                break
            end
            zindex = zindex + 1
        end
        ::continue::
    end
    if rsac.firsttime then
        local saved = require("RSItemsSaved")
        for index,item in pairs(rsac.items) do
            if rsac.ValidItem(item) then
                if saved[index] ~= nil then
                    item.State = saved[index].State
                end
                if item.State == nil then
                    item.State = false
                end
                rsac.GetPrio(item, 1)
                table.insert(rsac.validitems, item)
            end
        end
        saved = nil
    end
    rsac.firsttime = false
end

function rsac.GetPrio(item, initPrio)
    if item.Prio == nil then
        if item.DependsOn ~= nil then
            local prio = initPrio
            for depI,dependItem in pairs(item.DependsOn) do
                if rsac.items[dependItem.name] ~= nil then
                    rsac.GetPrio(rsac.items[dependItem.name], 1)
                    if rsac.items[dependItem.name].Prio >= prio then
                        prio = rsac.items[dependItem.name].Prio + 1
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

function rsac.Check(item)
    item.Status = ""
    if item.DependsOn ~= nil then
        for depI,dependItem in pairs(item.DependsOn) do
            if rsac.items[dependItem.name] ~= nil then
                local on = rsac.items[dependItem.name].State == rsac.GetStateSwitch(rsac.items[dependItem.name]).ON
                local depending = rsac.items[dependItem.name].Status == "Depends"
                if on or depending then
                    item.Status = "Depends"
                    return
                end
            end
        end
    end
    local stateSwitch = rsac.GetStateSwitch(item)
    if item.State == stateSwitch.OFF and item.minCount > item.Count then
        rsac.SwitchRS(item, stateSwitch.ON)
    elseif item.State == stateSwitch.ON and item.maxCount < item.Count then
        rsac.SwitchRS(item, stateSwitch.OFF)
    end
end

function rsac.SwitchRS(item, state)
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
    rsac.items[item.Name].State = state
    print("Turned " .. switchString .. ": " .. item.Label .. " (" .. item.Name .. ")")
end

function rsac.GoThruItems()
    rsac.MergeItems()
    for p=1,rsac.prio,1 do
        for index,item in pairs(rsac.validitems) do
            if item.Prio == p then
                rsac.Check(item)
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
    for index,item in pairs(rsac.validitems) do
        temp[item.Name] = {State=item.State}
    end
    rsac.mf.WriteObjectFile(temp,"/home/RSItemsSaved.lua")
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