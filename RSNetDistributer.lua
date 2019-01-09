local c = require("component")
local event = require("event")
local io = require("io")
local sides = require("sides")
local os = require("os")
local thread = require("thread")
local serial = require("serialization")
local mf = require("MainFunctions")
local rs = require("RSNetComponents")
local tp_net = c.proxy(rs.transposer_netcards)
local tp_dest = c.proxy(rs.transposer_destination)
local red = c.redstone
local m = c.modem
local distributer = {}

local function save()
  mf.WriteObjectFile(rs, "/home/RSNetComponents.lua")
  rs = require("RSNetComponents")
end
local function storeNetworkCard(side, sourceslot, slot)
  tp_net.transferItem(sides[rs.storingside], sides[side], 1, sourceslot, slot)
end
local function registerNetworkCard(netid)
  local cards = {}
  for i = 1, 27, 1 do
    if tp_net.getStackInSlot(sides[rs.storingside], i) ~= nil then
      cards[(#cards + 1)] = i
    end
  end
  if #cards == 0 then
    print("Put a linked Network-Card into the chest for storing.")
  else
    if netid ~= "" then
      for g,h in pairs(cards) do
        local id = -1
        local netside = ""
        for i = 1, #rs.netsides_order, 1 do
          if rs.netsides[rs.netsides_order[i]].size ~= -1 and rs.netsides[rs.netsides_order[i]].next <= rs.netsides[rs.netsides_order[i]].size then
            id = rs.netsides[rs.netsides_order[i]].next + ((i - 1) * rs.netsides[rs.netsides_order[i]].size)
            netside = rs.netsides_order[i]
            break
          end
        end
        if id ~= -1 then
          rs.netcards[id] = {net=netid, rsmonitor=h, side=netside, slot=rs.netsides[netside].next}
          rs.netsides[netside].next = rs.netsides[netside].next + 1
          storeNetworkCard(rs.netcards[id].side, h, rs.netcards[id].slot)
          save()
        end
      end
    end
  end
end
local function DistributeNetCard(remoteAddress, data)
  local id = -1
  local tempslot = -1
  local tempslotreverse = -1
  local timeout = 0
  if mf.contains(rs.rstorages_order, data.storage) then
    
    --get network-card-id
    for i,j in pairs(rs.netcards) do
      if j.net == remoteAddress and data.rsmonitor == j.rsmonitor then
        id = i
        tempslot = j.slot + 1
        tempslotreverse = tempslot
        break
      end
    end

    if id == -1 then
      print("Cant find a registered Network-Card for this address.")
    elseif data.method == "push" then
      
      --Get Network-Card if it is in another storage
      for a,b in pairs(rs.rstorages) do
        local found = false
        for i,j in pairs(rs.rorder) do
          if b[j] == id then
            DistributeNetCard(rs.netcards[id].net, {method="pull", storage=b, rsmonitor=rs.netcards[id].rsmonitor})
            found = true
            break
          end
        end
        if found then
          break
        end
      end
      
      --Get free slot at the destination storage
      local freenetslot = -1
      for i,j in pairs(rs.rorder) do
        if rs.rstorages[data.storage][j] == -1 then
          freenetslot = i
          break
        end
      end
      --Pull out a Network-Card if all slots are occupied
      if freenetslot == -1 then
        local templast = rs.rstorages[data.storage]["last"]
        local tempid = rs.rstorages[data.storage][rs.rorder[templast]]
        DistributeNetCard(rs.netcards[tempid].net, {method="pull", storage=data.storage, rsmonitor=rs.netcards[tempid].rsmonitor})
        freenetslot = templast
        if (templast + 1) == 5 then
          rs.rstorages[data.storage]["last"] = 1
        else
          rs.rstorages[data.storage]["last"] = templast + 1
        end
      end

      --Push items for rftools-processor 
      --items to indicate in which slot the Network-Card is located 
      local times = mf.MathUp(tempslot/64)
      for i = 1, times, 1 do
        if tempslot <= 64 then
          tp_dest.transferItem(sides[rs.destination[1]], sides[rs.destination[2]], tempslot, i, i)
        else
          tp_dest.transferItem(sides[rs.destination[1]], sides[rs.destination[2]], 64, i, i)
          tempslot = tempslot - 64
        end
      end
      --items to indicate at which node the Refined Storage is located
      tp_dest.transferItem(sides[rs.destination[1]], sides[rs.destination[2]], mf.getIndex(rs.rstorages_order, data.storage), 27, 27)
      --items to indicate at which side of node the Network-Card should go
      tp_dest.transferItem(sides[rs.destination[1]], sides[rs.destination[2]], freenetslot, 25, 25)
      --items to indicate in which chest the Network-Card is located 
      tp_dest.transferItem(sides[rs.destination[1]], sides[rs.destination[2]], mf.getIndex(rs.netsides_order, rs.netcards[id].side), 26, 26)
      
      --signal rftools-processor to distribute the Network-Card
      red.setOutput(sides[rs.redstone], 15)
      os.sleep(1)
      --wait until the Network-Card is no longer in the Network-storage-chest
      while tp_net.getStackInSlot(sides[rs.netcards[id].side], rs.netcards[id].slot) ~= nil or timeout < 100 do
        os.sleep(1)
      end
      --turn off signal
      red.setOutput(sides[rs.redstone], 0)
      
      --Push items back
      for i = 1, times, 1 do
        if tempslotreverse <= 64 then
          tp_dest.transferItem(sides[rs.destination[2]], sides[rs.destination[1]], tempslotreverse, i, i)
        else
          tp_dest.transferItem(sides[rs.destination[2]], sides[rs.destination[1]], 64, i, i)
          tempslotreverse = tempslotreverse - 64
        end
      end
      tp_dest.transferItem(sides[rs.destination[2]], sides[rs.destination[1]], mf.getIndex(rs.rstorages_order, data.storage), 27, 27)
      tp_dest.transferItem(sides[rs.destination[2]], sides[rs.destination[1]], freenetslot, 25, 25)
      tp_dest.transferItem(sides[rs.destination[2]], sides[rs.destination[1]], mf.getIndex(rs.netsides_order, rs.netcards[id].side), 26, 26)

      --set variables
      if timeout ~= 100 then
        rstorages[data.storage][rs.rorder[freenetslot]] = id
        save()
      end
      --m.send(remoteAddress, 478, serial.serialize(rs))

    elseif data.method == "pull" then
                    
        --Get slot at the refined storage network
        local freenetslot = -1
        for i,j in pairs(rs.rorder) do
          if rs.rstorages[data.storage][j] == id then
            freenetslot = i
            break
          end
        end
        if freenetslot ~= -1 then
        --Push items for rftools-processor 
        --items to indicate in which slot the Network-Card is located 
        local times = mf.MathUp(tempslot/64)
        for i = 1, times, 1 do
          if tempslot <= 64 then
            tp_dest.transferItem(sides[rs.destination[1]], sides[rs.destination[2]], tempslot, i, i)
          else
            tp_dest.transferItem(sides[rs.destination[1]], sides[rs.destination[2]], 64, i, i)
            tempslot = tempslot - 64
          end
        end
        --items to indicate at which node the Refined Storage is located
        tp_dest.transferItem(sides[rs.destination[1]], sides[rs.destination[2]], mf.getIndex(rs.rstorages_order, data.storage), 27, 27)
        --items to indicate at which side of node the Network-Card should go
        tp_dest.transferItem(sides[rs.destination[1]], sides[rs.destination[2]], freenetslot, 26, 26)
        --items to indicate in which chest the Network-Card is located 
        tp_dest.transferItem(sides[rs.destination[1]], sides[rs.destination[2]], mf.getIndex(rs.netsides_order, rs.netcards[id].side), 25, 25)
            
        --signal rftools-processor to distribute the Network-Card
        red.setOutput(sides[rs.redstone], 7)
        os.sleep(1)
        --wait until the Network-Card is no longer in the Network-storage-chest
        while tp_net.getStackInSlot(sides[rs.netcards[id].side], rs.netcards[id].slot) ~= nil or timeout < 100 do
          os.sleep(1)
          timeout = timeout + 1
        end
        --turn off signal
        red.setOutput(sides[rs.redstone], 0)
            
        --Push items back
        for i = 1, times, 1 do
          if tempslotreverse <= 64 then
            tp_dest.transferItem(sides[rs.destination[2]], sides[rs.destination[1]], tempslotreverse, i, i)
          else
            tp_dest.transferItem(sides[rs.destination[2]], sides[rs.destination[1]], 64, i, i)
            tempslotreverse = tempslotreverse - 64
          end
        end
        tp_dest.transferItem(sides[rs.destination[2]], sides[rs.destination[1]], mf.getIndex(rs.rstorages_order, data.storage), 27, 27)
        tp_dest.transferItem(sides[rs.destination[2]], sides[rs.destination[1]], freenetslot, 26, 26)
        tp_dest.transferItem(sides[rs.destination[2]], sides[rs.destination[1]], mf.getIndex(rs.netsides_order, rs.netcards[id].side), 25, 25)
      
        --set variables
        if timeout ~= 100 then
            rs.rstorages[data.storage][rs.rorder[freenetslot]] = -1
            save()
        end
        --m.send(remoteAddress, 478, serial.serialize(rs))
        else
          print("Cant pull Network-Card. No Network-Card found.")
        end
    end
  else
    print("Not a valid storage to put the linked Network-Card to.")
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
  data = serial.unserialize(data)
  if mf.containsKey(data, "register") then
    registerNetworkCard(remoteAddress)
  elseif mf.containsKey(data, "check") then
    m.send(remoteAddress, 478, "ok")
  else
    DistributeNetCard(remoteAddress, data)
  end
end)
distributer.registerNetworkCard = registerNetworkCard
distributer.DistributeNetCard = DistributeNetCard
return distributer