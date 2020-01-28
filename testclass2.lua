local mf = require("MainFunctionsEclipse")
local items = require("Costs Calculator/ALL_Items")
local ocpath = {work="C:/Users/alexandersk/workspace/OC-Scripts/", home="Y:/Minecraft/OC-Scripts/"}
local working = "home"
local res = {}
local sc = {}
local wt = {}


local function isFile(name)
    if type(name)~="string" then return false end
    if not exists(name) then return false end
    local f = io.open(name)
    if f then
        f:close()
        return true
    end
    return false
end
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
  for line in io.lines(ocpath[working] .. "recipes.log") do
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
  mf.WriteObjectFile(items,ocpath[working] .. "ItemsWithRecipes.lua", 3)
  mf.WriteObjectFile(invalid_recipes,ocpath[working] .. "InvalidRecipes.lua", 3)
  mf.WriteObjectFile(additional_recipes,ocpath[working] .. "AdditionalRecipes.lua", 4)
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
  mf.WriteObjectFile(irnames,ocpath[working] .. "InvalidRecipeNames.lua", 2)
  for a,b in pairs(irnames) do
    if b ~= "" then
      tempir[a] = irnames[a]
      irnames[a] = nil
    end
  end
  mf.WriteObjectFile(irnames,ocpath[working] .. "IRNames.lua", 2)
  mf.WriteObjectFile(tempir,ocpath[working] .. "TempIRNames.lua", 2)
  print("DONE CONVERTING")
end

                  
local function getAllItems()
  local bitems = {}
  for m in pairs(items) do
    if mf.containsKey(bitems, m) == false then
        bitems[m] = {}
    end
    for i in pairs(items[m]) do
        bitems[m][i] = true
    end
  end
  for line in io.lines(ocpath[working] .. "names-new2.txt") do
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
      items[isc][name] = {bit=false,buying=false,c1="",c2="",c3="",chisel=false,craftCount=1,fixedprice=false,group="",hasPattern=true,label="",maxCount=8,price=0,recipe={},selling=false,tag=tag,trader=0}
      bitems[isc][name] = false
    else
      bitems[isc][name] = false
      print("Found Item (" .. isc .. "): " .. name)
    end
  end
  for m in pairs(bitems) do
    for i in pairs(bitems[m]) do
      if bitems[m][i] == true then
        items[m][i] = nil
        print("Not Found Item (" .. m .. "): " .. i)
      end
    end
  end
--  for i,j in pairs(bitems) do
--    if mf.getCount(j) == 0 then
--      bitems[i] = nil
--    end
--  end
  --mf.WriteObjectFile(bitems, ocpath[working] .. "ConvertedItems.lua", 3)
end
local function AddItemFields(tableWithFields)
  for g,h in pairs(tableWithFields) do
      for i,j in pairs(items) do
        for a,b in pairs(j) do
          if items[i][a][g] == nil then
            items[i][a][g] = h
          end
        end
      end
  end
end
local function WriteItemsSC2()
  local temprall={}
  for i,j in pairs(items) do
    local temp={}
    local tempr={}
    local tempall={}
    local tempfullall={}
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
          else
            if temprall[g] == nil then
              temprall[g] = h.need
            else
              if temprall[g] > h.need then
                temprall[g] = h.need
              end
            end
          end
          if ck == false then
            if tempr[g] == nil then
              tempr[g] = {need=h.need}
            else
              if tempr[g].need > h.need then
                tempr[g].need = h.need
              end
            end
          end
        end
      end
      if j.tag == "" then
        tempall[a] = mf.copyTable(b, {"hasPattern", "label"})
      else
        tempall[a] = mf.copyTable(b, {"hasPattern", "label", "tag"})
      end
      if mf.contains(a, "_b_", nil) == false then
        tempfullall[a] = mf.copyTable(b, {"hasPattern", "label", "recipe"})
      end
    end
    print("Save ModFiles: " .. i)
    mf.WriteObjectFile(temp, (ocpath[working] .. "Crafter/Items/" .. i .. ".lua"), 2)
    mf.WriteObjectFile(tempr, (ocpath[working] .. "Crafter/Items/" .. i .. "-RecipeItems.lua"), 2)
    mf.WriteObjectFile(tempall, (ocpath[working] .. "Crafter/ItemsAll/" .. i .. ".lua"), 2)
    mf.WriteObjectFile(tempfullall, (ocpath[working] .. "Crafter/ItemsFullAll/" .. i .. ".lua"), 2)
  end
  mf.WriteObjectFile(temprall, (ocpath[working] .. "Crafter/RecipeItemsAll.lua"), 2)
end
local function WriteItemFiles()
  mf.WriteObjectFile(items, (ocpath[working] .. "Costs Calculator/ALL_Items.lua"), 3)
  local templines = {}
  local tempjslines = {}
  local boolfirst = true
  for line in io.lines((ocpath[working] .. "Costs Calculator/ALL_Items.lua")) do
    if boolfirst then
      table.insert(tempjslines, (line:gsub("return", "MC.Items = ")))
      boolfirst = false
    else
      table.insert(tempjslines, (line:gsub("=", ":")))
    end
    --{label="", selling=false, buying=false, fixedprice=false, group="", price=0, trader=0}
    local l = line:gsub("={bit=", "\t={bit=\t"):gsub(",buying=", "\t,buying=\t"):gsub(",c1=\"", "\t,c1=\"\t"):gsub("\",c2=\"", "\t'\",c2=\"\t"):gsub("\",c3=\"", "\t'\",c3=\"\t"):gsub("\",chisel=", "\t'\",chisel=\t"):gsub(",countforprice=", "\t,countforprice=\t"):gsub(",craftCount=", "\t,craftCount=\t"):gsub(",fixedprice=", "\t,fixedprice=\t"):gsub(",group=\"", "\t,group=\"\t"):gsub("\",hasPattern=", "\t'\",hasPattern=\t"):gsub(",label=\"", "\t,label=\"\t"):gsub("\",maxCount=", "\t'\",maxCount=\t"):gsub(",price=", "\t,price=\t"):gsub(",recipe=", "\t,recipe=\t"):gsub("},selling=", "}\t,selling=\t"):gsub("false,tag=\"", "false\t,tag=\"\t"):gsub("true,tag=\"", "true\t,tag=\"\t"):gsub("\",trader=", "\t'\",trader=\t") .. "\n"
    --local l = line:gsub("={c1=\"", "    ={c1=\"    "):gsub("\",c2=\"", "    '\",c2=\"    "):gsub("\",c3=\"", "    '\",c3=\"    "):gsub("\",craftCount=", "    '\",craftCount=    "):gsub(",hasPattern=", "    ,hasPattern=    "):gsub(",maxCount=", "    ,maxCount=    "):gsub(",recipe=", "    ,recipe=    "):gsub("},tag=\"", "}    ,tag=\"    ") .. "\n"
    if mf.startswith(l, "  ") then
      l = l:sub(3,#l)
    elseif mf.startswith(l, " ") then
      l = l:sub(2,#l)
    end
    if mf.endswith(l, "={\n") then
      l = l .. "\n"
    end
    if (l == "},\n") or (l == "}\n") then
      l = "\n" .. l 
    else
      l = l:gsub("},\n", "\t},\n"):gsub("}\n", "\t}\n")
    end
    table.insert(templines, l)
  end
  templines[#templines] = "}"
  --local newLuaFile = mf.io.open((ocpath[working] .. "ConvertedItems.lua"), "w")
  local newJSFile = mf.io.open((ocpath[working] .. "Costs Calculator/MC-ItemsTO.js"), "w")
  for i,j in pairs(templines) do
    --newLuaFile:write(j)
    newJSFile:write(tempjslines[i] .. "\n")
  end
  --newLuaFile:close()
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
  local patterns_lost = {}
  local patterns_gained = {}
  for a,b in pairs(items) do
    if file_exists(ocpath[working] .. "Crafter/PatternCheck/" .. a .. "_PatternChecked.lua") then
      local checkeditems = require("Crafter/PatternCheck/" .. a .. "_PatternChecked")
      for c,d in pairs(b) do
        if checkeditems[c] ~= nil then
		  if items[a][c].hasPattern == true and checkeditems[c] == false then
			print("                  ITEM: " .. c .. "       LOST PATTERN")
		  end
		  if items[a][c].hasPattern == false and checkeditems[c] == true then
			print("ITEM: " .. c .. "    gets a Pattern")
		  end
		  items[a][c].hasPattern = checkeditems[c]
        end
      end
    end
  end
  mf.WriteObjectFile(patterns_lost, (ocpath[working] .. "Crafter/Patterns_lost.lua"))
  mf.WriteObjectFile(patterns_gained, (ocpath[working] .. "Crafter/Patterns_gained.lua"))
end
local function combineRecipeCheck()
  local patterns_lost = {}
  local patterns_gained = {}
  for a,b in pairs(items) do
    if file_exists(ocpath[working] .. "Crafter/RecipeCheck/" .. a .. "_RecipeChecked.lua") then
      local itemrecipecheck = require("Crafter/RecipeCheck/" .. a .. "_RecipeChecked.lua")
      for c,d in pairs(b) do
        if itemrecipecheck[c] ~= nil then
          if items[a][c].c3 ~= "" then
            items[a][c].c3 = items[a][c].c3 .. " --RecipeCheck: " .. itemrecipecheck[c]
          else
            items[a][c].c3 = " --RecipeCheck: " .. itemrecipecheck[c]
          end
        end
      end
    end
  end
end
local function combineLabels()
  local patterns_lost = {}
  local patterns_gained = {}
  for a,b in pairs(items) do
    if file_exists(ocpath[working] .. "Crafter/NewLabels/" .. a .. "_NewLabels.lua") then
      local itemlabels = require("Crafter/NewLabels/" .. a .. "_NewLabels.lua")
      for c,d in pairs(b) do
        if itemlabels[c] ~= nil then
          items[a][c].label = itemlabels[c]
        end
      end
    end
  end
end
local function combineFull()
    for i, j in pairs(items) do
        if file_exists(("Crafter/ItemsAllNew/" .. i .. ".lua")) then
            local temp = require("Crafter/ItemsAllNew/" .. i)
            for g, h in pairs(items[i]) do
                if temp[g] ~= nil then
                    items[i][g] = mf.combineTables(items[i][g], temp[g])
                end
            end
        end
    end
end
local function irnamesCorrect()
  local templines = {}
  local counter = 0
  local counter2 = 0
  local irn = require("IRNames2")
  for line in io.lines((ocpath[working] .. "newItems.txt")) do
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

--mf.WriteObjectFile(sc, (ocpath[working] .. "Mods.lua"), 3)
--getAllItems()
combineFull()
--AddItemFields({aspects={},oredict=false,processing=false})
WriteItemFiles()


--addcostcalc()
--local mod_sc = {}
--for a,b in pairs(sc) do
--  for c,d in pairs(b) do
--    mod_sc[d] = a
--  end
--end
--mf.WriteObjectFile(mod_sc, ocpath[working] .. "Mods.lua", 2)
--mf.WriteObjectFile(items, ocpath[working] .. "ConvertedItems.lua", 3)
--print(findSC("thermalfoundation"))
--
--WriteItemsSC()
--convertCT()
--combinePatternCheck()
--WriteItemFiles2()
--mf.printx(mf.listFilesInDir("C:/Users/alexandersk/workspace/OC-Scripts/src/"))