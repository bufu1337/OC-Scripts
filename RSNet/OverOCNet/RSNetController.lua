local RSC = {}
RSC.mf = require("MainFunctions")
RSC.gui = require("GUI")
RSC.rs = {}
RSC.status = ""
RSC.statusc = ""
RSC.stationcount = 0
RSC.timercount = 30
RSC.itemselect = {dis=1, s=1, r=1, m=1}
RSC.app = RSC.gui.application()
RSC.mf.OCNet.system = "RSNet"
local varpath = "/home/RSNetStationVars.lua"

function RSC.Draw_GUI() 
  RSC.app:removeChildren()
  RSC.app:addChild(RSC.gui.panel(1, 1, RSC.app.width, RSC.app.height, 0x2D2D2D))
  
  RSC.text = {}
  RSC.combo = {}
  RSC.buttons = {}
  RSC.inputs = {}
  RSC.list = {}
    
  RSC.text.dis = RSC.app:addChild(RSC.gui.text(88, 3, 0xFFFFFF, "Distributor:"))
  RSC.combo.dis = RSC.app:addChild(RSC.gui.comboBox(88, 5, 25, 3, 0xEEEEEE, 0x2D2D2D, 0xCCCCCC, 0x888888))
  for i,j in pairs(RSC.mf.getSortedKeys(RSC.rs.Distributors)) do
    RSC.combo.dis:addItem(j).onTouch = function()
      if RSC.combo.dis.selectedItem ~= RSC.itemselect.dis then
        RSC.itemselect.dis = RSC.combo.dis.selectedItem
        RSC.itemselect.s = 1
        RSC.status = ""
        RSC.statusc = "check"
        RSC.check()
      end
    end
  end
  RSC.combo.dis.selectedItem = RSC.itemselect.dis
  
  RSC.text.station = RSC.app:addChild(RSC.gui.text(116, 3, 0xFFFFFF, "Station:"))
  RSC.combo.station = RSC.app:addChild(RSC.gui.comboBox(116, 5, 25, 3, 0xEEEEEE, 0x2D2D2D, 0xCCCCCC, 0x888888))
  if RSC.stationcount ~= 0 then
    for i,j in pairs(RSC.mf.getSortedKeys(RSC.rs.Distributors[RSC.combo.dis:getItem(RSC.itemselect.dis).text].stations)) do
      RSC.combo.dis:addItem(j).onTouch = function()
        RSC.itemselect.s = RSC.combo.station.selectedItem
        RSC.check()
      end
    end
    RSC.combo.station.selectedItem = RSC.itemselect.s
  end
  RSC.buttons.removeStation = RSC.app:addChild(RSC.gui.roundedButton(143, 5, 17, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Remove Station"))
  RSC.buttons.removeStation.onTouch = function()
    RSC.status = "removeStation"
    RSC.check()
  end
  
  RSC.text.newstation = RSC.app:addChild(RSC.gui.text(88, 19, 0xFFFFFF, "New Station:"))
  RSC.inputs.newstation = RSC.app:addChild(RSC.gui.input(105, 18, 20, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "", "New Station (Name) ..."))
  RSC.inputs.newstation.onInputFinished = function()
    RSC.status = "register"
    RSC.check()
  end
  RSC.buttons.clear = RSC.app:addChild(RSC.gui.roundedButton(125, 18, 13, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Clear"))
  RSC.buttons.clear.onTouch = function()
    RSC.status = "register"
    RSC.inputs.newstation = ""
    RSC.check()
  end
  RSC.buttons.addreg = RSC.app:addChild(RSC.gui.roundedButton(140, 18, 20, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Register Network-Cards"))
  RSC.buttons.addreg.onTouch = function()
    RSC.status = "register"
    RSC.check()
  end
  
  RSC.text.rs = RSC.app:addChild(RSC.gui.text(88, 24, 0xFFFFFF, "Selected Storage: "))
  RSC.text.desc = RSC.app:addChild(RSC.gui.text(88, 25, 0xFFFFFF, ""))
  RSC.text.desc2 = RSC.app:addChild(RSC.gui.textBox(88, 26, 72, 3, 0x000000, 0xFFFFFF, {}, 1, 1, 0, true))
  RSC.text.m = RSC.app:addChild(RSC.gui.text(121, 30, 0xFFFFFF, "Selected Monitor"))
  RSC.text.m2 = RSC.app:addChild(RSC.gui.text(121, 31, 0xFFFFFF, ""))
  RSC.text.act = RSC.app:addChild(RSC.gui.text(88, 37, 0xFFFFFF, "Action:"))
  RSC.text.act2 = RSC.app:addChild(RSC.gui.text(88, 38, 0xFFFFFF, "No action possible"))
  RSC.text.status = RSC.app:addChild(RSC.gui.text(88, 46, 0xFFFFFF, "Status: "))
  RSC.text.times = RSC.app:addChild(RSC.gui.text(90, 48, 0xFFFFFF, tostring(RSC.timercount)))
  
  
  RSC.buttons.off = RSC.app:addChild(RSC.gui.roundedButton(88, 28, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Turn off monitor"))
  RSC.buttons.off.onTouch = function()
    RSC.status = "turnOFF"
    RSC.check()
  end
  RSC.buttons.removeMonitor = RSC.app:addChild(RSC.gui.roundedButton(88, 32, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Remove Monitor"))
  RSC.buttons.removeMonitor.onTouch = function()
    RSC.status = "remove"
    RSC.check()
  end
  RSC.buttons.confirm = RSC.app:addChild(RSC.gui.roundedButton(88, 40, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Confirm"))
  RSC.buttons.confirm.onTouch = function()
    if RSC.mf.contains({"register", "remove", "removeStation", "turnON", "turnOFF"}, RSC.status) then
      RSC.text.act2.text = "No action possible"
      RSC.buttons.confirm.disabled = true
    end
    if RSC.status == "register" then
      local newstation = RSC.combo.station:getItem(RSC.itemselect.s).text
      if RSC.inputs.newstation.text ~= "" then
        newstation = RSC.inputs.newstation.text
      end
      RSC.text.status.text = "Status: Registering Network-Cards for station " .. newstation .. "."
      RSC.registerNetworkCards(RSC.combo.dis:getItem(RSC.itemselect.dis).text, newstation)
    elseif RSC.status == "remove" then
      if #RSC.text.m2.text > 12  then
        RSC.text.status.text = "Status: Turning OFF and Removing Monitor " .. RSC.text.m2.text:sub(12,12) .. "."        
      else
        RSC.text.status.text = "Status: Removing Monitor " .. RSC.text.m2.text:sub(12,12) .. "."
      end
      RSC.removeRSMonitor(RSC.combo.dis:getItem(RSC.itemselect.dis).text, RSC.combo.station:getItem(RSC.itemselect.s).text, tonumber(RSC.text.m2.text:sub(12,12)))
    elseif RSC.status == "removeStation" then
      RSC.text.status.text = "Status: Turning OFF all Monitors and Removing Station " .. RSC.text.m2.text:sub(12,12) .. " with " .. RSC.text.rs.text:sub(19) .."." 
      RSC.removeStation(RSC.combo.dis:getItem(RSC.itemselect.dis).text, RSC.combo.station:getItem(RSC.itemselect.s).text)
    elseif RSC.status == "turnON" then
      RSC.text.status.text = "Status: Turning ON Monitor " .. RSC.text.m2.text:sub(12,12) .. " with " .. RSC.text.rs.text:sub(19) .."."
      RSC.RSMonitorON(RSC.combo.dis:getItem(RSC.itemselect.dis).text, RSC.combo.station:getItem(RSC.itemselect.s).text, RSC.text.rs.text:sub(19), tonumber(RSC.text.m2.text:sub(12,12)))
    elseif RSC.status == "turnOFF" then
      RSC.text.status.text = "Status: Turning OFF Monitor " .. RSC.text.m2.text:sub(12,12) .. "."
      RSC.RSMonitorOFF(RSC.combo.dis:getItem(RSC.itemselect.dis).text, RSC.combo.station:getItem(RSC.itemselect.s).text, tonumber(RSC.text.m2.text:sub(12,12)))
    end
  end
  RSC.buttons.check = RSC.app:addChild(RSC.gui.roundedButton(95, 47, 25, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Check Connection"))
  RSC.buttons.check.onTouch = function()
    RSC.text.status.text = "Status: Checking Connection"
    RSC.checkConnection(RSC.combo.dis:getItem(RSC.itemselect.dis).text, true)
  end
  RSC.buttons.exit = RSC.app:addChild(RSC.gui.roundedButton(124, 47, 25, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Exit"))
  RSC.buttons.exit.onTouch = function()
    RSC.app:draw(false)
    RSC.app:stop()
    RSC.mf.os.execute("clear")
    RSC.mf.os.execute("clear")
  end  
  
  local as = RSC.mf.getAutoSizeForGuiList(RSC.mf.getSortedKeys(RSC.rs.Distributors[RSC.combo.dis:getItem(RSC.itemselect.dis).text].rstorages))
  RSC.list.rs = RSC.app:addChild(RSC.gui.list(3, as.y, 40, as.height, as.itemheight, 0, 0xE1E1E1, 0x4B4B4B, 0xD2D2D2, 0x4B4B4B, 0x3366CC, 0xFFFFFF, false))
  for i,j in pairs(RSC.mf.getSortedKeys(RSC.rs.Distributors[RSC.combo.dis:getItem(RSC.itemselect.dis).text].rstorages)) do
    RSC.list.rs:addItem(j).onTouch = function()
      RSC.itemselect.r = RSC.list.rs.selectedItem
      RSC.text.rs.text = "Selected Storage: " .. tostring(RSC.list.rs:getItem(RSC.list.rs.selectedItem).text)
      RSC.text.desc.text = "Description:"
      RSC.text.desc.lines = RSC.mf.split(RSC.rs.Distributors[RSC.combo.dis:getItem(RSC.itemselect.dis).text].rstorages[RSC.text.rs.text:sub(19)].desc, "\n")
      RSC.status = "turnON"
      RSC.check()
    end
  end
  RSC.list.rs.selectedItem = RSC.itemselect.r
  RSC.text.rs.text = "Selected Storage: " .. tostring(RSC.list.rs:getItem(RSC.list.rs.selectedItem).text)
  RSC.text.desc.text = RSC.mf.split(RSC.rs.Distributors[RSC.combo.dis:getItem(RSC.itemselect.dis).text].rstorages[RSC.text.rs.text:sub(19)].desc, "\n")
  
  if RSC.stationcount ~= 0 then
    as = RSC.mf.getAutoSizeForGuiList(RSC.rs.Distributors[RSC.combo.dis:getItem(RSC.itemselect.dis).text].stations[RSC.combo.station:getItem(RSC.itemselect.s).text].monitor)
    RSC.list.m = RSC.app:addChild(RSC.gui.list(45, as.y, 40, as.height, as.itemheight, 0, 0xE1E1E1, 0x4B4B4B, 0xD2D2D2, 0x4B4B4B, 0x3366CC, 0xFFFFFF, false))
    for i,j in pairs(RSC.rs.Distributors[RSC.combo.dis:getItem(RSC.itemselect.dis).text].stations[RSC.combo.station:getItem(RSC.itemselect.s).text].monitor) do
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
  else
    RSC.status = "register"
  end
  RSC.check()
end
function RSC.check()
  if RSC.statusc == "check" then
    for a,b in pairs({"buttons", "inputs", "list", "text", "combo"}) do
      for c,d in pairs(RSC[b]) do
        RSC[b][c].disabled = true
      end
    end
    RSC.buttons.exit.disabled = false
    RSC.buttons.check.disabled = false
    RSC.combo.dis.disabled = false
    RSC.text.act.disabled = false
    RSC.text.act2.disabled = false
    RSC.text.status.text = "Status: No connection to distributor. Please Check!"
    RSC.text.act2.text = "No action possible"
  elseif RSC.stationcount == 0 then
    for a,b in pairs({"buttons", "inputs", "list", "text", "combo"}) do
      for c,d in pairs(RSC[b]) do
        RSC[b][c].disabled = true
      end
    end
    RSC.buttons.exit.disabled = false
    RSC.buttons.check.disabled = false
    RSC.combo.dis.disabled = false
    RSC.text.act.disabled = false
    RSC.text.act2.disabled = false
    RSC.text.newstation.disabled = false
    RSC.inputs.newstation.disabled = false
    RSC.buttons.addreg.disabled = false
    RSC.text.status.text = "Status: No Station registered. Please register a station with Network-Cards!"
    RSC.text.act2.text = "No action possible"
    if RSC.status == "register" then
      if RSC.inputs.newstation.text ~= "" then
        RSC.buttons.clear.disabled = false
        RSC.buttons.confirm.disabled = false
        RSC.text.act2.text = "Register monitors to station " .. RSC.inputs.newstation.text .. ". Please confirm!"
      end
    end
  else
    for a,b in pairs({"buttons", "inputs", "list", "text", "combo"}) do
      for c,d in pairs(RSC[b]) do
        RSC[b][c].disabled = false
      end
    end
    RSC.text.act2.text = "No action available!"
    RSC.text.status.text = "Status: Idle"
    
    if RSC.inputs.newstation.text == "" then
      RSC.buttons.clear.disabled = true
    end
    if #RSC.text.m2.text == 12 then
      RSC.buttons.off.disabled = true
    end
    
    if RSC.status == "register" then
      local st = RSC.combo.station:getItem(RSC.itemselect.s).text
      if RSC.inputs.newstation.text ~= "" then
        st = RSC.inputs.newstation.text
      end
      RSC.text.act2.text = "Register monitors to station " .. st .. ". Please confirm!"
    elseif RSC.status == "remove" then
      local temp = tonumber(RSC.text.m2.text:sub(12,12))
      if RSC.rs.Distributors[RSC.combo.dis:getItem(RSC.itemselect.dis).text].stations[RSC.combo.station:getItem(RSC.itemselect.s).text].monitor[temp] == nil then
        RSC.text.act2.text = "Cant remove monitor!"
        RSC.buttons.confirm.disabled = true
      else
        RSC.text.act2.text = "Remove monitor " .. temp .. " from station " .. RSC.combo.station:getItem(RSC.itemselect.s).text .. ". Please confirm!"
      end
    elseif RSC.status == "removeStation" then
      if RSC.combo.station:getItem(RSC.itemselect.s).text == "" then
        RSC.buttons.confirm.disabled = true  
      else
        RSC.text.act2.text = "Remove station " .. RSC.combo.station:getItem(RSC.itemselect.s).text .. " and all its monitors... Please confirm!"
      end
    elseif RSC.status == "turnON" then
      if RSC.text.rs.text == "Selected Storage: " or RSC.text.rs.text:sub(19) == RSC.rs.Distributors[RSC.combo.dis:getItem(RSC.itemselect.dis).text].stations[RSC.combo.station:getItem(RSC.itemselect.s).text].monitor[tonumber(RSC.text.m2.text:sub(12,12))] then
        RSC.buttons.confirm.disabled = true
      else
        RSC.text.act2.text = "Turn ON Monitor " .. RSC.text.m2.text:sub(12,12) .. " with " .. RSC.text.rs.text:sub(19) ..". Please confirm!"
      end
    elseif RSC.status == "turnOFF" then
      if RSC.text.rs.text == "" or RSC.text.rs.text:sub(19) == RSC.rs.Distributors[RSC.combo.dis:getItem(RSC.itemselect.dis).text].stations[RSC.combo.station:getItem(RSC.itemselect.s).text].monitor[RSC.text.m2.text:sub(12,12)] then
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
  RSC.mf.WriteObjectFile(RSC.rs, varpath)
end

function RSC.start()
  if RSC.mf.filesystem.exists(varpath) == false then
    RSC.mf.WriteObjectFile({Distributors={}}, varpath)
  end
  RSC.rs = require("RSNetStationVars")
  local ocsuccess = RSC.mf.SetComputerName("Controller")
  if ocsuccess then
    local names = RSC.mf.GetNamesFromOCNet("Distributor")
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

function RSC.RSMonitorON(distributor, station, mod, monitor)
  if RSC.rs.Distributors[distributor].stations[station].monitor[monitor] ~= nil then
    if RSC.rs.Distributors[distributor].stations[station].monitor[monitor] ~= mod then
        RSC.mf.SendOverOCNet(distributor, {station=station, method="push", storage=mod, rsmonitor=monitor})
        RSC.checkConnection(distributor, false)
    else
      RSC.text.status.text = "Monitor already showing Refined Storage: " .. mod
    end
  else
    RSC.text.status.text = "Monitor not found."
  end
end
function RSC.RSMonitorOFF(distributor, station, monitor)
  if RSC.rs.Distributors[distributor].stations[station].monitor[monitor] ~= nil then
    if RSC.rs.Distributors[distributor].stations[station].monitor[monitor] ~= "" then
        RSC.mf.SendOverOCNet(distributor, {station=station, method="pull", storage=RSC.rs.Distributors[distributor].stations[station].monitor[monitor], rsmonitor=monitor})
        RSC.checkConnection(distributor, false)
    else
      RSC.text.status.text = "Monitor already OFF"
    end
  else
    RSC.text.status.text = "Monitor not found."
  end
end
function RSC.registerNetworkCards(distributor, station)
  RSC.mf.SendOverOCNet(distributor, {"register", station=station})
  RSC.checkConnection(distributor, false)
  if RSC.mf.containsKey(RSC.rs.Distributors[distributor].stations, station) then
    RSC.itemselect.s = RSC.mf.getIndex(RSC.mf.getSortedKeys(RSC.rs.Distributors[distributor].stations), station)
    RSC.combo.station.selectedItem = RSC.itemselect.s
  end
end
function RSC.removeRSMonitor(distributor, station, monitor)
  RSC.mf.SendOverOCNet(distributor, {station=station, method="push", storage="", rsmonitor=monitor, removing=true})
  RSC.checkConnection(distributor, false)
end
function RSC.removeStation(distributor, station)
  RSC.itemselect.s = 1
  RSC.mf.SendOverOCNet(distributor, {"remove", station=station})
  RSC.checkConnection(distributor, false)
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
    RSC.rs.Distributors[distributor].stations = RSC.mf.copyTable(data.stations)
    RSC.stationcount = RSC.mf.getCount(RSC.rs.Distributors[distributor].stations)
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