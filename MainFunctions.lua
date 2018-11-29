local io = require("io")
local serial = require("serialization")
local mf = {}

local function getObjectAsString(object)
  local returning = {}

end
local function WriteObjectFile(object, path)
    local newLuaFile = io.open(path, "w")
    local ikeys = mf.getSortedKeys(object)
    local itemsep = ","
    if type(object) == "table" then
      newLuaFile:write("return {\n")
      for ik = 1, #ikeys, 1 do
          if ik == #ikeys then itemsep = "" end
          --local tempsize = object[ikeys[ik]].size
          newLuaFile:write("  " .. ikeys[ik] .. "=" .. serial.serialize(object[ikeys[ik]]) .. itemsep .. "\n")
      end
      newLuaFile:write("}")
    elseif type(object) == "string" then
      newLuaFile:write("return " .. serial.serialize(object))
    else
      newLuaFile:write("return " .. toString(object))
    end    
    newLuaFile:close()
end

local function WriteArrayFile(object, path)
    local newLuaFile = io.open(path, "w")
    local ikeys = mf.getSortedKeys(object)
    local itemsep = ","
    newLuaFile:write("return {\n")
    for ik = 1, #ikeys, 1 do
        if ik == #ikeys then itemsep = "" end
        newLuaFile:write("    " .. serial.serialize(object[ikeys[ik]]) .. itemsep .. "\n")
    end
    newLuaFile:write("}")
    newLuaFile:close()
end
local function listSubDirsInDir(directory)
    local i, t = 0, {}
    local pfile = io.popen('dir "'..directory..'" /b /ad')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end
local function listFilesInDir(directory)
    local i, t, subdirs = 0, {}, listSubDirsInDir(directory)
    local pfile = io.popen('dir "'..directory..'" /b')
    for filename in pfile:lines() do
        if not mf.contains(subdirs, filename) then
          i = i + 1
          t[i] = filename
        end
    end
    pfile:close()
    return t
end
local function MathUp(num)
    local result = math.floor(num)
    if((num - result) > 0)then
      result = result + 1
    end
    return result
end
local function contains(ab, element)
  for key, value in pairs(ab) do
    if value == element then
      return true
    end
  end
  return false
end
local function containsKey(ab, element)
  for key, value in pairs(ab) do
    if key == element then
      return true
    end
  end
  return false
end
local function getCount(ab)
	local count = 0
	for i,j in pairs(ab) do
		count = count + 1
	end
	return count
end
local function getKeys(ab)
	local keys = {}
	for k in pairs(ab) do
		table.insert(keys, k)
	end
	return keys
end
local function getSortedKeys(ab)
	local keys = getKeys(ab)
	table.sort(keys)
	return keys
end
local function getIndex(ab, element)
  for key, value in pairs(ab) do
    if value == element then
      return key
    end
  end
  return -1
end
local function startswith(ab, str) 
    return ab:find('^' .. str) ~= nil
end
local function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
local out = {}
local function w(var, file)
    io.write(var .. "\n")
end
local function p(var, file)
    print(var)
end
local function f(var, file)
    file.write(var .. "\n")
end
out.w = w
out.p = p
out.f = f
local function x(where, var, file, outline)
    local typ = type(var)
    if (typ == "function")then
        out[where](typ, file)
    elseif (typ == "table") then
		local p = ""
        for i,j in pairs(var) do
            if (type(j) == "table") then
                if (outline == nil) then
                    out[where](i .. " = ", file)
                    p = "    "
                else
                    out[where](outline .. i .. " = ", file)
                    p = outline .. "    "
                end
                x(where, j, p)
            else
                if (outline == nil) then
                    out[where](i .. " = " .. tostring(j), file)
                else
                    out[where](outline .. i .. " = " .. tostring(j), file)
                end
            end
        end
    else
        out[where](var, file)
    end
end
out.x = x
local function writex(var)
	out.x("w", var)
end
local function printx(var)
	out.x("p", var)
end
local function filewx(var, file)
	out.x("f", var, file)
end
mf.MathUp = MathUp
mf.contains = contains
mf.containsKey = containsKey
mf.getKeys = getKeys
mf.getSortedKeys = getSortedKeys
mf.getIndex = getIndex
mf.getCount = getCount
mf.startswith = startswith
mf.split = split
mf.writex = writex
mf.printx = printx
mf.filewx = filewx
mf.WriteObjectFile = WriteObjectFile
mf.WriteArrayFile = WriteArrayFile
mf.listSubDirsInDir = listSubDirsInDir
mf.listFilesInDir = listFilesInDir

local newLuaFile = io.open("C:/Users/alexandersk/workspace/OC-Scripts/src/Builder/Models/test.lua", "w")
    newLuaFile:write("return " .. serial.serialize("haha"))
    newLuaFile:close()
return mf