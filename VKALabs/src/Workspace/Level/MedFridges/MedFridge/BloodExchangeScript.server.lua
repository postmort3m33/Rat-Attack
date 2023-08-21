-- Objects
local thisProx = script.Parent.Body.ProximityPrompt

-- Vars
local bloodPerVial = 50

-- Connections
thisProx.Triggered:Connect(function(player)
	
	-- check if player has enough blood
	if player.blood.Value >= bloodPerVial then
		
		-- Give Player a Vial of blood
		local clone = game.ServerStorage.Tools.EasterEggParts.VialWithBlood:Clone()

		-- Put in Players Backpack
		clone.Parent = player:WaitForChild("Backpack")
		
		-- Nil
		clone = nil
		
		-- take Blood from player..
		player.blood.Value -= bloodPerVial
		
		-- Play Local sound
		game.ReplicatedStorage.PlayLocalSound:FireClient(player, "BloodExchange")
		
	else
		
		-- Not Enough Blood
		game.ReplicatedStorage.SendPlayerHUDMessage:FireClient(player, "You need at least 50 mL of Blood to fill a Vial!")
	end
	
end)
