-- Services
local BadgeService = game:GetService("BadgeService")

-- Vars
local thisPlayer = game.Players.LocalPlayer
local ratsKilled = 0

-- Badge ID's
local pmpcExterminatorID = 2133722230
local pmpcSpecialistID = 2137640536
local pmpcTechnicianID = 2137635165
local pmpcInspectorID = 2137630455
local pmpcServiceRepID = 2137625247
local pmpcAssistantID = 2137614033
local pmpcApprenticeID = 2137564433

-- Badge ID Array
local allBadgeIDsArray = {pmpcExterminatorID, pmpcSpecialistID, pmpcTechnicianID, pmpcInspectorID, pmpcServiceRepID, pmpcAssistantID, pmpcApprenticeID}

-- Other Badge IDS
local vkaLabsCompletedID = 2146521101

-- PLayer Has Badges..
local hasExterminatorBadge = false
local hasSpecialistBadge = false
local hasTechnicianBadge = false
local hasInspectorBadge = false
local hasServiceRepBadge = false
local hasAssistantBadge = false
local hasApprenticeBadge = false

-----------------
-- Connections --
-----------------

-- If game was beat..
game.ReplicatedStorage.MissionEvents.ScientistClearedWarehouseSTC.OnClientEvent:Connect(function()
	
	-- Wait a second..
	task.wait(1)
	
	-- Check if the player has the badge
	local success, hasBadge = pcall(function()

		return BadgeService:UserHasBadgeAsync(thisPlayer.UserId, vkaLabsCompletedID)

	end)
	
	-- If they dont have it, give it to them..
	if not hasBadge then
		
		-- Award Game Beat Badge
		game.ReplicatedStorage.AwardBadgeCTS:FireServer(vkaLabsCompletedID)
		
	end
end)

-- Watch Rats Kiled Number
thisPlayer.leaderstats.ratskilled.Changed:Connect(function()
	
	-- Get Rats Killed
	ratsKilled = thisPlayer.leaderstats.ratskilled.Value
	
	-- Check for Badges..
	if ratsKilled >= 1 and not hasApprenticeBadge then
		
		-- Call Server To Award Badge..
		game.ReplicatedStorage.AwardBadgeCTS:FireServer(pmpcApprenticeID)
		
	elseif ratsKilled >= 5000 and not hasAssistantBadge then
		
		-- Call Server To Award Badge..
		game.ReplicatedStorage.AwardBadgeCTS:FireServer(pmpcAssistantID)
		
	elseif ratsKilled >= 10000 and not hasServiceRepBadge then
		
		-- Call Server To Award Badge..
		game.ReplicatedStorage.AwardBadgeCTS:FireServer(pmpcServiceRepID)
		
	elseif ratsKilled >= 15000 and not hasInspectorBadge then
		
		-- Call Server To Award Badge..
		game.ReplicatedStorage.AwardBadgeCTS:FireServer(pmpcInspectorID)
		
	elseif ratsKilled >= 20000 and not hasTechnicianBadge then
		
		-- Call Server To Award Badge..
		game.ReplicatedStorage.AwardBadgeCTS:FireServer(pmpcTechnicianID)
		
	elseif ratsKilled >= 25000 and not hasSpecialistBadge then
		
		-- Call Server To Award Badge..
		game.ReplicatedStorage.AwardBadgeCTS:FireServer(pmpcSpecialistID)
		
	elseif ratsKilled >= 30000 and not hasExterminatorBadge then
		
		-- Call Server To Award Badge..
		game.ReplicatedStorage.AwardBadgeCTS:FireServer(pmpcExterminatorID)
		
	end
end)

-- Confirm Has Badge..
game.ReplicatedStorage.ConfirmBadgeAwardedSTC.OnClientEvent:Connect(function(badgeID)
	
	-- Play Award Sound..
	script.Parent.Squeal1:Play()
	
	-- Update Badge Flags
	if badgeID == pmpcExterminatorID then

		-- Update
		hasExterminatorBadge = true

	elseif badgeID == pmpcSpecialistID then

		-- Update
		hasSpecialistBadge = true

	elseif badgeID == pmpcTechnicianID then

		-- Update
		hasTechnicianBadge = true

	elseif badgeID == pmpcInspectorID then

		-- Update
		hasInspectorBadge = true

	elseif badgeID == pmpcServiceRepID then

		-- Update
		hasServiceRepBadge = true

	elseif badgeID == pmpcAssistantID then

		-- Update
		hasAssistantBadge = true

	elseif badgeID == pmpcApprenticeID then

		-- Update
		hasApprenticeBadge = true

	end
	
end)

----------
-- Init --
----------

-- Wait
task.wait(3)

-- Check which badges player has...
for _, badgeID in pairs(allBadgeIDsArray) do

	-- Check if the player has the badge
	local success, hasBadge = pcall(function()

		return BadgeService:UserHasBadgeAsync(thisPlayer.UserId, badgeID)

	end)

	-- If there's an error, issue a warning and exit the function
	if not success then

		warn("Error while checking if player has badge!")

		return

	end

	-- If they had the badge..
	if hasBadge then

		-- Update Badge Flags
		if badgeID == pmpcExterminatorID then

			-- Update
			hasExterminatorBadge = true

		elseif badgeID == pmpcSpecialistID then

			-- Update
			hasSpecialistBadge = true

		elseif badgeID == pmpcTechnicianID then

			-- Update
			hasTechnicianBadge = true

		elseif badgeID == pmpcInspectorID then

			-- Update
			hasInspectorBadge = true

		elseif badgeID == pmpcServiceRepID then

			-- Update
			hasServiceRepBadge = true

		elseif badgeID == pmpcAssistantID then

			-- Update
			hasAssistantBadge = true

		elseif badgeID == pmpcApprenticeID then

			-- Update
			hasApprenticeBadge = true

		end
	end
	
	-- Wait
	task.wait()	
	
end

