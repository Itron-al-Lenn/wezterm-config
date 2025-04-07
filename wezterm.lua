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
local os_triplet = wezterm.target_triple

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
config.window_decorations = 'NONE'
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
  { key = 'a', mods = 'LEADER', action = act.SendKey { key = 'a', mods = 'CTRL' } },
  { key = 'c', mods = 'LEADER', action = act.ActivateCopyMode },
  { key = 'f', mods = 'CTRL', action = act.ToggleFullScreen },
  { key = '-', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = '$', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
  { key = 'n', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = '[', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  { key = ']', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = 't', mods = 'LEADER', action = act.ShowTabNavigator },
  { key = 'r', mods = 'LEADER', action = act.ActivateKeyTable { name = 'resize_pane', one_shot = false } },
  {
    key = 'e',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = 'Bold' } },
        { Foreground = { AnsiColor = 'Fuchsia' } },
        { Text = 'Renaming Tab Title...:' },
      },
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
  { key = 'm', mods = 'LEADER', action = act.ActivateKeyTable { name = 'move_tab', one_shot = false } },
  { key = 'Keypad7', mods = 'LEADER', action = background.action.zen_mode() },
  { key = 'Keypad8', mods = 'LEADER', action = background.action.remove_wallpaper() },
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

-- Os specific setup
if os_triplet == 'x86_64-pc-windows-msvc' then
  config.default_prog = { 'pwsh', '-NoLogo' }
  table.insert(config.keys, { key = 'n', mods = 'LEADER|ALT', action = act.SpawnTab { DomainName = 'WSL:Ubuntu' } })
else
  config.default_prog = { 'fish' }
end
return config
