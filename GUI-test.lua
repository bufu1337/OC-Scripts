local s = {}
s.gui = require("GUI")
s.mf = require("MainFunctions")
s.rs = require("rstorages")
s.status = ""
s.app = s.gui.application()

function s.Draw_GUI() 
  s.app:removeChildren()
  s.app:addChild(s.gui.panel(1, 1, s.app.width, s.app.height, 0x2D2D2D))
  
  s.text.rs = s.app:addChild(s.gui.text(88, 26, 0xFFFFFF, "Selected Storage:"))
  s.text.desc = s.app:addChild(s.gui.text(88, 27, 0xFFFFFF, "")) --Description:
  s.text.desc2 = s.app:addChild(s.gui.text(88, 28, 0xFFFFFF, ""))
  s.text.m = s.app:addChild(s.gui.text(121, 32, 0xFFFFFF, "Selected Monitor"))
  s.text.m2 = s.app:addChild(s.gui.text(121, 33, 0xFFFFFF, ""))
  s.text.act = s.app:addChild(s.gui.text(121, 37, 0xFFFFFF, "Action:"))
  s.text.act2 = s.app:addChild(s.gui.text(121, 38, 0xFFFFFF, "No action possible"))
  s.text.add = s.app:addChild(s.gui.text(88, 3, 0xFFFFFF, "Add Monitors:"))
  s.text.remove = s.app:addChild(s.gui.text(126, 3, 0xFFFFFF, "Remove Monitors:"))
  s.text.dis = s.app:addChild(s.gui.text(88, 10, 0xFFFFFF, "Distributor:"))
  
  s.buttons = {}
  s.buttons.restoredis = s.app:addChild(s.gui.roundedButton(88, 10, 15, 1, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Restore"))
  s.buttons.restoredis.onTouch = function()
    
  end
  s.buttons.off = s.app:addChild(s.gui.roundedButton(88, 32, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Turn off monitor"))
  s.buttons.off.onTouch = function()
    
  end
  s.buttons.confirm = s.app:addChild(s.gui.roundedButton(88, 37, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Confirm"))
  s.buttons.confirm.onTouch = function()
    
  end
  s.buttons.register = s.app:addChild(s.gui.roundedButton(120, 42, 25, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Register NetCard"))
  s.buttons.register.onTouch = function()
    
  end
  s.buttons.check = s.app:addChild(s.gui.roundedButton(98, 42, 25, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Check Connection"))
  s.buttons.check.onTouch = function()
    
  end
  s.buttons.exit = s.app:addChild(s.gui.roundedButton(112, 47, 23, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Exit"))
  s.buttons.exit.onTouch = function()
    s.app:draw(false)
    s.app:stop()
    s.mf.os.execute("clear")
  end
  s.buttons.addplus = s.app:addChild(s.gui.roundedButton(116, 2, 3, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "^"))
  s.buttons.addplus.onTouch = function()
    
  end
  s.buttons.addminus = s.app:addChild(s.gui.roundedButton(116, 5, 3, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "v"))
  s.buttons.addminus.onTouch = function()
    
  end
  s.buttons.removeplus = s.app:addChild(s.gui.roundedButton(154, 2, 3, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "^"))
  s.buttons.removeplus.onTouch = function()
    
  end
  s.buttons.removeminus = s.app:addChild(s.gui.roundedButton(154, 5, 3, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "v"))
  s.buttons.removeminus.onTouch = function()
    
  end
  
  s.inputs = {}
  s.inputs.add = s.app:addChild(s.gui.input(110, 4, 5, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "1", ""))
  s.inputs.add .onInputFinished = function()
  
  end
  s.inputs.remove = s.app:addChild(s.gui.input(148, 4, 5, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "1", ""))
  s.inputs.remove .onInputFinished = function()
  
  end
  s.inputs.dis = s.app:addChild(s.gui.input(88, 13, 40, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "", "Distributor UID"))
  s.inputs.dis .onInputFinished = function()
  
  end
  
  local bc = s.mf.getCount(s.rs.rstorages)
  local bb = math.floor(50 / bc)
  local by = math.floor(50 - (bb * bc)) + 1
  s.list.rs = s.app:addChild(s.gui.list(3, by, 40, (bb * bc), bb, 0, 0xE1E1E1, 0x4B4B4B, 0xD2D2D2, 0x4B4B4B, 0x3366CC, 0xFFFFFF, false))
  for i,j in pairs(s.mf.getSortedKeys(s.rs.rstorages)) do
    s.list.rs:addItem(j).onTouch = function()
      s.text.rs.text = "Selected Storage: " .. tostring(s.list.rs:getItem(s.list.rs.selectedItem).text)
    end
  end
  
  bc = s.mf.getCount(s.rs.monitor)
  bb = math.floor(50 / bc)
  by = math.floor(50 - (bb * bc)) + 1
  s.list.m = s.app:addChild(s.gui.list(45, by, 40, (bb * bc), bb, 0, 0xE1E1E1, 0x4B4B4B, 0xD2D2D2, 0x4B4B4B, 0x3366CC, 0xFFFFFF, false))
  for i,j in pairs(s.rs.monitor) do
    local txt= "RS Monitor " .. i
    if j ~= "" then
      txt = txt .. " (" .. j .. ")"
    end
    s.list.m:addItem(txt).onTouch = function()
      s.text.m2.text = tostring(s.list.m:getItem(s.list.m.selectedItem).text)
    end
  end
end
function s.check(set)
  if s.status == "check" then
    for a,b in pairs({"buttons", "inputs", "list", "text"}) do
      for c,d in pairs(s[b]) do
        s.buttons.confirm.disabled = true
      end
    end
  elseif s.status == "check" then
    s.buttons.confirm.disabled = false
  end
end

s.app:draw(true)
s.app:start()

return s