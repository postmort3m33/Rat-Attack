-- Wait a few seconds before running script --
task.wait(1) --  ** This fixes Changing Network Ownership to the Server but WHY? ** --

-- Service Init --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local DebrisService = game:GetService("Debris")
local PhysicsService = game:GetService("PhysicsService")

-- Character Vars --
local thisRat = script.Parent.Parent
local thisHumanoid = thisRat:WaitForChild("Humanoid")
local thisRatPrimaryPart = thisRat.PrimaryPart
local thisRatPos = nil

-- Dont display health or name..
thisHumanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

-- Value Vars --
local distanceToPlayer = 0

-- Targeting Vars --
local nearestPlayer = nil
local nearestPlayerPos = nil
local targetPlayerWait = 3 -- TARGET PLAYER INTERVAL --
local lastTargetPlayer = time()

-- Animation Vars --
local walkAnim = script:WaitForChild("Walk")
local walkAnimTrack = thisHumanoid.Animator:LoadAnimation(walkAnim)

-- Roaming Variables
local changeRandomWayPointInterval = 3
local lastChangeRandomWaypoint = time()

-- Sound Vars --
local lastSqueak = time()
local squeakWait = 0
local ratSqueak1 = script.Parent.Parent.Torso.Squeak1
local ratSqueak2 = script.Parent.Parent.Torso.Squeak2
local ratSqueak3 = script.Parent.Parent.Torso.Squeak3
local ratSqueak4 = script.Parent.Parent.Torso.Squeak4
local ratScratching = script.Parent.Parent.Torso.ratScratching
local ratDieSqueak1 = script.Parent.Parent.Torso.DieSqueak
local ratDieSqueak2 = script.Parent.Parent.Torso.DieSqueak2
local ratDieSqueak3 = script.Parent.Parent.Torso.DieSqueak3

-- Players in BossRoom
local playersInBossRoom = {}

-- Damage Variables --
local damage = 18
local attackDistance = 4 -- higher than Stop Distance
local attackWait = 1.25 -- in seconds
local lastAttack = time()

-- Dieing Variables --
local ratDieing = false
local transparency = 0

-- Aggressive Jumping Stuff
local lastJump = time()
local jumpInterval = 1
local startJumpingDistance = 20

-- Post Variable Wait
task.wait()

---------------------------
-- Initializiation Stuff --
---------------------------
-- Network OwnerShip on Character for all server-handling --
for _, object in pairs(thisRat:GetChildren()) do 
	
	-- If we found a basepart..
	if object:IsA("BasePart") then
		
		-- Set the Network Owner
		object:SetNetworkOwner()
		
	end
end

--------------------------------------------------------------------------
-- Functions -------------------------------------------------------------
--------------------------------------------------------------------------

-- Function to Calculate Rat Squeaking --
local function RatSqueaking()

	-- Only Squeak every time interval --
	if (time() - lastSqueak) >= squeakWait then

		-- Reset Last Squeak
		lastSqueak = time()

		-- Set Random squeakInterval
		squeakWait = math.random(3,9)

		-- Designate Random Spawn --
		local randomSpawnNumber = math.random(1,4)
		
		-- Random Squeak Sound
		local chosenSqueakSound = nil

		-- Choose Room --
		if randomSpawnNumber == 1 then
			chosenSqueakSound = ratSqueak1
		elseif randomSpawnNumber == 2 then
			chosenSqueakSound = ratSqueak2
		elseif randomSpawnNumber == 3 then
			chosenSqueakSound = ratSqueak3
		elseif randomSpawnNumber == 4 then
			chosenSqueakSound = ratSqueak4
		end


		-- Play it --
		chosenSqueakSound:Play()			
		
		-- Nil
		randomSpawnNumber = nil
		chosenSqueakSound = nil

	end		
end

-- Rat Roam Around --
local function Roam()
	
	-- Random Waypoint
	local randomWaypoint = nil

	-- Move to a different waypoint every interval --
	if (time() - lastChangeRandomWaypoint) >= changeRandomWayPointInterval then	

		-- Update This Change --
		lastChangeRandomWaypoint = time()

		-- Change Interval Time --
		changeRandomWayPointInterval = math.random(1,3)

		-- Calculate a random direction vector --
		randomWaypoint = Vector3.new(			
			thisRatPos.X + (math.random(-15,15)),0,
			thisRatPos.Z + (math.random(-15,15))
		)		
	end		
	
	-- Move Rat to random waypoint
	if randomWaypoint then

		-- Check if we reached the wayPoint --
		local distanceToWaypoint = (randomWaypoint - thisRatPos).Magnitude		

		-- If we are not near Waypoint.. move to it --
		if distanceToWaypoint > 4 then	
			
			-- Send Rat to Waypoint --
			thisHumanoid:MoveTo(randomWaypoint)	
			
		else
			
			-- Stop Moving
			thisHumanoid:MoveTo(thisRatPos)
		end	
		
		-- nil
		distanceToWaypoint = nil
	end	
end

-- Find Nearest Player -- 
function TargetNearestPlayer()

	-- Found player Vars --
	local localNearestPlayer = nil
	local distance = nil
	
	-- If there is a playerTable..
	if #playersInBossRoom > 0 then
		
		-- Loop to find nearest player --
		for _, player in pairs(playersInBossRoom) do

			-- Dont run Function unless the Players are lloaded up yet -- 
			if player.Character then
				
				-- If player is dead, return function with nil --
				if player.Character.Humanoid.Health <= 0 then

					-- Break the loop for that player -
					continue
				end	
				
				-- Define Player Position --
				local playerPos = player.Character.PrimaryPart.Position		

				-- Distance to this Player in the loop (Found Player position - This Position)
				local distanceVector = playerPos - thisRatPos					

				-- If nearestPlayer is not set yet, set it to first PLayer
				if not localNearestPlayer then 	-- FIRST ONE-TIME LOOP IF STATEMENT --

					-- set this player to nearest player
					localNearestPlayer = player

					-- Set Distance and Direction to New nearest Player
					distance = distanceVector.Magnitude	


				elseif distanceVector.Magnitude < distance then

					-- set this player to nearest player
					localNearestPlayer = player

					-- Set Distance and Direction to this player
					distance = distanceVector.Magnitude
				end	

				-- NIl
				playerPos = nil
				distanceVector = nil
			end
		end		
	end
	
	-- NIl Stuff
	distance = nil	
	
	------------------------------------------------------------
	-- Determine if there is a successful path to this player --
	------------------------------------------------------------
	
	-- Return
	return localNearestPlayer
end

-----------------
-- Connections --
-----------------

-- Running event -- If we are moving --
thisHumanoid.Running:Connect(function(speed)

	-- Only Animate if Alive
	if thisHumanoid.Health > 0 then

		-- Based on Speed
		if speed > 0 then

			-- Play Moving Sound
			if not ratScratching.IsPlaying then
				ratScratching:Play()
			end		

			if not walkAnimTrack.IsPlaying then
				walkAnimTrack:Play()
			end
		else

			-- Stop Walking Sound
			if ratScratching.IsPlaying then
				ratScratching:Stop()
			end

			if walkAnimTrack.IsPlaying then
				walkAnimTrack:Stop()
			end
		end		

	end

end)

-- Player In Boss Toom event --
game.ReplicatedStorage.PlayerInBossRoom.Event:Connect(function(player)

	-- add this player to bossroom List if they are not already on it.. --
	if not table.find(playersInBossRoom, player) then

		-- Add Player
		table.insert(playersInBossRoom, player)	
	end

end)

-- Listen for Boss Fight Ended
game.ReplicatedStorage.BossFightOver.Event:Connect(function()

	-- Reset Players in BOssRoom
	playersInBossRoom = {}

end)

------------------------
-- Heartbeat Function --
------------------------

-- Code that runs every physics frame --
RunService.Heartbeat:Connect(function(delta)
	
	-- Only Run all functions if this rats health is above 0 --
	if thisHumanoid.Health > 0 then
		
		-- Make Rat Always Randomly Squeak --
		RatSqueaking()
		
		-- Always GEt Rat Position
		thisRatPos = thisRatPrimaryPart.Position			
	
		-------------------------------------------------
		-- Retarget new nearest Player every n seconds --
		-------------------------------------------------			

		-- Get Nearest Player and Directional Info from Function --
		if (time() - lastTargetPlayer) >= targetPlayerWait then 

			-- Update Last Target Player Time
			lastTargetPlayer = time()

			-- Will only return a player within reach.. --		
			nearestPlayer = TargetNearestPlayer()

		end	

		----------------------------------
		-- Main if nearest player Logic --
		----------------------------------

		-- If rat has found a viable, alive target..
		if nearestPlayer then

			-- If Character is Ready --
			if nearestPlayer.Character then

				-- If nearest player isnt dead --
				if nearestPlayer.Character.Humanoid.Health > 0 then

					-- Always Update Position
					nearestPlayerPos = nearestPlayer.Character.LowerTorso.CFrame.Position

					-- If Rat has targeted a player, always be tracking distance to the playere --
					local directionToPlayer = (nearestPlayerPos - thisRatPos)
					distanceToPlayer = directionToPlayer.Magnitude

					----------------------------------
					-- Aggressive Jumping At Player --
					----------------------------------

					if distanceToPlayer < startJumpingDistance then

						-- Start Jumping Aggressively Toward the Player
						if (time() - lastJump) >= jumpInterval then

							-- Reset
							lastJump = time()

							-- Change the Random Interval
							jumpInterval = math.random(1,4) - 0.5 -- (0.5 - 3.5)

							-- Jump
							thisHumanoid.Jump = true
						end
					end

					----------------------------------------
					-- If we can reach PLayer to attack.. --
					----------------------------------------						

					-- If player is close enough to attck --
					if distanceToPlayer <= attackDistance then

						-- Stop Walking --
						thisHumanoid:MoveTo(nearestPlayerPos)

						-- Keep Attack Freuquency
						if (time() - lastAttack) >= attackWait then

							-- Update Last attack time
							lastAttack = time()

							-- Lower Target Players Health
							nearestPlayer.Character.Humanoid.Health -= damage

						end									

					else

						-----------------------------------------
						-- Dont need to Pathfind just follow.. --
						-----------------------------------------

						-- Follow Player Using No Pathfinding
						thisHumanoid:Move(directionToPlayer)	
																			
					end

					-- Nil Stuff
					directionToPlayer = nil
				end			
			end			
		else -- If there is no player to find, or if we cant reach player.. --	

			---------------
			-- Just Roam --
			---------------

			-- Roam --
			Roam()	

		end		
	else -- Rat is DEAD --
		
		-- If Rat is not already dieing --
		if not ratDieing then

			-- Now Rat is dieing
			ratDieing = true

			-- Stop Walk Animation
			walkAnimTrack:Stop()
			
			-- Stop Walking Sound
			ratScratching:Stop()

			-- Pick Random Die Squeak
			local chosenSound = nil
			local random = math.random(1,4)

			if random == 1 then
				chosenSound = ratDieSqueak1
			elseif random == 2 then
				chosenSound = ratDieSqueak2
			elseif random == 3 then
				chosenSound = ratDieSqueak3			
			elseif random == 4 then
				-- No sound
				chosenSound = nil
			end

			-- Rat Die Squeak
			if chosenSound then
				chosenSound:Play()		
			end
			
			-- Make eyes go Dim..
			thisRat.LeftEye.Color = Color3.fromRGB(66,0,0)
			thisRat.RightEye.Color = Color3.fromRGB(66,0,0)
			
			-- Wait
			task.wait(4)
			
			-- Fade Away
			local isFadedAway = false
			
			-- Fade Away --
			while not isFadedAway do

				-- Change it
				transparency += .1

				-- If then
				if transparency >= 1 then

					-- Is faded
					isFadedAway = true
				end

				-- Set Transparency
				script.Parent.Parent.Torso.Transparency = transparency
				script.Parent.Parent.Tail1.Transparency = transparency
				script.Parent.Parent.Tail2.Transparency = transparency
				script.Parent.Parent.RightEye.Transparency = transparency
				script.Parent.Parent.NoseTip.Transparency = transparency
				script.Parent.Parent.Nose.Transparency = transparency
				script.Parent.Parent.Neck.Transparency = transparency
				script.Parent.Parent.MiddleTorso.Transparency = transparency
				script.Parent.Parent.LeftEye.Transparency = transparency
				script.Parent.Parent.Head.Transparency = transparency
				script.Parent.Parent.FrontTailBase.Transparency = transparency
				script.Parent.Parent.BackTorso.Transparency = transparency
				script.Parent.Parent.BackTailBase.Transparency = transparency
				script.Parent.Parent.RightEar.Transparency = transparency
				script.Parent.Parent.LeftEar.Transparency = transparency
				
				-- Wait
				task.wait(0.1)
			end
			
			-- Nil Stuff
			chosenSound = nil
			random = nil

			-- Destroy
			thisRat:Destroy()
		end	
				
	end
end)