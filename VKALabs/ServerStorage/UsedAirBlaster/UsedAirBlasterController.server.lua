-- this Object
local thisAirBlaster = script.Parent

-- Player
local playerWhoShotString = nil
local playerWhoShot = nil
local gotPlayerWhoShot = false

-- Damage Stuff
local STARTING_POWER = 27 -- Max 39
local STARTING_DAMAGE = 17 -- Max 29
local POWER_UPGRADE_INCREMENT = 3
local DAMAGE_UPGRADE_INCREMENT = 3

----------------
-- Connections--
----------------

-- What the Bolt touches..
thisAirBlaster.Touched:Connect(function(part)

	-- Wait for Player who shot to be determined..
	task.wait()
	
	-- If the Part has a parent..
	if part.Parent then
		
		-- Did we hit a humanoid..
		if part.Parent:FindFirstChild("Humanoid") then

			-- If its still alive..
			if part.Parent.Humanoid.Health > 0 then

				-- Make sure its a rat..
				if part.Parent.Name == "Rat" or part.Parent.Name == "RatKing" or part.Parent.Name == "RatAlbino" or part.Parent.Name == "RatAlbinoMinion" then

					-- Make sure we only do this once per rat..
					if part == part.Parent.PrimaryPart then

						-- Wait for Player Who Shot.. (Just Incase Server Is Lagging..)
						while not playerWhoShot do task.wait() end

						--------------------------
						-- Determine Push Force --
						--------------------------

						local addedPower = (playerWhoShot.weaponlevels.airblasterpowerlevel.Value * POWER_UPGRADE_INCREMENT) - POWER_UPGRADE_INCREMENT
						local finalPower = STARTING_POWER + addedPower

						-- Triangle Shit..
						local direction = part.Position - thisAirBlaster.SpawnPosition.Value
						local distance = direction.Magnitude

						-- Determine Force To Push Back..
						local velocity = math.sqrt(finalPower - distance) * 200
						if not (velocity > 0) then velocity = 0 end

						local assemblyVel = thisAirBlaster.AssemblyLinearVelocity.Unit
						local newVel = Vector3.new(assemblyVel.X, (-assemblyVel.Y * 0.5) , assemblyVel.Z)

						-- Apply Impulse to Hit Rats..						
						part:ApplyImpulse(newVel * velocity)

						-- Nil Stuff
						direction = nil
						assemblyVel = nil
						velocity = nil
						newVel = nil
						addedPower = nil

						---------------
						-- Do Damage --
						---------------

						--Var
						local hitEnemyHealth = part.Parent.Humanoid.Health

						-- If enemy is not already dead --
						if hitEnemyHealth > 0 then

							-- Determine Added Damage
							local addedDamage = (playerWhoShot.weaponlevels.airblasterdamagelevel.Value  * DAMAGE_UPGRADE_INCREMENT) - DAMAGE_UPGRADE_INCREMENT
							local finalDamageMultiplier = STARTING_DAMAGE + addedDamage

							-- Determine the Damage this Rat will take based on distance..
							local damageTaken = math.sqrt(finalPower - distance) * finalDamageMultiplier
							if not (damageTaken > 0) then damageTaken = 0 end

							-- Is this player going to die on this hit.. ? --
							if hitEnemyHealth - damageTaken <= 0 then

								-- Do the Damage! --
								part.Parent.Humanoid.Health -= damageTaken

								-- Give PLayer a Stat --
								playerWhoShot.leaderstats.ratskilled.Value += 1

								-- If it was an albino Rat..
								if part.Parent.Name == "RatAlbino" or part.Parent.Name == "RatAlbinoMinion" then											
									-- 3 Blood
									playerWhoShot.blood.Value += 10	

								elseif part.Parent.Name == "RatKing" then											

									-- 100 Blood for RatKing
									playerWhoShot.blood.Value += 100											
								else
									-- 1 Blood for regular Rat..
									playerWhoShot.blood.Value += 1										
								end								

							else -- Player is not going to die on this hit..

								-- Do the Damage! --
								part.Parent.Humanoid.Health -= damageTaken

							end

							-- Nil Stuff
							damageTaken = nil
						end

						-- Nil Stuff
						hitEnemyHealth = nil
					end					
				end
			end
		end	
	end	
end)

-- Touch Ended Event..
thisAirBlaster.TouchEnded:Connect(function(part)
	
	-- Wait
	task.wait()
	
	-- If its concrete.. Destroy it.
	if part.Material.Name == "Concrete" or part.Material.Name == "Glass" then
		
		-- Wait
		task.wait()
		
		-- Destroy it..
		--thisAirBlaster:Destroy()
	end
end)

-- Loop for Stuff
while gotPlayerWhoShot == false do
	
	-- Ref
	playerWhoShotString = thisAirBlaster.PlayerName.Value
	
	-- Debug
	if playerWhoShotString ~= "" then
		
		-- Get Players
		local playerTable = game.Players:GetPlayers()
		
		-- Find this player..
		for _, player in pairs(playerTable) do
			
			-- If a match
			if player.Name == playerWhoShotString then
				
				-- set Player
				playerWhoShot = player
				
				-- We got it
				gotPlayerWhoShot = true
				
				-- Break
				break
			end
		end
		
		-- Nil Stuff
		playerTable = nil
	end	
	
	-- Wait
	task.wait()
end