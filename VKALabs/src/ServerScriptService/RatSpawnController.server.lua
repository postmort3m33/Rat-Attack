-- Control Vars --
local RATS_ON = true -- Default: true
local MAX_SERVER_RATS = 100 -- Default: 100
local MIN_SPAWN_INTERVAL = 0.33
local ALBINO_RATS_PER_ROUND = 8 -- Default: 8
local GAME_STARTED = false -- Must Start as False

-- Spawn Location Stuff --
local spawnBoxRooms1_2 = game.Workspace.RatSpawns["RatSpawnBoxRooms1-2"]
local spawnBoxRooms2_4 = game.Workspace.RatSpawns["RatSpawnBoxRooms2-4"]
local spawnBoxRooms1_3 = game.Workspace.RatSpawns["RatSpawnBoxRooms1-3"]
local spawnBoxRooms3_4 = game.Workspace.RatSpawns["RatSpawnBoxRooms3-4"]
local spawnBoxOutside2 = game.Workspace.RatSpawns.RatSpawnBoxOutside2
local spawnOutside = true -- Default: True

-- Rat Walk Speed Vars
local RAT_MIN_WALK_SPEED = 11
local RAT_MAX_WALK_SPEED = 13
local RAT_ALBINO_MIN_WALK_SPEED = 15
local RAT_ALBINO_MAX_WALK_SPEED = 17

-- Rat Count Vars --
local lastRatSpawn = time()
local ratSpawnInterval = 1.66
local maxRats = 0
local maxRatsSlope = 3 -- Default for 1 Player: 3
local ratFolderChildren = {}

-- Round Stuff  --
local CURRENT_ROUND = 1 -- MUST START AS 1
local maxRounds = 33 -- 

-- Rat Health Changer Stuff
local startRatHealth = 33
local maxHealth = 300
local ratHealthSlope = (maxHealth - startRatHealth) / (maxRounds - 1) -- Using Linear Function..
local ratHealthYIntercept = startRatHealth - ratHealthSlope

-- Albino Rat Health Stuff
local startRatAlbinoHealth = 33
local maxRatAlbinoHealth = 600
local ratAlbinoHealthSlope = (maxRatAlbinoHealth - startRatAlbinoHealth) / (maxRounds - 1) -- Using Linear Function..
local ratAlbinoHealthYIntercept = startRatAlbinoHealth - ratAlbinoHealthSlope

-- Albino Rat Vars --
local lastAlbinoRatSpawned = time()
local albinoRatsSpawnedThisRound = 0

-- Event Vars
local containmentBreachFired = false

---------------
-- Functions --
---------------

-- Functions - Spawn --
local function SpawnRat(spawnAlbino, minSpeed, maxSpeed)
	
	-- Random Number
	local randomSpawnNumber = 1
	local chosenSpawn = nil

	-- Only spawn Outside if Allowed
	if spawnOutside then
		randomSpawnNumber = math.random(1,5)
	else
		randomSpawnNumber = math.random(1,4)
	end			

	-- Choose Room --
	if randomSpawnNumber == 1 then
		chosenSpawn = spawnBoxRooms1_2
	elseif randomSpawnNumber == 2 then
		chosenSpawn = spawnBoxRooms2_4
	elseif randomSpawnNumber == 3 then
		chosenSpawn = spawnBoxRooms1_3
	elseif randomSpawnNumber == 4 then
		chosenSpawn = spawnBoxRooms3_4
	elseif randomSpawnNumber == 5 then
		chosenSpawn = spawnBoxOutside2
	end		

	-- we Are Spawning Albino..
	if spawnAlbino then
		
		-- Determine Health for rats this round..
		local newHealth = math.floor((ratAlbinoHealthSlope * CURRENT_ROUND) + ratAlbinoHealthYIntercept) -- Using Linear Function..

		-- Spawn Albino..
		local ratClone = game.ServerStorage.Prefabs.RatAlbino:Clone()

		-- Place into Workspace --
		ratClone.Parent = game.Workspace.Rats

		-- Set position -- 
		ratClone.Torso.CFrame = chosenSpawn.CFrame:ToWorldSpace(CFrame.new(math.random(-2,2), 0, math.random(-2,2)))

		-- Set random speed per rat --
		ratClone.Humanoid.WalkSpeed = math.random(minSpeed,maxSpeed)

		-- Albino Health
		ratClone.Humanoid.Health = newHealth

		-- Nil this variable
		ratClone = nil
		newHealth = nil
		
	else
		
		-- Determine Health for rats this round..
		local newHealth = math.floor((ratHealthSlope * CURRENT_ROUND) + ratHealthYIntercept) -- Using Linear Function..

		-- Spawn new rat, with offset --
		local ratClone = game.ServerStorage.Prefabs.Rat:Clone()

		-- Place into Workspace --
		ratClone.Parent = game.Workspace.Rats

		-- Set position -- 
		ratClone.Torso.CFrame = chosenSpawn.CFrame:ToWorldSpace(CFrame.new(math.random(-2,2), 0, math.random(-2,2)))

		-- Set random speed per rat --
		ratClone.Humanoid.WalkSpeed = math.random(minSpeed,maxSpeed)

		-- Set Rat Health..
		ratClone.Humanoid.Health = newHealth

		-- Random Rat Color (Shade) ==
		local randomRGB = math.random(100,180)
		local newColor = Color3.fromRGB(randomRGB,randomRGB,randomRGB)
		ratClone.BackTailBase.Color = newColor
		ratClone.BackTorso.Color = newColor
		ratClone.FrontTailBase.Color = newColor
		ratClone.Head.Color = newColor
		ratClone.MiddleTorso.Color = newColor
		ratClone.Neck.Color = newColor
		ratClone.Nose.Color = newColor
		ratClone.NoseTip.Color = newColor
		ratClone.Torso.Color = newColor

		-- Nil this variable
		newHealth = nil
		ratClone = nil
		randomRGB = nil
		newColor = nil

	end
	
	-- Nil Stuff
	randomSpawnNumber = nil	
	chosenSpawn = nil
end

-- Set max Rats --
local function SetMaxRats()

	-- Are Rats on or Off
	if RATS_ON and GAME_STARTED then
		
		-- Set RatSpawn Interval
		if spawnOutside then
			
			-- Set it
			ratSpawnInterval = (-1 * (math.sqrt(CURRENT_ROUND/ 18))) + 2 -- Default: the 12 was a 33
			
		end
		
		-- Now Multiply PLayer Count by RatsPerPlayer --
		maxRats = math.floor((maxRatsSlope * CURRENT_ROUND) + 6)
		
		-- Set max Albino Rats
		ALBINO_RATS_PER_ROUND = math.floor(math.sqrt(CURRENT_ROUND) * 2.5)

		-- Make Sure we dont surpass server count..
		if maxRats > MAX_SERVER_RATS then maxRats = MAX_SERVER_RATS end
		
		-- Cap Spawn Interval at 0.33
		if ratSpawnInterval < MIN_SPAWN_INTERVAL then ratSpawnInterval = MIN_SPAWN_INTERVAL end

	else -- Rats are turned off

		-- Set Max rats
		maxRats = 0
	end	
end

-----------------
-- Connections --
-----------------
game.ServerStorage.ServerEvents.StartGame.Event:Connect(function()
	
	-- Set maxRats depending on how many players..
	local playerList = game.Players:GetPlayers()
	local numPlayers = #playerList
	
	-- Change
	if numPlayers == 1 then
		maxRatsSlope = 3
	elseif numPlayers == 2 then
		maxRatsSlope = 3.33
	elseif numPlayers == 3 then
		maxRatsSlope = 3.66
	elseif numPlayers == 4 then
		maxRatsSlope = 4
	end
	
	-- Wait
	task.wait(5)
	
	-- Game started
	GAME_STARTED = true		
	
	-- Set Max Rats First..
	SetMaxRats()
	
	-- Nil
	playerList = nil
	numPlayers = nil
	
end)

-- Recieve New Rounds..
game.ServerStorage.ServerEvents.NewRound.Event:Connect(function(round)
	
	-- Set new Round
	CURRENT_ROUND = round
	
	-- Set Max Rats
	SetMaxRats()
	
end)

-- Check for Temporary No Outside spawning..
game.ReplicatedStorage.OutsideRatSpawnSwitch.Event:Connect(function()
	
	----------------------------------------
	-- This functions as an ON/OFF Switch --
	----------------------------------------
	
	-- Change it
	if spawnOutside then
		
		-- Dont
		spawnOutside = false
		
		-- Turn up ratSpawn Interval
		ratSpawnInterval = MIN_SPAWN_INTERVAL
	else
		
		-- Do
		spawnOutside = true
		
		-- Reset Spawn Interval
		SetMaxRats()
	end	
end)

-- Check for Bomb Set..
game.ReplicatedStorage.MissionEvents.BombSetSTS.Event:Connect(function()
	
	-- Spawn Double Batch of Albino Rats
	for i = 1, (ALBINO_RATS_PER_ROUND * 2) do
		
		-- Spawn Albino Rat It
		SpawnRat(true, RAT_ALBINO_MIN_WALK_SPEED, RAT_ALBINO_MAX_WALK_SPEED)
		
		task.wait()
	end
end)

-- Check for Escape Warehouse
game.ReplicatedStorage.MissionEvents.ScientistClearedWarehouseSTS.Event:Connect(function()
	
	-- turn off Rats.
	RATS_ON = false
	
	-- Run SetMax
	SetMaxRats()
	
	-- Destroy all Rats in Folder..
	for _, child in pairs(workspace.Rats:GetChildren()) do
		
		-- Get Humanoid..
		child:Destroy()

	end	
end)
---------------------
-- Main Spawn Loop --
---------------------

-- Wait for Game to start
while GAME_STARTED == false do task.wait() end

-- Now Run Game Loop
while task.wait() do
	
	----------------------
	-- Spawn Albino Rats --
	----------------------
	
	-- Spawn every 3 rounds..
	if CURRENT_ROUND % 3 == 0 and RATS_ON then
		
		-- Fire Containment Breach Event
		if containmentBreachFired == false then
			
			-- Now Fire
			containmentBreachFired = true
			
			-- Fire Event
			game.ServerStorage.ServerEvents.ContainmentBreachStarted:Fire()
			
		end		
		
		-- This Round we spawn 10 Albino Rats..
		if albinoRatsSpawnedThisRound < ALBINO_RATS_PER_ROUND then
			
			-- Spawn Albino Rat It
			SpawnRat(true, RAT_ALBINO_MIN_WALK_SPEED, RAT_ALBINO_MAX_WALK_SPEED)

			-- Albino Spawned
			albinoRatsSpawnedThisRound += 1
			
		end	
		
	else
		
		-- Reset Containment Variables
		containmentBreachFired = false

		-- Reset Albino
		albinoRatsSpawnedThisRound = 0
	end
	
	----------------
	-- Spawn Rats --
	----------------

	-- Only Spawn a Rat every Interval --
	if (time() - lastRatSpawn) >= ratSpawnInterval and RATS_ON then

		-- Update Last Rat Count
		lastRatSpawn = time()
		
		-- Reset Rat Children Folder
		ratFolderChildren = {}

		-- Get Number of Rats --
		ratFolderChildren = game.Workspace.Rats:GetChildren()
		
		-- If Num Rats is less Than Max Rats, Spawn One --
		if #ratFolderChildren < maxRats then

			-- Spawn A Rat --
			SpawnRat(false, RAT_MIN_WALK_SPEED, RAT_MAX_WALK_SPEED)

		end
	end	
end



