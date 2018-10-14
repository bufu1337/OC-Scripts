local thread = require("thread")
local c = require("component")
local rs = c.block_refinedstorage_grid_2
local sides = require("sides")
c.modem.open(111)
print("screenchange init")
thread.create(function()
    while true do
        local _, _, _, _, _, message = event.pull("modem_message")
		local rs_item = rs.getItem({name="minecraft:stick"}, true)
		local dropped = rs.extractItem(rs_item, 32, sides.down)
		print(dropped)
	end
end)
print("screenchange - thread started")