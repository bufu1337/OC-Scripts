local start = {}
local shell = require("shell")
local prog = "/home/crafting/"

local function getfiles(files)
    print("initializing files...")
    local Files
    for i,file in pairs(files) do
      file = file .. ".lua"
      print("getting file " .. file)
      os.execute("wget -f 'https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/" .. file .."' '" .. prog .. file .. "'")
    end
    print("Get new Files: done")
end

local function clone()
    local pFiles = {}
    local nFiles = {}
    if(filesystem.exists(prog))then
        if(filesystem.exists(prog .. "files"))then
            pFiles = get(io.lines(prog .. "files"))
        end
    else
        filesystem.makeDirectory(prog)
    end
    os.execute("wget -f 'https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/files' '" .. prog .. "files'")
    nFiles = get(io.lines(prog .. "files"))
    local files = {}
    local counter = 0
    for i,j in pairs(nFiles) do
        if(pFiles[i] == nil)then
            files[counter] = i
        elseif(nFiles[i] > pFiles[i])then
            files[counter] = i
        else
            print(i .. ".lua is uptodate")
        end
    end
    init.getfiles(files)
end
--local linestest = {"Proxies.lua 0.001", "Convert.lua 0.001", "MoveItem.lua 0.001", "AutoCraft.lua 0.001"}
local function get(lines)
    local files = {}
    for i, line in pairs(lines) do
        local fcounter = 0
        local filename
        local f = {version = 0; folder = ""}
        for w in (line .. " "):gmatch("([^ ]*) ") do 
            if(fcounter == 0)then
                if(w:match("/") ~= nil)then
                    local b = 0
                    for y in w:gmatch("([^/]*)/") do
                        if(w:match("/") ~= nil)then
                             f.folder = y
                        else
                            w = y
                        end
                    end
                end
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
    if args[1] == "GetFiles" then
        clone()
    end
end


start.clone = clone
return start
