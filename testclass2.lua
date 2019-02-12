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
  local returning = "new"
  for a,b in pairs(sc) do
    for i,j in pairs(b) do
      if j == mod then
        returning = a
      end
    end
  end
  return returning
end
local function getItem(arr)

end
local function convertCT()
  local invalid_recipes = {}
  local additional_recipes = {}
  local irnames = {}--mf.combineTables(require("InvalidRecipeNames"), require("IRNames"))
  for line in io.lines("Y:/Minecraft/OC-Scripts/recipes.log") do
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
                        if irnames[rname] ~= nil and irnames[rname] ~= "" then
                          rname = irnames[rname]
                          print("Recipe-Item found IN IR: " .. rname)
                        else
                          print("Recipe-Item not found: " .. rname .. "    TAG: " .. temptag)
                          recipe_full = false
                        end
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
                --items[item_sc][name].craftCount = 0
                --items[item_sc][name].recipe = {}
              end
            end
          end
        end
      end
    end
  end
  for a,b in pairs(items) do
    for e,f in pairs(b) do
      if mf.containsKeys(f, {"craftCount", "recipe"}) == false then
        items[a][e].craftCount = 0
        items[a][e].recipe = {}
      end
    end
  end
  mf.WriteObjectFile(items,"Y:/Minecraft/OC-Scripts/ItemsWithRecipes.lua", 3)
  mf.WriteObjectFile(invalid_recipes,"Y:/Minecraft/OC-Scripts/InvalidRecipes.lua", 3)
  mf.WriteObjectFile(additional_recipes,"Y:/Minecraft/OC-Scripts/AdditionalRecipes.lua", 4)
  for a,b in pairs(invalid_recipes) do
    for e,f in pairs(b) do
      for c,d in pairs(f.recipe) do
        if mf.containsKey(items[findSC(mf.split(c:gsub("_jj_", ":"), ":")[1])], c) == false and mf.containsKey(irnames, c) == false then
          irnames[c] = ""
        end
      end
    end
  end
  local tempir = {}
  mf.WriteObjectFile(irnames,"Y:/Minecraft/OC-Scripts/InvalidRecipeNames.lua", 2)
  for a,b in pairs(irnames) do
    if b ~= "" then
      tempir[a] = irnames[a]
      irnames[a] = nil
    end
  end
  mf.WriteObjectFile(irnames,"Y:/Minecraft/OC-Scripts/IRNames.lua", 2)
  mf.WriteObjectFile(tempir,"Y:/Minecraft/OC-Scripts/TempIRNames.lua", 2)
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
local function addcostcalc()
  local temp = {label="", selling=false, buying=false, fixedprice=false, group="", price=0, trader=0}
  for i,j in pairs(items) do
    for a,b in pairs(j) do
      items[i][a] = mf.combineTables(items[i][a], temp)
    end
  end
end
local function WriteItemsSC2()
  for i,j in pairs(items) do
    local temp={}
    local tempr={}
    for a,b in pairs(j) do
      if b.hasPattern then
        temp[a] = mf.copyTable(b, {"craftCount", "maxCount", "recipe"})
        for g,h in pairs(b.recipe) do
          if h.tag == "" then
            temp[a].recipe[g].tag = nil
          end
          local ck = mf.containsKey(j,g)
          if ck then
            if j[g].hasPattern == false then
              ck = false
            end
          end
          if ck == false then
            tempr[g] = {need=0}
          end
        end
      end
    end
    mf.WriteObjectFile(temp, "Y:/Minecraft/OC-Scripts/Crafter/Items/" .. i .. ".lua", 2)
    mf.WriteObjectFile(tempr, "Y:/Minecraft/OC-Scripts/Crafter/Items/" .. i .. "-RecipeItems.lua", 2)
  end
end
local function WriteItemFiles2()
  mf.WriteObjectFile(items, "Y:/Minecraft/OC-Scripts/ALL_Items.lua", 3)
  local templines = {}
  local tempjslines = {}
  local boolfirst = true
  for line in io.lines("Y:/Minecraft/OC-Scripts/ALL_Items.lua") do
    if boolfirst then
      table.insert(tempjslines, (line:gsub("return", "MC.Items = ")))
      boolfirst = false
    else
      table.insert(tempjslines, (line:gsub("=", ":")))
    end
    --{label="", selling=false, buying=false, fixedprice=false, group="", price=0, trader=0}
    local l = line:gsub("={buying=", "    ={buying=    "):gsub(",c1=\"", "    ,c1=\"    "):gsub("\",c2=\"", "    '\",c2=\"    "):gsub("\",c3=\"", "    '\",c3=\"    "):gsub("\",craftCount=", "    '\",craftCount=    "):gsub(",fixedprice=", "    ,fixedprice=    "):gsub(",group=\"", "    ,group=\"    "):gsub("\",hasPattern=", "    '\",hasPattern=    "):gsub(",label=\"", "    ,label=\"    "):gsub("\",maxCount=", "    '\",maxCount=    "):gsub(",price=", "    ,price=    "):gsub(",recipe=", "    ,recipe=    "):gsub("},selling=", "}    ,selling=    "):gsub(",tag=\"", "    ,tag=\"    "):gsub("\",trader=", "    '\",trader=    ") .. "\n"
    --local l = line:gsub("={c1=\"", "    ={c1=\"    "):gsub("\",c2=\"", "    '\",c2=\"    "):gsub("\",c3=\"", "    '\",c3=\"    "):gsub("\",craftCount=", "    '\",craftCount=    "):gsub(",hasPattern=", "    ,hasPattern=    "):gsub(",maxCount=", "    ,maxCount=    "):gsub(",recipe=", "    ,recipe=    "):gsub("},tag=\"", "}    ,tag=\"    ") .. "\n"
    l = l:gsub("},\n", "    },\n"):gsub("}\n", "    }\n")
    table.insert(templines, l)
  end
  local newLuaFile = mf.io.open("Y:/Minecraft/OC-Scripts/ConvertedItems.lua", "w")
  local newJSFile = mf.io.open("Y:/Minecraft/OC-Scripts/Costs Calculator/MC-ItemsTO.js", "w")
  for i,j in pairs(templines) do
    newLuaFile:write(j)
    newJSFile:write(tempjslines[i] .. "\n")
  end
  newLuaFile:close()
  newJSFile:close()
  templines = nil
  tempjslines = nil
  WriteItemsSC2()
end
local function WriteItemFiles()
  mf.WriteObjectFile(items, "Y:/Minecraft/OC-Scripts/ALL_Items.lua", 3)
  local templines = {}
  local tempjslines = {}
  local boolfirst = true
  for line in io.lines("Y:/Minecraft/OC-Scripts/ALL_Items.lua") do
    if boolfirst then
      table.insert(tempjslines, line:gsub("return", "MC.Items = "))
      boolfirst = false
    else
      table.insert(tempjslines, line:gsub("=", ":"))
    end
    
    local l = line:gsub("={c1=\"", "    ={c1=\"    "):gsub("\",c2=\"", "    '\",c2=\"    "):gsub("\",c3=\"", "    '\",c3=\"    "):gsub("\",hasPattern=", "    '\",hasPattern=    "):gsub(",maxCount=", "    ,maxCount=    "):gsub(",tag=\"", "    ,tag=\"    "):gsub("\"},\n", "    '\"},\n"):gsub("\"}\n", "    '\"}\n")
    table.insert(templines, l)
  end
  local newLuaFile = mf.io.open("Y:/Minecraft/OC-Scripts/ConvertedItems.lua", "w")
  local newJSFile = mf.io.open("Y:/Minecraft/OC-Scripts/Costs Calculator/MC-ItemsTO.js", "w")
  for i,j in pairs(templines) do
    newLuaFile:write(j .. "\n")
    newJSFile:write(tempjslines[i] .. "\n")
  end
  newLuaFile:close()
  newJSFile:close()
  templines = nil
  tempjslines = nil
  WriteItemsSC2()
end
local function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end
local function combinePatternCheck()
  for a,b in pairs(items) do
    if file_exists("Y:/Minecraft/OC-Scripts/Crafter/PatternCheck/" .. a .. "_check.lua") then
      local checkeditems = require("Crafter/PatternCheck/" .. a .. "_check")
      for c,d in pairs(b) do
        if checkeditems[c] ~= nil then
          if items[a][c].hasPattern == true and checkeditems[c] == false then
            print("                  ITEM: " .. c .. "       LOST PATTERN")
          end
          if items[a][c].hasPattern == false and checkeditems[c] == true then
            --print("ITEM: " .. c .. "    gets a Pattern")
          end
          items[a][c].hasPattern = checkeditems[c]
        end
      end
    end
  end
end
local function WriteItemsSC()
  for i,j in pairs(items) do
    local temp={}
    for a,b in pairs(j) do
      if mf.contains(a, "_b_") == false then
        temp[a] = b
      end
    end
    mf.WriteObjectFile(temp, "Y:/Minecraft/OC-Scripts/Crafter/ItemsNew/" .. i .. ".lua", 2)
  end
end
local function irnamesCorrect()
  local templines = {}
  local counter = 0
  local counter2 = 0
  local irn = require("IRNames2")
  for line in io.lines("C:/Users/alexandersk/workspace/OC-Scripts/src/newItems.txt") do
    counter2 = counter2 + 1
    print("Line: " .. tostring(counter2))
    for i,j in pairs(irn) do
      if mf.contains(line,"%[\"" .. i:sub(0,#i - 1) .. "%*\"%]") then
        line = line:gsub("%[\"" .. i:sub(0,#i - 1) .. "%*\"%]", i:sub(0,#i - 5))
        counter = counter + 1
      end
    end
    table.insert(templines, line)
  end
  print("Replaced: " .. tostring(counter))
  local newLuaFile = mf.io.open("C:/Users/alexandersk/workspace/OC-Scripts/src/newItems2.txt", "w")
  for i,j in pairs(templines) do
    newLuaFile:write(j .. "\n")
  end
  newLuaFile:close()
  templines = nil
end
addcostcalc()
WriteItemFiles2()
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
--WriteItemsSC()
--convertCT()
--combinePatternCheck()
--WriteItemFiles2()
--mf.printx(mf.listFilesInDir("C:/Users/alexandersk/workspace/OC-Scripts/src/"))