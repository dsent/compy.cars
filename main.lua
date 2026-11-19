-- main.lua
-- cars: a reproducible four-lane car simulation.
-- Children time each car with physical stopwatches as it
-- crosses milestone lines, then graph the data on paper.
-- Start with: run "cars"

gfx = love.graphics

dofile("constants.lua")
dofile("sound.lua")
dofile("layout.lua")
dofile("cars.lua")
dofile("sim.lua")
dofile("teacher.lua")
dofile("models.lua")
dofile("drawing.lua")

initLayout()
initFonts()
initCars()

-- Cars uses no mouse: relative mode keeps the system
-- pointer out of the picture.

love.mouse.setRelativeMode(true)

-- Cap dt so a slow frame never fast-forwards the run

MAX_DT = 0.1

-- The pause-time dialog is modal: whatever runs beneath
-- it freezes while it is open and resumes when it closes.

function love.update(dt)
  if dt > MAX_DT then
    dt = MAX_DT
  end
  if P_INPUT.active then
    return
  end
  simUpdate(dt)
end

function love.draw()
  drawScene()
end

-- Reset also abandons a half-typed pause entry

function doReset()
  simReset()
  P_INPUT.active = false
end

function ctrlDown()
  local down = love.keyboard.isDown
  return down("lctrl") or down("rctrl")
end

function altDown()
  local down = love.keyboard.isDown
  return down("lalt") or down("ralt")
end

-- Bare Esc empties the pause-time field, closes it when empty,
-- or leaves the program.

function goBack()
  if not P_INPUT.active then
    stop()
  elseif P_INPUT.digits ~= "" then
    P_INPUT.digits = ""
  else
    P_INPUT.active = false
  end
end

compy.input.shortcuts.keypressed.escape = compy.input.fn.
    stop_here(compy.input.fn.ignore_repeat(goBack))

-- Ctrl+Alt chords are reserved across Compy games and must
-- never land as in-game input.

function love.keypressed(k)
  if k == "escape" then
    return
  end
  local chorded = ctrlDown() or altDown()
  if chorded then
    return
  end
  if P_INPUT.active then
    pauseEntryKey(k)
    return
  end
  gameKey(k)
end

function gameKey(k)
  if k == "space" then
    simToggleRun()
  elseif k == "r" then
    doReset()
  else
    teacherKey(k)
  end
end
