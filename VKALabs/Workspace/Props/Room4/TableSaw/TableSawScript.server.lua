-- Prox Prompts --
local installSawBladePrompt = script.Parent.HiddenSawBlade.ProximityPrompt
local useSawProxPrompt = script.Parent.TableSaw.TopMiddle.ProximityPrompt
local getBatteryAcidPrompt = script.Parent.BrokenBattery.Battery.ProximityPrompt

-- Local Vars
local playerHasSawBlade = false
local playerSawBladeTool = nil

-- Sounds
local anvilHitSound = script.Parent.HiddenSawBlade.AnvilHit
local sawCutSound = script.Parent.TableSaw.SawCut

----------
-- Init --
----------

-- Turn on Prox Prompt
installSawBladePrompt.Enabled = true

-----------------
-- Connections --
-----------------

-- Prox Prompt
installSawBladePrompt.Triggered:Connect(function(player)
	
	-- Reset tool in Backpack
	playerHasSawBlade = false

	-- Loop Through Player Childen that our tools..
	for _, child in pairs(player.Character:GetChildren()) do

		-- If its a tool..--
		if child:IsA("Tool") then

			-- check if its this tool--
			if child.Name == "SawBlade" then

				-- Found Tool --
				playerHasSawBlade = true

				-- Set this Propane Tank
				playerSawBladeTool = child

				-- break
				break
			end
		end
	end

	-- IF Player had the tank in hand, then place it.. --
	if playerHasSawBlade then
		
		-- Take tank from player..
		playerSawBladeTool:Destroy()
		
		-- Play Sound
		anvilHitSound:Play()
		task.wait(.33)
		anvilHitSound:Play()
		task.wait(.33)
		anvilHitSound:Play()

		-- Turn off Prox Prompt
		installSawBladePrompt.Enabled = false
		
		-- Make Saw Blade Appear
		script.Parent.HiddenSawBlade.Transparency = 0
		
		-- Objective Complete..
		game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(20)
		
		-- Wait
		task.wait(0.5)
		
		-- Enable Use Saw Prox Prompt
		useSawProxPrompt.Enabled = true

	end		
end)

-- Use Saw Prox Prompt
useSawProxPrompt.Triggered:Connect(function(player)
	
	-- PLayer has Battery
	local playerHasBattery = false
	local playerBatteryTool = nil
	
	-- Loop Through Player Childen that our tools..
	for _, child in pairs(player.Character:GetChildren()) do

		-- If its a tool..--
		if child:IsA("Tool") then

			-- check if its this tool--
			if child.Name == "Battery" then

				-- Found Tool --
				playerHasBattery = true

				-- Set this Propane Tank
				playerBatteryTool = child

				-- break
				break
			end
		end
	end
	
	-- If they had the battery in hand..
	if playerHasBattery then
		
		-- Disable Table Prox Prompt
		useSawProxPrompt.Enabled = false
		
		-- Destroy Battery in Hand
		playerBatteryTool:Destroy()
		
		-- Run Saw Blade Sound
		sawCutSound:Play()
		
		-- Wait
		task.wait(1)
		
		-- Make Open Battery Appear
		script.Parent.BrokenBattery.Battery.Transparency = 0
		script.Parent.BrokenBattery.Bottom.Transparency = 0
		script.Parent.BrokenBattery.Acid.Transparency = 0
		
		-- Enable battery Acid Prompt
		getBatteryAcidPrompt.Enabled = true

	end
end)

-- Get Battery acid Prompt
getBatteryAcidPrompt.Triggered:Connect(function(player)
	
	-- PLayer has Battery
	local playerHasVialEmpty = false
	local playerVialEmptyTool = nil
	
	-- Loop Through Player Childen that our tools..
	for _, child in pairs(player.Character:GetChildren()) do

		-- If its a tool..--
		if child:IsA("Tool") then

			-- check if its this tool--
			if child.Name == "VialEmpty" then

				-- Found Tool --
				playerHasVialEmpty = true

				-- Set this Propane Tank
				playerVialEmptyTool = child

				-- break
				break
			end
		end
	end
	
	-- If they had the battery in hand..
	if playerHasVialEmpty then
		
		-- Disable Table Prox Prompt
		getBatteryAcidPrompt.Enabled = false
		
		-- Destroy Battery in Hand
		playerVialEmptyTool:Destroy()
		
		-- Give Player Vial with Acid
		local clone = game.ServerStorage.Tools.EasterEggParts.VialWithAcid:Clone()
		
		-- Parent
		clone.Parent = player:WaitForChild("Backpack")
		
		-- Nil Stuff
		clone = nil
		
		-- Play Local sound
		game.ReplicatedStorage.PlayLocalSound:FireClient(player, "BloodExchange")
		
		-- Objective Complete..
		game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(21)
	end
end)
