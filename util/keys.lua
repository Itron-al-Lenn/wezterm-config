---@diagnostic disable: missing-fields
local wezterm = require 'wezterm' --[[@as Wezterm]]
local act = wezterm.action
local fp = require 'util.floating_pane'

---Checks if inside a vim session
---@param pane Pane
---@return boolean
local function is_outside_vim(pane)
  local program = string.match(pane:get_title(), '%g+')
  wezterm.log_info('Reduced: ' .. tostring(program))
  local inside = program == 'nvim' or program == 'vim'
  wezterm.log_info('Bool: ' .. tostring(inside))
  return not inside
end

local zen_mode = function()
  return wezterm.action_callback(function(window)
    wezterm.GLOBAL.zen_mode = not wezterm.GLOBAL.zen_mode
    if wezterm.GLOBAL.zen_mode then
      window:set_config_overrides { window_background_opacity = 1.0 }
    else
      window:set_config_overrides { window_background_opacity = 0.7 }
    end
    wezterm.log_info('Zen mode: ' .. tostring(wezterm.GLOBAL.zen_mode))
  end)
end

local function bind_if(cond, key, mods, action)
  local function callback(win, pane)
    if cond(pane) then
      win:perform_action(action, pane)
    else
      win:perform_action(act.SendKey { key = key, mods = mods }, pane)
    end
  end

  return { key = key, mods = mods, action = wezterm.action_callback(callback) }
end

---@param config Config
return function(config)
  config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
  config.keys = {
    { key = 'Keypad7', mods = 'LEADER', action = zen_mode() },
    { mods = 'LEADER', key = 'f', action = fp.sessionizer() },
    { mods = 'LEADER', key = ',', action = act.ShowDebugOverlay },
    { mods = 'LEADER', key = '-', action = act.SplitVertical },
    { mods = 'LEADER', key = '$', action = act.SplitHorizontal },
    { mods = 'LEADER', key = 'c', action = act.SpawnTab 'CurrentPaneDomain' },
    { mods = 'LEADER', key = 'x', action = act.CloseCurrentPane { confirm = false } },
    { mods = 'LEADER', key = 'h', action = act.ActivateTabRelative(-1) },
    { mods = 'LEADER', key = 'l', action = act.ActivateTabRelative(1) },
    bind_if(is_outside_vim, 'h', 'CTRL', act.ActivatePaneDirection 'Left'),
    bind_if(is_outside_vim, 'l', 'CTRL', act.ActivatePaneDirection 'Right'),
    bind_if(is_outside_vim, 'j', 'CTRL', act.ActivatePaneDirection 'Down'),
    bind_if(is_outside_vim, 'k', 'CTRL', act.ActivatePaneDirection 'Up'),
  }
end
