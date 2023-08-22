-- Services --
local RunService = game:GetService("RunService")
local DebrisService = game:GetService("Debris")

-- this Object
local thisBolt = script.Parent
local arrowTrailPart = thisBolt.ArrowTrail

-- State vars
local hasGotPlayerWhoShotBolt = false
local boltExploded = false

-- Damage
local EXPLOSIVE_BLAST_DAMAGE = 160 -- Up to 240
local EXPLOSIVE_BLAST_RADIUS = 12 -- Up to 20
local EXPLOSIVE_UPGRADE_DAMAGE_INCREMENT = 20
local EXPLOSIVE_UPGRADE_RADIUS_INCREMENT = 2

---------------------------------------
-- Set network owner to the player.. --
---------------------------------------
local playerWhoShotBolt = nil

---------------
-- Functions --
---------------

-- Explosion
local function ArrowExplosionFXAndDamage()
	
	-- Get PLayer from PlayerName
	local playerTable = game.Players:GetPlayers()

	-- Ref the Player
	local thisPlayer = nil

	-- Loop Through and FInd this Player..
	for _, player in pairs(playerTable) do

		-- If this name then..
		if player.Name == script.Parent.PlayerName.Value then

			-- Set PLayer
			thisPlayer = player

			-- LEave
			break
		end
	end

	-----------------------------------
	-- Create Explosion Blast Radius --
	-----------------------------------

	-- Create Explosion to detect Blast Radius..
	local explosion = Instance.new("Explosion")
	
	-- Var
	local addedRadius = (thisPlayer.weaponlevels.crossbowexplosiveradiuslevel.Value * EXPLOSIVE_UPGRADE_RADIUS_INCREMENT) - EXPLOSIVE_UPGRADE_RADIUS_INCREMENT
	explosion.BlastRadius = EXPLOSIVE_BLAST_RADIUS + addedRadius
	addedRadius = nil

	-- Blast PRessure
	explosion.BlastPressure = 0

	-- Invisible Explosion
	explosion.Visible = true

	-- Set This to Handle Custom Humanoid Damage
	explosion.DestroyJointRadiusPercent = 0

	-- Explosion Type..
	explosion.ExplosionType = Enum.ExplosionType.NoCraters -- doesnt damage terrain

	-- Position of Explosion..
	explosion.Position = thisBolt.Position

	-- Put Explosioj Into Workspace
	explosion.Parent = game.Workspace

	-- Check for Event.HIT
	explosion.Hit:Connect(function(part, distance)

		-- Did we hit a humanoid?
		if part.Parent:FindFirstChild("Humanoid") then
			
			-- If the humanoid is still alive..
			if part.Parent.Humanoid.Health > 0 then
				
				-- If it was a rat..
				if part.Parent.Name == "Rat" or part.Parent.Name == "RatKing" or part.Parent.Name == "RatAlbino" or part.Parent.Name == "RatAlbinoMinion" then										

					-- Only Do Damage if we hit its HRP..
					if part == part.Parent.PrimaryPart then

						-- Get Force Direction
						local forceDirection = (part.Parent.PrimaryPart.Position - explosion.Position).Unit

						-- Apply Force impulse
						part.Parent.PrimaryPart:ApplyImpulse(forceDirection * 66 * part.Parent.PrimaryPart.AssemblyMass)

						-- Make Rats Black --
						if part.Parent.Name == "Rat" then
							part.Parent.BackTailBase.Color = Color3.fromRGB(33, 33, 33)
							part.Parent.BackTorso.Color = Color3.fromRGB(33, 33, 33)						
							part.Parent.FrontTailBase.Color = Color3.fromRGB(33, 33, 33)						
							part.Parent.Head.Color = Color3.fromRGB(33, 33, 33)						
							part.Parent.MiddleTorso.Color = Color3.fromRGB(33, 33, 33)
							part.Parent.Neck.Color = Color3.fromRGB(33, 33, 33)
							part.Parent.Nose.Color = Color3.fromRGB(33, 33, 33)						
							part.Parent.NoseTip.Color = Color3.fromRGB(33, 33, 33)
							part.Parent.Torso.Color = Color3.fromRGB(33, 33, 33)							
						elseif part.Parent.Name == "RatAlbino" or part.Parent.Name == "RatAlbinoMinion" then
							part.Parent.BackTailBase.Color = Color3.fromRGB(66, 66, 66)
							part.Parent.BackTorso.Color = Color3.fromRGB(66, 66, 66)						
							part.Parent.FrontTailBase.Color = Color3.fromRGB(66, 66, 66)						
							part.Parent.Head.Color = Color3.fromRGB(66, 66, 66)						
							part.Parent.MiddleTorso.Color = Color3.fromRGB(66, 66, 66)
							part.Parent.Neck.Color = Color3.fromRGB(66, 66, 66)
							part.Parent.Nose.Color = Color3.fromRGB(66, 66, 66)						
							part.Parent.NoseTip.Color = Color3.fromRGB(66, 66, 66)
							part.Parent.Torso.Color = Color3.fromRGB(66, 66, 66)							
						end

						-- Play Hit Sound attached to enemy --
						game.ReplicatedStorage.RatFleshImpactSound:FireClient(thisPlayer)

						-- Damage Humanoid..
						local hitEnemyHealth = part.Parent.Humanoid.Health				

						-- If enemy is not already dead --
						if hitEnemyHealth > 0 then
							
							-- Get Damage Mult
							local addedDamage = (thisPlayer.weaponlevels.crossbowexplosivedamagelevel.Value * EXPLOSIVE_UPGRADE_DAMAGE_INCREMENT) - EXPLOSIVE_UPGRADE_DAMAGE_INCREMENT

							-- Determine the Damage this Rat will take based on distance..
							local slope = (0 - (EXPLOSIVE_BLAST_DAMAGE + addedDamage)) / EXPLOSIVE_BLAST_RADIUS
							local damageTaken = (slope * distance) + (EXPLOSIVE_BLAST_DAMAGE + addedDamage)

							-- Is this player going to die on this hit.. ? --
							if hitEnemyHealth - damageTaken <= 0 then

								-- Do the Damage! --
								part.Parent.Humanoid.Health -= damageTaken

								-- Give PLayer a Stat --
								thisPlayer.leaderstats.ratskilled.Value = thisPlayer.leaderstats.ratskilled.Value + 1

								-- If it was an albino Rat..
								if part.Parent.Name == "RatAlbino" or part.Parent.Name == "RatAlbinoMinion" then											
									-- 3 Blood
									thisPlayer.blood.Value += 10										
								elseif part.Parent.Name == "RatKing" then											

									-- 100 Blood for RatKing
									thisPlayer.blood.Value += 100											
								else
									-- 1 Blood for regular Rat..
									thisPlayer.blood.Value += 1										
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
		end
	end)	
end

----------------
-- Connections--
----------------

-- What the Bolt touches..
thisBolt.Touched:Connect(function(part)
	
	-- Only if bolt is not already Anchored
	if boltExploded == false then
		
		-- Dont Stop for Player or Crossbow
		if part.Parent.Name == "CrossbowExplosive" or part.Parent.Parent.Name == "CrossbowExplosive" or part.Parent.Name == thisBolt.PlayerName.Value or part.Parent.Parent.Name == thisBolt.PlayerName.Value or part.CollisionGroup == "Triggers" then

			-- Leave Function
			return

		else
			-- Bolt Stuck in Rat
			boltExploded = true
			
			-- Anchor It..
			thisBolt.Anchored = true
			thisBolt.Explosive.Anchored = true

			-- Bolt can no longer collide
			thisBolt.CanCollide = false
			thisBolt.Explosive.CanCollide = false
			
			-- Make bolt Invisible
			thisBolt.Transparency = 1
			thisBolt.Explosive.Transparency = 1
			
			-- Stop Emitting
			arrowTrailPart.Trail.Enabled = false
			
			-- Play Explosion Sound
			thisBolt.Explode:Play()
			
			-- Create Explosion..
			ArrowExplosionFXAndDamage()

			-- Destroy thre Arrow
			DebrisService:AddItem(thisBolt, 3)

		end	
	end	
end)

-- Main while Loop..
while boltExploded == false do
	
	-- Keep Arrow Facing Velocity Direction
	thisBolt.CFrame = CFrame.new(thisBolt.CFrame.Position, thisBolt.Velocity + thisBolt.Position)
	
	-- Wait
	task.wait()
end