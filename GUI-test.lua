local t = {}
t.gui = require("GUI")
t.mf = require("MainFunctions")
t.rs = require("rstorages")

t.app = t.gui.application()
t.app:addChild(t.gui.panel(1, 1, t.app.width, t.app.height, 0x2D2D2D))

t.buttons = {}
t.buttons.confirm = t.app:addChild(t.gui.roundedButton(70, 34, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Confirm"))
t.buttons.confirm.disabled = true
t.buttons.confirm.onTouch = function()
  
end
t.buttons.off = t.app:addChild(t.gui.roundedButton(70, 38, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Turn off monitor"))
t.buttons.off.disabled = true
t.buttons.off.onTouch = function()
  
end
t.buttons.register = t.app:addChild(t.gui.roundedButton(70, 42, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Register NetCard"))
t.buttons.register.onTouch = function()
  
end
t.buttons.check = t.app:addChild(t.gui.roundedButton(70, 46, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Check Connection"))
t.buttons.check.onTouch = function()
  
end
t.buttons.exit = t.app:addChild(t.gui.roundedButton(70, 50, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Exit"))
t.buttons.exit.onTouch = function()
  t.app:draw(false)
  t.app:stop()
  t.mf.os.execute("clear")
end
t.buttons.addplus = t.app:addChild(t.gui.roundedButton(96, 5, 2, 2, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "^"))
t.buttons.addplus.onTouch = function()
  
end
t.buttons.addminus = t.app:addChild(t.gui.roundedButton(96, 7, 2, 2, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "v"))
t.buttons.addminus.onTouch = function()
  
end

t.inputs = {}
t.inputs.add = t.app:addChild(t.gui.input(85, 6, 10, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "1", ""))
t.inputs.add .onInputFinished = function()

end
t.inputs.remove = t.app:addChild(t.gui.input(85, 11, 10, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "1", ""))
t.inputs.remove .onInputFinished = function()

end
t.inputs.dis = t.app:addChild(t.gui.input(70, 15, 30, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "", "Distributor UID"))
t.inputs.dis .onInputFinished = function()

end

t.rstxt = t.app:addChild(t.gui.text(70, 20, 0xFFFFFF, "Selected Storage:"))
t.rstxt2 = t.app:addChild(t.gui.text(70, 21, 0xFFFFFF, ""))
t.mtxt = t.app:addChild(t.gui.text(70, 23, 0xFFFFFF, "Selected Monitor"))
t.mtxt2 = t.app:addChild(t.gui.text(70, 24, 0xFFFFFF, ""))
t.desctxt = t.app:addChild(t.gui.text(70, 26, 0xFFFFFF, "Description:"))
t.desctxt2 = t.app:addChild(t.gui.text(70, 27, 0xFFFFFF, ""))
t.acttxt = t.app:addChild(t.gui.text(70, 29, 0xFFFFFF, "Action:"))
t.acttxt2 = t.app:addChild(t.gui.text(70, 30, 0xFFFFFF, "No action possible"))

local bc = t.mf.getCount(t.rs.rstorages)
local bb = math.floor(50 / bc)
local by = math.floor(50 - (bb * bc)) + 1
t.rsList = t.app:addChild(t.gui.list(3, by, 20, (bb * bc), bb, 0, 0xE1E1E1, 0x4B4B4B, 0xD2D2D2, 0x4B4B4B, 0x3366CC, 0xFFFFFF, false))
for i,j in pairs(t.mf.getSortedKeys(t.rs.rstorages)) do
  t.rsList:addItem(j).onTouch = function()
    t.rstxt.text = tostring(t.rsList:getItem(t.rsList.selectedItem).text)
  end
end

bc = t.mf.getCount(t.rs.monitor)
bb = math.floor(50 / bc)
by = math.floor(50 - (bb * bc)) + 1
t.mList = t.app:addChild(t.gui.list(25, by, 40, (bb * bc), bb, 0, 0xE1E1E1, 0x4B4B4B, 0xD2D2D2, 0x4B4B4B, 0x3366CC, 0xFFFFFF, false))
for i = 1, #t.rs.monitor, 1 do
  local mtxt = "RS Monitor " .. i
  if t.rs.monitor[i] ~= "" then
    mtxt = mtxt .. " (" .. t.rs.monitor[i] .. ")"
  end
  t.mList:addItem(mtxt).onTouch = function()
    t.mtxt.text = tostring(t.mList:getItem(t.mList.selectedItem).text)
  end
end

t.app:draw(true)
t.app:start()

return t