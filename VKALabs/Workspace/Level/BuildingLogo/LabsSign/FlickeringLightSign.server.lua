-- Get Light -- 
local thisSign = script.Parent


-- Time Variables --
local flickerLength = 0.1 -- in seconds

---------------
-- Functions --
---------------

local function FlickerLight()
	
	-- Change Color of Brick to Black --
	thisSign.Color = Color3.fromRGB(100,100,100)
	
	-- Random Flicker Length --		
	local seed = Random.new(time())
	flickerLength = seed:NextNumber(0.01, 0.5)
	
	-- Wait flicker Length, then turn light back on --
	task.wait(flickerLength)

	-- Change Color of Brick to Black --
	thisSign.Color = Color3.fromRGB(190,190,190)
	
	-- Nil
	seed = nil
	
end

---------------
-- Main Loop --
---------------

while task.wait(math.random(1,200) * 0.01) do
	
	-- Flciker --
	FlickerLight()
	
end
