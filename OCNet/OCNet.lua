local oc = {mf=require("MainFunctions"), tunnels={}, receivers={}}

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

while true do
   local _, localAddress, remoteAddress, _, _, data = oc.mf.event.pull("modem_message")
   oc.mf.thread.create(function(localAddress, remoteAddress, data)
     
   end, localAddress, remoteAddress, data)
end