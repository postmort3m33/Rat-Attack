-- Refs --
local proxPrompt = script.Parent.TableTop.ProximityPrompt
local deadRatPart = script.Parent.DeadRat

-- var --
local playerHasDeadRat = false
local playerDeadRatTool = nil

-- Sounds
local dropBodySound = script.Parent.TableTop.DropBody

----------
-- Init --
----------

-- Turn on Prox Prompt
proxPrompt.Enabled = true

-----------------
-- Connections --
-----------------

-- Prox Prompt
proxPrompt.Triggered:Connect(function(player)

	-- Reset tool in Backpack
	playerHasDeadRat = false

	-- Loop Through Player Childen that our tools..
	for _, child in pairs(player.Character:GetChildren()) do

		-- If its a tool..--
		if child:IsA("Tool") then

			-- check if its this tool--
			if child.Name == "RatDead" then

				-- Found Tool --
				playerHasDeadRat = true

				-- Set this Propane Tank
				playerDeadRatTool = child

				-- break
				break
			end
		end
	end

	-- IF Player had the deadRat in hand, then place it.. --
	if playerHasDeadRat then

		-- Take tank from player..
		playerDeadRatTool:Destroy()
		
		-- Drop Body sound
		dropBodySound:Play()
		
		-- Gewt Blood Sample Ready
		game.ReplicatedStorage.EasterEggEvents.GetBloodSampleReady:Fire()

		-- Reveal Propane Tank
		deadRatPart.Transparency = 0
		deadRatPart.CanCollide = true

		-- Turn off Prox Prompt
		proxPrompt.Enabled = false
		
		-- Objective Complete..
		game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(23)
	end
end)
