---@diagnostic disable: missing-fields
local wezterm = require 'wezterm' --[[@as Wezterm]]
local act = wezterm.action
local g = wezterm.GLOBAL
local fp = require 'util.floating_pane'
local vim = require 'util.vim'

local zen_mode = function()
  return wezterm.action_callback(function(window)
    g.zen_mode = not g.zen_mode
    if g.zen_mode then
      window:set_config_overrides { window_background_opacity = 1.0 }
    else
      window:set_config_overrides { window_background_opacity = 0.7 }
    end
    wezterm.log_info('Zen mode: ' .. tostring(g.zen_mode))
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
    { mods = 'LEADER', key = 'g', action = fp.sessionizerv2() },
    { mods = 'LEADER', key = ',', action = act.ShowDebugOverlay },
    { mods = 'LEADER', key = '-', action = act.SplitVertical },
    { mods = 'LEADER', key = '$', action = act.SplitHorizontal },
    { mods = 'LEADER', key = 'c', action = act.SpawnTab 'CurrentPaneDomain' },
    { mods = 'LEADER', key = 'x', action = act.CloseCurrentPane { confirm = false } },
    { mods = 'LEADER', key = 'h', action = act.ActivateTabRelative(-1) },
    { mods = 'LEADER', key = 'l', action = act.ActivateTabRelative(1) },
    bind_if(vim.is_outside, 'h', 'CTRL', act.ActivatePaneDirection 'Left'),
    bind_if(vim.is_outside, 'l', 'CTRL', act.ActivatePaneDirection 'Right'),
    bind_if(vim.is_outside, 'j', 'CTRL', act.ActivatePaneDirection 'Down'),
    bind_if(vim.is_outside, 'k', 'CTRL', act.ActivatePaneDirection 'Up'),
  }
  if g.is_windows then
    table.insert(config.keys, { mods = 'LEADER|SHIFT', key = 'c', action = act.SpawnTab { DomainName = 'local' } })
  end
end
