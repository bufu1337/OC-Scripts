local builder = {}
builder.mf = require("MainFunctions")
builder.model = require("Builder/model")
builder.gui = require("GUI")
builder.gui_obj = {}
builder.buildrobots = {}
builder.gui_obj.app = builder.gui_obj.gui.application()
if builder.mf.filesystem.exists("/home/Builder/buildrobots.lua") then
  builder.buildrobots = require("Builder/buildrobots")
end
--local buildrobots = require("Builder/buildrobots")
--local modem = component.modem
--local pathing = require("Builder/pathing")
--local smartmove = require("smartmove")
--local inventory = require("inventory")
--local util = require("util")

function builder.saveRobots()
  builder.mf.WriteObjectFile(builder.buildrobots,"/home/Builder/buildrobots.lua")
end
function builder.registerRobot(uid, rschest)
  table.insert(builder.buildrobots, {robot=uid, rschest=rschest})
end
function builder.Draw_GUI() 
  builder.gui_obj.app:removeChildren()
  builder.gui_obj.app:addChild(builder.gui_obj.gui.panel(1, 1, builder.gui_obj.app.width, builder.gui_obj.app.height, 0x2D2D2D))
  builder.gui_obj.list = {}
  local c = builder.mf.getCount(builder.model.model_list)
  local ih = math.floor(50 / c)
  if ih == 0 then ih = 1 end
  local h = ih * c
  if h > 50 then h = 50 end
  local y = math.floor(50 - h) + 1
  builder.gui_obj.list.rs = builder.gui_obj.app:addChild(builder.gui_obj.gui.list(3, y, 40, h, ih, 0, 0xE1E1E1, 0x4B4B4B, 0xD2D2D2, 0x4B4B4B, 0x3366CC, 0xFFFFFF, false))
  for i,j in pairs(builder.mf.getSortedKeys(builder.model.model_list)) do
    builder.gui_obj.list.rs:addItem(j).onTouch = function()
      
    end
  end
  
end
function builder.start()

end

--local args, options = shell.parse( ... )
--if args[1] == 'help' then
--  print("commands: start, resume")
--elseif args[1] == 'start' then
--  if args[2] == nil or args[2] == 'help' or args[3] == nil or args[4] == nil then
--    print("usage: builder start $modelname $rotation $start{x=0,y=0,z=0}")
--  else
--    builder.model.loadNewModel(args[2], tonumber(args[3]), serial.unserialize(args[4]))
--    start()
--  end
--elseif args[1] == 'resume' then
--  if args[2] == nil or args[2] == 'help' then
--    print("usage: builder resume $modelname")
--  else
--    builder.model.loadModel(args[2], 0, serial.unserialize({x=0,y=0,z=0}))
--    start()
--  end
--else
--  print("commands: start, resume, help")
--end

local model_loaded = builder.model.loadModel("Brick Mansion - by ND63319", 2, {x=10,y=30,z=65})
if model_loaded then
  print("")
  print("---------------------------------------------- loadedModel ----------------------------------------------")
  builder.mf.printx(builder.model.loadedModel)
  print("")
  print("---------------------------------------------- getModelLevel 1 ----------------------------------------------")
  builder.mf.printx(builder.model.getModelLevelEx(1, 5, 6))
  builder.mf.WriteObjectFile(builder.model.getModelLevelEx(1, 5, 6), "C:/Users/alexandersk/workspace/OC-Scripts/src/Builder/Models/tt.lua")
else
  print("Cant load model: " .. "Brick Mansion - by ND63319")
end

return builder