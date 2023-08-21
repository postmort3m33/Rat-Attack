-- Parts
local thisPart = script.Parent
local thisEmitter = thisPart.Sparks

-- Sounds
local sparkSound = thisPart.Spark

-- Random Num Ref
local randomNum = 0

-- Init
thisEmitter.Enabled = false

---------------
-- Main Loop --
---------------

while true do
	
	-- Random Number
	randomNum = math.random(2,10)
	
	-- Play Sound.
	sparkSound.PlaybackSpeed = math.random(6,10) * 0.1
	sparkSound:Play()
	
	-- Emit Sparks
	thisEmitter:Emit(randomNum)
	
	-- Wait Random Interval
	task.wait(math.random(5,50) * 0.1)
end