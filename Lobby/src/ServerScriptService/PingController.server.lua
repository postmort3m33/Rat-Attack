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