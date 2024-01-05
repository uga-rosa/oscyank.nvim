local bit = require("bit")

local M = {}

local chars = vim.split("BCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", "")
chars[0] = "A"

---@generic K, T
---@param dict table<K, T>
---@param key K
---@param default T
---@return T
local function get(dict, key, default)
  local result = dict[key]
  if result ~= nil then
    return result
  else
    return default
  end
end

---@param str string
---@return string b64
function M.encode(str)
  local bytes = { string.byte(str, 1, -1) }
  local result = {}
  for i = 1, #bytes, 3 do
    local n = bit.lshift(bytes[i], 16) + bit.lshift(get(bytes, i + 1, 0), 8) + get(bytes, i + 2, 0)
    table.insert(result, chars[bit.rshift(n, 18)])
    table.insert(result, chars[bit.band(bit.rshift(n, 12), 0x3f)])
    table.insert(result, chars[bit.band(bit.rshift(n, 6), 0x3f)])
    table.insert(result, chars[bit.band(n, 0x3f)])
  end
  if #bytes % 3 == 1 then
    result[#result - 1] = "="
    result[#result] = "="
  elseif #bytes % 3 == 2 then
    result[#result] = "="
  end
  return table.concat(result, "")
end

return M
