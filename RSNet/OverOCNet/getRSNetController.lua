local os = require("os")
local filesystem = require("filesystem")
if filesystem.exists("/home/RSNet") == false then
  filesystem.makeDirectory("/home/RSNet")
end
os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/MainFunctions.lua" .. "?" .. math.random() .. " /home/MainFunctions.lua")
os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/serialization.lua" .. "?" .. math.random() .. " /lib/serialization.lua")
os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/RSNet/RSNetStation.lua" .. "?" .. math.random() .. " /home/RSNet/RSNetStation.lua")
os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/RSNet/SStart/.shrc" .. "?" .. math.random() .. " /home/.shrc")
os.execute("pastebin run ryhyXUKZ")
os.execute("reboot")