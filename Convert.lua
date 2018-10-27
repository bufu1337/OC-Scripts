local convert = {}
local function TextToItem(text)
    local result = {name="";damage=0;mod=""}
    local counter = 0
  if(text:find("jj") ~= nil) then
    text = text:gsub("jj", ":")
  end
    for w in (text .. ":"):gmatch("([^:]*):") do 
        if(counter == 0)then
            result.name = w
            result.mod = w 
        end
        if(counter == 1)then
            result.name = result.name .. ":" .. w
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
local function TextToOName(text)
    return text:gsub(":", "jj")
end
local function ItemToOName(item)
    if(item.damage ~= 0) then
      return TextToOName(item.name) .. "jj" .. item.damage
    else
      return TextToOName(item.name)
    end
end
local function ItemMod(item)
    if item.mod == nil then
        item = TextToItem(ItemToOName(item))
    end
    return item.mod
end
convert.TextToItem = TextToItem
convert.ItemToText = ItemToText
convert.ItemToOName = ItemToOName
convert.TextToOName = TextToOName
convert.ItemMod = ItemMod
return convert