-- Vars --
local thisVial = script.Parent
local proxPrompt = script.Parent:WaitForChild("ProximityPrompt")

-- Services --
local PlayerService = game:GetService("Players")

-- Players who have picked up Skull --
local playersWhoHaveVial = {}
local playerHasVial = false

---------------
-- Functions --
---------------

function GiveVial(player)
	
	-- Play Sound Locally --
	game.ReplicatedStorage.SkullPickupSound:FireClient(player)
	
	-- Now Add This player to the List of players --
	table.insert(playersWhoHaveVial, player)
	
	-- Give Player Random Blood..
	player.blood.Value += math.random(50,300)
end

-----------------
-- Connections --
-----------------

-- When a Player Leaves, delete him from the table --
PlayerService.PlayerRemoving:Connect(function(player)
	
	-- If this player had this skull.. --
	if table.find(playersWhoHaveVial, player) then
		
		-- Set index
		local index = table.find(playersWhoHaveVial, player)
		
		-- Remove them from the table
		table.remove(playersWhoHaveVial, index)	
		
		-- Nil Stuff
		index = nil
	end	
end)

-- When this skull is picked up.. --
proxPrompt.Triggered:Connect(function(player)
	
	-- reset player has skull
	playerHasVial = false

	---------------------------------------------------
	-- If table is empty, Give Skull to first player --
	---------------------------------------------------

	-- Check for first time empty Loop First --
	if #playersWhoHaveVial == 0 then

		-- Give Skull --
		GiveVial(player)
	else

		----------------------------
		-- Main Skull Table check --
		----------------------------

		-- If Table already exists, check if player requesting skull already has it..
		for _, v in pairs(playersWhoHaveVial) do

			-- If This player already has this skull, then break loop --
			if player == v then

				-- This player has a skull already --
				playerHasVial = true

				-- Send Message to HUD
				game.ReplicatedStorage.SendPlayerHUDMessage:FireClient(player, "You already got this!")
			end				
		end	

		-------------------------------------------
		-- Give Player Skull if he didnt have it --
		-------------------------------------------

		-- If the player did not have the skul yet, give it to them.. --
		if playerHasVial == false then

			-- Give Skull --
			GiveVial(player)

		end

	end
end)