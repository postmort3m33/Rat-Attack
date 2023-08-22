-- Wait
task.wait(5)

---------------
-- Functions --
---------------

-- Remove Ping
local function RemovePing(player)

	-- Remove this Players Ping..
	for _, currentPing in pairs(workspace.CurrentPings:GetChildren()) do

		-- check Player Value against this player..
		if currentPing.PlayerObjectThatPinged.Value == player then

			-- Remove this ping..
			currentPing:Destroy()

		end
	end
end

-- Set ping
local function SetMissionPing(position, objectiveNumber)
	
	-- Create Ping Clone..
	local pingMarkerClone = script:WaitForChild("MissionPingPart"):Clone()

	-- Parent it to local Folder..
	pingMarkerClone.Parent = workspace.CurrentMissionPings

	-- Set Location
	pingMarkerClone.CFrame = CFrame.new(position)
	
	-- Set Mission Objective Number
	pingMarkerClone.ObjectiveNumber.Value = objectiveNumber
	
	
end

-- Remove Mission Ping
local function RemoveMissionPing(objectiveNumber)
	
	-- Remove this Players Ping..
	for _, currentPing in pairs(workspace.CurrentMissionPings:GetChildren()) do

		-- check Player Value against this player..
		if currentPing.ObjectiveNumber.Value == objectiveNumber then

			-- Remove this ping..
			currentPing:Destroy()

		end
	end	
end

-----------------
-- Connections --
-----------------

-- Player Leaving Connnection
game:GetService("Players").PlayerRemoving:Connect(function(player)

	-- Remove this players ping..
	RemovePing(player)

end)

-- Ping Event
game.ReplicatedStorage.PingCTS.OnServerEvent:Connect(function(Player, HitSomething, TargetPosition)
	
	-- If we didnt hit anything, exit..
	if not HitSomething then return end
	
	RemovePing(Player)
	
	-- Create Ping Clone..
	local pinkMarkerClone = script:WaitForChild("PingPart"):Clone()
	
	-- Parent it to local Folder..
	pinkMarkerClone.Parent = workspace.CurrentPings
	
	-- Set Player Object
	pinkMarkerClone.PlayerObjectThatPinged.Value = Player
	
	-- Set Location
	pinkMarkerClone.CFrame = CFrame.new(TargetPosition)
	
end)

-- Player Wnats to remove Ping
game.ReplicatedStorage.RemovePingCTS.OnServerEvent:Connect(function(Player)
	
	-- Remove it
	RemovePing(Player)
	
end)
--------------------
-- Missions Pings --
--------------------

-- When First Objective Fires..
game.ServerStorage.ServerEvents.StartGame.Event:Connect(function()

	-- Wait
	task.wait(3)

	-- Give Players first Objective to Talk to the Scientist..
	SetMissionPing(Vector3.new(102.017, 39.971, 75.253), 1)

end)

-- Recieve Other Ping Removals
game.ReplicatedStorage.MissionEvents.RemoveMissionPingSTS.Event:Connect(function(id)
	
	-- Run functrion
	RemoveMissionPing(id)
	
end)

