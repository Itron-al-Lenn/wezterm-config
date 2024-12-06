---@diagnostic disable: missing-fields, assign-type-mismatch
-- Import necessary WezTerm and external modules
local wezterm = require 'wezterm' --[[@as Wezterm]]
local config = wezterm.config_builder()
local act = wezterm.action
local sb = require 'util.status_bar'
local background = require 'util.wallpaper'
local c_util = require 'util.colours'
local colours = c_util.current_colours
local nvim_util = require 'util.neovim'
-- Our current theme is defined is colours.lua, such that other programs too can read colours.lua and use the colours from there
local theme = c_util.theme

-- Set default font with fallback
config.font = wezterm.font_with_fallback {
  'mononoki',
  'Symbols Nerd Font Regular',
}

-- Configure WSL and ssh domains
config.wsl_domains = {
  {
    name = 'WSL:Ubuntu',
    default_cwd = '~',
    distribution = 'Ubuntu',
    default_prog = { 'fish' },
  },
}

-- config.ssh_domains = {
--   {
--     name = 'VSOS',
--     connect_automatically = true,
--     remote_address = 'debian@itron-al-lenn.vsos.ethz.ch',
--   },
-- }

-- Window customization
config.window_decorations = 'RESIZE|INTEGRATED_BUTTONS'
config.window_close_confirmation = 'NeverPrompt'
config.max_fps = 165
config.animation_fps = 60
config.cursor_blink_rate = 250
config.window_padding = {
  top = 20,
  bottom = 0,
  left = 5,
  right = 0,
}

-- Background configuration
config.background = background.get_wallpaper(theme)

-- Reload the configuration every thirty minute
wezterm.time.call_after(1800, function()
  wezterm.reload_configuration()
end)

-- Color scheme for tabs and other UI elements
config.colors = {
  tab_bar = {
    background = 'rgba(0, 0, 0, 0)', -- Background for the tab bar
    active_tab = {
      bg_color = 'rgba(0, 0, 0, 0)',
      fg_color = colours['text'],
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = 'rgba(0, 0, 0, 0)',
      fg_color = colours['subtext0'],
    },
    inactive_tab_hover = {
      bg_color = 'rgba(0, 0, 0, 0)',
      fg_color = colours['subtext1'],
    },
    new_tab = {
      bg_color = 'rgba(0, 0, 0, 0)',
      fg_color = colours['subtext0'],
    },
    new_tab_hover = {
      bg_color = 'rgba(0, 0, 0, 0)',
      fg_color = colours['subtext1'],
    },
  },
}

-- Default shell setup
config.default_prog = { 'pwsh', '-NoLogo' }

-- Enable dimming of inactive panes
config.inactive_pane_hsb = {
  saturation = 0.5,
  brightness = 0.5,
}

-- Customize the status bar and workspace display
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
sb.status_bar({ { 'Stat', 'red', 'sapphire', 'mauve' }, { 'Battery', 'green' } }, { { 'Schedule', 'lavender', 'pink' }, { 'Clock', 'pink' } }, theme)
config.tab_bar_style = {
  window_close = '󰛉  ',
  window_close_hover = '󱎘  ',
  window_maximize = '',
  window_maximize_hover = '',
  window_hide = '  󰖰  ',
  window_hide_hover = '  󰖰  ',
}

-- Keybindings
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
-- stylua: ignore
config.keys = {
  { key = 'a',         mods = 'LEADER',             action = act.SendKey { key = 'a', mods = 'CTRL' } },
  { key = 'c',         mods = 'LEADER',             action = act.ActivateCopyMode },
  { key = 'f',         mods = 'LEADER',             action = act.ToggleFullScreen },
  { key = '-',         mods = 'LEADER',             action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = '$',         mods = 'LEADER',             action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'x',         mods = 'LEADER',             action = act.CloseCurrentPane { confirm = true } },
  { key = 'z',         mods = 'LEADER',             action = act.TogglePaneZoomState },
  { key = 'n',         mods = 'LEADER',             action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'n',         mods = 'LEADER|ALT',         action = act.SpawnTab { DomainName = 'WSL:Ubuntu' } },
  { key = '[',         mods = 'LEADER',             action = act.ActivateTabRelative(-1) },
  { key = ']',         mods = 'LEADER',             action = act.ActivateTabRelative(1) },
  { key = 't',         mods = 'LEADER',             action = act.ShowTabNavigator },
  { key = 'r',         mods = 'LEADER',             action = act.ActivateKeyTable { name = 'resize_pane', one_shot = false } },
  { key = 'm',         mods = 'LEADER',             action = act.ActivateKeyTable { name = 'move_tab', one_shot = false } },
  { key = 'Keypad7',   mods = 'LEADER',             action = background.action.zen_mode() },
  { key = 'Keypad8',   mods = 'LEADER',             action = background.action.remove_wallpaper() },
}

for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = act.ActivateTab(i - 1),
  })
end

for _, keybind in pairs(nvim_util.nav_keys) do
  table.insert(config.keys, keybind)
end

config.key_tables = {
  resize_pane = {
    { key = 'h', action = act.AdjustPaneSize { 'Left', 1 } },
    { key = 'j', action = act.AdjustPaneSize { 'Down', 1 } },
    { key = 'k', action = act.AdjustPaneSize { 'Up', 1 } },
    { key = 'l', action = act.AdjustPaneSize { 'Right', 1 } },
    { key = 'Escape', action = 'PopKeyTable' },
    { key = 'Enter', action = 'PopKeyTable' },
  },
  move_tab = {
    { key = 'h', action = act.MoveTabRelative(-1) },
    { key = 'j', action = act.MoveTabRelative(-1) },
    { key = 'k', action = act.MoveTabRelative(1) },
    { key = 'l', action = act.MoveTabRelative(1) },
    { key = 'Escape', action = 'PopKeyTable' },
    { key = 'Enter', action = 'PopKeyTable' },
  },
}

return config
