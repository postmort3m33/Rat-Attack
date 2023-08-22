-- Services..
local DebrisService = game:GetService("Debris")

-- Objects --
local emitter = script.Parent:WaitForChild("Fire")
emitter.Enabled = true -- Enable it
local ratHumanoid = nil
local playerWhoFired = nil

-- Constants
local FIRE_DAMAGE = 50
local FIRE_UPGRADE_DAMAGE_INCREMENT = 20
local FIRE_DAMAGE_LENGTH = 3
local addedDamage = 0

-- State Vars
local ratBurning = true
local gotHumanoid = false
local gotPlayerWhoFired = false

-- Damage Vars
local damageInterval = 0.66
local lastDamage = time()

-- Play the Sizzle Sound just once
script.Parent.Sizzle:Play()

-- Loop That Damages Rat..
while ratBurning do
	
	-- If we havent got the player..
	if gotPlayerWhoFired == false then
		
		-- Get PLayer from PlayerName
		local playerTable = game.Players:GetPlayers()

		-- Loop Through and FInd this Player..
		for _, player in pairs(playerTable) do

			-- If this name then..
			if player.Name == script.Parent.PlayerName.Value then

				-- Set PLayer
				playerWhoFired = player
				
				-- Now its true
				gotPlayerWhoFired = true
				
				-- Detemrine Final Damage
				addedDamage = (playerWhoFired.weaponlevels.flamethrowerdamagelevel.Value * FIRE_UPGRADE_DAMAGE_INCREMENT) - FIRE_UPGRADE_DAMAGE_INCREMENT

				-- LEave
				break
			end
		end
		
		
		-- Nil Stuff
		playerTable = nil
	end	
	
	-- Get Humanoid..
	if gotHumanoid == false then
		
		-- Got Humanoid
		gotHumanoid = true
		
		-- Set Humanoid
		ratHumanoid = script.Parent.Parent.Parent:WaitForChild("Humanoid")
	end
	
	-- Do Damage
	if ratHumanoid and gotPlayerWhoFired then
		
		-- If he still has health..
		if ratHumanoid.Health > 0 then
			
			-- Only Burn for FireDamageLength
			local burnTimerCoroutine = coroutine.wrap(function()
				
				-- Wait for the timer..
				task.wait(FIRE_DAMAGE_LENGTH)
				
				-- Destroy this Emitter if the rat is not dead yet..
				if ratHumanoid.Health > 0 then
					
					-- Destroy It
					script.Parent:Destroy()
				end				
				
			end)()
			
			-- Do Damage Over Time..
			if (time() - lastDamage) >= damageInterval then
				
				-- Set Last Damage
				lastDamage = time()

				-- Do Damage
				ratHumanoid.Health -= FIRE_DAMAGE + addedDamage
				
				-- Play Sound on Cline
				game.ReplicatedStorage.RatFleshImpactSound:FireClient(playerWhoFired)
			end
			
		else -- Rat Died..
			
			-- Give PLayer a Stat --
			playerWhoFired.leaderstats.ratskilled.Value = playerWhoFired.leaderstats.ratskilled.Value + 1

			-- If it was an albino Rat..
			if script.Parent.Parent.Parent.Name == "RatAlbino" or script.Parent.Parent.Parent.Name == "RatAlbinoMinion" then											
				-- 3 Blood
				playerWhoFired.blood.Value += 10									
			elseif script.Parent.Parent.Parent.Name == "RatKing" then											

				-- 100 Blood for RatKing
				playerWhoFired.blood.Value += 100											
			else
				-- 1 Blood for regular Rat..
				playerWhoFired.blood.Value += 1										
			end
			
			-- Rat is done burning..
			ratBurning = false
		end		
	end
	
	-- Wait
	task.wait()
end

-- Wait 3 seconds..
task.wait(2)

-- Turn off Emitter..
emitter.Enabled = false

-- Debris
DebrisService:AddItem(script.Parent, 5)

