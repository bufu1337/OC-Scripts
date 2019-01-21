local RSC = {}
RSC.mf = require("MainFunctions")
RSC.gui = require("GUI")
RSC.saving = false
RSC.rs = {}
RSC.status = ""
RSC.statusc = ""
RSC.timercount = 30
RSC.itemselect = {r=1, m=1, reg=true}
RSC.app = RSC.gui.application()
RSC.mf.system = "RSNet"
local varpath = "/home/RSNetStationVars.lua"

function RSC.Draw_GUI() 
  RSC.app:removeChildren()
  RSC.app:addChild(RSC.gui.panel(1, 1, RSC.app.width, RSC.app.height, 0x2D2D2D))
  
  RSC.text = {}
  RSC.text.rs = RSC.app:addChild(RSC.gui.text(88, 24, 0xFFFFFF, "Selected Storage: "))
  RSC.text.desc = RSC.app:addChild(RSC.gui.text(88, 25, 0xFFFFFF, ""))
  RSC.text.desc2 = RSC.app:addChild(RSC.gui.textBox(88, 26, 72, 3, 0x000000, 0xFFFFFF, {}, 1, 1, 0, true))
  RSC.text.m = RSC.app:addChild(RSC.gui.text(121, 30, 0xFFFFFF, "Selected Monitor"))
  RSC.text.m2 = RSC.app:addChild(RSC.gui.text(121, 31, 0xFFFFFF, ""))
  RSC.text.act = RSC.app:addChild(RSC.gui.text(88, 37, 0xFFFFFF, "Action:"))
  RSC.text.act2 = RSC.app:addChild(RSC.gui.text(88, 38, 0xFFFFFF, "No action possible"))
  RSC.text.status = RSC.app:addChild(RSC.gui.text(88, 46, 0xFFFFFF, "Status: "))
  RSC.text.times = RSC.app:addChild(RSC.gui.text(90, 48, 0xFFFFFF, tostring(RSC.timercount)))
  RSC.text.add = RSC.app:addChild(RSC.gui.text(88, 5, 0xFFFFFF, "Add Monitors:"))
  RSC.text.dis = RSC.app:addChild(RSC.gui.text(88, 14, 0xFFFFFF, "Distributor UID:"))
  
  RSC.buttons = {}
  RSC.buttons.restore = RSC.app:addChild(RSC.gui.roundedButton(147, 13, 13, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Restore"))
  RSC.buttons.restore.onTouch = function()
    RSC.status = "turnON"
    RSC.inputs.dis = RSC.rs.distributor
    RSC.check()
  end
  RSC.buttons.off = RSC.app:addChild(RSC.gui.roundedButton(88, 28, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Turn off monitor"))
  RSC.buttons.off.onTouch = function()
    RSC.status = "turnOFF"
    RSC.check()
  end
  RSC.buttons.removeplus = RSC.app:addChild(RSC.gui.roundedButton(88, 32, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Remove Monitor"))
  RSC.buttons.removeplus.onTouch = function()
    RSC.status = "remove"
    RSC.check()
  end
  RSC.buttons.confirm = RSC.app:addChild(RSC.gui.roundedButton(88, 40, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Confirm"))
  RSC.buttons.confirm.onTouch = function()
    if RSC.status == "add" then
      if RSC.itemselect.reg then
        RSC.text.status.text = "Status: Registering Network-Cards and adding monitors"
        RSC.text.act2.text = "No action possible"
        RSC.buttons.confirm.disabled = true
        RSC.registerNetworkCards()
        RSC.checkConnection()
      else
        RSC.text.status.text = "Status: Adding monitors"
        RSC.addRSMonitors(tonumber(RSC.inputs.add.text))
      end
    elseif RSC.status == "remove" then
      if #RSC.text.m2.text > 12  then
        RSC.text.status.text = "Status: Turning ON Monitor " .. RSC.text.m2.text:sub(12,12) .. " with " .. RSC.text.rs.text:sub(19) .."."
        RSC.text.act2.text = "No action possible"
        RSC.buttons.confirm.disabled = true
        RSC.RSMonitorOFF(tonumber(RSC.text.m2.text:sub(12,12)))
      end
      RSC.text.status.text = "Status: Removing Monitor " .. RSC.text.m2.text:sub(12,12) .. "."
      RSC.text.act2.text = "No action possible"
      RSC.buttons.confirm.disabled = true
      RSC.removeRSMonitor(tonumber(RSC.inputs.remove.text))
    elseif RSC.status == "dis" then
      RSC.setDistributor(RSC.inputs.dis.text)
      RSC.checkConnection()
    elseif RSC.status == "turnON" then
      RSC.text.status.text = "Status: Turning ON Monitor " .. RSC.text.m2.text:sub(12,12) .. " with " .. RSC.text.rs.text:sub(19) .."."
      RSC.text.act2.text = "No action possible"
      RSC.buttons.confirm.disabled = true
      RSC.RSMonitorON(RSC.text.rs.text:sub(19), tonumber(RSC.text.m2.text:sub(12,12)))
    elseif RSC.status == "turnOFF" then
      RSC.text.status.text = "Status: Turning ON Monitor " .. RSC.text.m2.text:sub(12,12) .. " with " .. RSC.text.rs.text:sub(19) .."."
      RSC.text.act2.text = "No action possible"
      RSC.buttons.confirm.disabled = true
      RSC.RSMonitorOFF(tonumber(RSC.text.m2.text:sub(12,12)))
    end
  end
  RSC.buttons.check = RSC.app:addChild(RSC.gui.roundedButton(95, 47, 25, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Check Connection"))
  RSC.buttons.check.onTouch = function()
    RSC.text.status.text = "Status: Checking Connection"
    RSC.checkConnection(true)
  end
  RSC.buttons.exit = RSC.app:addChild(RSC.gui.roundedButton(124, 47, 25, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Exit"))
  RSC.buttons.exit.onTouch = function()
    RSC.app:draw(false)
    RSC.app:stop()
    RSC.mf.os.execute("clear")
    RSC.mf.os.execute("clear")
  end
  RSC.buttons.addplus = RSC.app:addChild(RSC.gui.roundedButton(111, 4, 3, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "^"))
  RSC.buttons.addplus.onTouch = function()
    local temp = tonumber(RSC.inputs.add.text)
    if temp == nil or ((27 - #RSC.rs.monitor) == temp) then
      RSC.inputs.add.text = "1"
    else
      RSC.inputs.add.text = tostring(temp + 1)
    end
    RSC.status = "add"
    RSC.check()
  end
  RSC.buttons.addminus = RSC.app:addChild(RSC.gui.roundedButton(115, 4, 3, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "v"))
  RSC.buttons.addminus.onTouch = function()
    local temp = tonumber(RSC.inputs.add.text)
    if temp == nil then
      RSC.inputs.add.text = "1"
    elseif temp == 1 then
      RSC.inputs.add.text = "27"
    else
      RSC.inputs.add.text = tostring(temp - 1)
    end
    RSC.status = "add"
    RSC.check()
  end
  
  RSC.inputs = {}
  RSC.inputs.add = RSC.app:addChild(RSC.gui.input(105, 4, 5, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "1", ""))
  RSC.inputs.add.onInputFinished = function()
    RSC.status = "add"
    RSC.check()
  end
  RSC.inputs.addreg = RSC.app:addChild(RSC.gui.switchAndLabel(120, 5, 18, 6, 0x66DB80, 0x1D1D1D, 0xFFFFFF, 0xFFFFFF, "Register:", RSC.itemselect.reg))
  RSC.inputs.addreg.switch.onStateChanged = function(state)
      RSC.itemselect.reg = RSC.inputs.addreg.switch.state
      RSC.status = "add"
      RSC.check()
    end
  RSC.inputs.dis = RSC.app:addChild(RSC.gui.input(105, 13, 40, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, RSC.rs.distributor, "Distributor UID"))
  RSC.inputs.dis.onInputFinished = function()
    RSC.status = "dis"
    RSC.check()
  end
  
  RSC.list = {}
  local as = RSC.mf.getAutoSizeForGuiList(RSC.rs.rstorages_order)
  RSC.list.rs = RSC.app:addChild(RSC.gui.list(3, as.y, 40, as.height, as.itemheight, 0, 0xE1E1E1, 0x4B4B4B, 0xD2D2D2, 0x4B4B4B, 0x3366CC, 0xFFFFFF, false))
  for i,j in pairs(RSC.mf.getSortedKeys(RSC.rs.rstorages)) do
    RSC.list.rs:addItem(j).onTouch = function()
      RSC.itemselect.r = RSC.list.rs.selectedItem
      RSC.text.rs.text = "Selected Storage: " .. tostring(RSC.list.rs:getItem(RSC.list.rs.selectedItem).text)
      RSC.text.desc.text = "Description:"
      RSC.text.desc.lines = RSC.mf.split(RSC.rs.rstorages[RSC.text.rs.text:sub(19)].desc, "\n")
      RSC.status = "turnON"
      RSC.check()
    end
  end
  RSC.list.rs.selectedItem = RSC.itemselect.r
  RSC.text.rs.text = "Selected Storage: " .. tostring(RSC.list.rs:getItem(RSC.list.rs.selectedItem).text)
  RSC.text.desc.text = RSC.mf.split(RSC.rs.rstorages[RSC.text.rs.text:sub(19)].desc, "\n")
  
  as = RSC.mf.getAutoSizeForGuiList(RSC.rs.monitor)
  RSC.list.m = RSC.app:addChild(RSC.gui.list(45, as.y, 40, as.height, as.itemheight, 0, 0xE1E1E1, 0x4B4B4B, 0xD2D2D2, 0x4B4B4B, 0x3366CC, 0xFFFFFF, false))
  for i,j in pairs(RSC.rs.monitor) do
    local txt= "RS Monitor " .. i
    if j ~= "" then
      txt = txt .. " (" .. j .. ")"
    end
    RSC.list.m:addItem(txt).onTouch = function()
      RSC.itemselect.m = RSC.list.m.selectedItem
      RSC.text.m2.text = tostring(RSC.list.m:getItem(RSC.list.m.selectedItem).text)
      RSC.status = "turnON"
      RSC.check()
    end
  end
  RSC.list.m.selectedItem = RSC.itemselect.m
  RSC.text.m2.text = tostring(RSC.list.m:getItem(RSC.list.m.selectedItem).text)
  RSC.status = "turnON"
  RSC.check()
end
function RSC.check()
  if RSC.statusc == "check" then
    for a,b in pairs({"buttons", "inputs", "list", "text"}) do
      for c,d in pairs(RSC[b]) do
        RSC[b][c].disabled = true
      end
    end
    RSC.buttons.exit.disabled = false
    RSC.buttons.check.disabled = false
    RSC.inputs.dis.disabled = false
    RSC.text.act.disabled = false
    RSC.text.act2.disabled = false
    RSC.text.status.text = "Status: No connection to distributor. Please Check!"
    if RSC.inputs.dis.text ~= RSC.rs.distributor then
      RSC.buttons.restore.disabled = false
    end
    if RSC.status == dis and RSC.inputs.dis.text ~= RSC.rs.distributor then
      RSC.text.act2.text = "Change distributor UID. Please confirm!"
      RSC.buttons.confirm.disabled = false
    else
      RSC.text.act2.text = "No action possible"
    end
  else
    for a,b in pairs({"buttons", "inputs", "list", "text"}) do
      for c,d in pairs(RSC[b]) do
        RSC[b][c].disabled = false
      end
    end
    RSC.text.act2.text = "No action available!"
    RSC.text.status.text = "Status: Idle"
    
    if RSC.inputs.dis.text == RSC.rs.distributor then
      RSC.buttons.restore.disabled = true
    end
    if #RSC.text.m2.text == 12 then
      RSC.buttons.off.disabled = true
    end
    
    if RSC.status == "add" then
      local temp = tonumber(RSC.inputs.add.text)
      if temp == nil then
        RSC.text.act2.text = "Cant add monitors! Give in a number!"
        RSC.buttons.confirm.disabled = true
      else
        if RSC.itemselect.reg then
          RSC.text.act2.text = "Add " .. temp .. " monitors. Please transfer Network-Cards and press confirm!"
        else
          RSC.text.act2.text = "Add " .. temp .. " monitors. Please confirm! Please register Network-Cards at Dis."
        end
      end
    elseif RSC.status == "remove" then
      local temp = tonumber(RSC.text.m2.text:sub(12,12))
      if RSC.rs.monitor[temp] == nil then
        RSC.text.act2.text = "Cant remove monitor!"
        RSC.buttons.confirm.disabled = true
      else
        RSC.text.act2.text = "Remove monitor " .. temp .. ". Please confirm!"
      end
    elseif RSC.status == "dis" then
      if RSC.inputs.dis.text == RSC.rs.distributor then
        RSC.buttons.confirm.disabled = true  
      else
        RSC.text.act2.text = "Change distributor UID. Please confirm!"
      end
    elseif RSC.status == "turnON" then
      if RSC.text.rs.text == "Selected Storage: " or RSC.text.rs.text:sub(19) == RSC.rs.monitor[tonumber(RSC.text.m2.text:sub(12,12))] then
        RSC.buttons.confirm.disabled = true
      else
        RSC.text.act2.text = "Turn ON Monitor " .. RSC.text.m2.text:sub(12,12) .. " with " .. RSC.text.rs.text:sub(19) ..". Please confirm!"
      end
    elseif RSC.status == "turnOFF" then
      if RSC.text.rs.text == "" or RSC.text.rs.text:sub(19) == RSC.rs.monitor[RSC.text.m2.text:sub(12,12)] then
        RSC.buttons.confirm.disabled = true
      else
        RSC.text.act2.text = "Turn OFF Monitor " .. RSC.text.m2.text:sub(12,12) ..". Please confirm!"
      end
    else
      RSC.buttons.confirm.disabled = true
    end
  end
end

function RSC.save()
  if RSC.saving then
    local rstorages = RSC.mf.copyTable(RSC.rs.rstorages)
    RSC.rs.rstorages = nil
    RSC.mf.WriteObjectFile(RSC.rs, varpath)
    RSC.rs.rstorages = RSC.mf.copyTable(rstorages)
  end
end
function RSC.addRSMonitors(count)
  for i = 1, count, 1 do
    table.insert(RSC.rs.monitor,"")
  end
  RSC.save()
end
function RSC.removeRSMonitor(monitor)
  RSC.ocnet.send(RSC.mf.serial.serialize({"RSNet", method="push", storage=mod, rsmonitor=monitor, removing=true},true))
  RSC.checkConnection(false)
end
function RSC.setDistributor(dis)
  RSC.rs.distributor = dis
  RSC.save()
end

function RSC.start()
  if RSC.mf.filesystem.exists(varpath) == false then
    RSC.mf.WriteObjectFile({Distributors={}}, varpath)
  end
  RSC.rs = require("RSNetStationVars")
  local ocsuccess = RSC.mf.SetComputerName("Controller")
  if ocsuccess then
    local names = RSC.mf.GetNamesFromOCNet("Distributors")
    if names ~= nil then
      if names.Distributors ~= nil then
        for i,j in pairs(names.Distributors) do
          if RSC.rs.Distributors[j] == nil then
            RSC.rs.Distributors[j] = {rstorages={}, stations={}}
          end
        end
        for i,j in pairs(RSC.rs.Distributors) do
          if RSC.mf.contains(names.Distributors, i) == false then
            RSC.rs.Distributors[i] = nil
          end
        end
        RSC.saving = true
        RSC.save()
        local distri = RSC.mf.getSortedKeys(RSC.rs.Distributors)
        if #distri == 0 then
          print("No distributors found. Setup a RSNet Distributor first.")
        else
          RSC.checkConnection(distri[1], true)
          RSC.app:draw(true)
          RSC.app:start()
        end
      end
    end
  else
    print("Please use OCNet for this Controller.")
  end
end

function RSC.RSMonitorON(mod, monitor)
  if RSC.rs.monitor[monitor] ~= nil and RSC.rs.monitor[monitor] ~= mod then
    if RSC.rs.monitor[monitor] ~= mod then
        RSC.ocnet.send(RSC.mf.serial.serialize({"RSNet", method="push", storage=mod, rsmonitor=monitor},true))
        RSC.checkConnection(false)
    else
      RSC.text.status.text = "Monitor already showing Refined Storage: " .. mod
    end
  else
    RSC.text.status.text = "Monitor not found. Try the method addRSMonitors(count)."
  end
end
function RSC.RSMonitorOFF(monitor)
  if RSC.rs.monitor[monitor] ~= nil then
    if RSC.rs.monitor[monitor] ~= "" then
        RSC.ocnet.send(RSC.mf.serial.serialize({"RSNet", method="pull", storage=RSC.rs.monitor[monitor], rsmonitor=monitor},true))
        RSC.checkConnection(false)
    else
      RSC.text.status.text = "Monitor already OFF"
    end
  else
    RSC.text.status.text = "Monitor not found. Try the method addRSMonitors(count)."
  end
end
function RSC.registerNetworkCards()
  RSC.ocnet.send(RSC.mf.serial.serialize({"RSNet", "register"},true))
  RSC.checkConnection(false)
end
function RSC.registerStation()
  RSC.ocnet.send(RSC.mf.serial.serialize({"RSNet", "register"},true))
  RSC.checkConnection(false)
end
function RSC.checkConnection(distributor, askfor)
  if RSC.timer ~= nil then
    RSC.mf.event.cancel(RSC.timer)
  end
  if askfor == nil or askfor == true then
    RSC.mf.SendOverOCNet(distributor, {"check"})
  end
  local data = RSC.mf.ReceiveFromOCNet(10)
  if data ~= nil then
    RSC.rs.Distributors[distributor].rstorages = RSC.mf.copyTable(data.rstorages)
    if data.stations ~= nil then
      RSC.rs.Distributors[distributor].stations = RSC.mf.combineTables(RSC.rs.Distributors[distributor].stations, data.stations)
    end
    RSC.save()
    RSC.statusc = ""
    RSC.timercount = 30
    RSC.timer = RSC.mf.event.timer(1, function()
      RSC.timercount = RSC.timercount - 1
      if RSC.text ~= nil then
        if RSC.text.times ~= nil then
          RSC.text.times.text = tostring(RSC.timercount)
        end
      end
      if RSC.timercount == 0 then
        RSC.statusc = "check"
        RSC.check()
      end
    end, 30)
  else
    RSC.statusc = "check"
  end
  RSC.Draw_GUI()
  RSC.text.status.text = "Status: Idle"
end
RSC.start()
return RSC