local s = {}
s.mf = require("MainFunctions")
s.gui = require("GUI")
s.saving = false
s.rs = {}
s.m = s.mf.component.modem
s.status = ""
s.itemselect = {r=1, m=1}
s.focus = ""
s.app = s.gui.application()
local varpath = "/home/RSNetStationVars.lua"

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
  s.text.dis = s.app:addChild(s.gui.text(88, 10, 0xFFFFFF, "Distributor UID:"))
  
  s.buttons = {}
  s.buttons.restoredis = s.app:addChild(s.gui.roundedButton(88, 10, 15, 1, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Restore"))
  s.buttons.restoredis.onTouch = function()
    s.focus = "turnON"
    s.inputs.dis = s.rs.distributor
    s.check()
  end
  s.buttons.off = s.app:addChild(s.gui.roundedButton(88, 32, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Turn off monitor"))
  s.buttons.off.onTouch = function()
    s.RSMonitorOFF(s.text.m2.text:sub(12,12))
  end
  s.buttons.confirm = s.app:addChild(s.gui.roundedButton(88, 37, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Confirm"))
  s.buttons.confirm.onTouch = function()
    if s.focus == "add" then
      
    elseif s.focus == "remove" then
      s.removeRSMonitor(s.inputs.remove.text)
    elseif s.focus == "dis" then
    
    elseif s.focus == "turnON" then
    
    end
  end
  s.buttons.check = s.app:addChild(s.gui.roundedButton(98, 47, 25, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Check Connection"))
  s.buttons.check.onTouch = function()
    s.checkConnection(true)
  end
  s.buttons.exit = s.app:addChild(s.gui.roundedButton(120, 47, 25, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Exit"))
  s.buttons.exit.onTouch = function()
    s.app:draw(false)
    s.app:stop()
    s.mf.os.execute("reboot")
  end
  s.buttons.addplus = s.app:addChild(s.gui.roundedButton(116, 2, 3, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "^"))
  s.buttons.addplus.onTouch = function()
    s.focus = "add"
    s.check()
  end
  s.buttons.addminus = s.app:addChild(s.gui.roundedButton(116, 5, 3, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "v"))
  s.buttons.addminus.onTouch = function()
    s.focus = "add"
    s.check()
  end
  s.buttons.removeplus = s.app:addChild(s.gui.roundedButton(154, 2, 3, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "^"))
  s.buttons.removeplus.onTouch = function()
    s.focus = "remove"
    s.check()
  end
  s.buttons.removeminus = s.app:addChild(s.gui.roundedButton(154, 5, 3, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "v"))
  s.buttons.removeminus.onTouch = function()
    s.focus = "remove"
    s.check()
  end
  
  s.inputs = {}
  s.inputs.add = s.app:addChild(s.gui.input(110, 4, 5, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "1", ""))
  s.inputs.add.onInputFinished = function()
    s.focus = "add"
    s.check()
  end
  s.inputs.remove = s.app:addChild(s.gui.input(148, 4, 5, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "1", ""))
  s.inputs.remove.onInputFinished = function()
    s.focus = "remove"
    s.check()
  end
  s.inputs.dis = s.app:addChild(s.gui.input(88, 13, 40, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, s.rs.distributor, "Distributor UID"))
  s.inputs.dis.onInputFinished = function()
    s.focus = "dis"
    s.check()
  end
  
  local bc = s.mf.getCount(s.rs.rstorages)
  local bb = math.floor(50 / bc)
  local by = math.floor(50 - (bb * bc)) + 1
  s.list.rs = s.app:addChild(s.gui.list(3, by, 40, (bb * bc), bb, 0, 0xE1E1E1, 0x4B4B4B, 0xD2D2D2, 0x4B4B4B, 0x3366CC, 0xFFFFFF, false))
  for i,j in pairs(s.mf.getSortedKeys(s.rs.rstorages)) do
    s.list.rs:addItem(j).onTouch = function()
      s.itemselect.r = s.list.m.selectedItem
      s.text.rs.text = "Selected Storage: " .. tostring(s.list.rs:getItem(s.list.rs.selectedItem).text)
    end
  end
  s.list.r.selectedItem = s.itemselect.r
  s.text.rs.text = "Selected Storage: " .. tostring(s.list.rs:getItem(s.list.rs.selectedItem).text)
  
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
      s.itemselect.m = s.list.m.selectedItem
      s.text.m2.text = tostring(s.list.m:getItem(s.list.m.selectedItem).text)
    end
  end
  s.list.m.selectedItem = s.itemselect.m
  s.text.m2.text = tostring(s.list.m:getItem(s.list.m.selectedItem).text)
  s.focus = "turnON"
  s.check()
end
function s.check()
  if s.status == "check" then
    for a,b in pairs({"buttons", "inputs", "list", "text"}) do
      for c,d in pairs(s[b]) do
        s[b][c].disabled = true
      end
    end
    s.buttons.exit.disabled = false
    s.buttons.check.disabled = false
    s.text.act.disabled = false
    s.text.act2.disabled = false
    s.text.act2.text = "No connection to distributor. Please Check!"
  else
    for a,b in pairs({"buttons", "inputs", "list", "text"}) do
      for c,d in pairs(s[b]) do
        s[b][c].disabled = false
      end
    end
    s.text.act2.text = "No action available!"
    
    if s.inputs.dis == s.rs.distributor then
      s.buttons.restore.disabled = true
    end
    if #s.text.m2.text == 12 then
      s.buttons.off.disabled = true
    end
    
    if s.focus == "add" then
      local temp = tonumber(s.inputs.add.text)
      if temp == nil then
        s.text.act2.text = "Cant add monitors! Give in a number!"
        s.buttons.confirm.disabled = true
      else
        s.text.act2.text = "Add " .. temp .. " monitors. Please confirm!"
      end
    elseif s.focus == "remove" then
      local temp = tonumber(s.inputs.add.text)
      if temp == nil then
        s.text.act2.text = "Cant remove monitor! Give in a number!"
        s.buttons.confirm.disabled = true
      elseif temp == nil then
        s.text.act2.text = "Cant remove monitor! Monitor does not exist!"
        s.buttons.confirm.disabled = true
      else
        s.text.act2.text = "Remove monitor " .. temp .. ". Please confirm!"
      end
    elseif s.focus == "dis" then
    
    elseif s.focus == "turnON" then
    
    else
      s.buttons.confirm.disabled = true
    end
  end
end

function s.save()
  if s.saving then
    local rstorages = s.mf.copyTable(s.rs.rstorages)
    s.rs.rstorages = nil
    s.mf.WriteObjectFile(s.rs, varpath)
    s.rs.rstorages = s.mf.copyTable(rstorages)
  end
end
function s.addRSMonitors(count)
  for i = 1, count, 1 do
    table.insert(s.rs.monitor,"")
  end
  s.save()
end
function s.removeRSMonitor(num)
  s.rs.monitor[num] = nil
  s.save()
end
function s.setDistributor(dis)
  s.rs.distributor = dis
  s.save()
end

function s.start()
  if s.mf.filesystem.exists(varpath) == false then
    s.mf.WriteObjectFile({distributor="", monitor={}}, varpath)
  end
  s.rs = require("RSNetStationVars")
  if s.rs.distributor == "" then
    print("Please type in the uid of the distributors modem")
    s.setDistributor(s.mf.io.read())
  end
  if #s.rs.monitor == 0 then
    print("How many monitors do you have")
    s.addRSMonitors(s.mf.io.read())
  end
  s.m.close(478)
  s.m.open(478)
  s.saving = true
  s.checkConnection(true)
  s.app:draw(true)
  s.app:start()
end

function s.RSMonitorON(mod, monitor)
  if s.rs.monitor[monitor] ~= nil and s.rs.monitor[monitor] ~= mod then
    if s.rs.monitor[monitor] ~= mod then
        s.m.send(s.rs.distributor, 478, s.mf.serial.serialize({method="push", storage=mod, rsmonitor=monitor},true))
        s.checkConnection(false)
    else
      print("Monitor already showing Refined Storage: " .. mod)
    end
  else
    print("Monitor not found. Try the method addRSMonitors(count).")
  end
end
function s.RSMonitorOFF(monitor)
  if s.rs.monitor[monitor] ~= nil then
    if s.rs.monitor[monitor] ~= "" then
        s.m.send(s.rs.distributor, 478, s.mf.serial.serialize({method="pull", storage=s.rs.monitor[monitor], rsmonitor=monitor},true))
        s.checkConnection(false)
    else
      print("Monitor already OFF")
    end
  else
    print("Monitor not found. Try the method addRSMonitors(count).")
  end
end
function s.registerNetworkCards()
  s.m.send(s.rs.distributor, 478, s.mf.serial.serialize({"register"},true))
end
function s.checkConnection(askfor)
  if s.timer ~= nil then
    s.mf.event.cancel(s.timer)
  end
  if askfor == nil or askfor == true then
    s.m.send(s.rs.distributor, 478, s.mf.serial.serialize({"check"},true))
  end
  local _, localAddress, remoteAddress, port, distance, data = s.mf.event.pull(10, "modem_message")
  if data ~= nil then
    data = s.mf.serial.unserialize(data)
    s.rs.rstorages = s.mf.copyTable(data.rstorages)
    if data.monitor ~= nil then
      s.rs.monitor = s.mf.combineTables(s.rs.monitor, data.monitor)
    end
    s.save()
    s.status = ""
    s.Draw_GUI()
    s.timer = s.mf.event.timer(60, function()
      s.status = "check"
      s.check()
    end, 1)
  else
    s.status = "check"
  end
end
s.start()
return s