-- Edited

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

-- Animation Vars --
local walkAnim = script:WaitForChild("Walk")
local walkAnimTrack = thisHumanoid.Animator:LoadAnimation(walkAnim)

-- Roaming Variables
local changeRandomWayPointInterval = 2
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

---------------
-- Functions --
---------------

-- Function to Calculate Rat Squeaking --
local function RatSqueaking()

	-- Only Squeak every time interval --
	if (time() - lastSqueak) >= squeakWait then

		-- Reset Last Squeak
		lastSqueak = time()

		-- Set Random squeakInterval
		squeakWait = math.random(2,7)

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

-----------------
-- Connections --
-----------------

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
		
		---------------
		-- Just Roam --
		---------------

		-- Roam --
		Roam()

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
			local random = math.random(1,3)

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
			
			-- Wait
			task.wait(3)
			
			-- Nil Stuff
			chosenSound = nil
			random = nil
			
			-- Destroy this Script
			script:Destroy()
		end				
	end
end)