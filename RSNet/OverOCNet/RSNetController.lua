local cn = {}
cn.mf = require("MainFunctions")
cn.gui = require("GUI")
cn.saving = false
cn.rs = {}
cn.ocnet = cn.mf.component.tunnel
cn.status = ""
cn.statusc = ""
cn.timercount = 30
cn.itemselect = {r=1, m=1, reg=true}
cn.app = cn.gui.application()
local varpath = "/home/RSNetStationVars.lua"

function cn.Draw_GUI() 
  cn.app:removeChildren()
  cn.app:addChild(cn.gui.panel(1, 1, cn.app.width, cn.app.height, 0x2D2D2D))
  
  cn.text = {}
  cn.text.rs = cn.app:addChild(cn.gui.text(88, 24, 0xFFFFFF, "Selected Storage: "))
  cn.text.desc = cn.app:addChild(cn.gui.text(88, 25, 0xFFFFFF, "")) --Description:
  cn.text.desc2 = cn.app:addChild(cn.gui.textBox(88, 26, 72, 3, 0x000000, 0xFFFFFF, {}, 1, 1, 0, true))
  cn.text.m = cn.app:addChild(cn.gui.text(121, 30, 0xFFFFFF, "Selected Monitor"))
  cn.text.m2 = cn.app:addChild(cn.gui.text(121, 31, 0xFFFFFF, ""))
  cn.text.act = cn.app:addChild(cn.gui.text(88, 37, 0xFFFFFF, "Action:"))
  cn.text.act2 = cn.app:addChild(cn.gui.text(88, 38, 0xFFFFFF, "No action possible"))
  cn.text.status = cn.app:addChild(cn.gui.text(88, 46, 0xFFFFFF, "Status: "))
  cn.text.times = cn.app:addChild(cn.gui.text(90, 48, 0xFFFFFF, tostring(cn.timercount)))
  cn.text.add = cn.app:addChild(cn.gui.text(88, 5, 0xFFFFFF, "Add Monitors:"))
  cn.text.dis = cn.app:addChild(cn.gui.text(88, 14, 0xFFFFFF, "Distributor UID:"))
  
  cn.buttons = {}
  cn.buttons.restore = cn.app:addChild(cn.gui.roundedButton(147, 13, 13, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Restore"))
  cn.buttons.restore.onTouch = function()
    cn.status = "turnON"
    cn.inputs.dis = cn.rs.distributor
    cn.check()
  end
  cn.buttons.off = cn.app:addChild(cn.gui.roundedButton(88, 28, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Turn off monitor"))
  cn.buttons.off.onTouch = function()
    cn.status = "turnOFF"
    cn.check()
  end
  cn.buttons.removeplus = cn.app:addChild(cn.gui.roundedButton(88, 32, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Remove Monitor"))
  cn.buttons.removeplus.onTouch = function()
    cn.status = "remove"
    cn.check()
  end
  cn.buttons.confirm = cn.app:addChild(cn.gui.roundedButton(88, 40, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Confirm"))
  cn.buttons.confirm.onTouch = function()
    if cn.status == "add" then
      if cn.itemselect.reg then
        cn.text.status.text = "Status: Registering Network-Cards and adding monitors"
        cn.text.act2.text = "No action possible"
        cn.buttons.confirm.disabled = true
        cn.registerNetworkCards()
        cn.checkConnection()
      else
        cn.text.status.text = "Status: Adding monitors"
        cn.addRSMonitors(tonumber(cn.inputs.add.text))
      end
    elseif cn.status == "remove" then
      if #cn.text.m2.text > 12  then
        cn.text.status.text = "Status: Turning ON Monitor " .. cn.text.m2.text:sub(12,12) .. " with " .. cn.text.rs.text:sub(19) .."."
        cn.text.act2.text = "No action possible"
        cn.buttons.confirm.disabled = true
        cn.RSMonitorOFF(tonumber(cn.text.m2.text:sub(12,12)))
      end
      cn.text.status.text = "Status: Removing Monitor " .. cn.text.m2.text:sub(12,12) .. "."
      cn.text.act2.text = "No action possible"
      cn.buttons.confirm.disabled = true
      cn.removeRSMonitor(tonumber(cn.inputs.remove.text))
    elseif cn.status == "dis" then
      cn.setDistributor(cn.inputs.dis.text)
      cn.checkConnection()
    elseif cn.status == "turnON" then
      cn.text.status.text = "Status: Turning ON Monitor " .. cn.text.m2.text:sub(12,12) .. " with " .. cn.text.rs.text:sub(19) .."."
      cn.text.act2.text = "No action possible"
      cn.buttons.confirm.disabled = true
      cn.RSMonitorON(cn.text.rs.text:sub(19), tonumber(cn.text.m2.text:sub(12,12)))
    elseif cn.status == "turnOFF" then
      cn.text.status.text = "Status: Turning ON Monitor " .. cn.text.m2.text:sub(12,12) .. " with " .. cn.text.rs.text:sub(19) .."."
      cn.text.act2.text = "No action possible"
      cn.buttons.confirm.disabled = true
      cn.RSMonitorOFF(tonumber(cn.text.m2.text:sub(12,12)))
    end
  end
  cn.buttons.check = cn.app:addChild(cn.gui.roundedButton(95, 47, 25, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Check Connection"))
  cn.buttons.check.onTouch = function()
    cn.text.status.text = "Status: Checking Connection"
    cn.checkConnection(true)
  end
  cn.buttons.exit = cn.app:addChild(cn.gui.roundedButton(124, 47, 25, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Exit"))
  cn.buttons.exit.onTouch = function()
    cn.app:draw(false)
    cn.app:stop()
    cn.mf.os.execute("clear")
    cn.mf.os.execute("clear")
  end
  cn.buttons.addplus = cn.app:addChild(cn.gui.roundedButton(111, 4, 3, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "^"))
  cn.buttons.addplus.onTouch = function()
    local temp = tonumber(cn.inputs.add.text)
    if temp == nil or ((27 - #cn.rs.monitor) == temp) then
      cn.inputs.add.text = "1"
    else
      cn.inputs.add.text = tostring(temp + 1)
    end
    cn.status = "add"
    cn.check()
  end
  cn.buttons.addminus = cn.app:addChild(cn.gui.roundedButton(115, 4, 3, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "v"))
  cn.buttons.addminus.onTouch = function()
    local temp = tonumber(cn.inputs.add.text)
    if temp == nil then
      cn.inputs.add.text = "1"
    elseif temp == 1 then
      cn.inputs.add.text = "27"
    else
      cn.inputs.add.text = tostring(temp - 1)
    end
    cn.status = "add"
    cn.check()
  end
  
  cn.inputs = {}
  cn.inputs.add = cn.app:addChild(cn.gui.input(105, 4, 5, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "1", ""))
  cn.inputs.add.onInputFinished = function()
    cn.status = "add"
    cn.check()
  end
  cn.inputs.addreg = cn.app:addChild(cn.gui.switchAndLabel(120, 5, 18, 6, 0x66DB80, 0x1D1D1D, 0xFFFFFF, 0xFFFFFF, "Register:", cn.itemselect.reg))
  cn.inputs.addreg.switch.onStateChanged = function(state)
      cn.itemselect.reg = cn.inputs.addreg.switch.state
      cn.status = "add"
      cn.check()
    end
  cn.inputs.dis = cn.app:addChild(cn.gui.input(105, 13, 40, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, cn.rs.distributor, "Distributor UID"))
  cn.inputs.dis.onInputFinished = function()
    cn.status = "dis"
    cn.check()
  end
  
  cn.list = {}
  local as = cn.mf.getAutoSizeForGuiList(cn.rs.rstorages_order)
  cn.list.rs = cn.app:addChild(cn.gui.list(3, as.y, 40, as.height, as.itemheight, 0, 0xE1E1E1, 0x4B4B4B, 0xD2D2D2, 0x4B4B4B, 0x3366CC, 0xFFFFFF, false))
  for i,j in pairs(cn.mf.getSortedKeys(cn.rs.rstorages)) do
    cn.list.rs:addItem(j).onTouch = function()
      cn.itemselect.r = cn.list.rs.selectedItem
      cn.text.rs.text = "Selected Storage: " .. tostring(cn.list.rs:getItem(cn.list.rs.selectedItem).text)
      cn.text.desc.text = "Description:"
      cn.text.desc.lines = cn.mf.split(cn.rs.rstorages[cn.text.rs.text:sub(19)].desc, "\n")
      cn.status = "turnON"
      cn.check()
    end
  end
  cn.list.rs.selectedItem = cn.itemselect.r
  cn.text.rs.text = "Selected Storage: " .. tostring(cn.list.rs:getItem(cn.list.rs.selectedItem).text)
  cn.text.desc.text = cn.mf.split(cn.rs.rstorages[cn.text.rs.text:sub(19)].desc, "\n")
  
  as = cn.mf.getAutoSizeForGuiList(cn.rs.monitor)
  cn.list.m = cn.app:addChild(cn.gui.list(45, as.y, 40, as.height, as.itemheight, 0, 0xE1E1E1, 0x4B4B4B, 0xD2D2D2, 0x4B4B4B, 0x3366CC, 0xFFFFFF, false))
  for i,j in pairs(cn.rs.monitor) do
    local txt= "RS Monitor " .. i
    if j ~= "" then
      txt = txt .. " (" .. j .. ")"
    end
    cn.list.m:addItem(txt).onTouch = function()
      cn.itemselect.m = cn.list.m.selectedItem
      cn.text.m2.text = tostring(cn.list.m:getItem(cn.list.m.selectedItem).text)
      cn.status = "turnON"
      cn.check()
    end
  end
  cn.list.m.selectedItem = cn.itemselect.m
  cn.text.m2.text = tostring(cn.list.m:getItem(cn.list.m.selectedItem).text)
  cn.status = "turnON"
  cn.check()
end
function cn.check()
  if cn.statusc == "check" then
    for a,b in pairs({"buttons", "inputs", "list", "text"}) do
      for c,d in pairs(cn[b]) do
        cn[b][c].disabled = true
      end
    end
    cn.buttons.exit.disabled = false
    cn.buttons.check.disabled = false
    cn.inputs.dis.disabled = false
    cn.text.act.disabled = false
    cn.text.act2.disabled = false
    cn.text.status.text = "Status: No connection to distributor. Please Check!"
    if cn.inputs.dis.text ~= cn.rs.distributor then
      cn.buttons.restore.disabled = false
    end
    if cn.status == dis and cn.inputs.dis.text ~= cn.rs.distributor then
      cn.text.act2.text = "Change distributor UID. Please confirm!"
      cn.buttons.confirm.disabled = false
    else
      cn.text.act2.text = "No action possible"
    end
  else
    for a,b in pairs({"buttons", "inputs", "list", "text"}) do
      for c,d in pairs(cn[b]) do
        cn[b][c].disabled = false
      end
    end
    cn.text.act2.text = "No action available!"
    cn.text.status.text = "Status: Idle"
    
    if cn.inputs.dis.text == cn.rs.distributor then
      cn.buttons.restore.disabled = true
    end
    if #cn.text.m2.text == 12 then
      cn.buttons.off.disabled = true
    end
    
    if cn.status == "add" then
      local temp = tonumber(cn.inputs.add.text)
      if temp == nil then
        cn.text.act2.text = "Cant add monitors! Give in a number!"
        cn.buttons.confirm.disabled = true
      else
        if cn.itemselect.reg then
          cn.text.act2.text = "Add " .. temp .. " monitors. Please transfer Network-Cards and press confirm!"
        else
          cn.text.act2.text = "Add " .. temp .. " monitors. Please confirm! Please register Network-Cards at Dis."
        end
      end
    elseif cn.status == "remove" then
      local temp = tonumber(cn.text.m2.text:sub(12,12))
      if cn.rs.monitor[temp] == nil then
        cn.text.act2.text = "Cant remove monitor!"
        cn.buttons.confirm.disabled = true
      else
        cn.text.act2.text = "Remove monitor " .. temp .. ". Please confirm!"
      end
    elseif cn.status == "dis" then
      if cn.inputs.dis.text == cn.rs.distributor then
        cn.buttons.confirm.disabled = true  
      else
        cn.text.act2.text = "Change distributor UID. Please confirm!"
      end
    elseif cn.status == "turnON" then
      if cn.text.rs.text == "Selected Storage: " or cn.text.rs.text:sub(19) == cn.rs.monitor[tonumber(cn.text.m2.text:sub(12,12))] then
        cn.buttons.confirm.disabled = true
      else
        cn.text.act2.text = "Turn ON Monitor " .. cn.text.m2.text:sub(12,12) .. " with " .. cn.text.rs.text:sub(19) ..". Please confirm!"
      end
    elseif cn.status == "turnOFF" then
      if cn.text.rs.text == "" or cn.text.rs.text:sub(19) == cn.rs.monitor[cn.text.m2.text:sub(12,12)] then
        cn.buttons.confirm.disabled = true
      else
        cn.text.act2.text = "Turn OFF Monitor " .. cn.text.m2.text:sub(12,12) ..". Please confirm!"
      end
    else
      cn.buttons.confirm.disabled = true
    end
  end
end

function cn.save()
  if cn.saving then
    local rstorages = cn.mf.copyTable(cn.rs.rstorages)
    cn.rs.rstorages = nil
    cn.mf.WriteObjectFile(cn.rs, varpath)
    cn.rs.rstorages = cn.mf.copyTable(rstorages)
  end
end
function cn.addRSMonitors(count)
  for i = 1, count, 1 do
    table.insert(cn.rs.monitor,"")
  end
  cn.save()
end
function cn.removeRSMonitor(monitor)
  cn.ocnet.send(cn.mf.serial.serialize({"RSNet", method="push", storage=mod, rsmonitor=monitor, removing=true},true))
  cn.checkConnection(false)
end
function cn.setDistributor(dis)
  cn.rs.distributor = dis
  cn.save()
end

function cn.start()
  if cn.mf.filesystem.exists(varpath) == false then
    cn.mf.WriteObjectFile({distributor="", monitor={}}, varpath)
  end
  cn.rs = require("RSNetStationVars")
  if cn.rs.distributor == "" then
    print("Please type in the uid of the distributors modem")
    cn.setDistributor(cn.mf.io.read())
  end
  if #cn.rs.monitor == 0 then
    print("How many monitors do you have")
    cn.addRSMonitors(cn.mf.io.read())
  end
  cn.m.close(478)
  cn.m.open(478)
  cn.saving = true
  cn.checkConnection(true)
  cn.app:draw(true)
  cn.app:start()
end

function cn.RSMonitorON(mod, monitor)
  if cn.rs.monitor[monitor] ~= nil and cn.rs.monitor[monitor] ~= mod then
    if cn.rs.monitor[monitor] ~= mod then
        cn.ocnet.send(cn.mf.serial.serialize({"RSNet", method="push", storage=mod, rsmonitor=monitor},true))
        cn.checkConnection(false)
    else
      cn.text.status.text = "Monitor already showing Refined Storage: " .. mod
    end
  else
    cn.text.status.text = "Monitor not found. Try the method addRSMonitors(count)."
  end
end
function cn.RSMonitorOFF(monitor)
  if cn.rs.monitor[monitor] ~= nil then
    if cn.rs.monitor[monitor] ~= "" then
        cn.ocnet.send(cn.mf.serial.serialize({"RSNet", method="pull", storage=cn.rs.monitor[monitor], rsmonitor=monitor},true))
        cn.checkConnection(false)
    else
      cn.text.status.text = "Monitor already OFF"
    end
  else
    cn.text.status.text = "Monitor not found. Try the method addRSMonitors(count)."
  end
end
function cn.registerNetworkCards()
  cn.ocnet.send(cn.mf.serial.serialize({"RSNet", "register"},true))
  cn.checkConnection(false)
end
function cn.checkConnection(askfor)
  if cn.timer ~= nil then
    cn.mf.event.cancel(cn.timer)
  end
  if askfor == nil or askfor == true then
    cn.ocnet.send(cn.mf.serial.serialize({"RSNet", "check"},true))
  end
  local _, localAddress, remoteAddress, port, distance, data = cn.mf.event.pull(10, "modem_message")
  if data ~= nil then
    data = cn.mf.serial.unserialize(data)
    cn.rs.rstorages = cn.mf.copyTable(data.rstorages)
    if data.monitor ~= nil then
      cn.rs.monitor = cn.mf.combineTables(cn.rs.monitor, data.monitor)
    end
    cn.save()
    cn.statusc = ""
    cn.timercount = 30
    cn.timer = cn.mf.event.timer(1, function()
      cn.timercount = cn.timercount - 1
      if cn.text ~= nil then
        if cn.text.times ~= nil then
          cn.text.times.text = tostring(cn.timercount)
        end
      end
      if cn.timercount == 0 then
        cn.statusc = "check"
        cn.check()
      end
    end, 30)
  else
    cn.statusc = "check"
  end
  cn.Draw_GUI()
  cn.text.status.text = "Status: Idle"
end
cn.start()
return cn