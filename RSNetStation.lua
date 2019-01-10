local s = {}
s.mf = require("MainFunctions")
s.gui = require("GUI")
s.saving = false
s.rs = {}
s.m = s.mf.component.modem

local varpath = "/home/RSNetStationVars.lua"

function s.save()
  if s.saving then
    local rstorages = s.mf.copyTable(s.rs.rstorages)
    s.rs.rstorages = nil
    s.mf.WriteObjectFile(s.rs, varpath)
    s.rs.rstorages = s.mf.copyTable(rstorages)
  end
end
function s.addRSMonitors(count)
  for i = 1, count, 1 do
    table.insert(s.rs.monitor,"")
  end
  s.save()
end
function s.removeRSMonitor(num)
  s.rs.monitor[num] = nil
  s.save()
end
function s.setDistributor(dis)
  s.rs.distributor = dis
  s.save()
end

function s.start()
  if s.mf.filesystem.exists(varpath) == false then
    s.mf.WriteObjectFile({distributor="", monitor={}}, varpath)
  end
  s.rs = require("RSNetStationVars")
  if s.rs.distributor == "" then
    print("Please type in the uid of the distributors modem")
    s.setDistributor(s.mf.io.read())
  end
  if #s.rs.monitor == 0 then
    print("How many monitors do you have")
    s.addRSMonitors(s.mf.io.read())
  end
  s.m.close(478)
  s.m.open(478)
  s.saving = true
  s.checkConnection()
end

function s.RSMonitorON(mod, monitor)
  if #s.rs.monitor[monitor] ~= nil then
    s.m.send(s.rs.distributor, 478, s.mf.serial.serialize({method="push", storage=mod, rsmonitor=monitor},true))
    s.rs.monitor[monitor] = mod
    s.save()
  else
    print("Monitor not found. Try the method addRSMonitors(count).")
  end
end
function s.RSMonitorOFF(mod, monitor)
  if #s.rs.monitor[monitor] ~= nil then
    s.m.send(s.rs.distributor, 478, s.mf.serial.serialize({method="pull", storage=mod, rsmonitor=monitor},true))
    s.rs.monitor[monitor] = ""
    s.save()
  else
    print("Monitor not found. Try the method addRSMonitors(count).")
  end
end
function s.registerNetworkCard()
  s.m.send(s.rs.distributor, 478, s.mf.serial.serialize({"register"},true))
end
function s.checkConnection()
  s.m.send(s.rs.distributor, 478, s.mf.serial.serialize({"check"},true))
  local _, localAddress, remoteAddress, port, distance, data = s.mf.event.pull(10, "modem_message")
  if data ~= nil then
    data = s.mf.serial.unserialize(data)
    s.rs.rstorages = s.mf.copyTable(data.rstorages)
    if data.monitor ~= nil then
      s.rs.monitor = s.mf.combineTables(s.rs.monitor, data.monitor)
    end
    s.save()
  else
    print("No connection to distributor")
  end
end
s.start()
return s