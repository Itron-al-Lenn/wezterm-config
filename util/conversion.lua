local M = {}

M.path = {}
M.string = {}

---Converts a windows path to its corresponding path in wsl
---@param path string
---@return string
M.path.windows_to_wsl = function(path)
  path = path:gsub('\\', '/')
  local drive, rest = path:match '^(%a):[\\/](.*)$'
  if drive then
    return '/mnt/' .. drive:lower() .. '/' .. rest
  end

  return path
end

---Converts a string of a hex number to a string of a decimal number
---@param hex string
---@return string
M.string.hex_to_decimal = function(hex)
  return tostring(tonumber(hex, 16))
end

---Converts a colour in hex format to rgba format
---@param hex string
---@param alpha integer
---@return string
M.string.hex_to_rgba = function(hex, alpha)
  local htod = M.string.hex_to_decimal
  local r = hex:sub(2, 3)
  local g = hex:sub(4, 5)
  local b = hex:sub(6, 7)
  local rgba = 'rgba(' .. htod(r) .. ', ' .. htod(g) .. ', ' .. htod(b) .. ', ' .. tostring(alpha) .. ')'
  return rgba
end

return M
