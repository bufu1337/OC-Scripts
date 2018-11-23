local serializer = require("serializer")
local mf = require("MainFunctions")

--local wp = "Y:/Minecraft/NBT/Out/"
--local we = "Y:/Minecraft/NBT/"
local wp = "C:/Privat/NBTConvert/Out/"
local we = "C:/Privat/NBTConvert/"

local new = false

local function listNewModels(directory)
  local subs, files, newModels, counter = mf.listSubDirsInDir(directory), mf.listFilesInDir(directory), {}, 1
  for _,sub in pairs(subs) do
    if mf.contains(files, (sub .. ".model")) and not mf.contains(files, sub .. ".model.lua") then 
      newModels[counter] = files[mf.getIndex(files, sub .. ".model")]
      counter = counter + 1
    end
  end
  return newModels
end
local function listModels(directory)
  local subs, files, models, counter = mf.listSubDirsInDir(directory), mf.listFilesInDir(directory), {}, 1
  for _,sub in pairs(subs) do
    if mf.contains(files, (sub .. ".model")) and mf.contains(files, sub .. ".model.lua") then 
      models[counter] = files[mf.getIndex(files, sub .. ".model.lua")]
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
  model.title = nil
  if model ~= nil and model.levels ~= nil then
    for lev, level in pairs(model.levels) do
      model.levels[lev].name = nil
      model.levels[lev].blocks = nil
    end
    mf.printx(model)
    mf.WriteObjectFile(model, wp .. modelname .. ".lua")
  end
end
local function ConvertModels()
  for i, modelname in pairs(listModels(wp)) do
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
  ConvertModels()
else
  ConvertNewModels()
end
WriteModelList()
