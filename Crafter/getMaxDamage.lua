local convert = require("bufu/Convert")
local filesystem = require("filesystem")
local hs = {}
local function hasDamage(item)
  local item_c = convert.TextToItem(item)
  local m = require("bufu2/Crafter/Items/max/" .. item_c.mod)
  if m[item] ~= nil then
    return true
  else
    return false
  end
end
local function getMax(item)
  local item_c = convert.TextToItem(item)
  if filesystem.exists("/home/bufu2/Crafter/Items/max/" .. item_c.mod .. ".lua") then
	  local m = require("bufu2/Crafter/Items/max/" .. item_c.mod)
	  if m[item] ~= nil then
		return m[item]
	  else
		return 0
	  end
  else
	return 0
  end
end
hs.hasDamage = hasDamage
hs.getMax = getMax
return hs