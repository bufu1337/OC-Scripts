local oc = {mf=require("MainFunctions"), servers={}, main_server={isMain=false, address="", name=""}, tunnels={}, receivers={}}
if oc.mf.filesystem.exists("/home/OCNetConfig.lua") then  
  oc = oc.mf.combineTables(oc, require("OCNetConfig"))
end
for address, componentType in oc.mf.component.list() do 
  if componentType == "tunnel" then
    table.insert(oc.tunnels, address)
  end
end
oc.modem = oc.mf.component.modem

function oc.setOC(toServer)
  local message = oc.mf.serial.serialize({OCNet={toSystem="OCNet", setOC={servers=oc.servers, receivers=oc.receivers}}})
  for i,j in pairs(oc.servers) do
    if j.address ~= oc.modem.address then
      oc.modem.send(j.address, 478, message)
    end
  end
  if oc.main_server.isMain == false then
    oc.modem.send(oc.main_server.address, 478, message)  
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
    local mainDefined, mainServerAddress, mainServerName = oc.mf.SetComputerName("OCNet", "server")
    if mainDefined == false then
      print("No main OCNet Server found. Setting this to Main-Server.")
      oc.main_server.isMain = true
    else
      oc.main_server.address = mainServerAddress
      oc.main_server.name = mainServerName
    end
    oc.save()
  end
end
function oc.getNames(system, typ, from)
  
end
function oc.Received(localAddress, remoteAddress, data)
    data = oc.mf.serial.unserialize(data)
    if oc.mf.containsKey(data, "OCNet") then
        if data.OCNet.toSystem == "OCNet" then
            if oc.mf.containsKey(data.OCNet, "register") then
                if oc.mf.containsKeys(data.OCNet.register, {"system", "name", "typ"}) then
                    if oc.main_server.isMain and data.OCNet.register.system == "OCNet" then
                      oc.servers[data.OCNet.register.name] = remoteAddress
                      oc.save()
                      oc.setOC()
                    elseif data.OCNet.register.system ~= "OCNet" then
                      if oc.mf.containsKey(oc.receivers, data.OCNet.register.system) == false then
                        oc.receivers[data.OCNet.register.system] = {}
                      end
                      local overTunnel = oc.mf.contains(oc.tunnels, localAddress)
                      oc.receivers[data.OCNet.register.system][data.OCNet.register.name] = {address = remoteAddress, overTunnel = overTunnel, typ=data.OCNet.register.typ}
                      if overTunnel then
                          oc.receivers[data.OCNet.register.system][data.OCNet.register.name].tunnel = {address=localAddress, cn=oc.mf.ComputerName["OCNet"]}
                      end
                      oc.save()
                      oc.setOC()
                    end
                end
            elseif oc.mf.contains(data.OCNet, "getOC") and oc.main_server.isMain then
              oc.setOC(remoteAddress)
            elseif oc.mf.containsKey(data.OCNet, "setOC") then
              oc.servers = oc.copyTable(data.OCNet.setOC.servers)
              oc.receivers = oc.copyTable(data.OCNet.setOC.receivers)
              oc.save()
            elseif oc.mf.containsKey(data.OCNet, "getNames") then
                if oc.mf.containsKeys(data.OCNet.getNames, {"system", "typ", "from"}) then
                    oc.getNames(data.OCNet.getNames.system, data.OCNet.getNames.typ, remoteAddress)
                end
            end
        end
    end
end

oc.findMain()
oc.getOC()

while true do
   local _, localAddress, remoteAddress, _, _, data = oc.mf.event.pull("modem_message")
   oc.mf.thread.create(oc.Received(localAddress, remoteAddress, data), localAddress, remoteAddress, data)
end