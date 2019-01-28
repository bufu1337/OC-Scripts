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
local function getItem(arr)

end
local function convertCT()
  local invalid_recipes = {}
  local additional_recipes = {}
  for line in io.lines("C:/Users/alexandersk/workspace/OC-Scripts/src/recipes.log") do
    --print(line)
    line = line:gsub("recipes.addShaped%(\"","{__oo__"):gsub("recipes.addShapeless%(\"","{__oo__"):gsub("\", <","__oo__, <"):gsub("\"",""):gsub("__oo__","\""):gsub("%);","}"):gsub("%)",")\""):gsub("%.withTag%(",", \"withTag("):gsub("<","\""):gsub(">","\""):gsub("%[","{"):gsub("%]","}"):gsub(" %*",", "):gsub(" %| ", ", "):gsub("%)\"_",")_"):gsub("null","\"null\"")
    print(line)
    local b = mf.serial.unserialize(line)
    if b ~= nil then
      if #b >= 3 then
        local name = b[2]:gsub(":", "_jj_"):gsub("/", "_xx_"):gsub("-", "_qq_"):gsub("%.", "_vv_")
        local ttag = ""
        local item_sc = findSC(mf.split(b[2], ":")[1])
        if type(b[3]) == "string" then
          if mf.startswith(b[3], "withTag") then
            ttag = b[3]:gsub("withTag", "")
            --temp = temp .. ttag:gsub(" ", "_"):gsub(":", "_bb_"):gsub("{", "_so_"):gsub("}", "_sc_"):gsub("%(", "_ro_"):gsub("%)", "_rc_"):gsub(",", "_co_"):gsub("-", "_bi_")
          end
        end
        local found = false
        if mf.containsKey(items[item_sc], name) then
          if ttag == items[item_sc][name].tag then
            found = true
          elseif mf.contains(wt[item_sc], name) then
            local i = 1
            while mf.containsKey(items[item_sc], name .. "_b_" .. i) and found == false do
              if ttag == items[item_sc][name .. "_b_" .. i].tag then
                found = true
                name = name .. "_b_" .. i
              else
                i = i + 1
              end
            end
          end
        end
        if found == false then
          print("Item not found: " .. name .. "    TAG: " .. ttag)
        else
          local additional_recipe = false
          local addcount = 1
          if items[item_sc][name].recipe ~= nil then
            additional_recipe = true
            if additional_recipes[item_sc] == nil then
              additional_recipes[item_sc] = {}
            end
            if additional_recipes[item_sc][name] == nil then
              additional_recipes[item_sc][name] = {{}}
            else
              addcount = #additional_recipes[item_sc][name] + 1
              additional_recipes[item_sc][name][addcount] = {}
            end
            additional_recipes[item_sc][name][addcount].craftCount = 1
            additional_recipes[item_sc][name][addcount].recipe = {}
            for i = 3, 4, 1 do if type(b[i]) == "number" then additional_recipes[item_sc][name][addcount].craftCount = b[i] break end end
          else
            items[item_sc][name].craftCount = 1
            items[item_sc][name].recipe = {}
            for i = 3, 4, 1 do if type(b[i]) == "number" then items[item_sc][name].craftCount = b[i] break end end
          end
          for i = 3, 5, 1 do
            if type(b[i]) == "table" then
              local recipe_full = true
              local rname = ""
              if type(b[i][1]) ~= "table" then
                b[i] = {b[i]}
              end
              for a,e in pairs(b[i]) do
                for c,d in pairs(e) do
                  d = tostring(d)
                  if mf.startswith(d,"withTag") == false and tonumber(d) == nil then
                    rname = d:gsub(":", "_jj_"):gsub("/", "_xx_"):gsub("-", "_qq_"):gsub("%.", "_vv_")
                    local temptag = ""
                    local ritem_sc = findSC(mf.split(d, ":")[1])
                    local need = 1
                    if rname ~= "null" then
                      if e[c + 1] ~= nil then
                        if tonumber(e[c + 1]) ~= nil then
                          need = tonumber(e[c + 1])
                        elseif mf.startswith(e[c + 1],"withTag") then
                          temptag = e[c + 1]:gsub("withTag", "")
                          if tonumber(e[c + 2]) ~= nil then
                            need = tonumber(e[c + 2])
                          end
                          --rname = rname .. temptag:gsub("withTag", ""):gsub(" ", "_"):gsub(":", "_bb_"):gsub("{", "_so_"):gsub("}", "_sc_"):gsub("%(", "_ro_"):gsub("%)", "_rc_"):gsub(",", "_co_"):gsub("-", "_bi_")
                        end
                      end
                      local rfound = false
                      if mf.containsKey(items[ritem_sc], rname) then
                        if temptag == items[ritem_sc][rname].tag then
                          rfound = true
                        elseif mf.contains(wt[ritem_sc], rname) then
                          local i = 1
                          while mf.containsKey(items[ritem_sc], rname .. "_b_" .. i) and rfound == false do
                            if temptag == items[ritem_sc][rname .. "_b_" .. i].tag then
                              rfound = true
                              rname = rname .. "_b_" .. i
                            else
                              i = i + 1
                            end
                          end
                        end
                      end
                      if rfound == false then
                        print("Recipe-Item not found: " .. rname .. "    TAG: " .. temptag)
                        recipe_full = false
                      end
                      if additional_recipe then
                        if additional_recipes[item_sc][name][addcount].recipe[rname] == nil then
                          additional_recipes[item_sc][name][addcount].recipe[rname] = {need=need, tag=temptag}
                        else
                          additional_recipes[item_sc][name][addcount].recipe[rname].need = additional_recipes[item_sc][name][addcount].recipe[rname].need + need
                        end
                      else
                        if items[item_sc][name].recipe[rname] == nil then
                          items[item_sc][name].recipe[rname] = {need=need, tag=temptag}
                        else
                          items[item_sc][name].recipe[rname].need = items[item_sc][name].recipe[rname].need + need
                        end
                      end
                    end
                  end
                end
              end
              if recipe_full == false or mf.getCount(items[item_sc][name].recipe) == 0 then
                if invalid_recipes[item_sc] == nil then
                  invalid_recipes[item_sc] = {}
                end
                invalid_recipes[item_sc][name] = mf.copyTable(items[item_sc][name])
                items[item_sc][name].recipe = nil
              end
            end
          end
        end
      end
    end
  end
  mf.WriteObjectFile(items,"C:/Users/alexandersk/workspace/OC-Scripts/src/ItemsWithRecipes.lua", 3)
  mf.WriteObjectFile(invalid_recipes,"C:/Users/alexandersk/workspace/OC-Scripts/src/InvalidRecipes.lua", 3)
  mf.WriteObjectFile(additional_recipes,"C:/Users/alexandersk/workspace/OC-Scripts/src/AdditionalRecipes.lua", 4)
  local irnames = {}
  for a,b in pairs(invalid_recipes) do
    for e,f in pairs(b) do
      for c,d in pairs(f.recipe) do
        if mf.containsKey(items[findSC(mf.split(c:gsub("_jj_", ":"), ":")[1])], c) == false then
          irnames[c] = ""
        end
      end
    end
  end
  mf.WriteObjectFile(irnames,"C:/Users/alexandersk/workspace/OC-Scripts/src/InvalidRecipeNames.lua", 2)
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
--local mod_sc = {}
--for a,b in pairs(sc) do
--  for c,d in pairs(b) do
--    mod_sc[d] = a
--  end
--end
--mf.WriteObjectFile(mod_sc, "Y:/Minecraft/OC-Scripts/Mods.lua", 2)
--mf.WriteObjectFile(items, "Y:/Minecraft/OC-Scripts/ConvertedItems.lua", 3)
--print(findSC("thermalfoundation"))
--getAllItems()
--WriteItemFiles()
convertCT()
--mf.printx(mf.listFilesInDir("C:/Users/alexandersk/workspace/OC-Scripts/src/"))