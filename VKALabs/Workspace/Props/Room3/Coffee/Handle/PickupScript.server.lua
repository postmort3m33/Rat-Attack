-- Vars --
local proxPrompt = script.Parent.ProximityPrompt
local thisTool = script.Parent.Parent
local thisHandle = thisTool.Handle

-- Vars --
local toolInBackpack = false

-- Keep TouchInterest Deleted --
local touchInterest = script.Parent:WaitForChild("TouchInterest")
touchInterest:Destroy()

-- events --
proxPrompt.Triggered:Connect(function(player)
	
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

	local numCoffees = 0

	-- Loop Through
	for _, tool in pairs(playerTools) do

		-- If its a cheese..
		if tool.Name == "Coffee" then

			-- Add
			numCoffees += 1
		end
	end

	-- If its more than 3, exit with message..
	if numCoffees < 3 then
		
		-- clone the gun so every player cam have one --
		local clone =  game.ServerStorage.Tools.Coffee:Clone()

		-- If Pistol was picked up... add it as child to the player
		clone.Parent = player:WaitForChild("Backpack")

		-- Nil Stuff
		clone = nil
		
		-- Play Pickup Sound
		game.ReplicatedStorage.GunPickupSound:FireClient(player)
		
	else

		-- Send Message
		game.ReplicatedStorage.SendPlayerHUDMessage:FireClient(player, "Cant carry anymore!")
	end

	-- Nil Stuff
	playerTools = nil
	numCoffees = nil
	
end)


