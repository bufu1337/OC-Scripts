local gp = {}
gp.mf = require("MainFunctions")
gp.filesystem = require("filesystem")
gp.com = require("component")
gp.cv = require("Convert")
gp.prox = require("Proxies")
gp.items = {}
function gp.GetCrafterLoc(crafter)
    local cl = {
        a9f = {
            "actadd",
            "aether",
            "appen",
            "atl",
            "biomes",
            "ceramics",
            "cyclic",
            "fairy",
            "fiifex",
            "immersive",
            "mekanism",
            "minewatch",
            "more",
            "mystical",
            "nuclear",
            "plants",
            "railroading",
            "rocketry",
            "storage",
            "terra",
            "treborn",
            "utilities"
        },
        x58e = {
            "deco",
            "draconic",
            "flat",
            "minecraft",
            "pillar"
        },
        f3d = {
            "biblio",
            "botania",
            "btrees",
            "chimneys",
            "environ",
            "food",
            "industrial",
            "metals",
            "modern",
            "reliq",
            "rftools",
            "thermal"
        },
        caa = {
            "binnie",
            "conquest",
            "others"
        }
    }
    loc = ""
    for i, j in pairs(cl) do
        if gp.mf.contains(j, crafter) then
            loc = string.gsub(i, "x", "")
            break
        end
    end
    return loc
end
function gp.GetPattern(crafter, newrecipes)
    print("Getting Patterns: " .. crafter)
    local craftloc = gp.GetCrafterLoc(crafter)
    if craftloc ~= "" then
        gp.items = require("/mnt/" .. craftloc .. "/home/Crafter/ItemsAll/" .. crafter)
        local rs = gp.com.proxy(gp.prox.GetProxyByCrafter(crafter))
        for i,j in pairs(gp.mf.getSortedKeys(gp.items)) do
            if string.match(j, "_b_") == nil then
                local start1 = gp.mf.getCount(gp.mf.getKeys(gp.items[j].recipe)) == 0 and newrecipes == false
                if newrecipes or start1 then
                    print("Check Item: " .. j)
                    local item = gp.cv.TextToItem(j)
                    local ok, pattern = pcall(rs.getPattern, item)
                    gp.items[j].recipe = {}
                    if ok and pattern ~= nil then
                        gp.items[j].hasPattern = true
                        gp.items[j].label = pattern.outputs[1].label
                        gp.items[j].craftCount = pattern.outputs[1].size
                        gp.items[j].aspects = pattern.outputs[1].aspects
                        gp.items[j].oredict = pattern.oredict
                        gp.items[j].processing = pattern.processing
                        for g, h in pairs(pattern.inputs) do
                            if g ~= "n" then
                                if h.n ~= 0 then
                                    craftitem = gp.cv.ItemToOName(h[1])
                                    if gp.items[j].recipe[craftitem] == nil then
                                        gp.items[j].recipe[craftitem] = {need=h[1].size,tag=""}
                                    else
                                        gp.items[j].recipe[craftitem].need = gp.items[j].recipe[craftitem].need + h[1].size
                                    end
                                end
                            end
                        end
                    else
                        print("No Pattern: " .. j)
                        gp.items[j].hasPattern = false
                    end
                end
            else
                gp.items[j].hasPattern = false
            end
        end
        gp.mf.WriteObjectFile(rs_item, "/mnt/" .. craftloc .. "/home/Crafter/ItemsAll/" .. crafter .. ".lua", nil, true)
    else
        print("Cant find Location: " .. crafter)
    end
end
return gp