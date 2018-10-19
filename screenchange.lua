local thread = require("thread")
local c = require("component")
local os = require("os")
local shell = require("shell")
local io = require("io")
local fs = require("filesystem")
local event = require("event")
local mf = require("MainFunctions")
local m = c.modem
local gpu = c.gpu
local sides = require("sides")
local serversfile = "/bufu/servers.lua"
local screensfile = "/bufu/screens.lua"
local logfile = "/bufu/sclog.lua"
local screens = {
    Temp="912e8944-1357-42cd-8dbf-e8140f7627e4";
    Main="9a85f463-04f0-45e6-a803-b1dafa230b47"
}
local servers = {}

mf.writex("ScreenChanger Init")
local function getScreens()
    if (fs.exists(screensfile)) then
        for line in io.lines(screensfile) do
          if (#line > 0) then
            local l = mf.split(line, " = ")
            --mf.writex("Adding screen: " .. l[1] .. " IP: " .. l[2] .. "")
            screens[l[1]] = l[2]
          end
        end
    else
        local file = io.open(screensfile, "w")
        file:close()
    end
end
local function getServers()
    if (fs.exists(serversfile)) then
        for line in io.lines(serversfile) do
          if (#line > 0) then
            local l = mf.split(line, " = ")
            --mf.writex("Adding server: " .. l[1] .. " IP: " .. l[2])
            servers[l[1]] = l[2]
          end
        end
    else
        local file = io.open(serversfile, "w")
        file:close()
    end
end
local function WriteServersFile()
    fs.remove(serversfile)
    local file = io.open(serversfile, "w")
    for i,j in pairs(servers) do
        file:write(i .. "=" .. j .. "\n")
    end
    file:close()
end
local function WriteScreensFile()
    fs.remove(screensfile)
    local file = io.open(screensfile, "w")
    for i,j in pairs(screens) do
        file:write(i .. "=" .. j .. "\n")
    end
    file:close()
end
local function log(text)
    local file = io.open(logfile, "a")
    file:write(text .. "\n")
    file:close()
end

getServers()
local sname = tostring(mf.getIndex(servers, m.address))
m.close()
m.open(123)
m.broadcast(123, sname)
gpu.bind(screens.Main, true)
c.setPrimary("screen", screens.Main)
c.setPrimary("keyboard", c.invoke(gpu.getScreen(), "getKeyboards")[1])
shell.execute("clear")
--log(sname .. " Server bound to Main Screen")
if (sname == "-1") then
    mf.writex("New Server started. Please define a name:")
    local command = io.read()
    servers[command] = m.address
    WriteServersFile()
    m.broadcast(123, "getServers")
    mf.writex("Server: " .. command .. " is now on the main screen!")
    sname = command
else
    mf.writex("Server: " .. sname .. " is now on the main screen!")
end
mf.writex("Type \"sc\" for help")
mf.writex("Type \"quit sc\" to quit the ScreenChanger")
mf.writex("Any other commands will be put in shell.execute\n")

local t = thread.create(function()
    while true do
        os.sleep()
        local _, _, _, _, _, name = event.pull("modem_message")
        local ex = mf.split(name, " ")
        if name == "getServers" then
            getServers()
        elseif ((ex[2] ~= nil) and (ex[1] == "exec")) then
            shell.execute(ex[2])
        else
            local where = ""
            if (sname == name) then
              where = "Main"
            else
              where = "Temp"
            end
            gpu.bind(screens[where], true)
            c.setPrimary("screen", screens[where])
            c.setPrimary("keyboard", c.invoke(gpu.getScreen(), "getKeyboards")[1])
            log(sname .. " Server bound to " .. where .. " Screen")
            mf.writex(sname .. " Server bound to " .. where .. " Screen")
        end
    end
end)

while true do
    local command = io.read()
    if (command ~= nil and #command > 0) then
        if command == "quit sc" then
            break
        elseif mf.startswith(command,"sc") then
            local ser = mf.split(command, " ")[2]
            if ser ~= nil then
                if ser == "renameServer" then
                    local newname = mf.split(command, " ")[3]
                    if (newname ~= nil) then
                        local oldname = mf.getIndex(servers, m.address)
                        servers[newname] = m.address
                        servers[oldname] = nil
                        WriteServersFile()
                        m.broadcast(123, "getServers")
                        mf.writex("ScreenChanger: Server: \"" .. oldname .. "\" renamed to: \"" .. newname .. "\"")
                    else
                        mf.writex("ScreenChanger: Write \"sc renameServer $mod$\" to rename the current server")
                    end
                elseif ser == "exec" then
                    local exs = mf.split(command, " ")
                    if (exs[3] ~= nil and exs[4] ~= nil) then
                        if (servers[exs[3]] ~= nil) then
                            m.send(servers[exs[3]], 123, "exec " .. exs[4])
                        end
                    else
                        mf.writex("ScreenChanger: Write \"sc exec $mod$ $execution$\" to execute something remotely on the specified server")
                    end
                elseif servers[ser] ~= nil then
                    if servers[ser] ~= m.address then
                        m.broadcast(123, ser)
                    else
                        mf.writex("Server: " .. ser .. " is already on screen")
                    end
                else
                    mf.writex("Unknown Server/Command: " .. ser)
                end
            else
                mf.writex("\nScreenChanger: Write \"sc renameServer $mod$\" to rename the current server")
                mf.writex("ScreenChanger: Write \"sc exec $mod$ $execution$\" to execute something remotely on the specified server\n")
                mf.writex("ScreenChanger: Write \"sc $mod$\"")
                mf.writex("---- MODS ----")
                mf.writex(servers)
                mf.writex("")
            end
        else
            shell.execute(command)
        end
    end
end
t:kill()