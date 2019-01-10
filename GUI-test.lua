local t = {}
t.gui = require("GUI")
t.mf = require("MainFunctions")
t.rs = require("rstorages")

t.app = t.gui.application()
t.app:addChild(t.gui.panel(1, 1, t.app.width, t.app.height, 0x2D2D2D))

local textBox = t.app:addChild(t.gui.textBox(2, 2, 32, 16, 0xEEEEEE, 0x2D2D2D, {}, 1, 1, 0))
for i,j in pairs(t.rs) do
  table.insert(textBox.lines, i)
end

t.app:draw(true)
t.app:start()

return t