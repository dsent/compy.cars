-- layout.lua
-- Screen geometry: header, lanes, milestone positions.
-- The unit size is chosen so the teacher's line 5 always
-- fits on screen; toggling it never moves lines 1-4.

LAYOUT = {
  width = 0,
  height = 0,
  header_h = 0,
  start_x = 0,
  unit_px = 0,
  lane_h = 0,
  lane_top = { },
}

function initLayout()
  LAYOUT.width, LAYOUT.height = gfx.getDimensions()
  LAYOUT.header_h = FONT_TIMER + 8
  LAYOUT.start_x = LABEL_COL_WIDTH
  local track = LAYOUT.width - LAYOUT.start_x - RIGHT_MARGIN
  LAYOUT.unit_px = track / EXTRA_MILESTONE_UNITS
  local lanes_h = LAYOUT.height - LAYOUT.header_h
    - HINT_BAND_H
  LAYOUT.lane_h = lanes_h / #CARS
  initLaneTops()
end

function initLaneTops()
  LAYOUT.lane_top = { }
  for i = 1, #CARS do
    LAYOUT.lane_top[i] = LAYOUT.header_h
      + (i - 1) * LAYOUT.lane_h
  end
end

function laneTop(i)
  return LAYOUT.lane_top[i]
end

function laneBottom(i)
  return LAYOUT.lane_top[i] + LAYOUT.lane_h
end

function laneY(i)
  return LAYOUT.lane_top[i] + LAYOUT.lane_h / 2
end

function trackBottom()
  return laneBottom(#CARS)
end

function milestoneUnits(m)
  if m > MILESTONES then
    return EXTRA_MILESTONE_UNITS
  end
  return m
end

function milestoneX(m)
  return LAYOUT.start_x + milestoneUnits(m) * LAYOUT.unit_px
end
