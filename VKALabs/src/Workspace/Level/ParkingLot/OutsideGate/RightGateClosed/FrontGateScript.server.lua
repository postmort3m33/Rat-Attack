-- Script Enabled from missions Controller when Mission number 12 is completed..

-- State
local playerMinDistance = 50

-- Playe rRange Emitter
local playerRangePart = script.Parent:WaitForChild("PlayerRange")
local playerRangeEmitter = playerRangePart.ParticleEmitter
playerRangePart.Size = Vector3.new(0.125, playerMinDistance * 2, playerMinDistance * 2)

-- Timer Stuff
local timerTextLabel = playerRangePart.TimerPart.SurfaceGui.Timer

-- state Vars
local gateEventOver = false

-- Swat Van from Shop
local swatVanFromShop = workspace.CutsceneStuff.SwatVanFromShop
local pmpcDummy = workspace.CutsceneStuff.PMPCGuy

-- Intro Swat Van
local ogSwatVanLight1 = workspace.CutsceneStuff.SwatVan.Part1
local ogSwatVanLight2 = workspace.CutsceneStuff.SwatVan.Part2

----------------------
-- Gate Event start --
----------------------

-- Player Notification Timer
local notifyPlayersInterval = 8
local lastNotifyPlayers = time()	
-- Vars
local playerList = game.Players:GetPlayers()
local playerDistance = 0

-- State Vars
local gateEventOver = false
local playersByGate = false
local aPlayerWasNotByGate = false

-- Gate Timer Stuff
local startedGateTimer = false
local timerCoroutine = nil
local EVENT_TIME = 180 -- Default: 180

---------------
-- Functions --
---------------

-- Seconds to Minutes/Seconds
local function FormatTime(timeNumber)
	
	-- Ref
	local min, sec = tostring(math.floor(timeNumber / 60)), tostring(timeNumber % 60)
	
	-- Logic
	if #sec == 1 then
		sec = "0" .. sec
	end
	
	-- Return string..
	return tostring(min)..":"..tostring(sec)
end

-- Timer
local function SecureGateTimer()
	
	-- Turn on SwatVanLights
	ogSwatVanLight1.SurfaceLight.Enabled = true
	ogSwatVanLight2.SurfaceLight.Enabled = true
	ogSwatVanLight1.Color = Color3.fromRGB(163, 162, 165)
	ogSwatVanLight2.Color = Color3.fromRGB(163, 162, 165)
		
	-- Setup Timer
	timerTextLabel.Text = FormatTime(EVENT_TIME)
	
	-- Reset Timer..
	local timerActual = EVENT_TIME
	
	-- Timer Loop
	while task.wait(1) do
		
		-- Add to Timer
		timerActual -= 1
		
		-- Disaply New time
		timerTextLabel.Text = FormatTime(timerActual)
		
		-- Cancel if playerNotByGate
		if playersByGate == false then
			
			-- Turn off Drums
			game.ReplicatedStorage.FrontGateEventEndedSTC:FireAllClients()
			
			-- Turn on SwatVanLights
			ogSwatVanLight1.SurfaceLight.Enabled = false
			ogSwatVanLight2.SurfaceLight.Enabled = false
			ogSwatVanLight1.Color = Color3.fromRGB(0,0,0)
			ogSwatVanLight2.Color = Color3.fromRGB(0,0,0)
			
			-- Turn Off Timer..
			timerTextLabel.Text = "Waiting for All Players.."
			
			-- reset by gate
			startedGateTimer = false
			
			-- Break..
			break
		end
		
		-- If timer is Over
		if timerActual <= 0 then
			
			-- break and event over..
			gateEventOver = true
			
			-- Break
			break
		end		
	end
end

----------
-- Init --
----------

-- Make Emitter Red..
playerRangeEmitter.Color = ColorSequence.new(Color3.fromRGB(255,0,0))

-- turn on Particle Emitter
playerRangeEmitter.Enabled = true

-- Empty Timer Label
timerTextLabel.Text = "Waiting for All Players.."

-- Stop Spawning Outside
game.ReplicatedStorage.OutsideRatSpawnSwitch:Fire()
	
---------------
-- Main Loop --
---------------	
while gateEventOver == false do
	
	-- Refresh Player List..
	playerList = game.Players:GetPlayers()
	
	-- Reset Var
	aPlayerWasNotByGate = false

	-- Make Sure Players stay in distance..
	for _, player in pairs(playerList) do

		-- Get distance
		if player.Character then
			
			-- Player Distance
			playerDistance = (player.Character.PrimaryPart.CFrame.Position - playerRangePart.CFrame.Position).Magnitude

			-- If any players leave gate area, cancel loop..
			if playerDistance > playerMinDistance then
				
				-- A PLayer was not by gate
				aPlayerWasNotByGate = true
				
			else -- Someone was bythe gate
				
				-- Send HUD Message to come to gate only if timer hasnt started..
				if startedGateTimer == false then
					
					-- If within Interval
					if (time() - lastNotifyPlayers) > notifyPlayersInterval then
						
						-- Set new Last
						lastNotifyPlayers = time()
						
						-- Run it
						game.ReplicatedStorage.SendPlayerHUDMessage:FireAllClients("All players must be near the Front Gate!")						
						
					end
				end				
			end			
		else
			
			-- Player not y Gat
			aPlayerWasNotByGate = true
			
		end

		-- Wait
		task.wait()			
	end
	
	-- Was a player not by gate?
	if aPlayerWasNotByGate then
		
		-- Players not by gate
		playersByGate = false
		
		-- Make Emitter Red..
		playerRangeEmitter.Color = ColorSequence.new(Color3.fromRGB(255,0,0))
		
		-- Turn on SwatVanLights
		ogSwatVanLight1.SurfaceLight.Enabled = false
		ogSwatVanLight2.SurfaceLight.Enabled = false
		ogSwatVanLight1.Color = Color3.fromRGB(0,0,0)
		ogSwatVanLight2.Color = Color3.fromRGB(0,0,0)
		
	else
		
		-- All by gate
		playersByGate = true
		
	end
	
	-- If there is a playerBytheGate
	if playersByGate and startedGateTimer == false then
		
		-- Started Gatetimer
		startedGateTimer = true
		
		-- Start Music
		game.ReplicatedStorage.FrontGateEventStartedSTC:FireAllClients()
		
		-- start a timer..
		timerCoroutine = coroutine.create(SecureGateTimer)
		
		-- start It
		coroutine.resume(timerCoroutine)
		
		-- Make Emitter Normal..
		playerRangeEmitter.Color = ColorSequence.new(Color3.fromRGB(0,174,255))
		
	end

	-- Wait
	task.wait(1)
end	

-- Turn Off Timer..
timerTextLabel.Text = ""

-- Turn off PlayerRange
playerRangeEmitter.Enabled = false

-- Make sure van lights are off..
ogSwatVanLight1.SurfaceLight.Enabled = false
ogSwatVanLight2.SurfaceLight.Enabled = false
ogSwatVanLight1.Color = Color3.fromRGB(0,0,0)
ogSwatVanLight2.Color = Color3.fromRGB(0,0,0)

-- PLay Satelliote Ring..
game.ReplicatedStorage.DingSound:FireAllClients()

-- End Music
game.ReplicatedStorage.FrontGateEventEndedSTC:FireAllClients()

--------------------
-- Start CutScene --
--------------------

-- Show Van
for _, part in pairs(swatVanFromShop:GetDescendants()) do
	
	-- if a basepart..
	if part:IsA("BasePart") then
		
		-- Show it
		part.Transparency = 0
	end
end

-- Keep Teleport Points Transparent..
swatVanFromShop.PMPCGuyTeleportPoint.Transparency = 1
swatVanFromShop.PMPCGuyMoveToPoint1.Transparency = 1

-- Play Engine Idle
swatVanFromShop.Body.EngineIdle:Play()

-- Play Metal Songs..
swatVanFromShop.Body.MetalSong:Play()
swatVanFromShop.Body.MetalSongMuffled:Play()

-- Mute Loud One..
swatVanFromShop.Body.MetalSong.Volume = 0

-- Make Van Drive Up..
local TweenInformation = TweenInfo.new(11, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
local TweenDetails = {
	["CFrame"] = swatVanFromShop.PrimaryPart.CFrame * CFrame.new(0, 0, -460)
}

local Tween = game.TweenService:Create(swatVanFromShop.PrimaryPart, TweenInformation, TweenDetails)
Tween:Play()
Tween.Completed:Wait()

-- Slow down Enging Idle..
swatVanFromShop.Body.EngineIdle.PlaybackSpeed = 0.5

-- Play Honk
swatVanFromShop.Body.TruckHonk:Play()

-- Play Brakes Sound
swatVanFromShop.Body.SlamBrakes:Play()

-- Do Slow Down Tween..
TweenInformation = TweenInfo.new(2, Enum.EasingStyle.Circular, Enum.EasingDirection.Out)
TweenDetails = {
	["CFrame"] = swatVanFromShop.PrimaryPart.CFrame * CFrame.new(0, 0, -15) * CFrame.Angles(0, math.rad(66), 0)
}
Tween = game.TweenService:Create(swatVanFromShop.PrimaryPart, TweenInformation, TweenDetails)
Tween:Play()
Tween.Completed:Wait()

-- Open Door
swatVanFromShop.Body.DoorOpen:Play()

-- Switch to loud metal song..
swatVanFromShop.Body.MetalSong.Volume = 0.5
swatVanFromShop.Body.MetalSongMuffled.Volume = 0

---------------------------
-- Start Animating Dummy --
---------------------------

-- Get humanoid
local dummyHumanoid = pmpcDummy:WaitForChild("Humanoid")
local walkAnimationTrack = pmpcDummy.Humanoid.Animator:LoadAnimation(pmpcDummy.Humanoid.Walk)
local partPickedUp = false

-- Here Man Sound Table
local hereManSound = workspace.CutsceneStuff.PMPCGuy.Head.HereMan
local heresYourFoggerSound = workspace.CutsceneStuff.PMPCGuy.Head.HeresYourFogger
local comeGetThisSound = workspace.CutsceneStuff.PMPCGuy.Head.ComeGetThis
local outtaHereSound = workspace.CutsceneStuff.PMPCGuy.Head.ImOuttaHere
local hereManSoundArray = {hereManSound, heresYourFoggerSound, comeGetThisSound}
local lastHereMan = time()
local hereManInterval = 1
local walkingSound = workspace.CutsceneStuff.PMPCGuy.RightFoot.Walking
local foggerProxPrompt = pmpcDummy.FoggerMachine.Handle.ProximityPrompt

-- Turn off Fogger Prox Prompt
foggerProxPrompt.Enabled = false

-- Check for Part Removal..
pmpcDummy.ChildRemoved:Connect(function(child)

	-- If it was a tool..
	if child:IsA("Tool") then

		-- Part Picked Up
		partPickedUp = true

		-- Play the Sound
		outtaHereSound:Play()

	end
end)

-- Lower Walk Speed
dummyHumanoid.WalkSpeed = 12

-- UnAnchor him
pmpcDummy.PrimaryPart.Anchored = false

-- Move Dummy into Place
pmpcDummy.PrimaryPart.CFrame = workspace.CutsceneStuff.SwatVanFromShop.PMPCGuyTeleportPoint.CFrame

-- Wait
task.wait(3)

-- Move to Point1
dummyHumanoid:MoveTo(workspace.CutsceneStuff.SwatVanFromShop.PMPCGuyMoveToPoint1.Position)

-- Play Animation Track
walkAnimationTrack:Play()

-- Play Walk Sound
walkingSound:Play()

-- when we make it to the point..
--dummyHumanoid.MoveToFinished:Wait()
task.wait(1.5)

-- Place into spot..
pmpcDummy.PrimaryPart.CFrame = workspace.CutsceneStuff.SwatVanFromShop.PMPCGuyMoveToPoint1.CFrame

-- Move to Point 2
dummyHumanoid:MoveTo(workspace.CutsceneStuff.PMPCGuyMoveToPoint2.Position)

-- when we make it to the point..
--dummyHumanoid.MoveToFinished:Wait()
task.wait(2)

-- Place into spot..
pmpcDummy.PrimaryPart.CFrame = workspace.CutsceneStuff.PMPCGuyMoveToPoint2.CFrame

-- Stop Walking Trak
walkAnimationTrack:Stop()

-- Stop Walking
walkingSound:Stop()

-- Enable Fogger Prox Prompt
foggerProxPrompt.Enabled = true

-- Wait
task.wait()

-- Now Wait for Part to be Picked up..
while partPickedUp == false do
	
	-- Only in Intervals
	if (time() - lastHereMan) > hereManInterval then
		
		-- Reset last
		lastHereMan = time()
		
		-- Random
		hereManSoundArray[math.random(1, #hereManSoundArray)]:Play()	
		
		-- Random Interval
		hereManInterval = math.random(10,30)
	end	
	
	-- Wait
	task.wait() 
end

-- Finished Objective
game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(13)

----------------------
-- Part Was Grabbed --
----------------------

-- Play Animation Track
walkAnimationTrack:Play()

-- Play Sound
walkingSound:Play()

-- Run back to Point1
dummyHumanoid:MoveTo(workspace.CutsceneStuff.SwatVanFromShop.PMPCGuyMoveToPoint1.Position)

-- Wait
--dummyHumanoid.MoveToFinished:Wait()
task.wait(2)

-- Place into spot..
pmpcDummy.PrimaryPart.CFrame = workspace.CutsceneStuff.SwatVanFromShop.PMPCGuyMoveToPoint1.CFrame

-- Move back to teleport Poinrt
dummyHumanoid:MoveTo(workspace.CutsceneStuff.SwatVanFromShop.PMPCGuyTeleportPoint.Position)

-- Wait
--dummyHumanoid.MoveToFinished:Wait()
task.wait(1.5)

-- Place into spot..
pmpcDummy.PrimaryPart.CFrame = workspace.CutsceneStuff.SwatVanFromShop.PMPCGuyTeleportPoint.CFrame

-- Stop Walking
walkingSound:Stop()

-- Stop Walk animation
walkAnimationTrack:Stop()

-- Destroy Dummy
pmpcDummy:Destroy()

-----------------------
-- Van Take Back Off --
-----------------------

-- Wait
task.wait(2)

-- Open Close
swatVanFromShop.Body.DoorClose:Play()

-- Switch to Muffled metal song..
swatVanFromShop.Body.MetalSong.Volume = 0
swatVanFromShop.Body.MetalSongMuffled.Volume = 0.5

-- Wait
task.wait(1)

-- Play Peel /out sound
swatVanFromShop.Body.PeelOut:Play()

-- Turn off Engine Idle
swatVanFromShop.Body.EngineIdle:Stop()

-- turn Van Around and Leave
TweenInformation = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
TweenDetails = {
	["CFrame"] = swatVanFromShop.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(114), 0)
}
Tween = game.TweenService:Create(swatVanFromShop.PrimaryPart, TweenInformation, TweenDetails)
Tween:Play()
Tween.Completed:Wait()

-- Drive Off Fast Sound
swatVanFromShop.Body.DriveOffFast:Play()

-- Make Van Drive Away..
TweenInformation = TweenInfo.new(11, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
TweenDetails = {
	["CFrame"] = swatVanFromShop.PrimaryPart.CFrame * CFrame.new(0, 0, -460)
}

Tween = game.TweenService:Create(swatVanFromShop.PrimaryPart, TweenInformation, TweenDetails)
Tween:Play()
Tween.Completed:Wait()

-- Destroy the Whole Van
swatVanFromShop:Destroy()

-- Spawn Outside again..
game.ReplicatedStorage.OutsideRatSpawnSwitch:Fire() -- turning Back On








