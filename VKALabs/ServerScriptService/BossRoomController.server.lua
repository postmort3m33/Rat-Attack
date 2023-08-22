-- Services --
local DataStoreService = game:GetService("DataStoreService")

-- Create Data Storage --
local BestBossTimeDataStore = DataStoreService:GetOrderedDataStore("BestBossTimeDataStore5")

-- Boss times Variable --
local bossFightStartTime = 0
local bossFightEndTime = 0
local bossTimeFrame = workspace.Level.BossRoom.BossTimeWall.SurfaceGui.BossTimeFrame

-- Vars --
local playersInBossRoom = {}
local currentRatKing = nil
local bossFightStarted = false
local bossAndMinionsBeat = false
local fightResetting = false
local maxPlayersInBossRoom = 4
local minionObjects = {}

-- Health Stuff
local MINION_HEALTH = 333
local RATKING_HEALTH = 3333

-- Check Players in Boss Room timer
local lastPlayerHealthCheck = time()
local playerHealthCheckInterval = 0.5

-- Spawn Vars --
local ratKingSpawn = game.Workspace.RatSpawns:WaitForChild("RatKingSpawn")

---------------
-- Functions --
---------------

-- Only spawn Minion
local function SpawnMinion()
	
	-- Spawn new rat, with offset --
	local albinoRatClone = game.ServerStorage.Prefabs.RatAlbinoMinion:Clone()

	-- Place into Workspace --
	albinoRatClone.Parent = game.Workspace.RatKingMinions

	-- Set position -- 
	albinoRatClone.Torso.CFrame = ratKingSpawn.CFrame

	-- Nil
	albinoRatClone = nil		
	
end

-- Spawn New Rat King --
local function SpawnRatKing()

	-- Spawn new rat, with offset --
	local ratKingClone = game.ServerStorage.Prefabs.RatKing:Clone()

	-- Place into Workspace --
	ratKingClone.Parent = game.Workspace.RatKings

	-- Set position -- 
	ratKingClone.Torso.CFrame = ratKingSpawn.CFrame
	
	-- this is the current Ratking
	currentRatKing = ratKingClone
	
	-- Nil
	ratKingClone = nil
end

-- Save Boss time Data --
local function SaveNewBossTime(playerName, finalTime)
	
	-- Change Final time to an integer by x 100 --
	finalTime *= 1000
	finalTime = math.floor(finalTime)
	
	-- init Data
	local oldData = nil
	
	-- Protected Function --
	local success, errorMessage = pcall(function()
		
		-- First get Users current time --
		oldData = BestBossTimeDataStore:GetAsync(playerName)			
		
	end)
	
	-- If PCall was successful, (Data was Stored)
	if success then	
		
		-- If Old Data was nil meaning they didnt have a highscore yet.. --
		if oldData then
			
			-- Only Update New time if it beats old time --
			if finalTime < oldData then

				-- use a PCall to save player data --
				local success2, errorMessage2 = pcall(function()

					-- Save the data --
					local data2 = BestBossTimeDataStore:SetAsync(playerName, finalTime)

				end)				
			end				
		else -- There was no entry for that player.. make one..
			
			-- Make a new Entry --
			local success3, errorMessage3 = pcall(function()

				-- Save the data --
				local data3 = BestBossTimeDataStore:SetAsync(playerName, finalTime)

			end)			
		end				
	end
	
	-- NIl
	oldData = nil
end

-----------------
-- Connecitons --
-----------------

-- Player In Boss Toom event --
game.ReplicatedStorage.PlayerInBossRoom.Event:Connect(function(player)

	-- add this player to bossroom List if they are not already on it.. --
	if not table.find(playersInBossRoom, player) then

		-- Add Player
		table.insert(playersInBossRoom, player)	

	end	

	-- If Numplayers is 3, dont allow anymore in --
	if #playersInBossRoom == maxPlayersInBossRoom then

		-- fire Max players event --
		game.ReplicatedStorage.MaxPlayersInBossRoom:Fire()
	end

end)

-- Event Once TrapDoors Drop and BossFight starts --
game.ReplicatedStorage.BossFightStart.Event:Connect(function()

	-- Boss Fight Started --
	bossFightStarted = true

	-- Boss fight start timer --
	bossFightStartTime = time()
	
	-- Set Minion and Boss Proper Health..
	currentRatKing.Humanoid.Health = RATKING_HEALTH
	currentRatKing.Humanoid.MaxHealth = RATKING_HEALTH
	
	-- Set Minion Health..
	for _, minion in pairs(minionObjects) do

		-- If minion Humanoid Exists..
		if minion:FindFirstChild("Humanoid") then
			
			-- Set it
			minion.Humanoid.Health = MINION_HEALTH
			minion.Humanoid.MaxHealth = MINION_HEALTH
		end		
	end
end)

----------
-- Init --
----------

-- Init Boiss Time Frame..
bossTimeFrame.Visible = false

-- Let Level Load
task.wait(2)

-- Spawn An Initial RatKing and minions Before Running the Spawn Loop
SpawnRatKing()

-- Wait
task.wait()

-- Spawn 5 Small Albinos Too
for i = 1, 5 do

	-- Spawn a Minion
	SpawnMinion()
	
	-- Wait
	task.wait()

end

-- Set Minion Objects
minionObjects = game.Workspace.RatKingMinions:GetChildren()

----------------
-- While Loop --
----------------

while bossAndMinionsBeat == false do
	
	----------------------------------------------------------
	-- Always Check if any players in BosssRoom have died.. --
	----------------------------------------------------------
	
	-- Check every interval
	if (time() - lastPlayerHealthCheck) >= playerHealthCheckInterval then
		
		-- Update Tick
		lastPlayerHealthCheck = time()
		
		-- If there is more than one player.. --
		if #playersInBossRoom > 0 then

			-- Loop Players --
			for i, player in ipairs(playersInBossRoom) do

				if player.Character then

					-- Get Humanoid
					local playerHumanoid = player.Character:WaitForChild("Humanoid")

					-- Check Health --
					if playerHumanoid.Health <= 0 then

						-- delete this player from playerInBossRoom Array --
						table.remove(playersInBossRoom, i)

					end	

					-- Nil Stuff
					playerHumanoid = nil
				end
			end		
		end		
	end

	----------------------------
	-- Boss Fight Has started --
	----------------------------

	-- If the Boss Fight Has Started --
	if bossFightStarted then
		
		---------------------------------------
		-- Set RatKing to Nil when he dies.. --
		---------------------------------------
		if currentRatKing ~= nil then
			if currentRatKing.Humanoid.Health <= 0 then
				-- Make Current RatKing NIl
				currentRatKing = nil
			end		
		end

		-- Keep Minion Table Updated..
		if #minionObjects > 0 then
			for i, minion in ipairs(minionObjects) do

				-- If health is below zero.. nil it..
				if minion:FindFirstChild("Humanoid") then					
					if minion.Humanoid.Health <= 0 then

						-- Remove from table
						table.remove(minionObjects, i)
					end					
				end				
			end
		end		
		
		------------------------------------------
		-- Reset Boss Room When all Players Die --
		------------------------------------------	
		if (#playersInBossRoom == 0) and (currentRatKing or #minionObjects > 0) and fightResetting == false then
			
			-- All players Died Debounce
			fightResetting = true
			
			-- Reset BossFightStarted --
			bossFightStarted = false
			
			-- wait
			task.wait(5)		

			-- If RatKing was still alive, Destroy Him. --
			if currentRatKing then currentRatKing:Destroy() end			
			
			-- Destroy Minions..
			minionObjects = game.Workspace.RatKingMinions:GetChildren()
						
			-- Find ones to delete
			for _, minion in pairs(minionObjects) do
				
				-- Destroy it
				minion:Destroy()
			end
			
			------------------------------
			-- Respawn King and Minions --
			------------------------------
			
			-- Spawn Him
			SpawnRatKing()

			-- Wait
			task.wait()

			-- Spawn 5 Small Albinos Too
			for i = 1, 5 do

				-- Spawn a Minion
				SpawnMinion()

				-- Wait
				task.wait()

			end			
			
			-- Now Reset Minion Objects
			minionObjects = game.Workspace.RatKingMinions:GetChildren()
			
			-- If there are no more players in the room then the fight is ovr (false Flag) --
			game.ReplicatedStorage.BossFightOver:Fire(false) -- Fire False to Reset Fight when the werent beat....
			
			-- reset all players diued
			fightResetting = false
			
		end	
		
		-------------------------------
		-- Boss and Minions are beat --
		-------------------------------		
		if currentRatKing == nil and #minionObjects == 0 and bossAndMinionsBeat == false then
			
			-- Debounce
			bossAndMinionsBeat = true
			
			-- Boss fight End timer --
			bossFightEndTime = time()

			-- final time--
			local bossFightFinalTime = bossFightEndTime - bossFightStartTime

			-- Save Time to Data Store for all players --
			for _, player in pairs(playersInBossRoom) do

				-- Save Time --
				SaveNewBossTime(player.Name, bossFightFinalTime)				
			end	
			
			------------------------------------
			-- Paste Final Time on the wall.. --
			------------------------------------

			-- Make it visible
			bossTimeFrame.Visible = true
			
			-- Calculate it..
			local finalFormattedTime = (math.floor(bossFightFinalTime * 1000)) / 1000
			
			-- Apply it..
			bossTimeFrame.GameBeatTime.Text = finalFormattedTime .. "!"
			
			-- NIl
			finalFormattedTime = nil
			bossFightFinalTime = nil

			-- Wait 1 seconds
			task.wait(1)

			-- Reset BossFightstart --
			bossFightStarted = false

			-- Tell Server the BossFight is Over
			game.ReplicatedStorage.BossFightOver:Fire(true)
			
			--Wait
			task.wait(3)
			
			-- Complete Objevtive
			game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(16)
			
		end
	end	
	
	-- Wait
	task.wait()
end




