if filesystem.exists("/home/crafting/") == false then
  filesystem.makeDirectory("/home/crafting/")
end
os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/StartCraft.lua" .. "?" .. math.random() .. " /home/crafting/StartCraft.lua")
os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/servers.lua" .. "?" .. math.random() .. " /mnt/71c/servers.lua")
os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/screenchange.lua" .. "?" .. math.random() .. " /home/screenchange.lua")
os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/autorun.lua" .. "?" .. math.random() .. " /autorun.lua")