local wezterm = require 'wezterm' --[[@as Wezterm]]
local c = require 'util.colours'

local M = {}

---Converts a colour in hex format to rgba format
---@param config Config
---@param colours table<string, string>
M.update_statusbar = function(config, colours)
  local text = colours['text']
  local base = c.hex_to_rgba(colours['base'], 0.6)
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

  config.tab_bar_style = {
    new_tab = '',
    new_tab_hover = '',
  }

  wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    local sym = tab.is_active and ' 𜲋' or ' ·'

    local tab_text = wezterm.format {
      { Text = string.match(tab.active_pane.title, '%g+') },
    }
    return tab_text .. sym .. divider
  end)

  wezterm.on('update-status', function(window, pane)
    -- Left Status
    local workspace_name = window:active_workspace()

    window:set_left_status(wezterm.format {
      { Text = ' [ ' },
      { Foreground = { Color = highlight } },
      { Text = workspace_name },
      { Foreground = { Color = text } },
      { Text = ' ]' },
      { Foreground = { Color = '#504945' } },
    } .. divider)

    -- Right Status
    local date_time = wezterm.strftime '%b %d %Y %H:%M '

    window:set_right_status(divider .. wezterm.format {
      { Foreground = { Color = highlight } },
      { Text = date_time },
    })
  end)
end

return M
