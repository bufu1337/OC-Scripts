local rsac = {}
rsac.convert = require("Convert")
rsac.prox = require("RSProxies")
rsac.mf = require("MainFunctions")
rsac.refs = rsac.mf.component.block_refinedstorage_cable
rsac.items = require("RSItems")
rsac.storageitems = rsac.refs.getItems()

for index,item in pairs(rsac.items) do
    rsac.items[index].Converted = index
    if item.State ~= nil then
        item.State = false
    end
end
-- for index,item in pairs(rsac.storageitems) do
    -- rsac.items[rsac.convert.ItemToOName(item)] = {minCount=0, maxCount=0, RSchannel={}}
-- end

-- rsac.mf.WriteObjectFile(rsac.items, "/home/RSItems.lua")

function rsac.MergeItems()
    for index,item in pairs(rsac.storageitems) do
        local citem = rsac.convert.ItemToOName(item)
        if rsac.items[citem] ~= nil then
            rsac.items[citem].Count = item.size
            rsac.items[citem].Label = item.label
        else
            print("StorageItem not found in ItemList: " .. citem .. " (" .. item.label .. ")")
        end
    end
end

function rsac.ValidItem(item)
    local ok = true
    for i,j in pairs({"minCount", "maxCount", "Count", "RSchannel", "Label"}) do
        if item[j] == nil then
            ok = false
        end
    end
    if rsac.mf.getCount(item.RSchannel) ~= 3 then
        ok = false
    elseif rsac.prox[item.rschannel[1]] == nil then
        ok = false
    elseif rsac.prox[item.rschannel[1]][item.rschannel[2]] == nil then
        ok = false
    elseif rsac.mf.sides[item.rschannel[3]] == nil then
        ok = false
    end
    return ok
end

function rsac.Check(item)
    if rsac.ValidItem(item) == false then
        return
    end
    local stateq = {false, true}
    if item.Reversed ~= nil then
        stateq = {true, false}
    end
    if item.State == stateq[1] and item.minCount > item.Count then
        rsac.SwitchRS(item, stateq[2])
    elseif item.State == stateq[2] and item.maxCount < item.Count then
        rsac.SwitchRS(item, stateq[1])
    end
end

function rsac.SwitchRS(item, state)
    if item.State ~= nil and item.State == state then
        return
    end
    local strength = 0
    if item.RSreversed ~= nil then
        strength = 0
    end
    local proxy = rsac.mf.component.proxy(rsac.prox[item.rschannel[1]][item.rschannel[2]])
    local b = proxy.setOutput(rsac.mf.sides[item.rschannel[3]], strength)
    rsac.items[item.Converted].State = state
    if state then
        print("Turned ON: " .. citem .. " (" .. item.label .. ")")
    else
        print("Turned OFF: " .. citem .. " (" .. item.label .. ")")
    end
end

return rsac