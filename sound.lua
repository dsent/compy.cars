-- sound.lua
-- The instrument is quiet: two sounds only, both soft.
-- Neither is a reward or a scold.

sfx = compy.audio

SOUND = { }

-- The "Go!" tick that synchronizes the stopwatches:
-- a soft dull knock.

function SOUND.go()
  sfx.knock()
end

-- End of run (every car past the last line): a soft
-- chime so the room knows the run is over.

function SOUND.done()
  sfx.correct()
end
