local serializer = require("Builder/serializer")
local mf = require("MainFunctionsEclipse")
local os = require("os")

--local wp = "Y:/Minecraft/OC-Scripts/Builder/Models/"
--local we = "Y:/Minecraft/OC-Scripts/Builder/"
local wp = "C:/Users/alexandersk/workspace/OC-Scripts/src/Builder/Models/"
local we = "C:/Users/alexandersk/workspace/OC-Scripts/src/Builder/"

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
local function listLuaModels(directory)
  local subs, files, models, counter = mf.listSubDirsInDir(directory), mf.listFilesInDir(directory), {}, 1
  for _,sub in pairs(subs) do
    if mf.contains(files, (sub .. ".lua")) then 
      models[counter] = files[mf.getIndex(files, sub .. ".lua")]
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
      local levelpath = modelname:sub(1,#modelname - 6) .. "/" .. levstr
      for line in io.lines(wp .. levelpath) do
        model.levels[lev].pattern[i] = line
        i = i + 1
      end
    end
    
    --trim columns
    local startcol = 0
    local endcol = 0
    for j = 1, #model.levels[1].pattern[1], 1 do
      local linetemp = ""
      for i = 1, #model.levels[1].pattern, 1 do
        for lev, level in pairs(model.levels) do
          linetemp = linetemp .. model.levels[lev].pattern[i]:sub(j,j)
        end
      end
      if linetemp:gsub("-", ""):gsub(" ", "") ~= "" then
        startcol = j
        print("STOP TRIMMING, COLUMN: " .. j .. " contains " .. linetemp:gsub("-", ""):gsub(" ", ""))
        break
      end
    end
    for j = #model.levels[1].pattern[1], 1, -1 do
      local linetemp = ""
      for i = 1, #model.levels[1].pattern, 1 do
        for lev, level in pairs(model.levels) do
          linetemp = linetemp .. model.levels[lev].pattern[i]:sub(j,j)
        end
      end
      if linetemp:gsub("-", ""):gsub(" ", "") ~= "" then
        endcol = j
        print("STOP TRIMMING, COLUMN: " .. j .. " contains " .. linetemp:gsub("-", ""):gsub(" ", ""))
        break
      end
    end
    for lev, level in pairs(model.levels) do
      for i = 1, #model.levels[1].pattern, 1 do
        model.levels[lev].pattern[i] = model.levels[lev].pattern[i]:sub(startcol, endcol)
      end
    end
    print("")
    print("")
    
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
        print("Trim ROW: " .. i)
      else
        print("STOP TRIMMING, ROW: " .. i .. " contains " .. linetemp:gsub("-", ""):gsub(" ", ""))
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
        print("Trim ROW: " .. i)
      else
        print("STOP TRIMMING, ROW: " .. i .. " contains " .. linetemp:gsub("-", ""):gsub(" ", ""))
        break
      end
    end
    for i = 1, #model.levels, 1 do
      local newpattern = {}
      local counter = 1
      for j = 1, #model.levels[i].pattern, 1 do
        if model.levels[i].pattern[j] ~= "" then
          newpattern[counter] = model.levels[i].pattern[j]
          counter = counter + 1
        end
      end
      model.levels[i].pattern = newpattern
    end
    print("")
    print("")
    
    --trim levels
    for i = 1, #model.levels, 1 do
      if mf.getCount(model.levels[i].matCounts) == 0 then
        model.levels[i] = nil
        local levstr = string.sub(tostring(i + 1000), 2)
        local itemsep = "\n"
        local levelpath = modelname:sub(1,#modelname - 6) .. "/" .. levstr
        os.remove(wp .. levelpath)
        print("Trim Level: " .. i)
      else 
        print("STOP TRIMMING, LEVEL: " .. i .. " contains materials")
        break
      end
    end
    for i = #model.levels, 1, -1 do
      if mf.getCount(model.levels[i].matCounts) == 0 then
        model.levels[i] = nil
        local levstr = string.sub(tostring(i + 1000), 2)
        local itemsep = "\n"
        local levelpath = modelname:sub(1,#modelname - 6) .. "/" .. levstr
        os.remove(wp .. levelpath)
        print("Trim Level: " .. i)
      else 
        print("STOP TRIMMING, LEVEL: " .. i .. " contains materials")
        break
      end
    end
    
    for i = 1, #model.levels, 1 do
      local levstr = string.sub(tostring(i + 1000), 2)
      local itemsep = "\n"
      local levelpath = modelname:sub(1,#modelname - 6) .. "/" .. levstr
      os.remove(wp .. levelpath)
      local newLuaFile = io.open(wp .. levelpath, "w")
      for il = 1, #model.levels[i].pattern, 1 do
          if il == #model.levels[i].pattern then itemsep = "" end
          newLuaFile:write(model.levels[i].pattern[il] .. itemsep)
      end
      newLuaFile:close()
    end
    for i = 1, #model.levels, 1 do
      model.levels[i].pattern = nil
    end
    print("")
    print("")
    mf.printx(model)
    os.remove(wp .. modelname)
    mf.WriteObjectFile(model, wp .. modelname:sub(1,#modelname - 6) .. ".lua")
  end 
end
local function ConvertModels()
  for i, modelname in pairs(listModels(wp)) do
    ConvertModel(modelname)
  end
end
local function WriteModelList()  
  os.remove(we .. "model_list.lua")
  mf.WriteObjectFile(listLuaModels(wp), we .. "model_list.lua")
end

ConvertModels()
WriteModelList()
