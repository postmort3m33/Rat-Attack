-- Vars --
local thisProx = script.Parent.Top.ProximityPrompt

-- Sounds
local anvilHitSound = script.Parent.Top.AnvilHit

-----------------
-- connections --
-----------------

-- Prox Connection --
thisProx.Triggered:Connect(function(player)
	
	-- Reset tool in Backpack
	local hasVialGunBasic = false
	local hasVialWithPoison = false
	local vialGunBasicTool = nil
	local vialWithPoisonTool = nil
	
	-- PLayer Backpack
	local playerBackpack = player:WaitForChild("Backpack")

	-- Loop through Backpack --
	for _, tool in pairs(playerBackpack:GetChildren()) do

		-- If we find this tool, dont attack --
		if tool.Name == "VialGunBasic" and not hasVialGunBasic then

			-- fonud Tool --
			hasVialGunBasic = true
			
			-- Set Tool
			vialGunBasicTool = tool

			-- Break
			continue
		end
		
		-- check for Vial with Poison..
		if tool.Name == "VialWithPoison" and not hasVialWithPoison then
			
			-- Vial Found
			hasVialWithPoison = true
			
			-- Set Tool
			vialWithPoisonTool = tool
			
			-- Break
			continue
		end
	end

	-- Loop Through Player Childen that our tools..
	for _, child in pairs(player.Character:GetChildren()) do

		-- If its a tool..--
		if child:IsA("Tool") then

			-- check if its this tool--
			if child.Name == "VialGunBasic" and not hasVialGunBasic then

				-- Found Tool --
				hasVialGunBasic = true
				
				-- Set Tool
				vialGunBasicTool = child

				-- break
				continue
			end
			
			-- check for Vial with Poison..
			if child.Name == "VialWithPoison" and not hasVialWithPoison then

				-- Vial Found
				hasVialWithPoison = true
				
				-- Set Tool
				vialWithPoisonTool = child

				-- Break
				continue
			end			
			
		end
	end

	-- If Tool was not found, clone a new one.. --
	if hasVialGunBasic and hasVialWithPoison then
		
		-- Destroy Parts
		vialWithPoisonTool:Destroy()
		vialGunBasicTool:Destroy()
		
		-- Play Sound
		anvilHitSound:Play()
		task.wait(.33)
		anvilHitSound:Play()
		task.wait(.33)
		anvilHitSound:Play()

		-- clone the gun so every player cam have one --
		local clone =  game.ServerStorage.Tools.VialGunPoison:Clone()

		-- If Pistol was picked up... add it as child to the player
		clone.Parent = player:WaitForChild("Backpack")

		-- Fire Event to PLay Sound --
		game.ReplicatedStorage.DingSound:FireAllClients()

		-- Nil Stuff
		clone = nil

	else
		
		-- Does not have proper items..
		game.ReplicatedStorage.SendPlayerHUDMessage:FireClient(player, "You need the right items!")
		
	end	
	
end)

