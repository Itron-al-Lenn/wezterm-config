local wezterm = require 'wezterm' --[[@as Wezterm]]
local g = wezterm.GLOBAL
local path = require 'util.path'

g.script_dir = path.windows_to_wsl_path(wezterm.config_dir) .. '/util/scripts/'
g.is_windows = wezterm.target_triple == 'x86_64-pc-windows-msvc'
