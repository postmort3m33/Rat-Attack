-- Services..
local PlayerService = game:GetService("Players")

-- List of Objectives and ID's
local objectiveList = {
	{1, "Talk to the Scientist upstairs to find out what's going on at VKA Labs."},
	{2, "Shoot down the satellite to get the fuse and take it to the lab to power up the Mixalyzer."},
	{3, "Insert a vial of rat blood into the Mixalyzer and turn it on to get the new formula."},
	{4, "Insert a vial of battery acid into the Mixalyzer."},	
	{5, "Insert a vial of albino rat blood plasma into the Mixalyzer."},	
	{6, "Find and insert an Empty Vial into the Mixalyzer."},
	{7, "Run the Mixalyzer to craft the new poison."},
	{8, "Take the poison to the Scientist to have him analyze it."},
	{9, "Bring the Scientist an Electronic Component."},
	{10, "Bring the Scientist 3 cans of Aerosol."},
	{11, "Bring the Scientist 10 vials of rat blood."},
	{12, "Call the shop and have them bring a fogger machine."},
	{13, "Defend the front gate while you wait for the fogger machine."},
	{14, "Bring the Scientist the fogger machine."},
	{15, "Wait for the Scientist to finish making the poison bomb."},
	{16, "Defeat the rats in Containment to access the ventilation system."},
	{17, "Set the poison bomb by the main ventilation fan."},
	{18, "Escape the warehouse with the scientist."},
	{19, "Install a propane tank onto the forklift to get the battery from the battery compartment."}, -- SubMissions Start Here..
	{20, "Install a new sawblade into the tablesaw."},
	{21, "Cut the battery open with the tablesaw and find and use an Empty Vial to get battery acid."},
	{22, "Use Cheese to set at least 4 mousetraps around the map to catch an albino rat."},
	{23, "Take the albino rat caught in the mouse trap to a lab table for dissection."},
	{24, "Find and use an Empty Vial to extract some of the albino rats' blood."},
	{25, "Use a centrifuge to isolate the albino rat blood plasma.",}
}

-- List of Completeed Objectives..
local completedObjectiveIDs = {}
local currentObjectiveIDs = {}

-- Objectives Complete ..
local objective4Complete = false
local objective5Complete = false
local objective6Complete = false
local objective7Given = false
local objective9Complete = false
local objective10Complete = false
local objective11Complete = false
local objective14Complete = false
local objective15Given = false

---------------
-- Functions --
---------------

-- Function to Give players new objective..
local function GiveNewObjective(objectiveArray)

	-- Dont give Objective if it was already completed..
	if table.find(completedObjectiveIDs, objectiveArray[1]) then

		-- Leave Function
		return
	else

		-- Give Objective..
		game.ReplicatedStorage.MissionEvents.GivePlayersObjective:FireAllClients(objectiveArray)

		-- Insert into current Objectives..
		table.insert(currentObjectiveIDs, objectiveArray[1])
	end
end

-- Objective Complete
local function ObjectiveComplete(id)
	
	-- Add to Completed Objectives
	table.insert(completedObjectiveIDs, id)

	-- Remove from Current Objectives..
	if table.find(currentObjectiveIDs, id) then
		
		-- Remove It
		local index = table.find(currentObjectiveIDs, id)
		table.remove(currentObjectiveIDs, index)	
		
		-- Send to Client GUI..
		game.ReplicatedStorage.MissionEvents.ObjectiveCompleteToClient:FireAllClients(id)
	end	
	
	-- Wait 3 Seconds..
	task.wait(3)

	-- Now Give Next Objective..
	if id == 1 then

		-- Now Find the Fuse..
		GiveNewObjective(objectiveList[2])

	elseif id == 2 then

		-- Now Insert Rat Blood into the Machine to Sample It..
		GiveNewObjective(objectiveList[3])

	elseif id == 3 then

		-- Give Players 3 Objectives Now to find the 3 Items..
		GiveNewObjective(objectiveList[4])
		GiveNewObjective(objectiveList[19])
		GiveNewObjective(objectiveList[20])
		GiveNewObjective(objectiveList[21])		
		GiveNewObjective(objectiveList[5])
		GiveNewObjective(objectiveList[22])
		GiveNewObjective(objectiveList[23])
		GiveNewObjective(objectiveList[24])
		GiveNewObjective(objectiveList[25])
		GiveNewObjective(objectiveList[6])

	elseif id == 4 then

		-- Its Complete
		objective4Complete = true

		-- Check for 3 Rat poison Objectives to be complete..
		if objective4Complete and objective5Complete and objective6Complete and objective7Given == false then

			-- Objective 7 Given
			objective7Given = true

			-- Give Objective 7..
			GiveNewObjective(objectiveList[7])
			
		end

	elseif id == 5 then

		-- Its Complete
		objective5Complete = true

		-- Check for 3 Rat poison Objectives to be complete..
		if objective4Complete and objective5Complete and objective6Complete and objective7Given == false then

			-- Objective 7 Given
			objective7Given = true

			-- Give Objective 7..
			GiveNewObjective(objectiveList[7])
			
		end

	elseif id == 6 then

		-- Its Complete
		objective6Complete = true

		-- Check for 3 Rat poison Objectives to be complete..
		if objective4Complete and objective5Complete and objective6Complete and objective7Given == false then

			-- Objective 7 Given
			objective7Given = true

			-- Give Objective 7..
			GiveNewObjective(objectiveList[7])
			
		end

	elseif id == 7 then

		-- New Mission.
		GiveNewObjective(objectiveList[8])

	elseif id == 8 then

		-- Give new Objectives..
		GiveNewObjective(objectiveList[9])
		GiveNewObjective(objectiveList[10])
		GiveNewObjective(objectiveList[11])
		GiveNewObjective(objectiveList[12])

	elseif id == 9 then
		
		-- Its Complete
		objective9Complete = true
		
		-- Check for 3 Rat poison Objectives to be complete..
		if objective9Complete and objective10Complete and objective11Complete and objective14Complete then
			
			-- Scientist 3rd Speech..
			game.ReplicatedStorage.MissionEvents.Scientist3rdSpeechServerToServer:Fire()
			
		end
		
	elseif id == 10 then

		-- Its Complete
		objective10Complete = true
		
		-- Check for 3 Rat poison Objectives to be complete..
		if objective9Complete and objective10Complete and objective11Complete and objective14Complete then

			-- Scientist 3rd Speech..
			game.ReplicatedStorage.MissionEvents.Scientist3rdSpeechServerToServer:Fire()
			
		end
		
	elseif id == 11 then

		-- Its Complete
		objective11Complete = true
		
		-- Check for 3 Rat poison Objectives to be complete..
		if objective9Complete and objective10Complete and objective11Complete and objective14Complete then

			-- Scientist 3rd Speech..
			game.ReplicatedStorage.MissionEvents.Scientist3rdSpeechServerToServer:Fire()

		end
		
	elseif id == 12 then
		
		-- Enable Front Gate Script..
		workspace.Level.ParkingLot.OutsideGate.RightGateClosed.FrontGateScript.Enabled = true
		
		-- Give 13..
		GiveNewObjective(objectiveList[13])
		
	elseif id == 13 then
		
		-- Give 14..
		GiveNewObjective(objectiveList[14])
		
	elseif id == 14 then
		
		-- Objective 14 COmpletew
		objective14Complete = true
		
		-- Check for 3 Rat poison Objectives to be complete..
		if objective9Complete and objective10Complete and objective11Complete and objective14Complete then

			-- Scientist 3rd Speech..
			game.ReplicatedStorage.MissionEvents.Scientist3rdSpeechServerToServer:Fire()			

		end
	elseif id == 15 then
		
		-- Give Next Mission
		GiveNewObjective(objectiveList[17])
		
	elseif id == 17 then
		
		-- Give Next Mission
		GiveNewObjective(objectiveList[18])
		
	end
end

-----------------
-- Connections --
-----------------

-- Recieve Complete Objectives from Server..
game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer.Event:Connect(function(id)

	-- Run functrion
	ObjectiveComplete(id)
end)

-- Startgame Event
game.ServerStorage.ServerEvents.StartGame.Event:Connect(function()
	
	-- Wait
	task.wait(3)
	
	-- Give Players first Objective to Talk to the Scientist..
	GiveNewObjective(objectiveList[1])
	
end)

-- Recieved when scientist 3rd speech is over..
game.ReplicatedStorage.MissionEvents.Scientist3rdSpeechOver.Event:Connect(function()
	
	-- Give Player Objective 15..
	GiveNewObjective(objectiveList[15])
	GiveNewObjective(objectiveList[16])
	
end)

-- When a player respawns Give them their currentObjectives back..
PlayerService.PlayerAdded:Connect(function(player)
	
	-- When Character is Added.
	player.CharacterAdded:Connect(function()
		
		-- check if Main GUI exists yet..
		local mainGUI = player.PlayerGui:WaitForChild("MainGUI")
		
		-- wait
		task.wait(3)
		
		-- Loop through currentObjectives..
		for _, objective in pairs(currentObjectiveIDs) do
			
			-- Send Mission For Each..
			game.ReplicatedStorage.MissionEvents.GivePlayersObjective:FireClient(player, objectiveList[objective])
			
		end	
		
		-- Nil Stuff
		mainGUI = nil
		
	end)
end)

