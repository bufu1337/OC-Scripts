local shell = require("shell")
local function CheckPattern(param)
    local filesystem = require("filesystem")
    local os = require("os")
    os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/Crafter/ItemsNew/" .. param .. ".lua" .. "?" .. math.random() .. " /home/bufu/GetCrafter.lua")
    local items = require("home/" .. param)
    local prox = require("home/Proxies")
    local convert = require("home/Convert")
    local mf = require("home/MainFunctions")
    local c = require("component")
    local rs = c.proxy(prox.GetProxyByName(param, "craft"))
    local newItems = {}
    for i,j in pairs(items) do
        newItems[i] = rs.hasPattern(convert.TextToItem(i))
    end
    filesystem.remove("/home/" .. param .. ".lua")
end
local args = shell.parse( ... )
if args[1] ~= nil and args[1]:find("hasPatternCheck") == nil then
    CheckPattern(args[1])
end