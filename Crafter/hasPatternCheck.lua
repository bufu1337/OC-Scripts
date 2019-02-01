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
    
    local itemcounter = 0
    local co = 1
    local iarr = {}
    local th = {}
    for i,j in pairs(items) do
        itemcounter = itemcounter + 1
        if (itemcounter > 50) then
          itemcounter = 1
          co = co + 1
        end
        if iarr[co] == nil then
            iarr[co] = {}
        end
        iarr[co][itemcounter] = i
    end
    local ttable = {}
    for v = 1, co, 1 do
      th[v] = mf.thread.create(function(o, u)
        for v = 1, u, 1 do
          mf.os.sleep(v)
        end
        for i,j in pairs(o) do 
            newItems[i] = rs.hasPattern(convert.TextToItem(i))
        end
      end, iarr[v], v)
      table.insert(ttable, th[v])
    end
    mf.thread.waitForAll(ttable)

    --[[for i,j in pairs(items) do 
        print(i)
        newItems[i] = rs.hasPattern(convert.TextToItem(i))
        print(i .. " = " .. tostring(newItems[i]))
    end]]
    mf.WriteObjectFile(newItems, "/home/" .. param .. "_check.lua")
    filesystem.remove("/home/" .. param .. ".lua")
end
local args = shell.parse( ... )
if args[1] ~= nil and args[1]:find("hasPatternCheck") == nil then
    CheckPattern(args[1])
end