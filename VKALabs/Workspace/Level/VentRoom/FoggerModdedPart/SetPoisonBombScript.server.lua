-- Objects
local thisPart = script.Parent
local thisProx = thisPart.Handle.ProximityPrompt

-- End Game Song..
local bombSetSongSound = script.Parent.RatAttackBombSong

----------
-- Init --
----------

-- Make Bomb Transparent.
for _, child in pairs(thisPart:GetDescendants()) do
	
	-- If a basepart
	if child:IsA("BasePart") then
		
		-- Set
		child.Transparency = 1
		
	elseif child:IsA("Decal") then
		
		-- Set
		child.Transparency = 1
	end
end

-----------------
-- Connections --
-----------------

-- turn off bomb song
game.ReplicatedStorage.MissionEvents.ScientistClearedWarehouseSTS.Event:Connect(function()
	
	-- Coroutine to fade bomb song out..
	local fadeOutCoroutine = coroutine.wrap(function()

		-- If Other song is playing, stop it
		if bombSetSongSound.IsPlaying then

			-- Vars
			local songVolume = bombSetSongSound.Volume

			-- Loop
			while songVolume > 0 do

				-- Volume down..
				songVolume -= 0.01

				-- Apply volume
				bombSetSongSound.Volume = songVolume

				-- Wait()
				task.wait()
			end

			-- Now stop it.
			bombSetSongSound:Stop()

		end

	end)()
end)

-- Prox
thisProx.Triggered:Connect(function(player)
	
	-- Ref
	local playerHasTool = false
	local playerToolObject = nil
	
	-- Get Tool in Player Hand
	for _, child in pairs(player.Character:GetChildren()) do

		-- If its a tool
		if child:IsA("Tool") then

			-- If its the fogger
			if child.Name == "FoggerMachineModded" then
				
				-- Has Tool
				playerHasTool = true
				
				-- Get Object
				playerToolObject = child
			end
		end
	end
	
	-- If we had the proper tool..
	if playerHasTool then
		
		-- Turn off Prox
		thisProx.Enabled = false
		
		-- Destroy Tool in Player hand
		playerToolObject:Destroy()

		-- Show Bomb
		for _, child in pairs(thisPart:GetDescendants()) do

			-- If a basepart
			if child:IsA("BasePart") then

				-- Set
				child.Transparency = 0

			elseif child:IsA("Decal") then

				-- Set
				child.Transparency = 0
			end
		end

		-- Let Server Know
		game.ReplicatedStorage.MissionEvents.BombSetSTS:Fire() -- Recieved from Scientist Script

		-- Objective Complete
		game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(17)
		
		-- Play bomb Song..
		--bombSetSongSound:Play()
	end
	
	-- Nil Stuff
	playerHasTool = nil
	playerToolObject = nil
	
end)