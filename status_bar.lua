local wezterm = require 'wezterm'
local schedule = require 'schedule'
local c = require 'colours'

local M = {}

local basename = function(s)
  return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

---Returns table with the lines for a component of the status bar
---@param window Window WezTerm Object
---@param pane Pane WezTerm Object
---@param component string Name of the component
---@param colour table Colour of the component
---@param default_colour string Default colour if no colour was specified
---@return table
local define_component = function(window, pane, component, colour, default_colour)
  local stats = {
    ['Workspace'] = window:active_workspace() or '',
    ['Key_Table'] = window:active_key_table(),
    ['LDR'] = 'LDR',
  }
  local stat = 'Workspace'
  local stat_c = 1
  if window:active_key_table() then
    stat = 'Key_Table'
    stat_c = 2
  end
  if window:leader_is_active() then
    stat = 'LDR'
    stat_c = 3
  end

  if component == 'Stat' then
    colour[1] = colour[stat_c]
  end

  -- Extract command name
  local cmd = basename(pane:get_foreground_process_name() or '')

  -- Battery status
  local battery = wezterm.battery_info()[1]
  local charge_percent = math.floor(battery.state_of_charge * 100)
  local battery_symbols = {
    ['Charging'] = {
      [10] = '󰢜 ',
      [20] = '󰂆 ',
      [30] = '󰂇 ',
      [40] = '󰂈 ',
      [50] = '󰢝 ',
      [60] = '󰂉 ',
      [70] = '󰢞 ',
      [80] = '󰂊 ',
      [90] = '󰂋 ',
      [100] = '󰂅 ',
    },
    ['Discharging'] = {
      [10] = '󰁺 ',
      [20] = '󰁻 ',
      [30] = '󰁼 ',
      [40] = '󰁽 ',
      [50] = '󰁾 ',
      [60] = '󰁿 ',
      [70] = '󰂀 ',
      [80] = '󰂁 ',
      [90] = '󰂂 ',
      [100] = '󰁹 ',
    },
  }
  local battery_icon = '󰂃 '
  if battery_symbols[battery.state] ~= nil then
    battery_icon = battery_symbols[battery.state][math.floor(charge_percent / 10) * 10]
  elseif battery.state == 'Full' then
    battery_icon = battery_symbols['Charging'][100]
  end
  local battery_status_time = ''

  if battery.time_to_empty ~= nil then
    battery_status_time = ' ' .. tostring(math.floor(battery.time_to_empty / 60)) .. ' min'
  elseif battery.time_to_full ~= nil then
    battery_status_time = ' ' .. tostring(math.floor(battery.time_to_full / 60)) .. ' min'
  end

  -- Current time
  local time = wezterm.strftime '%H:%M'

  -- Schedule
  local day, hour, minute = wezterm.strftime '%a', tonumber(wezterm.strftime '%H'), tonumber(wezterm.strftime '%M')
  local current, next_lecture = { name = '', room = '' }, { name = '', room = '', start = '' }

  -- Find current and next lectures
  if schedule.schedule[day] then
    for i, lecture in ipairs(schedule.schedule[day]) do
      if schedule.is_current(hour, minute, lecture) then
        current.name, current.room = lecture.name .. ' ' .. lecture.vu, lecture.location
        local next_lecture_info = schedule.schedule[day][i + 1]
        if next_lecture_info then
          next_lecture.name = next_lecture_info.name .. ' ' .. next_lecture_info.vu
          next_lecture.room = next_lecture_info.location
          next_lecture.start = next_lecture_info.start[1] .. ':' .. next_lecture_info.start[2]
        end
        break
      end
    end
  end

  local components = {
    ['Clock'] = time,
    ['Stat'] = wezterm.nerdfonts.oct_table .. '  ' .. stats[stat],
    ['CMD'] = wezterm.nerdfonts.fa_code .. '  ' .. cmd,
    ['Battery'] = battery_icon .. charge_percent .. '%' .. battery_status_time,
    ['Schedule'] = { current = '', next_lecture = '' },
  }

  if current.name ~= '' then
    components['Schedule'].current = current.name .. ' in ' .. current.room
  end
  if next_lecture.name ~= '' then
    components['Schedule'].next_lecture = next_lecture.name .. ' in ' .. next_lecture.room .. ' at ' .. next_lecture.start
  end

  if component == 'Schedule' then
    local r_current = {
      { Foreground = { Color = colour[1] or default_colour } },
      { Text = components['Schedule'].current },
      'ResetAttributes',
    }
    local r_next = {
      { Foreground = { Color = colour[2] or default_colour } },
      { Text = components['Schedule'].next_lecture },
      'ResetAttributes',
    }
    if current.name ~= '' and next_lecture.name ~= '' then
      local r = {}
      for _, v in pairs(r_current) do
        table.insert(r, v)
      end
      table.insert(r, { Text = ' | ' })
      for _, v in pairs(r_next) do
        table.insert(r, v)
      end
      return r
    elseif current.name ~= '' then
      return r_current
    elseif next_lecture.name ~= '' then
      return r_next
    else
      return nil
    end
  end

  local r = {
    { Foreground = { Color = colour[1] or default_colour } },
    { Text = components[component] },
    'ResetAttributes',
  }

  return r
end

---Renders the status bar based on the specified elements
---@param r_elements table Table of the elements on the right side their colour
---@param l_elements table Table of the elements on the left side an their colour
---@param theme string Used theme
M.status_bar = function(r_elements, l_elements, theme)
  theme = theme or 'Mocha'
  wezterm.on('update-status', function(window, pane)
    -- Define status bar components
    local left_status = { { Text = ' ' } }
    local right_status = {}
    for _, element in ipairs(r_elements) do
      local colour = {}
      for _, colour_name in ipairs(element) do
        table.insert(colour, c[theme][colour_name])
      end
      local component = define_component(window, pane, element[1], colour, c[theme].text)
      if component ~= nil then
        for _, line in ipairs(component) do
          table.insert(left_status, line)
        end
        table.insert(left_status, { Text = ' | ' })
      end
    end

    for _, element in ipairs(l_elements) do
      local colour = {}
      for _, colour_name in ipairs(element) do
        table.insert(colour, c[theme][colour_name])
      end
      local component = define_component(window, pane, element[1], colour, c[theme].text)
      if component ~= nil then
        table.insert(right_status, { Text = ' | ' })
        for _, line in ipairs(component) do
          table.insert(right_status, line)
        end
      end
    end

    -- Set the left and right status bar
    window:set_left_status(wezterm.format(left_status))
    window:set_right_status(wezterm.format(right_status))
  end)
end

return M
