if filesystem.exists("/home/DB") == false then filesystem.makeDirectory("/home/DB") end
local db = {}
db.component = require("component")
db.iTag = require("item")
db.mf = require("MainFunctions")
db.db_address = {
    "a0f47fd0-5a6d-4888-be22-b3ec9dbd580a"
}
function db.GetDB(db_num)
    return db.db_address[db_num]
end
function db.GetItemDataRaw(db_num, pos)
    if pos < 1 or pos > 81 then
        return nil
    end
    local db_com = db.GetDB(db_num)
    if db_com == nil then
        return nil
    end
    local com = db.component.proxy(db_com)
    if com == nil then
        return nil
    end
    return com.get(pos)
end
function db.GetItemData(db_num, pos)
    local item = db.GetItemDataRaw(db_num, pos)
    if item == nil then
        return nil
    end
    item.tag = db.itag.readTag(com.get(pos))
    return item
end
function db.GetDBItems(db_num)
    if filesystem.exists("/home/DB/db_" .. db_num .. ".lua") then
        return require("/home/DB/db_" .. db_num .. ".lua")
    end
    return {}
end
function db.RefreshDBFiles(new)
    for i, k in pairs(db.db_address) do
        local items = {}
        if new then
            items = db.GetDBItems(k)
        end
        for j = 1, 81, 1 do
            if items[j] ~= nil then
                local item = db.GetItemData(k, j)
                if item ~= nil then
                    table.insert(items, item)
                end
            end
        end
        db.mf.WriteObjectFile(items, "/home/DB/db_" .. k .. ".lua", 2)
    end
end

return db