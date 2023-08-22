-- Particles --
local bulletImpactEmitter = game.ServerStorage.Particles.BulletImpact
local bulletImpactEmitterBlood = game.ServerStorage.Particles.BloodSplatter
local plasmaImpactEmitter = game.ServerStorage.Particles.PlasmaImpact
local poisonImpactEmitter = game.ServerStorage.Particles.PoisonSplatter
local smokeImpactEmitter = game.ServerStorage.Particles.SmokeImpact
local glassShatterEmitter = game.ServerStorage.Particles.GlassShatter
local waterImpactEmitter = game.ServerStorage.Particles.WaterSplatter

-- Gun Damage --
local RANGE = 5000

-- Plasma Gun Damages
local PLASMAGUN_DAMAGE = 100 -- Up to 180
local PLASMAGUN_BLAST_DAMAGE = 100 -- Up to 180
local PLASMAGUN_BLAST_RADIUS = 8 -- Up to 16
local PLASMAGUN_UPGRADE_DAMAGE_INCREMENT = 20
local PLASMAGUN_UPGRADE_RADIUS_INCREMENT = 2
local PLASMAGUN_UPGRADE_PARTICLESPEED_INCREMENT = 5

-- Vial Gun Poison Damages
local VIALGUN_DAMAGE = 240 -- Max Damage
local VIALGUN_BLAST_DAMAGE = 240 -- Max Damage
local VIALGUN_BLAST_RADIUS = 16 -- Max Radius

-- Vial gun Basic
local VIALGUNBASIC_DAMAGE = 80 -- Up to 160
local VIALGUNBASIC_BLAST_DAMAGE = 80 -- Up to 160
local VIALGUNBASIC_BLAST_RADIUS = 8 -- Up to 16
local VIALGUNBASIC_UPGRADE_DAMAGE_INCREMENT = 20
local VIALGUNBASIC_UPGRADE_RADIUS_INCREMENT = 2
local VIALGUNBASIC_UPGRADE_PARTICLESPEED_INCREMENT = 2

-- Nailgun
local NAILGUN_DAMAGE = 60 -- Up to 140
local NAILGUN_UPGRADE_DAMAGE_INCREMENT = 20

-- BB Gun
local BBGUN_DAMAGE = 40 -- up to 120
local BBGUN_UPGRADE_DAMAGE_INCREMENT = 20

-- Shotgun
local SHOTGUN_DAMAGE = 80 -- Up to 160
local SHOTGUN_UPGRADE_DAMAGE_INCREMENT = 20
local SHOTGUN_SPREAD = 6
local SHOTGUN_BULLETSPERSHOT = 8

-- RayCast Vars --
local numRaycasts = 0
local raycastSpread = 0 -- Spread in Degrees

-- Debounce to Keep multiple Bullets from each Shot to only count as one kill --
local gotTheKill = false

---------------
-- Functions --
---------------

-- Function to Set Number of Raycasts and Spread for this Fire event --
local function SetNumRaycastsAndSpread(tool)


	-- If this was the VialGun, we need multiple Raycasts --
	if tool.Name == "VialGunPoison" or tool.Name == "VialGunBasic" then

		-- how Many raycasts and what spread --
		numRaycasts = 1
		raycastSpread = 0	
		
	elseif tool.Name == "PlasmaGun" then
		
		-- how Many raycasts and what spread --
		numRaycasts = 1
		raycastSpread = 0
		
	elseif tool.Name == "Nailgun" then
		
		-- how Many raycasts and what spread --
		numRaycasts = 1
		raycastSpread = 0		
		
	elseif tool.Name == "BBGun" then
		
		-- how Many raycasts and what spread --
		numRaycasts = 1
		raycastSpread = 0
	elseif tool.Name == "Shotgun" then

		-- how Many raycasts and what spread --
		numRaycasts = SHOTGUN_BULLETSPERSHOT
		raycastSpread = SHOTGUN_SPREAD
	end
end

-- Get This Shot Damage
local function GetThisDamage(player, tool)
	
	-- Get Multiplier
	local addedDamage = 0
	local totalDamage = 0

	-- Which gun is being used.. ? --	
	if tool.Name == "PlasmaGun" then
		addedDamage = (player.weaponlevels.plasmagundamagelevel.Value * PLASMAGUN_UPGRADE_DAMAGE_INCREMENT) - PLASMAGUN_UPGRADE_DAMAGE_INCREMENT
		totalDamage = PLASMAGUN_DAMAGE + addedDamage
	elseif tool.Name == "VialGunPoison" then
		totalDamage = VIALGUN_DAMAGE + addedDamage
	elseif tool.Name == "VialGunBasic" then
		addedDamage = (player.weaponlevels.vialgundamagelevel.Value * VIALGUNBASIC_UPGRADE_DAMAGE_INCREMENT) - VIALGUNBASIC_UPGRADE_DAMAGE_INCREMENT
		totalDamage = VIALGUNBASIC_DAMAGE + addedDamage
	elseif tool.Name == "Nailgun" then
		addedDamage = (player.weaponlevels.nailgundamagelevel.Value * NAILGUN_UPGRADE_DAMAGE_INCREMENT) - NAILGUN_UPGRADE_DAMAGE_INCREMENT
		totalDamage = NAILGUN_DAMAGE + addedDamage
	elseif tool.Name == "BBGun" then
		addedDamage = (player.weaponlevels.bbgundamagelevel.Value * BBGUN_UPGRADE_DAMAGE_INCREMENT) - BBGUN_UPGRADE_DAMAGE_INCREMENT
		totalDamage = BBGUN_DAMAGE + addedDamage
	elseif tool.Name == "Shotgun" then
		addedDamage = (player.weaponlevels.shotgundamagelevel.Value * SHOTGUN_UPGRADE_DAMAGE_INCREMENT) - SHOTGUN_UPGRADE_DAMAGE_INCREMENT
		totalDamage = SHOTGUN_DAMAGE + addedDamage
	else
		-- Default damage
		totalDamage = 0
	end
	
	-- nil Stuff
	addedDamage = nil
	
	return totalDamage
	
end

-- Debug Function for where a Raycast Hit (Creates Red Block) --
local function RayCastHitPosDebug(Position)

	-- RayCastHitDebug --
	local part = Instance.new("Part")
	part.Parent = workspace
	part.Position = Position
	part.BrickColor = BrickColor.new("Really red")
	part.Size = Vector3.new(1,1,1)
	part.Anchored = true
	part.CanCollide = false

end

-- Function to Coroutine and control a rats color..
local function PlasmaBurnFX(rat, distance)
	
	-- Cant Burn Rat King
	if rat.Name == "RatKing" then
		return
	end
	
	-- Leave function is Rat is dieing..
	if rat.Torso.Transparency > 0 then
		
		-- LEave Function
		return
	end
	
	-- Original Color (Brightness)
	local ogColor = rat.Torso.Color
	local ogColorRGB = math.floor(ogColor.R * 255)
	local minimumBrightness = 200
	local yDisplacement = (255 - minimumBrightness)
	
	-- Plasma Distance brightness
	local brightnessTaken = math.floor(((((0-yDisplacement) / PLASMAGUN_BLAST_RADIUS) * distance) + yDisplacement) + minimumBrightness)
	
    -- To COlor
	local colorToApply = Color3.fromRGB(brightnessTaken, brightnessTaken, brightnessTaken)
	
	-- Apply Brightness
	rat.BackTailBase.Color = colorToApply
	rat.BackTorso.Color = colorToApply
	rat.FrontTailBase.Color = colorToApply
	rat.Head.Color = colorToApply
	rat.MiddleTorso.Color = colorToApply
	rat.Neck.Color = colorToApply
	rat.Nose.Color = colorToApply
	rat.NoseTip.Color = colorToApply
	rat.Torso.Color = colorToApply
	
	-- Material Application 
	local materialToApply = nil
	
	-- Random Dakrness to Fade too (Burnt Effect)
	local random = nil
	
	--- Set Material to Plasma Only Apply them once..
	if rat.Name == "RatAlbino" or rat.Name == "RatAlbinoMinion" then
		
		-- Material
		materialToApply = "PlasmaWhite"	
		
		-- Set Burn Effect
		random = math.random(120, 160)
				
		
	else -- Is a regular Rat..
		
		-- Material
		materialToApply = "Plasma"	
		
		-- Set Burn Effect
		random = math.random(60, 100)
		
	end	
	
	-- Apply the material..
	rat.BackTailBase.MaterialVariant = materialToApply
	rat.BackTorso.MaterialVariant = materialToApply
	rat.FrontTailBase.MaterialVariant = materialToApply
	rat.Head.MaterialVariant = materialToApply
	rat.MiddleTorso.MaterialVariant = materialToApply
	rat.Neck.MaterialVariant = materialToApply
	rat.Nose.MaterialVariant = materialToApply
	rat.NoseTip.MaterialVariant = materialToApply
	rat.Torso.MaterialVariant = materialToApply
	
	---------------------------------
	-- Fade color back to original --
	---------------------------------
	
	
	while brightnessTaken > random and rat do
		
		-- Subtract brightness Taken
		brightnessTaken -= 5
		
		-- Color to Apply
		colorToApply = Color3.fromRGB(brightnessTaken, brightnessTaken, brightnessTaken)
		
		-- Apply Brightness
		rat.BackTailBase.Color = colorToApply
		rat.BackTorso.Color = colorToApply
		rat.FrontTailBase.Color = colorToApply
		rat.Head.Color = colorToApply
		rat.MiddleTorso.Color = colorToApply
		rat.Neck.Color = colorToApply
		rat.Nose.Color = colorToApply
		rat.NoseTip.Color = colorToApply
		rat.Torso.Color = colorToApply		
		
		-- Wait
		task.wait()
	end
	
	-- Nil Stuff
	materialToApply = nil
	random = nil
	colorToApply = nil
	minimumBrightness = nil
	ogColor = nil
	ogColorRGB = nil
	yDisplacement = nil
	
end

-- Plasma Gun FX --
local function PlasmaGunHitFX(player, result)

	--------------------------
	-- Plasma Burn from hit --
	--------------------------
	
	-- Name Ref..
	local resultName  = result.Instance.Parent.Name
	
	-- if we hit a rat..
	if resultName == "Rat" or resultName == "RatAlbino" or resultName == "RatAlbinoMinion" then

		-- Run as a coroutine..
		local plasmaBurnCoroutine = coroutine.create(PlasmaBurnFX)

		-- Run it
		coroutine.resume(plasmaBurnCoroutine, result.Instance.Parent, 0)

		-- Nil
		plasmaBurnCoroutine = nil	
	end	

	-- Create Bullet Impact Where Bullet Hit --
	local plasmaImpact = plasmaImpactEmitter:Clone()

	-- Put into Workspace --
	plasmaImpact.Parent = game.Workspace.Particles

	-- Anchor it
	plasmaImpact.Anchored = true

	-- Create Cframe Angle
	local normalAngleCFrame = CFrame.lookAt(result.Position, result.Position + result.Normal)			

	-- Set Position --				
	plasmaImpact.CFrame = normalAngleCFrame
	
	-- Add Radius Level to Emitter
	local addedRadius = (player.weaponlevels.plasmagunradiuslevel.Value * PLASMAGUN_UPGRADE_PARTICLESPEED_INCREMENT) - PLASMAGUN_UPGRADE_PARTICLESPEED_INCREMENT
	local newSpeed = NumberRange.new(plasmaImpact.Impact.Speed.Min + addedRadius, plasmaImpact.Impact.Speed.Max + addedRadius)
	plasmaImpact.Impact.Speed = newSpeed
	
	-- Nil Stuff
	plasmaImpact = nil
	normalAngleCFrame = nil
	addedRadius = nil
	newSpeed = nil
	resultName = nil
	
end

-- Plasma Gun Explosion FX --
local function PlasmaGunSplashDamageAndFX(Player, result)

	-----------------------------------
	-- Create Explosion Blast Radius --
	-----------------------------------

	-- Create Explosion to detect Blast Radius..
	local explosion = Instance.new("Explosion")
	
	----------------------
	-- Set Blast Radius --
	----------------------
	
	-- Var
	local addedRadius = (Player.weaponlevels.plasmagunradiuslevel.Value * PLASMAGUN_UPGRADE_RADIUS_INCREMENT) - PLASMAGUN_UPGRADE_RADIUS_INCREMENT
	explosion.BlastRadius = PLASMAGUN_BLAST_RADIUS + addedRadius
	addedRadius = nil

	-- Blast PRessure
	explosion.BlastPressure = 0

	-- Invisible Explosion
	explosion.Visible = false

	-- Set This to Handle Custom Humanoid Damage
	explosion.DestroyJointRadiusPercent = 0

	-- Explosion Type..
	explosion.ExplosionType = Enum.ExplosionType.NoCraters -- doesnt damage terrain
	
	-- Put Explosioj Into Workspace
	explosion.Parent = game.Workspace
	
	-- Position of Explosion..
	explosion.Position = result.Position	

	-- Check for Event.HIT
	explosion.Hit:Connect(function(part, distance)

		-- Reset Got the kill
		gotTheKill = false

		-- Did we hit a humanoid?
		if part.Parent:FindFirstChild("Humanoid") then

			-- If it was a rat..
			if part.Parent.Name == "Rat" or part.Parent.Name == "RatAlbino" or part.Parent.Name == "RatKing" or part.Parent.Name == "RatAlbinoMinion" then										

				-- Only Do Damage if we hit its HRP..
				if part == part.Parent.PrimaryPart then
					
					-- Exit if this is the same Rat that we just hit...
					if result.Instance.Parent == part.Parent then
						
						-- Exit this connection.
						return
					end

					-- Damage Humanoid..
					local hitEnemyHealth = part.Parent.Humanoid.Health				

					-- If enemy is not already dead --
					if hitEnemyHealth > 0 then
						
						-- Play Hit Sound attached to enemy --
						game.ReplicatedStorage.RatFleshImpactSound:FireClient(Player)

						-- Make Rats Purple --
						local plasmaBurnCoroutine = coroutine.create(PlasmaBurnFX)

						-- Run it
						coroutine.resume(plasmaBurnCoroutine, part.Parent, distance)

						-- Nil
						plasmaBurnCoroutine = nil
						
						-- Get Damage Mult
						local addedDamage = (Player.weaponlevels.plasmagundamagelevel.Value * PLASMAGUN_UPGRADE_DAMAGE_INCREMENT) - PLASMAGUN_UPGRADE_DAMAGE_INCREMENT
						
						-- Determine the Damage this Rat will take based on distance..
						local slope = (0 - (PLASMAGUN_BLAST_DAMAGE + addedDamage)) / explosion.BlastRadius
						local damageTaken = (slope * distance) + (PLASMAGUN_BLAST_DAMAGE + addedDamage)
						
						-- Is this player going to die on this hit.. ? --
						if hitEnemyHealth - damageTaken <= 0 then

							-- Only one Shot gets the kill --
							if gotTheKill == false then

								-- Do the Damage! --
								part.Parent.Humanoid.Health -= damageTaken

								-- Give PLayer a Stat --
								Player.leaderstats.ratskilled.Value = Player.leaderstats.ratskilled.Value + 1
								
								-----------------------
								-- Give Player Blood --
								-----------------------

								-- If it was an albino Rat..
								if part.Parent.Name == "RatAlbino" or part.Parent.Name == "RatAlbinoMinion" then											
									-- 3 Blood
									Player.blood.Value += 10											
								elseif part.Parent.Name == "RatKing" then											

									-- 100 Blood for RatKing
									Player.blood.Value += 100											
								else
									-- 1 Blood for regular Rat..
									Player.blood.Value += 1											
								end

								-- Now we got the kill --
								gotTheKill = true																		

							end

							------------------------
							-- Smoke FX on Death  --
							------------------------
							-- Vial gun Stuff
							local smokeImpact = smokeImpactEmitter:Clone()

							-- Put into Workspace --
							smokeImpact.Parent = game.Workspace.Particles

							-- Anchor it
							smokeImpact.Anchored = true

							-- Create Cframe Angle
							local normalAngleCFrame = CFrame.lookAt(part.Position, part.Position + Vector3.new(0,10,0))			

							-- Set Position --				
							smokeImpact.CFrame = normalAngleCFrame

							-- Play Sizzle Sound
							smokeImpact.Sizzle:Play()

							-- Nil Stuff
							smokeImpact = nil
							normalAngleCFrame = nil


						else -- Player is not going to die on this hit..

							-- Do the Damage! --
							part.Parent.Humanoid.Health -= damageTaken

						end

						-- Nil Stuff
						slope = nil
						damageTaken = nil
						addedDamage = nil
					end

					-- Nil Stuff
					hitEnemyHealth = nil

				end									
			end									
		end
	end)

	-- Nil Stuff
	--explosion = nil

end

--------------------------
-- Vial gun Basic Stuff --
--------------------------

-- Vial Gun Basic Water Burn FX
local function VialGunBasicWaterBurnFX(rat)

	-- If its ratKing leave
	if rat.Name == "RatKing" then
		return
	end

	-- Determine Material to apply..
	local materialToApply = nil	

	--- Find which material we are going to apply to this rat..
	if rat.Name == "RatAlbino" or rat.Name == "RatAlbinoMinion" then

		-- If it was already White, make it denser
		if rat.Torso.MaterialVariant == "WaterSplashWhite" or rat.Torso.MaterialVariant == "WaterSplashWhiteDense" then

			-- Mat
			materialToApply = "WaterSplashWhiteDense"

		else

			-- Mat
			materialToApply = "WaterSplashWhite"				

		end		

	else -- For Regular Rat..

		-- If Tree
		if rat.Torso.MaterialVariant == "WaterSplash" or rat.Torso.MaterialVariant == "WaterSplashDense" then

			-- Material
			materialToApply = "WaterSplashDense"
		else

			-- Mat
			materialToApply = "WaterSplash"
		end

	end	

	-- Now Apply the Chosen MAterial..
	rat.BackTailBase.MaterialVariant = materialToApply
	rat.BackTorso.MaterialVariant = materialToApply
	rat.FrontTailBase.MaterialVariant = materialToApply
	rat.Head.MaterialVariant = materialToApply
	rat.MiddleTorso.MaterialVariant = materialToApply	
	rat.Neck.MaterialVariant = materialToApply
	rat.Nose.MaterialVariant = materialToApply
	rat.NoseTip.MaterialVariant = materialToApply
	rat.Torso.MaterialVariant = materialToApply	

	-- Nil Stuff
	materialToApply = nil
end

-- Plasma Gun FX --
local function VialGunBasicHitFX(player, result)
	
	--------------------------
	-- Poison Burn from hit --
	--------------------------

	-- Local Ref
	local resultName = result.Instance.Parent.Name

	-- if we hit a rat..
	if resultName == "Rat" or resultName == "RatAlbino" or resultName == "RatAlbinoMinion" then

		-- Function
		VialGunBasicWaterBurnFX(result.Instance.Parent)		
	end	

	-----------------------
	-- Water Hit Splash --
	-----------------------

	-- Vial gun Stuff
	local waterImpact = waterImpactEmitter:Clone()

	-- Put into Workspace --
	waterImpact.Parent = game.Workspace.Particles

	-- Anchor it
	waterImpact.Anchored = true

	-- Create Cframe Angle
	local normalAngleCFrame = CFrame.lookAt(result.Position, result.Position + result.Normal)			

	-- Set Position --				
	waterImpact.CFrame = normalAngleCFrame	
	
	-- Add Radius Level to Emitter
	local addedRadius = (player.weaponlevels.vialgunradiuslevel.Value * VIALGUNBASIC_UPGRADE_PARTICLESPEED_INCREMENT) - VIALGUNBASIC_UPGRADE_PARTICLESPEED_INCREMENT
	local newSpeed = NumberRange.new(waterImpact.Impact.Speed.Min + addedRadius, waterImpact.Impact.Speed.Max + addedRadius)
	waterImpact.Impact.Speed = newSpeed

	------------------
	-- Splash Sound --
	------------------

	-- Get the Sound from the Tool --
	local vialSplashSound = waterImpact.Splash							

	-- Is sound not already playng, play it --
	if not vialSplashSound.IsPlaying then

		-- Set Time Position
		--vialSplashSound.TimePosition = 0.33

		-- Play the Sound
		vialSplashSound:Play()								
	end	

	-- Nil
	vialSplashSound = nil
	normalAngleCFrame = nil


end

-- VialGun Splash Damage and FX --
local function VialGunBasicSplashDamageAndFX(Player, result)

	-----------------------------------
	-- Create Explosion Blast Radius --
	-----------------------------------

	-- Create Explosion to detect Blast Radius..
	local explosion = Instance.new("Explosion")

	-- Var
	local addedRadius = (Player.weaponlevels.vialgunradiuslevel.Value * VIALGUNBASIC_UPGRADE_RADIUS_INCREMENT) - VIALGUNBASIC_UPGRADE_RADIUS_INCREMENT
	explosion.BlastRadius = VIALGUNBASIC_BLAST_RADIUS + addedRadius
	addedRadius = nil

	-- Blast PRessure
	explosion.BlastPressure = 0

	-- Invisible Explosion
	explosion.Visible = false

	-- Set This to Handle Custom Humanoid Damage
	explosion.DestroyJointRadiusPercent = 0

	-- Explosion Type..
	explosion.ExplosionType = Enum.ExplosionType.NoCraters -- doesnt damage terrain
	
	-- Put Explosioj Into Workspace
	explosion.Parent = game.Workspace

	-- Position of Explosion..
	explosion.Position = result.Position	

	-- Check for Event.HIT
	explosion.Hit:Connect(function(part, distance)

		-- Reset Got the kill
		gotTheKill = false

		-- Did we hit a humanoid?
		if part.Parent:FindFirstChild("Humanoid") then

			-- If it was a rat..
			if part.Parent.Name == "Rat" or part.Parent.Name == "RatAlbino" or part.Parent.Name == "RatKing" or part.Parent.Name == "RatAlbinoMinion" then									

				-- Only Do Damage if we hit its HRP..
				if part == part.Parent.PrimaryPart then

					-- Exit if this is the same Rat that we just hit...
					if result.Instance.Parent == part.Parent then

						-- Exit this connection.
						return
					end

					-- Damage Humanoid..
					local hitEnemyHealth = part.Parent.Humanoid.Health				

					-- If enemy is not already dead --
					if hitEnemyHealth > 0 then

						-- Play Hit Sound attached to enemy --
						game.ReplicatedStorage.RatFleshImpactSound:FireClient(Player)
						
						-- Make Rats Blue --
						local waterBurnCoroutine = coroutine.create(VialGunBasicWaterBurnFX)

						-- Run it
						coroutine.resume(waterBurnCoroutine, part.Parent)

						-- Nil
						waterBurnCoroutine = nil
						
						-- Add  Added Damage						
						local addedDamage = (Player.weaponlevels.vialgundamagelevel.Value * VIALGUNBASIC_UPGRADE_DAMAGE_INCREMENT) - VIALGUNBASIC_UPGRADE_DAMAGE_INCREMENT

						-- Determine the Damage this Rat will take based on distance..
						local slope = (0 - (VIALGUNBASIC_BLAST_DAMAGE + addedDamage)) / explosion.BlastRadius
						local damageTaken = (slope * distance) + (VIALGUNBASIC_BLAST_DAMAGE + addedDamage)

						-- Is this player going to die on this hit.. ? --
						if hitEnemyHealth - damageTaken <= 0 then

							-- Only one Shot gets the kill --
							if gotTheKill == false then

								-- Do the Damage! --
								part.Parent.Humanoid.Health -= damageTaken

								-- Give PLayer a Stat --
								Player.leaderstats.ratskilled.Value = Player.leaderstats.ratskilled.Value + 1

								-----------------------
								-- Give Player Blood --
								-----------------------

								-- If it was an albino Rat..
								if part.Parent.Name == "RatAlbino" or part.Parent.Name == "RatAlbinoMinion" then
									-- 3 Blood
									Player.blood.Value += 10											
								elseif part.Parent.Name == "RatKing" then										

									-- 100 Blood for RatKing
									Player.blood.Value += 100											
								else
									-- 1 Blood for regular Rat..
									Player.blood.Value += 1											
								end

								-- Now we got the kill --
								gotTheKill = true																		

							end

						else -- Player is not going to die on this hit..

							-- Do the Damage! --
							part.Parent.Humanoid.Health -= damageTaken

						end

						-- Nil Stuff
						slope = nil
						damageTaken = nil
						addedDamage = nil
					end

					-- Nil Stuff
					hitEnemyHealth = nil

				end									
			end									
		end
	end)
end

---------------------------
-- Vial Gun Poison Stuff --
---------------------------

-- Rat Poison Burn Coroutine..
local function VialGunPoisonBurnFX(rat)
	
	-- If its ratKing leave
	if rat.Name == "RatKing" then
		return
	end
	
	-- Determine Material to apply..
	local materialToApply = nil	

	--- Find which material we are going to apply to this rat..
	if rat.Name == "RatAlbino" or rat.Name == "RatAlbinoMinion" then

		-- If it was already White, make it denser
		if rat.Torso.MaterialVariant == "PoisonSplashWhite" or rat.Torso.MaterialVariant == "PoisonSplashWhiteDense" then

			-- Mat
			materialToApply = "PoisonSplashWhiteDense"

		else
			
			-- Mat
			materialToApply = "PoisonSplashWhite"					

		end		

	else -- For Regular Rat..
		
		-- If Tree
		if rat.Torso.MaterialVariant == "PoisonSplash" or rat.Torso.MaterialVariant == "PoisonSplashDense" then

			-- Material
			materialToApply = "PoisonSplashDense"
		else

			-- Mat
			materialToApply = "PoisonSplash"
		end

	end	
	
	-- Now Apply the Chosen MAterial..
	rat.BackTailBase.MaterialVariant = materialToApply
	rat.BackTorso.MaterialVariant = materialToApply
	rat.FrontTailBase.MaterialVariant = materialToApply
	rat.Head.MaterialVariant = materialToApply
	rat.MiddleTorso.MaterialVariant = materialToApply	
	rat.Neck.MaterialVariant = materialToApply
	rat.Nose.MaterialVariant = materialToApply
	rat.NoseTip.MaterialVariant = materialToApply
	rat.Torso.MaterialVariant = materialToApply	
	
	-- Nil Stuff
	materialToApply = nil

end

-- Plasma Gun FX --
local function VialGunPoisonHitFX(result)
	
	--------------------------
	-- Poison Burn from hit --
	--------------------------
	
	-- Local Ref
	local resultName = result.Instance.Parent.Name
	
	-- if we hit a rat..
	if resultName == "Rat" or resultName == "RatAlbino" or resultName == "RatAlbinoMinion" then
		
		-- Function
		VialGunPoisonBurnFX(result.Instance.Parent)		
	end	
	
	-----------------------
	-- Poison Hit Splash --
	-----------------------
	
	-- Vial gun Stuff
	local poisonImpact = poisonImpactEmitter:Clone()

	-- Put into Workspace --
	poisonImpact.Parent = game.Workspace.Particles

	-- Anchor it
	poisonImpact.Anchored = true

	-- Create Cframe Angle
	local normalAngleCFrame = CFrame.lookAt(result.Position, result.Position + result.Normal)			

	-- Set Position --				
	poisonImpact.CFrame = normalAngleCFrame	
	
	------------------
	-- Splash Sound --
	------------------

	-- Get the Sound from the Tool --
	local vialSplashSound = poisonImpact.Splash							

	-- Is sound not already playng, play it --
	if not vialSplashSound.IsPlaying then

		-- Play the Sound
		vialSplashSound:Play()								
	end	
	
	--[[
	-----------------------
	-- Glass Hit Shatter --
	-----------------------

	-- Vial gun Stuff
	local glassShatter = glassShatterEmitter:Clone()

	-- Put into Workspace --
	glassShatter.Parent = game.Workspace.Particles

	-- Anchor it
	glassShatter.Anchored = true

	-- Create Cframe Angle
	normalAngleCFrame = CFrame.lookAt(result.Position, result.Position + result.Normal)			

	-- Set Position --				
	glassShatter.CFrame = normalAngleCFrame
	
	------------------
	-- Glass Sound  --
	------------------

	-- Get the Sound from the Tool --
	local glassShatterSound = glassShatter.GlassShatter	
	local glassShatterSound2 = glassShatter.GlassShatter2
	
	-- Random
	local random = math.random(1,2)
	
	-- Choose
	local chosenSound = nil
	if random == 1 then
		chosenSound = glassShatterSound
	elseif random == 2 then
		chosenSound = glassShatterSound2
	end

	-- Is sound not already playng, play it --
	if not chosenSound.IsPlaying then

		-- Play the Sound
		chosenSound:Play()								
	end	
	
	-- Nil Stuff
	glassShatter = nil
	glassShatterSound = nil
	glassShatterSound2 = nil
	chosenSound = nil
	random = nil

	]]

	-- Nil
	vialSplashSound = nil
	poisonImpact = nil
	normalAngleCFrame = nil
	resultName = nil	
	
end

-- VialGun Splash Damage and FX --
local function VialGunPoisonSplashDamageAndFX(Player, result)
	
	-----------------------------------
	-- Create Explosion Blast Radius --
	-----------------------------------

	-- Create Explosion to detect Blast Radius..
	local explosion = Instance.new("Explosion")

	-- Radius..
	explosion.BlastRadius = VIALGUN_BLAST_RADIUS

	-- Blast PRessure
	explosion.BlastPressure = 0

	-- Invisible Explosion
	explosion.Visible = false

	-- Set This to Handle Custom Humanoid Damage
	explosion.DestroyJointRadiusPercent = 0

	-- Explosion Type..
	explosion.ExplosionType = Enum.ExplosionType.NoCraters -- doesnt damage terrain
	
	-- Put Explosioj Into Workspace
	explosion.Parent = game.Workspace

	-- Position of Explosion..
	explosion.Position = result.Position

	-- Check for Event.HIT
	explosion.Hit:Connect(function(part, distance)

		-- Reset Got the kill
		gotTheKill = false

		-- Did we hit a humanoid?
		if part.Parent:FindFirstChild("Humanoid") then

			-- If it was a rat..
			if part.Parent.Name == "Rat" or part.Parent.Name == "RatAlbino" or part.Parent.Name == "RatKing" or part.Parent.Name == "RatAlbinoMinion" then										

				-- Only Do Damage if we hit its HRP..
				if part == part.Parent.PrimaryPart then
					
					-- Exit if this is the same Rat that we just hit...
					if result.Instance.Parent == part.Parent then

						-- Exit this connection.
						return
					end

					-- Damage Humanoid..
					local hitEnemyHealth = part.Parent.Humanoid.Health				

					-- If enemy is not already dead --
					if hitEnemyHealth > 0 then
						
						-- Play Hit Sound attached to enemy --
						game.ReplicatedStorage.RatFleshImpactSound:FireClient(Player)
						
						-- Make Rats Purple --
						local poisonBurnCoroutine = coroutine.create(VialGunPoisonBurnFX)

						-- Run it
						coroutine.resume(poisonBurnCoroutine, part.Parent)

						-- Nil
						poisonBurnCoroutine = nil
						
						-- Determine the Damage this Rat will take based on distance..
						local slope = (0 - VIALGUN_BLAST_DAMAGE) / VIALGUN_BLAST_RADIUS
						local damageTaken = (slope * distance) + VIALGUN_BLAST_DAMAGE

						-- Is this player going to die on this hit.. ? --
						if hitEnemyHealth - damageTaken <= 0 then

							-- Only one Shot gets the kill --
							if gotTheKill == false then

								-- Do the Damage! --
								part.Parent.Humanoid.Health -= damageTaken

								-- Give PLayer a Stat --
								Player.leaderstats.ratskilled.Value = Player.leaderstats.ratskilled.Value + 1
								
								-----------------------
								-- Give Player Blood --
								-----------------------

								-- If it was an albino Rat..
								if part.Parent.Name == "RatAlbino" or part.Parent.Name == "RatAlbinoMinion" then											
									-- 3 Blood
									Player.blood.Value += 10											
								elseif part.Parent.Name == "RatKing" then											

									-- 100 Blood for RatKing
									Player.blood.Value += 100											
								else
									-- 1 Blood for regular Rat..
									Player.blood.Value += 1											
								end

								-- Now we got the kill --
								gotTheKill = true																		

							end
							
							------------------------
							-- Smoke FX on Death  --
							------------------------
							
							-- Vial gun Stuff
							local smokeImpact = smokeImpactEmitter:Clone()

							-- Put into Workspace --
							smokeImpact.Parent = game.Workspace.Particles

							-- Anchor it
							smokeImpact.Anchored = true

							-- Create Cframe Angle
							local normalAngleCFrame = CFrame.lookAt(part.Position, part.Position + Vector3.new(0,10,0))			

							-- Set Position --				
							smokeImpact.CFrame = normalAngleCFrame
							
							-- Play Sizzle Sound
							smokeImpact.Sizzle:Play()

							-- Nil Stuff
							smokeImpact = nil
							normalAngleCFrame = nil

						else -- Player is not going to die on this hit..

							-- Do the Damage! --
							part.Parent.Humanoid.Health -= damageTaken

						end
						
						-- Nil Stuff
						slope = nil
						damageTaken = nil
					end

					-- Nil Stuff
					hitEnemyHealth = nil

				end									
			end									
		end
	end)
	
	-- Nil Stuff
	explosion = nil
	
end

-- Blood Splatter From Bullet FX
local function BloodSplatterFX(result)
	
	------------------------------------------
	-- Create A Blood Splatter on Hit Enemy --
	------------------------------------------

	-- Blood Splatter
	local bulletImpactBlood = bulletImpactEmitterBlood:Clone()

	-- Put into Workspace --
	bulletImpactBlood.Parent = game.Workspace.Particles

	-- Anchor it
	bulletImpactBlood.Anchored = true

	-- Create Cframe Angle
	local normalAngleCFrame = CFrame.lookAt(result.Position, result.Position + result.Normal)			

	-- Set Position --				
	bulletImpactBlood.CFrame = normalAngleCFrame

	-- Nil Stuff
	bulletImpactBlood = nil
	normalAngleCFrame = nil
	
end

-- Function for Bullet Impact on NonFlesh --
local function BulletImpactFXHardSurface(result, showImpact, playSounds)
	
	--------------------------
	-- Create bullet sparks --
	--------------------------
	
	-- Create Bullet Impact Where Bullet Hit --
	local bulletImpact = bulletImpactEmitter:Clone()

	-- Put into Workspace --
	bulletImpact.Parent = game.Workspace.Particles

	-- Anchor it
	bulletImpact.Anchored = true

	-- Create Cframe Angle
	local normalAngleCFrame = CFrame.lookAt(result.Position, result.Position + result.Normal)		

	-- Set Position --				
	bulletImpact.CFrame = normalAngleCFrame
	
	-------------------------------
	-- Material Specific Impacts --
	-------------------------------

	-- Make ricochet Sound if we hit metal --
	if result.Instance.Material == Enum.Material.CorrodedMetal or result.Instance.Material == Enum.Material.Metal then
		
		-- If we want Ricochet..
		if playSounds then
			
			-- Get the Sound from the Tool --
			local bulletRicochetSound = bulletImpact.BulletRicochet						

			-- Is sound not already playng, play it --
			if not bulletRicochetSound.IsPlaying then

				-- Play the Sound
				bulletRicochetSound:Play()								
			end	

			-- NIl Stuff
			bulletRicochetSound = nil
			
		end		
		
	elseif result.Instance.Material == Enum.Material.Concrete then
		
		-- If we want to play Sonds
		if playSounds then
			
			-- Get the Sound from the Tool --
			local bulletHitConcreteSound = bulletImpact.BulletHitConcrete

			-- Is sound not already playng, play it --
			if not bulletHitConcreteSound.IsPlaying then

				-- Play the Sound
				bulletHitConcreteSound:Play()								
			end	

			-- NIl Stuff
			bulletHitConcreteSound = nil			
			
		end
		
		-- If we want to Show Impacts
		if showImpact then
			
			-- Show Bullet Decal
			bulletImpact.ConcreteHole.Transparency = 0
			
		end		
		
	elseif result.Instance.Material == Enum.Material.Glass then
		
		-- If Impacts
		if showImpact then
			
			-- make Box Bigger
			bulletImpact.Size = Vector3.new(0.66,0.66,0.05)

			-- Show Glass Decal..
			bulletImpact.GlassHole.Transparency = 0	
			
		end		
	end

	-- Nil Stuff
	bulletImpact = nil
	normalAngleCFrame = nil	
	
end

-- Recieving Fire Event from Local Player --
game.ReplicatedStorage.ShootGun.OnServerEvent:Connect(function(Player, HitSomething, TargetLocation, Direction, Tool, LocalFireOrigin)
	
	-- If this was a shot from the Crossbow..
	if Tool.Name == "CrossbowExplosive" then
		
		-- Play Fire sound From Crossbow
		Player.Character.Model.Handle.Fire:Play()
		
		-- Shot Direction Ref
		local shotDirection = nil
		
		-- Define Direction of this Shot..
		if HitSomething then
			
			-- Normal
			shotDirection = (TargetLocation - LocalFireOrigin).Unit
			
		else
			
			-- No Target
			shotDirection = ((Direction * 200) - LocalFireOrigin).Unit		
			
		end
		
		-- Create New Crossbow
		local bolt = game.ServerStorage.UsedExplosiveBolt:Clone()				

		-- Parent
		bolt.Parent = game.Workspace

		-- Set Player Name who shot It
		bolt.PlayerName.Value = tostring(Player.Name)

		-- Set Position
		bolt.CFrame = CFrame.lookAt(LocalFireOrigin, LocalFireOrigin + shotDirection)

		-- Apply Impulse
		bolt:ApplyImpulse(shotDirection * 200 * bolt.AssemblyMass)

		-- Nil Stuff
		bolt = nil
		
		-- Leave Function
		return
		
	end
	
	-- Get this Damage --
	local thisDamage = GetThisDamage(Player, Tool)
	
	-- Play Fire Sound from Handle on the server --
	Player.Character.Model.Handle.Fire:Play()
	
	-- function to set Raycats Number and Spread --
	SetNumRaycastsAndSpread(Tool)
	
	-- Only Loop through raycasts if we werent shooting into endless space...
	if HitSomething then
		
		-- Loop through every Shot.. --
		for i = 1, numRaycasts do

			-- Ref
			local result = nil

			-- Create new Raycast Handle --
			local newRay = RaycastParams.new()

			-- Dont let raycast hit the player shooting it --
			newRay.FilterDescendantsInstances = {Player.Character}
			
			-- filter Type
			newRay.FilterType = Enum.RaycastFilterType.Blacklist
			
			-- Collision Group
			newRay.CollisionGroup = "WeaponRaycasts"

			---------------------------------------
			-- Change Angle of Each rayCast Here --
			---------------------------------------		

			-- Calculate Raycast direction
			local rayDirection = (TargetLocation - LocalFireOrigin) * RANGE

			-- create a Random y Angle in Degrees --
			local randomYAngle = math.random(-raycastSpread,raycastSpread)
			local randomXAngle = math.random(-raycastSpread,raycastSpread)
			local randomZAngle = math.random(-raycastSpread,raycastSpread)

			-- apply the y angle to the DirectionVector
			rayDirection =
				CFrame.Angles( math.rad(randomXAngle),
							   math.rad(randomYAngle),
							   math.rad(randomZAngle))
											:VectorToWorldSpace(rayDirection)		

			--------------------------
			-- Now Cast the Raycast --
			--------------------------

			-- Cast From Camera --
			result = workspace:Raycast(LocalFireOrigin, rayDirection, newRay)

			-- Nil Stuff
			newRay = nil
			randomYAngle = nil
			randomXAngle = nil
			randomZAngle = nil

			-- Debug for where raycast Hit --
			--RayCastHitPosDebug(result.Position)	

			-- If we got back a result.. --
			if result then

				-- If we actually hit something.. --
				if result.Instance then

					-- If we hit an Instance with a humanoid on it.. --
					if result.Instance.Parent:FindFirstChild("Humanoid") then
						
						----------
						-- Vars --
						----------

						-- Save Character Hit --
						local hitEnemy = result.Instance.Parent
						
						-- Get Enemy Health
						local hitEnemyHealth = result.Instance.Parent.Humanoid.Health
						
						-----------
						-- Sound --
						-----------

						-- PLay Impact Sound of that Rat --
						if hitEnemy.Name == "Rat" or hitEnemy.Name == "RatKing" or hitEnemy.Name == "RatAlbino" or hitEnemy.Name == "RatAlbinoMinion" then
							
							------------------------------------------------------------
							-- Lower Health Based on Weapon and Add Leaderboard Stats --
							------------------------------------------------------------

							-- If their health is above 0..
							if hitEnemyHealth > 0 then
								
								-- Play Hit Sound attached to enemy --
								game.ReplicatedStorage.RatFleshImpactSound:FireClient(Player)

								-- Is this player going to die on this hit.. ? --
								if hitEnemyHealth - thisDamage <= 0 then

									-- Only one Shot gets the kill --
									if gotTheKill == false then

										-- Do the Damage! --
										hitEnemy.Humanoid.Health -= thisDamage

										-- Give PLayer a Stat --
										Player.leaderstats.ratskilled.Value = Player.leaderstats.ratskilled.Value + 1 
										
										-----------------------
										-- Give Player Blood --
										-----------------------
										
										-- If it was an albino Rat..
										if hitEnemy.Name == "RatAlbino" or hitEnemy.Name == "RatAlbinoMinion" then											
											-- 3 Blood
											Player.blood.Value += 10											
										elseif hitEnemy.Name == "RatKing" then											
											
											-- 100 Blood for RatKing
											Player.blood.Value += 100											
										else
											-- 1 Blood for regular Rat..
											Player.blood.Value += 1											
										end

										-- Now we got the kill --
										gotTheKill = true																		

									end

									-- If this was the plasmaGun or VialGun, make smoke..
									if Tool.Name == "PlasmaGun" or Tool.Name == "VialGunPoison" then

										------------------------
										-- Smoke FX on Death  --
										------------------------
										-- Vial gun Stuff
										local smokeImpact = smokeImpactEmitter:Clone()

										-- Put into Workspace --
										smokeImpact.Parent = game.Workspace.Particles

										-- Anchor it
										smokeImpact.Anchored = true

										-- Create Cframe Angle
										local normalAngleCFrame = CFrame.lookAt(result.Position, result.Position + Vector3.new(0,10,0))			

										-- Set Position --				
										smokeImpact.CFrame = normalAngleCFrame
										
										-- Play Sizzle Sound
										smokeImpact.Sizzle:Play()

										-- Nil Stuff
										smokeImpact = nil
										normalAngleCFrame = nil									

									end								

								else -- Player is not going to die on this hit..

									-- Do the Damage! --
									hitEnemy.Humanoid.Health -= thisDamage

								end
							end

						else -- Not a Rat, A PLayer..
							
							 -- Dont Do Damage							
						end		
	
						---------------------
						-- Special Effects --
						---------------------
						
						-- If we had the plasma Gun..
						if Tool.Name == "PlasmaGun" then
							
							-- Run Hit FX
							PlasmaGunHitFX(Player, result)					
							
							-- Splash Damage and FX
							PlasmaGunSplashDamageAndFX(Player, result)					
							
							
						elseif Tool.Name == "VialGunPoison" then
							
							-- Vial Gun Poison Hit FX
							VialGunPoisonHitFX(result)						
							
							-- VialGun Splash Damage and FX
							VialGunPoisonSplashDamageAndFX(Player, result)
							
						elseif Tool.Name == "VialGunBasic" then
							
							-- Vial Gun Poison Hit FX
							VialGunBasicHitFX(Player, result)
							
							-- Splash Damage
							VialGunBasicSplashDamageAndFX(Player, result)
							
							
						else -- NOt Special Weapon..
							
							-- Blood Splatter FX
							BloodSplatterFX(result)					
							
						end	
						
						-- Nil Stuff
						hitEnemy = nil
						hitEnemyHealth = nil


					else -- We didnt hit a Humanoid we hit a wall or other object--	
						
						----------------------------------------
						-- Gun FX for Non Flesh Hard Surfaces --
						----------------------------------------
						
						-- If we are shooting plasma weapon, use that splatter --
						if Tool.Name == "PlasmaGun" then

							-- Run Hit FX
							PlasmaGunHitFX(Player, result)
							
							-- Splash Damage and FX
							PlasmaGunSplashDamageAndFX(Player, result)							
							

						elseif Tool.Name == "VialGunPoison" then  -- Not a Plasma Weapon, Is VialGun --
							
							-- Vial Gun Poison Hit FX
							VialGunPoisonHitFX(result)						

							-- VialGun Splash Damage and FX
							VialGunPoisonSplashDamageAndFX(Player, result)
							
						elseif Tool.Name == "VialGunBasic" then
							
							-- Vial Gun Poison Hit FX
							VialGunBasicHitFX(Player, result)
							
							-- Splash Damage
							VialGunBasicSplashDamageAndFX(Player, result)
							
							
						else -- Normal Bullet Impact
							
							-- If this is the BB Gun, No FX..
							if Tool.Name == "BBGun" then
								
								-- Bullet Impact With No Impact Sprites
								BulletImpactFXHardSurface(result, false, true) -- Show Impact, PlaySounds
							else
								
								-- Wall FX
								BulletImpactFXHardSurface(result, true, true) -- Show Impact, PlaySounds							
							end							
							
						end	
						
						----------------------
						-- We Hit Satellite --
						----------------------
						
						-- If we Hit the Satellite --
						if result.Instance.Parent.Name == "Satellite" then

							-- Lower Health of satellite --
							result.Instance.Parent.Health.Value -= thisDamage
							
							-- Play Impact Sound..
							game.ReplicatedStorage.RatFleshImpactSound:FireClient(Player)

						end
					end					
				end
			end	

			-- NIl Stuff
			result = nil		
		end
	end
	
	-- Nil Stuff --
	thisDamage = nil
	gotTheKill = false
	
end)