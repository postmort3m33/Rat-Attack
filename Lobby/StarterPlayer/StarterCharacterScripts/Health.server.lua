---------------------------------------
-- Server Needs to Run this Script.. --
---------------------------------------

-- Entity Stuff
local Character = script.Parent
local Humanoid = Character:WaitForChild("Humanoid")


-- Vars
local REGEN_RATE = 3/100 -- Regenerate this fraction of MaxHealth per second.
local REGEN_STEP = 1 -- Wait this long between each regeneration step.

---------------
-- Main Loop --
---------------
while true do
	
	-- While HEalth is less than MaxHealth..
	while Humanoid.Health < Humanoid.MaxHealth do
		
		-- Set Wait Time
		local dt = wait(REGEN_STEP)
		local dh = dt*REGEN_RATE*Humanoid.MaxHealth
		
		-- Apply Proper Health
		Humanoid.Health = math.min(Humanoid.Health + dh, Humanoid.MaxHealth)
	end
	
	-- Dont run again until HEalth has Changed..
	Humanoid.HealthChanged:Wait()
end