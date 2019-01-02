local event = require("event")
local io = require("io")
local sides = require("sides")
local os = require("os")
local filesystem = require("filesystem")
local component = require("component")
local serial = require("serialization")
local convert = require("Convert")
local prox = require("Proxies")
local mD = require("bufu/Crafter/getMaxDamage")
local mf = require("MainFunctions")
local thread = require("thread")
local shell = require("shell")
local items = {}
local recipeitems = {}
local priocount = 0
local crafter = ""
local ac = {}
local args = shell.parse( ... )
local itemschange = false
local logfile = "/home/bufu/Crafter/AC-Log.lua"


local function searchforRepo(itemrepo)
  for b = 1, 30, 1 do
    local s = ""
    if b ~= 1 then
      s = tostring(b)
    end
    if filesystem.exists("/home/bufu" .. s .. "/Crafter/Items/" .. itemrepo .. ".lua") == true then
      return "bufu" .. s .. "/Crafter/Items/" .. itemrepo
    end
  end
  return ""
end
local function Define(itemrepo)
  local repo = searchforRepo(itemrepo)
  crafter = itemrepo
  if repo ~= "" then
    items = require(repo)
    if filesystem.exists("/home/" .. repo .. " - RecipeItems" .. ".lua") == true then
      recipeitems = require(repo .. " - RecipeItems")
    end
    logfile = "/home/bufu/Crafter/AC-Log  - " .. itemrepo .. ".lua"
    for i,j in pairs(items) do
      if j.craftCount == nil then
        items[i].craftCount = 1
      end
    end
  end
end
local function DefineEx(itemsToCraft, recipeitemsForCraft, craftmech)
  crafter = craftmech
  items = itemsToCraft
  recipeitems = recipeitemsForCraft
  logfile = "/home/bufu/Crafter/AC-Log  - " .. craftmech .. ".lua"
  for i,j in pairs(items) do
    if j.craftCount == nil then
      items[i].craftCount = 1
    end
  end
end
local function ConvertItems()
  print("ConvertItems")
  for i,j in pairs(items) do
    print("Convert: " .. i)
    if j ~= nil then
      if j.name == nil then
          local converted = convert.TextToItem(i)
          for x,y in pairs(converted) do
            items[i][x] = y
          end
      end
    else
      print("is null")
    end
  end
  for i,j in pairs(recipeitems) do
    print("Convert: " .. i)
    if j ~= nil then
      if j.name == nil then
          local converted = convert.TextToItem(i)
          for x,y in pairs(converted) do
            items[i][x] = y
          end
      end
    else
      print("is null")
    end
  end
  print("ConvertItems End")
end
local function GetStorageItems()
  print("GetStorageItems")
  local itemcounter = 0
  local co = 1
  local iarr = {}
  local th = {}
  for i,j in pairs(items) do
    if j.size == nil then
        itemcounter = itemcounter + 1
        if (itemcounter > 50) then
          itemcounter = 1
          co = co + 1
        end
        if iarr[co] == nil then
            iarr[co] = {}
        end
        iarr[co][itemcounter] = i
    end
  end
  local ttable = {}
  for v = 1, co, 1 do
    th[v] = thread.create(function(o, u)
      for v = 1, u, 1 do
        os.sleep()
      end
      for i,j in pairs(o) do
        local rs_item = {}
        local rs_proxy = prox.GetProxy(items[j]["mod"], "home")
        if(rs_proxy ~= "") then
          local rs_comp = component.proxy(rs_proxy)
          if(rs_comp ~= nil) then
            rs_item = rs_comp.getItem(items[j])
            if(rs_item == nil) then
              rs_item = {size=0.0}
            end
          end
        end
        for a,b in pairs(rs_item) do
          items[j][a] = b
        end
      end
    end, iarr[v], v)
    table.insert(ttable, th[v])
  end
  thread.waitForAll(ttable)
  
  itemcounter = 0
  co = 1
  iarr = {}
  th = {}
  for i,j in pairs(recipeitems) do
    if j.size == nil then
        itemcounter = itemcounter + 1
        if (itemcounter > 50) then
          itemcounter = 1
          co = co + 1
        end
        if iarr[co] == nil then
            iarr[co] = {}
        end
        iarr[co][itemcounter] = i
    end
  end
  local ttable = {}
  for v = 1, co, 1 do
    th[v] = thread.create(function(o, u)
      for v = 1, u, 1 do
        os.sleep()
      end
      for i,j in pairs(o) do
        local rs_item = {}
        local rs_proxy = prox.GetProxy(recipeitems[j]["mod"], "home")
        if(rs_proxy ~= "") then
          local rs_comp = component.proxy(rs_proxy)
          if(rs_comp ~= nil) then
            rs_item = rs_comp.getItem(recipeitems[j])
            if(rs_item == nil) then
              rs_item = {size=0.0}
            end
          end
        end
        for a,b in pairs(rs_item) do
          recipeitems[j][a] = b
        end
      end
    end, iarr[v], v)
    table.insert(ttable, th[v])
  end
  thread.waitForAll(ttable)
  print("GetStorageItems end")
end
local function WriteNewRepo()
    local serial = require("serialization")
    local rep = searchforRepo(crafter)
    local newRepoFile = io.open("/home/bufu/Crafter/Items/" .. crafter .. ".lua", "w")
    local ikeys = mf.getSortedKeys(items)
    local tempitems = {}
    for ik = 1, #ikeys, 1 do
        tempitems[ikeys[ik]] = items[ikeys[ik]].size
        items[ikeys[ik]].name = nil
        items[ikeys[ik]].mod = nil
        items[ikeys[ik]].damage = nil
        items[ikeys[ik]].size = nil
    end
    if rep ~= "" then
      mf.WriteObjectFile(serial.serializedtable(items), "/home/".. rep .. ".lua")
      mf.WriteObjectFile(serial.serializedtable(recipeitems), "/home/".. rep .. " - RecipeItems" .. ".lua")
    end
    for ik = 1, #ikeys, 1 do
        items[ikeys[ik]].size = tempitems[ikeys[ik]]
    end
    tempitems = {}
end
local function GetRecipes()
    print("GetRecipes")
    local itemcounter = 0
    local co = 1
    local iarr = {}
    local th = {}
    for i,j in pairs(items) do
        if j.maxCount ~= nil then
            if j.recipe == nil then
                itemcounter = itemcounter + 1
                if (itemcounter > 50) then
                    itemcounter = 1
                    co = co + 1
                end
                if iarr[co] == nil then
                    iarr[co] = {}
                end
                iarr[co][itemcounter] = i
            end
        end
    end
    if itemcounter ~= 0 and co ~= 1 then
        itemschange = true
        local ttable = {}
        for v = 1, co, 1 do
            th[v] = thread.create(function(o, u)
                for v = 1, u, 1 do
                    os.sleep()
                end
                for i,j in pairs(o) do
                    local rs_proxy = prox.GetProxyByName(crafter, "craft")
                    if(rs_proxy ~= "") then
                        local rs_comp = component.proxy(rs_proxy)
                        if rs_comp ~= nil then
                            --local wcrafts = mf.MathUp((items[j].maxCount - items[j].size) / items[j].craftCount)
                            local cr_recipe = {}
                            local recipe_complete = true
                            local rs_recipe = rs_comp.getMissingItems(items[j], items[j].craftCount)
                            rs_recipe.n = nil
                            for g,h in pairs(rs_recipe) do
                                local item_found = false
                                local oname = convert.ItemToOName(rs_recipe[g])
                                cr_recipe[g] = {}
                                cr_recipe[oname].need = rs_recipe[g].size
                                cr_recipe[oname].label = rs_recipe[g].label
                                local maxDamage = mD.getMax(oname)
                                if maxDamage > 0 then
                                    local recipe_item_storage = component.proxy(prox.GetProxy(convert.TextToItem(rs_recipe[g].name).mod, "home"))
                                    if recipe_item_storage ~= nil then
                                        for hh = 0, maxDamage, 1 do
                                            rs_recipe[g].damage = hh
                                            local recipe_item = recipe_item_storage.getItem(rs_recipe[g])
                                            if recipe_item ~= nil then
                                                if recipe_item.label == cr_recipe[oname].label then
                                                    cr_recipe[oname] = nil
                                                    oname = convert.ItemToOName(rs_recipe[g])
                                                    cr_recipe[oname].need = rs_recipe[g].size 
                                                    cr_recipe[oname].label = rs_recipe[g].label                                                   
                                                    item_found = true
                                                    break
                                                end
                                            end
                                        end
                                    end
                                else
                                    item_found = true
                                end
                                if item_found then
                                    if recipeitems[oname] == nil then
                                      local temp = {}
                                      local c = prox.ModToPName(convert.TextToItem(rs_recipe[g].name).mod)
                                      local repo = searchforRepo(c)
                                      if repo ~= "" then
                                        temp = require(repo)
                                      end
                                      if temp[oname] == nil then
                                        c = nil
                                      end
                                      temp = {}
                                      recipeitems[oname] = {crafter = c}
                                    end
                                else
                                    print("Item " .. oname .. " has more then 1 damage, place " .. cr_recipe[oname].label .. " into your storage to get the correct recipe")
                                    recipe_complete = false
                                end
                            end
                            if recipe_complete then
                                items[j].recipe = {}
                                for k,h in pairs(mf.getKeys(cr_recipe)) do
                                  items[j].recipe[h] = {}
                                  for l,m in pairs(mf.getKeys(cr_recipe[h])) do
                                    items[j].recipe[h][m] = cr_recipe[h][m]
                                  end 
                                end
                            end
                            
                            --get CraftCount
                            for cc = 2, 64, 1 do
                              local rs_recipe = rs_comp.getMissingItems(items[j], cc)
                              local more = true
                              rs_recipe.n = nil
                              for g,h in pairs(rs_recipe) do
                                local oname = convert.ItemToOName(rs_recipe[g])
                                local maxDamage = mD.getMax(oname)
                                if maxDamage > 0 then
                                    local recipe_item_storage = component.proxy(prox.GetProxy(convert.TextToItem(rs_recipe[g].name).mod, "home"))
                                    if recipe_item_storage ~= nil then
                                        for hh = 0, maxDamage, 1 do
                                            rs_recipe[g].damage = hh
                                            local recipe_item = recipe_item_storage.getItem(rs_recipe[g])
                                            if recipe_item ~= nil then
                                                if recipe_item.label == rs_recipe[g].label then
                                                    oname = convert.ItemToOName(rs_recipe[g])
                                                    break
                                                end
                                            end
                                        end
                                    end
                                end
                                if rs_recipe[g].size ~= items[j].recipe[oname].need then
                                  more = false
                                  break
                                end
                              end
                              if more then
                                items[j].craftCount = items[j].craftCount + 1
                              else
                                break
                              end
                            end
                        end
                    end
                end
            end, iarr[v], v)
            table.insert(ttable, th[v])
        end
        thread.waitForAll(ttable)
        WriteNewRepo()
        ConvertItems()
        GetStorageItems()
    end
    print("GetRecipes end")
end
local function SetCrafts(item)
    if(item ~= nil)then
        if items[item].recipe ~= nil then
            local proceed = true
            items[item].crafts = mf.MathUp((items[item].maxCount - items[item].size) / items[item].craftCount) * items[item].craftCount
            if items[item].need ~= nil then
              items[item].crafts = items[item].crafts + (mf.MathUp(items[item].need / items[item].craftCount) * items[item].craftCount)
            end
            for a,b in pairs(items[item].recipe) do
                if recipeitems[a] ~= nil then
                  if recipeitems[a].need ~= nil then
                    recipeitems[a].need = recipeitems[a].need + (items[item].crafts * b.need)
                  else
                    recipeitems[a].need = items[item].crafts * b.need
                  end
                end
            end
            for a,b in pairs(items[item].recipe) do
                if recipeitems[a] ~= nil then
                    local tempcrafts = math.floor(recipeitems[a].newsize / b.need)
                    if tempcrafts < items[item].crafts then
                        items[item].crafts = tempcrafts
                    end
                else
                    print("Cant find in itemsrepo: " .. a)
                    proceed = false
                    items[item].crafts = nil
                end
            end
            if proceed then
                for a,b in pairs(items[item].recipe) do
                    items[item].recipe[a].size = items[item].crafts * b.need
                    recipeitems[a].newsize = recipeitems[a].newsize - items[item].recipe[a].size
                end
                print(item .. ": SetCraft = " .. items[item].crafts)
            end
        end
    end
end
local function CalculateCrafts()
    print("CalculateCrafts")
    for i,j in pairs(items) do
      items[i]["newsize"] = j.size
    end
    for i,j in pairs(recipeitems) do
      recipeitems[i]["newsize"] = j.size
    end
    for i,j in pairs(items) do
        SetCrafts(i)
    end
end
local function MoveItem(item, count, route)
    local r = 1
    while r <= #route do
        local storage = component.proxy(route[r].proxy)
        while count > 0 do
            local dropped = storage.extractItem(item, count, route[r].side)
            if dropped ~= nil then
                count = count - dropped
            end
        end
        r = r + 1
    end
end
local function MoveRecipeItems(item)
    for i,j in pairs(items[item].recipe) do
        MoveItem(items[j.oname], j.size, (prox.GetRoute((convert.TextToItem(j.oname).mod), "craft", crafter, 2)))
    end
end
local function MoveCraftedItem(item)
    MoveItem(items[item], items[item].crafts, (prox.GetRoute(crafter, "home", items[item].mod, 1)))
end
local function MoveRestBack()
    local rest_items = component.proxy(prox.GetProxByName(crafter, "craft").proxy).getItems()
    local num_ritems = #rest_items
    for i = 1, num_ritems, 1 do
        local converted = convert.ItemToOName(rest_items[i])
        rest_items[converted] = convert.TextToItem(converted)
        rest_items[converted].size = rest_items[i].size
    end
    for i = 1, num_ritems, 1 do
        rest_items[i] = nil
    end
    rest_items.n = nil
    for i,j in pairs(rest_items) do
        MoveItem(j, j.size, (prox.GetRoute(crafter, "home", j.mod, 1)))
    end
end
local function CraftItems()
    local cr = component.proxy(prox.GetProxyByName(crafter,"craft"))
    for i,j in pairs(items) do
        if j.crafts ~= nil and j.crafts ~= 0 then
            print("Crafting Item: " .. i .. " Crafts: " .. j.crafts)
            MoveRecipeItems(i)
            cr.scheduleTask(j, j.crafts)
            local tasks = cr.getTasks()
            while #tasks > 0 do
                os.sleep(1)
                tasks = cr.getTasks()
                if (tasks == nil) then
                    tasks = {}
                end
            end
            items[i].newsize = items[i].newsize + j.crafts
            items[i].size = items[i].newsize
            MoveCraftedItem(i)
        end 
    end
    MoveRestBack()
end
local function GetItems()
    print("GetItems")
    ConvertItems()
    GetStorageItems()
    GetRecipes()
    CalculateCrafts()
end
local function GetRecipeCraftings()
  local recipecrafting = {}
  for i,j in pairs(recipeitems) do
    if j.crafter ~= nil then
      if recipecrafting[j.crafter] == nil then
        recipecrafting[j.crafter] = {items={}, recipeitems={}}
      end
      recipecrafting[j.crafter].items[i] = j
    end
  end
  for i,j in pairs(recipecrafting) do
    local temp = {}
    local temp2 = {}
    local repo = searchforRepo(i)
    if repo ~= "" then
      temp = require(repo)
    end
    if filesystem.exists("/home/" .. repo .. " - RecipeItems" .. ".lua") == true then
      temp2 = require(repo .. " - RecipeItems")
    end
    for a,b in pairs(j.items) do
      recipecrafting[i].items[a].maxCount = temp[a].maxCount
      recipecrafting[i].items[a].craftCount = temp[a].craftCount
      recipecrafting[i].items[a].recipe = mf.copyTable(temp[a].recipe)
      for c,d in pairs(b.recipe) do
        recipecrafting[i].recipeitems[c] = mf.copyTable(temp2[c])
      end
    end
    temp = {}
    temp2 = {}
  end
  local tempitems = mf.copyTable(items)
  local temprecipeitems = mf.copyTable(recipeitems)
  local temppriocount = priocount
  local tempcrafter = crafter
  local tempitemschange = itemschange
  
  for i,j in pairs(recipecrafting) do
    DefineEx(j.items, j.recipeitems, i)
    GetItems()
    CraftItems()
  end
  for i,j in pairs(items) do
    temprecipeitems[i].newsize = items[i].newsize
    temprecipeitems[i].size = items[i].size
  end
  
  items = mf.copyTable(tempitems)
  tempitems = {}
  recipeitems = mf.copyTable(temprecipeitems)
  temprecipeitems = {}
  priocount = temppriocount
  crafter = tempcrafter
  itemschange = tempitemschange
end
local function Craft(itemrepo)
  Define(itemrepo)
  GetItems()
  GetRecipeCraftings()
  CalculateCrafts()
  CraftItems()
end

if args[1] ~= nil and args[1]:find("Autocraft") == nil then
    Craft(args[1])
end

ac.Craft = Craft
ac.Define = Define
ac.ConvertItems = ConvertItems
ac.GetStorageItems = GetStorageItems
ac.GetRecipes = GetRecipes
ac.CalculateCrafts = CalculateCrafts
ac.CraftItems = CraftItems
ac.MoveRestBack = MoveRestBack
ac.items = function() return items end
return ac

--local function GetRecipeCounts()
--  print("GetRecipeCounts")
--  local temp = {}
--  for i,j in pairs(items) do
--    --print("Getting RecipeCounts: " .. i)
--    if(items[i].recipe ~= nil)then
--      items[i]["recipeCounts"] = {}
--      for g,h in pairs(items[i].recipe) do
--        if(h ~= nil)then
--          local he = convert.TextToOName(h)
--          if (items[i].recipeCounts[he] == nil) then
--            items[i].recipeCounts[he] = 1
--          else
--            items[i].recipeCounts[he] = items[i].recipeCounts[he] + 1
--          end
--          if(items[he] == nil)then
--            table.insert(temp, he)
--          end
--        end
--      end
--    else
--      print("Has no Recipe: " .. i)
--    end
--  end
--  for ie,je in pairs(temp) do
--    items[je] = {}
--  end
--end
--local function GetStorageItems_old()
--  print("GetStorageItems")
--  for i,j in pairs(items) do
--    print("RS-GetItem: " .. j.name .. " Damage: " .. j.damage)
--    local rs_p = prox.GetProxy(j.mod, "home")
--    if rs_p == "" then
--      print("Cant find proxy for: " .. j.name .. " Damage: " .. j.damage)
--    else
--        local rs_nr = component.proxy(rs_p)
--        if rs_nr == nil then
--          print("Cant find component for proxy: " .. rs_p .. " Item:" .. j.name .. " Damage: " .. j.damage)
--        else
--            local rs_item = rs_nr.getItem(items[i])
--            if(rs_item == nil) then
--              print("Cant find item in system: " .. j.name .. " Damage: " .. j.damage)
--              rs_item = {size=0.0}
--            end
--            for a,b in pairs(rs_item) do
--              items[i][a] = b
--            end
--        end
--    end
--  end
--  print("GetStorageItems End")
--end
--local function SetCanCraft_old(item)
--  local can = nil
--  if item ~= nil then
--    if items[item].recipe ~= nil then
--        print("Item has recipe")
--        for a,b in pairs(items[item].recipeCounts) do
--            print("recipeItem: " .. a)
--            SetCanCraft(a)
--            local h = math.floor(((items[a].newsize + items[a].canCraft) / b) * items[item].craftCount)
--            print("recipeItem: " .. a .. " canh:" .. h)
--            if((can == nil) or (can > h))then
--               can = h
--            end
--        end
--    end
--    if(can == nil)then
--      can = 0
--    end
--    items[item].canCraft = can
--    print(item .. ": CanCraft = " .. items[item].canCraft)
--  end
--end
--local function SetCanCraftALL_old()
--  print("SetCanCraftALL")
--  for ic,jc in pairs(items) do
--    SetCanCraft(ic)
--  end
--end
--local function SetCrafts_old(item)
--  if(items[item].recipeCounts ~= nil)then
--    local tocraft = mf.MathUp((items[item].maxCount - items[item].newsize) / items[item].craftCount)
--    SetCanCraft(item)
--    if(items[item].canCraft < tocraft)then
--      tocraft = items[item].canCraft
--    end
--    if(tocraft > 0)then
--      --print(item .. " tocraft: " .. tocraft)
--      items[item].crafts = items[item].crafts + tocraft
--      for a,b in pairs(items[item].recipeCounts) do
--        --print("setting size: " .. a .. " = " .. items[a].newsize)
--        items[a].newsize = items[a].newsize - (tocraft * b)
--        --print("new size: " .. a .. " = " .. items[a].newsize)
--      end
--      print("")
--      --print("setting size: " .. item .. " = " .. items[item].newsize)
--      items[item].newsize = items[item].newsize + (tocraft * items[item].craftCount)
--      --print("new size: " .. item .. " = " .. items[item].newsize)
--      print(item .. " craftstotal: " .. items[item].crafts)
--      --print("")
--      --print("")
--    end
--  end
--end
--local function RollBackCrafts_old()
--  print("RollBackCrafts")
--  for is,js in pairs(items) do
--    if(items[is].newsize < 0)then
--      for i,j in pairs(items) do
--        if(items[i].recipeCounts ~= nil)then
--          if(items[i].recipeCounts[is] ~= nil)then
--            local temp = (math.floor(items[is].newsize / items[i].recipeCounts[is]) * -1)
--            if(items[i].crafts > temp)then
--              items[i].crafts = items[i].crafts - temp
--              items[i].newsize = items[i].newsize - temp
--              --print("safgsdgdf size: ")
--              for a,b in pairs(items[i].recipeCounts) do
--                --print("setting size: " .. a .. " = " .. items[a].newsize)
--                items[a].newsize = items[a].newsize + (temp * b)
--                --print("new size: " .. a .. " = " .. items[a].newsize)
--              end
--              break
--            else
--              temp = items[i].crafts
--              items[i].crafts = 0
--              items[i].newsize = 0
--              --print("safgsdgdf size: ")
--              for a,b in pairs(items[i].recipeCounts) do
--                --print("setting size: " .. a .. " = " .. items[a].newsize)
--                items[a].newsize = items[a].newsize + (temp * b)
--                --print("new size: " .. a .. " = " .. items[a].newsize)
--              end
--            end
--          end
--        end
--      end
--    end
--  end
--end
--local function GetPrio(item)
--  local prio = 0;
--  if(items[item].recipeCounts ~= nil)then
--    for a,b in pairs(items[item].recipeCounts) do
--      if(items[a].recipeCounts ~= nil)then
--        GetPrio(a)
--        prio = items[a].prio + 1
--      end
--    end
--  end
--  if(prio > priocount)then
--    priocount = prio
--  end
--  items[item].prio = prio
--end
--local function GetPrios()
--  print("CalculateCrafts")
--  for i,j in pairs(items) do
--    GetPrio(i)
--  end
--end
-- local paths = {}
-- local rs = component.block_refinedstorage_interface
-- -- Print contents of `tbl`, with indentation.
-- -- `indent` sets the initial level of indentation.
-- function tprint (tbl, indent)
  -- if not indent then indent = 0 end
  -- for k, v in pairs(tbl) do
    -- formatting = string.rep("  ", indent) .. k .. ": "
    -- if type(v) == "table" then
      -- print(formatting)
      -- tprint(v, indent+1)
    -- elseif type(v) == 'boolean' then
      -- print(formatting .. tostring(v))      
    -- else
      -- print(formatting .. v)
    -- end
  -- end
-- end

-- -- Check if the file exist 
-- local function file_exist(path)
  -- local file = io.open(path)
 
  -- if (not file) then
    -- print("[ERROR]: No such file: " .. path .. ".")
    -- return false
  -- end
  -- io.close(file)
  -- return true
-- end

-- -- Load and parse the file, return a table with all the item to craft.
-- local function load_file(path)
  -- local crafts = {}
 
  -- for line in io.lines(path) do
    -- local n, c, l, f = line:match "(%S+)%s+(%d+)"
    -- l = n:match "(%u%S+)"
    -- f = n:match("(%l+:%l+)")
    -- if (l) then
      -- table.insert(crafts, { name = f, label = l, count = c, fullName = n })
    -- else
      -- table.insert(crafts, { name = f, count = c, fullName = n })
    -- end
  -- end
  -- return crafts
-- end

-- -- Check if a task have missing items.
-- local function is_missing_items(task)
  -- if (task.missing.n > 0) then
    -- return true
  -- end
  -- return false
-- end

-- -- Check if craft is already on the tasks' queue. 
-- local function craft_is_on_tasks(craft, tasks)
  -- for i, task in ipairs(tasks) do
    -- if craft.name == task.stack.name then
      -- local missing_items = rs.getMissingItems(task.stack, task.quantity)
      -- for j, item in ipairs(missing_items) do
        -- print("[WARNING]: Missing " .. item.size .. " " .. item.name)
      -- end
      -- return true
    -- end
  -- end
  -- return false
-- end

-- -- Craft an item
-- function craft_item(craft, tasks)
  -- local toCraft = tonumber(craft.count)

  -- if (rs.hasPattern(craft)) then
    -- if (not craft_is_on_tasks(craft, tasks)) then
      -- local rsStack = rs.getItem(craft)
      
      -- if (rsStack) then
        -- toCraft = toCraft - rsStack.size
      -- end
      -- if (toCraft > 0) then
        -- rs.craftItem(craft, toCraft)
      -- end
    -- end
  -- else
    -- print("[WARNING]: Missing pattern for: " .. craft.fullName .. ".")
  -- end 
-- end

-- function GetItemSizes(items)
  -- local rs_item = rs.getItem(item)
  -- local limit = tonumber(item.count)

  -- if (not rs_item) then
    -- return
  -- end
  -- while (rs_item.size > limit) do
    -- local dropped = rs.extractItem(rs_item, rs_item.size - limit, sides.down)

    -- rs_item.size = rs_item.size - dropped
    -- if (dropped < 1) then
      -- break
    -- end
  -- end
-- end

-- -- Destroy item
-- function destroy_item(item)
  -- local rs_item = rs.getItem(item)
  -- local limit = tonumber(item.count)

  -- if (not rs_item) then
    -- return
  -- end
  -- while (rs_item.size > limit) do
    -- local dropped = rs.extractItem(rs_item, rs_item.size - limit, sides.down)

    -- rs_item.size = rs_item.size - dropped
    -- if (dropped < 1) then
      -- break
    -- end
  -- end
-- end

-- local function do_crafting(file)
    -- GetItems(file)
-- end

-- Check the args
-- if (#args > 0) then
  -- paths[1] = os.getenv("PWD") .. "/" .. args[1]
  -- if not file_exist(paths[1]) then
    -- return
  -- end
-- else
  -- print("[ERROR]: Filename is needed.")
  -- return
-- end

-- The main loop ("Ctrl + C" to interrup the program)
-- while (true) do
    -- local items_path
    -- local crafts = load_file(paths[1])
    -- local tasks = rs.getTasks()
    -- local bin = nil

    -- -- Craft needed items
    -- for i, craft in ipairs(crafts) do
        -- craft_item(craft, tasks)
    -- end

    -- -- Event handler
    -- local id = event.pull(5, "interrupted")
    -- if (id == "interrupted") then
        -- print("Program stopped.")
        -- break
    -- end
-- end