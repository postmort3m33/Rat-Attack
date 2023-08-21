-- Vars --
local thisPart = script.Parent
local proxPrompt = script.Parent:WaitForChild("ProximityPrompt")

-- Connections --
proxPrompt.Triggered:Connect(function(player)

	-- clone the gun so every player cam have one --
	local clone =  game.ServerStorage.Tools.EasterEggParts.Fuse:Clone()

	-- If Pistol was picked up... add it as child to the player
	clone.Parent = player:WaitForChild("Backpack")

	-- Nil Stuff
	clone = nil
	
	-- Play Pickup Sound
	game.ReplicatedStorage.GunPickupSound:FireClient(player)
	
	-- Destroy
	thisPart:Destroy()
	
end)


