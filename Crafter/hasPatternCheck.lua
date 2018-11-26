local shell = require("shell")
local function CheckPattern(param)
    local items = require("home/crafting/Items/" .. param)
    local prox = require("home/crafting/Proxies")
    local convert = require("home/crafting/Convert")
    local c = require("component")
    local rs = c.proxy(prox.GetProxyByName(param, "craft"))
    local checkFile = io.open("home/crafting/Items/" .. param .. "_check.lua", "w")
    for i,j in pairs(items) do
        local h = tostring(rs.hasPattern(convert.TextToItem(i)))
        print(i .. " = " .. h)
        checkFile:write(i .. " = " .. h .. "\n")
    end
    checkFile:close()
end
local args = shell.parse( ... )
if args[1] ~= nil and args[1]:find("hasPatternCheck") == nil then
    CheckPattern(args[1])
end