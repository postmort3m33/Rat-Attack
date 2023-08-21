-- Vars
local proxPrompt = script.Parent.TVScreen.Screen:WaitForChild("ProximityPrompt")

-- Purchase Stuff
local gameOverLivesPackageID = 1365626009

---------------
-- Functions --
---------------

-- events --
proxPrompt.Triggered:Connect(function(player)
	
	-- Prompt Player..
	game.ReplicatedStorage.PromptDevItemPurchaseSTC:FireClient(player, gameOverLivesPackageID)
	
end)




