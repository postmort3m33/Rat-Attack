-------------------------------------------------------------------------
-- This Script defines leaderstat folders for every player that joins  --
-- and Connects the proper events to save players inventory upon death --
-- Joshua Touchstone 10/12/2022 -----------------------------------------

-- Services --
local DataStoreService = game:GetService("DataStoreService")
local PlayerService = game:GetService("Players")

-- Turn off AutoLoads
PlayerService.CharacterAutoLoads = false

-- Create Data Storage --
local MostRatsKilledDataStore = DataStoreService:GetOrderedDataStore("MostRatsKilledDataStore1")
local BestGameTimeDataStore = DataStoreService:GetOrderedDataStore("BestGameTimeDataStore1")
local FinishedTutorialDataStore = DataStoreService:GetDataStore("FinishedTutorialDataStore1")
local MostCheeseThrownDataStore = DataStoreService:GetOrderedDataStore("MostCheeseThrownDataStore1")
local MostFragsThrownDataStore = DataStoreService:GetOrderedDataStore("MostFragsThrownDataStore1")
local MostTimePlayedDataStore = DataStoreService:GetOrderedDataStore("MostTimePlayedDataStore1")
local MostCoffeeDrankDataStore = DataStoreService:GetOrderedDataStore("MostCoffeeDrankDataStore1")

-- Starting Vars --
local STARTING_SKULLS = 0 -- Default: 0
local STARTING_HEALTH = 150 -- Default: 150+
local STARTING_LIVES = 6
local STARTING_BLOOD = 0
local STARTING_WALKSPEED = 16
local DEATH_WAIT_TIME = 9

-- State Vars
local GAME_STARTED = false
local GAME_START_TIMESTAMP = 0

-- Objects --
local deathSpawnObject = workspace.Level.DeathRoom.DeathSpawn
local initialSpawn = workspace.CutsceneStuff.SwatVan.InitialSpawn
local gameSpawn = workspace.GameSpawn

-- Key Items Table
local keyItemsTable = {"AerosolCan", "Battery", "ElectronicComponent", "Fuse", 
	"PropaneTank", "RatDead", "SawBlade", "VialEmpty", "VialWithAcid",
	"VialWithAlbinoBlood", "VialWithPlasma", "VialWithPoison", "VialGunWithPoison", "FoggerMachine",
	"FoggerMachineModded"
}

---------------
-- Functions --
---------------

-- Function that creates all player stats/folder
local function CreatePlayerValues(player)
	
	-----------------
	-- LeaderStats --
	-----------------

	-- Create New LeaderStats Folder Inside of the Player --
	local leaderstats = Instance.new("Folder", player)
	leaderstats.Name = "leaderstats"
	
	-- Add Skulls Count --
	local skulls = Instance.new("IntValue", leaderstats)
	skulls.Name = "skulls"
	skulls.Value = STARTING_SKULLS

	-- Add Rat Killed Count --
	local ratskilled = Instance.new("IntValue", leaderstats)
	ratskilled.Name = "ratskilled"
	ratskilled.Value = 0
	
	-- Boolean determining wether player recieved proper Ratskilled from DataStore..
	local gotRatsKilled = Instance.new("BoolValue", player)
	gotRatsKilled.Name = "gotratskilled"
	gotRatsKilled.Value = false
	
	----------------------------------
	-- Item/Lives/Savedtools Values --
	----------------------------------
	
	-- Player Lives
	local lives = Instance.new("IntValue", player)
	lives.Name = "lives"
	lives.Value = STARTING_LIVES

	-- Player "Rat Blood"
	local blood = Instance.new("IntValue", player)
	blood.Name = "blood"
	blood.Value = STARTING_BLOOD

	-- Folder For Saved Inventory
	local savedtools = Instance.new("Folder", player)
	savedtools.Name = "savedtools"
	
	--------------------
	-- tutorial Stuff --
	--------------------	

	-- Player has Finished tutorial..
	local finishedTutorial = Instance.new("BoolValue", player)
	finishedTutorial.Name = "finishedtutorial"
	finishedTutorial.Value = false

	-- Player has recieved Blood tutorial..
	local gotBloodObjective = Instance.new("BoolValue", player)
	gotBloodObjective.Name = "gotbloodobjective"
	gotBloodObjective.Value = false

	-- Player has Finished Blood tutorial..
	local completedBloodObjective = Instance.new("BoolValue", player)
	completedBloodObjective.Name = "completedbloodobjective"
	completedBloodObjective.Value = false	

	------------------
	-- Weapon Stuff --
	------------------

	-- the Folder
	local weaponlevels = Instance.new("Folder", player)
	weaponlevels.Name = "weaponlevels"

	-- Plasma Gun
	local plasmagundamagelevel = Instance.new("IntValue", weaponlevels)
	plasmagundamagelevel.Name = "plasmagundamagelevel"
	plasmagundamagelevel.Value = 1
	local plasmagunradiuslevel = Instance.new("IntValue", weaponlevels)
	plasmagunradiuslevel.Name = "plasmagunradiuslevel"
	plasmagunradiuslevel.Value = 1

	-- Nail Gun
	local nailgundamagelevel = Instance.new("IntValue", weaponlevels)
	nailgundamagelevel.Name = "nailgundamagelevel"
	nailgundamagelevel.Value = 1
	local nailgunspecialupgrade = Instance.new("BoolValue", weaponlevels)
	nailgunspecialupgrade.Name = "nailgunspecialupgrade"
	nailgunspecialupgrade.Value = false

	-- Crossbow
	local crossbowexplosivedamagelevel = Instance.new("IntValue", weaponlevels)
	crossbowexplosivedamagelevel.Name = "crossbowexplosivedamagelevel"
	crossbowexplosivedamagelevel.Value = 1
	local crossbowexplosiveradiuslevel = Instance.new("IntValue", weaponlevels)
	crossbowexplosiveradiuslevel.Name = "crossbowexplosiveradiuslevel"
	crossbowexplosiveradiuslevel.Value = 1

	-- vial gun
	local vialgundamagelevel = Instance.new("IntValue", weaponlevels)
	vialgundamagelevel.Name = "vialgundamagelevel"
	vialgundamagelevel.Value = 1
	local vialgunradiuslevel = Instance.new("IntValue", weaponlevels)
	vialgunradiuslevel.Name = "vialgunradiuslevel"
	vialgunradiuslevel.Value = 1

	-- BB Gun
	local bbgundamagelevel = Instance.new("IntValue", weaponlevels)
	bbgundamagelevel.Name = "bbgundamagelevel"
	bbgundamagelevel.Value = 1
	local bbgunspecialupgrade = Instance.new("BoolValue", weaponlevels)
	bbgunspecialupgrade.Name = "bbgunspecialupgrade"
	bbgunspecialupgrade.Value = false

	-- Flamethrower
	local flamethrowerdamagelevel = Instance.new("IntValue", weaponlevels)
	flamethrowerdamagelevel.Name = "flamethrowerdamagelevel"
	flamethrowerdamagelevel.Value = 1

	-- AirBlaster
	local airblasterdamagelevel = Instance.new("IntValue", weaponlevels)
	airblasterdamagelevel.Name = "airblasterdamagelevel"
	airblasterdamagelevel.Value = 1
	local airblasterpowerlevel = Instance.new("IntValue", weaponlevels)
	airblasterpowerlevel.Name = "airblasterpowerlevel"
	airblasterpowerlevel.Value = 1

	-- Shot Gun
	local shotgundamagelevel = Instance.new("IntValue", weaponlevels)
	shotgundamagelevel.Name = "shotgundamagelevel"
	shotgundamagelevel.Value = 1
	
	-----------------------------
	-- Other LEaderboard Stuff --
	-----------------------------
	
	local coffeesdrank = Instance.new("IntValue", player)
	coffeesdrank.Name = "coffeesdrank"
	coffeesdrank.Value = 0
	
	-- Throwables Stuff
	local cheesesthrown = Instance.new("IntValue", player)
	cheesesthrown.Name = "cheesesthrown"
	cheesesthrown.Value = 0
	
	local fragsthrown = Instance.new("IntValue", player)
	fragsthrown.Name = "fragsthrown"
	fragsthrown.Value = 0
	
end

-- Function Runs once when a New Player joins the game (NOT RESPAWN) --
function playerSpawned(player)
	
	-- Create Player Values
	CreatePlayerValues(player)
	
	---------------------------------
	-- Retrieve Stored Rats Killed --
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
		player.leaderstats.ratskilled.Value = data
		
		-- Got Rats Killed
		player.gotratskilled.Value = true
		
	else
		
		-- if theyu didnt have data, still got rats killed..
		if not data then
			
			-- Update Player Data --
			player.leaderstats.ratskilled.Value = 0
			
			-- Got Rats Killed
			player.gotratskilled.Value = true
			
		end
	end
	
	-- just wait
	task.wait()
	
	--------------------------------------
	-- Retrieve Most Cheese Thrown Data --
	--------------------------------------

	-- Create the data variable --
	data = nil

	-- use a PCall --
	local success, errorMessage = pcall(function()

		-- Retrieve Data --
		data = MostCheeseThrownDataStore:GetAsync(player.Name)
	end)

	-- If it was succesfful, write to skull value --
	if success and data ~= nil then

		-- Update Player Data --
		player.cheesesthrown.Value = data

	end

	-- just wait
	task.wait()
	
	--------------------------------------
	-- Retrieve Most Frags Thrown Data --
	--------------------------------------

	-- Create the data variable --
	data = nil

	-- use a PCall --
	local success, errorMessage = pcall(function()

		-- Retrieve Data --
		data = MostFragsThrownDataStore:GetAsync(player.Name)
	end)

	-- If it was succesfful, write to skull value --
	if success and data ~= nil then

		-- Update Player Data --
		player.fragsthrown.Value = data

	end

	-- just wait
	task.wait()
	
	--------------------------------------
	-- Retrieve Most Coffee Drank Data --
	--------------------------------------

	-- Create the data variable --
	data = nil

	-- use a PCall --
	local success, errorMessage = pcall(function()

		-- Retrieve Data --
		data = MostCoffeeDrankDataStore:GetAsync(player.Name)
	end)

	-- If it was succesfful, write to skull value --
	if success and data ~= nil then

		-- Update Player Data --
		player.coffeesdrank.Value = data

	end

	-- just wait
	task.wait()
	
	
	--[[
	-------------------------------------
	-- Did Player already do Tutorial? --
	-------------------------------------
	
	-- Create the data variable --
	data = nil

	-- use a PCall --
	local success, errorMessage = pcall(function()

		-- Retrieve Data --
		data = FinishedTutorialDataStore:GetAsync(player.UserId)
	end)

	-- If it was succesfful, write to skull value --
	if success and data ~= nil then
		
		-- Bool
		local aBool = false
		
		-- If
		if data == "true" then
			
			-- Set
			aBool = true
		else
			
			-- Set
			aBool = false
		end

		-- Update Player Data --
		player.finishedtutorial.Value = aBool

	end
	]]
	
	---------------------------------------------
	-- Function When Player Character is Added --
	---------------------------------------------
	
	-- On Character Added Function --
	local function OnCharacterAdded(character)
		
		-----------------------------------
		-- Raise Every Players MaxHealth --
		-----------------------------------
		character.Humanoid.MaxHealth = STARTING_HEALTH
		character.Humanoid.Health = STARTING_HEALTH
		character.Humanoid.WalkSpeed = STARTING_WALKSPEED

		-- Load Saved Tools onto Players Character..
		for _, tool in pairs(player.savedtools:GetChildren()) do

			-- Put tool in Backpack
			tool.Parent = player:WaitForChild("Backpack")
			
			-- Wait
			task.wait()

		end
		
		-- Re-enable Player GUI
		if GAME_STARTED then
			
			-- Wait for Main GUI
			local mainGUI = player.PlayerGui:WaitForChild("MainGUI")
			
			-- Wait for ToolHandler..
			while not player.Character do task.wait() end
			local toolHandler = player.Character:WaitForChild("ToolHandler")
			local pingHandler = player.Character:WaitForChild("PingHandler")
			
			-- Wait
			task.wait()

			-- Enable
			player.PlayerGui.MainGUI.Enabled = true
			player.PlayerGui.MainGUI.MainGUIController.Enabled = true
			player.Character.ToolHandler.Enabled = true
			player.Character.PingHandler.Enabled = true
			
			-- Nil Stuff
			mainGUI = nil
			toolHandler = nil
			pingHandler = nil
		end
		
		-- Ran when player dies..
		local function OnDied()
			
			-- Old Code to support not losing lives when upstairs.. --
			-- if player.Character.PrimaryPart.Position.Y < 22 and player.lives.Value > 0 then --

			-- Only lose a life if you were downstairs..
			if player.lives.Value > 0 then

				-- Tell CLient Someone Died for GUI..
				game.ReplicatedStorage.PlayerDiedSTC:FireAllClients(player.Name)

				-- Lose a Life
				player.lives.Value -= 1

				-- Lose All Blood
				player.blood.Value = 0
				
				-- Save Tools in Backpack --
				for _, tool in pairs(player.Backpack:GetChildren()) do

					-- If its not the flashlight..
					if tool.Name ~= "Flashlight" and tool.Name ~= "BBGun" then

						-- Move Tool to Savedtools
						tool.Parent = player.savedtools

					end
				end

				-- Save the Tool In Hand --
				for _, child in pairs(player.Character:GetChildren()) do

					-- If its a tool..
					if child:IsA("Tool") then

						-- If its not the flashlight..
						if child.Name ~= "Flashlight" and child.Name ~= "BBGun" then

							-- Move tool to savedtools
							child.Parent = player.savedtools

						end
					end
				end

				-- Wait
				task.wait(DEATH_WAIT_TIME)

				-- Reload Character if still exists
				if player.Parent == game.Players then
					
					player:LoadCharacter()
					
					-- Spawn Character Based on wether game has started or not..
					if GAME_STARTED == false then

						-- Spawn in Van for Cutscene
						player.Character.PrimaryPart.CFrame = initialSpawn.CFrame

					else

						-- If out of lives..
						if player.lives.Value <= 0 then

							-- Move To Death Room
							player.Character.PrimaryPart.CFrame = deathSpawnObject.CFrame						

						else

							-- Spawn in Weapons Room
							player.Character.PrimaryPart.CFrame = gameSpawn.CFrame * CFrame.new(math.random(-20,20), 3 , math.random(-20,20))						

						end
					end					
				end				
			else
				
				--------------------------------------------------------------
				-- Player Reset himself after entering the game over room.. --
				--------------------------------------------------------------
				
				-- Save Tools in Backpack --
				for _, tool in pairs(player.Backpack:GetChildren()) do

					-- If its not the flashlight..
					if tool.Name ~= "Flashlight" and tool.name ~= "BBGun" then

						-- Move Tool to Savedtools
						tool.Parent = player.savedtools

					end
				end

				-- Save the Tool In Hand --
				for _, child in pairs(player.Character:GetChildren()) do

					-- If its a tool..
					if child:IsA("Tool") then

						-- If its not the flashlight..
						if child.Name ~= "Flashlight" and child.Name ~= "BBGun" then

							-- Move tool to savedtools
							child.Parent = player.savedtools

						end
					end
				end

				-- Wait
				task.wait(5)

				-- Reload Character..
				if player.Parent == game.Players then
					
					-- Load
					player:LoadCharacter()
					
					-- Move To Death Room
					player.Character.PrimaryPart.CFrame = deathSpawnObject.CFrame			
					
				end				
			end
		end

		-- Connection for When the Player dies..
		character.Humanoid.Died:Connect(OnDied)	
	end
	
	-- Connection for Player character Added --
	player.CharacterAdded:Connect(OnCharacterAdded)
	
	-----------------------------------------------
	-- Function When Player Character is Removed --
	-----------------------------------------------
	
	-- Character Removed Function..
	local function OnCharacterRemoved(character)
		
		-- If player is holding key item
		for _, child in pairs(player.Character:GetChildren()) do
			
			-- If its a tool..
			if child:IsA("Tool") then
				
				-- Move it to the players Backpack..
				child.Parent = player.Backpack
			end
		end		
	end
	
	-- Connection
	player.CharacterRemoving:Connect(OnCharacterRemoved)
	
	----------------------------
	-- Default Character Load --
	----------------------------
	
	-- Load Character
	if player.Parent == game.Players then
		
		-- Load
		player:LoadCharacter()
		
		-- Spawn in Van..
		player.Character.PrimaryPart.CFrame = initialSpawn.CFrame * CFrame.new(math.random(-4,4) , 0, 0)
		
	end	
end

-- Fcuntion runs when a Player is about to leave the game --
function playerRemoving(player)
	
	----------------------------------------------------------------------
	-- If Player holds any key items, transfer them to another player.. --
	----------------------------------------------------------------------

	-- Get Player Tools
	local playerTools = player.Backpack:GetChildren()

	-- Get List of All PLayers..
	local playerList = game.Players:GetPlayers()

	-- If no players, leave
	if #playerList > 0 then
		
		-- Loop through to see if any are key Items..
		for _, tool in pairs(playerTools) do

			-- Search Table
			if table.find(keyItemsTable, tool.Name) then

				-- Move this tool to a random players inventory..
				tool.Parent = playerList[math.random(1, #playerList)].Backpack

			end
		end		
	end

	-- Nil Stuff
	playerTools = nil
	playerList = nil	
	
	-----------------------------------
	-- Set Players Rats Killed Data  --
	-----------------------------------
	
	-- If we got rats killed in beginning og game.., then update it..
	if player.gotratskilled.Value == true then		

		-- Add these kills to Current Kills.
		local success, errorMessage = pcall(function()

			-- Save the data --
			MostRatsKilledDataStore:SetAsync(player.Name, player.leaderstats.ratskilled.Value)

		end)	
	end
	
	--------------------------------
	-- Set Most Coffee Drank Data --
	--------------------------------

	-- Add these kills to Current Kills.
	local success, errorMessage = pcall(function()

		-- Save the data --
		MostCoffeeDrankDataStore:SetAsync(player.Name, player.coffeesdrank.Value)

	end)	
	
	-- wait
	task.wait()
	
	---------------------------------
	-- Set Most Cheese Thrown Data --
	---------------------------------
	
	-- Add these kills to Current Kills.
	local success, errorMessage = pcall(function()

		-- Save the data --
		MostCheeseThrownDataStore:SetAsync(player.Name, player.cheesesthrown.Value)

	end)	
	
	--wati
	task.wait()
	
	--------------------------------
	-- Set Most Frags Thrown Data --
	--------------------------------

	-- Add these kills to Current Kills.
	local success, errorMessage = pcall(function()

		-- Save the data --
		MostFragsThrownDataStore:SetAsync(player.Name, player.fragsthrown.Value)

	end)	
	
	-- Wait
	task.wait()
	
	--------------------------------
	-- Set Most Hours Played Data --
	--------------------------------
	
	-- If Game Hasnt Started... Dont do Game Time..
	if not GAME_STARTED then return end
	
	-- Get Saved Playtime..
	local data = nil
	
	-- Get Playtime..
	local playTime = math.floor(time() - GAME_START_TIMESTAMP)
	
	-- Get Current Playtime..
	local success, errorMessage = pcall(function()

		-- Save the data --
		data = MostTimePlayedDataStore:GetAsync(player.Name)

	end)	
	
	-- If we got the data
	if success then
		
		if data ~= nil then

			-- Now set new time..
			local success, errorMessage = pcall(function()

				-- Save the data --
				MostTimePlayedDataStore:SetAsync(player.Name, data + playTime)

			end)	

		else -- Didnt have any data..
			
			-- Now set new time..
			local success, errorMessage = pcall(function()

				-- Save the data --
				MostTimePlayedDataStore:SetAsync(player.Name, playTime)

			end)
		end		
	end
	
	-- wait
	task.wait()
	
end

-----------------
-- Connections --
-----------------

-- When Game has been beat..
game.ReplicatedStorage.MissionEvents.ScientistClearedWarehouseSTS.Event:Connect(function()
	
	-- Get Final GameTime..
	local finalTime = (time() - GAME_START_TIMESTAMP) * 1000
	finalTime = math.floor(finalTime)	
	
	-- Get players..
	local playerList = game.Players:GetPlayers()
	
	-- Loop through
	for _, player in pairs(playerList) do
		
		-- Get humanoid.
		if player.Character then
			
			-- Humanoid
			local humanoid = player.Character:WaitForChild("Humanoid")
			
			-- Give Tons of Health...
			humanoid.MaxHealth = 150000
			humanoid.Health = 150000
			
		end
		
		----------------------------------
		-- Save Player Beat Game Time.. --
		----------------------------------
		
		-- init Data
		local oldData = nil
		local newRecord = false

		-- Protected Function --
		local success, errorMessage = pcall(function()

			-- First get Users current time --
			oldData = BestGameTimeDataStore:GetAsync(player.Name)

		end)

		-- If PCall was successful, (Data was Retrieved)
		if success then	

			-- If Old Data was nil meaning they didnt have a highscore yet.. --
			if oldData then

				-- Only Update New time if it beats old time --
				if finalTime < oldData then
					
					-- Was new Record
					newRecord = true

					-- use a PCall to save player data --
					local success2, errorMessage2 = pcall(function()

						-- Save the data --
						local data2 = BestGameTimeDataStore:SetAsync(player.Name, finalTime)

					end)				
				end				
			else -- There was no entry for that player.. make one..

				-- Make a new Entry --
				local success3, errorMessage3 = pcall(function()

					-- Save the data --
					local data3 = BestGameTimeDataStore:SetAsync(player.Name, finalTime)

				end)			
			end				
		end
		
		-- Send Game Time Data to All Clients...
		game.ReplicatedStorage.SendGameTimeDataSTC:FireClient(player, finalTime, tostring(newRecord)) -- Listening from MainGUI to display game time..

		-- NIl
		oldData = nil
		
		-- Wait
		task.wait()
	end
end)

-- Check for when the game starts to spawn character in the proper area..
game.ServerStorage.ServerEvents.StartGame.Event:Connect(function()
	
	-- Set it
	GAME_STARTED = true
	
	-- Set Game Start Time_STAMP..
	GAME_START_TIMESTAMP = time()
	
end)

-- Every time a player joins..
PlayerService.PlayerAdded:Connect(playerSpawned)

-- Every Time a Player Leaves the Game --
PlayerService.PlayerRemoving:Connect(playerRemoving)

-- Bind this function to run before this server shuts down --
game:BindToClose(function()
	
	-- If players are still in the lobby, Kick them.. --
	-- which calls the PlayerRemoving function in this script --
	for i, player in pairs(PlayerService:GetChildren()) do
		
		-- Kick Each player --
		player:Kick("Server Closed")
	end
	
	-- Wait
	wait(2)
end)