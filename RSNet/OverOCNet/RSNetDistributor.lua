local dis = {gui = require("GUI"), mf = require("MainFunctions"), rs = {}, tp_net = "", tp_dest = "", listener = "", distime = 50}
dis.red = dis.mf.component.redstone
dis.modem = dis.mf.component.modem

function dis.save()
  dis.mf.WriteObjectFile(dis.rs, "/home/RSNetComponents.lua")
  dis.rs = require("RSNetComponents")
end
local function storeNetworkCard(side, sourceslot, slot)
  dis.tp_net.transferItem(dis.mf.sides[dis.rs.storingside], dis.mf.sides[side], 1, sourceslot, slot)
end

function dis.RegisterNetCard(data)
  local cards = {}
  local returning = {}
  for i = 1, 27, 1 do
    if dis.tp_net.getStackInSlot(dis.mf.sides[dis.rs.storingside], i) ~= nil then
      local temp = 1
      for a,b in pairs(dis.rs.netcards) do
        if b.station == data.station and b.rsmonitor >= temp then
          temp = b.rsmonitor + 1
        end
      end
      cards[(#cards + 1)] = temp
    end
  end
  if #cards == 0 then
    --"Put a linked Network-Card into the chest for storing."
  else
    if data.station ~= "" then
      for g,h in pairs(cards) do
        local id = -1
        local netside = ""
        local b = 1
        for i = 1, #dis.rs.netsides_order, 1 do
          if dis.rs.netsides[dis.rs.netsides_order[i]].size ~= -1 and dis.rs.netsides[dis.rs.netsides_order[i]].next <= dis.rs.netsides[dis.rs.netsides_order[i]].size then
            id = dis.rs.netsides[dis.rs.netsides_order[i]].next + ((i - 1) * dis.rs.netsides[dis.rs.netsides_order[i]].size)
            netside = dis.rs.netsides_order[i]
            b = i
            break
          end
        end
        if id ~= -1 then
          dis.rs.netcards[id] = {station=data.station, rsmonitor=h, side=netside, slot=dis.rs.netsides[netside].next}
          for i = 1, dis.rs.netsides[netside].size, 1 do
            if dis.rs.netcards[i + ((b - 1) * dis.rs.netsides[netside].size)] == nil then
              dis.rs.netsides[netside].next = i
              break
            end
          end
          storeNetworkCard(dis.rs.netcards[id].side, h, dis.rs.netcards[id].slot)
          dis.save()
        end
      end
    end
  end
  dis.StationCheck(data)
end

function dis.StationCheck(data)
  local station_message = {"RSNet", ocnet=data.ocnet, rstorages={}, stations={}}
  --{net=netid, rsmonitor=h, side=netside, slot=rs.netsides[netside].next}
  local cards = {}
  for i,j in pairs(dis.rs.netcards) do
    if j.station == data.station then
      table.insert(cards,i)
      if station_message[j.station] == nil then
        station_message[j.station] = {monitor={}}
      end
      station_message[j.station].monitor[dis.rs.netcards[i].rsmonitor] = ""
    end
  end
  for a,b in pairs(dis.rs.rstorages) do
    station_message.rstorages[a] = {desc=b.desc}
    for i,j in pairs(dis.rs.rorder) do
      if b[j] ~=-1 then
        if dis.mf.contains(cards, b[j]) then
          station_message.monitor[dis.rs.netcards[b[j]].rsmonitor] = a
        end
      end
    end
  end
  dis.modem.send(data.remoteAddress, 478, dis.mf.serial.serialize(station_message))
end

function dis.DistributeNetCard(data)
  local id = -1
  local tempslot = -1
  local tempslotreverse = -1
  local timeout = 0
  if dis.mf.contains(dis.rs.rstorages_order, data.storage) then
    
    --get network-card-id
    for i,j in pairs(dis.rs.netcards) do
      if j.station == data.station and j.rsmonitor == data.rsmonitor then
        id = i
        tempslot = j.slot
        tempslotreverse = tempslot
        break
      end
    end

    if id == -1 then
      print("Cant find a registered Network-Card for this address.")
    elseif data.method == "push" then
      
      --Get Network-Card if it is in another storage
      for a,b in pairs(dis.rs.rstorages) do
        local found = false
        for i,j in pairs(dis.rs.rorder) do
          if b[j] == id then
            print("Network-Card found at: " .. a .. " (" .. j .. ") --- Pulling")
            dis.DistributeNetCard({method="pull", storage=a, rsmonitor=dis.rs.netcards[id].rsmonitor, station=dis.rs.netcards[id].station})
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
      for i,j in pairs(dis.rs.rorder) do
        if dis.rs.rstorages[data.storage][j] == -1 then
          freenetslot = i
          break
        end
      end
      --Pull out a Network-Card if all slots are occupied
      if freenetslot == -1 then
        local templast = dis.rs.rstorages[data.storage]["last"]
        local tempid = dis.rs.rstorages[data.storage][dis.rs.rorder[templast]]
        dis.DistributeNetCard({method="pull", storage=data.storage, rsmonitor=dis.rs.netcards[tempid].rsmonitor, station=dis.rs.netcards[tempid].station})
        freenetslot = templast
        if (templast + 1) == 5 then
          dis.rs.rstorages[data.storage]["last"] = 1
        else
          dis.rs.rstorages[data.storage]["last"] = templast + 1
        end
      end

      --Push items for rftools-processor 
      --items to indicate in which slot the Network-Card is located 
      local times = dis.mf.MathUp(tempslot/64)
      for i = 1, times, 1 do
        if tempslot <= 64 then
          dis.tp_dest.transferItem(dis.mf.sides[dis.rs.destination[1]], dis.mf.sides[dis.rs.destination[2]], tempslot, i, i)
        else
          dis.tp_dest.transferItem(dis.mf.sides[dis.rs.destination[1]], dis.mf.sides[dis.rs.destination[2]], 64, i, i)
          tempslot = tempslot - 64
        end
      end
      --items to indicate at which node the Refined Storage is located
      dis.tp_dest.transferItem(dis.mf.sides[dis.rs.destination[1]], dis.mf.sides[dis.rs.destination[2]], dis.mf.getIndex(dis.rs.rstorages_order, data.storage), 27, 27)
      --items to indicate at which side of node the Network-Card should go
      dis.tp_dest.transferItem(dis.mf.sides[dis.rs.destination[1]], dis.mf.sides[dis.rs.destination[2]], freenetslot, 25, 25)
      --items to indicate in which chest the Network-Card is located 
      dis.tp_dest.transferItem(dis.mf.sides[dis.rs.destination[1]], dis.mf.sides[dis.rs.destination[2]], dis.mf.getIndex(dis.rs.netsides_order, dis.rs.netcards[id].side), 26, 26)
      
      --signal rftools-processor to distribute the Network-Card
      dis.red.setOutput(dis.mf.sides[dis.rs.redstone], 0)
      if data.removing ~= nil then
        dis.red.setOutput(dis.mf.sides[dis.rs.redstone], 1)
      else
        dis.red.setOutput(dis.mf.sides[dis.rs.redstone], 15)
      end
      dis.mf.os.sleep(1)
      --wait until the Network-Card is no longer in the Network-storage-chest
      while dis.tp_net.getStackInSlot(dis.mf.sides[dis.rs.netcards[id].side], dis.rs.netcards[id].slot) ~= nil and timeout < dis.distime do
        dis.mf.os.sleep(1)
      end
      --turn off signal
      dis.red.setOutput(dis.mf.sides[dis.rs.redstone], 0)
      
      --Push items back
      for i = 1, times, 1 do
        if tempslotreverse <= 64 then
          dis.tp_dest.transferItem(dis.mf.sides[dis.rs.destination[2]], dis.mf.sides[dis.rs.destination[1]], tempslotreverse, i, i)
        else
          dis.tp_dest.transferItem(dis.mf.sides[dis.rs.destination[2]], dis.mf.sides[dis.rs.destination[1]], 64, i, i)
          tempslotreverse = tempslotreverse - 64
        end
      end
      dis.tp_dest.transferItem(dis.mf.sides[dis.rs.destination[2]], dis.mf.sides[dis.rs.destination[1]], dis.mf.getIndex(dis.rs.rstorages_order, data.storage), 27, 27)
      dis.tp_dest.transferItem(dis.mf.sides[dis.rs.destination[2]], dis.mf.sides[dis.rs.destination[1]], freenetslot, 25, 25)
      dis.tp_dest.transferItem(dis.mf.sides[dis.rs.destination[2]], dis.mf.sides[dis.rs.destination[1]], dis.mf.getIndex(dis.rs.netsides_order, dis.rs.netcards[id].side), 26, 26)

      --set variables
      if timeout ~= dis.distime then
        if data.removing ~= nil then
          dis.rs.netcards[id] = nil
        else
          dis.rs.rstorages[data.storage][dis.rs.rorder[freenetslot]] = id
        end
        dis.save()
      end
      dis.StationCheck(data.station)

    elseif data.method == "pull" then
                    
        --Get slot at the refined storage network
        local freenetslot = -1
        for i,j in pairs(dis.rs.rorder) do
          if dis.rs.rstorages[data.storage][j] == id then
            freenetslot = i
            break
          end
        end
        if freenetslot ~= -1 then
        --Push items for rftools-processor 
        --items to indicate in which slot the Network-Card is located 
        local times = dis.mf.MathUp(tempslot/64)
        for i = 1, times, 1 do
          if tempslot <= 64 then
            dis.tp_dest.transferItem(dis.mf.sides[dis.rs.destination[1]], dis.mf.sides[dis.rs.destination[2]], tempslot, i, i)
          else
            dis.tp_dest.transferItem(dis.mf.sides[dis.rs.destination[1]], dis.mf.sides[dis.rs.destination[2]], 64, i, i)
            tempslot = tempslot - 64
          end
        end
        --items to indicate at which node the Refined Storage is located
        dis.tp_dest.transferItem(dis.mf.sides[dis.rs.destination[1]], dis.mf.sides[dis.rs.destination[2]], dis.mf.getIndex(dis.rs.rstorages_order, data.storage), 27, 27)
        --items to indicate at which side of node the Network-Card should go
        dis.tp_dest.transferItem(dis.mf.sides[dis.rs.destination[1]], dis.mf.sides[dis.rs.destination[2]], freenetslot, 26, 26)
        --items to indicate in which chest the Network-Card is located 
        dis.tp_dest.transferItem(dis.mf.sides[dis.rs.destination[1]], dis.mf.sides[dis.rs.destination[2]], dis.mf.getIndex(dis.rs.netsides_order, dis.rs.netcards[id].side), 25, 25)
            
        --signal rftools-processor to distribute the Network-Card
        dis.red.setOutput(dis.mf.sides[dis.rs.redstone], 0)
        dis.red.setOutput(dis.mf.sides[dis.rs.redstone], 7)
        dis.mf.os.sleep(1)
        --wait until the Network-Card is no longer in the Network-storage-chest
        while dis.tp_net.getStackInSlot(dis.mf.sides[dis.rs.netcards[id].side], dis.rs.netcards[id].slot) == nil and timeout < dis.distime do
          dis.mf.os.sleep(1)
          timeout = timeout + 1
        end
        --turn off signal
        dis.red.setOutput(dis.mf.sides[dis.rs.redstone], 0)
            
        --Push items back
        for i = 1, times, 1 do
          if tempslotreverse <= 64 then
            dis.tp_dest.transferItem(dis.mf.sides[dis.rs.destination[2]], dis.mf.sides[dis.rs.destination[1]], tempslotreverse, i, i)
          else
            dis.tp_dest.transferItem(dis.mf.sides[dis.rs.destination[2]], dis.mf.sides[dis.rs.destination[1]], 64, i, i)
            tempslotreverse = tempslotreverse - 64
          end
        end
        dis.tp_dest.transferItem(dis.mf.sides[dis.rs.destination[2]], dis.mf.sides[dis.rs.destination[1]], dis.mf.getIndex(dis.rs.rstorages_order, data.storage), 27, 27)
        dis.tp_dest.transferItem(dis.mf.sides[dis.rs.destination[2]], dis.mf.sides[dis.rs.destination[1]], freenetslot, 26, 26)
        dis.tp_dest.transferItem(dis.mf.sides[dis.rs.destination[2]], dis.mf.sides[dis.rs.destination[1]], dis.mf.getIndex(dis.rs.netsides_order, dis.rs.netcards[id].side), 25, 25)
      
        --set variables
        if timeout ~= dis.distime then
            dis.rs.rstorages[data.storage][dis.rs.rorder[freenetslot]] = -1
            dis.save()
        end
        dis.StationCheck(data)
        else
          print("Cant pull Network-Card. No Network-Card found.")
        end
    end
  else
    print("Not a valid storage to put the linked Network-Card to.")
  end
end
function dis.addRStorage(name, description, save)
  table.insert(dis.rs.rstorages,1)
end
local function setup()  
  print("Welcome to Refined Stoarge Net.")
--  print("This is the setup for the distribution of Network-Cards over OpenComputers-Network.")
--  print("It is only useful if you have more then one Refined Storage System.")
--  print("")
--  print("The Refined Storage Systems must be at one location in your world.")
--  print("Please build them as close as possible with the following build-pattern.")
--  print("   ( Letters '< ^ v >' mean that the block front facing this direction")
--  print("   Ground:    (powersupply)()()()")
--  print("   1st Level: (refinedstorage:controlblock)()()()")
--  print("")
--  print("Please build this Distributor-Computer near your Refined Storage Systems.")
--  
--  print("Goal of this script:")
--  
--  print("   You can have RSNet-Stations somewhere in the world with ")
--  print("")
--  print("Other Mods needed: RFTools, Refined Storage, Mekanism")
--  print("Optional Mod: Actually Additions (or other mod containing large chests)")
--  print("")
--  
--  print("")
--  print("Please put in the distribution chest:")
--  print("  First slots: (SlotCount of largest Network-Cards-Chest)x Cobblestone")
--  print("  Slot 25: 4x Diorit")
--  print("  Slot 26: 4x Dirt")
--  print("  Slot 27: 64x Stone")
  local ocnetsuccess = dis.mf.SetComputerName("RSNet")
  print("Please enter the Transposer UID for storing the Network-Cards.")
  dis.rs.transposer_netcards = dis.mf.getComponentProxyInput()
  print("Please enter the Transposer UID for the storage of items for distribution.")
  dis.rs.transposer_destination = dis.mf.getComponentProxyInput()
  print("Please enter the storing side. (Side from transposer where you put in the Network-Cards.)")
  dis.rs.storingside = dis.mf.getSidesInput(1, {"east", "west", "north", "south"})
  local tempswitch = {east={"up", "north", "west", "south"}, west={"up", "south", "east", "north"}, south={"up", "east", "north", "west"}, north={"up", "west", "south", "east"}}
  dis.rs.netsides_order = dis.mf.copyTable(tempswitch[dis.rs.storingside])
  dis.rs.netsides = {}
  for i,j in pairs(dis.rs.netsides_order) do
    dis.rs.netsides[j] = {size=-1, next=1}
  end
  dis.rs.destination = {tempswitch[dis.rs.storingside][3], "down"}
  dis.rs.redstone = tempswitch[dis.rs.storingside][4]
  print("To which sides are your Refined Storage Systems facing? Enter 2 opposite sides.")
  dis.rs.rorder = dis.mf.getSidesInput(2, {"east", "west", "north", "south"}, true)
  dis.rs.rorder = {"up", "down", dis.rs.rorder[1], dis.rs.rorder[2]}
  print("How many Refined Storage Systems do you have?")
  local rscount = dis.mf.getNumericInput(1,50)
  print("Please enter names and descriptions for Refined Storage Systems:")
  print("(names must be without blanks, blanks will be replace by underline)")
  dis.rs.rstorages = {}
  dis.rs.rstorages_order = {}
  for i = 1, rscount, 1 do
    print(i .. ". Name:")
    local temp = dis.mf.io.read()
    temp = tostring(temp:gsub(" ", "_"))
    table.insert(dis.rs.rstorages_order, temp)
    print(i .. ". Descriptions:")
    local temp2 = dis.mf.io.read()
    dis.rs.rstorages[temp] = {up=-1, down=-1, [dis.rs.rorder[3]]=-1, [dis.rs.rorder[4]]=-1, last=1, desc=temp2}
  end
  dis.rs.netcards = {}
  dis.save()
  return ocnetsuccess
end

function dis.start()
  local ocnetsuccess = true
  if dis.mf.filesystem.exists("/home/RSNetComponents.lua") then
    dis.rs = require("RSNetComponents")
    ocnetsuccess = dis.mf.SetComputerName("RSNet")
  else
    ocnetsuccess = setup()
  end
  if ocnetsuccess == false then
    print("Cant start Distributor. OCNet is not connected.")
    return
  end
  dis.name = require("ComputerName").RSNet
  dis.tp_net = dis.mf.component.proxy(dis.rs.transposer_netcards)
  dis.tp_dest = dis.mf.component.proxy(dis.rs.transposer_destination)
  for i = 1, #dis.rs.netsides_order, 1 do
    dis.rs.netsides[dis.rs.netsides_order[i]].size = dis.tp_net.getInventorySize(dis.mf.sides[dis.rs.netsides_order[i]])
  end
  dis.save()
  dis.modem.close(478)
  dis.modem.open(478)
  dis.listener = dis.mf.thread.create(function()
    while true do
      local _, localAddress, remoteAddress, port, distance, data = dis.mf.event.pull("modem_message")
      data = dis.mf.serial.unserialize(data)
      if dis.mf.containsKey(data, "OCNet") then
        if data.OCNet.toSystem == "RSNet" then
          if data.OCNet.to == dis.name then
            print("")
            print("Received message:")
            print("Data: " .. data)
            data.remoteAddress = remoteAddress
            if dis.mf.contains(data, "register", "number") then
              dis.RegisterNetCard(data)
            elseif dis.mf.contains(data, "check", "number") then
              dis.StationCheck(data)
            elseif dis.mf.containsKeys(data, {"method", "storage", "rsmonitor"}) then
              dis.DistributeNetCard(data)
            else
              print("Cant handle received data.")
            end
          else
            print("Received message not for me.")
          end
        else
          print("Received message not for me.")
        end
      else
        print("Received message not for me.")
      end
    end
  end)
end
function dis.StopListening()
  dis.listener:kill()
end
dis.start()
return dis