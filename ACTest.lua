local ac = require("crafting/Autocraft")
ac.Define("minecraft")
ac.ConvertItems()
ac.GetStorageItems()
ac.GetRecipes()
local items = ac.items()
local serial = require("serialization")
local mf = require("MainFunctions")
local newRepoFile = io.open("crafting/Items/" ..  .. "mcall.lua", "w")
local ikeys = mf.getSortedKeys(items)
local itemsep = ","
newRepoFile:write("return {\n")
for ik = 1, #ikeys, 1 do
	if ik == #ikeys then itemsep = "" end
	local tempsize = items[ikeys[ik]].size
	newRepoFile:write("    " .. ikeys[ik].. "=" .. serial.serialize(items[ikeys[ik]]) .. itemsep .. "\n")
end
newRepoFile:write("}")
newRepoFile:close()