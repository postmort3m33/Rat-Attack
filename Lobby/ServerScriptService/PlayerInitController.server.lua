-- Services --
local DataStoreService = game:GetService("DataStoreService")
local PlayerService = game:GetService("Players")

-- Turn off AutoLoads
PlayerService.CharacterAutoLoads = false

-- Objects --
local mainSpawnObject = workspace.Level.SpawnLocation

-- Create Data Storage --
local MostRatsKilledDataStore = DataStoreService:GetOrderedDataStore("MostRatsKilledDataStore1")

---------------
-- Functions --
---------------

-- Function Runs once when a New Player joins the game (NOT RESPAWN) --
function playerSpawned(player)
	
	----------------------------------------
	-- Create Leaderstats and Handle data --
	----------------------------------------

	-- Create New LeaderStats Folder Inside of the Player --
	local leaderstats = Instance.new("Folder", player)
	leaderstats.Name = "leaderstats"

	-- Add Rat Killed Count --
	local ratskilled = Instance.new("IntValue", leaderstats)
	ratskilled.Name = "ratskilled"
	ratskilled.Value = 0
	
	---------------------------------
	-- Retrieve Stored Player Data --
	---------------------------------

	-- Create the data variable --
	local data = nil

	-- use a PCall --
	local success, errorMessage = pcall(function()

		-- Retrieve Data --
		data = MostRatsKilledDataStore:GetAsync(player.Name)
	end)

	-- If it was succesfful, write to skull value --
	if success and data ~= nil then

		-- Update Player Data --
		ratskilled.Value = data
	end	
	
	-- just wait
	task.wait()
	
	-- On Character Added Function --
	local function OnCharacterAdded(character)
		
		-- Move to Spawn Area
		player.Character.PrimaryPart.CFrame = mainSpawnObject.CFrame		
		
		-- Function to Save Tools on player Death --
		local function OnDied()

			-- Wait
			task.wait(5)

			-- Reload Character..
			player:LoadCharacter()
			
		end

		-- Connection for When the Player dies..
		character.Humanoid.Died:Connect(OnDied)
		
		-- Wait
		task.wait()

	end
	
	-- Connection for Player character Added --
	player.CharacterAdded:Connect(OnCharacterAdded)
	
end

-----------------
-- Connections --
-----------------

-- Every time a player joins..
PlayerService.PlayerAdded:Connect(playerSpawned)

-- When Player Pressed Play, Load their Character..
game.ReplicatedStorage.PlayButtonPressedLocally.OnServerEvent:Connect(function(player)

	-- Load character
	player:LoadCharacter()

end)