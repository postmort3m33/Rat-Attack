-- Service Init --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local DebrisService = game:GetService("Debris")
local PhysicsService = game:GetService("PhysicsService")

-- Character Vars --
local thisRatKing = script.Parent.Parent
local thisHumanoid = thisRatKing:WaitForChild("Humanoid")
local thisRatKingPrimaryPart = thisRatKing.PrimaryPart
local thisRatKingPos = nil
local thisNosePart = thisRatKing:WaitForChild("Nose")
local eye1 = thisRatKing:WaitForChild("LeftEye")
local eye2 = thisRatKing:WaitForChild("RightEye")

-- Value Vars --
local distanceToPlayer = 0

-- Targeting Vars --
local nearestPlayer = nil
local nearestPlayerPos = nil
local targetPlayerWait = 0.5 -- TARGET PLAYER INTERVAL --
local lastTargetPlayer = time()

-- Animation Vars --
local walkAnim = script:WaitForChild("Walk")
local walkAnimTrack = thisHumanoid.Animator:LoadAnimation(walkAnim)
local runningConnection = nil

-- Roaming Variables
local randomWaypoint = nil
local changeRandomWayPointInterval = 3
local lastChangeRandomWaypoint = time()

-- Sound Initializiation --
local lastLowGrowl = time()
local lowGrowlInterval = 1.25
local giantStepping = script.Parent.Parent.Torso.giantStep
local lowGrowl = script.Parent.Parent.Torso.lowGrowl
local dieSound1 = script.Parent.Parent.Torso.DieSqueak2
local dieSound2 = script.Parent.Parent.Torso.DieSqueak3

-- Players in BossRoom
local playersInBossRoom = {}

-- Damage Variables --
local damage = 33
local attackDistance = 4 -- higher than Stop Distance
local attackWait = 2.5 -- in seconds
local lastAttack = time()
local stopMovingDistance = 3

-- Dieing Variables --
local ratDieing = false
local redValue = 255
local isFadedAway = false
local transparency = 0

-- Post Variable Wait
task.wait(1)

---------------------------
-- Initializiation Stuff --
---------------------------

-- Network OwnerShip on Character for all server-handling --
for _, object in pairs(thisRatKing:GetChildren()) do 
	
	-- If we found a basepart..
	if object:IsA("BasePart") then
		
		-- Set the Network Owner
		object:SetNetworkOwner()
	end
end

--------------------------------------------------------------------------
-- Functions -------------------------------------------------------------
--------------------------------------------------------------------------

-- RatKing Low Grown Function --
local function RatGrowling()

	-- Time Interval for Low Growl --
	if (time() - lastLowGrowl) >= lowGrowlInterval then

		--- Set Last Growl --
		lastLowGrowl = time()

		-- Random INterval
		lowGrowlInterval = math.random(1,4)

		-- Make Rat Always LowGrowling--
		if not lowGrowl.IsPlaying then

			-- Pay Sound --
			lowGrowl:Play()
		end			
	end		
end

-- Rat Roam Around --
local function Roam()

	-- Move to a different waypoint every interval --
	if (time() - lastChangeRandomWaypoint) >= changeRandomWayPointInterval then

		-- Update This Change --
		lastChangeRandomWaypoint = time()		

		-- Change Interval Time --
		changeRandomWayPointInterval = math.random(2,5) -- Changes Waypoint every 1 to 3 seconds

		-- Calculate a random direction vector --		
		randomWaypoint = Vector3.new(			
			thisRatKing.PrimaryPart.Position.X + (math.random(-30,30) + 10),thisRatKing.PrimaryPart.Position.Y,
			thisRatKing.PrimaryPart.Position.Z + (math.random(-30,30) + 10)
		)

		-- RayCast to make sure Waypoint isnt through a wall --
		local newRay = RaycastParams.new()		

		-- Calculate Raycast direction
		local rayDirection = (randomWaypoint - thisRatKing.PrimaryPart.Position) * 500

		-- Dont let raycast hit the player shooting it --
		newRay.FilterDescendantsInstances = {thisRatKing}	

		-- Cast From Camera --
		local result = workspace:Raycast(thisRatKing.PrimaryPart.Position, rayDirection, newRay)	

		-- Reset random Waypoint to where the raycast hit --
		if result then

			-- Set it
			randomWaypoint = result.Position			
		end	

		-- Nil Stuff
		newRay = nil
		result = nil
		rayDirection = nil
	end		


	-- Move Rat to random waypoint
	if randomWaypoint then

		-- Check if we reached the wayPoint --
		local distanceToWaypoint = (randomWaypoint - thisNosePart.Position).Magnitude

		-- If we are not near Waypoint.. move to it --
		if distanceToWaypoint > 10 then		

			-- Send Rat to Waypoint --
			thisHumanoid:MoveTo(randomWaypoint)
		else

			-- Stop Moving
			thisHumanoid:MoveTo(thisRatKing.PrimaryPart.Position)
		end	

		-- Nil Stuff
		distanceToWaypoint = nil
	end		
end

-- Find Nearest Player -- 
function TargetNearestPlayer()

	-- Found player Vars --
	local localNearestPlayer = nil
	local distance = nil
	
	-- If there are players in the bossroom
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
				local distanceVector = playerPos - thisNosePart.Position

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
	
	-- Return
	return localNearestPlayer
end

-----------------
-- Connections --
-----------------

-- If AI is Running, Animate the Run Function
runningConnection = thisHumanoid.Running:Connect(function(speed)
	
	-- If ratdieing leave
	if ratDieing then
		
		-- Stop Tracks.,.
		if walkAnimTrack.IsPlaying then walkAnimTrack:Stop() end
		if giantStepping.IsPlaying then giantStepping:Stop() end
		
		-- Disconnect
		if runningConnection then
			
			-- Dis
			runningConnection:Disconnect()
			runningConnection = nil
		end
		
		-- return
		return
	end

	-- If we are moving..
	if speed > 0 then
		
		-- Reloop Sound
		giantStepping.Looped = true
		
		-- Play Moving Sound, Loop it
		if not giantStepping.IsPlaying then
			
			-- Play Giant Step..
			giantStepping:Play()
		end	

		--Play Animation
		if not walkAnimTrack.IsPlaying then
			walkAnimTrack:Play()
		end

	else -- Rat has Stopped.
		
		-- UnLoop Stepping Sound
		giantStepping.Looped = false

		-- Play Animation --
		if walkAnimTrack.IsPlaying then
			walkAnimTrack:Stop()
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

-- Shake Camera Every Time Step PLays..
giantStepping.DidLoop:Connect(function()
	
	-- If there are players in the bossroom..
	if #playersInBossRoom > 0 then
		
		-- Shake Camera for all of them..
		for _, player in pairs(playersInBossRoom) do

			-- Fir eevent
			game.ReplicatedStorage.CameraShake:FireClient(player, 0.2) -- Seconds to Shake
		end
	end
end)

------------------------
-- Heartbeat Function --
------------------------

-- Code that runs every physics frame --
RunService.Heartbeat:Connect(function() 
	
	-- Only Run all functions if this rats health is above 0 --
	if thisHumanoid.Health > 0 then
		
		-- Make Rat Always Randomly Squeak --
		RatGrowling()		
		
		-- Always GEt Rat Position
		thisRatKingPos = thisRatKingPrimaryPart.Position
		
		-------------------------------------------------
		-- Retarget new nearest Player every n seconds --
		-------------------------------------------------			

		-- Get Nearest Player and Directional Info from Function --
		if (time() - lastTargetPlayer) >= targetPlayerWait then --

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
					nearestPlayerPos = nearestPlayer.Character.PrimaryPart.Position

					-- If Rat has targeted a player, always be tracking distance to the playere --
					local directionToPlayer = (nearestPlayerPos - thisRatKingPos)
					distanceToPlayer = (nearestPlayerPos - thisNosePart.Position).Magnitude				

					----------------------------------------
					-- If we can reach PLayer to attack.. --
					----------------------------------------

					-- If player is close enough to attck --
					if distanceToPlayer <= attackDistance then
						
						-- If too close..
						if distanceToPlayer <= stopMovingDistance then
							
							-- Stop Walking --
							thisHumanoid:Move(Vector3.new(0,0,0))
						else
							
							-- Move Toward Player..
							thisHumanoid:Move(directionToPlayer)							
						end						

						-- Keep Attack Freuquency
						if (time() - lastAttack) >= attackWait then

							-- Update Last attack time
							lastAttack = time()

							-- Lower Target Players Health
							nearestPlayer.Character.Humanoid.Health -= damage

						end									

						--------------------------------------------------------------
						-- Not close enough to attack, Lets follow using Pathfinding--
						--------------------------------------------------------------
					else
						
						-- Follow Player Using No Pathfinding
						thisHumanoid:Move(directionToPlayer)						

					end	
					
					-- Nil Stuff
					directionToPlayer = nil					
				end			
			end			
		else -- If there is no player to find, or if we cant reach player.. --	

			-- Roam --
			Roam()	

		end	
		
	else -- Rat is DEAD --

		-- If rat is not yet dieing, now he is.. --
		if not ratDieing then

			-- now dieing
			ratDieing = true
			
			-- Disconnect running connection
			if runningConnection then
				
				-- Dis
				runningConnection:Disconnect()
				runningConnection = nil
			end			
			
			-- Wait
			task.wait()

			-- Stop Walk Animation
			if walkAnimTrack.IsPlaying then walkAnimTrack:Stop() end

			-- Stop AllSounds
			if giantStepping.IsPlaying then giantStepping:Stop() end
			if lowGrowl.IsPlaying then lowGrowl:Stop() end
			
			-- Pick Random Die Squeak
			local chosenSound = nil
			local random = math.random(1,2)

			if random == 1 then
				chosenSound = dieSound1
			elseif random == 2 then
				chosenSound = dieSound2
			end
			
			-- Play Sound
			chosenSound:Play()

			-- make Neon eyes go to black --		
			while redValue >= 0 do

				-- Apply Eye Color
				eye1.Color = Color3.fromRGB(redValue, redValue, 0)
				eye2.Color = Color3.fromRGB(redValue, redValue, 0)

				-- Lower Red Value
				redValue -= 2

				-- Wait --
				task.wait()
			end

			-- Wait for a few seconds then destroy the entity --
			task.wait(2)

			-- now make it dissapear --
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
				task.wait(.1)
			end
			
			-- Nil Stuff
			chosenSound = nil
			random = nil

			-- Destroy
			thisRatKing:Destroy()			
		end			
	end	
end)