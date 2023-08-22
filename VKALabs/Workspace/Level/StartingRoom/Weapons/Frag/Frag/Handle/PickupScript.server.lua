-- Vars --
local thisTool = script.Parent.Parent
local thisHandle = thisTool.Handle
local proxPrompt = script.Parent:WaitForChild("ProximityPrompt")

-- Vars --
local toolInBackpack = false

-- Keep TouchInterest Deleted --
local touchInterest = script.Parent:WaitForChild("TouchInterest")
touchInterest:Destroy()

-- events --
proxPrompt.Triggered:Connect(function(player)
	
	-- Check if player has enough skulls to pickup --
	if player.leaderstats.skulls.Value >= 5 then
		
		----------------------
		-- Get Player Tools --
		----------------------

		local playerTools = player.Backpack:GetChildren()

		-- Add Tool in Hand as well
		for _, v in pairs(player.Character:GetChildren()) do

			-- If its a tool
			if v:IsA("Tool") then

				-- Add it to the player tools
				table.insert(playerTools, v)
			end
		end

		----------------------------------------------
		-- Now Make sure we dont have more than 3.. --
		----------------------------------------------

		local numFrags = 0

		-- Loop Through
		for _, tool in pairs(playerTools) do

			-- If its a cheese..
			if tool.Name == "Frag" then

				-- Add
				numFrags += 1
			end
		end

		-- Check if player has enough skulls to pickup --
		if numFrags < 3 then

			-- clone the gun so every player cam have one --
			local clone =  game.ServerStorage.Tools.Frag:Clone()

			-- If Pistol was picked up... add it as child to the player
			clone.Parent = player:WaitForChild("Backpack")

			-- Nil Stuff
			clone = nil

			-- Play Pickup Sound
			game.ReplicatedStorage.GunPickupSound:FireClient(player)

		else

			-- Update GUI
			game.ReplicatedStorage.SendPlayerHUDMessage:FireClient(player, "Can't carry anymore!")
		end	

		-- Nil Stuff
		playerTools = nil
		numFrags = nil
		
	else
		
		-- Update GUI
		game.ReplicatedStorage.SendPlayerHUDMessage:FireClient(player, "Find more skulls!")
		
	end	
end)


