-- Get Light -- 
local thisLight = script.Parent:WaitForChild("SurfaceLight")
local lightPart = script.Parent

-- Sound --
local flickerSound = script.Parent:WaitForChild("Flicker")

----------
-- Init --
----------

-- Light Off
thisLight.Enabled = false

-- BrightNess
thisLight.Brightness = 1

-- Dim Light Part
lightPart.Color = Color3.fromRGB(66,66,66)

-- Transparency
lightPart.Transparency = 0


---------------
-- Functions --
---------------

local function FlickerLight()
	
	-- Turn light on --
	thisLight.Enabled = true
	
	-- Change Color of Brick to Black --
	lightPart.BrickColor = BrickColor.new("Medium stone grey")
	
	-- TrueFalse Array
	local trueOrFalse = {true, false}
	
	-- Play Sound --
	if not flickerSound.IsPlaying and trueOrFalse[math.random(1,2)] then
		
		-- Random Playback Speed
		flickerSound.PlaybackSpeed = math.random(10, 13) * 0.1
		
		-- Play Sound
		flickerSound:Play()		
	end	
	
	-- Random Flicker Length --		
	local seed = Random.new(tick())
	local flickerLength = seed:NextNumber(0.01, 0.5)
	
	-- Wait flicker Length, then turn light back off --
	task.wait(flickerLength)
	
	-- Turn light off --
	thisLight.Enabled = false

	-- Dim Light Part
	lightPart.Color = Color3.fromRGB(66,66,66)
	
	-- Nil Stuff
	trueOrFalse = nil
	seed = nil
	flickerLength = nil
	
end

---------------
-- Main Loop --
---------------

while task.wait(math.random(1, 200) * 0.01) do
	
	-- Flciker --
	FlickerLight()
	
end