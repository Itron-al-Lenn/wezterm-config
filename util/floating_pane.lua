local wezterm = require 'wezterm' --[[@as Wezterm]]
local act = wezterm.action
local g = wezterm.GLOBAL

local M = {}

M.floating_pane = function(cmd)
  wezterm.log_info('Open floating pan running: ' .. cmd)
  local script = g.script_dir .. 'floating-pane'
  if g.is_windows then
    script = script .. '-win'
  end
  wezterm.run_child_process {
    'wsl',
    'bash',
    script,
    cmd,
  }
end

M.floating_pane_out = function(cmd)
  wezterm.log_info('Open floating pan running: ' .. cmd)
  local script = g.script_dir .. 'floating-pane-out'
  if g.is_windows then
    script = script .. '-win'
  end
  local success, stdout, stderr = wezterm.run_child_process {
    'wsl',
    'bash',
    script,
    cmd,
  }
  if success then
    return stdout
  else
    wezterm.log_error('floating_pane failed: ' .. stderr)
  end
end

M.sessionizer = function()
  return wezterm.action_callback(function(window, pane)
    local stdout = M.floating_pane_out(g.script_dir .. 'wezterm-sessionizer')
    if not stdout then
      wezterm.log_error 'fzf: Failed to get session information'
      return
    end

    local lines = wezterm.split_by_newlines(stdout:gsub(';', '\n'))
    if #lines < 2 then
      wezterm.log_error 'fzf: Invalid session format in output'
      return
    end

    local session_n = lines[1]
    local session_d = lines[2]

    wezterm.log_info('Switch Workspace: Name: ' .. session_n .. ' Dir: ' .. session_d)
    window:perform_action(
      act.SwitchToWorkspace {
        name = session_n,
        spawn = {
          cwd = session_d,
        },
      },
      pane
    )
  end)
end

return M
