local thread = require("thread")
local c = require("component")
local os = require("os")
local event = require("event")
local m = c.modem
local gpu = c.gpu
local sides = require("sides")
local screen = {
    Temp="912e8944-1357-42cd-8dbf-e8140f7627e4";
    Main="9a85f463-04f0-45e6-a803-b1dafa230b47"
}
m.close()
m.open(123)
print("screenchange init")
local t = thread.create(function()
    while true do
        os.sleep()
        local _, _, from, _, _, where = event.pull("modem_message")
        print(where)
        gpu.bind(screen[where], true)
        if where == "Main" then
            if m.address ~= from then
                m.send(from, 123, "Temp")
            end
        end
    end
end)
print("screenchange - thread started")

while true do
  local command = io.read()
  if command == "quit sc" then
    break
  else
    os.execute(command)
  end
end
t:kill()