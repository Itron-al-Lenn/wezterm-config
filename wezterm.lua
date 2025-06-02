---@diagnostic disable: missing-fields, assign-type-mismatch
-- Import necessary WezTerm and external modules
local wezterm = require 'wezterm' --[[@as Wezterm]]
local config = wezterm.config_builder()
local g = require 'util.globals'
local sb = require 'status_bar'
local keys = require 'keys'

-- Set default theme
g.theme = 'Gruvbox-Mat'

-- Set default font with fallback
config.font = wezterm.font_with_fallback {
  'mononoki',
  'Symbols Nerd Font Mono',
}
config.font_size = 12
config.line_height = 1.1

-- Window customization
config.window_close_confirmation = 'NeverPrompt'
config.max_fps = 120
config.window_padding = {
  top = 7,
  bottom = 0,
  left = 7,
  right = 0,
}

-- Customize the status bar and workspace display
config.use_fancy_tab_bar = false
sb.update_statusbar(config)

config.status_update_interval = 2000

wezterm.on('gui-startup', function(cmd)
  local _, _, mux_window = wezterm.mux.spawn_window(cmd or {})
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
  config.window_decorations = 'RESIZE'
  config.default_domain = 'WSL:Ubuntu'
else
  config.unix_domains = {
    {
      name = 'arch',
    },
  }
  config.default_prog = { 'fish' }
  config.enable_wayland = true
end
return config
