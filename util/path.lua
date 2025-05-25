local M = {}

---Converts a windows path to its corresponding path in wsl
---@param path string
---@return string
M.windows_to_wsl_path = function(path)
  path = path:gsub('\\', '/')
  local drive, rest = path:match '^(%a):[\\/](.*)$'
  if drive then
    return '/mnt/' .. drive:lower() .. '/' .. rest
  end

  return path
end

return M
