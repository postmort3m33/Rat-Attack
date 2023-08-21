-- Connection Vars --
local mouseTrapSetConnection = nil

-- Mouse Trap Vars
local mouseTrapsSet = {}

-- Current_Round
local CURRENT_ROUND = 1

-- state vars
local albinoRatSpawned = false

---------------
-- Functions --
---------------

-- Spawn Dead Rat into One of the Mouse Traps --
local function SpawnDeadRatIntoMouseTrap()
	
	-- state
	albinoRatSpawned = true
	
	-- Make Dead rat
	local deadRatClone = game.ServerStorage.Tools.EasterEggParts.RatDeadPart:Clone()

	-- Parent
	deadRatClone.Parent = game.Workspace
	
	-- Choose Random Mouse Trap
	local randomNumber = math.random(1, #mouseTrapsSet)

	-- Position/Rotation
	deadRatClone.CFrame = CFrame.new(mouseTrapsSet[randomNumber].Position) + Vector3.new(0, 0.5, 0)
	
	-- Call Ding Sound..
	game.ReplicatedStorage.CheckTrapsSound:FireAllClients()

	-- Nil Stuff
	deadRatClone = nil
	randomNumber = nil
	
	-- Objective Complete..
	game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(22)
	
end

-----------------
-- Connections --
-----------------

-- Event sent from ServerUpTimeTracker to Update New Rounds..
game.ServerStorage.ServerEvents.NewRound.Event:Connect(function(newRound)
	
	-- Set this round
	CURRENT_ROUND = newRound
	
	-- If this is albino Round and mouse traps were set..
	if #mouseTrapsSet >= 4 and CURRENT_ROUND % 3 == 0 and albinoRatSpawned == false then
		
		-- spawn Albuino Rat into Trap
		SpawnDeadRatIntoMouseTrap()
		
		-- Disconnect
		mouseTrapSetConnection:Disconnect()
		mouseTrapSetConnection = nil	
	end
	
end)

-- A Mouse Trap was Set with Cheese
mouseTrapSetConnection = game.ReplicatedStorage.EasterEggEvents.MouseTrapSet.Event:Connect(function(player, mouseTrapObject)
	
	-- Add to Mouse Traps Set
	table.insert(mouseTrapsSet, mouseTrapObject)
	
	-- If all Traps have been set (4)..
	if #mouseTrapsSet >= 4 and CURRENT_ROUND % 3 == 0 and albinoRatSpawned == false then
		
		-- spawn Albuino Rat into Trap
		SpawnDeadRatIntoMouseTrap()
		
		-- Disconnect
		mouseTrapSetConnection:Disconnect()
		mouseTrapSetConnection = nil		
	end
	
end)
