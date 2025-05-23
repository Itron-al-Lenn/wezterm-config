local function is_current(hour, minute, lecture)
  local after_start = (hour >= lecture.start[1] and not (hour == lecture.start[1] and minute < lecture.start[2]))
  local before_fin = (hour <= lecture.fin[1] and not (hour == lecture.fin[1] and minute >= lecture.fin[2]))
  return after_start and before_fin
end

local schedule = {}
schedule = {
  Mon = {
    { start = { 7, 45 }, fin = { 9, 30 }, name = 'AC 1', vu = 'V', location = 'HCI G3' },
    { start = { 9, 45 }, fin = { 11, 30 }, name = 'Physik 3', vu = 'V', location = 'HPH G2' },
    { start = { 11, 45 }, fin = { 13, 30 }, name = 'Alg. Mech.', vu = 'V', location = 'HPH G3' },
  },
  Tue = {
    { start = { 8, 50 }, fin = { 9, 35 }, name = 'PC 2', vu = 'V', location = 'HIL E1' },
    { start = { 10, 15 }, fin = { 12, 00 }, name = 'SPCA', vu = 'V', location = 'HG E7' },
    { start = { 14, 15 }, fin = { 16, 00 }, name = 'CS', vu = 'V', location = 'HG F7' },
    { start = { 16, 15 }, fin = { 18, 00 }, name = 'MMP 1', vu = 'U', location = 'ML F38' },
  },
  Wed = {
    { start = { 9, 15 }, fin = { 10, 00 }, name = 'MMP 1', vu = 'V', location = 'NO C60' },
    { start = { 10, 15 }, fin = { 12, 00 }, name = 'SPCA', vu = 'V', location = 'ETA F5' },
    { start = { 12, 15 }, fin = { 14, 00 }, name = 'Alg. Mech.', vu = 'V', location = 'ETA F5' },
    { start = { 16, 15 }, fin = { 18, 00 }, name = 'CS', vu = 'U', location = 'ML H34.3' },
  },
  Thu = {
    { start = { 9, 45 }, fin = { 11, 30 }, name = 'Physik 3', vu = 'U', location = 'HCI F2' },
    { start = { 11, 45 }, fin = { 13, 30 }, name = 'Physik 3', vu = 'V', location = 'HPH G2' },
    { start = { 13, 45 }, fin = { 15, 30 }, name = 'Alg. Mech.', vu = 'U', location = 'HIT J53' },
  },
  Fri = {
    { start = { 9, 45 }, fin = { 11, 30 }, name = 'PC 2', vu = 'V', location = 'HCI G3' },
    { start = { 11, 45 }, fin = { 12, 30 }, name = 'PC 2', vu = 'U', location = 'HCI D2' },
    { start = { 13, 45 }, fin = { 17, 30 }, name = 'PP 1', vu = 'P', location = 'HPP' },
  },
}

return { schedule = schedule, is_current = is_current }
