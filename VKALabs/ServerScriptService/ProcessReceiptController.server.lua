-- Services
local MarketplaceService = game:GetService("MarketplaceService")

-- Product IDS
local vialWithBloodID = 1365597254
local gameOverLivesPackageID = 1365626009

---------------
-- Functions --
---------------

-- Process Receipt..
local function ProcessReceipt(receiptInfo)
	
	-- Get Player..
	local player = game.Players:GetPlayerByUserId(receiptInfo.PlayerId)
	
	-- If PLayer Doesnt Exist.. Purchase Didnt Process..
	if not player then
		
		-- Return Not Processed
		return Enum.ProductPurchaseDecision.NotProcessedYet

	elseif player then
		
		-- Determine which product was purchased..
		if receiptInfo.ProductId == vialWithBloodID then
			
			-- Give Player the blood..
			local clone = game.ServerStorage.Tools.EasterEggParts.VialWithBlood:Clone()

			-- Put in Players Backpack
			clone.Parent = player:WaitForChild("Backpack")

			-- Nil
			clone = nil
			
			-- Play Local sound
			game.ReplicatedStorage.PlayLocalSound:FireClient(player, "BloodExchange")
			
		elseif receiptInfo.ProductId == gameOverLivesPackageID then
			
			-- Give Player 6 More Lives
			player.lives.Value += 6
			
			-- PLay Ding Sound
			game.ReplicatedStorage.DingSound:FireClient(player)
			
			-- Wait
			task.wait(1)
			
			-- Move Player to Starting Room..
			if player.Character then
				
				-- move Player to weapons room..
				player.Character.PrimaryPart.CFrame = workspace.GameSpawn.CFrame * CFrame.new(math.random(-20,20), 3 , math.random(-20,20))
				
			end			
		end
		
		-- Purchase was granted..
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end
end

-- Process Receipt Connection..
MarketplaceService.ProcessReceipt = ProcessReceipt