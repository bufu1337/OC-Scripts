local items = require("mcall")
local mf = require("MainFunctions")
for i,j in pairs(items) do
  items[i]["newsize"] = j.size
end
local function SetCrafts(item)
    if(item ~= nil)then
        if items[item].recipe ~= nil then
            print("")
            print(item)
            items[item].crafts = mf.MathUp((items[item].maxCount - items[item].size) / items[item].craftCount) * items[item].craftCount
            print("Crafts init = " .. items[item].crafts)
            for a,b in pairs(items[item].recipe) do
                print("Recipe Item: OName: " .. b.oname .. " Realname: items[b.oname].name")
                print("Recipe Item size: " .. items[b.oname].newsize)
                print("Recipe Item need: " .. b.need)
                local tempcrafts = math.floor(items[b.oname].newsize / b.need)
                if tempcrafts < items[item].crafts then
                    items[item].crafts = tempcrafts
                end
            end
            for a,b in pairs(items[item].recipe) do
                items[item].recipe[a].size = items[item].crafts * b.need
                items[b.oname].newsize = items[b.oname].newsize - items[item].recipe[a].size
            end
            print(item .. ": SetCraft = " .. items[item].crafts)
            print("")
        end
    end
end
local function CalculateCrafts()
    print("CalculateCrafts")
    for i,j in pairs(items) do
        SetCrafts(i)
    end
end
--SetCrafts("minecraftjjspruce_boat")
CalculateCrafts()
--local item = "minecraftjjstick"
--SetCrafts(item)
--mf.printx(items[item])
--print("")
--mf.printx(items["minecraftjjplanks"])