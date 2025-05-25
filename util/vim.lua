local wezterm = require 'wezterm' --[[@as Wezterm]]
local M = {}

---Checks if inside a vim session
---@param pane Pane
---@return boolean
M.is_outside = function(pane)
  local program = string.match(pane:get_title(), '%g+')
  local inside = program == 'nvim' or program == 'vim'
  return not inside
end

return M
