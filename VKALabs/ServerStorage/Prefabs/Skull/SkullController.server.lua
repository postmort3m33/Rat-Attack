-- Vars --
local thisSkull = script.Parent
local pickupProximityPrompt = script.Parent:WaitForChild("ProximityPrompt")

-- Services --
local PlayerService = game:GetService("Players")

-- Players who have picked up Skull --
local playersWhoHaveSkull = {}
local playerHasSkull = false

-- Proximity Trigger is Ready Var --
local proxTriggerIsReady = true

---------------
-- Functions --
---------------

function GiveSkull(player)
	
	-- Play Sound Locally --
	game.ReplicatedStorage.SkullPickupSound:FireClient(player)
	
	-- Give Playerr this Skull
	player.leaderstats.skulls.Value = player.leaderstats.skulls.Value + 1
	
	-- Now Add This player to the List of players --
	table.insert(playersWhoHaveSkull, player)
end

-----------------
-- Connections --
-----------------

-- When a Player Leaves, delete him from the table --
PlayerService.PlayerRemoving:Connect(function(player)
	
	-- If this player had this skull.. --
	if table.find(playersWhoHaveSkull, player) then
		
		-- Set index
		local index = table.find(playersWhoHaveSkull, player)
		
		-- Remove them from the table
		table.remove(playersWhoHaveSkull, index)	
		
		-- Nil Stuff
		index = nil
	end	
end)

-- When this skull is picked up.. --
pickupProximityPrompt.Triggered:Connect(function(player)
	
	-- Only fire function if the last one is finished --
	if proxTriggerIsReady then
		
		-- Prox not ready now --
		proxTriggerIsReady = false
		
		-- reset player has skull
		playerHasSkull = false
		
		---------------------------------------------------
		-- If table is empty, Give Skull to first player --
		---------------------------------------------------
		
		-- Check for first time empty Loop First --
		if #playersWhoHaveSkull == 0 then

			-- Give Skull --
			GiveSkull(player)
		else
			
			----------------------------
			-- Main Skull Table check --
			----------------------------

			-- If Table already exists, check if player requesting skull already has it..
			for _, v in pairs(playersWhoHaveSkull) do

				-- If This player already has this skull, then break loop --
				if player == v then

					-- This player has a skull already --
					playerHasSkull = true

					-- Send Message to HUD
					game.ReplicatedStorage.SendPlayerHUDMessage:FireClient(player, "You already have this skull!")
				end				
			end	
			
			-------------------------------------------
			-- Give Player Skull if he didnt have it --
			-------------------------------------------

			-- If the player did not have the skul yet, give it to them.. --
			if playerHasSkull == false then

				-- Give Skull --
				GiveSkull(player)

			end
			
		end	
		
		-- Now Prox trigger is ready again --
		proxTriggerIsReady = true	
		
	end	
end)