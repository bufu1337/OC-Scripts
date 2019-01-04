local a = {}
local items = {}
local mf = require("MainFunctions")
local function b(i)
  items = mf.copyTable(i)
  mf.printx(items)
  local tempitems = {}
  for i,j in pairs(items) do
    if j.recipe ~= nil then
      print("hasRecipe")
      for a,g in pairs(j.recipe) do
        print("--- " .. a .. "    " .. g.name)
        tempitems[a] = g
      end
    end
  end
  print("")
  print("Function END")
  print("")
  print(mf.getCount(tempitems))
  if mf.getCount(tempitems) ~= 0 then
    local tc = require("testclass")
    tc.b(tempitems)
  end
end
local h = {name="sdf", hh={2,4}, gg={bu="bla"}}
local g = {name="sddsf", hh={1,2,4}, gg={ba="blaaa"}}
mf.printx(mf.combineTables(h,g))
a.b = b
return a