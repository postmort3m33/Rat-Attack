-- Services..
local PlayerService = game:GetService("Players")

-- Control Vars --
local START_TIME = 0 -- Default: 0

-- Vars --
local upTimeIntValue = script.UpTimeSeconds
local startGameConnection = nil

-- Round Vars
local CURRENT_ROUND = 1
local ROUND_TIME = 195 -- Seconds

-- Game Vars
local GAME_STARTED = false


----------
-- Init --
----------

-- Init at 0 --
upTimeIntValue.Value = 0

-- game Has Not Started Value
script.GameStarted.Value = false

---------------
-- Functions --
---------------

-- Update Current Round --
local function ChangeRound()
	
	-- Only Change rounds if the game has started..
	if GAME_STARTED then
		
		-- Add to Current Round
		CURRENT_ROUND += 1

		-- Fire new round to all Clients
		game.ReplicatedStorage.NewRound:FireAllClients(CURRENT_ROUND)

		-- Fire New Round on Server as well.. (Listening from MouseTrapsController Script)
		game.ServerStorage.ServerEvents.NewRound:Fire(CURRENT_ROUND)		
		
	end	
	
end

-----------------
-- Connections --
-----------------

-- When a Players Character is added.. Send them the Round...
PlayerService.PlayerAdded:Connect(function(player)
	
	-- When Character is Added.
	player.CharacterAdded:Connect(function(character)
		
		-- Wait for players GUI to load...
		task.wait(3)
		
		-- Send Round to Each Player
		game.ReplicatedStorage.SendRoundToClient:FireClient(player, CURRENT_ROUND)
	end)
end)

-- Wait until the game starts and then Re-start the Game Timer..
startGameConnection = game.ServerStorage.ServerEvents.StartGame.Event:Connect(function()
	
	-- Start Game
	GAME_STARTED = true
	
	-- Set Value
	script.GameStarted.Value = true
	
	-- Update Time
	upTimeIntValue.Value = START_TIME
	
	-- Disconnect
	startGameConnection:Disconnect()
	startGameConnection = nil	
end)

---------------
-- Main Loop --
---------------

-- Loop Timer..
while task.wait(1) do
	
	-- Update UpTime Value..
	upTimeIntValue.Value += 1
	
	-- Send Game Time to all clients..
	game.ReplicatedStorage.SendGameTimeSTC:FireAllClients(upTimeIntValue.Value)
	
	----------------------------
	-- Calculate Round Number --
	----------------------------

	-- Get Round Number..
	local round = (math.floor(upTimeIntValue.Value / ROUND_TIME)) + 1

	-- Only Change Current Round if its a different Value
	if round ~= CURRENT_ROUND then

		-- Change Round
		ChangeRound()

	end	
	
	-- Nil Stuff
	round = nil	
	
end
