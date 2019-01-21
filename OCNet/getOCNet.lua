local filesystem = require("filesystem")
local os = require("os")
local disc_inserted = false
for i,j in pairs(filesystem.findNode("mnt").children.mnt.children) do
  if (j.fs.spaceTotal() == 524288 and filesystem.findNode("mnt").children.mnt.children[i].fs.getLabel() == "OCNetInstall") then
    disc_inserted = true
    break
  end
end
if disc_inserted == false then
  for i,j in pairs(filesystem.findNode("mnt").children.mnt.children) do
    if (j.fs.spaceTotal() == 524288 and filesystem.findNode("mnt").children.mnt.children[i].fs.getLabel() == nil) then
      filesystem.findNode("mnt").children.mnt.children[i].fs.setLabel("OCNetInstall")
      disc_inserted = true
      break
    end
  end
end
if disc_inserted then
  os.execute("mount OCNetInstall /home/OCNetSetup")
  os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/MainFunctions.lua" .. "?" .. math.random() .. " /home/OCNetSetup/MainFunctions.lua")
  os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/serialization.lua" .. "?" .. math.random() .. " /home/OCNetSetup/serialization.lua")
  os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/OCNet/OCNet.lua" .. "?" .. math.random() .. " /home/OCNetSetup/OCNet.lua")
  os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/OCNet/getOCNet.lua" .. "?" .. math.random() .. " /home/OCNetSetup/getOCNet.lua")
  os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/OCNet/startOCNet.lua" .. "?" .. math.random() .. " /home/OCNetSetup/startOCNet.lua")
  os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/OCNet/copyOCNet.lua" .. "?" .. math.random() .. " /home/OCNetSetup/copyOCNet.lua")
  os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/OCNet/.shrc" .. "?" .. math.random() .. " /home/OCNetSetup/.shrc")
else
  print("Please insert an empty Disc into Disk Drive.")
end