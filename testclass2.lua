local mf = require("MainFunctionsEclipse")
local res = {}

local function convertCT()
  for line in io.lines("C:/Users/alexandersk/workspace/OC-Scripts/src/crafttweaker.txt") do
    print(line)
    line = line:gsub("recipes.addShaped%(\"","{__oo__"):gsub("recipes.addShapeless%(\"","{__oo__"):gsub("\", <","__oo__, <"):gsub("\"",""):gsub("__oo__","\""):gsub("%);","}"):gsub("%)",")\""):gsub("%.withTag%(",", \"withTag("):gsub("<","\""):gsub(">","\""):gsub("%[","{"):gsub("%]","}"):gsub(" %*",", "):gsub(" %| ", ", "):gsub("%)\"_",")_")
    print(line)
    local b = mf.serial.unserialize(line)
    if b ~= nil then
      if #b >= 3 then
        local temp = b[2]:gsub(":", "_jj_"):gsub("/", "_xx_"):gsub("-", "_qq_"):gsub("%.", "_vv_")
        local ttag = ""
        if type(b[3]) == "string" then
          if mf.startswith(b[3], "withTag") then
            ttag = b[3]
            temp = temp .. ttag:gsub("withTag", "__wt"):gsub(" ", "_"):gsub(":", "_jj_"):gsub("{", "_so_"):gsub("}", "_sc_"):gsub("%(", "_ro_"):gsub("%)", "_rc_")
          else
            ttag = nil
          end
        else
          ttag = nil
        end
        res[temp] = {craftCount=1, recipe={}, tag=ttag}
        for i = 3, 5, 1 do if type(b[i]) == "number" then res[temp].craftCount = b[i] break end end
        for i = 3, 5, 1 do
          if type(b[i]) == "table" then
            local recipe = {}
            local name = ""
            if type(b[i][1]) ~= "table" then
              b[i] = {b[i]}
            end
            for a,e in pairs(b[i]) do
              for c,d in pairs(e) do
                d = tostring(d)
                if mf.startswith(d,"withTag") == false and tonumber(d) == nil then
                  name = d:gsub(":", "_jj_"):gsub("/", "_xx_"):gsub("-", "_qq_"):gsub("%.", "_vv_")
                  local temptag = ""
                  local need = 1
                  if e[c + 1] ~= nil then
                    if tonumber(e[c + 1]) ~= nil then
                      need = tonumber(e[c + 1])
                    elseif mf.startswith(e[c + 1],"withTag") then
                      temptag = e[c + 1]
                      name = name .. temptag:gsub("withTag", "__wt"):gsub(" ", "_"):gsub(":", "_jj_"):gsub("{", "_so_"):gsub("}", "_sc_"):gsub("%(", "_ro_"):gsub("%)", "_rc_")
                    end
                  end
                  if recipe[name] == nil then
                    recipe[name] = {need=need, tag=temptag:gsub("withTag", "")}
                  else
                    recipe[name].need = recipe[name].need + need
                  end
                end
              end
            end
            table.insert(res[temp].recipe, recipe)
            break
          end
        end
      end
    end
  end
  mf.WriteObjectFile(res,"C:/Users/alexandersk/workspace/OC-Scripts/src/ct.txt")
  print("DONE CONVERTING")
end
convertCT()
--mf.printx(mf.listFilesInDir("C:/Users/alexandersk/workspace/OC-Scripts/src/"))