local filesystem = require("filesystem")
local args = ( ... )
print(args)
if #args == 0 then
  if filesystem.exists("/home/crafting/") == false then
    filesystem.makeDirectory("/home/crafting/")
  end
  os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/StartCraft.lua?" .. math.random() .. " /home/crafting/StartCraft.lua")
else
  print("getting: " .. args)
  os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/" .. args .. ".lua /home/" .. args .. ".lua")
end