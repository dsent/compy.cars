-- teacher.lua
-- Hidden teacher controls for the prediction rounds.
-- M toggles milestone line 5; P sets a pause time.
-- Neither leaves a permanent mark on the child's screen.

P_INPUT = {
  active = false,
  digits = "",
}

function teacherKey(k)
  if k == "m" then
    simToggleMilestone()
  elseif k == "p" then
    startPauseEntry()
  end
end

-- P with a pause point set clears it; P without one
-- opens the digit entry.

function startPauseEntry()
  if SIM_STATE.pause_target then
    SIM_STATE.pause_target = nil
    SIM_STATE.pause_fired = false
    return
  end
  P_INPUT.active = true
  P_INPUT.digits = ""
end

function pauseEntryKey(k)
  if k:match("^%d$") then
    addPauseDigit(k)
  elseif k == "backspace" then
    P_INPUT.digits = P_INPUT.digits:sub(1, -2)
  elseif k == "return" then
    confirmPauseEntry()
  elseif k == "p" then
    P_INPUT.active = false
  end
end

function addPauseDigit(k)
  if #P_INPUT.digits < 2 then
    P_INPUT.digits = P_INPUT.digits .. k
  end
end

-- Enter with no digits just closes the entry

function confirmPauseEntry()
  local t = tonumber(P_INPUT.digits)
  P_INPUT.active = false
  local usable = t and t > 0
  if usable then
    SIM_STATE.pause_target = t
    SIM_STATE.pause_fired = false
  end
end
