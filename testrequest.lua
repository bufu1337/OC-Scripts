local os = require("os")
local c = require("component")
local event = require("event")
local sides = require("sides")
local m = c.modem
local s = require("serialization")
local rs = c.block_refinedstorage_grid_2
m.open(123)
m.broadcast(123, s.serialize({get="getItem", name="minecraft:planks", damage=0.0, count=32, side=sides.east}))
_, _, _, _, _, item = event.pull("modem_message")
item = s.unserialize(item)
os.sleep(0.005)
local rs_item = rs.getItem(item)
if(rs_item ~= nil) then
  print(rs_item.size)
else
  print(0)
end