local shell = require("shell")
local objectStore = require("objectStore")
local component = require("component")
local sides = require("sides")
local serial = require("serialization")
local thread = require("thread")
local buildrobots = require("Builder/buildrobots")
local modem = component.modem
local builder = {}
builder.model = require("Builder/model")
--local pathing = require("Builder/pathing")
--local smartmove = require("smartmove")
--local inventory = require("inventory")
--local util = require("util")

local function start()

end

local args, options = shell.parse( ... )
if args[1] == 'help' then
  print("commands: start, resume")
elseif args[1] == 'start' then
  if args[2] == nil or args[2] == 'help' or args[3] == nil or args[4] == nil then
    print("usage: builder start $modelname $rotation $start{x=0,y=0,z=0}")
  else
    model.loadNewModel(args[2], tonumber(args[3]), serial.unserialize(args[4]))
    start()
  end
elseif args[1] == 'resume' then
  if args[2] == nil or args[2] == 'help' then
    print("usage: builder resume $modelname")
  else
    model.loadModel(args[2], 0, serial.unserialize({x=0,y=0,z=0}))
    start()
  end
else
  print("commands: start, resume, help")
end

return builder