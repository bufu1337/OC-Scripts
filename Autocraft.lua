-- Refined Storage autocraft
--
-- Run the program with the pathname of the crafts' listing file 
-- Crafts file (a craft per line): [item_name] [count]
-- File example: https://pastebin.com/zDrXzfSM
--
-- Created by Nyhillius  


local event = require("event")
local io = require("io")
local sides = require("sides")
local os = require("os")
local component = require("component")
local convert = require("Convert")
local prox = require("Proxies")
local thread = require("thread")
local shell = require("shell")
local items = {}
local priocount = 0
local crafter = ""
local ac = {}
local args = shell.parse( ... )

local function MathUp(num)
	local result = math.floor(num)
	if((num - result) > 0)then
      result = result + 1
    end
	return result
end
local function GetRecipeCounts()
  local temp = {}
  for i,j in pairs(items) do
    --print("Getting RecipeCounts: " .. i)
    if(items[i].recipe ~= nil)then
      items[i]["recipeCounts"] = {}
      for g,h in pairs(items[i].recipe) do
        if(h ~= nil)then
          local he = convert.TextToOName(h)
          if (items[i].recipeCounts[he] == nil) then
            items[i].recipeCounts[he] = 1
          else
            items[i].recipeCounts[he] = items[i].recipeCounts[he] + 1
          end
          if(items[he] == nil)then
            table.insert(temp, he)
          end
        end
      end
    else
      print("Has no Recipe: " .. i)
    end
  end
  for ie,je in pairs(temp) do
    items[je] = {}
  end
end
local function ConvertItems()
  for i,j in pairs(items) do
    local converted = convert.TextToItem(i)
    for x,y in pairs(converted) do
      items[i][x] = y
    end
  end
end
local function GetStorageItems()
  for i,j in pairs(items) do
    local rs_item = component.proxy(prox.GetProxy(items[i]["mod"], "home")).getItem(items[i])
    if(rs_item == nil) then
      rs_item = {size=0.0}
    end
    for a,b in pairs(rs_item) do
      items[i][a] = b
    end
  end
end
local function GetItemsCount()
	local count = 0
	for i,j in pairs(items) do
		count = count + 1
	end
	return count
end
local function GetStorageItemsThread()
	local rawtimes = 
  for i,j in pairs(items) do
    local rs_item = component.proxy(prox.GetProxy(items[i]["mod"], "home")).getItem(items[i])
    if(rs_item == nil) then
      rs_item = {size=0.0}
    end
    for a,b in pairs(rs_item) do
      items[i][a] = b
    end
  end
end
local function SetCanCraft(item)
  local can = nil
  if(item ~= nil)then
    if(items[item].recipeCounts ~= nil)then
      local tempsizes = {}    
      for a,b in pairs(items[item].recipeCounts) do
        SetCanCraft(a)
        local h = math.floor(((items[a].newsize + items[a].canCraft) / b) * items[item].craftCount)
        if((can == nil) or (can > h))then
          can = h
        end
      end
    end
    if(can == nil)then
      can = 0
    end
    items[item].canCraft = can
    print(item .. ": CanCraft = " .. items[item].canCraft)
  end
end
local function SetCanCraftALL()
  for ic,jc in pairs(items) do
    SetCanCraft(ic)
  end
end
local function SetCrafts(item)
  if(items[item].recipeCounts ~= nil)then
    local tocraft = MathUp((items[item].maxCount - items[item].newsize) / items[item].craftCount)
    SetCanCraft(item)
    if(items[item].canCraft < tocraft)then
      tocraft = items[item].canCraft
    end
    if(tocraft > 0)then
      print(item .. " tocraft: " .. tocraft)
      items[item].crafts = items[item].crafts + tocraft
      for a,b in pairs(items[item].recipeCounts) do
        print("setting size: " .. a .. " = " .. items[a].newsize)
        items[a].newsize = items[a].newsize - (tocraft * b)
        print("new size: " .. a .. " = " .. items[a].newsize)
      end
      print("")
      print("setting size: " .. item .. " = " .. items[item].newsize)
      items[item].newsize = items[item].newsize + (tocraft * items[item].craftCount)
      print("new size: " .. item .. " = " .. items[item].newsize)
      print(item .. " craftstotal: " .. items[item].crafts)
      print("")
      print("")
    end
  end
end
local function SetCraftsALL()
  for i,j in pairs(items) do
    SetCrafts(i)
  end
end
local function RollBackCrafts()
  for is,js in pairs(items) do
    if(items[is].newsize < 0)then
      for i,j in pairs(items) do
        if(items[i].recipeCounts ~= nil)then
          if(items[i].recipeCounts[is] ~= nil)then
            local temp = (math.floor(items[is].newsize / items[i].recipeCounts[is]) * -1)
            if(items[i].crafts > temp)then
              items[i].crafts = items[i].crafts - temp
              items[i].newsize = items[i].newsize - temp
              print("safgsdgdf size: ")
              for a,b in pairs(items[i].recipeCounts) do
                print("setting size: " .. a .. " = " .. items[a].newsize)
                items[a].newsize = items[a].newsize + (temp * b)
                print("new size: " .. a .. " = " .. items[a].newsize)
              end
              break
            else
              temp = items[i].crafts
              items[i].crafts = 0
              items[i].newsize = 0
              print("safgsdgdf size: ")
              for a,b in pairs(items[i].recipeCounts) do
                print("setting size: " .. a .. " = " .. items[a].newsize)
                items[a].newsize = items[a].newsize + (temp * b)
                print("new size: " .. a .. " = " .. items[a].newsize)
              end
            end
          end
        end
      end
    end
  end
end
local function CalculateCrafts()
  for is,js in pairs(items) do
    items[is]["newsize"] = js.size
    if(js.recipeCounts ~= nil)then
      items[is]["crafts"] = 0
    end
  end
  SetCanCraftALL()
  SetCraftsALL()
  SetCraftsALL()
  SetCraftsALL()
  SetCraftsALL()
  SetCraftsALL()
  SetCraftsALL()
  RollBackCrafts()
end
local function GetPrio(item)
  local prio = 0;
  if(items[item].recipeCounts ~= nil)then
    for a,b in pairs(items[item].recipeCounts) do
      if(items[a].recipeCounts ~= nil)then
        GetPrio(a)
        prio = items[a].prio + 1
      end
    end
  end
  if(prio > priocount)then
    priocount = prio
  end
  items[item].prio = prio
end
local function GetPrios()
  for i,j in pairs(items) do
    GetPrio(i)
  end
end
local function PrintItems()
  print("")
  print("Items:")
  for i,j in pairs(items) do
    local output = i .. "={"
    for c,d in pairs(items[i]) do
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
  print("")
end
local function MoveItems(destination)
  for i,j in pairs(items) do
    local check = (j.newsize > j.size)
    if (destination == "craft") then
      check = (j.newsize < j.size)
    end
    if (check) then
      local mod = crafter
      local dest = items[i]["mod"]
      if (destination == "craft") then
        mod = items[i]["mod"]
        dest = crafter
      end
      local route = prox.GetRoute(mod, destination, dest)
      local r = 1
      while r <= #route do
        local count = j.newsize - j.size 
        if (destination == "craft") then
          count = j.size - j.newsize
        end
        local storage = component.proxy(route[r].proxy)
        while count > 0 do
          local dropped = storage.extractItem(items[i], count, route[r].side)
          count = count - dropped
        end
        r = r + 1
      end
    end
  end
  --os.sleep(1)
end
local function CraftItems()
  local prio = 0
  local cr = component.proxy(prox.GetProxy(crafter,"craft"))
  while prio <= priocount do
    for i,j in pairs(items) do
      if ((j.prio == prio) and (j.crafts ~= nil)) then
        cr.scheduleTask(j, (j.crafts * j.craftCount))
        local tasks = cr.getTasks()
        while #tasks > 0 do
          --os.sleep(1)
          tasks = cr.getTasks()
          if (tasks == nil) then
            tasks = {}
          end
        end
      end 
    end
    prio = prio + 1
  end
end
local function GetStorageInfo(store)
  local cr = component.proxy(prox.GetProxy(crafter,store))
  print("")
  print("Items in " .. store .. ": " .. crafter)
  for a,b in pairs(cr.getItems()) do
    print(a .. " = " .. b.size)
  end
  print("")
end
local function GetItems()
  GetRecipeCounts()
  ConvertItems()
  GetStorageItems()
  CalculateCrafts()
  GetPrios()
  PrintItems()
end
local function Craft(itemrepo)
  items = require("Items/" .. itemrepo)
  crafter = itemrepo
  GetItems()
  --GetStorageInfo("home")
  --GetStorageInfo("craft")
  MoveItems("craft")
  --GetStorageInfo("home")
  --GetStorageInfo("craft")
  CraftItems()
  --GetStorageInfo("home")
  --GetStorageInfo("craft")
  PrintItems()
  MoveItems("home")
  --GetStorageInfo("home")
  --GetStorageInfo("craft")
end

if args[1] ~= nil then
    Craft(args[1])
end

ac.Craft = Craft
return ac

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