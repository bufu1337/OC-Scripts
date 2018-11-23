local os = require("os")
local filesystem = require("filesystem")
local gitrepo = "https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/Builder"
local wp = "/home/builder/temp"
local model = {}
local function listNewModels()
  
end
local function listModels()
  
end
local function getModel(modelname)
  
end
local function mirrorLevel(level, vertical)
  local new_level = {}
  local ccount = string.len(level[1])
  local rcount = 0
  for _ in pairs(level) do rcount = rcount + 1 end
  if vertical then
    local newcount = 1
    for j = rcount, 1, -1 do
      new_level[newcount] = level[j]
      newcount = newcount + 1
    end
  else
    for i = 1, rcount, 1 do
      local new_line = ""
      for j = ccount, 1, -1 do
        new_line = new_line .. level[i]:sub(j,j)
      end
      new_level[i] = new_line
    end
  end
  return new_level
end
local function rotateLevel(level, rotation)
  local new_level = {}
  local size = {}
  local ccount = string.len(level[1])
  local rcount = 0
  for _ in pairs(level) do rcount = rcount + 1 end
  if rotation == 0 then
    local h = 1
    for i = 1, rcount, 1 do
      new_level[h] = ""
      local row = ""
      for j = 1, ccount, 1 do
        if string.len(level[i]) >= j then
          local temp = level[i]:sub(j,j)
          if temp == "^" then
            temp = "-"
          end
          new_level[h] = new_level[h] .. temp
        else
          new_level[h] = new_level[h] .. "-"
        end
      end
      h = h + 1
    end
    size = {x=ccount, y=rcount}
  end
  if rotation == 1 then
    local h = 1
    for i = ccount, 1, -1 do
      new_level[h] = ""
      local row = ""
      for j = 1, rcount, 1 do
        if string.len(level[j]) >= i then
          local temp = level[j]:sub(i,i)
          if temp == "^" then
            temp = "-"
          end
          new_level[h] = new_level[h] .. temp
        else
          new_level[h] = new_level[h] .. "-"
        end
      end
      h = h + 1
    end
    size = {x=rcount, y=ccount}
  end
  if rotation == 2 then
    local h = 1
    for i = rcount, 1, -1 do
      new_level[h] = ""
      local row = ""
      for j = ccount, 1, -1 do
        if string.len(level[i]) >= j then
          local temp = level[i]:sub(j,j)
          if temp == "^" then
            temp = "-"
          end
          new_level[h] = new_level[h] .. temp
        else
          new_level[h] = new_level[h] .. "-"
        end
      end
      h = h + 1
    end
    size = {x=ccount, y=rcount}
  end
  if rotation == 3 then
    local h = 1
    for i = 1, ccount, 1 do
      new_level[h] = ""
      local row = ""
      for j = rcount, 1, -1 do
        if string.len(level[j]) >= i then
          local temp = level[j]:sub(i,i)
          if temp == "^" then
            temp = "-"
          end
          new_level[h] = new_level[h] .. temp
        else
          new_level[h] = new_level[h] .. "-"
        end
      end
      h = h + 1
    end
    size = {x=rcount, y=ccount}
  end
  return {new_level, size}
end
local function getLevel(modelname, level)
  local levstr = string.sub(tostring(level + 1000), 2)
  local lev = {}
  local i = 1
  local levelpath = modelname:sub(1,#modelname - 6) .. "/" .. levstr
  for line in io.lines(wp .. levelpath) do
    lev[i] = line
    i = i + 1
  end
  return lev
end
local function getModelSize(modelname, rotation)
  return rotateLevel(rotateLevel(mirrorLevel(getLevel(modelname, 1), false), 3)[1], rotation)[2]
end
local function getModelLevel(modelname, level, rotation, starting, ending)
  local newlevel = rotateLevel(rotateLevel(mirrorLevel(getLevel(modelname, level), false), 3)[1], rotation)[1]
  local lev = {}
  for j, l in pairs(newlevel) do
    lev[j] = {}
    for b = 1, #l, 1 do
      local letter = l:sub(b,b)
      if letter == "-" or letter == " " then
        lev[j][b] = {}
      else
        lev[j][b] = {name=modelname.mats[letter], placed=false}
      end
    end
  end
  return lev
end
local function getModelLevelsCount(modelname)
  local levels = getModel(modelname).levels
  return #levels
end
local function getModelLevel(modelname, level, rotation)
  return getModelLevel(modelname, level, rotation, 1, getModelLevelsCount(modelname))
end

return model
