local mf = {}
mf.component = require("component")
mf.event = require("event")
mf.io = require("io")
mf.sides = require("sides")
mf.thread = require("thread")
mf.shell = require("shell")
mf.filesystem = require("filesystem")
mf.os = require("os")
mf.serial = require("serialization")
mf.OCNet = {toSystem = "", system = "", to = "", from = "", tunnel = false, loc = "", remote = "", tunnels = {}, main_server = {}}

for address, componentType in mf.component.list() do 
  if componentType == "tunnel" then
    table.insert(mf.OCNet.tunnels, address)
  end
end
if mf.component.modem ~= nil then
  mf.component.modem.close(478)
  mf.component.modem.open(478)
end
mf.ComputerName = {}
if mf.filesystem.exists("/home/ComputerName.lua") then  
  mf.ComputerName = require("ComputerName")
end
if mf.filesystem.exists("/home/OCNetServer.lua") then  
  mf.OCNet.main_server = require("OCNetServer")
end
mf.logFile = ""

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
local function getSystem(system)
  if system == nil then
    return mf.OCNet.system
  end
  return system
end
function mf.SendOverOCNet(computer, data, modem_destination, system, tunnel)
  system = getSystem(system)
  if system == "" then
    print("Pleas define system.")
    return false
  end
  local ocnet_obj = {OCNet={toSystem=system, to=computer, from=mf.ComputerName[system].name}}
  ocnet_obj = mf.combineTables(ocnet_obj, data)
  local message = mf.serial.serialize(ocnet_obj)
  if tunnel ~= nil then
    mf.component.proxy(tunnel).send(message)
  elseif modem_destination ~= nil and mf.component.modem ~= nil then
  	if modem_destination == "" and mf.OCNet.main_server.address == nil then
	    mf.components.modem.broadcast(478, message)
  	elseif modem_destination == "" and mf.OCNet.main_server.address ~= nil then
  	  mf.components.modem.send(mf.OCNet.main_server.address, 478, message)
  	elseif modem_destination ~= "" then
  	  mf.components.modem.send(modem_destination, 478, message)
  	end
  elseif mf.component.tunnel ~= nil then
      mf.component.tunnel.send(message)
  else
    print("No Network-Card or Linked-Card installed to connect to OCNet.")
    return false
  end
  return true
end
function mf.ReceiveFromOCNet(timeout)
  local _, localAddress, remoteAddress, data = ""
  if timeout ~= nil and tonumber(timeout) ~= nil then
    _, localAddress, remoteAddress, _, _, data = mf.event.pull(timeout, "modem_message")
  else
	  _, localAddress, remoteAddress, _, _, data = mf.event.pull("modem_message")
  end
  if remoteAddress ~= nil then
    data = mf.serial.unserialize(data)
    if mf.containsKey(data, "OCNet") then
    	mf.OCNet = mf.combineTables(mf.OCNet, data.OCNet)
    	if mf.contains(mf.OCNet.tunnels, localAddress) then
    	  mf.OCNet.tunnel = true
    	  mf.OCNet.loc = localAddress
    	else
    	  mf.OCNet.tunnel = false
    	  mf.OCNet.loc = ""
    	end
    	mf.OCNet.remote = remoteAddress
    	data.OCNet = nil
    	return data, mf.copyTable(mf.OCNet)
    else
    	print("Received data is not from OCNet.")
    	return data
    end
  else
    print("No data received from OCNet.")
    return nil
  end
end

function mf.SendBack(data)
  if mf.OCNet.tunnel then
    mf.SendOverOCNet(mf.OCNet.from, data, nil, nil, mf.OCNet.loc)
  else
    mf.SendOverOCNet(mf.OCNet.from, data, mf.OCNet.remote)
  end
end
function mf.GetNamesFromOCNet(typ, system)
  system = getSystem(system)
  if system ~= "" then
    local sended = mf.SendOverOCNet("", {getNames={system=system, typ=typ}}, "", "OCNet")
    if sended then
      local received = mf.ReceiveFromOCNet(20)
      if received then
        return received
      else
        print("No OCNet found. Please build OCNet-Server and restart this Computer.")
      end
    end
  else
    print("Pleas define system.")
  end
  return nil
end

function mf.SetComputerName(typ, system)
  system = getSystem(system)
  if system ~= "" then
    if mf.ComputerName[system] == nil then
      print("Please enter a Computername for the System: " .. system .. ".")
      print("(No blank spaces allowed, will be replaced with underline)")
      mf.ComputerName[system] = {isRegistered = false}
      mf.ComputerName[system].name = mf.io.read()
      mf.ComputerName[system].name = mf.ComputerName[system].name:gsub(" ", "_")
      mf.WriteObjectFile(mf.ComputerName,"/home/ComputerName.lua")
    end
    if mf.ComputerName[system].isRegistered == false then
      local sended = mf.SendOverOCNet("", {registerComputer={system=system, name=mf.ComputerName[system].name, typ=typ}}, "", "OCNet")
      if sended then
        local received = mf.ReceiveFromOCNet(10)
        if received then
          print("OCNet found. Computer registered in OCNet.")
          mf.OCNet.main_server.address = mf.OCNet.remote
          mf.OCNet.main_server.name = received[1]
          mf.WriteObjectFile(mf.OCNet.main_server, "/home/OCNetServer.lua")
          return true
        else
          print("No OCNet found.")
        end
      end
    end
  else
    print("Please define system.")
  end
  return false
end
function mf.WriteObjectFile(object, path, dep)
    local newLuaFile = mf.io.open(path, "w")
    if type(object) == "table" then
      newLuaFile:write("return ")
      for i, k in pairs(mf.serial.serializedtable(object, true, dep)) do
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
    local i, t, subdirs = 0, {}, mf.listSubDirsInDir(directory)
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
function mf.isSide(text, validsides)
  if validsides == nil then
    validsides = {"up", "down", "east", "west", "north", "south"}
  end
  if mf.contains(validsides, text) then
    return true
  else
    return false
  end
end
function mf.getSidesInput(count, validsides, opposite)
  local invalid = true
  while invalid do
    local temp = mf.split(mf.io.read())
    local tempvalid = {}
    local tempswitch = {up="down", down="up", east="west", west="east", south="north", north="south"}
    for i,j in pairs(temp) do
      tempvalid[i] = mf.isSide(j, validsides)
    end
    if #temp ~= count or mf.contains(tempvalid, false) then
      local txt = "Invalid input. Please enter " .. count .. " side"
      
      if count == 1 then
        txt = txt .. ". Possible: "
      else
        txt = txt .. "s separated with ', '. Possible: "
      end
      if validsides == nil then
        for i,j in pairs(validsides) do
          if i == #validsides then
            txt = txt .. j
          else
            txt = txt .. j .. ", "
          end
        end
      else
        txt = txt .. "up, down, east, west, north, south"
      end
      print(txt)
    elseif count == 2 and opposite and temp[2] ~= tempswitch[temp[1]] then
      print("Please enter 2 opposite sides separated with ', '.")
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
function mf.getNumericInput(min, max)
  local invalid = true
  local min_y = (min ~= nil)
  local max_y = (max ~= nil)
  while invalid do
    local min_x = true
    local max_x = true
    local temp = tonumber(mf.io.read())
    if temp ~= nil then
      if min_y then
        if temp < min then
          min_x = false
        end
      end
      if max_y then
        if temp > max then
          max_x = false
        end
      end
      if min_x and max_x then
        invalid = false
        return temp
      else
        if min_y and max_y == false then
          print("Numeric value out of range. Please enter a number from " .. tostring(min) ..  " (including).")
        elseif min_y == false and max_y then
          print("Numeric value out of range. Please enter a number up to " .. tostring(max) .. "(including).")
        else
          print("Numeric value out of range. Please enter a number between " .. tostring(min) .. " (including) and " .. tostring(max) .. " (including).")
        end
      end
    else
      print("Invalid numeric value. Please enter a numeric value.")
    end
  end
end
function mf.checkComponent(proxy)
  --if mf.component.proxy(proxy) == nil then
    --return false
  --end
  return true
end
function mf.getComponentProxyInput()
  local invalid = true
  while invalid do
    local temp = mf.io.read()
    if mf.checkComponent(temp) then
      invalid = false
      return temp
    else
      print("Invalid component. Please enter a correct UID.")
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
function mf.contains(ab, element, only_keytype)
  if type(ab) == "string" then
    local abnew = ab:gsub(element, "")
    if #abnew < #ab then
      return true
    else
      return false
    end
  elseif type(ab) == "table" then
    for key, value in pairs(ab) do
      local t = true
      if only_keytype ~= nil then
        if only_keytype == "string" or only_keytype == "number" then
          if type(key) ~= only_keytype then
            t = false
          end
        end
      end
      if value == element and t then
        return true
      end
    end
  end
  return false
end
function mf.containsKey(ab, element)
  if ab ~= nil then
    if ab[element] ~= nil then
      return true
    end
  end
  return false
end
function mf.containsKeys(ab, elements)
  local temp = true
  for key, element in pairs(elements) do
    if ab[element] == nil then
      temp = false
    end
  end
  return temp
end
function mf.getAutoSizeForGuiList(list)
  local count = mf.getCount(list)
  local r = {y=0, height=0, width=0, itemheight= 0}
  r.itemheight = math.floor(50 / count)
  if r.itemheight == 0 then r.itemheight = 1 end
  r.height = r.itemheight * count
  if r.height > 50 then r.height = 50 end
  r.y = math.floor(50 - r.height) + 1
  for i,j in pairs(list) do
    if type(j) == "string" then
      if r.width <= #j then
        r.width = #j
      end
    end
  end
  r.width = r.width + 4
  return r
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
function mf.copyTable(ab, keys)
  local returning = mf.serial.unserialize(mf.serial.serialize(ab))
  if keys ~= nil then
    for i,j in pairs(returning) do
      if mf.contains(keys, i) == false then
        returning[i] = nil
      end
    end
  end
  return returning
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