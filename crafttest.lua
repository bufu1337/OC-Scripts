local function sleep(s)
  local ntime = os.time() + s
  repeat until os.time() > ntime
end
local os = {sleep=sleep}
local sides = {up=1;down=2;right=3;left=4}
local component = {}
local convert = {}
local prox = {}
local rs = {a={};b={};c={}}
local activprox = ""
local priocount = 0
local crafter = "minecraft"
local rsi = {
  a_sides={"b", nil, "c", nil};
  b_sides={nil, "a", nil, "c"};
  c_sides={"a", "b"};
  a={
    minecraftjjactivator_rail={size=50.0};
    minecraftjjanvil={size=50.0};
    minecraftjjarmor_stand={size=10.0};
    minecraftjjarrow={size=50.0};
    minecraftjjiron_block={size=100.0};
    minecraftjjstick={size=100.0};
    minecraftjjiron_ingot={size=10000.0};
    minecraftjjplanks={size=10000.0};
    minecraftjjflint={size=10000.0};
    minecraftjjredstone_torch={size=10000.0};
    minecraftjjfeather={size=10000.0};
    minecraftjjstone_slab={size=10000.0}
  };
  b={};
  c={};
  a_tasks={};
  b_tasks={};
  c_tasks={};
}
local items = {
  minecraftjjactivator_rail={maxCount=512.0; craftCount=6.0; recipe={"minecraft:iron_ingot", "minecraft:stick", "minecraft:iron_ingot", "minecraft:iron_ingot", "minecraft:redstone_torch", "minecraft:iron_ingot", "minecraft:iron_ingot", "minecraft:stick", "minecraft:iron_ingot"}};
  minecraftjjanvil={maxCount=512.0; craftCount=1.0; recipe={"minecraft:iron_block", "minecraft:iron_block", "minecraft:iron_block", nil, "minecraft:iron_ingot", nil, "minecraft:iron_ingot", "minecraft:iron_ingot", "minecraft:iron_ingot"}};
  minecraftjjarmor_stand={maxCount=128.0; craftCount=1.0; recipe={"minecraft:stick", "minecraft:stick", "minecraft:stick", nil, "minecraft:stick", nil, "minecraft:stick", "minecraft:stone_slab", "minecraft:stick"}};
  minecraftjjarrow={maxCount=512.0; craftCount=4.0; recipe={nil, "minecraft:flint", nil, nil, "minecraft:stick", nil, nil, "minecraft:feather", nil}};
  minecraftjjiron_block={maxCount=640.0; craftCount=1.0; recipe={"minecraft:iron_ingot", "minecraft:iron_ingot", "minecraft:iron_ingot", "minecraft:iron_ingot", "minecraft:iron_ingot", "minecraft:iron_ingot", "minecraft:iron_ingot", "minecraft:iron_ingot", "minecraft:iron_ingot"}};
  minecraftjjstick={maxCount=1280.0; craftCount=4.0; recipe={"minecraft:planks", "minecraft:planks", nil, nil, nil, nil, nil, nil, nil}}
}

-- # Proxies.lua
function Proxies()
    return {
        minecraft = {home={proxy="a", tocraft=sides.up, toroute=sides.right}; craft={proxy="b", tohome=sides.down, toroute=sides.left}}--Minecraft 01.12.2002
    }
end
function RouteSystem()
    return {
        minecraft = {proxy="c", home=sides.up, craft=sides.down}
    }
end
local function GetRoute(mod, typ, destinationmod)
    local typ2 = ""
    if(typ == "craft")then
        typ2 = "home"
    else
        typ2 = "craft"
    end 
    local proxy = Proxies()
    local routesystem = RouteSystem()
    if((mod == destinationmod) or (destinationmod == nil))then
        return {{proxy = proxy[mod][typ2].proxy, side=proxy[mod][typ2][("to" .. typ)]}}
    else
        return {{proxy = proxy[mod][typ2].proxy, side=proxy[mod][typ2].toroute}; {proxy = routesystem[destinationmod].proxy, side=routesystem[destinationmod][typ]}}
    end
end
local function GetProxy(mod, typ)
    --print(mod)
    if(mod == "routing")then
        return ""
    else
        local proxy = Proxies()
        return proxy[mod][typ].proxy
    end
end
prox.GetRoute = GetRoute
prox.GetProxy = GetProxy

-- # Convert.lua
local function TextToItem(text)
    local result = {name="";damage=0;mod=""}
    local counter = 0
  if(text:find("jj") ~= nil) then
    text = text:gsub("jj", ":")
  end
    for w in (text .. ":"):gmatch("([^:]*):") do 
        if(counter == 0)then
            result.name = w
            result.mod = w 
        end
        if(counter == 1)then
            result.name = result.name .. ":" .. w
        end
        if(counter == 2)then
            result.damage = tonumber(w)
        end
        counter = counter +1
    end
    return result
end
local function ItemToText(item)
    return item.name .. ":" .. item.damage
end
local function TextToOName(text)
    return text:gsub(":", "jj")
end
local function ItemToOName(item)
    if(item.damage ~= 0) then
      return TextToOName(item.name) .. "jj" .. item.damage
    else
      return TextToOName(item.name)
    end
end
convert.TextToItem = TextToItem
convert.ItemToText = ItemToText
convert.ItemToOName = ItemToOName
convert.TextToOName = TextToOName

-- # OC-System
local function getItem(item)
  --print("getItem: " .. tostring(item.name) .. " " .. tostring(item.damage) .. " " .. convert.ItemToOName(item) .. " " .. tostring(rsi[convert.ItemToOName(item)]))
  return rsi[activprox][convert.ItemToOName(item)]
end
local function getSItems()
  --print("getItem: " .. tostring(item.name) .. " " .. tostring(item.damage) .. " " .. convert.ItemToOName(item) .. " " .. tostring(rsi[convert.ItemToOName(item)]))
  return rsi[activprox]
end
local function extractItem(item, count, side)
  if(count > 64)then
    count = 64
  end
  rsi[activprox][convert.ItemToOName(item)].size = rsi[activprox][convert.ItemToOName(item)].size - count
  side = rsi[(activprox .. "_sides")][side]
  item = convert.ItemToOName(item)
  if (rsi[side][item] == nil) then
    rsi[side][item] = {size=0.0}
  end
  rsi[side][item].size = rsi[side][item].size + count
  return count
end
local function scheduleTask(item, count)
  rsi[(activprox .. "_tasks")][1] = convert.ItemToOName(item)
  rsi[(activprox .. "_tasks")][2] = count
end
local function getTasks()
  local item = rsi[(activprox .. "_tasks")][1]
  local count = rsi[(activprox .. "_tasks")][2]
  if (rsi[activprox][item] == nil) then
    rsi[activprox][item] = {size=0.0}
  end
  local crafting = 50
  if (items[item].crafts < crafting) then
    crafting = items[item].crafts
  end
  local c = crafting * items[item].craftCount
  for a,b in pairs(items[item].recipeCounts) do
    rsi[activprox][a].size = rsi[activprox][a].size - (crafting * b)
  end
  rsi[activprox][item].size = rsi[activprox][item].size + c
  rsi[(activprox .. "_tasks")][2] = rsi[(activprox .. "_tasks")][2] - c
  items[item].crafts = items[item].crafts - crafting
  if (rsi[(activprox .. "_tasks")][2] == 0) then
    rsi[(activprox .. "_tasks")] = {}
  end
  return rsi[(activprox .. "_tasks")]
end
local function proxy(test)
  activprox = test
  rs[test].getItem = getItem
  rs[test].getItems = getSItems
  rs[test].extractItem = extractItem
  rs[test].scheduleTask = scheduleTask
  rs[test].getTasks = getTasks
  return rs[test]
end
component.proxy = proxy

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
    local rawcraft = (items[item].maxCount - items[item].newsize) / items[item].craftCount
    local tocraft = math.floor(rawcraft)
    if((rawcraft - tocraft) > 0)then
      tocraft = tocraft + 1
    end
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
local function MoveItemsToCraft()
  for i,j in pairs(items) do
    if (j.newsize < j.size) then
      local route = prox.GetRoute(items[i]["mod"], "craft", crafter)
      local r = 1
      while r <= #route do
        local count = j.size - j.newsize
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
local function MoveItemsFromCraft()
  for i,j in pairs(items) do
    if (j.newsize > j.size) then
      local route = prox.GetRoute(crafter, "home", items[i]["mod"])
      local r = 1
      while r <= #route do
        local count = j.newsize - j.size 
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
local function Craft()
  GetItems()
  GetStorageInfo("home")
  GetStorageInfo("craft")
  MoveItems("craft")
  GetStorageInfo("home")
  GetStorageInfo("craft")
  CraftItems()
  GetStorageInfo("home")
  GetStorageInfo("craft")
  PrintItems()
  MoveItems("home")
  GetStorageInfo("home")
  GetStorageInfo("craft")
end
Craft()