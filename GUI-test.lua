local t = {}
t.gui = require("GUI")
t.mf = require("MainFunctions")
t.rs = require("rstorages")

t.app = t.gui.application(0,0,640,480)
t.app:addChild(t.gui.panel(1, 1, t.app.width, t.app.height, 0x2D2D2D))

local verticalList = t.app:addChild(t.gui.list(3, 2, 25, 50, 1, 0, 0xE1E1E1, 0x4B4B4B, 0xD2D2D2, 0x4B4B4B, 0x3366CC, 0xFFFFFF, false))
for i,j in pairs(t.rs) do
  verticalList:addItem(i)
  --table.insert(textBox.lines, i)
end

--local textBox = t.app:addChild(t.gui.textBox(2, 2, 32, 40, 0xEEEEEE, 0x2D2D2D, {}, 1, 1, 0))
--for i,j in pairs(t.rs) do
--  table.insert(textBox.lines, i)
--end

t.app:draw(true)
t.app:start()

return t