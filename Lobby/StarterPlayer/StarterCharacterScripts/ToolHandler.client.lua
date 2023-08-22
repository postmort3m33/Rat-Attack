-- Wait for game loaded..
while task.wait() do

	-- Break when game is loaded..
	if game:IsLoaded() then

		-- Leave
		break
	end
end

-- Load Character --
local thisPlayer = game.Players.LocalPlayer
if not thisPlayer.Character then thisPlayer.CharacterAdded:Wait() end
local thisCharacter = thisPlayer.Character
local thisHumanoid = thisCharacter:WaitForChild("Humanoid")
local thisRightHand = thisCharacter:WaitForChild("RightHand")
local mouse = game.Players.LocalPlayer:GetMouse()

-- Services
local contextActionService = game:GetService("ContextActionService")
local UIS = game:GetService("UserInputService")

-- Camera Vars --
local playerCamera = workspace.CurrentCamera

-- Mouse --
local thisPlayerMouse = thisPlayer:GetMouse() -- For Firing on XBOX or PC

-- Connection Vars --
local playButtonConnection = nil

-- State Vars --
local activeTool = nil
local flashlightOn = false
local toolIsAGun = false
local flamethrowerOn = false
local isReloading = false
local isFiring = false
local isSprinting = false
local leftShiftDown = false
local crossBowLoaded = false
local reloadAnimTrack = nil
local holdingADSButton = false
local usedThrowable = false
local isTouchScreen = false
local isGamePad = false

-- Gun Cooldown Times --
local PLASMAGUN_COOLDOWN_TIME = 0.33
local VIALGUN_COOLDOWN_TIME = 0.33
local AIRBLASTER_COOLDOWN_TIME = 1.8
local NAILGUN_COOLDOWN_TIME = 0.2
local NAILGUN_AUTO_COOLDOWN_TIME = 0.2
local BBGUN_COOLDOWN_TIME = 0.2
local BBGUN_AUTO_COOLDOWN_TIME = 0.2
local CROSSBOW_COOLDOWN_TIME = 1
local SHOTGUN_COOLDOWN_TIME = 0.5
local SHOTLIGHTDELAY = 0.1

-- Gun Reload Times
local reloadSound = nil
local PLASMAGUN_OVERHEAT_TIME = 2

-- PlasmaGun Vars
local plasmaGunHeat = 0
local plasmaGunHeatBarFrame = thisPlayer:WaitForChild("PlayerGui").MainGUI.WeaponGUIFrame.PlasmaGunFrame.HeatBarFrame.HeatBar

-- Flamethrower Gas Vars..
local FLAMETHROWER_MAX_AMMO = 400
local flamethrowerGas = FLAMETHROWER_MAX_AMMO
local flamethrowerGasBarFrame = thisPlayer:WaitForChild("PlayerGui").MainGUI.WeaponGUIFrame.FlamethrowerFrame.GasBarFrame.GasBar

-- Crossbow Vars:
local crossBowLoaded = false
local CROSSBOW_FIRE_RELOAD_DELAY = 0.33

-- Nailgun Vars
local NAILGUN_MAX_AMMO = 30
local nailGunAmmo = NAILGUN_MAX_AMMO
local nailGunAmmoFrame = thisPlayer:WaitForChild("PlayerGui").MainGUI.WeaponGUIFrame.NailgunFrame

-- Shotgun Vars
local SHOTGUN_MAX_AMMO = 8
local SHOTGUN_FIRE_RELOAD_DELAY = 0.15
local shotgunAmmo = SHOTGUN_MAX_AMMO
local shotgunAmmoFrame = thisPlayer:WaitForChild("PlayerGui").MainGUI.WeaponGUIFrame.ShotgunFrame

-- BBGun Vars
local BBGUN_MAX_AMMO = 50
local bbGunAmmo = BBGUN_MAX_AMMO
local bbGunAmmoFrame = thisPlayer:WaitForChild("PlayerGui").MainGUI.WeaponGUIFrame.BBGunFrame

-- Vial Gun Vars..
local VIALGUN_MAX_AMMO = 150
local vialGunAmmo = VIALGUN_MAX_AMMO
local vialGunAmmoBar = thisPlayer:WaitForChild("PlayerGui").MainGUI.WeaponGUIFrame.VialGunFrame.AmmoBarFrame.AmmoBar

-- RayCast Variables --
local RAYCAST_RANGE = 5000

-- Debounce Vars --
local mouse1Held = false
local activateToolFunctionRunning = false
local reloadFunctionRunning = false
local adsFunctionRunning = false
local sprintFunctionRunning = false

-- ViewModel Vars
local rotation_x = 0
local rotation_y = 0
local rotation_z = 0
local lerped_rotation_x=0
local lerped_rotation_y = 0
local lerped_rotation_z = 0
local lerp_increment = 0.175
local aim_lerp_increment_x = 0.2
local aim_lerp_increment_y = 0.1
local aim_lerp_increment_z = 0.4
local x_mouse_movement = 0
local y_mouse_movement = 0
local sway_x = 0
local sway_y = 0
local lerped_sway_x = 0
local lerped_sway_y = 0
local last_x = 0
local last_y = 0
local max_sway_value = 2
local sway_weaken = 5
local xpos=1.7
local ypos=-0.8
local zpos=-3.1
local ogXPos = 0
local ogYPos = 0
local ogZPos = 0
local lerpedxpos=1.7
local lerpedypos=-0.8
local lerpedzpos=-3.1
local DEFAULT_FOV = 70
local FOV = DEFAULT_FOV
local beforenter
local aiming=false
local weapon
local item
local shaking = false
local shaking_extra_x=0
local shaking_extra_y=0
local shaking_extra_z=0

-- Weapon Fire Movements
local AIRBLASTER_FIRE_ROTATION = 0.33
local AIRBLASTER_FIRE_ZMOVE = 0.5
local AIRBLASTER_FIRE_YMOVE = 0
local PLASMAGUN_FIRE_ROTATION = 0.5
local PLASMAGUN_FIRE_ZMOVE = 0.5
local PLASMAGUN_FIRE_YMOVE = 0
local CROSSBOW_FIRE_ROTATION = 0.33
local CROSSBOW_FIRE_ZMOVE = 0.2
local CROSSBOW_FIRE_YMOVE = 0
local NAILGUN_FIRE_ROTATION = 0.1
local NAILGUN_FIRE_ZMOVE = 0.1
local NAILGUN_FIRE_YMOVE = 0
local SHOTGUN_FIRE_ROTATION = 0.2
local SHOTGUN_FIRE_ZMOVE = 1
local SHOTGUN_FIRE_YMOVE = 0.5
local VIALGUN_FIRE_ROTATION = 0.1
local VIALGUN_FIRE_ZMOVE = 0.1
local VIALGUN_FIRE_YMOVE = 0

-- Bobble Effect
local bobX = 0
local bobY = 0
local bobXDistance = 0.25
local bobYDistance = 0.5
local headBobTracker = 0

-- Xbox Thumbstick Input Stuff
local lastJoyXPos = 0
local lastJoyYPos = 0
local thumbstickDeadZone = 0.1 -- Minimum Thumbstick Position to register Gun Sway
local XBOX_SWAY_AMOUNT = 1.5 -- Max: 2.5

-- Sprint Vars
local SPRINT_SPEED_ADD = 5
local SPRINT_FOV = 65
local OG_WALKSPEED = thisHumanoid.WalkSpeed
local canSprint = false
local humanoidMoveDirection = nil

-- Stamina Vars
local currentStamina = 100
local MAX_STAMINA = 100
local STAMINA_REGEN_RATE = 0.33 -- per task.wait()
local STAMINA_USE_RATE = 0.2 -- Per task.wait()
local STAMINA_REGEN_COOLDOWN = 2
local staminaCanRegen = true
local lastStaminaRegen = time()
local staminaRegenInterval = 1.5 -- 1 Second
local currentStaminaFrame = thisPlayer:WaitForChild("PlayerGui").MainGUI.HUDFrame.StaminaFrame.CurrentStaminaFrame

----------
-- Init --
----------

-- ViewModel Setup
local viewModel = game.ReplicatedStorage:WaitForChild("GunSystem"):WaitForChild("View Model"):Clone()
viewModel.LeftHand.BrickColor = thisCharacter:WaitForChild("LeftHand").BrickColor
viewModel.LeftUpperArm.BrickColor = thisCharacter:WaitForChild("LeftUpperArm").BrickColor
viewModel.LeftLowerArm.BrickColor = thisCharacter:WaitForChild("LeftLowerArm").BrickColor
viewModel.RightHand.BrickColor = thisCharacter:WaitForChild("RightHand").BrickColor
viewModel.RightUpperArm.BrickColor = thisCharacter:WaitForChild("RightUpperArm").BrickColor
viewModel.RightLowerArm.BrickColor = thisCharacter:WaitForChild("RightLowerArm").BrickColor
viewModel.Parent = playerCamera

-- Get Default SHoulder Offsets..
local defaultLeftShoulderC1 = viewModel.LeftUpperArm.LeftShoulder.C1
local defaultRightShoulderC1 = viewModel.RightUpperArm.RightShoulder.C1

-- Change Footstep Sound..
local runningSound = thisCharacter:WaitForChild("HumanoidRootPart"):WaitForChild("Running")
runningSound.SoundId = "rbxassetid://12874750569"
runningSound.PlaybackSpeed = 1.25
runningSound.Volume = 0.05

------------------
-- Bob Function --
------------------

local function CalculateHeadBob()
	
	-- Return Vector
end

----------------------
-- Sprint Functions --
----------------------

-- Stmaine Regen Coiroutine
local function StaminaCoolDown()

	-- Start Can Regen Coroutine..
	local canRegenCoroutine = coroutine.wrap(function()

		-- Cant Regen Now
		staminaCanRegen = false

		-- Wait Regen Cooldown
		task.wait(STAMINA_REGEN_COOLDOWN)

		-- Now Can Regen
		staminaCanRegen = true

	end)()
end

-- Deactivate
local function DeactivateSprint()
	
	-- If dead leave
	if thisHumanoid.Health <= 0 or isSprinting == false then return end
	
	-- Is no longer sprinting
	isSprinting = false

	-- Reset to OG Speed
	thisHumanoid.WalkSpeed = OG_WALKSPEED

	-- Change Back FOV
	FOV = DEFAULT_FOV

	-- turn on Wind Effect..
	--sprintEffectEmitter.SprintWind.Enabled = false
	
	-- Reset Rotation and Position
	rotation_x = 0
	rotation_y = 0
	rotation_z = 0
	
	-- Reset Pos
	xpos = ogXPos
	ypos = ogYPos
	zpos = ogZPos
	
	-- Do Stamina Cooldown
	StaminaCoolDown()

end

-- Activate It
local function ActivateSprint()

	-- Not when reloading..
	if isReloading or isFiring or aiming or not canSprint or thisHumanoid.Health <= 0 or isSprinting or currentStamina <= 0 then

		-- Leave
		return

	end
	
	-- Is Sprinting
	isSprinting = true
	
	-- Rotate weapon or item if we have one..
	if weapon or item then
		
		-- Rotation
		rotation_y = 0.66
		rotation_z = 0
		rotation_x = -0.33
		zpos = ogZPos + 0.5
		ypos = ogYPos - 0.5
		xpos = ogXPos - 1
		
	end

	-- change Movement Speed
	thisHumanoid.WalkSpeed += SPRINT_SPEED_ADD

	-- Change FOv
	FOV = SPRINT_FOV

end

-------------------------
-- ViewModel Functions --
-------------------------

--Arm rotation function
local function ArmToWeapon(arm)

	-- Defines which shoulder we are going to move..
	local shoulder = viewModel[arm.."UpperArm"][arm.."Shoulder"]


	local cf = weapon[arm].CFrame * CFrame.Angles(math.pi/2, 0, 0) * CFrame.new(0, 1.5, 0)


	shoulder.C1 = cf:inverse() * shoulder.Part0.CFrame * shoulder.C0
end

--Arm rotation function
local function ArmToItem(arm)

	-- Defines which shoulder we are going to move..
	local shoulder = viewModel[arm.."UpperArm"][arm.."Shoulder"]


	local cf = item[arm].CFrame * CFrame.Angles(math.pi/2, 0, 0) * CFrame.new(0, 1.5, 0)


	shoulder.C1 = cf:inverse() * shoulder.Part0.CFrame * shoulder.C0
end

-- Set Amrs to Default Rotation..
local function ArmDown(arm)

	-- Defines which shoulder we are going to move..
	local shoulder = viewModel[arm.."UpperArm"][arm.."Shoulder"]

	-- Which Shoulder
	if arm == "Left" then

		-- Set
		shoulder.C1 = defaultLeftShoulderC1 * CFrame.Angles(math.rad(90),0,0)

	elseif arm == "Right" then

		-- Set
		shoulder.C1 = defaultRightShoulderC1 * CFrame.Angles(math.rad(90),0,0)

	end
end
--
--Lerp function
local function Lerp(starting, ending, increment)
	return starting + (ending - starting) * increment
end

--Disable aiming
local function UnAim()

	-- Not Aiming Anymore..
	aiming = false
	
	-- Reset Position
	xpos=ogXPos
	ypos=ogYPos
	zpos=ogZPos
	lerpedypos=lerpedypos-math.abs(ogYPos)

	-- Reset FOV
	FOV = DEFAULT_FOV
	
	-- If we are holding sprint, start sprinting
	if leftShiftDown then
		
		-- Sprint
		ActivateSprint()
	end
end

-- Aim Doiwn Sight Function
local function AimDownSight()
	
	-- Stop Sprinting
	DeactivateSprint()

	-- If we have a weapon and we are not reloading..
	if weapon and isReloading == false then

		-- If we werent already aiming..
		if aiming==false then

			-- Now we are aiming..
			aiming=true

			-- Let gun lerp to the middle of the screen..
			xpos=0
			ypos=0
			zpos=thisCharacter.Gun.Value.Settings.PositionOnScreen.AimZ.Value
			lerpedypos=lerpedypos+math.abs(thisCharacter.Gun.Value.Settings.PositionOnScreen.Y.Value)
			
			-- reset rotation
			rotation_x = 0
			rotation_y = 0
			rotation_z = 0

			-- Set Aiming FOV
			FOV = thisCharacter.Gun.Value.Settings.AimFOV.Value
		end
	end
end

-- Release ADS
local function ReleaseADS()

	-- Release Aim Down Sight
	if weapon then
		if aiming==true then
			UnAim()
		end
	end
end

-- ViewModel Firing Animation
local function ViewModelFire(model)
	
	-- Stop Sprinting
	DeactivateSprint()

	-- Is now Firing..
	isFiring = true

	-- Gun Kick/Rotation
	if model == "AirBlaster" then

		-- If we are not aiming, move weapon when kicking not only rotate..
		if aiming == false then

			-- Move Weapon
			ypos += AIRBLASTER_FIRE_YMOVE
			zpos += AIRBLASTER_FIRE_ZMOVE
		end

		-- Rotate
		rotation_x += AIRBLASTER_FIRE_ROTATION

		-- Wait
		wait(0.05)

		-- If we were not aiming, unkick harder..
		if aiming == false then

			-- MOve Weapoin Back
			ypos -= AIRBLASTER_FIRE_YMOVE
			zpos -= AIRBLASTER_FIRE_ZMOVE
		end

		-- Un-rotate
		rotation_x -= AIRBLASTER_FIRE_ROTATION

	elseif model == "PlasmaGun" then

		-- If we are not aiming, kick harder..
		if aiming == false then

			-- Move Weapon
			ypos += PLASMAGUN_FIRE_YMOVE
			zpos += PLASMAGUN_FIRE_ZMOVE
		end

		-- Rotate
		rotation_x += PLASMAGUN_FIRE_ROTATION

		-- Wait
		wait(0.05)

		-- If we were not aiming, unkick harder..
		if aiming == false then

			-- Move Weapon BAck
			ypos -= PLASMAGUN_FIRE_YMOVE
			zpos -= PLASMAGUN_FIRE_ZMOVE
		end

		-- Un-rotate
		rotation_x -= PLASMAGUN_FIRE_ROTATION

	elseif model == "CrossbowExplosive" then

		-- If we are not aiming, kick harder..
		if aiming == false then

			-- Move Weapon
			ypos += CROSSBOW_FIRE_YMOVE
			zpos += CROSSBOW_FIRE_ZMOVE
		end

		-- Rotate
		rotation_x += CROSSBOW_FIRE_ROTATION

		

		-- Wait
		wait(0.05)

		-- If we were not aiming, unkick harder..
		if aiming == false then

			-- Move Weapon BAck
			ypos -= CROSSBOW_FIRE_YMOVE
			zpos -= CROSSBOW_FIRE_ZMOVE
		end

		-- Un-rotate
		rotation_x -= CROSSBOW_FIRE_ROTATION		

	elseif model == "Nailgun" then

		-- If we are not aiming, kick harder..
		if aiming == false then

			-- Move Weapon
			ypos += NAILGUN_FIRE_YMOVE
			zpos += NAILGUN_FIRE_ZMOVE
		end

		-- Rotate
		rotation_x += NAILGUN_FIRE_ROTATION

		-- Wait
		wait(0.05)

		-- If we were not aiming, unkick harder..
		if aiming == false then

			-- Move Weapon BAck
			ypos -= NAILGUN_FIRE_YMOVE
			zpos -= NAILGUN_FIRE_ZMOVE
		end

		-- Un-rotate
		rotation_x -= NAILGUN_FIRE_ROTATION


	elseif model == "Shotgun" then

		-- If we are not aiming, kick harder..
		if aiming == false then

			-- Move Weapon
			ypos += SHOTGUN_FIRE_YMOVE
			zpos += SHOTGUN_FIRE_ZMOVE
		end

		-- Rotate
		rotation_x += SHOTGUN_FIRE_ROTATION

		-- Wait
		wait(0.05)

		-- If we were not aiming, unkick harder..
		if aiming == false then

			-- Move Weapon BAck
			ypos -= SHOTGUN_FIRE_YMOVE
			zpos -= SHOTGUN_FIRE_ZMOVE
		end

		-- Un-rotate
		rotation_x -= SHOTGUN_FIRE_ROTATION
	end

	-- Is not firing anymore..
	isFiring = false

end

--------------------
-- Tool Functions --
--------------------

-- Debug Function for where a Raycast Hit (Creates Red Block) --
local function RayCastHitPosDebug(position)

	-- RayCastHitDebug --
	local part = Instance.new("Part")
	part.Parent = workspace
	part.Position = position
	part.BrickColor = BrickColor.new("Really red")
	part.Size = Vector3.new(1,1,1)
	part.Anchored = true
	part.CanCollide = false

end

-- Flamethrower Collider Creator
local function FlamethrowerColliderMaker()
	
	-- Timer Vars
	local flameColliderMadeInterval = 0
	local lastFlameColliderMade = time()
	
	-- Loop
	while flamethrowerOn do

		-- every Interval
		if (time() - lastFlameColliderMade) >= flameColliderMadeInterval then

			-- Reset Last Flame Collioder Made
			lastFlameColliderMade = time()
			
			-- Set Interval Time
			flameColliderMadeInterval = 0.5
			
			-- Run Event,,
			game.ReplicatedStorage.CreateFlamethrowerCollider:FireServer(weapon.Light.CFrame.Position, weapon.Light.CFrame.LookVector)				

		end			

		-- Wait
		task.wait()
	end
end

-- AirBlaster Collider Creator
local function AirBlasterFire()

	-- Send One Collider Maker..
	game.ReplicatedStorage.CreateAirBlasterCollider:FireServer(thisCharacter:WaitForChild("Model"), weapon.Light.CFrame.Position, weapon.Light.CFrame.LookVector)
	
	-- Fire to Gun Client ViewModel
	ViewModelFire("AirBlaster")
	
	-- If still have weapon
	if weapon then
		
		-- If same Weapon
		if weapon.ModelName.Value == "AirBlaster" then
			
			-- Enable Emitter --
			weapon.Light.SmokeImpact.Impact.Enabled = true
			weapon.Light.SmokeRing.Impact.Enabled = true

			-- Cleqar, Then Emit 10 particels --
			weapon.Light.SmokeImpact.Impact:Clear()
			weapon.Light.SmokeRing.Impact:Clear()
			weapon.Light.SmokeImpact.Impact:Emit(333)
			weapon.Light.SmokeRing.Impact:Emit(333)

			-- disable Emitter
			weapon.Light.SmokeImpact.Impact.Enabled = false
			weapon.Light.SmokeRing.Impact.Enabled = false			
			
		end
	end	
end

-- fuinction to just chamber certain weapons
local function ChamberAmmo(toolName)
	
	if toolName == "Shotgun" then
		
		-- PLay reload sound..
		reloadSound = script.Parent.GunSounds.ShotgunReload
		reloadSound:Play()

		-- Load and Play Reload Animation..
		reloadAnimTrack = viewModel.AnimationController:LoadAnimation(script.ShotgunReload)

		-- Let it load
		while reloadAnimTrack.Length == 0 do task.wait() end

		-- Play it.
		reloadAnimTrack.Looped = false
		reloadAnimTrack:Play()

		-- LEt animation Finish..
		task.wait(reloadAnimTrack.Length)
	end
	
end

-- Reload Function --
local function Reload(toolName, animNum)
	
	-- Leave if no active tool..
	if not activeTool then return end
	
	-- Get this actual tool..
	local thisActiveTool = activeTool

	-- Is Reloading
	isReloading = true
	
	-- Stop any automatic tool Loop
	mouse1Held = false

	-- Check Active Tool..
	if toolName == "VialGunBasic" then
		
		-- If we arent fuly loadedd.
		if vialGunAmmo < VIALGUN_MAX_AMMO then
			
			-- If we were sprinting, stop..
			DeactivateSprint()
			
			-- If we were aiming, unaim..
			if aiming== true then UnAim() end
			
			-- PLay reload sound..
			reloadSound = script.Parent.GunSounds.VialGunReload
			reloadSound:Play()
			
			-- Move Back..
			zpos = ogZPos - 0.3
			xpos = ogXPos - 0.5
			rotation_x = 0.2
			rotation_y = 0.33

			-- Load and Play Reload Animation..
			reloadAnimTrack = viewModel.AnimationController:LoadAnimation(script.VialGunReload)

			-- Let it Load..
			while reloadAnimTrack.Length == 0 do task.wait() end

			-- Play It
			reloadAnimTrack.Looped = false
			reloadAnimTrack:Play()

			-- Wait
			task.wait(reloadAnimTrack.Length)

			-- See if we still have this gun..
			if activeTool and viewModel then

				-- If its same one..
				if activeTool.Name == toolName then

					-- New VialGun Ammo
					vialGunAmmo = VIALGUN_MAX_AMMO

				end
			end
		end		

	elseif toolName == "CrossbowExplosive" then
		
		-- Leave if loaded..
		if not crossBowLoaded then
			
			-- If we were sprinting, stop..
			DeactivateSprint()
			
			-- If we were aiming, unaim..
			if aiming== true then UnAim() end
			
			-- Play Reload Sound...
			reloadSound = script.Parent.GunSounds.CrossbowReload
			reloadSound:Play()
			
			-- Move Back
			zpos = ogZPos + 1	

			-- Load and Play Reload Animation..
			reloadAnimTrack = viewModel.AnimationController:LoadAnimation(script.CrossbowReload)

			-- Let it load..
			while reloadAnimTrack.Length == 0 do task.wait() end

			-- Playe It
			reloadAnimTrack.Looped = false
			reloadAnimTrack:Play()

			-- Wait Half
			task.wait(reloadAnimTrack.Length)

			-- Run Arrow Effect
			if activeTool and viewModel then

				-- If its the right ViewModel..
				if activeTool.Name == toolName then

					-- Run it
					viewModel.Model.Bolt.Transparency = 0
					viewModel.Model.Bolt.Explosive.Transparency = 0			

					-- Move sLide Back..
					viewModel.Model.Handle.BoltLauncherWeld.C1 *= CFrame.new(0,0, -1.2)
					
					-- Crossbow Loaded
					crossBowLoaded = true
					
				end			
			end		
		end
		
	elseif toolName == "Nailgun" then
		
		-- If not loaded..
		if nailGunAmmo < NAILGUN_MAX_AMMO then
			
			-- If we were sprinting, stop..
			DeactivateSprint()
			
			-- If we were aiming, unaim..
			if aiming== true then UnAim() end
			
			-- PLay reload sound..
			reloadSound = script.Parent.GunSounds.NailgunReload
			reloadSound:Play()
			
			-- Move Back..
			zpos = ogZPos + 0.5
			rotation_x = 0.33

			-- Load and Play Reload Animation..
			reloadAnimTrack = viewModel.AnimationController:LoadAnimation(script.NailgunReload)

			-- Let it Load..
			while reloadAnimTrack.Length == 0 do task.wait() end

			-- Play It
			reloadAnimTrack.Looped = false
			reloadAnimTrack:Play()

			-- Wait
			task.wait(reloadAnimTrack.Length)

			-- See if we still have this gun..
			if activeTool and viewModel then

				-- If its same one..
				if activeTool.Name == "Nailgun" then

					-- New Nailgun Ammo
					nailGunAmmo = NAILGUN_MAX_AMMO

				end
			end
		end		
		
	elseif toolName == "Shotgun" then
			
		-- If not fully loaded..
		if shotgunAmmo < SHOTGUN_MAX_AMMO then
			
			-- If we were sprinting, stop..
			DeactivateSprint()
			
			-- If we were aiming, unaim..
			if aiming== true then UnAim() end

			-- Move Gun.
			xpos = ogXPos - 1.5
			ypos = ogYPos - 0.5
			rotation_z = 0.5

			-- Load and Play Reload Animation..
			reloadAnimTrack = viewModel.AnimationController:LoadAnimation(script.ShotgunReload2OneBullet)

			-- Make sure ANimation Loads..
			while reloadAnimTrack.Length == 0 do task.wait() end

			-- Now PLay it
			reloadAnimTrack.Looped = false

			-- Shotgun Sounds.
			local loadAmmoSound = script.Parent.GunSounds.ShotgunLoadAmmo

			-- Loop..
			for i = 0, SHOTGUN_MAX_AMMO - 1, 1 do

				-- If we lost the tool..
				if activeTool and viewModel then
					if activeTool.Name ~= toolName then
						break
					end
				else
					break
				end	

				-- Play ANimation
				reloadAnimTrack:Play()

				-- Do it
				loadAmmoSound:Play()

				-- Wait till its finished
				task.wait(reloadAnimTrack.Length)

				-- Add Ammo
				shotgunAmmo += 1

				-- Add Ammo
				if shotgunAmmo == SHOTGUN_MAX_AMMO then
					break						
				end					
			end

			-- See if we still have this gun..
			if activeTool and viewModel then

				-- If its same one..
				if activeTool.Name == toolName then
					
					-- Do Gun Reload/Shake Animation..
					local reloadCoroutine = coroutine.wrap(function()

						-- Reload.
						ChamberAmmo("Shotgun")	

					end)()
				end
			end
		end	
		
	elseif toolName == "BBGun" then
		
		-- If not loaded..
		if bbGunAmmo < BBGUN_MAX_AMMO then
			
			-- If we were sprinting, stop..
			DeactivateSprint()
			
			-- If we were aiming, unaim..
			if aiming== true then UnAim() end
			
			-- PLay reload sound..
			reloadSound = script.Parent.GunSounds.BBGunReload
			reloadSound:Play()
			
			-- Set
			rotation_x = 0.33
			rotation_z = -0.33	

			-- Load and Play Reload Animation..
			reloadAnimTrack = viewModel.AnimationController:LoadAnimation(script.BBGunReload)

			-- Wait to load
			while reloadAnimTrack.Length == 0 do task.wait() end

			-- PLay
			reloadAnimTrack.Looped = false
			reloadAnimTrack:Play()

			-- Let ANimation Finish
			task.wait(reloadAnimTrack.Length)

			-- See if we still have this gun..
			if activeTool and viewModel then

				-- If its same one..
				if activeTool.Name == toolName then

					-- New Nailgun Ammo
					bbGunAmmo = BBGUN_MAX_AMMO
					
				end
			end
		end		
		
	elseif toolName == "Flamethrower" then
		
		-- If not loaded..
		if flamethrowerGas < FLAMETHROWER_MAX_AMMO then
			
			-- If we were sprinting, stop..
			DeactivateSprint()
			
			-- Flamethrower is now off.
			flamethrowerOn = false
			
			-- Flamethrower FX Off
			game.ReplicatedStorage.FlamethrowerOff:FireServer()
			
			
			-- Run FX for local Client
			if weapon then

				-- Do it
				weapon.Light.FireEmitter.Enabled = false
				weapon.Light.PilotEmitter.Enabled = true
			end
			
			
			-- If we were aiming, unaim..
			if aiming== true then UnAim() end
			
			-- Play Sound
			reloadSound = script.Parent.GunSounds.FlamethrowerReload
			reloadSound:Play()

			-- Move Back..
			zpos = ogZPos + 1
			rotation_x = 0.66

			-- Load and Play Reload Animation..
			reloadAnimTrack = viewModel.AnimationController:LoadAnimation(script.FlamethrowerReload)

			-- Let it Load..
			while reloadAnimTrack.Length == 0 do task.wait() end

			-- Play It
			reloadAnimTrack.Looped = false
			reloadAnimTrack:Play()

			-- Wait Half
			task.wait(1)
			
			-- See if we still have this gun..
			if activeTool and viewModel then

				-- If its same one..
				if activeTool.Name == toolName then

					-- Do It.
					viewModel.Model.Canister.Transparency = 1		

				end
			end

			-- Wait Length of animation..
			task.wait(1)
			
			-- See if we still have this gun..
			if activeTool and viewModel then

				-- If its same one..
				if activeTool.Name == toolName then

					-- Do It.
					viewModel.Model.Canister.Transparency = 0	

				end
			end

			-- if there is an animation track still.
			if reloadAnimTrack then
				
				-- do it..
				if reloadAnimTrack.Length > 2 then

					-- Do It..,
					task.wait(reloadAnimTrack.Length - 2)
				end
			end			

			-- See if we still have this gun..
			if activeTool and viewModel then

				-- If its same one..
				if activeTool.Name == "Flamethrower" then

					-- Reset Gas..
					flamethrowerGas = FLAMETHROWER_MAX_AMMO

				end
			end
		end
		
	elseif toolName == "PlasmaGun" then
		
		-- If we were sprinting, stop..
		DeactivateSprint()
		
		-- If we were aiming, unaim..
		if aiming== true then UnAim() end
		
		-- Play Sound
		reloadSound = script.Parent.GunSounds.PlasmaOverheat
		reloadSound:Play()
		
		-- Run it
		viewModel.Model.ReloadParticle.Smoke.Enabled = true

		-- Lift Gun Up While its Shaking
		ypos= ogYPos + 0.5
		zpos= ogZPos + 1
		rotation_x = 1

		-- Wait
		task.wait(PLASMAGUN_OVERHEAT_TIME)
		
		-- See if we still have this gun..
		if activeTool and viewModel then

			-- If its same one..
			if activeTool.Name == toolName then
				
				-- Turn it Off..
				viewModel.Model.ReloadParticle.Smoke.Enabled = false

			end
		end
		
	elseif toolName == "Frag" or toolName == "Cheese" then
		
		-- If we were sprinting, stop..
		DeactivateSprint()
		
		-- Move Back..
		rotation_x = 1
		ypos = ogYPos + 2.5
		zpos = ogZPos + 1.5

		-- Wait
		task.wait(0.33)
		
		-- Hide Local Model
		if activeTool and viewModel then

			-- If its same one..
			if activeTool == thisActiveTool then
				
				-- We threw it
				usedThrowable = true
				
				-- Fire Throwable Thrown (Arguments: Tool Name, Local tool Position, Players Camera Look Vector) --
				game.ReplicatedStorage.ThrowableThrown:FireServer(toolName, item.Handle.CFrame.Position , playerCamera.CFrame.LookVector)

				-- Turn it Off..
				viewModel.Model.Handle.Transparency = 1

				-- Move Back..
				rotation_x = 0
				ypos = ogYPos
				zpos = ogZPos

			else
				
				-- Did not throw
				usedThrowable = false
				
			end
		else
			
			-- Did not throw
			usedThrowable = false
			
		end
		
		-- Let Arm go back down
		task.wait(0.5)
		
	elseif toolName == "Coffee" then
		
		-- If we were sprinting, stop..
		DeactivateSprint()
		
		-- Move Back..
		rotation_x = 1
		xpos = ogXPos - 1
		zpos = ogZPos + 1
		ypos = ogYPos + 0.5

		-- Wait
		task.wait(0.5)
		
		-- Hide Local Model
		if activeTool and viewModel then

			-- If its same one..
			if activeTool == thisActiveTool then
				
				-- give Player 50 health --
				game.ReplicatedStorage.AddHealthToPlayer:FireServer(75)
				
				-- We threw it
				usedThrowable = true
				
				-- Wait
				task.wait(0.5)

				-- Move Back..
				rotation_x = 0
				xpos = ogXPos
				zpos = ogZPos 
				ypos = ogYPos

			else

				-- Did not throw
				usedThrowable = false

			end
		else

			-- Did not throw
			usedThrowable = false

		end

		-- Let Arm go back down
		task.wait(0.5)
	end
	
	-- Not Reloading
	isReloading = false
	
	-- If we are still aiming... aim..
	if holdingADSButton then
		
		-- ADS
		AimDownSight()
		
	elseif aiming then
		
		-- Un aim
		UnAim()
		
	elseif leftShiftDown then
		
		-- Start Sprinting
		ActivateSprint()
		
	end
end

-- Fire Gun --
local function Fire()
	
	-- Raycast Origin
	local origin = nil

	-- Empty Direction Var
	local direction = Vector3.new(0,0,0)

	-- Check distance between players camera and head to determine if in first person --
	local camDistance = (thisCharacter.Head.CFrame.Position - playerCamera.CFrame.Position).Magnitude
	
	-- If player is in first person mode..
	if camDistance < 2 then

		-- Viewport Center Points --
		local viewportPoint = playerCamera.ViewportSize / 2

		-- Create Ray from Viewport Center.. --
		local unitRay = playerCamera:ViewportPointToRay(viewportPoint.X, viewportPoint.Y, 0)	

		-- Origina is Ray origin --
		origin = unitRay.Origin

		-- Direction is Ray direction with 5000 length --
		direction = unitRay.Direction * RAYCAST_RANGE	

		-- Nil Stuff
		viewportPoint = nil
		unitRay = nil
		
	else -- In third person mode..
		
		-- If we are on mobile or Ipad..
		if UIS.TouchEnabled then	
			
			-- Viewport Center Points --
			local viewportPoint = playerCamera.ViewportSize / 2

			-- Create Ray from Viewport Center.. --
			local unitRay = playerCamera:ViewportPointToRay(viewportPoint.X, ((viewportPoint.Y * 2) * 0.375), 0)	

			-- Origina is Ray origin --
			origin = unitRay.Origin

			-- Direction is Ray direction with 500 length --
			direction = unitRay.Direction * RAYCAST_RANGE

			-- Nil Stuff
			viewportPoint = nil
			unitRay = nil			
			
		else
			
			-- Third person mode on PC or Xbox..
			game.ReplicatedStorage.ShootGun:FireServer(true, thisPlayerMouse.Hit.Position, direction, activeTool, weapon.Light.Position)
			
			-- Leave function..
			return
			
		end	
	end
	
	-----------------------------------------------------------
	-- Need Origin and Direction Defined BEfore This Point!! --
	-----------------------------------------------------------

	-- Create new Raycast Handle --
	local newRay = RaycastParams.new()

	-- Dont let raycast hit the player shooting it --
	newRay.FilterDescendantsInstances = {thisPlayer.Character, workspace.CurrentCamera}

	-- FilterType
	--newRay.FilterType = Enum.RaycastFilterType.Blacklist

	-- Collision
	newRay.CollisionGroup = "WeaponRaycasts"

	-- Cast the Ray --
	local result = workspace:Raycast(origin, direction, newRay)	

	-- IF we hit anything
	if result then

		-- Tell Server to Fire the ShootGun Event.. 
		game.ReplicatedStorage.ShootGun:FireServer(true, result.Position, direction, activeTool, weapon.Light.Position)

	else -- We Hit nothing

		-- Tell Server to Fire the ShootGun Event.. 
		game.ReplicatedStorage.ShootGun:FireServer(false, Vector3.new(0,0,0), direction, activeTool, weapon.Light.Position)			

	end		

	-- Nil Stuff
	origin = nil
	direction = nil
	camDistance = nil
	newRay = nil
	result = nil
	
end

-- Tool Activate Function --
local function ActivateTool()
	
	-- If there is no active tool, return
	if not activeTool then return end
	
	-- If reloading, leave
	if isReloading then return end
	
	-- Reference This Active Tool..
	local thisActiveTool = activeTool
	
	--------------------------------
	-- Flashlight Tool Activation --
	--------------------------------	
	if activeTool.Name == "Flashlight" then
		
		-- We want our flash light to be on/off so we run it outside the loop --
		if flashlightOn == false then
			
			-- Flashlight On..
			flashlightOn = true
			
			-- If the model exists..
			if weapon then
				
				-- If right one..
				if weapon.ModelName.Value == "Flashlight" then
					
					-- Do it
					weapon.Light.Light.Enabled = true
					weapon.Light.Sound:Play()
					weapon.Front.SurfaceLight.Enabled = true
				end
			end
			
		elseif flashlightOn == true then
			
			-- its on now..
			flashlightOn = false
			
			-- If the model exists..
			if weapon then

				-- If right one..
				if weapon.ModelName.Value == "Flashlight" then

					-- Do it
					weapon.Light.Light.Enabled = false
					weapon.Light.Sound2:Play()
					weapon.Front.SurfaceLight.Enabled = false
				end
			end		
		end	
		
		-- Return
		return
	end	
	
	----------------------------
	-- Cheese Tool Activation --
	----------------------------
	if activeTool.Name == "Cheese" then
		
		-- Activate Throw Animation -- Dont coroutine this because we want it to delay this function..
		Reload("Cheese")

		-- If its the same tool that was thrown..
		if activeTool == thisActiveTool then

			-- Destroy it
			activeTool:Destroy()

			-- Make Active tool nil
			activeTool = nil

		else
			
			-- Did it get thrown?
			if usedThrowable then
				
				-- also destroy it from the server..
				game.ReplicatedStorage.RemoveToolFromPlayerServerSide:FireServer(thisActiveTool)

				-- Make Active tool nil
				thisActiveTool = nil
				
			end
		end
		
		-- Exit Function
		return
		
	end
	
	----------------------------
	-- Frag Tool Activation --
	----------------------------
	if activeTool.Name == "Frag" then
		
		-- Activate Throw Animation
		Reload("Frag")

		-- If its the same tool that was thrown..
		if activeTool == thisActiveTool then

			-- Destroy it
			activeTool:Destroy()

			-- Make Active tool nil
			activeTool = nil

		else

			-- Did it get thrown?
			if usedThrowable then

				-- also destroy it from the server..
				game.ReplicatedStorage.RemoveToolFromPlayerServerSide:FireServer(thisActiveTool)

				-- Make Active tool nil
				thisActiveTool = nil

			end
		end

		-- Exit Function
		return

	end
	
	----------------------------
	-- Coffee Tool Activation --
	----------------------------
	
	if activeTool.Name == "Coffee" then
		
		-- If Health is less than MaxHealth..
		if thisHumanoid.Health < thisHumanoid.MaxHealth then
			
			-- Reload Animation..
			Reload("Coffee")

			-- If its the same tool that was thrown..
			if activeTool == thisActiveTool then

				-- Destroy it
				activeTool:Destroy()

				-- Make Active tool nil
				activeTool = nil

			else

				-- Did it get thrown?
				if usedThrowable then

					-- also destroy it from the server..
					game.ReplicatedStorage.RemoveToolFromPlayerServerSide:FireServer(thisActiveTool)

				end
			end

			-- Exit Function
			return
		else
			
			-- LEave
			return
		end		
	end
	
	---------------------------------
	-- Air Blaster Tool Activation --
	---------------------------------
	
	if activeTool.Name == "AirBlaster" then
		
		-- Make a Collider..
		AirBlasterFire()
		
		-- Wait Cooldown Time..
		task.wait(AIRBLASTER_COOLDOWN_TIME)
	end
	
	-- Now Mouse is Held
	mouse1Held = true
	
	-- While it is held, run loop
	while mouse1Held and toolIsAGun do
		
		-- Make sure player did not die..
		if thisHumanoid.Health <= 0 then
			
			-- Change State
			mouse1Held = false
			
			-- Break Loop
			break
		end
		
		-- Each Guns Fireing Sequence..
		if activeTool.Name == "PlasmaGun" then
			
			-- Add to Heat..
			plasmaGunHeat = plasmaGunHeat + 10
		
			-- Check Heat
			if plasmaGunHeat >= 90 then
				
				-- Reload..
				local reloadCoroutine = coroutine.wrap(function()
					
					-- Reload
					Reload("PlasmaGun")
					
				end)()				
				
			elseif plasmaGunHeat < 90 then				
							
				-- Flash Muzzle Light
				if weapon then

					-- If same Model..
					if weapon.ModelName.Value == "PlasmaGun" then
						
						-- Run Actual Fire event
						Fire()

						-- Do it..
						weapon.Light.SpotLight.Enabled = true

					end				
				end				
				
				-- Fire Event for Viewmodel
				ViewModelFire("PlasmaGun")
				
				-- Turn Muzzle Flash Off
				if weapon then
					
					-- If same Model..
					if weapon.ModelName.Value == "PlasmaGun" then

						-- Turn OFf Light
						weapon.Light.SpotLight.Enabled = false

					end					
				end				
			end				

			-- Gun Cooldown.
			task.wait(PLASMAGUN_COOLDOWN_TIME) -- Subtrcat Light On/Off Delay

			-- Non Automatic Gun..
			mouse1Held = false
			
		elseif activeTool.Name == "CrossbowExplosive" then
			
			-- Reload Crossbow if not reloaded..
			if crossBowLoaded then
				
				-- If weapon
				if weapon then
					
					-- If its the crossbow
					if weapon.ModelName.Value == "CrossbowExplosive" then
						
						-- Fire when loaded..
						Fire()

						-- Move Bolt Launcher Back
						viewModel.Model.Handle.BoltLauncherWeld.C1 *= CFrame.new(0,0,1.2)

						-- Hide Bolt..
						viewModel.Model.Bolt.Transparency = 1
						viewModel.Model.Bolt.Explosive.Transparency = 1						
						
					end
				end					

				-- GunClient Stuff
				ViewModelFire("CrossbowExplosive")

				-- Now is unloaded..
				crossBowLoaded = false					
				
			else
				
				-- Trigger CLick
				script.Parent.GunSounds.TriggerClick:Play()
				
			end	
			
			-- Wait
			task.wait(CROSSBOW_COOLDOWN_TIME)
			
			-- Non Auto Weapon
			mouse1Held = false
			
		elseif activeTool.Name == "Nailgun" then
			
			-- If we have ammo..
			if nailGunAmmo > 0 then
				
				-- If weapon
				if weapon then
					
					-- If nailgun
					if weapon.ModelName.Value == "Nailgun" then
						
						-- Run Actual Fire event
						Fire()
					end
				end				
				
				-- Fire Event for Viewmodel
				ViewModelFire("Nailgun")				
				
				-- ONe Less AMmo
				nailGunAmmo -= 1
				
			else
				
				-- Trigger CLick
				script.Parent.GunSounds.TriggerClick:Play()		
				
			end
			
			-- If it is upgraded..
			if thisPlayer.weaponlevels.nailgunspecialupgrade.Value == true then

				-- Make it shoot faster..
				task.wait(NAILGUN_AUTO_COOLDOWN_TIME)
			else
				-- Normal Cooldown Time..
				task.wait(NAILGUN_COOLDOWN_TIME)
				
				-- Non Auto
				mouse1Held = false
			end
			
		elseif activeTool.Name == "Shotgun" then
			
			-- If we have ammo..
			if shotgunAmmo > 0 then
				
				-- If weapon
				if weapon then

					-- If nailgun
					if weapon.ModelName.Value == "Shotgun" then

						-- Run Actual Fire event
						Fire()
						
						-- Do it..
						weapon.Light.SpotLight.Enabled = true
					end
				end
				
				-- Fire Event for Viewmodel
				ViewModelFire("Shotgun")
				
				-- If View Model Exists --
				if weapon then

					-- If same Model..
					if weapon.ModelName.Value == "Shotgun" then

						-- Do it..
						weapon.Light.SpotLight.Enabled = false

					end
				end								

				-- ONe Less AMmo
				shotgunAmmo -= 1
				
				-- Wait
				task.wait(SHOTGUN_FIRE_RELOAD_DELAY)
				
				-- If we have no more ammo, dont chamber one..
				if shotgunAmmo > 0 then
					
					-- Do Gun Reload/Shake Animation..
					local reloadCoroutine = coroutine.wrap(function()

						-- Reload
						ChamberAmmo("Shotgun")

					end)()
				end			
			else
				
				-- Gun Triger Sound..
				script.Parent.GunSounds.TriggerClick:Play()
				
			end
			
			-- Shotgun Cooldown
			task.wait(SHOTGUN_COOLDOWN_TIME)
			
			-- Non Automatic Gun
			mouse1Held = false
			
		elseif activeTool.Name == "BBGun" then
			
			-- If we have ammo..
			if bbGunAmmo > 0 then
				
				-- If weapon
				if weapon then

					-- If nailgun
					if weapon.ModelName.Value == "BBGun" then

						-- Run Actual Fire event
						Fire()

					end
				end

				-- Fire Event for Viewmodel
				ViewModelFire("BBGun")		

				-- ONe Less AMmo
				bbGunAmmo -= 1			

			else
				
				-- Trigger Clkick
				script.Parent.GunSounds.TriggerClick:Play()
				
			end
						
			-- If it is upgraded..
			if thisPlayer.weaponlevels.bbgunspecialupgrade.Value == true then

				-- Make it shoot faster..
				task.wait(BBGUN_AUTO_COOLDOWN_TIME)
			else
				-- Normal Cooldown Time..
				task.wait(BBGUN_COOLDOWN_TIME)
				
				-- Non Auto
				mouse1Held = false
			end
			
		elseif activeTool.Name == "VialGunPoison" or activeTool.Name == "VialGunBasic" then
			
			-- If we have ammo..
			if vialGunAmmo > 0 then
				
				-- If weapon
				if weapon then

					-- If nailgun
					if weapon.ModelName.Value == "VialGunBasic" then

						-- Run Actual Fire event
						Fire()

					end
				end

				-- Fire Event for Viewmodel
				ViewModelFire("VialGunBasic")				

				-- ONe Less AMmo
				vialGunAmmo -= 10

			else
				
				-- Gun Triger Sound..
				script.Parent.GunSounds.TriggerClick:Play()
				
			end			
			
			-- Cooldown
			task.wait(VIALGUN_COOLDOWN_TIME)
			
			-- Non Auto
			mouse1Held = false
			
		else
			
			-- Wait
			task.wait()
		end	
	end
end

-- Function fire when Tool is activated --
local function FireButtonPressed(actionName, inputState, inputObj)
	
	-- If Player is dead, Dont let them use tools..
	if thisHumanoid.Health <= 0 then return end
	
	-- If TOol is nil, leave function..
	if not activeTool then return end
	
	-- Leave if reloading..
	if isReloading then return end

	-- Make sure we only fire function once on Input Begin.. --
	if inputState == Enum.UserInputState.Begin then
		
		-- If Activate Tool is not running, then Run it.. --
		if not activateToolFunctionRunning then
			
			-- Now it is running --
			activateToolFunctionRunning = true
			
			-- Flamethrower Logic
			if activeTool.Name == "Flamethrower" then
				
				-- If we have enough gas, turn on..
				if flamethrowerGas > 0 then
					
					-- Flamethrower On
					flamethrowerOn = true

					-- Flamethrower FX On
					game.ReplicatedStorage.FlamethrowerOn:FireServer(thisCharacter:WaitForChild("Model"))

					-- Run Coroutine Function
					local flamethrowerCoroutine = coroutine.create(FlamethrowerColliderMaker)

					-- Start it
					coroutine.resume(flamethrowerCoroutine)

					-- Nil
					flamethrowerCoroutine = nil
									
					-- Run FX for local Client
					if weapon then
						
						-- Turn stuff on and off..
						weapon.Light.FireEmitter.Enabled = true
						weapon.Light.PilotEmitter.Enabled = false
					end
					
				else
					
					-- Trigger Clkick
					script.Parent.GunSounds.TriggerClick:Play()		
					
				end				
			else
				
				-- run function
				ActivateTool()		
			end			
			
			-- NOw it is not running --
			activateToolFunctionRunning = false
		end
		
	elseif inputState == Enum.UserInputState.End or inputState == Enum.UserInputState.Cancel then -- Button Released
		
		-- Flamethrower Logic
		if activeTool.Name == "Flamethrower" and flamethrowerOn == true then
			
			-- Its Off
			flamethrowerOn = false
			
			-- Flamethrower FX Off
			game.ReplicatedStorage.FlamethrowerOff:FireServer()
			
			
			-- Run FX for local Client
			if weapon then
				
				-- Do it
				weapon.Light.FireEmitter.Enabled = false
				weapon.Light.PilotEmitter.Enabled = true
			end	
			
		else
			
			-- Mouse was released --
			mouse1Held = false
			
		end		
	end
end 

-- Reload Button Pressed..
local function ReloadButtonPressed(actionName, inputState, inputObj)

	-- If Player is dead, Dont let them use tools..
	if thisHumanoid.Health <= 0 then return end

	-- If TOol is nil, leave function..
	if not activeTool then return end

	-- Leave if reloading..
	if isReloading then return end

	-- Make sure we only fire function once on Input Begin.. --
	if inputState == Enum.UserInputState.Begin then

		-- If Activate Tool is not running, then Run it.. --
		if not reloadFunctionRunning then

			-- Now it is running --
			reloadFunctionRunning = true

			-- Reload
			if activeTool.Name ~= "PlasmaGun" and activeTool.Name ~= "Frag" and activeTool.Name ~= "Cheese" and activeTool.Name ~= "Coffee" and activeTool.Name ~= "Flashlight" then

				-- Do it
				Reload(activeTool.Name)
			end			

			-- NOw it is not running --
			reloadFunctionRunning = false
		end		
	end
end

-- Reload Button Pressed..
local function ADSButtonPressed(actionName, inputState, inputObj)

	-- If dead..
	if thisHumanoid.Health <= 0 then return end

	-- Make sure we only fire function once on Input Begin.. --
	if inputState == Enum.UserInputState.Begin then

		-- Mouse Button 2 is Down
		holdingADSButton = true

		-- States to LEave Functions..
		if not activeTool or isReloading or not weapon then return end

		-- If Activate Tool is not running, then Run it.. --
		if not adsFunctionRunning then

			-- Now it is running --
			adsFunctionRunning = true

			-- If we were aiming, unaim..
			if aiming then

				-- UnAim
				UnAim()

			else

				-- ADS
				AimDownSight()

			end				

			-- NOw it is not running --
			adsFunctionRunning = false
		end

	elseif inputState == Enum.UserInputState.End or inputState == Enum.UserInputState.Cancel or inputState == Enum.UserInputState.Change then -- Button Released

		-- Not Down anymoire
		holdingADSButton = false

		-- States to LEave Functions..
		if not activeTool or isReloading or not weapon or isTouchScreen then return end

		-- Relase ADS if aiming
		if aiming then

			-- Release
			UnAim()

		end
	end
end

-- Sprint Button Pressed..
local function SprintButtonPressed(actionName, inputState, inputObj)

	-- If dead..
	if thisHumanoid.Health <= 0 then return end

	-- Make sure we only fire function once on Input Begin.. --
	if inputState == Enum.UserInputState.Begin then

		-- Mouse Button 2 is Down
		leftShiftDown = true

		-- If Activate Tool is not running, then Run it.. --
		if not sprintFunctionRunning then

			-- Now it is running --
			sprintFunctionRunning = true

			-- If we were sprinting..
			if isSprinting then

				-- Deactivate it
				DeactivateSprint()

			else

				-- Xbox Sprint
				ActivateSprint()

			end

			-- NOw it is not running --
			sprintFunctionRunning = false
		end

	elseif inputState == Enum.UserInputState.End or inputState == Enum.UserInputState.Cancel or inputState == Enum.UserInputState.Change then -- Button Released

		-- Not Down anymoire
		leftShiftDown = false

		-- If this is a touchscreen.. OIn/OFf Switch
		if isTouchScreen or isGamePad then return end

		-- Deactivate Sprint
		DeactivateSprint()

	end
end

------------------
-- Aiming Input --
------------------

--Mouse movement capture
UIS.InputChanged:Connect(function(input)

	-- Which Input are we using..
	if input.UserInputType == Enum.UserInputType.MouseMovement then

		-- Set Delta Movements
		x_mouse_movement = x_mouse_movement - input.Delta.x * 0.2
		y_mouse_movement = math.clamp(y_mouse_movement - input.Delta.y * 0.2, -80, 80)

	else
		-- Check for Joystick Movement
		if input.KeyCode == Enum.KeyCode.Thumbstick2 then

			-- Set Last Joy Position..
			lastJoyXPos = input.Position.X
			lastJoyYPos = input.Position.Y
			
		end				
	end
end)

-- Xbox Input.
UIS.InputBegan:Connect(function(input)

	-- if xbox
	if input.KeyCode == Enum.KeyCode.ButtonL3 then

		-- is gamepad
		isGamePad = true

	end
end)

-----------------
-- Connections --
-----------------

-- Check When a tool is added ot the player --
thisCharacter.ChildAdded:Connect(function(child)

	-- If the Child Added was a Tool, reference it.. --
	if child:IsA("Tool") then
		
		-- Ref it --
		activeTool = child
		
		-- Reset isRealoding..
		isReloading = false
		
		-- tool Name --
		local toolName = activeTool.Name
		
		-- check if the Tool is a weapon --
		if toolName == "PlasmaGun" or toolName == "VialGunPoison" or toolName == "VialGunBasic" or toolName == "Nailgun" or toolName == "CrossbowExplosive" or toolName == "BBGun" or toolName == "Shotgun" then
			
			-- Tool is a gun --
			toolIsAGun = true
			
		else
			
			-- tool is not a gun --
			toolIsAGun = false
		end
		
	elseif child.Name == "Gun" then
		
		-- Were we sprinting
		local wasSprinting = nil

		-- If we were sprinting..
		if isSprinting then

			-- Was
			wasSprinting = true

			-- Deactivate then reactive
			DeactivateSprint()

		else

			-- Wasnt
			wasSprinting = false
		end

		-- Stop Last Rerload Track
		if reloadAnimTrack then

			-- If its playing..
			if reloadAnimTrack.IsPlaying then

				-- Do IT
				reloadAnimTrack:Stop()
			end			
		end		

		-- Get Weapon Value
		local weaponString = child.Value.Settings.Model.Value

		-- Set Weapon Reference..
		weapon = game:GetService("ReplicatedStorage").GunSystem.Guns[weaponString].Model:Clone()

		-- Parent to the viewModel..
		weapon.Parent = viewModel

		-- Parent ViewModel
		viewModel.Parent = playerCamera	

		-- Set Lerp Settings
		lerpedxpos=child.Value.Settings.PositionOnScreen.X.Value
		lerpedypos=child.Value.Settings.PositionOnScreen.Y.Value
		lerpedzpos=child.Value.Settings.PositionOnScreen.Z.Value
		xpos=child.Value.Settings.PositionOnScreen.X.Value
		ypos=child.Value.Settings.PositionOnScreen.Y.Value
		zpos=child.Value.Settings.PositionOnScreen.Z.Value
		ogXPos = xpos
		ogYPos = ypos
		ogZPos = zpos
		rotation_x = 0
		rotation_y = 0
		rotation_z = 0
		
		-- If its the flashlight.,.
		if weaponString == "Flashlight" then

			-- If it was on..
			if flashlightOn then

				-- Turn it ON.
				if weapon then

					-- If same Model..
					if weapon.ModelName.Value == weaponString then

						-- Do it..
						weapon.Light.Light.Enabled = true
						weapon.Front.SurfaceLight.Enabled = true

					end				
				end			
			end

		elseif weaponString == "CrossbowExplosive" then

			-- Check if loaded or unloaded..
			if crossBowLoaded then

				-- Show Bolt..
				viewModel.Model.Bolt.Transparency = 0
				viewModel.Model.Bolt.Explosive.Transparency = 0
			else

				-- Show Bolt..
				viewModel.Model.Bolt.Transparency = 1
				viewModel.Model.Bolt.Explosive.Transparency = 1
			end
		end
		
		-- Sprint again if asking too
		if wasSprinting then

			-- Activate it
			ActivateSprint()
		end

		-- Nil
		wasSprinting = nil

	elseif child.Name == "Item" then
		
		-- Were we sprinting
		local wasSprinting = nil
		
		-- If we were sprinting..
		if isSprinting then
			
			-- Was
			wasSprinting = true

			-- Deactivate then reactive
			DeactivateSprint()
			
		else
			
			-- Wasnt
			wasSprinting = false
		end

		-- Stop Last Rerload Track
		if reloadAnimTrack then

			-- If its playing..
			if reloadAnimTrack.IsPlaying then

				-- Do IT
				reloadAnimTrack:Stop()
			end			
		end
		
		-- Get Item Name
		local itemString = child.Value.Settings.Model.Value

		-- Set Weapon Reference..
		item = game:GetService("ReplicatedStorage").GunSystem.Items[child.Value.Settings.Model.Value].Model:Clone()

		-- Parent to the viewModel..
		item.Parent = viewModel

		-- Parent ViewModel
		viewModel.Parent = playerCamera

		-- Set Head of Viewmodel to Camera Cframe
		viewModel.Head.CFrame = playerCamera.CFrame

		-- Reset FOV
		FOV = DEFAULT_FOV

		-- Set Lerp Settings
		lerpedxpos=child.Value.Settings.PositionOnScreen.X.Value
		lerpedypos=child.Value.Settings.PositionOnScreen.Y.Value
		lerpedzpos=child.Value.Settings.PositionOnScreen.Z.Value
		xpos=child.Value.Settings.PositionOnScreen.X.Value
		ypos=child.Value.Settings.PositionOnScreen.Y.Value
		zpos=child.Value.Settings.PositionOnScreen.Z.Value
		ogXPos = xpos
		ogYPos = ypos
		ogZPos = zpos
		rotation_x = 0
		rotation_y = 0
		rotation_z = 0
		
		
		
		-- Sprint again if asking too
		if wasSprinting then
			
			-- Activate it
			ActivateSprint()
		end
		
		-- Nil
		wasSprinting = nil

	elseif child.Name == "Model" then

		-------------------------------------------------------------
		-- When Server Gun Model Shows Up, Hide It to the Client.. --
		-------------------------------------------------------------

		-- GunParts
		local gunParts = nil

		-- Wait for client to catch up..
		repeat

			-- Get Children
			gunParts = child:GetDescendants()

			-- Wait			
			task.wait()

		until #gunParts > 0

		-- looop
		for _, part in pairs(gunParts) do

			-- If its a basepart..
			if part:IsA("BasePart") then

				-- Make invisible
				part.Transparency = 1

			elseif part:IsA("Beam") then

				-- Delete
				part:Destroy()

			elseif part:IsA("RopeConstraint") then

				-- Hide It
				part.Visible = false

			elseif part:IsA("ParticleEmitter") then
				
				-- Turn Transparent..
				part.Transparency = NumberSequence.new(1)
			end
		end	
	end
end)

-- Connection for Tools Removed..
thisCharacter.ChildRemoved:Connect(function(child)
	
	-- If its a tool..
	if child:IsA("Tool") then
		
		-- No Tool in players hand..
		activeTool = nil
		
		-- If its the flamethrower, make sure its off..
		if child.Name == "Flamethrower" then
			
			-- If it was on..
			if flamethrowerOn then
				
				-- Flamethrower Off
				flamethrowerOn = false
				
				-- Turn off
				game.ReplicatedStorage.FlamethrowerOff:FireServer()
			end
		end

	elseif child.Name == "Gun" then
		
		-- Cancel Animation if running
		if reloadAnimTrack then
			
			-- If playing
			if reloadAnimTrack.IsPlaying then
				
				--- Stop
				reloadAnimTrack:Stop()
				
				-- Nil iot
				reloadAnimTrack = nil
			end
		end
		
		-- Stop any reload Sound thats playing..
		if reloadSound then

			-- Stop
			if reloadSound.IsPlaying then reloadSound:Stop() end

			-- Nil it
			reloadSound = nil
		end

		-- Remove Weapon
		if weapon then

			-- Unaim
			UnAim()

			-- Do it
			weapon:Remove()
			weapon = nil

		end	

	elseif child.Name == "Item" then

		-- If an item is still active
		if item then

			-- Remove asnd nil it
			item:Remove()
			item = nil
		end	
	end
end)

--Death
thisCharacter.Humanoid.Died:Connect(function()
	
	-- If flamethrower is still on..
	if flamethrowerOn then

		-- Now it is off
		flamethrowerOn = false

		-- Flamethrower FX Off
		game.ReplicatedStorage.FlamethrowerOff:FireServer()
	end

	-- Remove ViewModel
	viewModel:Destroy()
	
	-- Nil Weapon
	weapon = nil
	item = nil
end)

----------------
-- Init Stuff --
----------------

-- Setup Local Screen Variables --
local screenSizeX = game.Workspace.CurrentCamera.ViewportSize.X
local screenSizeY = game.Workspace.CurrentCamera.ViewportSize.Y
local aspectRatio = screenSizeX/screenSizeY

-- Test Sizes
local fireButtonPosX = screenSizeX * 0.02 -- right side of screen
local fireButtonPosY = screenSizeY * -0.02
local fireButtonSizeX = 0.1 * screenSizeX
local fireButtonSizeY = (0.1 * aspectRatio) * screenSizeY
local reloadButtonPosX = (screenSizeX * 0.1) + fireButtonPosX
local reloadButtonPosY = fireButtonPosY
local reloadButtonSizeX = 0.066 * screenSizeX
local reloadButtonSizeY = (0.066 * aspectRatio) * screenSizeY
local adsButtonPosX = fireButtonPosX
local adsButtonPosY = screenSizeX * 0.1 + fireButtonPosY
local adsButtonSizeX = 0.066 * screenSizeX
local adsButtonSizeY = (0.066 * aspectRatio) * screenSizeY
local sprintButtonPosX = reloadButtonPosX + reloadButtonSizeX
local sprintButtonPosY = fireButtonPosY
local sprintButtonSizeX = 0.066 * screenSizeX
local sprintButtonSizeY = (0.066 * aspectRatio) * screenSizeY

--------------------------
-- Setup Button Actions --
--------------------------	

-- Now Draw Fire Button --
local fireButton = contextActionService:BindAction("FireButton", FireButtonPressed, true, Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2)
contextActionService:SetImage("FireButton", "rbxassetid://12896278690")

-- Draw Reload Button
local reloadButton = contextActionService:BindAction("ReloadButton", ReloadButtonPressed, true, Enum.KeyCode.R, Enum.KeyCode.ButtonX)
contextActionService:SetImage("ReloadButton", "http://www.roblox.com/asset/?id=12789388764")

-- Draw Reload Button
local adsButton = contextActionService:BindAction("ADSButton", ADSButtonPressed, true, Enum.KeyCode.ButtonL2, Enum.UserInputType.MouseButton2)
contextActionService:SetImage("ADSButton", "http://www.roblox.com/asset/?id=5160482784")

-- Draw Reload Button
local sprintButton = contextActionService:BindAction("SprintButton", SprintButtonPressed, true, Enum.KeyCode.ButtonL3, Enum.KeyCode.LeftShift)
contextActionService:SetImage("SprintButton", "rbxassetid://13045651210")

-- Now Adjust button if we are on a Touchscreen --
if UIS.TouchEnabled then
	
	-- This is touchscreen
	isTouchScreen = true

	-- Resize Fire Button --
	local fireButtonGUI = contextActionService:GetButton("FireButton")
	fireButtonGUI.Size = UDim2.new(0,fireButtonSizeX,0,fireButtonSizeY)
	fireButtonGUI.Position = UDim2.new(0,fireButtonPosX,0,fireButtonPosY)
	fireButtonGUI = nil
	
	-- Resize Reload Button --
	local reloadButtonGUI = contextActionService:GetButton("ReloadButton")
	reloadButtonGUI.Size = UDim2.new(0,reloadButtonSizeX,0,reloadButtonSizeY)
	reloadButtonGUI.Position = UDim2.new(0,reloadButtonPosX,0,reloadButtonPosY)
	reloadButtonGUI = nil
	
	-- Resize ADS Button --
	local adsButtonGUI = contextActionService:GetButton("ADSButton")
	adsButtonGUI.Size = UDim2.new(0,adsButtonSizeX,0,adsButtonSizeY)
	adsButtonGUI.Position = UDim2.new(0,adsButtonPosX,0,adsButtonPosY)
	adsButtonGUI = nil
	
	-- Resize Sprint Button --
	local sprintButtonGUI = contextActionService:GetButton("SprintButton")
	sprintButtonGUI.Size = UDim2.new(0,sprintButtonSizeX,0,sprintButtonSizeY)
	sprintButtonGUI.Position = UDim2.new(0,sprintButtonPosX,0,sprintButtonPosY)
	sprintButtonGUI = nil

end

-- Nil
--fireButton = nil
--reloadButton = nil
--adsButton = nil

---------------------------
-- ViewModel Render Loop --
---------------------------

-- Render Loop
game:GetService("RunService").RenderStepped:Connect(function()

	-- If we are alive..
	if thisHumanoid.Health > 0 then

		-- Always Keep ViewModel on Camera..
		viewModel.Head.CFrame = playerCamera.CFrame
		
		-- Always Lerp to New FOV
		playerCamera.FieldOfView = Lerp(playerCamera.FieldOfView, FOV, lerp_increment)
		
		-------------------------
		-- ViewModel Animation --
		-------------------------
		
		-- If its a weapon..
		if weapon then		
	
			-- If we are not reloading or aiming.. keep rotation and position at the og ones..
			if not isReloading and not isFiring and not aiming and not isSprinting then

				-- Rot
				rotation_x = 0
				rotation_y = 0
				rotation_z = 0

				-- Pos
				xpos = ogXPos
				ypos = ogYPos
				zpos = ogZPos

			end

			-- Define Lerp Vars
			lerped_sway_x=Lerp(lerped_sway_x, sway_x, lerp_increment)
			lerped_sway_y=Lerp(lerped_sway_y, sway_y, lerp_increment)
			lerped_rotation_x=Lerp(lerped_rotation_x,rotation_x,lerp_increment)	
			lerped_rotation_y = Lerp(lerped_rotation_y, rotation_y, lerp_increment)
			lerped_rotation_z = Lerp(lerped_rotation_z, rotation_z, lerp_increment)
			lerpedxpos=Lerp(lerpedxpos, xpos, aim_lerp_increment_x)
			lerpedypos=Lerp(lerpedypos, ypos, aim_lerp_increment_y)
			lerpedzpos=Lerp(lerpedzpos, zpos, aim_lerp_increment_z)

			-- Keep Shaking at 0 unless weapon is shaking..		
			shaking_extra_x=0
			shaking_extra_y=0
			shaking_extra_z=0

			-- If we are shaking then..
			if shaking == true then

				-- Set Shake AMount..
				shaking_extra_x = math.random(-5,5)/100
				shaking_extra_y = math.random(-5,5)/100
				shaking_extra_z = math.random(-5,5)/100
			end

			-- If Not aiming..
			if aiming == false then

				-- Position Weapon By Handle
				weapon.Handle.Anchored = true
				weapon.AimPart.Anchored = false
				weapon.Handle.CFrame = playerCamera.CFrame * CFrame.new(lerpedxpos + lerped_sway_x / sway_weaken + shaking_extra_x, lerpedypos - lerped_sway_y / sway_weaken - shaking_extra_y, lerpedzpos + shaking_extra_z)
				weapon.Handle.CFrame *= CFrame.Angles(lerped_rotation_x,lerped_rotation_y,lerped_rotation_z)
			else

				-- Position Weapon by Aimpart..
				weapon.Handle.Anchored = false
				weapon.AimPart.Anchored = true
				weapon.AimPart.CFrame = playerCamera.CFrame * CFrame.new(lerpedxpos+ lerped_sway_x / (sway_weaken*2),lerpedypos-lerped_sway_y / (sway_weaken*2),lerpedzpos)
				weapon.Handle.CFrame *= CFrame.Angles(lerped_rotation_x,lerped_rotation_y,lerped_rotation_z)
			end

			--Arm rotation
			ArmToWeapon("Left")
			ArmToWeapon("Right")					

		elseif item then
			
			-- If we are not reloading or aiming.. keep rotation and position at the og ones..
			if not isSprinting and not isReloading then

				-- Rot
				rotation_x = 0
				rotation_y = 0
				rotation_z = 0

				-- Pos
				xpos = ogXPos
				ypos = ogYPos
				zpos = ogZPos

			end

			-- Define Lerp Vars
			lerped_sway_x=Lerp(lerped_sway_x, sway_x, lerp_increment)
			lerped_sway_y=Lerp(lerped_sway_y, sway_y, lerp_increment)
			lerped_rotation_x=Lerp(lerped_rotation_x,rotation_x,lerp_increment)
			lerped_rotation_y = Lerp(lerped_rotation_y, rotation_y, lerp_increment)
			lerped_rotation_z = Lerp(lerped_rotation_z, rotation_z, lerp_increment)
			lerpedxpos=Lerp(lerpedxpos, xpos, aim_lerp_increment_x)
			lerpedypos=Lerp(lerpedypos, ypos, aim_lerp_increment_y)
			lerpedzpos=Lerp(lerpedzpos, zpos, aim_lerp_increment_z)

			-- Line Item Up
			item.Handle.Anchored = true
			item.Handle.CFrame = playerCamera.CFrame * CFrame.new(lerpedxpos + lerped_sway_x / sway_weaken + shaking_extra_x, lerpedypos - lerped_sway_y / sway_weaken - shaking_extra_y, lerpedzpos + shaking_extra_z)
			item.Handle.CFrame *= CFrame.Angles(lerped_rotation_x,lerped_rotation_y,lerped_rotation_z)

			--Arm rotation
			ArmToItem("Right")
			ArmDown("Left")

		else

			-- Arms Down
			ArmDown("Left")
			ArmDown("Right")

		end
	end
end)

----------------
-- While Loop --
----------------

-- Constantly Running Loop.
while task.wait() do
	
	-- Get Humanoid Move Direction
	humanoidMoveDirection = thisHumanoid.MoveDirection
	
	-- Always be Lowering Heat Value..
	if plasmaGunHeat > 0 then plasmaGunHeat -= 0.2 end
	
	---------------------
	-- Stamina Control --
	---------------------
	
	-- Lower Stamina..
	if isSprinting then
		
		-- If we have stamina..
		if currentStamina > 0 then

			-- Lower IT..
			currentStamina -= STAMINA_USE_RATE		

		elseif currentStamina <= 0 then

			-- Stop Sprinting
			DeactivateSprint()

			-- Set to Zero
			currentStamina = 0

		end		
	else
		
		-- Regen Staming
		if currentStamina < MAX_STAMINA then

			-- Raise Stamina if not cooling down
			if staminaCanRegen then

				currentStamina += STAMINA_REGEN_RATE			

			end		

			-- Cap it at MaxStamine
			if currentStamina > MAX_STAMINA then currentStamina = MAX_STAMINA end		

		end		
	end
	
	-- Always be updating Stamina GUI
	currentStaminaFrame.Size = UDim2.new(currentStamina/MAX_STAMINA, 0, 1, 0)	
	
	------------------------
	-- Control Weapon GUI --
	------------------------
	
	-- If we have an active tool..
	if activeTool then
		
		-- Plasma Gun Heat
		if activeTool.Name == "BBGun" then
			
			-- Update GUI
			bbGunAmmoFrame.CurrentAmmo.Text = bbGunAmmo
			bbGunAmmoFrame.MaxAmmo.Text = BBGUN_MAX_AMMO
			
		elseif activeTool.Name == "VialGunBasic" then
			
			-- Keep GUI Updated..
			vialGunAmmoBar.Size = UDim2.new(vialGunAmmo/VIALGUN_MAX_AMMO, 0 , 1, 0)					
			
		elseif activeTool.Name == "PlasmaGun" then				
			
			-- Keep GUI Updated..
			plasmaGunHeatBarFrame.Size = UDim2.new(plasmaGunHeat/100, 0 , 1, 0)
			
		elseif activeTool.Name == "Flamethrower" then
			
			-- If flamethrower is on, lower Gas
			if flamethrowerOn then
				
				-- Check Gas.
				if flamethrowerGas > 0 then
					
					-- Lower Gas
					flamethrowerGas -= 1
					
				else
					
					-- Turn Flamethrower Off
					flamethrowerOn = false
					
					-- Flamethrower FX Off
					game.ReplicatedStorage.FlamethrowerOff:FireServer()

					-- Run FX for local Client
					if weapon then
						
						-- run it
						weapon.Light.FireEmitter.Enabled = false
						weapon.Light.PilotEmitter.Enabled = false							
					end				
					
					-- Make Trigger CLick Noise
					script.Parent.GunSounds.TriggerClick:Play()
					
				end				
			end
			
			-- Keep GUI Updated..
			flamethrowerGasBarFrame.Size = UDim2.new(flamethrowerGas/FLAMETHROWER_MAX_AMMO, 0 , 1, 0)
			
		elseif activeTool.Name == "Nailgun" then
			
			-- Update Ammo..
			nailGunAmmoFrame.CurrentAmmo.Text = nailGunAmmo
			nailGunAmmoFrame.MaxAmmo.Text = NAILGUN_MAX_AMMO
			
		elseif activeTool.Name == "Shotgun" then
			
			-- Update GUI
			shotgunAmmoFrame.CurrentAmmo.Text = shotgunAmmo
			shotgunAmmoFrame.MaxAmmo.Text = SHOTGUN_MAX_AMMO
			
		end
	end
	
	------------------------------
	-- Camera Bob and Footsteps --
	------------------------------
	
	-- Character Velocity..
	local characterVelocity = thisCharacter.PrimaryPart.Velocity.Magnitude
	
	-- Keep addindg to head bob Tracker (Clamp it from 0-1)
	headBobTracker += characterVelocity / (OG_WALKSPEED + SPRINT_SPEED_ADD)
	
	-- Calculate Bob
	bobX = math.cos(headBobTracker/6) * bobXDistance
	bobY = math.abs(math.cos(headBobTracker/6)) * bobYDistance

	-- If Sprinting.. Multiply Bob
	if isSprinting then

		-- Bobble
		bobX *= 2
		bobY *= 2
		
		-- Change Footstep Speed
		runningSound.PlaybackSpeed = 1.6

	else		
		
		-- Reset Running Speed
		runningSound.PlaybackSpeed = (1.6 / (OG_WALKSPEED + SPRINT_SPEED_ADD)) * characterVelocity

	end		

	-- Set it to humanoid
	thisHumanoid.CameraOffset = Vector3.new(Lerp(thisHumanoid.CameraOffset.X, bobX, lerp_increment), Lerp(thisHumanoid.CameraOffset.Y, bobY, lerp_increment), 0)
	
	-- Nil Stuff
	characterVelocity = nil
	
	----------------------------
	-- Check if we can sprint --
	----------------------------

	-- Calculate Moving Direction..
	if (thisCharacter.HumanoidRootPart.CFrame:VectorToObjectSpace(humanoidMoveDirection)).Z < 0 then

		-- If we couldnt..
		if canSprint == false then

			-- Now Can
			canSprint = true	

			-- If we were trying to sprint.. sprint..
			if leftShiftDown then

				-- Activtae
				ActivateSprint()
			end				
		end
	else

		-- If we could..
		if canSprint then

			-- now we cant..
			canSprint = false

			-- Deactivate
			DeactivateSprint()				

		end
	end
	
	-------------------
	-- Gun Sway Code --
	-------------------

	-- GamePad Support
	if (lastJoyXPos > 0 or lastJoyXPos < 0) or (lastJoyYPos > 0 or lastJoyYPos < 0) then

		-- Dont include "Dead Zone"
		if lastJoyXPos > thumbstickDeadZone or lastJoyXPos < -thumbstickDeadZone then

			-- Set Sway
			x_mouse_movement = x_mouse_movement - (lastJoyXPos * XBOX_SWAY_AMOUNT)

		end

		-- The Y
		if lastJoyYPos > thumbstickDeadZone or lastJoyYPos < -thumbstickDeadZone then

			-- Set Sway
			y_mouse_movement = math.clamp(y_mouse_movement + (lastJoyYPos * XBOX_SWAY_AMOUNT), -20, 20)

		end
	end
	
	---------------------
	-- Destermine Sway --
	---------------------
	
	--Horizontal
	if x_mouse_movement > last_x then
		sway_x = x_mouse_movement-last_x
	else
		sway_x = -(last_x - x_mouse_movement)
	end

	--Vertical
	if y_mouse_movement > last_y then
		sway_y = -(last_y - y_mouse_movement)
	else
		sway_y = -(last_y - y_mouse_movement)
	end

	--Limits
	if sway_x > max_sway_value then
		sway_x = max_sway_value
	end
	if sway_x < -max_sway_value then
		sway_x = -max_sway_value
	end
	if sway_y > max_sway_value then
		sway_y = max_sway_value
	end
	if sway_y < -max_sway_value then
		sway_y = -max_sway_value
	end
	
	--Capture last
	last_x = x_mouse_movement
	last_y = y_mouse_movement	
end

