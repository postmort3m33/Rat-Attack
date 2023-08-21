-- this Stuff --
local thisPart = script.Parent

-- Door Side Stuff
local triggerZPos = thisPart.Position.Z

-- Connections --
thisPart.TouchEnded:Connect(function(entity)
	
	-- If this Part is touched by a player, check if they are in the outdoor area..
	if game.Players:GetPlayerFromCharacter(entity.Parent) then
		
		-- Get PLayer
		local thisPlayer = game.Players:GetPlayerFromCharacter(entity.Parent)
		
		-- If a HumanoidRootPart has passed through
		if entity == entity.Parent.PrimaryPart then
			
			-- Get HRP Pos
			local hrpPos = entity.Parent.PrimaryPart.Position.Z
			
			-- See which side the HRP is on NOw..
			if hrpPos > triggerZPos then
				
				-- Play Outside Ambience
				game.ReplicatedStorage.PlayOutdoorAmbienceSound:FireClient(thisPlayer)
			else
				
				-- Play Dungeon Ambience
				game.ReplicatedStorage.PlayDungeonAmbienceSound:FireClient(thisPlayer)
			end
			
			-- Nil Stuff
			hrpPos = nil
		end	
		
		-- Nil Stuff
		thisPlayer = nil
		
	end
end)
