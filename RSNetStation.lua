local c = require("component")
local event = require("event")
local io = require("io")
local sides = require("sides")
local os = require("os")
local thread = require("thread")
local serial = require("serialization")
local filesystem = require("filesystem")
local mf = require("MainFunctions")
if filesystem.exists("/home/RSNetSationVars.lua") == false then
  mf.WriteObjectFile({distributer="", monitor={}}, "/home/RSNetSationVars.lua")
end
local rs = require("RSNetSationVars")
local m = c.modem
local station = {}


local function addRSMonitors(count)
  local mcount = #rs.monitor
  for i = (mcount + 1), (count + mcount), 1 do
    rs.monitor[i] = ""
  end
end
local function removeRSMonitor(num)
  rs.monitor[num] = nil
end

if rs.distributer == "" then
  print("Please type in the uid of the distributers modem")
  rs.distributer = io.read()
  print("How many monitors do you have")
  local mc = io.read()
  addRSMonitors(mc)
  mf.WriteObjectFile(rs, "/home/RSNetSationVars.lua")
end

local function RSMonitorON(mod, monitor)
  if #rs.monitor[monitor] ~= nil then
    m.send(rs.distributer, 478, serial.serialize({method="push", storage=mod, rsmonitor=monitor},true))
    rs.monitor[monitor] = mod
    mf.WriteObjectFile(rs, "/home/RSNetSationVars.lua")
  else
    print("Monitor not found. Try the method addRSMonitors(count).")
  end
end
local function RSMonitorOFF(mod, monitor)
  if #rs.monitor[monitor] ~= nil then
    m.send(rs.distributer, 478, serial.serialize({method="pull", storage=mod, rsmonitor=monitor},true))
    rs.monitor[monitor] = ""
    mf.WriteObjectFile(rs, "/home/RSNetSationVars.lua")
  else
    print("Monitor not found. Try the method addRSMonitors(count).")
  end
end
local function registerNetworkCard()
  m.send(rs.distributer, 478, serial.serialize({register=""},true))
end
local function checkConnection()
  m.send(rs.distributer, 478, serial.serialize({check=""},true))
  local _, localAddress, remoteAddress, port, distance, data = event.pull(10, "modem_message")
  if data ~= nil then
    if data ~= "ok" then
      print("Connection to distributer ok")
    end
  else
    print("No connection to distributer")
  end
end

m.close(478)
m.open(478)
station.addRSMonitors = addRSMonitors
station.removeRSMonitor = removeRSMonitor
station.RSMonitorON = RSMonitorON
station.RSMonitorOFF = RSMonitorOFF
station.registerNetworkCard = registerNetworkCard
station.checkConnection = checkConnection
return station