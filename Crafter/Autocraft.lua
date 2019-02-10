local ac = {}
ac.convert = require("bufu/Convert")
ac.prox = require("bufu/Proxies")
ac.mD = require("bufu/Crafter/getMaxDamage")
ac.mf = require("bufu/MainFunctions")
ac.items = {}
ac.recipeitems = {}
ac.priocount = 0
ac.crafter = ""
ac.itemcrafters = {}
ac.completeRepo = true
ac.itemschange = false
ac.logfile = "/home/bufu/Crafter/AC-Log.lua"
ac.args = ac.mf.shell.parse( ... )

function ac.searchforRepo(itemrepo)
  for b = 1, 30, 1 do
    local s = ""
    if b ~= 1 then
      s = tostring(b)
    end
    if ac.mf.filesystem.exists("/home/bufu" .. s .. "/Crafter/Items/" .. itemrepo .. ".lua") == true then
      return "bufu" .. s .. "/Crafter/Items/" .. itemrepo
    end
  end
  return ""
end
function ac.searchforRepoRecipe(itemrepo)
  for b = 1, 30, 1 do
    local s = ""
    if b ~= 1 then
      s = tostring(b)
    end
    if ac.mf.filesystem.exists("/home/bufu" .. s .. "/Crafter/Items/" .. itemrepo .. "-RecipeItems" .. ".lua") == true then
      return "bufu" .. s .. "/Crafter/Items/" .. itemrepo .. "-RecipeItems"
    end
  end
  return ""
end
function ac.getCrafter(oname)
  local temp = {}
  local c = ac.prox.ModToPName(ac.convert.TextToItem(oname).mod)
  local repo = ac.searchforRepo(c)
  if repo ~= "" then
    temp = require(repo)
  end
  if temp[oname] == nil then
    c = nil
  end
  temp = {}
  return c
end
function ac.Define(itemrepo)
  local repo = ac.searchforRepo(itemrepo)
  if repo ~= "" then
    ac.items = require(repo)
    if itemrepo == "conquest" then
      local repo2 = ac.searchforRepo(itemrepo .. "2")
      ac.items = ac.mf.combineTables(ac.items, require(repo2))
    end
    ac.crafter = ac.prox.ModToPName(ac.convert.TextToItem(ac.mf.getKeys(ac.items)[1]).mod)
    local reporecipe = ac.searchforRepoRecipe(itemrepo)
    if reporecipe ~= "" then
      ac.recipeitems = require(reporecipe)
    end
    ac.logfile = "/home/bufu/Crafter/AC-Log - " .. itemrepo .. ".lua"
    for i,j in pairs(ac.items) do
      if j.craftCount == nil then
        ac.items[i].craftCount = 1
      end
    end
  end
end
function ac.DefineEx(itemsToCraft, recipeitemsForCraft)
  ac.completeRepo = false
  ac.crafter = ac.prox.ModToPName(ac.convert.TextToItem(ac.mf.getKeys(ac.items)[1]).mod)
  ac.items = itemsToCraft
  ac.recipeitems = recipeitemsForCraft
  ac.logfile = "/home/bufu/Crafter/AC-Log - " .. ac.crafter .. ".lua"
  for i,j in pairs(ac.items) do
    if j.craftCount == nil then
      ac.items[i].craftCount = 1
    end
  end
end
function ac.DefineItems(itemsToCraft)
  for i,j in pairs(ac.mf.getKeys(itemsToCraft)) do
    local temp_item_crafter = ac.prox.ModToPName(ac.convert.TextToItem(j).mod)
    if ac.mf.containsKey(ac.itemcrafters, temp_item_crafter) then
      ac.itemcrafters[temp_item_crafter] = {items={}, ac.recipeitems{}}
    end
    ac.itemcrafters[temp_item_crafter].items[j] = itemsToCraft[j]
  end
  for i,j in pairs(ac.itemcrafters) do
    local repo = ac.searchforRepo(i)
    if repo ~= "" then
      local tempitems = require(repo)
      if i == "conquest" then
        local repo2 = ac.searchforRepo(i .. "2")
        tempitems = ac.mf.combineTables(tempitems, require(repo2))
      end
      for a,b in pairs(tempitems) do
        if j.items[a] == nil then
          tempitems[a] = nil
        end
      end
      ac.itemcrafters[i].items = ac.mf.combineTables(ac.itemcrafters[i].items, tempitems)
      tempitems = {}
      
      if ac.mf.filesystem.exists("/home/" .. repo .. "-RecipeItems" .. ".lua") == true then
        local temprecipeitemKeys = {}
        for a,b in pairs(ac.itemcrafters[i].items) do
          if b.recipe ~= nil then
            for c,d in pairs(b.recipe) do
              if ac.mf.contains(temprecipeitemKeys, c) == false then
                table.insert(temprecipeitemKeys, c)
              end
            end
          end
        end
        
        ac.itemcrafters[i].recipeitems = require(repo .. "-RecipeItems")
        for a,b in pairs(ac.itemcrafters[i].recipeitems) do
          if ac.mf.contains(temprecipeitemKeys, a) == false then
            ac.itemcrafters[i].recipeitems[a] = nil
          end
        end
      end
      ac.logfile = "/home/bufu/Crafter/AC-Log - items.lua"
      for i,j in pairs(ac.items) do
        if j.craftCount == nil then
          ac.items[i].craftCount = 1
        end
      end
    end
  end
end
function ac.ConvertItems()
  print("ConvertItems")
  for i,j in pairs(ac.items) do
    print("Convert: " .. i)
    if j ~= nil then
      if j.name == nil then
          local converted = ac.convert.TextToItem(i)
          for x,y in pairs(converted) do
            ac.items[i][x] = y
          end
      end
    else
      print("is null")
    end
  end
  for i,j in pairs(ac.recipeitems) do
    print("Convert: " .. i)
    if j ~= nil then
      if j.name == nil then
          local converted = ac.convert.TextToItem(i)
          for x,y in pairs(converted) do
            ac.recipeitems[i][x] = y
          end
      end
    else
      print("is null")
    end
  end
  print("ConvertItems End")
end
function ac.GetStorageItems()
  print("GetStorageItems")
  local itemcounter = 0
  local co = 1
  local iarr = {}
  local th = {}
  for i,j in pairs(ac.items) do
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
    th[v] = ac.mf.thread.create(function(o, u)
      for v = 1, u, 1 do
        ac.mf.os.sleep()
      end
      for i,j in pairs(o) do
        local rs_item = {}
        local rs_proxy = ac.prox.GetProxy(ac.items[j].mod, "home")
        if(rs_proxy ~= "") then
          local rs_comp = ac.mf.component.proxy(rs_proxy)
          if(rs_comp ~= nil) then
            rs_item = rs_comp.getItem(ac.items[j])
            if(rs_item == nil) then
              rs_item = {size=0.0}
            end
          end
        end
        for a,b in pairs(rs_item) do
          ac.items[j][a] = b
        end
      end
    end, iarr[v], v)
    table.insert(ttable, th[v])
  end
  ac.mf.thread.waitForAll(ttable)
  
  itemcounter = 0
  co = 1
  iarr = {}
  th = {}
  for i,j in pairs(ac.recipeitems) do
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
    th[v] = ac.mf.thread.create(function(o, u)
      for v = 1, u, 1 do
        ac.mf.os.sleep()
      end
      for i,j in pairs(o) do
        local rs_item = {}
        local rs_proxy = ac.prox.GetProxy(ac.recipeitems[j].mod, "home")
        if(rs_proxy ~= "") then
          local rs_comp = ac.mf.component.proxy(rs_proxy)
          if(rs_comp ~= nil) then
            rs_item = rs_comp.getItem(ac.recipeitems[j])
            if(rs_item == nil) then
              rs_item = {size=0.0}
            end
          end
        end
        for a,b in pairs(rs_item) do
          ac.recipeitems[j][a] = b
        end
      end
    end, iarr[v], v)
    table.insert(ttable, th[v])
  end
  ac.mf.thread.waitForAll(ttable)
  print("GetStorageItems end")
end
function ac.WriteNewRepo()
  local rep = ac.searchforRepo(ac.crafter)
  local reprec = ac.searchforRepoRecipe(ac.crafter)
  if rep ~= "" then
    if ac.completeRepo then
        local tempitemssize = {}
        local ikeys = ac.mf.getSortedKeys(ac.items)
        for ik = 1, #ikeys, 1 do
            tempitemssize[ikeys[ik]] = ac.items[ikeys[ik]].size
            ac.items[ikeys[ik]].name = nil
            ac.items[ikeys[ik]].mod = nil
            ac.items[ikeys[ik]].damage = nil
            ac.items[ikeys[ik]].size = nil
        end
        ac.mf.WriteObjectFile(ac.mf.serial.serializedtable(ac.items), "/home/".. rep .. ".lua")
        for ik = 1, #ikeys, 1 do
            ac.items[ikeys[ik]].size = tempitemssize[ikeys[ik]]
        end
        tempitemssize = {}
    else
        local tempitems = require(rep)
        tempitems = ac.mf.combineTables(tempitems, ac.items)
        local ikeys = ac.mf.getSortedKeys(tempitems)
        for ik = 1, #ikeys, 1 do
            tempitems[ikeys[ik]].name = nil
            tempitems[ikeys[ik]].mod = nil
            tempitems[ikeys[ik]].damage = nil
            tempitems[ikeys[ik]].size = nil
        end
        ac.mf.WriteObjectFile(ac.mf.serial.serializedtable(tempitems), "/home/".. rep .. ".lua")
        tempitems = {}
    end
  end
  if reprec ~= "" then
    if ac.completeRepo then
        local temprecipeitemssize = {}
        local rikeys = ac.mf.getSortedKeys(ac.recipeitems)
        for ik = 1, #rikeys, 1 do
            temprecipeitemssize[rikeys[ik]] = ac.recipeitems[rikeys[ik]].size
            ac.recipeitems[rikeys[ik]].name = nil
            ac.recipeitems[rikeys[ik]].mod = nil
            ac.recipeitems[rikeys[ik]].damage = nil
            ac.recipeitems[rikeys[ik]].size = nil
        end
        ac.mf.WriteObjectFile(ac.mf.serial.serializedtable(ac.recipeitems), "/home/".. reprec .. "-RecipeItems" .. ".lua")
        for ik = 1, #rikeys, 1 do
            ac.recipeitems[rikeys[ik]].size = temprecipeitemssize[rikeys[ik]]
        end
        temprecipeitemssize = {}
    else
      local temprecipeitems = require(rep)
        temprecipeitems = ac.mf.combineTables(temprecipeitems, ac.recipeitems)
        local ikeys = ac.mf.getSortedKeys(temprecipeitems)
        for ik = 1, #ikeys, 1 do
            temprecipeitems[ikeys[ik]].name = nil
            temprecipeitems[ikeys[ik]].mod = nil
            temprecipeitems[ikeys[ik]].damage = nil
            temprecipeitems[ikeys[ik]].size = nil
        end
        ac.mf.WriteObjectFile(ac.mf.serial.serializedtable(temprecipeitems), "/home/".. reprec .. "-RecipeItems" .. ".lua")
        temprecipeitems = {}
    end
  end
end
function ac.GetRecipes()
  print("GetRecipes")
  local itemcounter = 0
  local co = 1
  local iarr = {}
  local th = {}
  for i,j in pairs(ac.items) do
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
    ac.itemschange = true
    local ttable = {}
    for v = 1, co, 1 do
        th[v] = ac.mf.thread.create(function(o, u)
            for v = 1, u, 1 do
                ac.mf.os.sleep()
            end
            for i,j in pairs(o) do
                local rs_proxy = ac.prox.GetProxyByName(ac.crafter, "craft")
                if(rs_proxy ~= "") then
                    local rs_comp = ac.mf.component.proxy(rs_proxy)
                    if rs_comp ~= nil then
                        --local wcrafts = mf.MathUp((items[j].maxCount - items[j].size) / items[j].craftCount)
                        local cr_recipe = {}
                        local recipe_complete = true
                        local rs_recipe = rs_comp.getMissingItems(ac.items[j], ac.items[j].craftCount)
                        rs_recipe.n = nil
                        for g,h in pairs(rs_recipe) do
                            local item_found = false
                            local oname = ac.convert.ItemToOName(rs_recipe[g])
                            cr_recipe[g] = {}
                            cr_recipe[oname].need = rs_recipe[g].size
                            cr_recipe[oname].label = rs_recipe[g].label
                            local maxDamage = ac.mD.getMax(oname)
                            if maxDamage > 0 then
                                local recipe_item_storage = ac.mf.component.proxy(ac.prox.GetProxy(ac.convert.TextToItem(rs_recipe[g].name).mod, "home"))
                                if recipe_item_storage ~= nil then
                                    for hh = 0, maxDamage, 1 do
                                        rs_recipe[g].damage = hh
                                        local recipe_item = recipe_item_storage.getItem(rs_recipe[g])
                                        if recipe_item ~= nil then
                                            if recipe_item.label == cr_recipe[oname].label then
                                                cr_recipe[oname] = nil
                                                oname = ac.convert.ItemToOName(rs_recipe[g])
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
                                if ac.recipeitems[oname] == nil then
                                  ac.recipeitems[oname] = {crafter = ac.getCrafter(oname)}
                                end
                            else
                                print("Item " .. oname .. " has more then 1 damage, place " .. cr_recipe[oname].label .. " into your storage to get the correct recipe")
                                recipe_complete = false
                            end
                        end
                        if recipe_complete then
                            ac.items[j].recipe = ac.mf.copyTable(cr_recipe)
                        end
                        
                        --get CraftCount
                        for cc = 2, 64, 1 do
                          local rs_recipe = rs_comp.getMissingItems(ac.items[j], cc)
                          local more = true
                          rs_recipe.n = nil
                          for g,h in pairs(rs_recipe) do
                            local oname = ac.convert.ItemToOName(rs_recipe[g])
                            local maxDamage = ac.mD.getMax(oname)
                            if maxDamage > 0 then
                                local recipe_item_storage = ac.mf.component.proxy(ac.prox.GetProxy(ac.convert.TextToItem(rs_recipe[g].name).mod, "home"))
                                if recipe_item_storage ~= nil then
                                    for hh = 0, maxDamage, 1 do
                                        rs_recipe[g].damage = hh
                                        local recipe_item = recipe_item_storage.getItem(rs_recipe[g])
                                        if recipe_item ~= nil then
                                            if recipe_item.label == rs_recipe[g].label then
                                                oname = ac.convert.ItemToOName(rs_recipe[g])
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                            if rs_recipe[g].size ~= ac.items[j].recipe[oname].need then
                              more = false
                              break
                            end
                          end
                          if more then
                            ac.items[j].craftCount = ac.items[j].craftCount + 1
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
    ac.mf.thread.waitForAll(ttable)
    ac.WriteNewRepo()
    ac.ConvertItems()
    ac.GetStorageItems()
  end
  print("GetRecipes end")
end
function ac.SetCrafts(item, newneed)
    if(item ~= nil)then
        if ac.items[item].recipe ~= nil then
            local craftsChanged = false
            local ThisTempCrafts = 0
            local ThisTempCrafts2 = 0
            if ac.items[item].crafts == nil then
                ac.items[item].crafts = ac.mf.MathUp((ac.items[item].maxCount - ac.items[item].size) / ac.items[item].craftCount)
                if ac.items[item].crafts < 0 then
                  ac.items[item].crafts = 0
                end
                if ac.items[item].need ~= nil then
                  ac.items[item].crafts = ac.items[item].crafts + (ac.mf.MathUp(ac.items[item].need / ac.items[item].craftCount))
                end
                ThisTempCrafts = ac.items[item].crafts
                newneed = nil
                print(item .. ": CraftsFirst = " .. ThisTempCrafts)
            elseif newneed ~= nil then
                ThisTempCrafts = ac.mf.MathUp(newneed / ac.items[item].craftCount)
                print(item .. ": CraftsNeed = " .. ThisTempCrafts)
            end
            if ThisTempCrafts ~= 0 then
                for a,b in pairs(ac.items[item].recipe) do
                    if ac.recipeitems[a] ~= nil then
                      if ac.recipeitems[a].need ~= nil then
                        ac.recipeitems[a].need = ac.recipeitems[a].need + (ThisTempCrafts * b.need)
                      else
                        ac.recipeitems[a].need = ThisTempCrafts * b.need
                      end
                      print(a .. ": New recipe item Need = " .. ac.recipeitems[a].need)
                    elseif ac.items[a] ~= nil then
                      if ac.items[a].need ~= nil then
                        ac.items[a].need = ac.items[a].need + (ThisTempCrafts * b.need)
                      else
                        ac.items[a].need = ThisTempCrafts * b.need
                      end
                      print(a .. ": New recipe item Need (in items) = " .. ac.items[a].need)
                      if a ~= item then
                        ac.SetCrafts(a, (ThisTempCrafts * b.need))
                      end
                    end
                end
                if newneed ~= nil then
                    ac.items[item].crafts = ac.items[item].crafts + ThisTempCrafts
                    ThisTempCrafts2 = ac.items[item].crafts
                    print(item .. ": CraftsOverall = " .. ThisTempCrafts2)
                end
                for a,b in pairs(ac.items[item].recipe) do
                    if ac.recipeitems[a] ~= nil then
                        local tempcrafts = math.floor(ac.recipeitems[a].newsize / b.need)
                        if tempcrafts < ac.items[item].crafts then
                            ac.items[item].crafts = tempcrafts
                            craftsChanged = true
                        end
                    elseif ac.items[a] ~= nil then
                        local tempcrafts = math.floor(ac.items[a].newsize / b.need)
                        if tempcrafts < ac.items[item].crafts then
                            ac.items[item].crafts = tempcrafts
                            craftsChanged = true
                        end
                    end
                end
                if craftsChanged then
                    if newneed ~= nil then
                      ThisTempCrafts = ThisTempCrafts - (ThisTempCrafts2 - ac.items[item].crafts)
                    else
                      ThisTempCrafts = ac.items[item].crafts
                    end
                    print(item .. ": ChangedCrafts = " .. ThisTempCrafts)
                end
                for a,b in pairs(ac.items[item].recipe) do
                    if ac.recipeitems[a] ~= nil then
                      print(a .. ": recipeitems Size = " .. ac.recipeitems[a].newsize)
                      ac.recipeitems[a].newsize = ac.recipeitems[a].newsize - (ThisTempCrafts * ac.items[item].recipe[a].need)
                      print(a .. ": recipeitems Size changed = " .. ac.recipeitems[a].newsize)
                    end
                end
                print(item .. ": Size = " .. ac.items[item].newsize)
                ac.items[item].newsize = ac.items[item].newsize + (ThisTempCrafts * ac.items[item].craftCount)
                print(item .. ": Size Changed = " .. ac.items[item].newsize)
                if newneed ~= nil then
                    print(item .. ": SetNewCraft = " .. ac.items[item].crafts)
                else
                    print(item .. ": SetCraft = " .. ac.items[item].crafts)
                end
            end
        end
    end
end
function ac.CalculateCrafts()
    print("CalculateCrafts")
    for i,j in pairs(ac.items) do ac.items[i]["newsize"] = j.size end
    for i,j in pairs(ac.recipeitems) do ac.recipeitems[i]["newsize"] = j.size end
    for i,j in pairs(ac.mf.getSortedKeys(ac.items)) do
        ac.SetCrafts(j)
    end
end
function ac.MoveItem(item, count, route)
    local r = 1
    while r <= #route do
        local storage = ac.mf.component.proxy(route[r].proxy)
        while count > 0 do
            local dropped = storage.extractItem(item, count, route[r].side)
            if dropped ~= nil then
                count = count - dropped
            end
        end
        r = r + 1
    end
end
function ac.MoveRecipeItems(item)
    for i,j in pairs(ac.items[item].recipe) do
        if ac.recipeitems[i] ~= nil then
            ac.MoveItem(ac.recipeitems[i], ac.items[item].crafts * j.need, (ac.prox.GetRoute(ac.recipeitems[i].mod, "craft", ac.crafter, 2)))
        elseif ac.items[i] ~= nil then
            ac.MoveItem(ac.items[i], ac.items[item].crafts * j.need, (ac.prox.GetRoute(ac.items[i].mod, "craft", ac.crafter, 2)))
        end
    end
end
function ac.MoveCraftedItem(item)
    ac.MoveItem(ac.items[item], ac.items[item].crafts, (ac.prox.GetRoute(ac.crafter, "home", ac.items[item].mod, 1)))
end
function ac.MoveRestBack()
    local rest_items = ac.mf.component.proxy(ac.prox.GetProxByName(ac.crafter, "craft").proxy).getItems()
    local num_ritems = #rest_items
    for i = 1, num_ritems, 1 do
        local converted = ac.convert.ItemToOName(rest_items[i])
        rest_items[converted] = ac.convert.TextToItem(converted)
        rest_items[converted].size = rest_items[i].size
    end
    for i = 1, num_ritems, 1 do
        rest_items[i] = nil
    end
    rest_items.n = nil
    for i,j in pairs(rest_items) do
        ac.MoveItem(j, j.size, (ac.prox.GetRoute(ac.crafter, "home", j.mod, 1)))
    end
end
function ac.CraftItems()
    local cr = ac.mf.component.proxy(ac.prox.GetProxyByName(ac.crafter,"craft"))
    for i,j in pairs(ac.items) do
        if j.crafts ~= nil and j.crafts ~= 0 then
            print("Crafting Item: " .. i .. " Crafts: " .. j.crafts)
            ac.MoveRecipeItems(i)
            cr.scheduleTask(j, j.crafts * j.craftCount)
            local tasks = cr.getTasks()
            while #tasks > 0 do
                ac.mf.os.sleep(1)
                tasks = cr.getTasks()
                if (tasks == nil) then
                    tasks = {}
                end
            end
            ac.items[i].newsize = ac.items[i].newsize + j.crafts
            ac.items[i].size = ac.items[i].newsize
            ac.MoveCraftedItem(i)
        end 
    end
    ac.MoveRestBack()
end
function ac.CheckItemRecipe(item)
    local returning = ""
    ac.items[item].crafts = 1
    print("Checking Item Recipe: " .. item)
    for g,h in pairs(ac.items[item].recipe) do
        local tempsize
        if ac.recipeitems[g] ~= nil then
            tempsize = ac.recipeitems[g].size
        elseif ac.items[g] ~= nil then
            tempsize = ac.items[g].size
        end
        if tempsize < ac.items[item].crafts * ac.items[item].recipe[g].need then
            if returning == "" then
              returning = "Cant check, missing: " .. g
            else
              returning = returning .. ", " .. g
            end
        end
    end
    if returning == "" then
        ac.MoveRecipeItems(item)
        local r = ac.rs_cr.getMissingItems(ac.items[item], ac.items[item].crafts * ac.items[item].craftCount)
        if r.n > 1 then
          returning = "Wrong"
        else
          returning = "OK"
        end
        ac.MoveRestBack()
    end
    print(returning)
    return returning
end
function ac.CheckRecipes()
    ac.rs_cr = ac.mf.component.proxy(ac.prox.GetProxyByName(ac.crafter,"craft"))
    local cr_items = {}
    for i,j in pairs(ac.mf.getSortedKeys(ac.items)) do
        cr_items[j] = ac.CheckItemRecipe(j)
    end
    ac.MoveRestBack()
    ac.mf.WriteObjectFile(cr_items, "/home/" .. ac.crafter .. " - RecipeChecked.lua")
end
function ac.test()
  ac = require("bufu/Crafter/Autocraft")
  ac.Define("minecraft")
  ac.ConvertItems()
  ac.GetStorageItems()
  
  ac.sorted = ac.mf.getSortedKeys(ac.items)
  ac.SetCrafts(ac.sorted[1])

  ac.CalculateCrafts()
  ac.mf.WriteObjectFile(ac.items, "/home/tempitems2.lua", 2)
  ac.mf.WriteObjectFile(ac.recipeitems, "/home/temprecipeitems2.lua", 2)
end
function ac.GetItems()
    print("GetItems")
    ac.ConvertItems()
    ac.GetStorageItems()
    ac.GetRecipes()
    ac.CalculateCrafts()
end
function ac.GetRecipeCraftings()
  local recipecrafting = {}
  for i,j in pairs(ac.recipeitems) do
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
    local repo = ac.searchforRepo(i)
    local reporec = ac.searchforRepoRecipe(i)
    if repo ~= "" then
      temp = require(repo)
    end
    if reporec ~= "" then
      temp2 = require(reporec)
    end
    for a,b in pairs(j.items) do
      recipecrafting[i].items[a].maxCount = temp[a].maxCount
      recipecrafting[i].items[a].craftCount = temp[a].craftCount
      recipecrafting[i].items[a].recipe = ac.mf.copyTable(temp[a].recipe)
      for c,d in pairs(b.recipe) do
        recipecrafting[i].recipeitems[c] = ac.mf.copyTable(temp2[c])
      end
    end
    temp = {}
    temp2 = {}
  end
  for i,j in pairs(recipecrafting) do
    local tempac = require("bufu/Crafter/Autocraft")
    tempac.DefineEx(j.items, j.recipeitems)
    tempac.GetItems()
    tempac.CalculateCrafts()
    tempac.GetRecipeCraftings()
    tempac.CraftItems()
    for a,b in pairs(tempac.items) do
      ac.recipeitems[a].newsize = b.newsize
      ac.recipeitems[a].size = b.newsize
    end
    tempac = {}
  end
end
function ac.Craft(itemrepo)
  ac.Define(itemrepo)
  ac.GetItems()
  --ac.GetRecipeCraftings()
  ac.CraftItems()
end
function ac.CraftExItems(itemsToCraft)
  ac.DefineItems(itemsToCraft)
  for i,crafter in pairs(ac.itemcrafters) do
    local tempac = require("bufu/Crafter/Autocraft")
    tempac.DefineEx(crafter.items, crafter.recipeitems)
    tempac.GetItems()
    tempac.CalculateCrafts()
    tempac.GetRecipeCraftings()
    tempac.CraftItems()
  end
end

if ac.args[1] ~= nil and ac.args[1]:find("Autocraft") == nil then
    ac.Craft(ac.args[1])
end

return ac

--function GetRecipeCounts()
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
--function GetStorageItems_old()
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
--function SetCanCraft_old(item)
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
--function SetCanCraftALL_old()
--  print("SetCanCraftALL")
--  for ic,jc in pairs(items) do
--    SetCanCraft(ic)
--  end
--end
--function SetCrafts_old(item)
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
--function RollBackCrafts_old()
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
--function GetPrio(item)
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
--function GetPrios()
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
-- function file_exist(path)
  -- local file = io.open(path)
 
  -- if (not file) then
    -- print("[ERROR]: No such file: " .. path .. ".")
    -- return false
  -- end
  -- io.close(file)
  -- return true
-- end

-- -- Load and parse the file, return a table with all the item to craft.
-- function load_file(path)
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
-- function is_missing_items(task)
  -- if (task.missing.n > 0) then
    -- return true
  -- end
  -- return false
-- end

-- -- Check if craft is already on the tasks' queue. 
-- function craft_is_on_tasks(craft, tasks)
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

-- function do_crafting(file)
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