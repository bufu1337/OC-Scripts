local rsac = {}
rsac.convert = require("Convert")
rsac.prox = require("RSProxies")
rsac.mf = require("MainFunctions")
rsac.refs = rsac.mf.component.block_refinedstorage_cable
rsac.items = require("RSItems")
rsac.storageitems = {}


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
            rsac.items[citem].Label = item.label
            rsac.items[citem].Status = ""
        else
            print("StorageItem not found in ItemList: " .. citem .. " (" .. item.label .. ")")
        end
        ::continue::
    end
    for index,item in pairs(rsac.items) do
        rsac.items[index].Converted = index
        if item.State == nil then
            item.State = false
        end
        rsac.GetPrio(item, 1)
    end
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

function rsac.Check(item)
    item.Status = ""
    if rsac.ValidItem(item) == false then
        item.Status = "Not Valid"
        return
    end
    if item.DependsOn ~= nil then
        for depI,dependItem in pairs(item.DependsOn) do
            if rsac.items[dependItem.name] ~= nil then
                if rsac.items[dependItem.name].Status == "Low" or rsac.items[dependItem.name].Status == "Depends" then
                    item.Status = "Depends"
                    return
                end
            end
        end
    end
    local stateq = {false, true}
    if item.Reversed ~= nil then
        stateq = {true, false}
    end
    if item.State == stateq[1] and item.minCount > item.Count then
        rsac.SwitchRS(item, stateq[2])
        item.Status = "Low"
    elseif item.State == stateq[2] and item.maxCount < item.Count then
        rsac.SwitchRS(item, stateq[1])
        item.Status = "Ok"
    else
        item.Status = "Ok"
    end
end

function rsac.SwitchRS(item, state)
    if item.State ~= nil and item.State == state then
        return
    end
    local strength = 0
    if (state == false and item.RSreversed ~= nil) or (state and item.RSreversed == nil) then
        strength = 15
    end
    local proxy = rsac.mf.component.proxy(rsac.prox[item.RSChannel[1]][item.RSChannel[2]])
    local b = proxy.setOutput(rsac.mf.sides[item.RSChannel[3]], strength)
    rsac.items[item.Converted].State = state
    if state then
        print("Turned ON: " .. item.Label .. " (" .. item.Converted .. ")")
    else
        print("Turned OFF: " .. item.Label .. " (" .. item.Converted .. ")")
    end
end

function GoThruItems()
    rsac.MergeItems()
    for index,item in pairs(rsac.items) do
        rsac.Check(item)
    end
end

return rsac