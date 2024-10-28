local wezterm = require 'wezterm' --[[@as Wezterm]]
local colours = require 'util.colours'

M = {}

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
    background = {
      source = { Color = colours[theme]['base'] },
      width = '100%',
      height = '100%',
    }
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
    background = {
      source = { File = wezterm.GLOBAL.wallpaper },
      horizontal_align = 'Center',
      opacity = 1,
    }
  end
  return background
end

---Events handling the background behaviour
M.events = function()
  -- Toggle the Zen Mode variable and reloads the config
  wezterm.on('Toggle-Zen-Mode', function()
    wezterm.GLOBAL.zen_mode = not wezterm.GLOBAL.zen_mode
    wezterm.log_info(wezterm.GLOBAL.zen_mode)
    wezterm.reload_configuration()
  end)

  -- Remove the current background image
  wezterm.on('Remove-Wallpaper', function()
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
