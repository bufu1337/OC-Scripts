local os = require("os")
local filesystem = require("filesystem")
os.execute("cp -f /home/OCNetSetup/MainFunctions.lua /home")
os.execute("cp -f /home/OCNetSetup/.shrc /home")
os.execute("cp -f /home/OCNetSetup/getOCNet.lua /home")
os.execute("cp -f /home/OCNetSetup/copyOCNet.lua /home")
os.execute("cp -f /home/OCNetSetup/serialization.lua /lib")
os.execute("cp -f /home/OCNetSetup/OCNet.lua /home/OCNet")
os.execute("cp -f /home/OCNetSetup/startOCNet.lua /home/OCNet")
if filesystem.exists("/lib/GUI.lua") == false then
  os.execute("pastebin run ryhyXUKZ")
end
os.execute("reboot")