local io = require("io")
local mf = {}
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
mf.contains = contains
mf.containsKey = containsKey
mf.getIndex = getIndex
mf.startswith = startswith
mf.split = split
mf.writex = writex
mf.printx = printx
mf.filewx = filewx
return mf