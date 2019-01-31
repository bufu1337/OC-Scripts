local shell = require("shell")
local function CheckPattern(param)
    local filesystem = require("filesystem")
    local os = require("os")
    os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/Crafter/ItemsNew/" .. param .. ".lua" .. "?" .. math.random() .. " /home/" .. param .. ".lua")
    local items = require(param)
    local prox = require("Proxies")
    local convert = require("Convert")
    local mf = require("MainFunctions")
    local c = require("component")
    local rs = c.proxy(prox.GetProxyByName(param, "craft"))
    local newItems = {}
    for i,j in pairs(items) do
        newItems[i] = rs.hasPattern(convert.TextToItem(i))
        print(i .. " = " .. tostring(newItems[i]))
    end
    mf.WriteObjectFile(newItems, "/home/" .. param .. "_check.lua")
    filesystem.remove("/home/" .. param .. ".lua")
end
local args = shell.parse( ... )
if args[1] ~= nil and args[1]:find("hasPatternCheck") == nil then
    CheckPattern(args[1])
end