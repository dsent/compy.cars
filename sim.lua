-- sim.lua
-- Simulation state machine:
-- idle / countdown / running / paused / done.
-- Cars start moving the instant "Go!" appears, so the
-- children's stopwatches and the cars share one zero.

SIM_STATE = {
  phase = "idle",
  elapsed = 0,
  countdown_left = 0,
  go_left = nil,
  extra_milestone = false,
  pause_target = nil,
  pause_fired = false,
}

function simStart()
  SIM_STATE.phase = "countdown"
  SIM_STATE.elapsed = 0
  SIM_STATE.countdown_left =
    SIM.countdown_steps * SIM.countdown_step_time
  SIM_STATE.go_left = nil
  SIM_STATE.pause_fired = false
  initCars()
end

function simReset()
  SIM_STATE.phase = "idle"
  SIM_STATE.elapsed = 0
  SIM_STATE.countdown_left = 0
  SIM_STATE.go_left = nil
  SIM_STATE.pause_fired = false
  initCars()
end

-- Space: start when idle, pause when running, continue
-- when paused. Ignored during the countdown and once the
-- run is done (reset first).

function simToggleRun()
  if SIM_STATE.phase == "idle" then
    simStart()
  elseif SIM_STATE.phase == "running" then
    SIM_STATE.phase = "paused"
  elseif SIM_STATE.phase == "paused" then
    SIM_STATE.phase = "running"
  end
end

function simToggleMilestone()
  SIM_STATE.extra_milestone = not SIM_STATE.extra_milestone
end

function simUpdate(dt)
  if SIM_STATE.phase == "countdown" then
    updateCountdown(dt)
  elseif SIM_STATE.phase == "running" then
    updateRunning(dt)
  end
  updatePulses(dt)
end

function updateCountdown(dt)
  SIM_STATE.countdown_left = SIM_STATE.countdown_left - dt
  if SIM_STATE.countdown_left <= 0 then
    SIM_STATE.phase = "running"
    SIM_STATE.go_left = SIM.go_time
    SOUND.go()
  end
end

-- The "Go!" overlay lingers briefly over the moving cars

function updateGoOverlay(dt)
  if not SIM_STATE.go_left then
    return
  end
  SIM_STATE.go_left = SIM_STATE.go_left - dt
  if SIM_STATE.go_left <= 0 then
    SIM_STATE.go_left = nil
  end
end

function updateRunning(dt)
  updateGoOverlay(dt)
  local prev_t = SIM_STATE.elapsed
  SIM_STATE.elapsed = prev_t + dt
  clampToPauseTarget()
  updateCrossings(prev_t, SIM_STATE.elapsed)
  checkFinish()
end

-- The teacher's pause point fires once per run; the
-- clamp lands the freeze exactly on the target time.

function clampToPauseTarget()
  local target = SIM_STATE.pause_target
  if not target then
    return
  end
  if SIM_STATE.pause_fired then
    return
  end
  if SIM_STATE.elapsed >= target then
    SIM_STATE.elapsed = target
    SIM_STATE.phase = "paused"
    SIM_STATE.pause_fired = true
  end
end

function checkFinish()
  if SIM_STATE.phase ~= "running" then
    return
  end
  local finished = allCarsDone(SIM_STATE.elapsed)
  local timed_out = SIM_STATE.elapsed >= SIM.safety_timeout
  local over = finished or timed_out
  if over then
    SIM_STATE.phase = "done"
    SOUND.done()
  end
end
