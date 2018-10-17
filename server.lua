local c = require("component")
local shell = require("shell")
local m = c.modem
local servers = {
  minecraft="e6c5887f-5058-4067-a2aa-d33a24c4541e";
  chimneys="2583b808-0f6e-4ab4-b3f6-efd1b30a6520"
}
if m.isOpen(123) == false then
  m.open(123)
end
local args = shell.parse( ... )
if args[1] ~= nil then
  if m.address ~= servers[args[1]] then
    m.send(servers[args[1]], 123, "Main")
  else
    print("Server: " .. args[1] .. " already on screen")
  end
end