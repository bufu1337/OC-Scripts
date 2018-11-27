local serializer = require("Builder\\serializer")
local mf = require("MainFunctions")
local os = require("os")

--local wp = "Y:/Minecraft/OC-Scripts/Builder/Models/"
--local we = "Y:/Minecraft/OC-Scripts/Builder/"
local wp = "C:/Users/alexandersk/workspace/OC-Scripts/src/Builder/Models/"
local we = "C:/Users/alexandersk/workspace/OC-Scripts/src/Builder"

local new = false

local function listNewModels(directory)
  local subs, files, newModels, counter = mf.listSubDirsInDir(directory), mf.listFilesInDir(directory), {}, 1
  for _,sub in pairs(subs) do
    if mf.contains(files, (sub .. ".model")) and not mf.contains(files, (sub .. ".model.lua")) then 
      newModels[counter] = files[mf.getIndex(files, sub .. ".model")]
      counter = counter + 1
    end
  end
  return newModels
end
local function listModels(directory)
  local subs, files, models, counter = mf.listSubDirsInDir(directory), mf.listFilesInDir(directory), {}, 1
  for _,sub in pairs(subs) do
    if mf.contains(files, (sub .. ".model")) then 
      models[counter] = files[mf.getIndex(files, sub .. ".model")]
      counter = counter + 1
    end
  end
  return models
end
local function getModel(modelname)
  local obj, err = serializer.deserializeFile(wp .. modelname)
  if obj then
    obj.matCountsAll = {}
    for g,l in pairs(obj.levels) do
      for g,l in pairs(l.matCounts) do
        if obj.matCountsAll[g] == nil then
          obj.matCountsAll[g] = l
        else
          obj.matCountsAll[g] = obj.matCountsAll[g] + l
        end
      end
    end
  end
  return obj
end
local function ConvertModel(modelname)
  print("Convert Model: " .. modelname)
  local model = getModel(modelname)
  model.startPoint = nil
  model.author = nil
  model.defaultDropPoint = nil
  model.name = model.title
  model.title = nil
  if model ~= nil and model.levels ~= nil then
    for lev, level in pairs(model.levels) do
      model.levels[lev].name = nil
      model.levels[lev].blocks = nil
--      if mf.getCount(model.levels[lev].matCounts) ~= 0 then
--      print("array is filled")
--      else
--      print("array is empty")
--      end
      model.levels[lev].pattern = {}
      local levstr = string.sub(tostring(lev + 1000), 2)
      local i = 1
      local levelpath = model.loadedModel.name:sub(1,#model.loadedModel.name - 6) .. "/" .. levstr
      for line in io.lines(wp .. levelpath) do
        model.levels[lev].pattern[i] = line
        i = i + 1
      end
    end
    
    --trim columns
    for i = 1, #model.levels[1].pattern[1], 1 do
      local linetemp = ""
      for lev, level in pairs(model.levels) do
        linetemp = linetemp .. model.levels[lev].pattern[i]
      end
      if linetemp:gsub("-", ""):gsub(" ", "") == "" then
        for lev, level in pairs(model.levels) do
          model.levels[lev].pattern[i] = ""
        end
      else
        break
      end
    end
    for i = #model.levels[1].pattern[1], 1, -1 do
      local linetemp = ""
      for lev, level in pairs(model.levels) do
        linetemp = linetemp .. model.levels[lev].pattern[i]
      end
      if linetemp:gsub("-", ""):gsub(" ", "") == "" then
        for lev, level in pairs(model.levels) do
          model.levels[lev].pattern[i] = ""
        end
      else
        break
      end
    end
    
    --trim rows
    for i = 1, #model.levels[1].pattern, 1 do
      local linetemp = ""
      for lev, level in pairs(model.levels) do
        linetemp = linetemp .. model.levels[lev].pattern[i]
      end
      if linetemp:gsub("-", ""):gsub(" ", "") == "" then
        for lev, level in pairs(model.levels) do
          model.levels[lev].pattern[i] = ""
        end
      else
        break
      end
    end
    for i = #model.levels[1].pattern, 1, -1 do
      local linetemp = ""
      for lev, level in pairs(model.levels) do
        linetemp = linetemp .. model.levels[lev].pattern[i]
      end
      if linetemp:gsub("-", ""):gsub(" ", "") == "" then
        for lev, level in pairs(model.levels) do
          model.levels[lev].pattern[i] = ""
        end
      else
        break
      end
    end
    mf.printx(model)
    mf.WriteObjectFile(model, wp .. modelname .. ".lua")
  end 
end
local function ConvertModels()
  for i, modelname in pairs(listModels(wp)) do
    os.remove(wp .. modelname .. ".lua")
    ConvertModel(modelname)
  end
end
local function ConvertNewModels()
  for i, modelname in pairs(listNewModels(wp)) do
    ConvertModel(modelname)
  end
end
local function WriteModelList()  
  mf.WriteArrayFile(listModels(wp), we .. "model_list.lua")
end
if new then
  ConvertNewModels()
else
  ConvertModels()
end
WriteModelList()
