-- Wait
task.wait(1)

-- Services
local BadgeService = game:GetService("BadgeService")
local PlayerService = game:GetService("Players")

-- Get Player and Character
local thisCharacter = script.Parent
local thisHead = thisCharacter:WaitForChild("Head")
local thisPlayer = PlayerService:GetPlayerFromCharacter(thisCharacter)

-- Admin IDs
local myID = 4272115183
local chaseID = 3878809968

-- Badge Asset Ids
local exterminatorBadgeLabelID = "rbxassetid://13168409630"
local technicianBadgeLabelID = "rbxassetid://13169021935"
local specialistBadgeLabelID = "rbxassetid://13169022034"
local serviceRepBadgeLabelID = "rbxassetid://13169022142"
local inspectorBadgeLabelID = "rbxassetid://13169022304"
local assistantBadgeLabelID = "rbxassetid://13169022478"
local apprenticeBadgeLabelID = "rbxassetid://13169122222"
local goldstarBadgeLabelID = "rbxassetid://13557385821"

-- Get Badges
local billBoardGUI = script.BadgeBillboardGUI

-- Badge ID's
local pmpcExterminatorID = 2133722230
local pmpcSpecialistID = 2137640536
local pmpcTechnicianID = 2137635165
local pmpcInspectorID = 2137630455
local pmpcServiceRepID = 2137625247
local pmpcAssistantID = 2137614033
local pmpcApprenticeID = 2137564433

-- Badge ID Array
local allBadgeIDsArray = {pmpcApprenticeID, pmpcAssistantID, pmpcServiceRepID, pmpcInspectorID, pmpcTechnicianID, pmpcSpecialistID, pmpcExterminatorID}

----------
-- Init --
----------

-- Move it To Head..
billBoardGUI.Parent = thisHead

-- Wait
task.wait()

-- Blank the label
billBoardGUI.BadgeLabel.Image = ""

-- Hide it from thisplayer
billBoardGUI.PlayerToHideFrom = thisPlayer

-- Apply Label Image By Badge
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
		if badgeID == pmpcApprenticeID then

			-- Update
			billBoardGUI.BadgeLabel.Image = apprenticeBadgeLabelID

		elseif badgeID == pmpcAssistantID then

			-- Update
			billBoardGUI.BadgeLabel.Image = assistantBadgeLabelID

		elseif badgeID == pmpcServiceRepID then

			-- Update
			billBoardGUI.BadgeLabel.Image = serviceRepBadgeLabelID

		elseif badgeID == pmpcInspectorID then

			-- Update
			billBoardGUI.BadgeLabel.Image = inspectorBadgeLabelID

		elseif badgeID == pmpcTechnicianID then

			-- Update
			billBoardGUI.BadgeLabel.Image = technicianBadgeLabelID

		elseif badgeID == pmpcSpecialistID then

			-- Update
			billBoardGUI.BadgeLabel.Image = specialistBadgeLabelID

		elseif badgeID == pmpcExterminatorID then

			-- Update
			billBoardGUI.BadgeLabel.Image = exterminatorBadgeLabelID

		end
	end

	-- Wait
	task.wait()	

end

-- Check for Admins..
if thisPlayer.UserId == myID or thisPlayer.UserId == chaseID then
	
	-- Set to GoldStar
	billBoardGUI.BadgeLabel.Image = goldstarBadgeLabelID
	
end

-- Destroy this script..
task.wait(3)

-- Do it
script:Destroy()





