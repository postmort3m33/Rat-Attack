-- Services --
local RunService = game:GetService("RunService")
local DebrisService = game:GetService("Debris")

-- Object
local thisObject = script.Parent

-- Event Vars --
local fragEventStarted = false
local fragTime = 2.5

-- Damage
local FRAG_BLAST_DAMAGE = 400
local FRAG_BLAST_RADIUS = 25

---------------
-- Functions --
---------------

-- Explode
local function FragExplode()
	
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
	
	-- Explosion Sound --
	script.Parent.Explode:Play()
	
	-----------------------------------
	-- Create Explosion Blast Radius --
	-----------------------------------

	-- Create Explosion to detect Blast Radius..
	local explosion = Instance.new("Explosion")

	-- Radius..
	explosion.BlastRadius = FRAG_BLAST_RADIUS

	-- Blast PRessure
	explosion.BlastPressure = 0

	-- Invisible Explosion
	explosion.Visible = true

	-- Set This to Handle Custom Humanoid Damage
	explosion.DestroyJointRadiusPercent = 0

	-- Explosion Type..
	explosion.ExplosionType = Enum.ExplosionType.NoCraters -- doesnt damage terrain

	-- Position of Explosion..
	explosion.Position = thisObject.Position

	-- Put Explosioj Into Workspace
	explosion.Parent = game.Workspace

	-- Check for Event.HIT
	explosion.Hit:Connect(function(part, distance)

		-- Did we hit a humanoid?
		if part.Parent:FindFirstChild("Humanoid") then
			
			-- If rat is still alive..
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

							-- Determine the Damage this Rat will take based on distance..
							local slope = (0 - FRAG_BLAST_DAMAGE) / FRAG_BLAST_RADIUS
							local damageTaken = (slope * distance) + FRAG_BLAST_DAMAGE	

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
						end

						-- Nil Stuff
						hitEnemyHealth = nil

					end									
				end				
			end											
		end
	end)
end

-- Run Heartbeat Loop --
RunService.Heartbeat:Connect(function()
	
	-- Wait Frag Time --
	if fragEventStarted == false then		

		-- Event Fired
		fragEventStarted = true
		
		-- Play Pull Pin..
		script.Parent.PullPin:Play()
		
		-- Play Throw Sound
		script.Parent.Throw:Play()

		-- Wait Frag Time
		task.wait(fragTime)

		-- Explode..
		FragExplode()

		-- Make Grenade Dissapear
		thisObject.Transparency = 1

		-- Destroy
		DebrisService:AddItem(thisObject, 3)
	end	
end)
