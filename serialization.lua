local serialization = {}

-- delay loaded tables fail to deserialize cross [C] boundaries (such as when having to read files that cause yields)
local local_pairs = function(tbl)
  local mt = getmetatable(tbl)
  return (mt and mt.__pairs or pairs)(tbl)
end
local function endswith(ab, str) 
    return (ab:sub(#ab - #str + 1) == str)
end

-- Important: pretty formatting will allow presenting non-serializable values
-- but may generate output that cannot be unserialized back.
function serialization.serializedtable(value, pretty, dep)
  local kw =  {["and"]=true, ["break"]=true, ["do"]=true, ["else"]=true,
               ["elseif"]=true, ["end"]=true, ["false"]=true, ["for"]=true,
               ["function"]=true, ["goto"]=true, ["if"]=true, ["in"]=true,
               ["local"]=true, ["nil"]=true, ["not"]=true, ["or"]=true,
               ["repeat"]=true, ["return"]=true, ["then"]=true, ["true"]=true,
               ["until"]=true, ["while"]=true}
  local id = "^[%a_][%w_]*$"
  local ts = {}
  local result_pack = {}
  local current_str = ""
  if dep == nil then
    dep = 100000
  end
  local function recurse(current_value, depth)
    local t = type(current_value)
    if t == "number" then
      if current_value ~= current_value then
        current_str = current_str .. "0/0"
        --table.insert(result_pack, "0/0")
      elseif current_value == math.huge then
        current_str = current_str .. "math.huge"
      elseif current_value == -math.huge then
        current_str = current_str .. "-math.huge"
      else
        current_str = current_str .. tostring(current_value)
      end
    elseif t == "string" then
      current_str = current_str .. (string.format("%q", current_value):gsub("\\\n","\\n"))
    elseif
      t == "nil" or
      t == "boolean" or
      pretty and (t ~= "table" or (getmetatable(current_value) or {}).__tostring) then
      current_str = current_str .. tostring(current_value)
    elseif t == "table" then
      if ts[current_value] then
        if pretty then
          table.insert(result_pack, "recursion")
          return
        else
          error("tables with cycles are not supported")
        end
      end
      ts[current_value] = true
      local f
      if pretty then
        local ks, sks, oks = {}, {}, {}
        for k in local_pairs(current_value) do
          if type(k) == "number" then
            table.insert(ks, k)
          elseif type(k) == "string" then
            table.insert(sks, k)
          else
            table.insert(oks, k)
          end
        end
        table.sort(ks)
        table.sort(sks)
        for _, k in ipairs(sks) do
          table.insert(ks, k)
        end
        for _, k in ipairs(oks) do
          table.insert(ks, k)
        end
        local n = 0
        f = table.pack(function()
          n = n + 1
          local k = ks[n]
          if k ~= nil then
            return k, current_value[k]
          else
            return nil
          end
        end)
      else
        f = table.pack(local_pairs(current_value))
      end
      local i = 1
      local first = true
      
      for k, v in table.unpack(f) do
        if first then
          if endswith(current_str, "{") or endswith(current_str, "},") then
            current_str = string.gsub(current_str, "=}", "={}")
            if depth < dep then
              current_str = current_str .. "\n"
              table.insert(result_pack, current_str)
              current_str = string.rep(" ", depth)
            end
          end
          current_str = current_str .. "{"
        else
          current_str = current_str .. ","
        end
        if pretty and type(k) == "string" and depth < dep then
          current_str = string.gsub(current_str, "=}", "={}")
          current_str = current_str .. "\n"
          table.insert(result_pack, current_str)
          current_str = string.rep(" ", depth)
        end
        first = nil
        local tk = type(k)
        if tk == "number" and k == i then
          i = i + 1
          recurse(v, depth + 1)
        else
          if tk == "string" and not kw[k] and string.match(k, id) then
            current_str = current_str .. k
          else
            current_str = current_str .. "["
            recurse(k, depth + 1)
            current_str = current_str .. "]"
          end
          current_str = current_str .. "="
          recurse(v, depth + 1)
        end
      end
      ts[current_value] = nil -- allow writing same table more than once
      if endswith(current_str, "}") or endswith(current_str, "},") then
        current_str = string.gsub(current_str, "=}", "={}")
        if depth < dep then
          current_str = current_str .. "\n"
          table.insert(result_pack, current_str)
          current_str = string.rep(" ", depth)
        end
      end
      current_str = current_str .. "}"
    else
      error("unsupported type: " .. t)
    end
  end
  recurse(value, 1)
  if current_str ~= "" then
    current_str = string.gsub(current_str, "=}", "={}")
    table.insert(result_pack, current_str)
  end
  return result_pack
end
function serialization.serialize(value, pretty)
  local result = table.concat(serialization.serializedtable(value, pretty))
  if pretty then
    local limit = type(pretty) == "number" and pretty or 10
    local truncate = 0
    while limit > 0 and truncate do
      truncate = string.find(result, "\n", truncate + 1, true)
      limit = limit - 1
    end
    if truncate then
      return result:sub(1, truncate) .. "..."
    end
  end
  return result
end
function serialization.unserialize(data)
  --checkArg(1, data, "string")
  local result, reason = load("return " .. data, "=data", nil, {math={huge=math.huge}})
  if not result then
    return nil, reason
  end
  local ok, output = pcall(result)
  if not ok then
    return nil, output
  end
  return output
end

return serialization
