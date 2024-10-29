local M = {}

M.theme = 'Gruvbox-Mat'

---Converts a string of a hex number to a string of a decimal number
---@param hex string
---@return string
local htod = function(hex)
  return tostring(tonumber(hex, 16))
end

---Converts a colour in hex format to rgba format
---@param hex string
---@param alpha integer
---@return string
M.hex_to_rgba = function(hex, alpha)
  local r = hex:sub(2, 3)
  local g = hex:sub(4, 5)
  local b = hex:sub(6, 7)
  local rgba = 'rgba(' .. htod(r) .. ', ' .. htod(g) .. ', ' .. htod(b) .. ', ' .. tostring(alpha) .. ')'
  return rgba
end

-- stylua: ignore
M['Mocha'] = {
  ['rosewater']  =  '#f5e0dc',
  ['flamingo']   =  '#f2cdcd',
  ['pink']       =  '#f5c2e7',
  ['mauve']      =  '#cba6f7',
  ['red']        =  '#f38ba8',
  ['maroon']     =  '#eba0ac',
  ['peach']      =  '#fab387',
  ['yellow']     =  '#f9e2af',
  ['green']      =  '#a6e3a1',
  ['teal']       =  '#94e2d5',
  ['sky']        =  '#89dceb',
  ['sapphire']   =  '#74c7ec',
  ['blue']       =  '#89b4fa',
  ['lavender']   =  '#b4befe',
  ['text']       =  '#cdd6f4',
  ['subtext1']   =  '#bac2de',
  ['subtext0']   =  '#a6adc8',
  ['overlay2']   =  '#9399b2',
  ['overlay1']   =  '#7f849c',
  ['overlay0']   =  '#6c7086',
  ['surface2']   =  '#585b70',
  ['surface1']   =  '#45475a',
  ['surface0']   =  '#313244',
  ['base']       =  '#1e1e2e',
  ['mantle']     =  '#181825',
  ['crust']      =  '#11111b',
}

-- stylua: ignore
M['Gruvbox-Mat'] = {
  ['rosewater']  =  '#ffc6be',
  ['flamingo']   =  '#fb4934',
  ['pink']       =  '#ff75a0',
  ['mauve']      =  '#f2594b',
  ['red']        =  '#f2594b',
  ['maroon']     =  '#fe8019',
  ['peach']      =  '#FFAD7D',
  ['yellow']     =  '#e9b143',
  ['green']      =  '#b0b846',
  ['teal']       =  '#8bba7f',
  ['sky']        =  '#7daea3',
  ['sapphire']   =  '#689d6a',
  ['blue']       =  '#80aa9e',
  ['lavender']   =  '#e2cca9',
  ['text']       =  '#e2cca9',
  ['subtext1']   =  '#e2cca9',
  ['subtext0']   =  '#e2cca9',
  ['overlay2']   =  '#8C7A58',
  ['overlay1']   =  '#735F3F',
  ['overlay0']   =  '#806234',
  ['surface2']   =  '#665c54',
  ['surface1']   =  '#3c3836',
  ['surface0']   =  '#32302f',
  ['base']       =  '#282828',
  ['mantle']     =  '#1d2021',
  ['crust']      =  '#1b1b1b',
}

M.current_colours = M[M.theme]

return M
