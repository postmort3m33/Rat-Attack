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
	
	local numEnergies = 0
	
	-- Loop Through
	for _, tool in pairs(playerTools) do
		
		-- If its a cheese..
		if tool.Name == "Energy" then
			
			-- Add
			numEnergies += 1
		end
	end
	
	-- If its more than 3, exit with message..
	if numEnergies < 3 then
		
		-- clone the gun so every player cam have one --
		local clone =  game.ServerStorage.Tools.Energy:Clone()

		-- If Pistol was picked up... add it as child to the player
		clone.Parent = player:WaitForChild("Backpack")
		
		-- Play Pickup Sound
		game.ReplicatedStorage.GunPickupSound:FireClient(player)

		-- Nil Stuff
		clone = nil		
	else
		
		-- Send Message
		game.ReplicatedStorage.SendPlayerHUDMessage:FireClient(player, "Cant carry anymore!")
	end
	
	-- Nil Stuff
	playerTools = nil
	numEnergies = nil	
	
end)


