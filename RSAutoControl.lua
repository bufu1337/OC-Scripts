local rsac = {}
rsac.convert = require("Convert")
rsac.prox = require("RSProxies")
rsac.mf = require("MainFunctions")
rsac.refs = rsac.mf.component.block_refinedstorage_cable
rsac.items = {}
rsac.storageitems = rsac.refs.getItems()

for index,item in pairs(rsac.storageitems) do
    rsac.items[rsac.convert.ItemToOName(item)] = {minCount=0, maxCount=0, rschannel={}}
end

rsac.mf.WriteObjectFile(rsac.items, "/home/RSItems.lua")

return rsac