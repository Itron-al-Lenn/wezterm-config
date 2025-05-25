local wezterm = require 'wezterm' --[[@as Wezterm]]
local g = wezterm.GLOBAL
local path = require('util.conversion').path

g.script_dir = path.windows_to_wsl(wezterm.config_dir) .. '/scripts/'
g.is_windows = wezterm.target_triple == 'x86_64-pc-windows-msvc'

return g
