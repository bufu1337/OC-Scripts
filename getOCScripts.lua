if filesystem.exists("/home/crafting/") == false then
  filesystem.makeDirectory("/home/crafting/")
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
os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/autorun.lua" .. "?" .. math.random() .. " /autorun.lua")