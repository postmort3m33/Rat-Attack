-- Services
local MarketplaceService = game:GetService("MarketplaceService")

-- Vars --
local thisTool = script.Parent.Parent
local thisHandle = thisTool.Handle
local proxPrompt = script.Parent:WaitForChild("ProximityPrompt")

-- Pass ID
local gamePassID = 127349614

-- Vars --
local toolInBackpack = false

-- Keep TouchInterest Deleted --
local touchInterest = script.Parent:WaitForChild("TouchInterest")
touchInterest:Destroy()

-- events --
proxPrompt.Triggered:Connect(function(player)

	-- Vars...
	local hasPass = false

	-- Check if PLayer has this pass already..
	local success, message = pcall(function()

		-- Set HasPass
		hasPass = MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamePassID)

	end)

	-- If Pass Check Failed..
	if not success then

		-- Warn..
		game.ReplicatedStorage.SendPlayerHUDMessage:FireClient(player, "Error while checking for GamePass..")

		-- Leave
		return
	end

	-- If Player already had pass..
	if hasPass then

		----------------------------
		-- Give player the weapon --
		----------------------------

		-- Reset tool in Backpack
		toolInBackpack = false

		-- Loop through Backpack --
		for _, tool in pairs(player.Backpack:GetChildren()) do

			-- If we find this tool, dont attack --
			if tool.Name == thisTool.Name then

				-- fonud Tool --
				toolInBackpack = true

				-- Break
				break
			end
		end

		-- Loop Through Player Childen that our tools..
		for _, child in pairs(player.Character:GetChildren()) do

			-- If its a tool..--
			if child:IsA("Tool") then

				-- check if its this tool--
				if child.Name == thisTool.Name then

					-- Found Tool --
					toolInBackpack = true

					-- break
					break
				end
			end
		end

		-- If Tool was not found, clone a new one.. --
		if toolInBackpack == false then

			-- clone the gun so every player cam have one --
			local clone =  game.ServerStorage.Tools.CrossbowExplosive:Clone()

			-- If Pistol was picked up... add it as child to the player
			clone.Parent = player:WaitForChild("Backpack")

			-- Nil Stuff
			clone = nil

			-- Play Pickup Sound
			game.ReplicatedStorage.GunPickupSound:FireClient(player)

		else -- PLayer Had Tool Already

			-- Send HUD MEssage
			game.ReplicatedStorage.SendPlayerHUDMessage:FireClient(player, "You already have this weapon!")
		end

	else

		-- Prompt For Purchase
		game.ReplicatedStorage.PromptGamePassPurchaseSTC:FireClient(player, gamePassID)

	end

	-- Nil Stuff
	hasPass = nil
end)


