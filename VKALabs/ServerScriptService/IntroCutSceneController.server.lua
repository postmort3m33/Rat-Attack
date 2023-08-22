-------------------------------------------------------------
-- Cutscene Starts when Lobby is full and Game has started --
-------------------------------------------------------------

-- State Vars
local CUTSCENE_STARTED = false
local CUTSCENE_OVER = false

-- TimeLine Vars
local vanFinishedDriving = false

-- Follow Points
local playerTeleportPoint = workspace.CutsceneStuff.PlayerTeleportPoint

-- Sounds
local slamBrakesSound = workspace.CutsceneStuff.SwatVan.Body.SlamBrakes
local engineSound = workspace.CutsceneStuff.SwatVan.Body.EngineIdle
local doorOpenClose = workspace.CutsceneStuff.SwatVan.Body.DoorOpenClose

-- Objects
local swatVan = workspace.CutsceneStuff:WaitForChild("SwatVan")

-- Seats
local seat1 = workspace.CutsceneStuff.SwatVan.CabAndBed.Seat1
local seat2 = workspace.CutsceneStuff.SwatVan.CabAndBed.Seat2
local seat3 = workspace.CutsceneStuff.SwatVan.CabAndBed.Seat3
local seat4 = workspace.CutsceneStuff.SwatVan.CabAndBed.Seat4

-----------------
-- Connections --
-----------------

-- Listen for the start of trhe game..
game.ServerStorage.ServerEvents.StartCutScene.Event:Connect(function()
	
	-- Game Has Started.. 
	CUTSCENE_STARTED = true
	
end)

-- Wait for game to start..
while CUTSCENE_STARTED == false do task.wait() end

---------------
-- Functions --
---------------

--- Van Driving Up Coroutine
local function VanDrivingUp()

	-- Move from Start to End Waypoint --
	local TweenInformation = TweenInfo.new(11, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local TweenDetails = {
		["CFrame"] = swatVan.PrimaryPart.CFrame * CFrame.new(0, 0, -520)
	}

	local Tween = game.TweenService:Create(swatVan.PrimaryPart, TweenInformation, TweenDetails)
	Tween:Play()
	Tween.Completed:Wait()
	
	-- Change Engine idle
	engineSound.PlaybackSpeed = 0.5
	
	-- Play Brakes Sound
	slamBrakesSound:Play()
	
	-- Do Slow DownTween..
	TweenInformation = TweenInfo.new(2, Enum.EasingStyle.Circular, Enum.EasingDirection.Out)
	TweenDetails = {
		["CFrame"] = swatVan.PrimaryPart.CFrame * CFrame.new(3, 0, -15) * CFrame.Angles(0, math.rad(30), 0)
	}
	Tween = game.TweenService:Create(swatVan.PrimaryPart, TweenInformation, TweenDetails)
	Tween:Play()
	Tween.Completed:Wait()
	
	-- Open and Close Doors..
	doorOpenClose:Play()
	
	-- turn off Engine..
	engineSound:Stop()
	
	-- Player out of van..
	game.ReplicatedStorage.CutSceneEvents.VanStopped:FireAllClients()
	
	-- Van Finsihed
	vanFinishedDriving = true
end

-- Camera Switch coroutine
local function CameraSwitch()
	
	-- Cam TimeLine Switches
	local switch1 = 5
	local switch2 = 3
	
	-- Start TimeLine
	game.ReplicatedStorage.CutSceneEvents.CameraFollowCFrame:FireAllClients("SwatVanDriversCam")
	
	-- Wait
	task.wait(switch1)
	
	-- Change
	game.ReplicatedStorage.CutSceneEvents.CameraFollowCFrame:FireAllClients("SwatVanPlayersCam")
	
	--Wait
	task.wait(switch2)
	
	-- Change
	game.ReplicatedStorage.CutSceneEvents.CameraFollowCFrame:FireAllClients("SwatVanDriversCam")	

end

----------------------------
-- Start CutScene Actions --
----------------------------

-- Turn EntryRoadGrassWall On..
workspace.Level.EntryRoadGrassWall.Transparency = 0

-- Run coroutine for Van Driving Up..
local vanDriveUpCoroutine = coroutine.create(VanDrivingUp)
coroutine.resume(vanDriveUpCoroutine)
vanDriveUpCoroutine = nil

-- Run coroutine for Camera Switches....
local camSwitchCoroutine = coroutine.create(CameraSwitch)
coroutine.resume(camSwitchCoroutine)
camSwitchCoroutine = nil	

-- Now Run Main Loop
while CUTSCENE_OVER == false do
	
	-- If Van is finished, teleport players out of it..
	if vanFinishedDriving then
		
		-- Debounce
		vanFinishedDriving = false
		
		-- call Outside Rain Sound
		game.ReplicatedStorage.PlayOutdoorAmbienceSound:FireAllClients()
		
		-- Delete Van Seats..
		seat1.Disabled = true	
		seat2.Disabled = true
		seat3.Disabled = true
		seat4.Disabled = true
		
		-- Make Sure Seat Welds are Broken..
		while seat1:FindFirstChildOfClass("Weld") ~= nil do task.wait() end
		while seat2:FindFirstChildOfClass("Weld") ~= nil do task.wait() end
		while seat3:FindFirstChildOfClass("Weld") ~= nil do task.wait() end
		while seat4:FindFirstChildOfClass("Weld") ~= nil do task.wait() end
		
		task.wait(2)
					
		-- local Get Player List
		local playerList = game.Players:GetPlayers()
		
		-- Loop through them
		for _, player in pairs(playerList) do
			
			-- Ref humanoid..
			local thisHumanoid = player.Character:WaitForChild("Humanoid")
			
			-- Unsit..
			thisHumanoid.Sit = false
			
			-- Teleport
			player.Character:MoveTo(playerTeleportPoint.Position + Vector3.new(math.random(2,5), 0 , math.random(2,5)))
			
			-- Re-enable walkspeed and jumppower
			thisHumanoid.WalkSpeed = 16
			thisHumanoid.JumpPower = 50
			
			-- Nil
			thisHumanoid = nil
			
			-- Wait
			task.wait(0.5)
		end
		
		-- CutScene Now Over..
		CUTSCENE_OVER = true
		
		-- Let Client know Cutscene is Over
		game.ReplicatedStorage.CutSceneEvents.CutSceneOverFromServer:FireAllClients()
		
		-- Let Server know Cutscene is Over..
		game.ReplicatedStorage.CutSceneEvents.CutSceneOverSTS:Fire()
		
		-- Make Van Collision Enabled..
		workspace.CutsceneStuff.SwatVan.Body.CanCollide = true
		
		-- Close gates
		workspace.Level.ParkingLot.OutsideGate.RightGateOpen.Union.Transparency = 1
		--workspace.Level.ParkingLot.OutsideGate.RightGateClosed.Gate.CanCollide = true
		workspace.Level.ParkingLot.OutsideGate.RightGateClosed.Gate.Transparency = 0
		
		-- Turn off Van Headlights and Cab Light and radio..
		workspace.CutsceneStuff.SwatVan.Part1.SurfaceLight.Enabled = false
		workspace.CutsceneStuff.SwatVan.Part2.SurfaceLight.Enabled = false
		workspace.CutsceneStuff.SwatVan.Part1.Color = Color3.fromRGB(0,0,0)
		workspace.CutsceneStuff.SwatVan.Part2.Color = Color3.fromRGB(0,0,0)
		--workspace.CutsceneStuff.SwatVan.Part1:Destroy()
		--workspace.CutsceneStuff.SwatVan.Part2:Destroy()
		workspace.CutsceneStuff.SwatVan.BackLight:Destroy()
		workspace.CutsceneStuff.SwatVan.RadioPart:Destroy()
		
		-- Destroy Farthest Rain FX (Optimization)
		workspace.Level.RainFX.RainFX3:Destroy()
		
		-- Nil Stuff
		playerList = nil
		
	end
	
	-- Wait
	task.wait()
end

----------------------
-- Cutscene is Over --
----------------------

-- Fire StartGame Event...
game.ServerStorage.ServerEvents.StartGame:Fire()

-- Fire Event to Send to Clients for GUI To Start..
game.ReplicatedStorage.StartGameFromServer:FireAllClients()

