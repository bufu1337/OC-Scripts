local t = {}
t.gui = require("GUI")
t.mf = require("MainFunctions")
t.rs = require("rstorages")

t.app = t.gui.application()
t.app:addChild(t.gui.panel(1, 1, t.app.width, t.app.height, 0x2D2D2D))

t.txt = t.app:addChild(t.gui.text(60, 1, 0xFFFFFF, t.mf.getSortedKeys(t.rs.rstorages)[1]))
t.txt2 = t.app:addChild(t.gui.text(60, 2, 0xFFFFFF, ""))
local bc = t.mf.getCount(t.rs.storages)
local bb = math.floor(50 / bc)
local by = math.floor(50 - (bb * bc)) + 1
t.rsList = t.app:addChild(t.gui.list(3, by, 20, (bb * bc), bb, 0, 0xE1E1E1, 0x4B4B4B, 0xD2D2D2, 0x4B4B4B, 0x3366CC, 0xFFFFFF, false))
for i,j in pairs(t.mf.getSortedKeys(t.rs.rstorages)) do
  t.rsList:addItem(j).onTouch = function()
    t.txt.text = tostring(t.rsList:getItem(t.rsList.selectedItem).text)
  end
end
bc = t.mf.getCount(t.rs.monitor)
bb = math.floor(50 / bc)
by = math.floor(50 - (bb * bc)) + 1
t.mList = t.app:addChild(t.gui.list(27, by, 15, (bb * bc), bb, 0, 0xE1E1E1, 0x4B4B4B, 0xD2D2D2, 0x4B4B4B, 0x3366CC, 0xFFFFFF, false))
for i = 1, #t.rs.monitor, 1 do
  t.mList:addItem("RS Monitor " .. i).onTouch = function()
    t.txt2.text = tostring(t.mList:getItem(t.rsList.selectedItem).text)
  end
end
t.app:addChild(t.gui.roundedButton(60, 46, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Exit")).onTouch = function()
  t.app:draw(false)
  t.app:stop()
end

t.app:draw(true)
t.app:start()

return t