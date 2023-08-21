----------------------------------------------------------------------------------
-- Waits for up to MAX_PLAYERS to join the lobby then fires "Start Game" event. --
----------------------------------------------------------------------------------

-- Services --
local PlayerService = game:GetService("Players")

-- State Vars
local CUTSCENE_STARTED = false
local startGameEventRunning = false

-- Connections --
local numPlayers = 0
local playerAddedConnection = nil

-- Van Seats
local filledSeatsArray = {}
local playerInSeatArray = {}
local seat1 = workspace.CutsceneStuff.SwatVan.CabAndBed.Seat1
local seat2 = workspace.CutsceneStuff.SwatVan.CabAndBed.Seat2
local seat3 = workspace.CutsceneStuff.SwatVan.CabAndBed.Seat3
local seat4 = workspace.CutsceneStuff.SwatVan.CabAndBed.Seat4
local seatArray = {seat1, seat2, seat3, seat4}

-- Player/Character Table
local playersReadyTable = {}

-----------------
-- Connections --
-----------------

-- Only Start Player Stuff when Client has Loaded in...
game.ReplicatedStorage.CutSceneEvents.ClientLoadedInToServer.OnServerEvent:Connect(function(player)
	
	-- Make Sure Character is loaded on server..
	if not player.Character then player.CharacterAdded:Wait() end
	
	---------------------------------------
	-- Add Player to Player Joined Table --
	---------------------------------------

	-- If Player Is already in table, leave function..
	if table.find(playersReadyTable, player) then return end

	-- Add this Player to the Players Ready Table
	table.insert(playersReadyTable, player)	
	
end)

-- When Player is Added..
playerAddedConnection = PlayerService.PlayerAdded:Connect(function(player)
	
	-- When Character Added..
	player.CharacterAdded:Connect(function(character)

		------------------------------------------
		-- M0ve Player into an available seat.. --
		------------------------------------------

		-- Wait a few seconds..
		task.wait(3)
		
		-- Wait until humanoid is accessible
		local thisHumanoid = character:WaitForChild("Humanoid")
		
		-- Freeze Jump and Movement Power
		thisHumanoid.WalkSpeed = 0
		thisHumanoid.JumpPower = 0
		
		-- Wait random time
		task.wait(math.random(10,30) * 0.1)

		-- Place them into an empty seat in the van..
		if #filledSeatsArray > 0 then

			-- Loop through seat array..
			for _, seat in pairs(seatArray) do

				-- Check if its already filled..
				if table.find(filledSeatsArray, seat) then continue end
				
				-- Add to Array
				table.insert(filledSeatsArray, seat)
				
				-- Set player in seat
				table.insert(playerInSeatArray, {seat, player})

				-- Move Character to Proper Seat..
				seat:Sit(thisHumanoid)			

				-- Break
				break
			end

		else
			
			-- Seat filled
			table.insert(filledSeatsArray, seat1)
			
			-- Set player in seat
			table.insert(playerInSeatArray, {seat1, player})

			-- Make Player Sit
			seat1:Sit(thisHumanoid)
			
		end

		-- Nil Stuff
		thisHumanoid = nil
		
	end)	
end)

---------------
-- Main Loop --
---------------

-- Wait until all players join.
while #PlayerService:GetPlayers() == 0 do task.wait(1) end

-- While the game has not been started.. run
while CUTSCENE_STARTED == false do
	
	-- If we have enough players, start the game
	if #playersReadyTable >= #PlayerService:GetPlayers() and startGameEventRunning == false then

		-- Debounce
		startGameEventRunning = true

		-- Wait
		task.wait(3)
		
		-- Game started
		CUTSCENE_STARTED = true

		-- Open Game Door
		game.ServerStorage.ServerEvents.StartCutScene:Fire()

		-- Let Cleint Know Cutscene Has Started..
		game.ReplicatedStorage.CutSceneEvents.CutSceneStartedFromServer:FireAllClients()

		-- Disconnect Player Connection
		playerAddedConnection:Disconnect()
		playerAddedConnection = nil
		
	end
	
	-- Wait
	task.wait(1)
end

-- Destroy Script..
task.wait(3)

-- Destroy
script:Destroy()
