local thread = require("thread")
local c = require("component")
c.modem.open(111)
print("screenchange init")
thread.create(function()
    while true do
        local _, _, _, _, _, message = event.pull("modem_message")
		print(message)
	end
end)
print("screenchange - thread started")