local event = require("event")
local io = require("io")
local sides = require("sides")
local os = require("os")
local component = require("component")
local convert = require("crafting/Convert")
local prox = require("crafting/Proxies")
local mf = require("MainFunctions")
local thread = require("thread")
local shell = require("shell")
local items = {}
local priocount = 0
local crafter = ""
local ac = {}
local args = shell.parse( ... )
local itemschange = false
local logfile = "/home/crafting/AC-Log.lua"

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
        local rs_item = {size=0.0}
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
  print("GetStorageItems end")
end
local function WriteNewRepo()
    local serial = require("serialization")
    local newRepoFile = io.open("crafting/Items/" .. crafter .. ".lua", "w")
    local ikeys = mf.getSortedKeys(items)
    local itemsep = ","
    newRepoFile:write("return {\n")
    for ik = 1, #ikeys, 1 do
        if ik == #ikeys then itemsep = "" end
        local tempsize = items[ikeys[ik]].size
        items[ikeys[ik]].name = nil
        items[ikeys[ik]].mod = nil
        items[ikeys[ik]].damage = nil
        items[ikeys[ik]].size = nil
        newRepoFile:write("    " .. ikeys[ik].. "=" .. serial.serialize(items[ikeys[ik]]) .. itemsep .. "\n")
        items[ikeys[ik]].size = tempsize
    end
    newRepoFile:write("}")
    newRepoFile:close()
end
local function GetRecipes()
    print("GetRecipes")
    local itemcounter = 0
    local co = 1
    local iarr = {}
    local th = {}
    for i,j in pairs(items) do
        if j.maxCount ~= nil
            if j.recipe == nil and j.size < j.maxCount then
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
                        if(rs_comp ~= nil) then
                            local wcrafts = mf.MathUp((items[j].maxCount - items[j].size) / items[j].craftCount)
                            local cr_recipe = {}
                            local rs_recipe = rs_comp.getMissingItems(items[j], (wcrafts * items[j].craftCount))
                            rs_recipe.n = nil
                            for g,h in pairs(rs_recipe) do
                                cr_recipe[g] = {}
                                if h.maxDamage ~= nil then
                                    rs_recipe[g].damage = h.maxDamage
                                else
                                    rs_recipe[g].damage = 0.0
                                end
                                cr_recipe[g].oname = convert.ItemToOName(rs_recipe[g])
                                cr_recipe[g].need = rs_recipe[g].size / wcrafts
                                cr_recipe[g].label = rs_recipe[g].label
                                if items[cr_recipe[g].oname] == nil then
                                    items[cr_recipe[g].oname] = {label = rs_recipe[g].label, crafter=""}
                                end
                            end
                            items[j].recipe = cr_recipe
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
            items[item].crafts = mf.MathUp((items[item].maxCount - items[item].size) / items[item].craftCount) * items[item].craftCount
            for a,b in pairs(items[item].recipe) do
                local tempcrafts = items[b.oname].newsize * b.need
                if tempcrafts < items[item].crafts then
                    items[item].crafts = tempcrafts
                end
            end
            for a,b in pairs(items[item].recipe) do
                items[item].recipe[a].size = items[item].crafts / b.need
                items[b.oname].newsize = items[b.oname].newsize - items[item].recipe[a].size
            end
            print(item .. ": SetCraft = " .. items[item].crafts)
        end
    end
end
local function SetCraftsALL()
  print("SetCraftsALL")
  for i,j in pairs(items) do
    SetCrafts(i)
  end
end
local function CalculateCrafts()
    print("CalculateCrafts")
    for is,js in pairs(items) do
      items[is]["newsize"] = js.size
    end
    SetCraftsALL()
end
local function PrintItem(item, prefix)
    local output = item .. "={"
    if prefix ~= nil then
      output = prefix .. output
    end
    for c,d in pairs(items[item]) do
      if((c ~= "recipe") and (c ~= "recipeCounts")) then
      output = output .. c .. " = " .. tostring(d) .. "; "
      elseif c == "recipe" then
        output = output .. c .. " = {"
        for e,f in pairs(d) do
          output = output .. f .. ", "
        end
        output = output .. "}; "
        output = output:gsub(", }; ", "}; ")
      elseif c == "recipeCounts" then
        output = output .. c .. " = {"
        for e,f in pairs(d) do
          output = output .. e .. " = " .. f .. "; "
        end
        output = output .. "}; "
        output = output:gsub("; }; ", "}; ")
      end
    end
    output = output .. "}"
    output = output:gsub("; }", "}")
    print(output)
end
local function PrintItems()
  print("")
  print("Items:")
  for i,j in pairs(items) do
    PrintItem(i)
  end
  print("")
end
local function MoveItems(item, count, route)
    local r = 1
    while r <= #route do
        local storage = component.proxy(route[r].proxy)
        while count > 0 do
            local dropped = storage.extractItem(items[i], count, route[r].side)
            if dropped ~= nil then
                count = count - dropped
            end
        end
        r = r + 1
    end
end
local function MoveRecipeItems(item)
    for i,j in pairs(items[item].recipe) do
        MoveItems(j , j.size, (prox.GetRoute((convert.TextToItem(j.oname).mod), "craft", crafter, 2)))
    end
end
local function MoveCraftedItem(item)
    MoveItems(item, (items[item].crafts * items[item].craftCount), (prox.GetRoute(crafter, "home", items[item].mod, 1)))
end
local function CraftItems()
    local cr = component.proxy(prox.GetProxByName(crafter,"craft"))
    for i,j in pairs(items) do
        if j.crafts ~= nil and j.crafts ~= 0 then
            PrintItem(i, "Crafting Item: ")
            MoveRecipeItems(j)
            cr.scheduleTask(j, (j.crafts * j.craftCount))
            local tasks = cr.getTasks()
            while #tasks > 0 do
                os.sleep(1)
                tasks = cr.getTasks()
                if (tasks == nil) then
                    tasks = {}
                end
            end
            MoveCraftedItem(j)
        end 
    end
end
local function GetStorageInfo(store)
  local cr = component.proxy(prox.GetProxByName(crafter,store))
  print("")
  print("Items in " .. store .. ": " .. crafter)
  for a,b in pairs(cr.getItems()) do
    print(a .. " = " .. b.size)
  end
  print("")
end
local function GetItems()
    print("GetItems")
    --GetRecipeCounts()
    ConvertItems()
    GetStorageItems()
    GetRecipes()
    GetRecipeItems()
    CalculateCrafts()
    --PrintItems()
end
local function Define(itemrepo)
  items = require("crafting/Items/" .. itemrepo)
  crafter = itemrepo
  for i,j in pairs(items) do
    if j.craftCount == nil then
      items[i].craftCount = 1.0
    end
  end
end
local function Craft(itemrepo)
  Define(itemrepo)
  GetItems()
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
ac.GetRecipeItems = GetRecipeItems
ac.CalculateCrafts = CalculateCrafts
ac.CraftItems = CraftItems
ac.PrintItems = PrintItems
ac.items = items
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