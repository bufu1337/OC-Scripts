if filesystem.exists("/home/crafting/") == false then
  filesystem.makeDirectory("/home/crafting/")
end
os.execute("wget -f https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/StartCraft.lua /home/crafting/StartCraft.lua")