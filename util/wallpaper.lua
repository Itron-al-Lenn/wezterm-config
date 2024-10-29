local wezterm = require 'wezterm' --[[@as Wezterm]]
local c_util = require 'util.colours'

M = {}

local function gradients(theme)
  local colours = c_util[theme]
  return {
    {
      source = {
        Gradient = {
          colors = {
            colours['base'],
            c_util.hex_to_rgba(colours['mantle'], 0.2),
            c_util.hex_to_rgba(colours['mantle'], 0.2),
            c_util.hex_to_rgba(colours['crust'], 0.0),
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
            colours['base'],
            c_util.hex_to_rgba(colours['base'], 0.5),
            c_util.hex_to_rgba(colours['base'], 0.0),
            c_util.hex_to_rgba(colours['base'], 0.0),
            c_util.hex_to_rgba(colours['base'], 0.5),
            colours['base'],
          },
          orientation = { Linear = { angle = 270 } },
        },
      },
      width = '100%',
      height = '100%',
    },
  }
end

local function calc_seed()
  local seed = tonumber(wezterm.strftime '%y%m%d')
  return seed
end

local function get_file_sep()
  local sep = '/'
  if wezterm.target_triple:find 'windows' ~= nil then
    sep = '\\'
  end
  return sep
end

---Returns a table configuring the last pane of the background.
---@param theme string Theme used
---@return table
M.get_wallpaper = function(theme)
  theme = theme or 'Mocha'
  local background = {}
  if wezterm.GLOBAL.zen_mode then
    local solid_background = {
      source = { Color = c_util[theme]['base'] },
      width = '100%',
      height = '100%',
    }
    table.insert(background, solid_background)
  else
    local seed = calc_seed()
    if wezterm.GLOBAL.last_seed ~= seed or not wezterm.GLOBAL.wallpaper then
      local sep = get_file_sep()
      local wallpaper_path = wezterm.config_dir .. sep .. 'wallpapers' .. sep
      local wallpapers
      if pcall(wezterm.read_dir, wallpaper_path .. theme) then
        wallpapers = wezterm.read_dir(wallpaper_path .. theme)
      else
        wallpapers = wezterm.read_dir(wallpaper_path)
      end
      math.randomseed(seed)
      ---@type string
      wezterm.GLOBAL.wallpaper = wallpapers[math.random(#wallpapers)]
      wezterm.GLOBAL.last_seed = seed
    end
    local background_image = {
      source = { File = wezterm.GLOBAL.wallpaper },
      horizontal_align = 'Center',
      opacity = 1,
    }
    table.insert(background, background_image)
    local gradient = gradients(theme)
    table.move(gradient, 1, #gradient, 2, background)
  end
  return background
end

-- Add actions to control our background
M.action = {}

-- Toggle the Zen Mode variable and reloads the config
M.action.zen_mode = function()
  return wezterm.action_callback(function()
    wezterm.GLOBAL.zen_mode = not wezterm.GLOBAL.zen_mode
    wezterm.log_info(wezterm.GLOBAL.zen_mode)
    wezterm.reload_configuration()
  end)
end

-- Remove the current background image
M.action.remove_wallpaper = function()
  return wezterm.action_callback(function()
    if wezterm.GLOBAL.zen_mode then
      return
    end
    local sep = get_file_sep()
    local num_wallpapers = #wezterm.read_dir(wezterm.GLOBAL.wallpaper:match([[(.*]] .. sep .. [[)]]))
    wezterm.log_info(wezterm.GLOBAL.wallpaper:match([[(.*]] .. sep .. [[)]]))
    wezterm.log_info(tostring(num_wallpapers))
    if num_wallpapers == 1 then
      wezterm.log_error "Can't delete the last wallpaper"
      return
    end
    if os.remove(wezterm.GLOBAL.wallpaper) then
      wezterm.log_error 'Deleting wallpaper failed'
    end
    wezterm.log_info(string.format('Sucessfully deleted wallpaper. %d wallpaper remaining', num_wallpapers - 1))
    wezterm.GLOBAL.last_seed = 0
    wezterm.reload_configuration()
  end)
end

return M
