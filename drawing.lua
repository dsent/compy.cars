-- drawing.lua
-- All rendering for the car simulation. Palette colors
-- only; alpha comes from Color.with_alpha.

FONTS = { }

function initFonts()
  FONTS.label = gfx.newFont(FONT_LABEL)
  FONTS.small = gfx.newFont(FONT_SMALL)
  FONTS.hint = gfx.newFont(FONT_HINT)
  FONTS.timer = gfx.newFont(FONT_TIMER)
  FONTS.dialog = gfx.newFont(FONT_DIALOG)
  FONTS.countdown = gfx.newFont(FONT_COUNTDOWN)
end

COLOR_BG = Color[Color.white + Color.bright]
COLOR_LINE = Color[Color.white]
COLOR_TEXT = Color[Color.black]
COLOR_DIM = Color.with_alpha(Color[Color.black], 0.45)

function carColor(i)
  return Color[CARS[i].color]
end

function drawScene()
  gfx.clear(COLOR_BG)
  drawLaneTints()
  drawMilestones()
  drawPulses()
  drawLaneLabels()
  drawCars()
  drawTimer()
  drawHint()
  drawPauseInfo()
  drawFrozenMarkers()
  drawCountdown()
  drawGoOverlay()
  drawPauseDialog()
end

function drawLaneTints()
  for i = 1, #CARS do
    local tint = Color.with_alpha(carColor(i), TINT_ALPHA)
    gfx.setColor(tint)
    gfx.rectangle("fill", 0, laneTop(i),
      LAYOUT.width, LAYOUT.lane_h)
  end
end

-- The start line is milestone 0: the origin the children
-- plot from. Lines are thin and light so the cars keep
-- the attention.

function drawMilestones()
  for m = 0, milestoneCount() do
    drawOneMilestone(m)
  end
end

function drawOneMilestone(m)
  local x = milestoneX(m)
  gfx.setColor(COLOR_LINE)
  gfx.setLineWidth(2)
  gfx.line(x, LAYOUT.header_h, x, trackBottom())
  gfx.setLineWidth(1)
  gfx.setFont(FONTS.small)
  gfx.setColor(COLOR_DIM)
  local label = tostring(m)
  local tw = FONTS.small:getWidth(label)
  gfx.print(label, x - tw - 4, LAYOUT.header_h + 2)
end

function drawPulses()
  for i = 1, #CARS do
    for m, left in pairs(CAR_STATE[i].pulses) do
      drawOnePulse(i, m, left / PULSE.duration)
    end
  end
end

function drawOnePulse(i, m, strength)
  local x = milestoneX(m)
  local band = Color.with_alpha(carColor(i),
    strength * PULSE.alpha)
  gfx.setColor(band)
  gfx.rectangle("fill", x - PULSE.half_width, laneTop(i),
    PULSE.half_width * 2, LAYOUT.lane_h)
end

-- Color-name labels: the text fallback for children who
-- are color-uncertain. Top-left of each lane, clear of
-- the car glyphs driving along the lane center.

function drawLaneLabels()
  gfx.setFont(FONTS.label)
  for i = 1, #CARS do
    gfx.setColor(carColor(i))
    gfx.print(CARS[i].name, 12, laneTop(i) + 6)
  end
end

function drawCars()
  local t = SIM_STATE.elapsed
  for i = 1, #CARS do
    drawCarGlyph(i, carX(i, t), laneY(i))
  end
end

function drawTimer()
  gfx.setFont(FONTS.timer)
  gfx.setColor(COLOR_TEXT)
  local text = string.format("%.1f", SIM_STATE.elapsed)
  local tw = FONTS.timer:getWidth(text)
  gfx.print(text, LAYOUT.width - tw - 12, 2)
end

HINTS = {
  idle = "Space: start",
  countdown = "R: reset",
  running = "Space: pause    R: reset",
  paused = "Space: continue    R: reset",
  done = "R: reset",
}

-- The hint sits on a light pill so it reads at a glance
-- (black text carries the contrast, the pill the eye).

function drawHint()
  gfx.setFont(FONTS.hint)
  local text = HINTS[SIM_STATE.phase]
  local tw = FONTS.hint:getWidth(text)
  local th = FONTS.hint:getHeight()
  local x = (LAYOUT.width - tw) / 2
  local y = LAYOUT.height - HINT_BAND_H
    + (HINT_BAND_H - th) / 2
  gfx.setColor(Color.with_alpha(Color[Color.white], 0.55))
  gfx.rectangle("fill", x - 14, y - 4, tw + 28, th + 8, 8)
  gfx.setColor(COLOR_TEXT)
  gfx.print(text, x, y)
end

-- Teacher-only reminder of a set pause time, while idle.
-- Gone once the run starts.

function pauseInfoText()
  local target = SIM_STATE.pause_target
  local idle = SIM_STATE.phase == "idle"
  local show = target and idle
  if show then
    return string.format("Pause at %ds", target)
  end
  return nil
end

function drawPauseInfo()
  local text = pauseInfoText()
  if not text then
    return
  end
  gfx.setFont(FONTS.label)
  gfx.setColor(Color.with_alpha(Color[Color.black], 0.6))
  local tw = FONTS.label:getWidth(text)
  gfx.print(text, LAYOUT.width - tw - 110, 6)
end

-- Modal pause-time entry: a dimmed field and a centered
-- dialog. The run underneath is frozen while it is open
-- (main gates the update) and resumes when it closes.

function drawPauseDialog()
  if not P_INPUT.active then
    return
  end
  gfx.setColor(Color.with_alpha(Color[Color.black], 0.25))
  gfx.rectangle("fill", 0, 0, LAYOUT.width, LAYOUT.height)
  drawDialogBox()
end

function drawDialogBox()
  local w = 520
  local h = 150
  local x = (LAYOUT.width - w) / 2
  local y = (LAYOUT.height - h) / 2
  gfx.setColor(COLOR_BG)
  gfx.rectangle("fill", x, y, w, h, 12)
  gfx.setColor(COLOR_TEXT)
  gfx.setLineWidth(3)
  gfx.rectangle("line", x, y, w, h, 12)
  gfx.setLineWidth(1)
  drawDialogText(y, h)
end

function drawDialogText(y, h)
  gfx.setFont(FONTS.dialog)
  gfx.setColor(COLOR_TEXT)
  local text = "Pause at: " .. P_INPUT.digits .. "_ s"
  local tw = FONTS.dialog:getWidth(text)
  gfx.print(text, (LAYOUT.width - tw) / 2, y + 22)
  gfx.setFont(FONTS.hint)
  gfx.setColor(Color.with_alpha(Color[Color.black], 0.6))
  local hint = "Enter: set    P: cancel"
  local hw = FONTS.hint:getWidth(hint)
  gfx.print(hint, (LAYOUT.width - hw) / 2, y + h - 42)
end

-- While paused, a dashed line in each car's color marks
-- its frozen position across all four lanes, so the
-- children can compare positions to their predictions.

function drawFrozenMarkers()
  if SIM_STATE.phase ~= "paused" then
    return
  end
  local t = SIM_STATE.elapsed
  for i = 1, #CARS do
    gfx.setColor(carColor(i))
    drawDashedVertical(carX(i, t))
  end
end

function drawDashedVertical(x)
  local dash = 8
  local gap = 6
  local y = LAYOUT.header_h
  local bottom = trackBottom()
  gfx.setLineWidth(2)
  while y < bottom do
    local y2 = math.min(y + dash, bottom)
    gfx.line(x, y, x, y2)
    y = y2 + gap
  end
  gfx.setLineWidth(1)
end

function drawCountdown()
  if SIM_STATE.phase ~= "countdown" then
    return
  end
  local n = math.ceil(SIM_STATE.countdown_left)
  if n < 1 then
    n = 1
  end
  drawBigCenter(tostring(n))
end

function drawGoOverlay()
  if not SIM_STATE.go_left then
    return
  end
  drawBigCenter("Go!")
end

function drawBigCenter(text)
  gfx.setFont(FONTS.countdown)
  gfx.setColor(Color.with_alpha(COLOR_TEXT, 0.8))
  local tw = FONTS.countdown:getWidth(text)
  local th = FONTS.countdown:getHeight()
  gfx.print(text, (LAYOUT.width - tw) / 2,
    (LAYOUT.height - th) / 2)
end
