local io = require("io")
local serial = require("serialization")
local mf = {}

local function WriteObjectFile(object, path)
    local newLuaFile = io.open(path, "w")
    if type(object) == "table" then
      newLuaFile:write("return ")
      for i, k in pairs(serial.serializedtable(object, true)) do
        newLuaFile:write(k)
      end
    elseif type(object) == "string" then
      newLuaFile:write("return " .. serial.serialize(object))
    else
      newLuaFile:write("return " .. toString(object))
    end    
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
local function endswith(ab, str) 
    return (ab:sub(#ab - #str + 1) == str)
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
local function copyTable(ab)
  return serial.unserialize(serial.serialize(ab))
end
local function combineTables(table1, table2)
  for i,j in pairs(table2) do
    if table1[i] ~= nil then
      if type(table1[i]) == "table" and type(j) == "table" then
        table1[i] = combineTables(table1[i], j)
      else
        table1[i] = j
      end
    else
      table1[i] = j
    end
  end
  return table1
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
mf.listSubDirsInDir = listSubDirsInDir
mf.listFilesInDir = listFilesInDir
mf.copyTable = copyTable
mf.combineTables = combineTables
--local newLuaFile = io.open("C:/Users/alexandersk/workspace/OC-Scripts/src/Builder/Models/test.lua", "w")
--  local t = serial.serializedtable({a="dsf",["b:c"]=3,d=true, {1,sad="dd",3,4}},true)
--  local b = serial.serialize({a="dsf",["b:c"]=3,d=true, {1,sad="dd",3,4}},true)
--  for i,j in pairs(t) do
--    newLuaFile:write(j)
--    print(j)
--  end
--  local x = serial.unserialize(b)
--  print(x.a)
--  --for i,j in pairs(serial.serialize({a="dsf",["b:c"]=3,d=true})) do
--    --newLuaFile:write(j .. "\n")
--  --end
--    newLuaFile:close()
WriteObjectFile({lol="", netcards={}}, "C:/Users/alexandersk/workspace/OC-Scripts/haha.txt")
return mf