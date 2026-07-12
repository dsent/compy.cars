-- constants.lua
-- All tunable values for the car simulation.

-- Countdown and end-of-run timing (seconds)

SIM = {
  countdown_steps = 3,
  countdown_step_time = 1,
  go_time = 0.5,
  safety_timeout = 25,
}

-- Milestones sit at whole position units: line m is m
-- units from the start line. The optional teacher line 5
-- sits 1.25 spacings past line 4.

MILESTONES = 4
EXTRA_MILESTONE_UNITS = 5.25

-- Speeds in position units per second. Milestone times:
-- red 4/8/12/16, blue 2.5/5/7.5/10, green 1.5/3/4.5/6,
-- yellow (accelerating) 6/8.5/10.4/12.

SPEED_SLOW = 1 / 4
SPEED_MED = 1 / 2.5
SPEED_FAST = 1 / 1.5
ACCEL = 1 / 18

CARS = {
  { name = "Red", color = Color.red },
  { name = "Blue", color = Color.blue },
  { name = "Green", color = Color.green },
  { name = "Yellow", color = Color.yellow },
}

-- Milestone crossing pulse: a gentle band of the car's
-- color around the line, fading out

PULSE = {
  duration = 0.5,
  half_width = 20,
  alpha = 0.35,
}

-- Lane background tint: identification, not decoration

TINT_ALPHA = 0.07

-- Layout (pixels)

LABEL_COL_WIDTH = 112
RIGHT_MARGIN = 40
HINT_BAND_H = 30
CAR_RADIUS_MAX = 24

-- Font sizes (pixels)

FONT_LABEL = 18
FONT_SMALL = 16
FONT_TIMER = 26
FONT_COUNTDOWN = 120
