local mf = require("MainFunctionsEclipse")
local str = 'recipes.addShaped("floricraft:petals_raw_allium", <floricraft:petals_raw:3>, [[<floricraft:petal_raw:3>, <floricraft:petal_raw:3>, <floricraft:petal_raw:3>], [<floricraft:petal_raw:3>, <floricraft:petal_raw:3>, <floricraft:petal_raw:3>], [<floricraft:petal_raw:3>, <floricraft:petal_raw:3>, <floricraft:petal_raw:3>]]);'
local str2 = 'recipes.addShaped("buildcrafttransport:plug_gate_quartz_nether_brick_or", <buildcrafttransport:plug_gate>.withTag({gate: {material: 2 as byte, modifier: 2 as byte, logic: 0 as byte}}), [[<buildcrafttransport:plug_gate>.withTag({gate: {material: 2 as byte, modifier: 2 as byte, logic: 1 as byte}})]]);'
str2 = str2:gsub("recipes.addShaped%(","{"):gsub("recipes.addShapeless%(","{"):gsub("%);","}"):gsub("%)",")\""):gsub("%.withTag%(",", \"withTag("):gsub("<","\""):gsub(">","\""):gsub("%[","{"):gsub("%]","}")
print(str2)
print("")
--print(mf.serial.serialize({"floricraft:petals_raw_allium", "floricraft:petals_raw:3", {{"floricraft:petal_raw:3", "floricraft:petal_raw:3", "floricraft:petal_raw:3"}, {"floricraft:petal_raw:3", "floricraft:petal_raw:3", "floricraft:petal_raw:3"}, {"floricraft:petal_raw:3", "floricraft:petal_raw:3", "floricraft:petal_raw:3"}}}))
local b = mf.serial.unserialize(str2)

mf.printx(b)