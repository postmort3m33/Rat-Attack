-- Wait
task.wait(5)

-- Objects
local thisScientist = script.Parent.Parent
local thisTray = script.Parent.Parent:WaitForChild("Tray")
local thisHumanoid = script.Parent

-- Prox
local thisProx = script.Parent.Parent.HumanoidRootPart:WaitForChild("ProximityPrompt")
local trayProx = thisTray:WaitForChild("ProximityPrompt")
local trayProxConnection = nil

-- Animation
local animator = script.Parent.Animator
local idleAnimation = script:WaitForChild("Idle")
local talkingAnimation = script:WaitForChild("Talking")
local coughAnimation = script:WaitForChild("Cough")
local walkAnimation = script:WaitForChild("Walk")
local workBenchAnimation = script:WaitForChild("WorkBench")

-- Wait a sec...
task.wait(1)

-- Load Animation Tracks
local idleTrack = animator:LoadAnimation(idleAnimation)
local talkingTrack = animator:LoadAnimation(talkingAnimation)
local coughTrack = animator:LoadAnimation(coughAnimation)
local walkTrack = animator:LoadAnimation(walkAnimation)
local workBenchTrack = animator:LoadAnimation(workBenchAnimation)

-- State Vars
local lastIdle2Play = time()
local idle2PlayInterval = 10

-- Tray Item Vars
local numAerosolCans = 0
local numVialsForPoison = 0

-- Sounds
local firstSpeechSound = script.Parent.Parent.Head:WaitForChild("FirstSpeech")
local secondSpeechSound = script.Parent.Parent.Head:WaitForChild("SecondSpeech")
local thirdSpeechSound = script.Parent.Parent.Head:WaitForChild("ThirdSpeech")
local heresTheBombSound = script.Parent.Parent.Head:WaitForChild("HeresTheBomb")

-- Mission Stuff
local hasBeenTalkedTo = false
local hasBeenTalkedToTwice = false
local secondSpeechReady = false  -- Default: false
local readyToReceiveBomb = false
local hasReceivedBomb = false
local bombWasSet = false
local BOMBMAKING_TIME = 180 -- Default: 180 (3:00)

---------------
-- Functions --
---------------

-- Find Nearest Player -- 
function TargetNearestPlayer()

	-- Found player Vars --
	local localNearestPlayer = nil
	local distance = nil
	
	-- PLayer Table
	local playerTable = game.Players:GetPlayers()

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

			-- Distance to this Player in the loop (Found Player position - This Position)
			local distanceVector = playerPos - thisScientist.PrimaryPart.Position

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

	-- NIl Stuff
	distance = nil
	playerTable = nil

	-- Debugging
	return localNearestPlayer
end

-- follow Player Out of Warehouse
local function FollowPlayer()
	
	-- Vars..
	local escapedWarehouse = false
	local nearestPlayer = nil
	local runningConnection = nil
	
	-- Follow Vars
	local lastTargetPlayer = time()
	local targetPlayerInterval = 1
	
	-- UnAnchor Scientist
	thisScientist.PrimaryPart.Anchored = false
	
	-- Turn up Walkspeed..
	thisHumanoid.WalkSpeed = 16
	
	-- Stop All other Animation
	idleTrack:Stop()
	talkingTrack:Stop()
	
	-- Connection for Running Animation
	runningConnection = thisHumanoid.Running:Connect(function(speed)
		
		-- If  Escaped Warehouse/ Stop
		if escapedWarehouse then
			
			-- Stop
			walkTrack:Stop()
			
			-- Disconnect
			runningConnection:Disconnect()
			runningConnection = nil
			
			-- Leave
			return
		end
		
		-- Animate
		if speed > 0 then
			
			-- if not
			if not walkTrack.IsPlaying then
				
				-- play it
				walkTrack:Play()
			end
		else
			
			-- Not Running
			if walkTrack.IsPlaying then
				
				-- Stop it
				walkTrack:Stop()
			end
		end
	end)
	
	-- Follow Player out of warehouse..
	while escapedWarehouse == false do
		
		--Find Nearest Player in intervals..
		if (time() - lastTargetPlayer) >= targetPlayerInterval then
			
			-- Set Last
			lastTargetPlayer = time()
			
			-- Target
			nearestPlayer = TargetNearestPlayer()			
			
		end	
		
		-- Follow Them
		if nearestPlayer then
			
			-- If Character
			if nearestPlayer.Character then
				
				-- Get Nearest Player Position..
				local nearestPlayerPos = nearestPlayer.Character.PrimaryPart.Position
				
				-- Vars
				local distanceToTarget = (nearestPlayerPos - script.Parent.Parent.PrimaryPart.Position).Magnitude
				
				-- If within..
				if distanceToTarget > 8 then
					
					-- Follow Them
					script.Parent:MoveTo(nearestPlayerPos)
					
				else
					
					-- Stop
					script.Parent:Move(Vector3.new(0,0,0))
				end
				
				-- Nil
				nearestPlayerPos = nil
				distanceToTarget = nil
				
			end			
		end
		
		-- Check if Scientist has cleared the warehouse..
		if thisScientist.PrimaryPart.CFrame.Position.Z >= 450 and escapedWarehouse == false then
			
			-- Escaped Warehouse
			escapedWarehouse = true
			
			-- Trigger EndGame Cutscene
			game.ReplicatedStorage.MissionEvents.ScientistClearedWarehouseSTS:Fire() -- Listening from RatSpawner Script
			
			-- Send to Client
			game.ReplicatedStorage.MissionEvents.ScientistClearedWarehouseSTC:FireAllClients() -- Listening from MainGUI Local
			
			-- Stop and Anchor Scientist..,
			script.Parent:MoveTo(script.Parent.Parent.PrimaryPart.Position)

			-- Anchor
			script.Parent.Parent.PrimaryPart.Anchored = true
			
			-- Turn off Scientist Name
			script.Parent.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
			
			-- Turn oin Poison Bomb Gas
			workspace.Level.PoisonBombParticleParts.PoisonBombParticlePart.PoisonGas.Enabled = true
			workspace.Level.PoisonBombParticleParts.PoisonBombParticlePart2.PoisonGas.Enabled = true
		
		end
		
		-- wait
		task.wait()
		
	end	
end

-- Beard Move
local function OneBeardMove(thisBeard)

	-- Min/Max Points
	local beardYLowest = 1
	local beardYHighest = 0.95

	-- beard OGS
	local beardZPos = thisBeard.AttachmentPoint.Position.Z

	-- Current Beards..
	local currentBeardYPos = thisBeard.AttachmentPoint.Position.Y
	
	-- Move Beard Down
	while currentBeardYPos < beardYLowest do

		-- Move Current Down
		currentBeardYPos += 0.01

		-- Move it
		thisBeard.AttachmentPoint = CFrame.new(0, currentBeardYPos, beardZPos)

		-- Wait
		task.wait()
	end

	-- Move it Back Up
	while currentBeardYPos > beardYHighest do

		-- Minus
		currentBeardYPos -= 0.01

		-- Move it
		thisBeard.AttachmentPoint = CFrame.new(0, currentBeardYPos, beardZPos)

		-- Wait
		task.wait()
	end	
	
end

-- Talking Animations
local function TalkingAnimations(audioClip)
	
	-- Get Bears..
	local beardObj = script.Parent.Parent:WaitForChild("Beard")
	
	-- Loudness Thrwshold..
	local minLoudness = 500
	
	-- State Vars..
	local beardMoving = false
	
	-- Loop
	while talkingTrack.IsPlaying do
		
		-- check loudness
		if audioClip.PlaybackLoudness > minLoudness and beardMoving == false then
			
			-- Move Beard
			beardMoving = true
			
			-- OneBeard
			OneBeardMove(beardObj)
			
			-- not moving anymore
			beardMoving = false 
			
		end		
		
		-- Random Wait Time
		task.wait()
		
	end
end

-----------------
-- Connections --
-----------------

-- This Prox
thisProx.Triggered:Connect(function(player)
	
	-- If bomb was set
	if bombWasSet then

		-- Turn off Prox
		thisProx.Enabled = false

		-- Follow Player Coroutine..
		local newCoroutine = coroutine.create(FollowPlayer)
		coroutine.resume(newCoroutine)
		newCoroutine = nil

		-- Make Rat Spawn High
		game.ReplicatedStorage.OutsideRatSpawnSwitch:Fire()

		-- Open Gates Outside..
		workspace.Level.ParkingLot.OutsideGate.RightGateOpen.Union.Transparency = 0
		workspace.Level.ParkingLot.OutsideGate.RightGateClosed:Destroy()
		workspace.Level.ParkingLot.OutsideCollision.GateCollision:Destroy()

		-- Leave
		return
	end
	
	-- First time Talked To
	if hasBeenTalkedTo == false then

		-- Now Its True
		hasBeenTalkedTo = true
		
		-- turn off prox
		thisProx.Enabled = false
		
		-- Remove this Mission Ping
		game.ReplicatedStorage.MissionEvents.RemoveMissionPingSTS:Fire(1)

		-- Play First Speech..
		firstSpeechSound:Play()
		
		-- Play Talking Track
		idleTrack:Stop()
		talkingTrack:Play()
		
		-- run talking animations
		--local talkingCoroutine = coroutine.create(TalkingAnimations)
		--coroutine.resume(talkingCoroutine, firstSpeechSound)
		
		-- Wait sound length
		task.wait(firstSpeechSound.TimeLength)
		
		-- Fire Mission Control event
		game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(1) -- ID of Complete Objective
		
		-- Make sure animations stop..
		if talkingTrack.IsPlaying then talkingTrack:Stop() end
		if not idleTrack.IsPlaying then idleTrack:Play() end
		
		-- turn it back on
		thisProx.Enabled = true
		
		-- Leave
		return
		
	end
	
	-- Check if Second Speech is ready..
	if secondSpeechReady and hasBeenTalkedToTwice == false then
		
		--------------------------
		-- Check for Rat poison --
		--------------------------
		
		-- Vars
		local playerHasTool = false
		local vialWithPoisonObject = nil
		local playerTools = player.Backpack:GetChildren()

		-- Add Tool in Hand as well
		for _, v in pairs(player.Character:GetChildren()) do

			-- If its a tool
			if v:IsA("Tool") then

				-- Add it to the player tools
				table.insert(playerTools, v)
			end
		end

		----------------------------------------
		-- Search through tools for this Tool --
		----------------------------------------

		for _, tool in pairs(playerTools) do

			-- If its trhe vial
			if tool.Name == "VialWithPoison" then

				-- PLayer has Tool
				playerHasTool = true
				
				-- Set Object
				vialWithPoisonObject = tool

				-- Leave
				break
			end
		end

		-- If they had the poison..
		if playerHasTool then
			
			-- Has Been talked to twice
			hasBeenTalkedToTwice = true

			-- Disable Prox Prompt..
			thisProx.Enabled = false
			
			-- Close Weapons Bench
			game.ReplicatedStorage.ClosePlayerWeaponsBenchSTC:FireAllClients()
			
			-- Take Rat Poison
			vialWithPoisonObject:Destroy()
			
			-- Play talkiong anim
			idleTrack:Stop()
			talkingTrack:Play()

			-- Say Second Speech..
			secondSpeechSound:Play()
			
			-- Wait until speech is over.
			task.wait(secondSpeechSound.TimeLength)
			
			-- Animation
			talkingTrack:Stop()
			idleTrack:Play()

			-- Objective 8 Complete
			game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(8) -- Talked to Scientist 2nd Time
			
			-- Phone Prox Ready..
			game.ReplicatedStorage.MissionEvents.PhoneCallReadyToServer:Fire()
			
			-- Show Tray
			thisTray.Transparency = 0
			trayProx.Enabled = true

			-- Reenable it
			thisProx.Enabled = true
			
			-- Nil Stuff
			playerTools = nil
			playerHasTool = nil
			
			-- Leave
			return
			
		end
		
		-- Nil Stuff
		playerTools = nil
		playerHasTool = nil
	end
	
	-- Check for Recieving the Bomb
	if readyToReceiveBomb and hasReceivedBomb == false then
		
		-- Has Received
		hasReceivedBomb = true
		
		-- Disable Prox Prompt..
		thisProx.Enabled = false
		
		-- Animate
		idleTrack:Stop()
		talkingTrack:Play()
		
		-- Put finished Bomb in Players Inventory..
		local clone = game.ServerStorage.Tools.EasterEggParts.FoggerMachineModded:Clone()

		-- Put into workspace
		clone.Parent = player:FindFirstChild("Backpack")

		-- Nil it
		clone = nil
		
		-- Ahh Here the bomb..
		heresTheBombSound:Play()
		
		-- Wait for it
		task.wait(heresTheBombSound.TimeLength)
		
		-- Animation
		talkingTrack:Stop()
		idleTrack:Play()
		
		-- Wait
		task.wait(1)
	
		-- Disable Prox Prompt..
		thisProx.Enabled = true
		
		-- Mission Stuff
		game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(15)
		
		-- Leave
		return
	end
	
	-- Open the Weapons Bench
	game.ReplicatedStorage.PlayerOpenedWeaponsBench:FireClient(player)
	
end)

-- Tray Prox
trayProxConnection = trayProx.Triggered:Connect(function(player)

	-- Add Tool in Hand if eligible
	for _, v in pairs(player.Character:GetChildren()) do

		-- If its a tool
		if v:IsA("Tool") then
			
			-- If its a tool we need..
			if v.Name == "ElectronicComponent" then
				
				-- Destroy the tool..
				v:Destroy()
				
				-- Show Component on tray..
				thisTray.ElectronicComponentPart.Transparency = 0
				thisTray.ElectronicComponentPart.Parts.Transparency = 0
				thisTray.ElectronicComponentPart.Texture.Transparency = 0.45
				
				-- Mission Complete
				game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(9)
				
			end
			
			-- If its a tool we need..
			if v.Name == "AerosolCan" then

				-- Destroy the tool..
				v:Destroy()
				
				-- Add one to Cans
				numAerosolCans += 1
				
				-- Show proper Cans
				if numAerosolCans == 1 then
					
					-- Show Can 1
					thisTray.AerosolCanPart1.Transparency = 0
					thisTray.AerosolCanPart1.Can.Transparency = 0
					thisTray.AerosolCanPart1.Top.Transparency = 0
					thisTray.AerosolCanPart1.Decal1.Transparency = 0
					thisTray.AerosolCanPart1.Decal2.Transparency = 0
					
				elseif numAerosolCans == 2 then
					
					-- Show Can 2
					thisTray.AerosolCanPart2.Transparency = 0
					thisTray.AerosolCanPart2.Can.Transparency = 0
					thisTray.AerosolCanPart2.Top.Transparency = 0
					thisTray.AerosolCanPart2.Decal1.Transparency = 0
					thisTray.AerosolCanPart2.Decal2.Transparency = 0
					
				elseif numAerosolCans == 3 then
					
					-- Show Can 3
					thisTray.AerosolCanPart3.Transparency = 0
					thisTray.AerosolCanPart3.Can.Transparency = 0
					thisTray.AerosolCanPart3.Top.Transparency = 0
					thisTray.AerosolCanPart3.Decal1.Transparency = 0
					thisTray.AerosolCanPart3.Decal2.Transparency = 0
					
					-- Mission Complete
					game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(10)
					
				end
			end
			
			-- If its the fogger..
			if v.Name == "FoggerMachine" then
				
				-- Destroy fogger
				v:Destroy()
				
				-- Show Fogger.
				thisTray.FoggerPart.Transparency = 0
				
				-- Mission Complete
				game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(14)				
				
			end
			
			-- If its Blood
			if v.Name == "VialWithBlood" then
				
				-- If we already gave the vials, exit..
				if numVialsForPoison >= 10 then
					
					-- Exit
					return
				end
				
				-- Destroy Part..
				v:Destroy()
				
				-- Play Sound
				script.Parent.Parent.Head.CeramicHandle:Play()
				
				-- Add one to Vials
				numVialsForPoison += 1

				-- Show proper Cans
				if numVialsForPoison == 1 then

					-- Show Vial 1
					thisTray.Vial1.Transparency = 0.7
					thisTray.Vial1.Ends.Transparency = 0
					thisTray.Vial1.Blood.Transparency = 0

				elseif numVialsForPoison == 2 then

					-- Show Vial 2
					thisTray.Vial2.Transparency = 0.7
					thisTray.Vial2.Ends.Transparency = 0
					thisTray.Vial2.Blood.Transparency = 0

				elseif numVialsForPoison == 3 then

					-- Show Vial 3
					thisTray.Vial3.Transparency = 0.7
					thisTray.Vial3.Ends.Transparency = 0
					thisTray.Vial3.Blood.Transparency = 0
					
				elseif numVialsForPoison == 4 then

					-- Show Vial 4
					thisTray.Vial4.Transparency = 0.7
					thisTray.Vial4.Ends.Transparency = 0
					thisTray.Vial4.Blood.Transparency = 0

				elseif numVialsForPoison == 5 then

					-- Show Vial 3
					thisTray.Vial5.Transparency = 0.7
					thisTray.Vial5.Ends.Transparency = 0
					thisTray.Vial5.Blood.Transparency = 0

				elseif numVialsForPoison == 6 then

					-- Show Vial 6
					thisTray.Vial6.Transparency = 0.7
					thisTray.Vial6.Ends.Transparency = 0
					thisTray.Vial6.Blood.Transparency = 0

				elseif numVialsForPoison == 7 then

					-- Show Vial 7
					thisTray.Vial7.Transparency = 0.7
					thisTray.Vial7.Ends.Transparency = 0
					thisTray.Vial7.Blood.Transparency = 0

				elseif numVialsForPoison == 8 then

					-- Show Vial 8
					thisTray.Vial8.Transparency = 0.7
					thisTray.Vial8.Ends.Transparency = 0
					thisTray.Vial8.Blood.Transparency = 0

				elseif numVialsForPoison == 9 then

					-- Show Vial 9
					thisTray.Vial9.Transparency = 0.7
					thisTray.Vial9.Ends.Transparency = 0
					thisTray.Vial9.Blood.Transparency = 0

				elseif numVialsForPoison == 10 then

					-- Show Vial 10
					thisTray.Vial10.Transparency = 0.7
					thisTray.Vial10.Ends.Transparency = 0
					thisTray.Vial10.Blood.Transparency = 0
					
					-- Mission Complete
					game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(11)

				end				
			end
		end
	end
end)

-- Keep Up with which Objectives have been completed..
game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer.Event:Connect(function(id)
	
	-- If ID was 7.. then we have made the Rat Poison..
	if id == 7 then
		
		-- Second Speech is ready
		secondSpeechReady = true
	end
end)

-- Checkl for 3rd Speech Call
game.ReplicatedStorage.MissionEvents.Scientist3rdSpeechServerToServer.Event:Connect(function()
	
	-- Close Weapons Bench
	game.ReplicatedStorage.ClosePlayerWeaponsBenchSTC:FireAllClients()
	
	-- Disable Prox Prompt..
	thisProx.Enabled = false
	
	-- UnAnchor Scientist
	script.Parent.Parent:FindFirstChild("HumanoidRootPart").Anchored = false
	
	-- Disconnect Tray Prox
	trayProxConnection:Disconnect()
	trayProxConnection = nil
	
	-- Animate
	idleTrack:Stop()
	talkingTrack:Play()
	
	-- Play Third Speech
	thirdSpeechSound:Play()
	
	-- Wait for the speech to end..
	task.wait(thirdSpeechSound.TimeLength)
	
	-- Animation
	talkingTrack:Stop()
	
	-- Wait
	task.wait(1)
	
	-- Destroy Tray
	thisTray:Destroy()
	
	-- Speech OIver
	game.ReplicatedStorage.MissionEvents.Scientist3rdSpeechOver:Fire()
	
	-- Unlock Containment Door..
	game.ReplicatedStorage.MissionEvents.UnlockContainmentDoorSTS:Fire()
	
	-- turn on VentFanScript..
	workspace.Level.VentRoom.VentFan.VentFan.VentFanScript.Enabled = true
	
	-- Wait
	task.wait(1)
	
	--------------------------------------
	-- Scientist Starts Making the Bomb --
	--------------------------------------
	
	-- Move Scientist to workbench..
	script.Parent:MoveTo(workspace.Level.ScientistWorkBenchPointPart.Position)	
	
	-- Walk Animation
	walkTrack:Play()
	
	-- Wait a second
	task.wait(1)
	
	-- Stop Walking Track
	walkTrack:Stop()
	
	-- Place into spot..
	script.Parent.Parent.HumanoidRootPart.CFrame = CFrame.new(107.5, 38.5, 75.25) * CFrame.Angles(0, math.rad(-90), 0)
	
	-- Re Anchor
	script.Parent.Parent:FindFirstChild("HumanoidRootPart").Anchored = true
	
	-- Now Stop Idle and Start Workbench Track
	workBenchTrack:Play()
	
	------------------------------
	-- Start Timer to Make Bomb --
	------------------------------
	
	-- Wait Time
	task.wait(BOMBMAKING_TIME)
	
	-- Stop Idle
	workBenchTrack:Stop()
	
	-- UnAnchor Scientist
	script.Parent.Parent:FindFirstChild("HumanoidRootPart").Anchored = false
	
	-- Wait To unAnchor
	task.wait(4)		
	
	-- Move Scientist to workbench..
	script.Parent:MoveTo(workspace.Level.ScientistNormalPointPart.Position)
	
	-- Walk Animation
	walkTrack:Play()
	
	-- Wait
	task.wait(1)

	-- Stop Walking Track
	walkTrack:Stop()
	
	-- Set Into Position..
	script.Parent.Parent.HumanoidRootPart.CFrame = CFrame.new(102.017, 38.471, 75.253) * CFrame.Angles(0, math.rad(90), 0)

	-- Re Anchor
	script.Parent.Parent:FindFirstChild("HumanoidRootPart").Anchored = true
	
	-- Wait
	task.wait(1)

	-- Now Play Idle Again..
	if workBenchTrack.IsPlaying then workBenchTrack:Stop() end
	if walkTrack.IsPlaying then walkTrack:Stop() end
	if not idleTrack.IsPlaying then idleTrack:Play() end
	
	-- Now Ready to recieve Bomb
	readyToReceiveBomb = true
	
	-- ReEnable Prox Prompt
	thisProx.Enabled = true	
	
	-- Unlock Scientist Door
	game.ReplicatedStorage.UnlockScientistDoorSTS:Fire()
	
end)

-- Check for Bomb Set..
game.ReplicatedStorage.MissionEvents.BombSetSTS.Event:Connect(function()
	
	-- Bomb Set
	bombWasSet = true
	
end)
----------
-- Init --
----------

-- Tray Not Accessible at start..
trayProx.Enabled = false

-- Make Tray Invisible
thisTray.Transparency = 1

-- Make all Tray Stuff invisible..
for _, child in pairs(thisTray:GetDescendants()) do
	
	-- If its a basepart..
	if child:IsA("BasePart") then
		
		-- Make Invisible
		child.Transparency = 1
		
	elseif child:IsA("Decal") then
		
		-- Make Invisible
		child.Transparency = 1
	end
end

-- PLay Idle Animation
idleTrack:Play()