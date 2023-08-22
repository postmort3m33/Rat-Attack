-- Services
local BadgeService = game:GetService("BadgeService")

-- Rank Bot Stuff
local glitchURL = "https://pmpc-rank-bot.glitch.me/"

-- Badge ID's
local pmpcExterminatorID = 2133722230
local pmpcSpecialistID = 2137640536
local pmpcTechnicianID = 2137635165
local pmpcInspectorID = 2137630455
local pmpcServiceRepID = 2137625247
local pmpcAssistantID = 2137614033
local pmpcApprenticeID = 2137564433

-- Other Badge IDS
local vkaLabsCompletedID = 2146521101

-- Badge Kill Counts
local apprenticeKills = 1
local assistantKills = 5000
local serviceRepKills = 10000
local inspectorKills = 15000
local technicianKills = 20000
local specialistKills = 25000
local exterminatorKills = 30000

---------------
-- Functions --
---------------

-- Get Role ID
local function GetRoleID(badgeID)
	
	-- New Rol ID
	local roleID = nil
	
	-- Update Badge Flags
	if badgeID == pmpcExterminatorID then

		-- Update
		roleID = 231

	elseif badgeID == pmpcSpecialistID then

		-- Update
		roleID = 198

	elseif badgeID == pmpcTechnicianID then

		-- Update
		roleID = 165

	elseif badgeID == pmpcInspectorID then

		-- Update
		roleID = 132

	elseif badgeID == pmpcServiceRepID then

		-- Update
		roleID = 99

	elseif badgeID == pmpcAssistantID then

		-- Update
		roleID = 66

	elseif badgeID == pmpcApprenticeID then

		-- Update
		roleID = 1

	else
		
		-- Update
		roleID = 0
	end	
	
	-- Return it
	return roleID
	
end

-- Update User Rank..
function RankUser(userID, roleID)
	
	-- Run HTTP Service using Glitch to Update PLayer Rank..
	game:GetService("HttpService"):GetAsync(glitchURL .. "ranker?userid=" .. userID .. "&rank=" .. roleID)
end

-----------------
-- Connections --
-----------------

-- Award Badge Conection
game.ReplicatedStorage.AwardBadgeCTS.OnServerEvent:Connect(function(player, badgeID)
	
	-----------------------------------------------------------------
	-- If Someone Sends Hacked Badge Award Event, Leave Function.. --
	-----------------------------------------------------------------
	
	-- Cross Reference Actual Rat Kills
	if badgeID == pmpcExterminatorID then

		-- Check
		if player.leaderstats.ratskilled.Value < exterminatorKills then return end

	elseif badgeID == pmpcSpecialistID then

		-- Check
		if player.leaderstats.ratskilled.Value < specialistKills then return end


	elseif badgeID == pmpcTechnicianID then

		-- Check
		if player.leaderstats.ratskilled.Value < technicianKills then return end


	elseif badgeID == pmpcInspectorID then

		-- Check
		if player.leaderstats.ratskilled.Value < inspectorKills then return end


	elseif badgeID == pmpcServiceRepID then

		-- Check
		if player.leaderstats.ratskilled.Value < serviceRepKills then return end


	elseif badgeID == pmpcAssistantID then

		-- Check
		if player.leaderstats.ratskilled.Value < assistantKills then return end


	elseif badgeID == pmpcApprenticeID then

		-- Check
		if player.leaderstats.ratskilled.Value < apprenticeKills then return end

	end
	
	---------------------
	-- Now Award Badge --
	---------------------
	
	-- Fetch badge information
	local success, badgeInfo = pcall(function()

		return BadgeService:GetBadgeInfoAsync(badgeID)

	end)

	-- If we successfully got the Badge Info..
	if success then

		-- Confirm that badge can be awarded
		if badgeInfo.IsEnabled then

			-- Award badge
			local awardSuccess, result = pcall(function()

				return BadgeService:AwardBadge(player.UserId, badgeID)

			end)

			-- If it was wsuccessful..
			if awardSuccess then
				
				-- Confirm badge was awearded..
				game.ReplicatedStorage.ConfirmBadgeAwardedSTC:FireClient(player, badgeID)
				
				-- If this is a rank badge..
				if badgeID ~= vkaLabsCompletedID then
					
					-- Find Role ID
					local roleID = GetRoleID(badgeID)

					-- Update Players Rank Using Glitch..
					RankUser(player.UserId, roleID)

					-- Nil
					roleID = nil					
					
				end				

			elseif not awardSuccess then

				-- the AwardBadge function threw an error
				warn("Error while awarding badge:", result)

			elseif not result then

				-- the AwardBadge function did not award a badge
				warn("Failed to award badge.")

			end
		end
	else

		warn("Error while fetching badge info: " .. badgeInfo)

	end	
end)