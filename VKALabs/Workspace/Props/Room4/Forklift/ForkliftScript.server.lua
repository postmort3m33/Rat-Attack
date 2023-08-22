-- Refs --
local proxPrompt = script.Parent.Body.TankSpot.ProximityPrompt
local batteryProxPrompt = script.Parent.Body.Battery.ProximityPrompt
local propaneTankPart = script.Parent.Body.PropaneTank
local batteryPart = script.Parent.Body.Battery

-- Sounds
local compressedAirSound = script.Parent.Body.TankSpot.CompressedAir

----------
-- Init --
----------
proxPrompt.Enabled = true

-----------------
-- Connections --
-----------------

-- Prox Prompt
proxPrompt.Triggered:Connect(function(player)
	
	-- var --
	local playerHasTank = false
	local playerPropaneTankTool = nil

	-- Loop Through Player Childen that our tools..
	for _, child in pairs(player.Character:GetChildren()) do

		-- If its a tool..--
		if child:IsA("Tool") then

			-- check if its this tool--
			if child.Name == "PropaneTank" then

				-- Found Tool --
				playerHasTank = true
				
				-- Set this Propane Tank
				playerPropaneTankTool = child

				-- break
				break
			end
		end
	end

	-- IF Player had the tank in hand, then place it.. --
	if playerHasTank then
		
		-- Play Air Sound
		compressedAirSound:Play()
		
		-- Take tank from player..
		playerPropaneTankTool:Destroy()
		
		-- Reveal Propane Tank
		propaneTankPart.Transparency = 0
		propaneTankPart.CanCollide = true
		
		-- Turn off Prox Prompt
		proxPrompt.Enabled = false		
		
		-- Objective Complete..
		game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(19)
		
		-- Wait
		task.wait(1)
		
		-- PLay Hacth Sound
		script.Parent.Body.Battery.HatchOpen:Play()
		
		-- Turn on battery highlights
		batteryPart.Highlight.Enabled = true
		
		-- Raise Battery and Turn on Prox Prompt
		local tweenInformation = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
		local tween = game.TweenService:Create(batteryPart, tweenInformation, {["CFrame"] = batteryPart.CFrame:ToWorldSpace(CFrame.new(0, 0.5, 0))})
		tween:Play()
		tween.Completed:Wait()
		
		-- Prox Prompt
		batteryProxPrompt.Enabled = true		
		
	end	
end)

batteryProxPrompt.Triggered:Connect(function(player)
	
	-- clone the gun so every player cam have one --
	local clone =  game.ServerStorage.Tools.EasterEggParts.Battery:Clone()

	-- If Pistol was picked up... add it as child to the player
	clone.Parent = player:WaitForChild("Backpack")

	-- Nil Stuff
	clone = nil
	
	-- Play Pickup Sound
	game.ReplicatedStorage.GunPickupSound:FireClient(player)
	
	-- Destroy 
	batteryPart:Destroy()
	
end)
