local s = {}
s.mf = require("MainFunctions")
s.gui = require("GUI")
s.saving = false
s.rs = {}
s.m = s.mf.component.modem
s.status = ""
s.statusc = ""
s.timercount = 30
s.itemselect = {r=1, m=1, reg=true}
s.app = s.gui.application()
local varpath = "/home/RSNetStationVars.lua"

function s.Draw_GUI() 
  s.app:removeChildren()
  s.app:addChild(s.gui.panel(1, 1, s.app.width, s.app.height, 0x2D2D2D))
  
  s.text = {}
  s.text.rs = s.app:addChild(s.gui.text(88, 24, 0xFFFFFF, "Selected Storage:"))
  s.text.desc = s.app:addChild(s.gui.text(88, 25, 0xFFFFFF, "")) --Description:
  s.text.desc2 = s.app:addChild(s.gui.text(88, 26, 0xFFFFFF, ""))
  s.text.m = s.app:addChild(s.gui.text(121, 30, 0xFFFFFF, "Selected Monitor"))
  s.text.m2 = s.app:addChild(s.gui.text(121, 31, 0xFFFFFF, ""))
  s.text.act = s.app:addChild(s.gui.text(88, 37, 0xFFFFFF, "Action:"))
  s.text.act2 = s.app:addChild(s.gui.text(88, 38, 0xFFFFFF, "No action possible"))
  s.text.status = s.app:addChild(s.gui.text(88, 46, 0xFFFFFF, "Status: "))
  s.text.times = s.app:addChild(s.gui.text(90, 48, 0xFFFFFF, tostring(s.timercount)))
  s.text.add = s.app:addChild(s.gui.text(88, 5, 0xFFFFFF, "Add Monitors:"))
  s.text.dis = s.app:addChild(s.gui.text(88, 14, 0xFFFFFF, "Distributor UID:"))
  
  s.buttons = {}
  s.buttons.restore = s.app:addChild(s.gui.roundedButton(147, 13, 13, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Restore"))
  s.buttons.restore.onTouch = function()
    s.status = "turnON"
    s.inputs.dis = s.rs.distributor
    s.check()
  end
  s.buttons.off = s.app:addChild(s.gui.roundedButton(88, 28, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Turn off monitor"))
  s.buttons.off.onTouch = function()
    s.status = "turnOFF"
    s.check()
  end
  s.buttons.removeplus = s.app:addChild(s.gui.roundedButton(88, 32, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Remove Monitor"))
  s.buttons.removeplus.onTouch = function()
    s.status = "remove"
    s.check()
  end
  s.buttons.confirm = s.app:addChild(s.gui.roundedButton(88, 40, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Confirm"))
  s.buttons.confirm.onTouch = function()
    if s.status == "add" then
      s.addRSMonitors(tonumber(s.inputs.add.text))
      if s.itemselect.reg then
        s.registerNetworkCards()
      end
    elseif s.status == "remove" then
      s.removeRSMonitor(s.inputs.remove.text)
    elseif s.status == "dis" then
      s.setDistributor(s.inputs.dis.text)
    elseif s.status == "turnON" then
      s.RSMonitorON(s.text.rs.text:sub(19), s.text.m2.text:sub(12,12))
    elseif s.status == "turnOFF" then
      s.RSMonitorOFF(s.text.m2.text:sub(12,12))
    end
  end
  s.buttons.check = s.app:addChild(s.gui.roundedButton(95, 47, 25, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Check Connection"))
  s.buttons.check.onTouch = function()
    s.checkConnection(true)
  end
  s.buttons.exit = s.app:addChild(s.gui.roundedButton(124, 47, 25, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Exit"))
  s.buttons.exit.onTouch = function()
    s.app:draw(false)
    s.app:stop()
    s.mf.os.execute("clear")
    s.mf.os.execute("clear")
  end
  s.buttons.addplus = s.app:addChild(s.gui.roundedButton(111, 4, 3, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "^"))
  s.buttons.addplus.onTouch = function()
    local temp = tonumber(s.inputs.add.text)
    if temp == nil or ((27 - #s.rs.monitor) == temp) then
      s.inputs.add.text = "1"
    else
      s.inputs.add.text = tostring(temp + 1)
    end
    s.status = "add"
    s.check()
  end
  s.buttons.addminus = s.app:addChild(s.gui.roundedButton(115, 4, 3, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "v"))
  s.buttons.addminus.onTouch = function()
    local temp = tonumber(s.inputs.add.text)
    if temp == nil then
      s.inputs.add.text = "1"
    elseif temp == 1 then
      s.inputs.add.text = "27"
    else
      s.inputs.add.text = tostring(temp - 1)
    end
    s.status = "add"
    s.check()
  end
  
  s.inputs = {}
  s.inputs.add = s.app:addChild(s.gui.input(105, 4, 5, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "1", ""))
  s.inputs.add.onInputFinished = function()
    s.status = "add"
    s.check()
  end
  s.inputs.addreg = s.app:addChild(s.gui.switchAndLabel(120, 5, 28, 6, 0x66DB80, 0x1D1D1D, 0xFFFFFF, "Register:", s.itemselect.reg))
  s.inputs.addreg.switch.onStateChanged = function(state)
      s.itemselect.reg = state
      s.status = "add"
      s.check()
    end
  s.inputs.dis = s.app:addChild(s.gui.input(105, 13, 40, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, s.rs.distributor, "Distributor UID"))
  s.inputs.dis.onInputFinished = function()
    s.status = "dis"
    s.check()
  end
  
  s.list = {}
  local bc = s.mf.getCount(s.rs.rstorages)
  local bb = math.floor(50 / bc)
  local by = math.floor(50 - (bb * bc)) + 1
  s.list.rs = s.app:addChild(s.gui.list(3, by, 40, (bb * bc), bb, 0, 0xE1E1E1, 0x4B4B4B, 0xD2D2D2, 0x4B4B4B, 0x3366CC, 0xFFFFFF, false))
  for i,j in pairs(s.mf.getSortedKeys(s.rs.rstorages)) do
    s.list.rs:addItem(j).onTouch = function()
      s.itemselect.r = s.list.rs.selectedItem
      s.text.rs.text = "Selected Storage: " .. tostring(s.list.rs:getItem(s.list.rs.selectedItem).text)
    end
  end
  s.list.rs.selectedItem = s.itemselect.r
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
  s.status = "turnON"
  s.check()
end
function s.check()
  if s.statusc == "check" then
    for a,b in pairs({"buttons", "inputs", "list", "text"}) do
      for c,d in pairs(s[b]) do
        s[b][c].disabled = true
      end
    end
    s.buttons.exit.disabled = false
    s.buttons.check.disabled = false
    s.text.act.disabled = false
    s.text.act2.disabled = false
    s.text.status.text = "Status: No connection to distributor. Please Check!"
    if s.status == dis and s.inputs.dis.text ~= s.rs.distributor then
      s.text.act2.text = "Change distributor UID. Please confirm!"
      s.buttons.confirm.disabled = false
    else
      s.text.act2.text = "No action available!"
    end
  else
    for a,b in pairs({"buttons", "inputs", "list", "text"}) do
      for c,d in pairs(s[b]) do
        s[b][c].disabled = false
      end
    end
    s.text.act2.text = "No action available!"
    s.text.status.text = "Status: Idle"
    
    if s.inputs.dis.text == s.rs.distributor then
      s.buttons.restore.disabled = true
    end
    if #s.text.m2.text == 12 then
      s.buttons.off.disabled = true
    end
    
    if s.status == "add" then
      local temp = tonumber(s.inputs.add.text)
      if temp == nil then
        s.text.act2.text = "Cant add monitors! Give in a number!"
        s.buttons.confirm.disabled = true
      else
        if s.itemselect.reg then
          s.text.act2.text = "Add " .. temp .. " monitors. Please transfer Network-Cards and press confirm!"
        else
          s.text.act2.text = "Add " .. temp .. " monitors. Please confirm! Please register Network-Cards at Dis."
        end
      end
    elseif s.status == "remove" then
      local temp = tonumber(s.inputs.add.text)
      if temp == nil then
        s.text.act2.text = "Cant remove monitor! Give in a number!"
        s.buttons.confirm.disabled = true
      elseif s.rs.monitor[temp] == nil then
        s.text.act2.text = "Cant remove monitor! Monitor does not exist!"
        s.buttons.confirm.disabled = true
      else
        s.text.act2.text = "Remove monitor " .. temp .. ". Please confirm!"
      end
    elseif s.status == "dis" then
      if s.inputs.dis.text == s.rs.distributor then
        s.buttons.confirm.disabled = true  
      else
        s.text.act2.text = "Change distributor UID. Please confirm!"
      end
    elseif s.status == "turnON" then
      if s.text.rs.text == "" or s.text.rs.text:sub(19) == s.rs.monitor[s.text.m2.text:sub(12,12)] then
        s.buttons.confirm.disabled = true
      end
    elseif s.status == "turnOFF" then
      if s.text.rs.text == "" or s.text.rs.text:sub(19) == s.rs.monitor[s.text.m2.text:sub(12,12)] then
        s.buttons.confirm.disabled = true
      end
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
    s.statusc = ""
    s.timer = s.mf.event.timer(1, function()
      s.timercount = s.timercount - 1
      if s.text ~= nil then
        if s.text.times ~= nil then
          s.text.times.text = tostring(s.timercount)
        end
      end
      if s.timercount == 0 then
        s.statusc = "check"
        s.timercount = 30
        s.check()
      end
    end, 30)
  else
    s.statusc = "check"
  end
    s.Draw_GUI()
end
s.start()
return s