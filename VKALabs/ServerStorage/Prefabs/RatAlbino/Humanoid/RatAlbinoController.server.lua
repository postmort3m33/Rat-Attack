-- Service Init --
local PathfindingService = game:GetService("PathfindingService")
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

local pathAgentParams = { -- PathFinding Parameters --
	AgentRadius = 0.5, -- Default:1
	AgentHeight = 1, -- Default: 2.2
	AgentCanJump = true,
	WaypointSpacing = 3, -- default:4
	Costs = {
		DiamondPlate = 0.5,
		Concrete = 1.0,
		Grass = 20.0,
		Slate = 20.0,
		Asphalt = 1.0
	}
}
local path = PathfindingService:CreatePath(pathAgentParams)
local waypoints = nil
local movingThroughWaypoints = false
local movingToWaypoint = false
local moveToFinishedFinalTime = 3
local waypointsFinished = true -- MUST START AS TRUE

-- CollisionGroup Variables --
local changeCollisionDistance = 50
local canCollideWithRats = true -- MUST START AS TRUE

-- Targeting Vars --
local nearestPlayer = nil
local nearestPlayerPos = nil
local distanceToPlayer = nil
local targetPlayerWait = 2 -- TARGET PLAYER INTERVAL --
local lastTargetPlayer = time()

-- Raycast Vars
local canSeePlayer = false
local rayCastInterval = 0.5
local lastRayCast = time()

-- Animation Vars --
local walkAnim = script:WaitForChild("Walk")
local walkAnimTrack = thisHumanoid.Animator:LoadAnimation(walkAnim)

-- Roaming Variables
local changeRandomWayPointInterval = 3
local lastChangeRandomWaypoint = time()

-- Sound Vars --
local lastSqueak = time()
local squeakWait = 0

-- Sound Initializiation --
local ratSqueak1 = script.Parent.Parent.Torso.Squeak1
local ratSqueak2 = script.Parent.Parent.Torso.Squeak2
local ratSqueak3 = script.Parent.Parent.Torso.Squeak3
local ratSqueak4 = script.Parent.Parent.Torso.Squeak4
local ratScratching = script.Parent.Parent.Torso.ratScratching
local ratDieSqueak1 = script.Parent.Parent.Torso.DieSqueak
local ratDieSqueak2 = script.Parent.Parent.Torso.DieSqueak2

-- Get Player Count Vars --
local playerTable = nil

-- Damage Variables --
local damage = 18
local attackDistance = 4 -- higher than Stop Distance
local jumpDistance = 15
local attackWait = 1.25 -- in seconds
local lastAttack = time()

-- Aggressive Jumping Stuff
local lastJump = time()
local jumpInterval = 1

-- Distance to Player Respawn Vars
local setInitPos = false
local initPos = nil
local respawnTimer = 0
local respawnTime = 20

-- Dieing Variables --
local ratDieing = false

-- Post Variable Wait
task.wait(1)

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

-- Wait again
task.wait(1)

--------------------------------------------------------------------------
-- Functions -------------------------------------------------------------
--------------------------------------------------------------------------

-- Function to periodically get player list
local function SetPlayerTable()
	
	-- Player Table --
	playerTable = Players:GetPlayers()
end

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
local function TargetNearestPlayer()

	-- Found player Vars --
	local localNearestPlayer = nil
	local distance = nil
	
	-- If there is a playerTable..
	if playerTable then
		
		-- Loop to find nearest player --
		for _, player in pairs(playerTable) do	

			-- Dont run Function unless the Players are lloaded up yet -- 
			if player.Character then
				
				-- If player is dead, return function with nil --
				if player.Character.Humanoid.Health <= 0 then

					-- Break the loop for that player -
					continue
				end	
				
				-- Define Player Position --
				local playerPos = player.Character.PrimaryPart.Position
				
				-- If this player is too high, skip..
				if playerPos.Y > 20 then
					
					-- Skip
					continue
				end
				
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
	
	return localNearestPlayer	
end

-- Function to get a new path to target (Returns "success" and "waypoints") --
local function FindNewPath(destination)
	
	-- Computer Actual Path --
	local success, errorMessage = pcall(function()
		path:ComputeAsync(thisRatPos, destination)
	end)
	
	-- If successfukl
	if success and path.Status == Enum.PathStatus.Success then
		
		-- nil Stuff
		success = nil
		errorMessage = nil

		-- Return if path was successful and waypoints --
		return path:GetWaypoints()
		
	else -- Not successful, no waypoints --
		
		-- Nil Stuff
		success = nil
		errorMessage = nil
		
		-- return nil
		return nil
	end	

end

-- function to change COllision Group --
local function ChangeCollisionGroup(newGroup)
	
	-- New Collision Group..
	thisRat.Torso.CollisionGroup = newGroup
	thisRatPrimaryPart.CollisionGroup = newGroup
	
	-- Change HRP and Torso Collision
	--PhysicsService:SetPartCollisionGroup(thisRat.Torso, newGroup)
	--PhysicsService:SetPartCollisionGroup(thisRatPrimaryPart, newGroup)
	
end

-----------------
-- Connections --
-----------------

-- When a Player is leaving
Players.PlayerRemoving:Connect(function()
	
	-- Wait
	task.wait(1)

	-- Re run Player Table
	SetPlayerTable()
	
end)

-- Running event -- If we are moving --
thisHumanoid.Running:Connect(function(speed)
	
	-- Only Animate if rat is Alive
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

--------------------
-- Init Functions --
--------------------

SetPlayerTable()

------------------------
-- Heartbeat Function --
------------------------

-- Code that runs every physics frame --
RunService.Heartbeat:Connect(function(delta)
	
	-------------------------------
	-- Beginning of Main If Loop --
	-------------------------------
	
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
					distanceToPlayer = (nearestPlayerPos - thisRatPos).Magnitude

					--------------------------------------------------------
					-- Change collision Group Based on Distance to Player --
					--------------------------------------------------------

					if distanceToPlayer < changeCollisionDistance and canCollideWithRats == false then

						-- Change it to Default (so they hit eachother)
						ChangeCollisionGroup("RatCollideRat")

						-- now Can Collide
						canCollideWithRats = true

					elseif (distanceToPlayer > changeCollisionDistance + 5) and canCollideWithRats == true then

						-- Change it to Rats (So they can go through vents)
						ChangeCollisionGroup("RatNoCollideRat")

						-- now Cant Collide
						canCollideWithRats = false

					end	
					
					
					----------------------------------------
					-- If we can reach PLayer to attack.. --
					----------------------------------------						

					-- If player is close enough to attck --
					if distanceToPlayer <= attackDistance then

						-- Stop Walking --
						thisHumanoid:MoveTo(nearestPlayerPos - thisRatPos)

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
						
						-- If we are tihting Jump Distance..
						if distanceToPlayer <= jumpDistance then

							-- Start Jumping Aggressively Toward the Player
							if (time() - lastJump) >= jumpInterval then

								-- Reset
								lastJump = time()

								-- Change the Random Interval
								jumpInterval = math.random(1,2)
								
								-- Random Jump Power
								thisHumanoid.JumpPower = math.random(40,50)

								-- Jump
								thisHumanoid.Jump = true
							end								
						end

						-----------------------------------------
						-- Raycast to see if Player is insight --
						-- this to minimize Pathfinding calls  --
						-----------------------------------------

						-- Every Time Interval..
						if (time() - lastRayCast) >= rayCastInterval then

							-- Set Last one
							lastRayCast = time()

							-- Ref
							local result = nil

							-- Create new Raycast Handle --
							local newRay = RaycastParams.new()

							-- Dont let raycast hit the player shooting it --
							newRay.FilterDescendantsInstances = {thisRat}

							---------------------------------------
							-- Change Angle of Each rayCast Here --
							---------------------------------------	
							
							-- New Origin
							local newOrigin = Vector3.new(thisRatPos.X, thisRatPos.Y + 1, thisRatPos.Z)

							-- Calculate Raycast direction
							local rayDirection = (nearestPlayerPos - newOrigin)	

							--------------------------
							-- Now Cast the Raycast --
							--------------------------

							-- Cast From Camera --
							result = workspace:Raycast(newOrigin, rayDirection, newRay)

							-- Check our result
							if result then

								-- Hit an active instance
								if result.Instance then

									-- If we hit our player..
									if result.Instance.Parent.Name == nearestPlayer.Name or result.Instance.Parent.Parent.Name == nearestPlayer.Name then

										-- We Can See our player
										canSeePlayer = true
									else

										-- Cant See Player
										canSeePlayer = false
									end
								end
							end

							-- Nil Stuff
							newRay = nil
							result = nil
							rayDirection = nil	

						end

						----------------------------
						-- Can We See our Target? --
						----------------------------
						if canSeePlayer then

							-- Renil Waypoints
							waypoints = nil
							
							-- Reset Init Pos
							setInitPos = false

							-- Move without Pathfinding..
							thisHumanoid:Move(nearestPlayerPos - thisRatPos)

						else -- Cannot See Player must Pathfind..
							
							------------------------------
							-- Respawn When hasnt moved --
							------------------------------

							if setInitPos == false then

								-- Now Weve Set It
								setInitPos = true

								-- Set it
								initPos = thisRatPos
							end

							-- Now Check to see if we moved..
							if setInitPos and ((initPos - thisRatPos).Magnitude < 5) then

								-- Cont down the Timer.
								respawnTimer += delta

								-- If we reached respawn timer, destroy..
								if respawnTimer > respawnTime then

									-- Destroy
									DebrisService:AddItem(thisRat, 2)

								end
							else

								-- Reset..
								setInitPos = false

								-- Reset respawn Timer
								respawnTimer = 0
							end

							-------------------------------------------------
							-- Get a New Path to the PLayer every Interval --
							-------------------------------------------------							

							-- Get a new Path every Path Interval
							if waypointsFinished then
								
								-- Now Not Finished
								waypointsFinished = false

								-- Get a new Path --
								waypoints = FindNewPath(nearestPlayerPos)	

								-- If we found a successful path..
								if not waypoints then
									
									-- Cant Reach PLayer make them Nil
									nearestPlayer = nil

									-- Waypoints are no longer finished..
									waypointsFinished = true
									
								end
							end		

							-- If we got waypoints.. 
							if waypoints then								

								-- if not currently moving through waypoints and new waypoints to traverse.. 
								if movingThroughWaypoints == false and waypointsFinished == false then									

									-- moving to waypoint
									movingThroughWaypoints = true

									-- Loop through.. 
									for i, waypoint in ipairs(waypoints) do

										-- MOve to Finsihed Connection
										local connection = nil
										
										-- Move To Timer
										local moveToTimer = 0

										-- MOving to next waypoint
										movingToWaypoint = true

										-- While we are moving to the next waypoint..
										while movingToWaypoint do
											
											-- Connection for MoveToFinished --	
											if not connection then
												
												-- Move..
												thisHumanoid:MoveTo(waypoint.Position)
												
												-- Connect Finish
												connection = thisHumanoid.MoveToFinished:Connect(function()										

													-- Done moving to waypoint
													movingToWaypoint = false

												end)												
											end	

											-- Keep Counting
											moveToTimer += delta

											-- Start a timer for Rats getting stuck..
											if moveToTimer > moveToFinishedFinalTime or canSeePlayer or not nearestPlayer then

												-- leave..
												movingToWaypoint = false
												movingThroughWaypoints = false

											end

											-- Check for Jump
											if waypoint.Action == Enum.PathWaypointAction.Jump then

												-- Make Rat Jump
												thisHumanoid.Jump = true
											end											

											-- Wait
											task.wait()
										end	

										-- Break Connection
										connection:Disconnect()
										connection = nil

										-- if
										if movingThroughWaypoints == false then

											-- break
											break
										end																				
									end

									-- not moving to waypoint anymore --
									movingThroughWaypoints = false	

									-- Not Moving to a wayoint..
									movingToWaypoint = false

									-- Waypoints are finished
									waypointsFinished = true

									-- Nil Waypoints...
									waypoints = nil

								end																	
							end								
						end																											
					end

					-- Nil Stuff
					distanceToPlayer = nil
					nearestPlayerPos = nil
					
				end			
			end			
		else -- If there is no player to find, or if we cant reach player.. --				

			-- Reset Collision Group..
			if canCollideWithRats == true then
				
				-- now Cant Collide
				canCollideWithRats = false

				ChangeCollisionGroup("RatNoCollideRat")				

			end	

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
				chosenSound = nil
			end

			-- Rat Die Squeak
			if chosenSound then
				chosenSound:Play()			
			end
			
			-- Make eyes go Dim..
			thisRat.LeftEye.Color = Color3.fromRGB(66,0,0)
			thisRat.RightEye.Color = Color3.fromRGB(66,0,0)
			
			-- Make Rats Not Collide with other Rats once they die..
			ChangeCollisionGroup("DeadRat")
			
			-- Wait
			task.wait(3)
			
			-- Fade Away
			local isFadedAway = false
			local transparency = 0
			
			-- Fade Away --
			while not isFadedAway do

				-- Change it
				transparency += .1

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
				
				-- If then
				if transparency >= 1 then

					-- Is faded
					isFadedAway = true
				end
				
				-- Wait
				task.wait(0.1)
			end
			
			-- Nil Stuff
			chosenSound = nil
			random = nil
			isFadedAway = nil
			transparency = nil

			-- Destroy
			thisRat:Destroy()
		end	
				
	end
end)