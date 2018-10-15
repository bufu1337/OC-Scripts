local component = require("component")
local thread = require("thread")
local event = require("event")
local m = component.modem
local s = require("serialization")
local rs = component.block_refinedstorage_network_receiver
local sides = require("sides")
m.close()
m.open(123)
thread.create(function()
    os.sleep(20)
    while true do
      _, _, source, _, _, item = event.pull("modem_message")
      item = s.unserialize(item)
      if (item.get=="getItem") then
        local rs_item = rs.getItem(item, true)
        if(rs_item ~= nil) then
          if(rs_item.size < item.count) then
            item.count = rs_item.size
          end
        else
          item.count = 0
        end
        local returning = {name=item.name, damage=item.damage, count=item.count}
        while item.count > 0 do
          local dropped = rs.extractItem(rs_item, item.count, item.side)
          item.count = item.count - dropped
        end
        m.send(source, 123, s.serialize(returning))
      end
    end
--  local id = event.pull(5, "interrupted")
--  if (id=="interrupted") then
--    print("Programm stopped.")
--    m.close()
--    break
--  end
end)