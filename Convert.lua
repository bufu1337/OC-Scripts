local convert = {}

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

convert.TextToItem = TextToItem
convert.ItemToText = ItemToText
convert.ItemToOName = ItemToOName
convert.TextToOName = TextToOName
return convert