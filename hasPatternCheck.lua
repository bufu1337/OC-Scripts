local function CheckPattern(param)
    local items = require("home/crafting/Items/" .. param)
    local prox = require("home/crafting/Proxies")
    local convert = require("home/crafting/Convert")
    local c = require("component")
    local rs = c.proxy(prox.GetProxyByName(param, "craft"))
    local checkFile = io.open("home/crafting/Items/" .. param .. "_check.lua", "w")
    for i,j in pairs(items) do
        checkFile:write(i .. " = " .. tostring(rs.hasPattern(convert.TextToItem(i))) .. "\n")
    end
    checkFile:close()
end
local args = shell.parse( ... )
if args[1] ~= nil and args[1]:find("hasPatternCheck") == nil then
    Start(args[1])
end