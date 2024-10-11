-- Import necessary WezTerm and external modules
local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action
local sb = require 'util.status_bar'
local theme = 'Mocha'
local c = require('util.colours')[theme]

-- Set default font with fallback
config.font = wezterm.font_with_fallback {
  {
    family = 'mononoki',
    weight = 'Regular',
  },
  'Symbols Nerd Font Regular',
}

-- Configure WSL domains
config.wsl_domains = {
  {
    name = 'WSL:Ubuntu',
    distribution = 'Ubuntu',
    default_prog = { 'zsh' },
  },
}

-- Window customization
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.window_close_confirmation = 'NeverPrompt'
config.max_fps = 144
config.animation_fps = 60
config.cursor_blink_rate = 250
config.window_padding = {
  top = 20,
  bottom = 0,
  left = 5,
  right = 0,
}

-- Background configuration
config.background = {
  {
    source = { File = wezterm.config_dir .. '/wallpapers/jellyfish.jpg' },
    horizontal_align = 'Center',
    opacity = 1,
  },
  {
    source = {
      Gradient = {
        colors = {
          c['base'],
          -- 'rgba(24, 24, 37, 0.75)',
          'rgba(24, 24, 37, 0.2)',
          'rgba(17, 17, 27, 0.0)',
        },
      },
    },
    width = '100%',
    height = '100%',
  },
  {
    source = {
      Gradient = {
        colors = {
          c['mantle'],
          c['mantle'],
          'rgba(17, 17, 27, 0.0)',
          'rgba(17, 17, 27, 0.0)',
          'rgba(17, 17, 27, 0.0)',
          'rgba(17, 17, 27, 0.0)',
        },
        orientation = { Linear = { angle = 270 } },
      },
    },
    width = '100%',
    height = '100%',
  },
}

-- Color scheme for tabs and other UI elements
config.colors = {
  tab_bar = {
    background = c['mantle'], -- Background for the tab bar
    active_tab = {
      bg_color = c['surface0'],
      fg_color = c['text'],
      intensity = 'Bold',
      underline = 'None',
      italic = false,
      strikethrough = false,
    },
    inactive_tab = {
      bg_color = c['mantle'],
      fg_color = c['subtext0'],
    },
    inactive_tab_hover = {
      bg_color = c['base'],
      fg_color = c['subtext1'],
    },
    new_tab = {
      bg_color = c['mantle'],
      fg_color = c['subtext0'],
    },
    new_tab_hover = {
      bg_color = c['base'],
      fg_color = c['subtext1'],
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
sb.status_bar({ { 'Stat', 'red', 'sapphire', 'mauve' }, { 'Battery', 'green' } }, { { 'Schedule', 'lavender', 'pink' }, { 'Clock' } }, theme)
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
  { key = 'n', mods = 'LEADER|ALT', action = act.SpawnTab { DomainName = 'WSL:Ubuntu' } },
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
}

for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = act.ActivateTab(i - 1),
  })
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
