local filesystem = require("filesystem")
for i,j in pairs(filesystem.findNode("mnt").children.mnt.children) do
  if (j.fs.spaceTotal() == 524288 and filesystem.findNode("mnt").children.mnt.children[i].fs.getLabel() == nil) then
    filesystem.findNode("mnt").children.mnt.children[i].fs.setLabel("BufuScripts")
    break
  end
end
os.execute("mount BufuScripts /home/bufu")
if filesystem.exists("/home/bufu/Crafter/") == false then
  filesystem.makeDirectory("/home/bufu/Crafter/")
end
if filesystem.exists("/home/bufu/Crafter/Items") == false then
  filesystem.makeDirectory("/home/bufu/Crafter/Items")
end
if filesystem.exists("/home/bufu/Crafter/Items/max") == false then
  filesystem.makeDirectory("/home/bufu/Crafter/Items/max")
end
os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/GetCrafter.lua" .. "?" .. math.random() .. " /home/bufu/GetCrafter.lua")
os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/MainFunctions.lua" .. "?" .. math.random() .. " /home/bufu/MainFunctions.lua")
os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/screenchange.lua" .. "?" .. math.random() .. " /home/bufu/screenchange.lua")
os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/.shrc" .. "?" .. math.random() .. " /home/bufu/.shrc")
os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/start.lua" .. "?" .. math.random() .. " /home/bufu/start.lua")