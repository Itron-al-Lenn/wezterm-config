---@diagnostic disable: missing-fields, assign-type-mismatch
-- Import necessary WezTerm and external modules
local wezterm = require 'wezterm' --[[@as Wezterm]]
local config = wezterm.config_builder()
local c_util = require 'util.colours'
local colours = c_util.current_colours
local os_triplet = wezterm.target_triple

-- Set default font with fallback
config.font = wezterm.font_with_fallback {
  'mononoki',
  'Symbols Nerd Font Mono',
}
config.font_size = 12
config.line_height = 1.1

-- Window customization
config.colors = { background = colours['base'] }
config.window_decorations = 'RESIZE'
config.window_close_confirmation = 'NeverPrompt'
config.max_fps = 165
config.animation_fps = 60
config.cursor_blink_rate = 250
config.window_padding = {
  top = 3,
  bottom = 0,
  left = 4,
  right = 0,
}

-- Customize the status bar and workspace display
config.enable_tab_bar = false

-- Zen mode
config.window_background_opacity = 0.85
local zen_mode = function()
  return wezterm.action_callback(function(window)
    wezterm.GLOBAL.zen_mode = not wezterm.GLOBAL.zen_mode
    if wezterm.GLOBAL.zen_mode then
      window:set_config_overrides { window_background_opacity = 1.0 }
    else
      window:set_config_overrides { window_background_opacity = 0.85 }
    end
    wezterm.log_info('Zen mode: ' .. tostring(wezterm.GLOBAL.zen_mode))
  end)
end

-- Keybindings
config.keys = {
  { key = 'Keypad7', mods = 'CTRL', action = zen_mode() },
}

-- Os specific setup
if os_triplet == 'x86_64-pc-windows-msvc' then
  -- Configure WSL and ssh domains
  config.wsl_domains = {
    {
      name = 'WSL:Ubuntu',
      default_cwd = '~',
      distribution = 'Ubuntu',
      default_prog = { 'fish' },
    },
  }

  config.default_domain = 'WSL:Ubuntu'
else
  config.default_prog = { 'fish' }
end
return config
