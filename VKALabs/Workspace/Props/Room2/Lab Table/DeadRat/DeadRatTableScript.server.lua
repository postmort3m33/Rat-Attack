-- Vars --
local thisObject = script.Parent
local thisProx = thisObject.ProximityPrompt

-- Vars
local playersHasVialEmpty = false
local playerVialEmptyTool = nil

-- Sounds
local syringeSound = script.Parent.Syringe

-- Connections --
local getBloodSampleReadyConnection = nil

-- Debounce
local aPlayerGotTheVial = false

-----------------
-- Connections --
-----------------

-- Prox Prompt
thisProx.Triggered:Connect(function(player)
	
	-- Reset tool in Backpack
	playersHasVialEmpty = false

	-- Loop Through Player Childen that our tools..
	for _, child in pairs(player.Character:GetChildren()) do

		-- If its a tool..--
		if child:IsA("Tool") then

			-- check if its this tool--
			if child.Name == "VialEmpty" then

				-- Found Tool --
				playersHasVialEmpty = true

				-- Set this Propane Tank
				playerVialEmptyTool = child

				-- break
				break
			end
		end
	end

	-- If Player had the tank in hand, then place it.. --
	if playersHasVialEmpty and aPlayerGotTheVial == false then
		
		-- A Player Got the vial
		aPlayerGotTheVial = true

		-- Take tank from player..
		playerVialEmptyTool:Destroy()
		
		-- Play Sound
		syringeSound:Play()

		-- Put Vial with Blood in Players Backpack
		local clone = game.ServerStorage.Tools.EasterEggParts.VialWithAlbinoBlood:Clone()
		
		-- Put in Players Backpack
		clone.Parent = player:WaitForChild("Backpack")
		
		-- Nil Stuff
		clone = nil
		
		-- Objective Complete..
		game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(24)
		
		-- Destroy
		thisProx.Enabled = false
			
	end	
end)

-- Get Blood Sample Ready
getBloodSampleReadyConnection = game.ReplicatedStorage.EasterEggEvents.GetBloodSampleReady.Event:Connect(function()
	
	-- Prox Prompt Ready
	thisProx.Enabled = true
	
	-- Nil Stuff
	getBloodSampleReadyConnection:Disconnect()
	getBloodSampleReadyConnection = nil
end)