local t = {}
t.gui = require("GUI")
t.mf = require("MainFunctions")
t.rs = require("rstorages")

t.app = t.gui.application()
--t.app:addChild(t.gui.panel(1, 1, t.app.width, t.app.height, 0x2D2D2D))

local txt = t.app:addChild(t.gui.text(3, 2, 0xFFFFFF, "Hello, world!"))
local verticalList = t.app:addChild(t.gui.list(3, 2, 25, 49, 1, 0, 0xE1E1E1, 0x4B4B4B, 0xD2D2D2, 0x4B4B4B, 0x3366CC, 0xFFFFFF, false))
for i,j in pairs(t.mf.getSortedKeys(t.rs)) do
  verticalList:addItem(i).onTouch = function()
    txt.text = t.mf.serial.serialize(verticalList:getItem(verticalList.selectedItem), true)
    t.mf.WriteObjectFile(verticalList:getItem(verticalList.selectedItem), "/home/listitem.lua")
  end
  --table.insert(textBox.lines, i)
end

--local textBox = t.app:addChild(t.gui.textBox(2, 2, 32, 40, 0xEEEEEE, 0x2D2D2D, {}, 1, 1, 0))
--for i,j in pairs(t.rs) do
--  table.insert(textBox.lines, i)
--end

t.app:draw(true)
t.app:start()

return t