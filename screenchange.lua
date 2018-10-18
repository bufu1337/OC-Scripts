local thread = require("thread")
local c = require("component")
local os = require("os")
local io = require("io")
local fs = require("filesystem")
local event = require("event")
local m = c.modem
local gpu = c.gpu
local sides = require("sides")
local serversfile = "/bufu/servers.lua"
local screen = {
    Temp="912e8944-1357-42cd-8dbf-e8140f7627e4";
    Main="9a85f463-04f0-45e6-a803-b1dafa230b47"
}
local servers = {
  --minecraft="e6c5887f-5058-4067-a2aa-d33a24c4541e";
  --chimneys="2583b808-0f6e-4ab4-b3f6-efd1b30a6520"
}
local function contains(self, element)
  for key, value in pairs(self) do
    if value == element then
      return true
    end
  end
  return false
end
local function containsKey(self, element)
  for key, value in pairs(self) do
    if key == element then
      return true
    end
  end
  return false
end
local function getIndex(self, element)
  for key, value in pairs(self) do
    if value == element then
      return key
    end
  end
  return -1
end
local function startswith(self, str) 
    return self:find('^' .. str) ~= nil
end
local function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
print("screenchange init")
local function getServers()
    if (fs.exists(serversfile)) then
        for line in io.lines(serversfile) do
          if (#line > 0) then
            local l = split(line, "=")
            print("Adding server: " .. l[1] .. " IP: " .. l[2])
            servers[l[1]] = l[2]
          end
        end
    else
        local file = io.open(serversfile, "w")
        file:close()
    end
end

getServers()
m.close()
m.open(123)
gpu.bind(screen.Main, true)
for i,j in pairs(servers) do
    if m.address ~= j then
        m.send(j, 123, "Temp")
    else
        print("Server: " .. i .. " is now on the main screen")
    end
end
if (contains(servers, m.address)) == false then
    print("New Server started. Please define a name:")
    local command = io.read()
    servers[command] = m.address
    fs.remove(serversfile)
    local file = io.open(serversfile, "w")
    for i,j in pairs(servers) do
        file:write(i .. "=" .. j)
    end
    file:close()
    m.broadcast(123, "getServers")
    print("Server: " .. command .. " is now on the main screen!")
else
    print("Server is in list")
end
print("Type \"sc\" for help")
print("Type \"quit sc\" to quit the screen-changing")
print("Any other commands will be put in os.execute")

local t = thread.create(function()
    while true do
        os.sleep()
        local _, _, from, _, _, where = event.pull("modem_message")
        if where == "getServers" then
            getServers()
        else
            print(where)
            gpu.bind(screen[where], true)
            if where == "Main" then
                if m.address ~= from then
                    m.send(from, 123, "Temp")
                end
            end
        end
    end
end)

while true do
    local command = io.read()
    if (command ~= nil and #command > 0) then
      if command == "quit sc" then
        break
      elseif startswith(commmand,"sc") then
        local ser = split(command, " ")[2]
        if ser ~= nil then
            if ser == "addServer" then
                local snew = split(command, " ")
                if ((snew[3] ~= nil) and (snew[4] ~= nil)) then
                    servers[snew[3]] = snew[4]
                    fs.remove(serversfile)
                    local file = io.open(serversfile, "w")
                    for i,j in pairs(servers) do
                        file:write(i .. "=" .. j)
                    end
                    file:close()
                    m.broadcast(123, "getServers")
                else
                    print("ScreenChanger: Write \"sc addServer $mod$ $modem.address$\" to add a new server to server list")
                end
            elseif servers[ser] ~= nil then
                if servers[ser] ~= m.address then
                    m.send(servers[ser], 123, "Main")
                else
                    print("Server: " .. ser .. " is already on screen")
                end
            else
                print("Unknown Server: " .. ser)
            end
        else
            print("")
            print("ScreenChanger: Write \"sc addServer $mod$ $modem.address$\" to add a new server to server list")
            print("")
            print("ScreenChanger: Write \"sc $mod$\"")
            print("---- MODS ----")
            for i,j in servers do
                print(i)
            end
            print("")
        end
      else
        os.execute(command)
      end
    end
end
t:kill()