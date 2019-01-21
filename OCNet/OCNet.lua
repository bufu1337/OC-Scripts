local oc = {mf=require("MainFunctions"), servers={}, main_server={isMain=false}, receivers={}}
if oc.mf.filesystem.exists("/home/OCNetConfig.lua") then  
  oc = oc.mf.combineTables(oc, require("OCNetConfig"))
end
oc.mf.system = "OCNet"
oc.modem = oc.mf.component.modem

function oc.setOC(toServer)
  local message = oc.mf.serial.serialize({setOC={servers=oc.servers, receivers=oc.receivers}, OCNet={toSystem="OCNet", to="", from=oc.mf.ComputerName.OCNet.name}})
  if toServer ~= nil then
    oc.modem.send(toServer, 478, message)
  else
    for i,j in pairs(oc.servers) do
      if j.address ~= oc.modem.address then
        oc.modem.send(j.address, 478, message)
      end
    end
    if oc.main_server.isMain == false then
      oc.modem.send(oc.main_server.address, 478, message)  
    end
  end
end
function oc.getOC()
  oc.modem.send(oc.main_server.address, 478, oc.mf.serial.serialize({OCNet={toSystem="OCNet", "getOC"}}))
end
function oc.save()
  oc.mf.WriteObjectFile({servers=oc.servers, main_server=oc.main_server, receivers=oc.receivers}, "/home/OCNetConfig.lua")
end
function oc.findMain()
  if oc.main_server.isMain == false and oc.main_server.address == "" and oc.main_server.name == "" then
    local mainDefined = oc.mf.SetComputerName("OCNetServer")
    if mainDefined == false then
      print("No main OCNet Server found. Setting this to Main-Server.")
      oc.main_server.isMain = true
      oc.mf.OCNet.main_server.address = oc.modem.address
      oc.mf.OCNet.main_server.name = oc.mf.Computername.OCNet.name
      oc.mf.WriteObjectFile(oc.mf.OCNet.main_server, "/home/OCNetServer.lua")
    end
    oc.save()
  end
end
function oc.getNames(system, typ)
  local returning = {}
  if oc.receivers[system] ~= nil then
    if type(typ) == "string" then
      local t = {}
      table.insert(t,typ)
      typ = oc.mf.copyTable(t)
    end
    for a,b in pairs(typ) do
      returning[typ] = {}
      for i,j in pairs(oc.receivers[system]) do
        if j.typ == b then
          table.insert(returning[typ], i)
        end
      end
    end
  end
  return returning
end
function oc.SendBack(data, oc_data)
  if oc_data.tunnel then
    oc.mf.SendOverOCNet(oc_data.from, data, nil, nil, oc_data.loc)
  else
    oc.mf.SendOverOCNet(oc_data.from, data, oc_data.remote)
  end
end
function oc.Received(data, oc_data)
  if oc_data.toSystem == "OCNet" then
    if oc.mf.containsKey(data, "registerComputer") then
      if oc.mf.containsKeys(data.registerComputer, {"system", "name", "typ"}) then
        if oc.main_server.isMain and data.registerComputer.system == "OCNet" then
          oc.servers[data.registerComputer.name] = oc_data.remote
          oc.SendBack({oc.mf.ComputerName.OCnet.name}, oc_data)
          oc.save()
          oc.setOC()
        elseif data.registerComputer.system ~= "OCNet" then
          if oc.mf.containsKey(oc.receivers, data.registerComputer.system) == false then
            oc.receivers[data.registerComputer.system] = {}
          end
          oc.receivers[data.registerComputer.system][data.registerComputer.name] = {address = oc_data.remote, overTunnel = oc_data.tunnel, tunnel = {address = oc_data.loc, cn = oc.mf.ComputerName.OCNet}, typ = data.registerComputer.typ}
          oc.SendBack({oc.mf.OCNet.main_server.name}, oc_data)
          oc.save()
          oc.setOC()
        end
      end
    elseif oc.mf.contains(data, "getOC") and oc.main_server.isMain then
      oc.setOC(oc_data.remote)
    elseif oc.mf.containsKey(data, "setOC") then
      oc.servers = oc.copyTable(data.setOC.servers)
      oc.receivers = oc.copyTable(data.setOC.receivers)
      oc.save()
    elseif oc.mf.containsKey(data, "getNames") then
      if oc.mf.containsKeys(data.getNames, {"system", "typ"}) then
        oc.SendBack(oc.getNames(data.getNames.system, data.getNames.typ), oc_data)
      end
    end
  else
    data.OCNet = oc.mf.copyTable(oc_data, {"toSystem", "to", "from"})
    if oc.receivers[oc_data.toSystem][oc_data.to] ~= nil then
      local forward = oc.mf.serial.serialize(data)
      if oc.receivers[oc_data.toSystem][oc_data.to].overTunnel then
        oc.mf.component.proxy(oc.receivers[oc_data.toSystem][oc_data.to].tunnel.address).send(forward)
      else
        oc.modem.send(oc.receivers[oc_data.toSystem][oc_data.to].address, 478, forward)
      end
    else
      oc.SendBack({"Computer_not_found"}, oc_data)
    end
  end
end

oc.findMain()
oc.getOC()

while true do
  local data, oc_data = oc.mf.ReceiveFromOCNet()
  oc.mf.thread.create(oc.Received(data, oc_data), data, oc_data)
end