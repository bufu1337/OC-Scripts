local shell = require("shell")
local prox = require("Proxies")
local convert = require("Convert")
local mf = require("MainFunctions")
local hpc = {}
function hpc.CheckPattern(param)
    mf.os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/Crafter/ItemsNew/" .. param .. ".lua" .. "?" .. math.random() .. " /home/" .. param .. ".lua")
    local items = require(param)
    local rs = mf.component.proxy(prox.GetProxyByName(param, "craft"))
    local newItems = {}
    for i,j in pairs(items) do 
        print(i)
        newItems[i] = rs.hasPattern(convert.TextToItem(i))
        print(i .. " = " .. tostring(newItems[i]))
    end
    mf.WriteObjectFile(newItems, "/home/patternCheck/" .. param .. "_check.lua")
    mf.filesystem.remove("/home/" .. param .. ".lua")
end
local args = shell.parse( ... )
if args[1] ~= nil and args[1]:find("hasPatternCheck") == nil then
    CheckPattern(args[1])
end
return hpc