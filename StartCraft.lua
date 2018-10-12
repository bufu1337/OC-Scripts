local init = {}
local shell = require("shell")
local prog = "/home/crafting/"
function init.getfiles()
  print("initializing files...")
  local Files
  for line in io.lines("/home/crafting/files") do
    if version == nil then
      version = tonumber(line)
    else
      print("getting " .. line)
      os.execute("wget -f 'https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/" .. line .."' '" .. prog .. line .. "'")
    end
  end
  print("done")
end

function init.clone(repo, gotFilesList)
	local pFiles = {}
	local nFiles = {}
	if(exists(prog))then
		if(file_exist(prog .. "files"))then
			pFiles = GetFiles(io.lines(prog .. "files"))
		end
	else
		filesystem.makeDirectory(prog)
	end
	os.execute("wget -f 'https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/files' '" .. prog .. "files'")
	nFiles = GetFiles(io.lines(prog .. "newfiles"))
	filesystem.remove("/home/crafting/newfiles")
	init.getfiles()
end
--local linestest = {"Proxies.lua 0.001", "Convert.lua 0.001", "MoveItem.lua 0.001", "AutoCraft.lua 0.001"}
local function GetFiles(lines)
	local files = {}
	for i, line in pairs(lines) do
		local fcounter = 0
		local filename
		local f = {version=0}
		for w in (line .. " "):gmatch("([^ ]*) ") do 
			if(fcounter == 0)then
				local c = 0
				for x in w:gmatch("([^.]*).") do
					if(c == 0)then filename = x end
					c = c + 1
				end
			end
			if(fcounter == 1)then
				f.version = tonumber(w)
			end
			fcounter = fcounter +1
		end
		files[filename] = f
	end
	return files
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
