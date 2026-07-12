-- models.lua
-- Car glyphs, drawn nose-first: carX is the front bumper,
-- so a crossing pulse fires the moment the nose touches
-- the line. The silhouette matches the speed profile:
-- slow red is a tractor, medium blue a family sedan, fast
-- green a sports car, accelerating yellow a dragster.

function glyphMetrics(y)
  local lh = LAYOUT.lane_h
  return {
    len = lh * 0.72,
    ground = y + lh * 0.26,
    lh = lh,
  }
end

function drawWheel(x, y, r)
  gfx.setColor(Color[Color.black])
  gfx.circle("fill", x, y, r)
  gfx.setColor(Color[Color.white + Color.bright])
  gfx.circle("fill", x, y, r * 0.4)
end

function drawCarGlyph(i, x, y)
  local m = glyphMetrics(y)
  gfx.setColor(Color[CARS[i].color])
  if i == 1 then
    drawTractor(x, m)
  elseif i == 2 then
    drawSedan(x, m)
  elseif i == 3 then
    drawSports(x, m)
  else
    drawDragster(x, m)
  end
end

-- Tractor: tall cab at the rear, low hood, chimney, one
-- big and one small wheel.

function drawTractor(x, m)
  local L = m.len
  local g = m.ground
  local lh = m.lh
  gfx.rectangle("fill", x - 0.42 * L, g - 0.24 * lh,
    0.40 * L, 0.18 * lh)
  gfx.rectangle("fill", x - 0.68 * L, g - 0.48 * lh,
    0.30 * L, 0.30 * lh)
  gfx.rectangle("fill", x - 0.34 * L, g - 0.36 * lh,
    0.05 * L, 0.12 * lh)
  drawTractorGlass(x, m)
  drawWheel(x - 0.54 * L, g - 0.17 * lh, 0.17 * lh)
  drawWheel(x - 0.14 * L, g - 0.10 * lh, 0.10 * lh)
end

function drawTractorGlass(x, m)
  local L = m.len
  local g = m.ground
  local lh = m.lh
  gfx.setColor(Color[Color.white + Color.bright])
  gfx.rectangle("fill", x - 0.62 * L, g - 0.44 * lh,
    0.14 * L, 0.12 * lh)
end

-- Family sedan: one long body, a roomy cabin, two equal
-- wheels.

function drawSedan(x, m)
  local L = m.len
  local g = m.ground
  local lh = m.lh
  gfx.rectangle("fill", x - 0.94 * L, g - 0.22 * lh,
    0.94 * L, 0.15 * lh)
  gfx.polygon("fill",
    x - 0.74 * L, g - 0.22 * lh,
    x - 0.64 * L, g - 0.38 * lh,
    x - 0.34 * L, g - 0.38 * lh,
    x - 0.26 * L, g - 0.22 * lh)
  drawSedanGlass(x, m)
  drawWheel(x - 0.70 * L, g - 0.10 * lh, 0.10 * lh)
  drawWheel(x - 0.22 * L, g - 0.10 * lh, 0.10 * lh)
end

function drawSedanGlass(x, m)
  local L = m.len
  local g = m.ground
  local lh = m.lh
  gfx.setColor(Color[Color.white + Color.bright])
  gfx.polygon("fill",
    x - 0.70 * L, g - 0.24 * lh,
    x - 0.62 * L, g - 0.35 * lh,
    x - 0.37 * L, g - 0.35 * lh,
    x - 0.31 * L, g - 0.24 * lh)
end

-- Sports car: a low wedge with a tapered nose, a flat
-- cabin, and a rear wing.

function drawSports(x, m)
  drawSportsBody(x, m)
  drawSportsTop(x, m)
  local L = m.len
  local g = m.ground
  local lh = m.lh
  drawWheel(x - 0.78 * L, g - 0.09 * lh, 0.09 * lh)
  drawWheel(x - 0.18 * L, g - 0.09 * lh, 0.09 * lh)
end

function drawSportsBody(x, m)
  local L = m.len
  local g = m.ground
  local lh = m.lh
  gfx.polygon("fill",
    x - 0.98 * L, g - 0.18 * lh,
    x - 0.30 * L, g - 0.18 * lh,
    x, g - 0.10 * lh,
    x, g - 0.06 * lh,
    x - 0.98 * L, g - 0.06 * lh)
  gfx.rectangle("fill", x - 0.97 * L, g - 0.28 * lh,
    0.04 * L, 0.10 * lh)
  gfx.rectangle("fill", x - 1.02 * L, g - 0.32 * lh,
    0.14 * L, 0.05 * lh)
end

function drawSportsTop(x, m)
  local L = m.len
  local g = m.ground
  local lh = m.lh
  gfx.polygon("fill",
    x - 0.80 * L, g - 0.18 * lh,
    x - 0.68 * L, g - 0.32 * lh,
    x - 0.42 * L, g - 0.32 * lh,
    x - 0.30 * L, g - 0.18 * lh)
  gfx.setColor(Color[Color.white + Color.bright])
  gfx.polygon("fill",
    x - 0.64 * L, g - 0.20 * lh,
    x - 0.56 * L, g - 0.29 * lh,
    x - 0.44 * L, g - 0.29 * lh,
    x - 0.38 * L, g - 0.20 * lh)
end

-- Dragster: a long thin arrow of a body, a huge rear
-- wheel, a tiny front wheel, a wing over the back.

function drawDragster(x, m)
  drawDragsterBody(x, m)
  drawDragsterWing(x, m)
  local L = m.len
  local g = m.ground
  local lh = m.lh
  drawWheel(x - 0.80 * L, g - 0.16 * lh, 0.16 * lh)
  drawWheel(x - 0.08 * L, g - 0.06 * lh, 0.06 * lh)
end

function drawDragsterBody(x, m)
  local L = m.len
  local g = m.ground
  local lh = m.lh
  gfx.polygon("fill",
    x - 0.92 * L, g - 0.22 * lh,
    x - 0.50 * L, g - 0.14 * lh,
    x, g - 0.08 * lh,
    x, g - 0.03 * lh,
    x - 0.92 * L, g - 0.03 * lh)
  gfx.rectangle("fill", x - 0.62 * L, g - 0.28 * lh,
    0.12 * L, 0.14 * lh)
end

-- The high wing over the rear axle is what makes the
-- silhouette read "dragster" at a glance.

function drawDragsterWing(x, m)
  local L = m.len
  local g = m.ground
  local lh = m.lh
  gfx.rectangle("fill", x - 0.81 * L, g - 0.40 * lh,
    0.04 * L, 0.18 * lh)
  gfx.rectangle("fill", x - 0.94 * L, g - 0.45 * lh,
    0.24 * L, 0.06 * lh)
end
