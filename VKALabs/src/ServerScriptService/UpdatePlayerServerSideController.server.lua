-- Services
local DataStoreService = game:GetService("DataStoreService")

-- Data Store
local FinishedTutorialDataStore = DataStoreService:GetDataStore("FinishedTutorialDataStore1")

-----------------
-- Connections --
-----------------

-- Connection to Remove tool from a Players Backpack
game.ReplicatedStorage.RemoveToolFromPlayerServerSide.OnServerEvent:Connect(function(player, toolToRemove)
	
	-- Get All Tools in Backpack and In Hand..
	local playerTools = player.Backpack:GetChildren()

	-- Add Tool in Hand as well
	for _, v in pairs(player.Character:GetChildren()) do

		-- If its a tool
		if v:IsA("Tool") then

			-- Add it to the player tools
			table.insert(playerTools, v)
		end
	end
	
	-- Remove It
	for _, tool in pairs(playerTools) do
		
		-- If this is the tool, delete it..
		if tool == toolToRemove then
			
			-- Remove it
			tool:Destroy()
		end
	end
	
	-- Nil Stuff
	playerTools = nil
	
end)

-- connection to Add tool to Player Server Sude..
game.ReplicatedStorage.AddToolToPlayerServerSide.OnServerEvent:Connect(function(player, toolStringToAdd, stringHandOrBackpack)
	
	-- Reset tool in Backpack
	local playerHasTool = false
	
	----------------------
	-- Get Player Tools --
	----------------------

	local playerTools = player.Backpack:GetChildren()

	-- Add Tool in Hand as well
	for _, v in pairs(player.Character:GetChildren()) do

		-- If its a tool
		if v:IsA("Tool") then

			-- Add it to the player tools
			table.insert(playerTools, v)
		end
	end
	
	-------------------------------------------
	-- Look for this Tool in Players Tools.. --
	-------------------------------------------

	-- Loop through Backpack --
	for _, tool in pairs(playerTools) do

		-- If we find this tool, dont attack --
		if tool.Name == toolStringToAdd then

			-- fonud Tool --
			playerHasTool = true

			-- Break
			break
		end
	end

	-- If Tool was not found, clone a new one.. --
	if playerHasTool == false then
		
		-- Choose Which tool to add..
		if toolStringToAdd == "CrossbowExplosive" then

			-- Give player crossbow if he doesnt already have it..
			local clone =  game.ServerStorage.Tools.CrossbowExplosive:Clone()
			
			-- check for Hand or Backpack..
			if stringHandOrBackpack == "Hand" then
				
				-- Add Tool to Player character
				clone.Parent = player.Character			
			else
				
				-- Add to Backpack
				clone.Parent = player:WaitForChild("Backpack")
			end
			
			-- Nil Stuff
			clone = nil

		end
	end
end)

-- Connection to Update Players Health Server Side..
game.ReplicatedStorage.AddHealthToPlayer.OnServerEvent:Connect(function(player, health)

	-- Get PLayer Character and Humanoid
	if not player.Character then player.CharacterAdded:Wait() end
	local thisHumanoid = player.Character:WaitForChild("Humanoid")

	-- Give this Player Health
	thisHumanoid.Health += health
	
	-- Add to Coffees drank... assuming this event is only called when coffee is drank...
	player.coffeesdrank.Value += 1
	
end)

-- connection to update weapon levels
game.ReplicatedStorage.UpdateWeaponLevelsServerSide.OnServerEvent:Connect(function(player, leveldescription)
	
	-- if
	if leveldescription == "plasmagundamagelevel" then
		
		-- Update it
		player.weaponlevels.plasmagundamagelevel.Value += 1
		
	elseif leveldescription == "plasmagunradiuslevel" then
		
		-- Update it
		player.weaponlevels.plasmagunradiuslevel.Value += 1
		
	elseif leveldescription == "nailgundamagelevel" then
		
		-- Update it
		player.weaponlevels.nailgundamagelevel.Value += 1
		
	elseif leveldescription == "crossbowexplosivedamagelevel" then
		
		player.weaponlevels.crossbowexplosivedamagelevel.Value += 1
		
	elseif leveldescription == "crossbowexplosiveradiuslevel" then
		
		player.weaponlevels.crossbowexplosiveradiuslevel.Value += 1

	elseif leveldescription == "vialgundamagelevel" then
		
		player.weaponlevels.vialgundamagelevel.Value += 1

	elseif leveldescription == "vialgunradiuslevel" then
		
		player.weaponlevels.vialgunradiuslevel.Value += 1

	elseif leveldescription == "bbgundamagelevel" then
		
		player.weaponlevels.bbgundamagelevel.Value += 1

	elseif leveldescription == "bbgunspecialupgrade" then
		
		player.weaponlevels.bbgunspecialupgrade.Value = true
		
	elseif leveldescription == "nailgunspecialupgrade" then
		
		player.weaponlevels.nailgunspecialupgrade.Value = true
	elseif leveldescription == "flamethrowerdamagelevel" then
		
		player.weaponlevels.flamethrowerdamagelevel.Value += 1
	elseif leveldescription == "airblasterdamagelevel" then
		
		player.weaponlevels.airblasterdamagelevel.Value += 1
	elseif leveldescription == "airblasterpowerlevel" then
		
		player.weaponlevels.airblasterpowerlevel.Value += 1
	elseif leveldescription == "shotgundamagelevel" then

		player.weaponlevels.shotgundamagelevel.Value += 1
	end
	
end)

-- Add a Life to Player Server Side..
game.ReplicatedStorage.AddLifeToPlayerServerSide.OnServerEvent:Connect(function(player)
	
	-- Add a Life..
	player.lives.Value += 1	
	
end)

-- Update Tutorial Status
game.ReplicatedStorage.UpdateTutorialStatusServerSide.OnServerEvent:Connect(function(player)
	
	-- Make it True..
	player.finishedtutorial.Value = true
	
	--[[
	
	-- Save to Database..
	local data = nil

	-- Add these kills to Current Kills.
	local success, errorMessage = pcall(function()

		-- Save the data --
		data = FinishedTutorialDataStore:SetAsync(player.UserId, tostring(true))

	end)

	-- If not successful
	if not success then

		-- Wait
		task.wait(1)

		-- Try Again
		local success2, errorMessage2 = pcall(function()

			-- Save the data --
			data = FinishedTutorialDataStore:SetAsync(player.UserId, tostring(true))

		end)
	end
	]]
	
end)

-- Update Tutorial Status
game.ReplicatedStorage.UpdateGotBloodObjectiveServerSide.OnServerEvent:Connect(function(player)

	-- Make it True..
	player.gotbloodobjective.Value = true
	
end)

-- Update Tutorial Status
game.ReplicatedStorage.UpdateCompletedBloodObjectiveServerSide.OnServerEvent:Connect(function(player)

	-- Make it True..
	player.completedbloodobjective.Value = true

end)