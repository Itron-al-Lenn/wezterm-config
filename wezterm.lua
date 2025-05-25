---@diagnostic disable: missing-fields, assign-type-mismatch
-- Import necessary WezTerm and external modules
require 'util.globals'
local wezterm = require 'wezterm' --[[@as Wezterm]]
local config = wezterm.config_builder()
local c_util = require 'util.colours'
local g = wezterm.GLOBAL
local colours = c_util.current_colours
local sb = require 'util.status_bar'
local keys = require 'util.keys'

-- Set default font with fallback
config.font = wezterm.font_with_fallback {
  'mononoki',
  'Symbols Nerd Font Mono',
}
config.font_size = 12
config.line_height = 1.1

-- Window customization
-- config.window_background_opacity = 0.7
config.window_close_confirmation = 'NeverPrompt'
config.max_fps = 120
config.animation_fps = 30
config.window_padding = {
  top = 7,
  bottom = 0,
  left = 7,
  right = 0,
}

-- Customize the status bar and workspace display
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
sb.update_statusbar(config, colours)

config.status_update_interval = 2000

config.unix_domains = {
  {
    name = 'arch',
  },
}

wezterm.on('gui-startup', function(cmd)
  local tab, pane, mux_window = wezterm.mux.spawn_window(cmd or {})
  local window = mux_window:gui_window()

  local overrides = window:get_config_overrides() or {}

  if cmd and cmd.args and #cmd.args >= 2 then
    local program_to_run = cmd.args[1]
    local first_arg_to_program = cmd.args[2]

    if string.match(program_to_run, 'fish$') and first_arg_to_program == '-c' then
      overrides.enable_tab_bar = false
    end
  end

  window:set_config_overrides(overrides)
end)

-- Keybindings
keys(config)

-- Os specific setup
if g.is_windows then
  config.wsl_domains = {
    {
      name = 'WSL:Ubuntu',
      default_cwd = '~',
      distribution = 'Ubuntu',
      default_prog = { 'fish' },
    },
  }

  config.default_domain = 'WSL:Ubuntu'
  config.window_decorations = 'RESIZE'
else
  config.default_prog = { 'fish' }
  config.enable_wayland = true
end
return config
