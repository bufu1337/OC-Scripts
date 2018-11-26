local os = require("os")
local filesystem = require("filesystem")
local mf = require("MainFunctions")
local gitrepo = "https://raw.githubusercontent.com/bufu1337/OC-Scripts/master/Builder/"
local wp = "/home/Builder/Models/"
local model = {}
local model_list = {}
local function listNewModels()
  os.execute("wget -f " .. gitrepo .. "model_list.lua" .. "?" .. math.random() .. " /home/Builder/model_list.lua")
  model_list = require("Builder/model_list")
  print("List of models in builder")
  mf.printx(model_list)
end
local function checkLoadedModel()
  if model.loadedModel == nil then
    return false
  else
    return true
  end
end
local function listModels()
  if filesystem.exists("/home/Builder/model_list.lua") == false then
    listNewModels()
  else
    model_list = require("Builder/model_list")
    print("List of models in builder")
    mf.printx(model_list)
  end
end
local function getNewModel(modelname)
  os.execute("wget -f " .. gitrepo .. "Models/" .. modelname .. ".model.lua" .. "?" .. math.random() .. " " .. wp .. modelname .. ".model.lua")
end
local function getModel(modelname)
  if filesystem.exists(wp .. modelname .. ".model.lua") == false then
    os.execute("wget -f " .. gitrepo .. "Models/" .. modelname .. ".model.lua" .. "?" .. math.random() .. " " .. wp .. modelname .. ".model.lua")
  end
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
local function getLevel(level)
  local lev = {}
  if checkLoadedModel() then
    local levstr = string.sub(tostring(level + 1000), 2)
    local i = 1
    local levelpath = model.loadedModel.name:sub(1,#model.loadedModel.name - 6) .. "/" .. levstr
    if filesystem.exists(wp .. levelpath) == false then
      os.execute("wget -f " .. gitrepo .. "Models/" .. levelpath .. "?" .. math.random() .. " " .. wp .. levelpath)
    end
    for line in io.lines(wp .. levelpath) do
      lev[i] = line
      i = i + 1
    end
    --os.remove(wp .. levelpath)
  end
  return lev
end
local function loadModelEx(modelname, rotation, startpoint)
  getModel(modelname)
  model.loadedModel = require("Builder/Models/" .. model_list[mf.getIndex(modelname .. ".model.lua")])
  model.loadedModel.rotation = rotation
  model.loadedModel.startpoint = startpoint
  model.loadedModel.size = rotateLevel(rotateLevel(mirrorLevel(getLevel(1), false), 3)[1], rotation)[2]
  model.loadedModel.levelsCount = #model.loadedModel.levels
end
local function loadModel(modelname, rotation, startpoint)
  listModels()
  if mf.contains(model_list, modelname .. ".model.lua") then
    loadModelEx(modelname, rotation, startpoint)
    return true
  else
    listNewModels()
    if mf.contains(model_list, modelname .. ".model.lua") then
      loadModelEx(modelname, rotation, startpoint)
      return true
    else
      return false
    end
  end
end
local function loadModelbyIndex(modelindex, rotation, startpoint)
  listModels()
  if model_list[modelindex] ~= nil then
    loadModelEx(model_list[modelindex]:sub(1, #model_list[modelindex] - 10), rotation, startpoint)
    return true
  else
    return false
  end
end
local function unloadModel()
  model.loadedModel = nil
end
local function getModelLevel(level, starting, ending)
  local newlevel = rotateLevel(rotateLevel(mirrorLevel(getLevel(level), false), 3)[1], model.loadedModel.rotation)[1]
  local lev = {}
  if checkLoadedModel() then
    for j, l in pairs(newlevel) do
      lev[j] = {}
      if j >= starting and j <= ending then
        for b = 1, #l, 1 do
          local letter = l:sub(b,b)
          if letter == "-" or letter == " " then
            lev[j][b] = {}
          else
            lev[j][b] = {name=model.loadedModel.mats[letter], placed=false}
          end
        end
      end
    end
  end
  return lev
end
local function getModelLevel(level)
  return getModelLevel(level, 1, model.loadedModel.y)
end

return model
