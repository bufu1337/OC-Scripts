local mf = {}
mf.component = require("component")
mf.event = require("event")
mf.io = require("io")
mf.sides = require("sides")
mf.os = require("os")
mf.thread = require("thread")
mf.serial = require("serialization")
mf.filesystem = require("filesystem")
mf.shell = require("shell")
mf.logFile = ""

--mf.io = io
--mf.os = os
--mf.serial = require("serialization")
--mf.filesystem = filesystem

function mf.OpenLogFile(path)
  if mf.logFile == "" then
    mf.logFile = mf.io.open(path, "a")
  end
end
function mf.CloseLogFile()
  if mf.logFile ~= "" then
    mf.logFile:close()
    mf.logFile = ""
  end
end
function mf.Log(logtext)
  if mf.logFile ~= "" then
    mf.logFile:write(logtext)
  end
end
function mf.LogEx(path, logtext)
  mf.OpenLogFile(path)
  mf.logFile:write(logtext)
  mf.CloseLogFile()
end
function mf.WriteObjectFile(object, path)
    local newLuaFile = mf.io.open(path, "w")
    if type(object) == "table" then
      newLuaFile:write("return ")
      for i, k in pairs(mf.serial.serializedtable(object, true)) do
        newLuaFile:write(k)
      end
    elseif type(object) == "string" then
      newLuaFile:write("return " .. mf.serial.serialize(object))
    else
      newLuaFile:write("return " .. toString(object))
    end    
    newLuaFile:close()
end
function mf.listSubDirsInDir(directory)
    local i, t = 0, {}
    local pfile = mf.io.popen('dir "'..directory..'" /b /ad')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end
function mf.listFilesInDir(directory)
    local i, t, subdirs = 0, {}, listSubDirsInDir(directory)
    local pfile = mf.io.popen('dir "'..directory..'" /b')
    for filename in pfile:lines() do
        if not mf.contains(subdirs, filename) then
          i = i + 1
          t[i] = filename
        end
    end
    pfile:close()
    return t
end
function mf.isSide(text)
  if mf.contains({"up", "down", "east", "west", "north", "south"}, text) then
    return true
  else
    return false
  end
end
function mf.getSidesInput(count)
  local invalid = true
  while invalid do
    local temp = mf.split(io.read())
    local tempvalid = {}
    for i,j in pairs(temp) do
      tempvalid[i] = mf.isSide(j)
    end
    if #temp ~= count or mf.contains(tempvalid, false) then
      if count == 1 then
        print("Invalid input. Please give in " .. count .. " side.")
      else
        print("Invalid input. Please give in " .. count .. " sides separated with ', '.")
      end
    else
      invalid = false
      if #temp == 1 then
        return temp[1]
      else
        return temp
      end
    end
  end
end
function mf.checkComponent(proxy)
  if mf.component.proxy(proxy) == nil then
    return false
  end
  return true
end
function mf.getComponentProxyInput()
  local invalid = true
  while invalid do
    local temp = io.read()
    if mf.checkComponent(temp) then
      invalid = false
      return temp
    else
      print("Invalid component. Please give in a correct UID.")
    end
  end
end
function mf.MathUp(num)
    local result = math.floor(num)
    if((num - result) > 0)then
      result = result + 1
    end
    return result
end
function mf.contains(ab, element)
  for key, value in pairs(ab) do
    if value == element then
      return true
    end
  end
  return false
end
function mf.containsKey(ab, element)
  for key, value in pairs(ab) do
    if key == element then
      return true
    end
  end
  return false
end
function mf.getCount(ab)
	local count = 0
	for i,j in pairs(ab) do
		count = count + 1
	end
	return count
end
function mf.getKeys(ab)
	local keys = {}
	for k in pairs(ab) do
		table.insert(keys, k)
	end
	return keys
end
function mf.getSortedKeys(ab)
	local keys = mf.getKeys(ab)
	table.sort(keys)
	return keys
end
function mf.getIndex(ab, element)
  for key, value in pairs(ab) do
    if value == element then
      return key
    end
  end
  return -1
end
function mf.startswith(ab, str) 
    return ab:find('^' .. str) ~= nil
end
function mf.endswith(ab, str) 
    return (ab:sub(#ab - #str + 1) == str)
end
function mf.split(inputstr, sep)
    if sep == nil then
        sep = ", "
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
function mf.copyTable(ab)
  return mf.serial.unserialize(mf.serial.serialize(ab))
end
function mf.combineTables(table1, table2)
  for i,j in pairs(table2) do
    if table1[i] ~= nil then
      if type(table1[i]) == "table" and type(j) == "table" then
        table1[i] = mf.combineTables(table1[i], j)
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
    mf.io.write(var .. "\n")
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
function mf.writex(var)
	out.x("w", var)
end
function mf.printx(var)
	out.x("p", var)
end
function mf.filewx(var, file)
	out.x("f", var, file)
end
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
--WriteObjectFile({lol="", netcards={}}, "C:/Users/alexandersk/workspace/OC-Scripts/haha.txt")
return mf