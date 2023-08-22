-- Let Server Boot --
task.wait(5)

-- Services --
local RunService = game:GetService("RunService")

-- This entity --
local thisShip = script.Parent
local fireEmitter = thisShip.Fire.FireEmitter
local fireEmitterCrashed = thisShip.Fire.FireEmitterCrashed
local fireBallEmitter = thisShip.FireBall.FireParticle
local smokeEmitterCrashed = thisShip.Fire.SmokeEmitterCrashed

-- Start Position --
local crashPoint = workspace.Level.Skyroom.SatelliteCrashPoint

-- Tween Stuff
local mainTween = nil
local currentTweenDegree = 220
local tweenRadius = 300
local timeForOneDegree = (math.floor((((math.pi * tweenRadius) / 5) / 360) * 100)) / 100
local tweenOriginPos = Vector3.new(75 - tweenRadius, 400, 75 + tweenRadius)

-- Connections --
local heartbeatConnection = nil

-- Other vars --
local tweening = false
local isCrashing = false

---------------
-- Functions --
---------------

-- Crash Event..
local function RunCrashEvent()
	
	-- Fire Ding
	game.ReplicatedStorage.DingSound:FireAllClients()

	-- Ref current Position..
	local currentCFrame = thisShip.PrimaryPart.CFrame

	-- Pause Main Tween
	mainTween:Cancel()

	-- Set it
	thisShip.PrimaryPart.CFrame = currentCFrame

	-- start fire..
	fireEmitter.Enabled = true
	fireBallEmitter.Enabled = true

	-- Play Crashingsound
	thisShip.Body.CrashingSound:Play()

	-- start Tween to Observatory
	local TweenInformation = TweenInfo.new(9.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local TweenDetails = {
		["CFrame"] = crashPoint.CFrame
	}

	local tween = game.TweenService:Create(thisShip.PrimaryPart, TweenInformation, TweenDetails)
	tween:Play()
	tween.Completed:Wait()

	-- Create Explision
	local explosion = Instance.new("Explosion")
	explosion.BlastRadius = 0
	explosion.BlastPressure = 0
	explosion.Visible = true
	explosion.DestroyJointRadiusPercent = 0
	explosion.ExplosionType = Enum.ExplosionType.NoCraters -- doesnt damage terrain
	explosion.Position = thisShip.PrimaryPart.CFrame.Position
	explosion.Parent = thisShip.Fire
	explosion.TimeScale = 0.33

	-- Play Explosion Sound
	thisShip.Body.Explosion:Play()

	-- Stop Crashing Sound
	thisShip.Body.CrashingSound:Stop()

	-- Shake Everyones Screen
	game.ReplicatedStorage.CameraShake:FireAllClients(2)

	-- Change Fires
	fireEmitter.Enabled = false
	fireBallEmitter.Enabled = false
	fireEmitterCrashed.Enabled = true		

	-- Lighten the Solar Panels
	thisShip.SolarPanel1.Texture1.Color3 = Color3.fromRGB(255,255,255)
	thisShip.SolarPanel1.Texture2.Color3 = Color3.fromRGB(255,255,255)		
	thisShip.SolarPanel2.Texture1.Color3 = Color3.fromRGB(255,255,255)	
	thisShip.SolarPanel2.Texture2.Color3 = Color3.fromRGB(255,255,255)

	-- Wait
	task.wait(3)

	-- Spawn Saw Tool --
	local fuseClone = game.ServerStorage.Tools.EasterEggParts.FusePart:Clone()

	-- Parent
	fuseClone.Parent = game.Workspace

	-- Position/Rotation
	fuseClone.Position = Vector3.new(90.625, 56.444, 61.059)
	fuseClone.Orientation = Vector3.new(0,0,0)	

	-- Nil Stuff
	fuseClone = nil

	-- Let Firte Burn for a minute..
	task.wait(20)

	-- Turn it off.
	fireEmitterCrashed.Enabled = false

	-- Turn on Smoke Emitter
	smokeEmitterCrashed.Enabled = true

	-- Wait 20 more seconds
	task.wait(33)

	-- disasble Smoke
	smokeEmitterCrashed.Enabled = false	
	
end

-----------------------------
-- Main heartbeat Loop --
-----------------------------
heartbeatConnection = RunService.Heartbeat:Connect(function()	
	
	---------------------------------------
	-- Tween in an orbit above the level --
	---------------------------------------	
	
	-- If not tweening --
	if not tweening and isCrashing == false then
		
		-- Tweening
		tweening = true
		
		-- Move to the next degree
		currentTweenDegree += 1
		
		-- Circular degree
		if currentTweenDegree == 361 then currentTweenDegree = 1 end
		
		-- Calculate new Position
		local X = tweenRadius * math.cos(math.rad(currentTweenDegree))
		local Y = tweenRadius * math.sin(math.rad(currentTweenDegree))
		
		-- New Pos
		local newPosition = Vector3.new(X, 0, Y) + tweenOriginPos
		
		-- Move from Start to End Waypoint --
		local TweenInformation = TweenInfo.new(timeForOneDegree, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
		local TweenDetails = {
			["CFrame"] = CFrame.lookAt(newPosition, tweenOriginPos)
		}

		mainTween = game.TweenService:Create(thisShip.PrimaryPart, TweenInformation, TweenDetails)
		mainTween:Play()
		mainTween.Completed:Wait()
		
		-- Done Tweening -- 
		tweening = false
		
		-- Nil Stuff
		TweenInformation = nil
		TweenDetails = nil
	end
	
	-- Check if Satellite Health Value is 0..
	if isCrashing == false and script.Parent.Health.Value <= 0 then
		
		-- Is now Crashing
		isCrashing = true
		
		-- Run Crash Event..
		local crashCoroutine = coroutine.wrap(function()			
			
			-- Run Event..
			RunCrashEvent()
			
		end)()
		
		-- Wait a second..
		task.wait(1)
		
		-- Close Connection
		heartbeatConnection:Disconnect()
		heartbeatConnection = nil		
		
	end	
end)

