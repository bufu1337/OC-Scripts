local oc = {mf=require("MainFunctions"), servers={}, main_server={isMain=false, address=""}, tunnels={}, receivers={}}

for i,j in pairs(oc.mf.filesystem.findNode("mnt").children.mnt.children) do
  if (j.fs.spaceTotal() == 524288 and oc.mf.filesystem.findNode("mnt").children.mnt.children[i].fs.getLabel() == nil) then
    oc.mf.filesystem.findNode("mnt").children.mnt.children[i].fs.setLabel("OCNetDisk")
    break
  end
end
os.execute("mount BufuScripts /home/bufu")
for address, componentType in oc.mf.component.list() do 
  if componentType == "tunnel" then
    table.insert(oc.tunnels, {address=address})
  end
end
oc.modem = oc.mf.component.modem
oc.mf.component.modem.close(478)
oc.mf.component.modem.open(478)
function oc.findMain()
  oc.modem.broadcast(478, oc.mf.serial.serialize({OCNet={toSystem="OCNet", "getMain"}}))
  local _, localAddress, remoteAddress, _, _, data = oc.mf.event.pull(5,"modem_message")
  if remoteAddress == nil then
    print("No main OCNet Server found. Setting this to Main-Server.")
    oc.main_oc = true
  else
  
  end
end
while true do
   local _, localAddress, remoteAddress, _, _, data = oc.mf.event.pull("modem_message")
   oc.mf.thread.create(function(localAddress, remoteAddress, data)
     data = oc.mf.serial.unserialize(data)
     if oc.mf.containsKey(data, "OCNet") then
        if data.OCNet.toSystem == "OCNet" then
          if oc.mf.containsKey(ab,element) and then
          
          else
          
          end
        end
     end
   end, localAddress, remoteAddress, data)
end