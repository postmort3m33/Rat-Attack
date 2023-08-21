-- Vars
local playerTimeArray = {}
local minThrowInterval = 0.5

------------
-- Events --
------------

game.ReplicatedStorage.ThrowableThrown.OnServerEvent:Connect(function(player, throwableName, throwableLocalPos, cameraLookVector)
	
	-- Loop through index
	for _, playerTime in pairs(playerTimeArray) do
		
		-- Check player part..
		if playerTime[1] == player then

			-- If threw again before in interval, leave function
			return
			
		end
	end
	
	-- Log this player as throwing a cheese at timestamp
	table.insert(playerTimeArray, {player, time()})	
	
	-- If Character Exists --
	if player.Character then
		
		-- Determine what was thrown --
		if throwableName == "Cheese" then

			-- Clone a new Cheese --
			local usedCheese = game.ServerStorage.UsedCheese:Clone()

			-- Parent -- 
			usedCheese.Parent = game.Workspace

			-- position --
			usedCheese.CFrame = CFrame.new(throwableLocalPos)
			
			-- Apply Impulse
			usedCheese:ApplyImpulse(cameraLookVector * 120 * usedCheese.AssemblyMass)
			
			-- Nil Stuff
			usedCheese = nil
			
			-- Add to player stats if player is downstairs..
			if player.Character then
				
				-- if
				if player.Character.PrimaryPart.Position.Y < 23 then
					
					-- Add to cheese..
					player.cheesesthrown.Value += 1
					
				end
			end			
			
		elseif throwableName == "Frag" then
			
			-- Clone a new Frag --
			local usedFrag = game.ServerStorage.UsedFrag:Clone()

			-- Parent -- 
			usedFrag.Parent = game.Workspace
			
			-- Set Player Who Threw It
			usedFrag.PlayerName.Value = player.Name

			-- position --
			usedFrag.CFrame = CFrame.new(throwableLocalPos)
			
			-- apply Impulse
			usedFrag:ApplyImpulse(cameraLookVector * 120 * usedFrag.AssemblyMass)

			-- Nil Stuff
			usedFrag = nil	
			
			-- Add to Player stats if player is downstairs..
			if player.Character then

				-- if
				if player.Character.PrimaryPart.Position.Y < 23 then

					-- Add to cheese..
					player.fragsthrown.Value += 1

				end
			end			
		end		
	end	
	
	-- Wait until interval is up, then remove index..
	task.wait(minThrowInterval)
	
	-- Remove this throw from the index..
	for i, playerTime in pairs(playerTimeArray) do

		-- Check player part..
		if playerTime[1] == player then

			-- remove
			table.remove(playerTimeArray, i)

		end
	end
	
	print("#Array: " .. #playerTimeArray)
end)

