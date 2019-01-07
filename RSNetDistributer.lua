local c = require("component")
local event = require("event")
local io = require("io")
local sides = require("sides")
local os = require("os")
local thread = requie("thread")
local mf = require("MainFunctions")
local rs = require("RSNetComponents")
local tp = c.transposer
local tps = {}
local possides = {"north", "south", "east", "west", "up", "down"}
local storingside = ""

if mf.getCount(rs.netcards) ~= 0 then
  for i,j in pairs(possides) do
    if mf.containsKey(rs.netcards, j) == false then
      storingside = j
    end
  end
end

if storingside == "" then
  print("Please define on which side of the transposer")
  print("your chest for storing linked Network-Cards is located.")
  print("Possible Values: north, south, east, west, up, down")
  while mf.contains(possides, storingside) == false do
    storingside = io.read()
    if mf.contains(possides, storingside) == false then
      print("This is not a valid side.")
      print("Possible Values: north, south, east, west, up, down")
    end
  end

  local is = 1
  for i = 1, 6, 1 do
    if storingside ~= possides[i] then
      tps[is] = tp.getInventorySize(sides[possides[i]])
      is = is + 1
    end
  end
end

print(tps)
local function registerNetworkCard(netid)
  if tp.getStackInSlot(sides[storingside], 0) == nil then
    print("Put a linked Network-Card into the chest for storing.")
  else
    if netid ~= "" then
      
    end
  end
end
local function storeNetworkCard()

end
local function registerRefinedStorage(name)
  
end
local function NumberToBinary(num)
  local returning = {}
  returning[0] = 1
  --loc
end
