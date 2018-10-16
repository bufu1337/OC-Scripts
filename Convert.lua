local C = {}

local function TextToItem(text)
    local result = {name="";damage=0;mod=""}
    local counter = 0
	local search = {"jj", "([^jj]*)jj"}
	if(text:find(":") ~= nil) then
		search = {":", "([^:]*):"}
	end
    for w in (text .. search[1]):gmatch(search[2]) do 
        if(counter == 0)then
            result.name = w
            result.mod = w 
        end
        if(counter == 1)then
            result.name = result.name .. search[1] .. w
        end
        if(counter == 2)then
            result.damage = tonumber(w)
        end
        counter = counter +1
    end
    return result
end
local function ItemToText(item)
    return item.name .. ":" .. item.damage
end
local function ItemToOName(item)
    return item.name .. "jj" .. item.damage
end
local function TextToOName(text)
    return text:gsub(":", "jj")
end

local items = {{item="minecraft:stone:1"; maxCount=256; recipes={"minecraft:cobblestone:2", "minecraft:cobblestone:2", nil, "minecraft:cobblestone:2", "minecraft:cobblestone:2", nil, nil, nil, nil}},
            {item="minecraft:stone:2"; maxCount=256; recipes={"minecraft:cobblestone:3", "minecraft:cobblestone:3", nil, "minecraft:cobblestone:3", "minecraft:cobblestone:3", nil, nil, nil, nil}}}


table.remove(items, 1)
C.TextToItem = TextToItem
C.ItemToText = ItemToText
C.ItemToOName = ItemToOName
C.TextToOName = TextToOName
return C