local convert = {}
local function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end
function convert.TextToItem(text)
    local result = {name="";damage=0;mod="";tagnum=0}
    text = text:gsub("_jj_", ":")
    text = text:gsub("_xx_", "/")
    text = text:gsub("_qq_", "-")
    text = text:gsub("_vv_", ".")
    text = text:gsub("_b_", "#")
    local temp = split(text, "#")
    local temp2 = split(temp[1], ":")
    result.mod = temp2[1]
    result.name = temp2[1] .. ":" .. temp2[2]
    text = temp[1]
    if temp2[3] ~= nil then
        result.damage = tonumber(temp2[3])
    end
    if temp[2] ~= nil then
        result.tagnum = tonumber(temp[2])
    end
    return result
end
function convert.ItemToText(item)
    return item.name .. ":" .. item.damage
end
function convert.TextToOName(text)
    text = text:gsub(":", "_jj_")
    text = text:gsub("/", "_xx_")
    text = text:gsub("-", "_qq_")
    text = text:gsub("%.", "_vv_")
    return text
end
function convert.ItemToOName(item)
    if item.damage ~= nil and item.damage ~= 0 then
      return TextToOName(item.name) .. "_jj_" .. item.damage
    else
      return TextToOName(item.name)
    end
end
function convert.ItemMod(item)
    if item.mod == nil then
        item = TextToItem(ItemToOName(item))
    end
    return item.mod
end
return convert