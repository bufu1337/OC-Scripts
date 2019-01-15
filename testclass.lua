local dis = {mf = require("MainFunctions"), rs = {}}
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
  print("Please give in the Transposer UID for storing the Network-Cards.")
  dis.rs.transposer_netcards = dis.mf.getComponentProxyInput()
  print("Please give in the Transposer UID for the storage of items for distribution.")
  dis.rs.transposer_destination = dis.mf.getComponentProxyInput()
  print("Please give in the storing side. (Side from transposer where you put in the Network-Cards.)")
  dis.rs.storingside = dis.mf.getSidesInput(1, {"east", "west", "north", "south"})
  local tempswitch = {east={"up", "north", "west", "south"}, west={"up", "south", "east", "north"}, south={"up", "east", "north", "west"}, north={"up", "west", "south", "east"}}
  dis.rs.netsides_order = dis.mf.copyTable(tempswitch[dis.rs.storingside])
  dis.rs.netsides = {}
  for i,j in pairs(dis.rs.netsides_order) do
    dis.rs.netsides[j] = {size=-1, next=1}
  end
  dis.rs.destination = {tempswitch[dis.rs.storingside][3], "down"}
  dis.rs.redstone = tempswitch[dis.rs.storingside][4]
  print("To which sides are your Refined Storage Systems facing? Give in 2 opposite sides.")
  dis.rs.rorder = dis.mf.getSidesInput(2, {"east", "west", "north", "south"}, true)
  dis.rs.rorder = {"up", "down", dis.rs.rorder[1], dis.rs.rorder[2]}
  print("How many Refined Storage Systems do you have?")
  local rscount = dis.mf.getNumericInput(1,50)
  print("Please enter names and descriptions for Refined Storage Systems:")
  dis.rs.rstorages = {}
  dis.rs.rstorages_order = {}
  dis.rs.netcards = {}
  for i = 1, rscount, 1 do
    print(i .. ". Name:")
    local temp = dis.mf.io.read()
    table.insert(dis.rs.rstorages_order, temp)
    print(i .. ". Descriptions:")
    local temp2 = dis.mf.io.read()
    dis.rs.rstorages[temp] = {up=-1, down=-1, [dis.rs.rorder[3]]=-1, [dis.rs.rorder[4]]=-1, last=1, desc=temp2}
  end
  --dis.save()
end
setup()
print("")
print("")
print("")
print("")
dis.mf.printx(dis.rs)
return dis