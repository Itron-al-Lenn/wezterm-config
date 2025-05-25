local wezterm = require 'wezterm' --[[@as Wezterm]]
local hex_to_rgba = require('util.conversion').string.hex_to_rgba
local colours = require('util.colours').current_colours

local M = {}

---Sets the status bar config
---@param config Config
M.update_statusbar = function(config)
  local text = colours['text']
  local base = hex_to_rgba(colours['base'], 0.6)
  local mauve = colours['mauve']
  local surface = colours['surface0']
  local highlight = colours['maroon']

  ---@diagnostic disable-next-line: missing-fields
  config.colors = {
    background = base,
    tab_bar = {
      background = base,
      active_tab = {
        fg_color = highlight,
        bg_color = base,
      },
      inactive_tab = {
        fg_color = text,
        bg_color = base,
      },
      inactive_tab_hover = {
        fg_color = mauve,
        bg_color = base,
        italic = false,
      },
    },
  }

  local divider = wezterm.format {
    { Foreground = { Color = surface } },
    { Background = { Color = base } },
    { Text = ' ╏ ' },
  }

  ---@diagnostic disable-next-line: missing-fields
  config.tab_bar_style = {
    new_tab = '',
    new_tab_hover = '',
  }

  wezterm.on('format-tab-title', function(tab)
    local sym = tab.is_active and ' 󱓼' or ' ·'

    local tab_text = wezterm.format {
      { Text = string.match(tab.active_pane.title, '%g+') },
    }
    return tab_text .. sym .. divider
  end)

  wezterm.on('update-status', function(window)
    local workspace_name = window:active_workspace()

    window:set_left_status(wezterm.format {
      { Text = ' [ ' },
      { Foreground = { Color = highlight } },
      { Text = workspace_name },
      { Foreground = { Color = text } },
      { Text = ' ]' },
      { Foreground = { Color = '#504945' } },
    } .. divider)

    local date_time = wezterm.strftime '%b %d %Y %H:%M '
    window:set_right_status(divider .. wezterm.format {
      { Foreground = { Color = highlight } },
      { Text = date_time },
    })
  end)
end

return M
