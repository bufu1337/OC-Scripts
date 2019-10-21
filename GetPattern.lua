mf = require("MainFunctions")
com = require("component")
cv = require("Convert")
prox = require("Proxies")
crafter = "minecraft"
items = require("Crafter/ItemsAll/" .. crafter)
rs = com.proxy(prox.GetProxyByCrafter(crafter))
for i,j in pairs(mf.getSortedKeys(items)) do
	item = c.TextToItem(j)
	ok, pattern = pcall(rs.getPattern, item)
	if ok and pattern != nil then
		mc[j].hasPattern = true
		mc[j].label = pattern.inputs[1].label
		mc[j].recipe = {}
		for i, j in
	else
		mc[j].hasPattern = false
	end
end