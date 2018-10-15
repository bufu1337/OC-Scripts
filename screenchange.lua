local thread = require("thread")
local c = require("component")
local event = require("event")
local m = c.modem
local s = require("serialization")
local rs = c.block_refinedstorage_grid_0
local sides = require("sides")
m.close()
m.open(123)
print("screenchange init")
_, _, _, _, _, m = event.pull("modem_message")
print(m)
local t = thread.create(function()
    while true do
        print("a")
        os.sleep()
        print(tostring(c.modem.isOpen(123)))
        _, _, _, _, _, message = event.pull("modem_message")
        print(message)
        --local rs_item = rs.getItem({name="minecraft:stick"}, true)
        --local dropped = rs.extractItem(rs_item, 32, sides.west)
        --print(dropped)
    end
end)
print("screenchange - thread started")

while true do
  local command = io.read()
  if command == "quit sc" then
    break
  end
end
t:kill()