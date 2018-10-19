local fs = require("filesystem")
local shell = require("shell")
 
local args, options = shell.parse(...)
if #args < 2 then
  io.write("Usage:\n")
  io.write("  hddclone <from> <to>")
  return
end

local fromstr = args[1]
local from = { path = "/mnt/" .. args[1] }

for times = 2, #args, 1 do
    local to = { path = "/mnt/" .. args[times] } 
    io.write("Copying files from " .. from.path .. " to " .. to.path .. ".\n")
    shell.execute("cp -v -r " .. from.path .. "* " .. to.path)
    io.write("Done!\n")
end