local convert = {}
local function TextToItem(text)
    local result = {name="";damage=0;mod=""}
    local counter = 0
	text = text:gsub("_jj_", ":")
	text = text:gsub("_xx_", "/")
	text = text:gsub("_qq_", "-")
    text = text:gsub("_vv_", ".")
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
    if result.damage == nil then
        result.damage = 0.0
    end
    return result
end
local function ItemToText(item)
    return item.name .. ":" .. item.damage
end
local function TextToOName(text)
	text = text:gsub(":", "_jj_")
	text = text:gsub("/", "_xx_")
	text = text:gsub("-", "_qq_")
	text = text:gsub("\.", "_vv_")
    return text
end
local function ItemToOName(item)
    if item.damage ~= nil and item.damage ~= 0 then
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