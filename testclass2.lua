local mf = require("MainFunctionsEclipse")
local items = require("ALL_Items")
local res = {}
local sc = {}
local wt = {}

local function getSCMods()
  for a,b in pairs(items) do
    sc[a] = {}
    for i,j in pairs(b) do
      local c = mf.split(i:gsub("_jj_", "?"), "?")[1]
      if mf.contains(sc[a], c) == false then
        table.insert(sc[a], c)
      end
    end
  end
end
local function getNamesWT()
  for a,b in pairs(items) do
    wt[a] = {}
    for i,j in pairs(b) do
      if mf.contains(i, "_b_") then
        local tmp = mf.split(i:gsub("_b_", "?"), "?")[1]
        if mf.contains(wt[a], tmp) == false then
          table.insert(wt[a], tmp)
        end
      end
    end
  end
end
getSCMods()
getNamesWT()
local function findSC(mod)
  for a,b in pairs(sc) do
    for i,j in pairs(b) do
      if j == mod then
        return a
      end
    end
  end
  return "new"
end

local function convertCT()
  for line in io.lines("Y:/Minecraft/OC-Scripts/recipes.log") do
    --print(line)
    line = line:gsub("recipes.addShaped%(\"","{__oo__"):gsub("recipes.addShapeless%(\"","{__oo__"):gsub("\", <","__oo__, <"):gsub("\"",""):gsub("__oo__","\""):gsub("%);","}"):gsub("%)",")\""):gsub("%.withTag%(",", \"withTag("):gsub("<","\""):gsub(">","\""):gsub("%[","{"):gsub("%]","}"):gsub(" %*",", "):gsub(" %| ", ", "):gsub("%)\"_",")_")
    print(line)
    local b = mf.serial.unserialize(line)
    if b ~= nil then
      if #b >= 3 then
        local temp = b[2]:gsub(":", "_jj_"):gsub("/", "_xx_"):gsub("-", "_qq_"):gsub("%.", "_vv_")
        local ttag = ""
        if type(b[3]) == "string" then
          if mf.startswith(b[3], "withTag") then
            ttag = b[3]:gsub("withTag", "__wt")
            --temp = temp .. ttag:gsub(" ", "_"):gsub(":", "_bb_"):gsub("{", "_so_"):gsub("}", "_sc_"):gsub("%(", "_ro_"):gsub("%)", "_rc_"):gsub(",", "_co_"):gsub("-", "_bi_")
          end
        end
        res[temp] = {craftCount=1, recipe={}, tag=ttag}
        for i = 3, 5, 1 do if type(b[i]) == "number" then res[temp].craftCount = b[i] break end end
        for i = 3, 5, 1 do
          if type(b[i]) == "table" then
            local recipe = {}
            local name = ""
            if type(b[i][1]) ~= "table" then
              b[i] = {b[i]}
            end
            for a,e in pairs(b[i]) do
              for c,d in pairs(e) do
                d = tostring(d)
                if mf.startswith(d,"withTag") == false and tonumber(d) == nil then
                  name = d:gsub(":", "_jj_"):gsub("/", "_xx_"):gsub("-", "_qq_"):gsub("%.", "_vv_")
                  local temptag = ""
                  local need = 1
                  if e[c + 1] ~= nil then
                    if tonumber(e[c + 1]) ~= nil then
                      need = tonumber(e[c + 1])
                    elseif mf.startswith(e[c + 1],"withTag") then
                      temptag = e[c + 1]
                      name = name .. temptag:gsub("withTag", "__wt"):gsub(" ", "_"):gsub(":", "_bb_"):gsub("{", "_so_"):gsub("}", "_sc_"):gsub("%(", "_ro_"):gsub("%)", "_rc_"):gsub(",", "_co_"):gsub("-", "_bi_")
                    end
                  end
                  if recipe[name] == nil then
                    recipe[name] = {need=need, tag=temptag:gsub("withTag", "")}
                  else
                    recipe[name].need = recipe[name].need + need
                  end
                end
              end
            end
            table.insert(res[temp].recipe, recipe)
            break
          end
        end
      end
    end
  end
  mf.WriteObjectFile(res,"C:/Users/alexandersk/workspace/OC-Scripts/src/ct.txt")
  print("DONE CONVERTING")
end
local function getAllItems()
  local bitems = {}
  for line in io.lines("Y:/Minecraft/OC-Scripts/items.log") do
    line = line:gsub("\"",""):gsub("<",""):gsub(">",""):gsub("%.withTag", "?")
    line = mf.split(line, "?")--
    local tag = ""
    if line[2] ~= nil then
      tag = line[2]
    end
    local isc = findSC(mf.split(line[1], ":")[1])
    if mf.containsKey(bitems, isc) == false then
        bitems[isc] = {}
    end
    if mf.containsKey(items, isc) == false then
        items[isc] = {}
    end
    local name = line[1]:gsub(":", "_jj_"):gsub("/", "_xx_"):gsub("-", "_qq_"):gsub("%.", "_vv_")
    local found = false
    if mf.containsKey(items[isc], name) then
      found = true
      if tag ~= "" then
        if items[isc][name].tag ~= tag then
          for i = 1, 20000, 1 do
            if mf.containsKey(items[isc], name .. "_b_" .. i) then
              if items[isc][name .. "_b_" .. i].tag == tag then
                break
              end
            else
              name = name .. "_b_" .. i
              found = false
              break
            end
          end
        end
      end
    end
    if found == false then
      print("     Creating Item (" .. isc .. "): " .. name)
      items[isc][name] = {c1="",c2="",c3="",hasPattern=false,maxCount=1,tag=tag}
      --bitems[isc][name] = {c1="",c2="",c3="",hasPattern=false,maxCount=1,tag=tag}
    else
      print("Found Item (" .. isc .. "): " .. name)
    end
  end
--  for i,j in pairs(bitems) do
--    if mf.getCount(j) == 0 then
--      bitems[i] = nil
--    end
--  end
  --mf.WriteObjectFile(bitems, "Y:/Minecraft/OC-Scripts/ConvertedItems.lua", 3)
end
local function WriteItemFiles()
  mf.WriteObjectFile(items, "Y:/Minecraft/OC-Scripts/ConvertedItems.lua", 3)
  local templines = {}
  for line in io.lines("Y:/Minecraft/OC-Scripts/ConvertedItems.lua") do
    local l = line:gsub("={c1=\"", "    ={c1=\"    "):gsub("\",c2=\"", "    '\",c2=\"    "):gsub("\",c3=\"", "    '\",c3=\"    "):gsub("\",hasPattern=", "    '\",hasPattern=    "):gsub(",maxCount=", "    ,maxCount=    "):gsub(",tag=\"", "    ,tag=\"    "):gsub("\"}", "    '\"}    ")
    table.insert(templines, l)
  end
  local newLuaFile = mf.io.open("Y:/Minecraft/OC-Scripts/ConvertedItems.lua", "w")
  for i,j in pairs(templines) do
    newLuaFile:write(j .. "\n")
  end
  newLuaFile:close()
  templines = nil
  
--  for i,j in pairs(items) do
--    local temp={}
--    for a,b in pairs(j) do
--      temp[a] = {hasPattern=b.hasPattern, maxCount=b.maxCount}
--    end
--    mf.WriteObjectFile(temp, "Y:/Minecraft/OC-Scripts/Crafter/ItemsNew/" .. i .. ".lua", 2)
--  end
end
local mod_sc = {}
for a,b in pairs(sc) do
  for c,d in pairs(b) do
    mod_sc[d] = a
  end
end
mf.WriteObjectFile(mod_sc, "Y:/Minecraft/OC-Scripts/Mods.lua", 2)
--mf.WriteObjectFile(items, "Y:/Minecraft/OC-Scripts/ConvertedItems.lua", 3)
--print(findSC("thermalfoundation"))
--getAllItems()
--WriteItemFiles()
--convertCT()
--mf.printx(mf.listFilesInDir("C:/Users/alexandersk/workspace/OC-Scripts/src/"))