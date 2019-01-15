local os = require("os")
local filesystem = require("filesystem")
if filesystem.exists("/home/Builder") == false then
  filesystem.makeDirectory("/home/Builder")
end
if filesystem.exists("/home/Builder/Models") == false then
  filesystem.makeDirectory("/home/Builder/Models")
end
os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/MainFunctions.lua" .. "?" .. math.random() .. " /home/MainFunctions.lua")
os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/serialization.lua" .. "?" .. math.random() .. " /lib/serialization.lua")
os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/Builder/builder.lua" .. "?" .. math.random() .. " /home/Builder/builder.lua")
os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/Builder/model.lua" .. "?" .. math.random() .. " /home/Builder/model.lua")
--os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/RSNet/.shrc" .. "?" .. math.random() .. " /home/.shrc")
os.execute("pastebin run ryhyXUKZ")
os.execute("reboot")