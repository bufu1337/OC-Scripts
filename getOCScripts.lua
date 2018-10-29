local filesystem = require("filesystem")
if filesystem.exists("/home/crafting/") == false then
  filesystem.makeDirectory("/home/crafting/")
end
if filesystem.exists("/home/crafting/Items") == false then
  filesystem.makeDirectory("/home/crafting/Items")
end
if filesystem.exists("/home/crafting/Items/max") == false then
  filesystem.makeDirectory("/home/crafting/Items/max")
end
for i,j in pairs(filesystem.findNode("mnt").children.mnt.children) do
  if (j.fs.spaceTotal() == 524288) then
    filesystem.findNode("mnt").children.mnt.children[i].fs.setLabel("BufuScripts")
  end
end
os.execute("mount BufuScripts /bufu")
os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/StartCraft.lua" .. "?" .. math.random() .. " /home/crafting/StartCraft.lua")
os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/MainFunctions.lua" .. "?" .. math.random() .. " /home/MainFunctions.lua")
os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/screenchange.lua" .. "?" .. math.random() .. " /home/screenchange.lua")
os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/.shrc" .. "?" .. math.random() .. " /home/.shrc")
os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/start.lua" .. "?" .. math.random() .. " /start.lua")