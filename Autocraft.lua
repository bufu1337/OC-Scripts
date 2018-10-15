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
local component = require("component")
local convert = require("Convert")
local prox = require("Proxies")
local rs = component.block_refinedstorage_interface

local items = {}
local args = { ... }
local paths = {}

-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
function tprint (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      tprint(v, indent+1)
    elseif type(v) == 'boolean' then
      print(formatting .. tostring(v))      
    else
      print(formatting .. v)
    end
  end
end

-- Check if the file exist 
local function file_exist(path)
  local file = io.open(path)
 
  if (not file) then
    print("[ERROR]: No such file: " .. path .. ".")
    return false
  end
  io.close(file)
  return true
end

-- Load and parse the file, return a table with all the item to craft.
local function load_file(path)
  local crafts = {}
 
  for line in io.lines(path) do
    local n, c, l, f = line:match "(%S+)%s+(%d+)"
    l = n:match "(%u%S+)"
    f = n:match("(%l+:%l+)")
    if (l) then
      table.insert(crafts, { name = f, label = l, count = c, fullName = n })
    else
      table.insert(crafts, { name = f, count = c, fullName = n })
    end
  end
  return crafts
end

local function get_items(file)
	items = require("Items/" .. file)
	for i,j in pairs(items) do
		items[i]["recipeCounts"] = {}
		for g,h in pairs(items[i].recipe) do
			if(h ~= nil)then
				local he = h:gsub(":", "_")
				if (items[i].recipeCounts[he] == nil) then
					items[i].recipeCounts[he] = 1
				else
					items[i].recipeCounts[he] = items[i].recipeCounts[he] + 1
				end
				if(items[he] == nil)then
					items[he] = {}
				end
			end
		end
		local converted = convert.TextToItem(i:gsub("_", ":"))
		for x,y in pairs(converted) do
			items[i][x] = y
		end
		local rs_item = component.proxy(prox.GetProxy(items[i][mod], "home")).getItem(items[i])
		if(rs_item == nil) then
			rs_item = {hasTag=false; size=0.0}
		end
		for a,b in pairs(rs_item) do
			items[i][a] = b
		end
		for c,d in pairs(items) do
			print("")
			print(c)
			for e,f in pairs(d) do
				print(e .. " = " .. f)
			end
		end
	end
end

-- Check if a task have missing items.
local function is_missing_items(task)
  if (task.missing.n > 0) then
    return true
  end
  return false
end

-- Check if craft is already on the tasks' queue. 
local function craft_is_on_tasks(craft, tasks)
  for i, task in ipairs(tasks) do
    if craft.name == task.stack.name then
      local missing_items = rs.getMissingItems(task.stack, task.quantity)
      for j, item in ipairs(missing_items) do
        print("[WARNING]: Missing " .. item.size .. " " .. item.name)
      end
      return true
    end
  end
  return false
end

-- Craft an item
function craft_item(craft, tasks)
  local toCraft = tonumber(craft.count)

  if (rs.hasPattern(craft)) then
    if (not craft_is_on_tasks(craft, tasks)) then
      local rsStack = rs.getItem(craft)
      
      if (rsStack) then
        toCraft = toCraft - rsStack.size
      end
      if (toCraft > 0) then
        rs.craftItem(craft, toCraft)
      end
    end
  else
    print("[WARNING]: Missing pattern for: " .. craft.fullName .. ".")
  end 
end

function GetItemSizes(items)
  local rs_item = rs.getItem(item)
  local limit = tonumber(item.count)

  if (not rs_item) then
    return
  end
  while (rs_item.size > limit) do
    local dropped = rs.extractItem(rs_item, rs_item.size - limit, sides.down)

    rs_item.size = rs_item.size - dropped
    if (dropped < 1) then
      break
    end
  end
end

-- Destroy item
function destroy_item(item)
  local rs_item = rs.getItem(item)
  local limit = tonumber(item.count)

  if (not rs_item) then
    return
  end
  while (rs_item.size > limit) do
    local dropped = rs.extractItem(rs_item, rs_item.size - limit, sides.down)

    rs_item.size = rs_item.size - dropped
    if (dropped < 1) then
      break
    end
  end
end

local function do_crafting(file)
	get_items(file)
end

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