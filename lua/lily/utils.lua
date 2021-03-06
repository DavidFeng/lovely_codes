local M = {}

function M.table_reverse(t)
  local j = #t
  for i = 1, j / 2 do
    t[i], t[j] = t[j], t[i]
    j = j - 1
  end
  return t
end

function M.string_bytes(str)
  local i = 0
  local len = # str
  return function ()
    i = i + 1
    if i > len then
      return nil
    else
      return str:byte(i)
    end
  end
end

local function inject_stdlib()
  table.reverse = M.table_reverse
  string.bytes = M.string_bytes
end

function M.callable_class()
  return setmetatable({}, {
    __call = function (class, ...)
      return setmetatable({}, class):ctor(...)
    end
  })
end

inject_stdlib()

return M
