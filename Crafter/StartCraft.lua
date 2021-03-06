local startcraft = {}
local shell = require("shell")
local thread = require("thread")
local filesystem = require("filesystem")
local mf = require("MainFunctions")
local prog = "/home/crafting/"

local function getDefs(lines)
    local files = {}
    for line in lines do
        local fcounter = 0
        local filename
        local f = {version = 0; folder = ""}
        for w in (line .. " "):gmatch("([^ ]*) ") do 
            if(fcounter == 0)then
                if(w:find("/") ~= nil)then
                    local b = 0
                    for y in w:gmatch("([^/]*)/") do
                        f.folder = f.folder .. y .. "/"
                    end
                end
                local n = string.sub(w, #f.folder + 1)
                local c = 0
                for x in n:gmatch("([^.]*).") do
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
        print(filename .. ": Version: " .. f.version .. " Folder: " .. f.folder)
    end
    return files
end

local function getfiles(files)
    print("")
    if(files.n > 0)then
        print("Downloading files...")
        for name,props in pairs(files) do
            if name ~= "n" then
                local temp = prog
                for i in props.folder:gmatch("([^/]*)/") do
                    temp = temp .. i .. "/"
                    filesystem.makeDirectory(temp)
                end
                local file = props.folder .. name .. ".lua"
                print("Getting file: " .. file .. "  (Version: " .. props.version .. ")")
                os.execute("wget -f 'https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/" .. file .."?" .. math.random() .. "' '" .. prog .. file .. "'")
            end
        end
        print("Get new Files: done")
    else
        print("All files are uptodate")
    end

end

local function clone(filelist, specificfile)
  local pFiles = {}
  local nFiles = {}
  if(filesystem.exists(prog))then
      if(filesystem.exists(prog .. filelist))then
          print("Getting old file attributes")
          pFiles = getDefs(io.lines(prog .. filelist))
      end
  else
      print("Directory: " .. prog .. "not existing... Creating!")
      filesystem.makeDirectory(prog)
  end
  print("")
  print("Getting new file attributes")
  os.execute("wget -f 'https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/" .. filelist .. "?" .. math.random() .. "' '" .. prog .. filelist .. "'")
  nFiles = getDefs(io.lines(prog .. filelist))
  local files = {n=0}
  local counter = 0
  print("")
    if(specificfile ~= nil) then
        for i,j in pairs(nFiles) do
            if((j.folder .. i .. ".lua") ~= specificfile) then
                nFiles[i] = nil
            end
        end
    end
  mf.printx(nFiles)
  for i,j in pairs(nFiles) do
    if(pFiles[i] == nil)then
      files[i] = j
      files.n = files.n + 1
      print(j.folder .. i .. ".lua updating, Version: " .. j.version)
    elseif(nFiles[i].version > pFiles[i].version)then
      files[i] = j
      files.n = files.n + 1
      print(j.folder .. i .. ".lua updating, Version: " .. j.version)
    else
      print(j.folder .. i .. ".lua is uptodate, Version: " .. j.version)
    end
  end
  getfiles(files)
end
--local linestest = {"Proxies.lua 0.001", "Convert.lua 0.001", "MoveItem.lua 0.001", "AutoCraft.lua 0.001"} 


local function Start(param)
    if param == "GetFiles" then
    clone("files")
  elseif param == "GetNewFiles" then
    print("Removing: " .. prog .. "files")
    filesystem.remove(prog .. "files")
    clone("files")
    else
      thread.create(function(itemrepo)
          clone("files")
          clone("itemfiles", "Items/" .. itemrepo .. ".lua")
          local ac = require("crafting/Autocraft")
          ac.Craft(itemrepo)
        end, param)
  end
end

local args = shell.parse( ... )
if args[1] ~= nil and args[1]:find("StartCraft") == nil then
    Start(args[1])
end

startcraft.Start = Start
return startcraft
