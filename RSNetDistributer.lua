local c = require("component")
local event = require("event")
local io = require("io")
local sides = require("sides")
local os = require("os")
local thread = requie("thread")
local serial = require("serialization")
local mf = require("MainFunctions")
local rs = require("RSNetComponents")
local tp_net = c.proxy(rs.transposer_netcards)
local tp_dest = c.proxy(rs.transposer_destination)
local red = c.redstone
local m = c.modem


local function save()
  mf.WriteObjectFile(rs, "/home/RSNetComponents.lua")
  rs = require("RSNetComponents")
end
local function storeNetworkCard(side, slot)
  tp_net.transferItem(sides[rs.storingside], sides[side], 1, 0, slot)
end
local function registerNetworkCard(netid, monitor)
  if tp_net.getStackInSlot(sides[rs.storingside], 0) == nil then
    print("Put a linked Network-Card into the chest for storing.")
  else
    if netid ~= "" then
      local id = -1
      local netside = ""
      for i = 1, #rs.netsides_order, 1 do
        if rs.netsides[rs.netsides_order[i]].size ~= -1 and rs.netsides[rs.netsides_order[i]].next < rs.netsides[rs.netsides_order[i]].size then
          id = rs.netsides[rs.netsides_order[i]].next + ((i - 1) * rs.netsides[rs.netsides_order[i]].size)
          netside = rs.netsides_order[i]
          break
        end
      end
      if id ~= -1 then
        rs.netcards[id] = {net=netid, rsmonitor=monitor, side=netside, slot=rs.netsides[rs.netsides_order[i]].next}
        rs.netsides[rs.netsides_order[i]].next = rs.netsides[rs.netsides_order[i]].next + 1
        storeNetworkCard(rs.netcards[id].side, rs.netcards[id].slot)
        save()
      end
    end
  end
end
local function DistributeNetCard(remoteAddress, data)
  local found = false
  for i,j in pairs(rs.netcards) do
    if j.net == remoteAddress and data.rsmonitor == j.rsmonitor then
      
      found = true
    end
  end
  if found == false then
    print("Cant find a registered Network-Card for this address.")
  end
end

for i = 1, #rs.netsides_order, 1 do
  rs.netsides[rs.netsides_order[i]].size = tp_net.getInventorySize(sides[rs.netsides_order[i]])
end
save()
m.close(478)
m.open(478)
local listener = thread.create(function()
  local _, localAddress, remoteAddress, port, distance, data = event.pull("modem_message")
  print("")
  print("Received message:")
  print("From: " .. remoteAddress .. " Port: " .. port)
  print("Distance: " .. distance)
  print("Data: " .. data)
  DistributeNetCard(remoteAddress, serial.unserialize(data))
end)