-- Services --
local RunService = game:GetService("RunService")
local DebrisService = game:GetService("Debris")

-- Event Vars --
local cheeseEventFired = false
local cheeseTime = 10
local cheeseAnchored = false

-- Sound Vars --
local thrownSoundPlayed = false

-- Run Heartbeat Loop --
RunService.Heartbeat:Connect(function()
	
	-- Once Cheese stops moving, anchor it..
	if script.Parent.AssemblyLinearVelocity.Magnitude == 0 then
		
		-- Anchor it
		script.Parent.Anchored = true		
	end
	
	-- Tell the server that cheese was thrown --
	if cheeseEventFired == false then

		-- event Fired
		cheeseEventFired = true
		
		-- Play Thrown Sound
		script.Parent.Throw:Play()

		-- Fire it
		game.ReplicatedStorage.CheeseThrown:Fire(script.Parent) -- Pass this cheese object and its position

		-- wait 10 seconds
		wait(cheeseTime)

		-- Tell server this cheese is destroyed
		game.ReplicatedStorage.CheeseDestroyed:Fire(script.Parent)

		-- Make Cheese invisible
		script.Parent.Transparency = 1

		-- Turn off eating Sound
		if script.Parent.Eating.IsPlaying then
			script.Parent.Eating:Stop()
		end

		-- Destroy this Cheese --
		DebrisService:AddItem(script.Parent, 5)

	end	
		
end)