local init = {}
local shell = require("shell")

function init.getfiles()
  print("initializing files...")
  local version
  for line in io.lines(os.getenv("PWD") .. "/files") do
    if version == nil then
      version = tonumber(line)
    else
      print("getting " .. line)
      os.execute("wget -f 'https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/" .. line .."' '/home/crafting/" .. line .. "'")
    end
  end
  print("done")
end

function init.clone(repo, gotFilesList)
	local previousVersion
	local Version
	if(exists("/home/crafting/"))then
		if(file_exist("/home/crafting/files"))then
			previousVersion = io.lines("/home/crafting/files")[1]
		end
	end
	os.execute("wget -f 'https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/files' /home/crafting/newfiles")
	filesystem.remove("/home/crafting/newfiles")
	init.getfiles()
end


local function file_exist(path)
  local file = io.open(path)
 
  if (not file) then
    print("[ERROR]: No such file: " .. path .. ".")
    return false
  end
  io.close(file)
  return true
end

local args = shell.parse( ... )
if args[1] ~= nil then
  init.clone()
else
  init.getfiles()
end

return init
