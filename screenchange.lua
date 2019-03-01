local mf = require("bufu/MainFunctions")
mf.OCNet.system = "ACNet"
mf.SetComputerName("Crafter")
local m = mf.component.modem
local gpu = mf.component.gpu
local serversfile = "/home/bufu/servers.lua"
local screensfile = "/home/bufu/screens.lua"
local logfile = "/home/bufu/sclog.lua"
local screens = {
    Temp="912e8944-1357-42cd-8dbf-e8140f7627e4";
    Main="9a85f463-04f0-45e6-a803-b1dafa230b47"
}
local servers = require("bufu/servers")

mf.writex("ScreenChanger Init")
getServers()
local sname = tostring(mf.getIndex(servers, m.address))

local function getScreens()
    screens = require("bufu/screens")
end
local function WriteScreensFile()
    mf.WriteObjectFile(screens, screensfile)
end
local function log(text)
    local file = mf.io.open(logfile, "a")
    file:write(text .. "\n")
    file:close()
end
local function sendToAll(data)
    for i,j in pairs(servers) do
        if sname ~= i then 
            mf.SendOverOCNet(i, data)
        end
    end
end

sendToAll({sname})
gpu.bind(screens.Main, true)
mf.component.setPrimary("screen", screens.Main)
mf.component.setPrimary("keyboard", mf.component.invoke(gpu.getScreen(), "getKeyboards")[1])
mf.shell.execute("clear")
--log(sname .. " Server bound to Main Screen")
if (sname == "-1") then
    mf.writex("New Server started. Please define a name:")
    local command = mf.io.read()
    servers[command] = m.address
    mf.WriteObjectFile(servers, serversfile)
    sendToAll({"getServers"})
    mf.writex("Server: " .. command .. " is now on the main screen!")
    sname = command
else
    mf.writex("Server: " .. sname .. " is now on the main screen!")
end
mf.writex("Type \"sc\" for help")
mf.writex("Type \"quit sc\" to quit the ScreenChanger")
mf.writex("Any other commands will be put in shell.execute\n")

local t = mf.thread.create(function()
    while true do
        mf.os.sleep()
        local data, slot = mf.ReceiveFromOCNet()
        if slot ~= -1 then
            if data[1] == "getServers" then
                servers = require("bufu/servers")
            elseif ((data[2] ~= nil) and (data[1] == "exec")) then
                local execparams = data[2]
                if #data > 2 then
                    for i = 3, #data, 1 do
                        execparams = execparams .. " " .. data[i]
                    end
                end
                mf.shell.execute(execparams)
            else
                local where = ""
                if (sname == data[1]) then
                  where = "Main"
                else
                  where = "Temp"
                end
                gpu.bind(screens[where], true)
                mf.component.setPrimary("screen", screens[where])
                mf.component.setPrimary("keyboard", mf.component.invoke(gpu.getScreen(), "getKeyboards")[1])
                --log(sname .. " Server bound to " .. where .. " Screen")
                mf.shell.execute("clear")
                mf.writex("Server: " .. sname .. " bound to " .. where .. " Screen")
            end
            mf.OCNet[slot] = nil
        end
    end
end)

while true do
    local command = mf.io.read()
    if (command ~= nil and #command > 0) then
        if command == "quit sc" then
            break
        elseif mf.startswith(command,"sc") then
            local ser = mf.split(command, " ")[2]
            if ser ~= nil then
                if ser == "renameServer" then
                    local newname = mf.split(command, " ")[3]
                    if (newname ~= nil) then
                        servers[newname] = m.address
                        servers[sname] = nil
                        mf.writex("ScreenChanger: Server: \"" .. sname .. "\" renamed to: \"" .. newname .. "\"")
                        sname = newname
                        mf.WriteObjectFile(servers, serversfile)
                        sendToAll({"getServers"})
                    else
                        mf.writex("ScreenChanger: Write \"sc renameServer $server$\" to rename the current server")
                    end
                elseif ser == "exec" then
                    local exs = mf.split(command, " ")
                    if (exs[3] ~= nil and exs[4] ~= nil) then
                        if (servers[exs[3]] ~= nil) then
                            local data = {"exec"}
                            for i = 4, #exs[], 1 do
                                data[i - 2] = exs[i]
                            end
                            mf.SendOverOCNet(servers[exs[3]], data)
                        else
                            mf.writex("Unknown Server/Command: " .. ser)
                        end
                    else
                        mf.writex("ScreenChanger: Write \"sc exec $server$ $execution$\" to execute something remotely on the specified server")
                    end
                elseif servers[ser] ~= nil then
                    if servers[ser] ~= m.address then
                        sendToAll({ser})
                    else
                        mf.writex("Server: " .. ser .. " is already on screen")
                    end
                else
                    mf.writex("Unknown Server/Command: " .. ser)
                end
            else
                mf.writex("\nScreenChanger: Write \"sc renameServer $server$\" to rename the current server")
                mf.writex("ScreenChanger: Write \"sc exec $server$ $execution$\" to execute something remotely on the specified server\n")
                mf.writex("ScreenChanger: Write \"sc $server$\"")
                mf.writex("---- Servers ----")
                mf.writex(servers)
                mf.writex("")
            end
        else
            mf.shell.execute(command)
        end
    end
end
t:kill()