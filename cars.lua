-- cars.lua
-- Car positions, milestone crossings, crossing pulses.

CAR_STATE = { }

function initCars()
  CAR_STATE = { }
  for i = 1, #CARS do
    CAR_STATE[i] = {
      crossed = { },
      pulses = { },
    }
  end
end

-- Position in milestone units after t seconds of driving.
-- Cars 1-3 move at constant speed; car 4 accelerates
-- uniformly. Position depends only on t, so every run is
-- identical: the children are measuring, and repeated
-- measurements must converge.

function carUnits(i, t)
  if i == 1 then
    return SPEED_SLOW * t
  end
  if i == 2 then
    return SPEED_MED * t
  end
  if i == 3 then
    return SPEED_FAST * t
  end
  return 0.5 * ACCEL * t * t
end

-- Drawn position: a car parks at the finish line of the
-- current heat as it arrives, so no car ever drives off
-- the screen while slower cars are still racing.

function carPos(i, t)
  return math.min(carUnits(i, t), SIM_STATE.finish_units)
end

function carX(i, t)
  return LAYOUT.start_x + carPos(i, t) * LAYOUT.unit_px
end

function milestoneCount()
  if SIM_STATE.extra_milestone then
    return MILESTONES + 1
  end
  return MILESTONES
end

function updateCrossings(prev_t, cur_t)
  for i = 1, #CARS do
    local prev_u = carPos(i, prev_t)
    local cur_u = carPos(i, cur_t)
    checkCarCrossings(i, prev_u, cur_u)
  end
end

function checkCarCrossings(i, prev_u, cur_u)
  local cs = CAR_STATE[i]
  for m = 1, milestoneCount() do
    local mu = milestoneUnits(m)
    local hit = prev_u < mu and mu <= cur_u
    local fresh_hit = hit and not cs.crossed[m]
    if fresh_hit then
      cs.crossed[m] = true
      cs.pulses[m] = PULSE.duration
    end
  end
end

function updatePulses(dt)
  for i = 1, #CARS do
    local ps = CAR_STATE[i].pulses
    for m, remaining in pairs(ps) do
      ps[m] = remaining - dt
      if ps[m] <= 0 then
        ps[m] = nil
      end
    end
  end
end

function allCarsDone(t)
  local last = SIM_STATE.finish_units
  for i = 1, #CARS do
    if carPos(i, t) < last then
      return false
    end
  end
  return true
end
