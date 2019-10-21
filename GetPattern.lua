local gp = {}
gp.mf = require("MainFunctions")
gp.filesystem = require("filesystem")
gp.com = require("component")
gp.cv = require("Convert")
gp.prox = require("Proxies")
gp.items = {}
if gp.filesystem.exists("/home/Crafter/ItemsNew") == false then 
    gp.filesystem.makeDirectory("/home/Crafter/ItemsNew")
end
function gp.GetPattern(crafter, newrecipes)
    print("Getting Patterns: " .. crafter)
    gp.items = require("Crafter/ItemsAll/" .. crafter)
    rs = gp.com.proxy(gp.prox.GetProxyByCrafter(crafter))
    for i,j in pairs(gp.mf.getSortedKeys(gp.items)) do
        if string.match(j, "_b_") == nil then
            start1 = gp.mf.getCount(gp.mf.getKeys(gp.items[j].recipe)) == 0 and newrecipes == false
            if newrecipes or start1 then
                item = gp.cv.TextToItem(j)
                ok, pattern = pcall(rs.getPattern, item)
                gp.items[j].recipe = {}
                if ok and pattern ~= nil then
                    gp.items[j].hasPattern = true
                    gp.items[j].label = pattern.outputs[1][1].label
                    gp.items[j].craftCount = pattern.outputs[1][1].size
                    gp.items[j].oredict = pattern.oredict
                    gp.items[j].processing = pattern.processing
                    for g, h in pairs(pattern.inputs) do
                        if h.n ~= 0 then
                            craftitem = gp.cv.ItemToOName(h[1])
                            if gp.items[j].recipe[craftitem] == nil then
                                gp.items[j].recipe[craftitem] = {need=1,tag=""}
                            else
                                gp.items[j].recipe[craftitem].need += 1
                            end
                        end
                    end
                else
                    gp.items[j].hasPattern = false
                end
            end
        else
            gp.items[j].hasPattern = false
        end
    end
    gp.mf.WriteObjectFile(rs_item, "/home/Crafter/ItemsNew/" .. crafter .. ".lua", nil, true)
end
return gp