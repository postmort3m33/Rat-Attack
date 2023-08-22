-- Object Vars
local thisObject = script.Parent
local fuseObject = script.Parent:WaitForChild("HiddenFuse")
local vialWithBloodObject = script.Parent:WaitForChild("HiddenVialWithBlood")
local switchObject = script.Parent:WaitForChild("Switch")
local tvDecal = script.Parent.TVScreen.Screen:WaitForChild("Decal")
local vialWithPoison = script.Parent.Machine:WaitForChild("VialWithPoisonPart")

-- TV Screen Ids --
local insertChemicalScreenID = "rbxassetid://11236013319"
local analyzerReadyScreen = "rbxassetid://11236044749"
local analyzingScreen = "rbxassetid://11236706569"
local analyzationFinished = "rbxassetid://11236961630"
local itemsNeededScreen = "rbxassetid://11369657553"
local mixerReadyScreen = "rbxassetid://11242884567"
local mixingScreen = "rbxassetid://11243363503"

-- Proximity Prompts
local switchProx = thisObject.Switch:WaitForChild("ProximityPrompt")
local fuseProx = thisObject.HiddenFuse:WaitForChild("ProximityPrompt")
local vialWithBloodProx = thisObject.HiddenVialWithBlood.Handle:WaitForChild("ProximityPrompt")
local leftVialHolderProx = thisObject.VialHolders.Left.MetalCasing.ProximityPrompt
local middleVialHolderProx = thisObject.VialHolders.Middle.MetalCasing.ProximityPrompt
local rightVialHolderProx = thisObject.VialHolders.Right.MetalCasing.ProximityPrompt
local vialWithPoisonProx = vialWithPoison.ProximityPrompt

-- Machine Lights --
local runningLight = thisObject:WaitForChild("RunningLight")
local powerLight = thisObject:WaitForChild("PowerLight")

-- Sounds --
local switchSound = thisObject.Switch:WaitForChild("Switch")
local machineHumSound = thisObject.Machine.Wedge:WaitForChild("MachineHum")
local computerBeepsSound = thisObject.Machine.Wedge:WaitForChild("ComputerBeeps")
local machineHumSound2 = thisObject.Machine.Wedge:WaitForChild("MachineHum2")
local machineMixingSound = thisObject.Machine.Wedge:WaitForChild("MachineMixing")

-- Local Vars --
local switchOn = false
local powerOn = false
local sampleIn = false
local ranSample = false
local allSamplesPlaced = false
local craftedThePoison = false
local vialEmptyPlaced = false
local vialWithPlasmaPlaced = false
local vialWithAcidPlaced = false

---------------
-- Functions --
---------------

-- Craft The Poison
local function CraftThePoison()
	
	-- Refs
	local vialEmptyPart = nil
	local vialWithAcidPart = nil
	local vialWithPlasmaPart = nil
	
	-- Referenc all the vials for movement..
	for _, v in pairs(script.Parent.VialHolders:GetDescendants()) do
		
		-- check for samples
		if v.name == "VialEmptyPart" then
			vialEmptyPart = v
		end
		
		if v.Name == "VialWithAcidPart" then
			vialWithAcidPart = v
		end
		
		if v.Name == "VialWithPlasmaPart" then
			vialWithPlasmaPart = v
		end
	end
	
	-- Turn Running Light On
	runningLight.BrickColor = BrickColor.new("Lime green")
	
	-- Set TV Screen
	tvDecal.Texture = mixingScreen
	
	-- PLay Samples into Machine Hum
	machineHumSound:Play()
	
	-- Tween the Samples down..
	local tweenInformation = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local tween1 = game.TweenService:Create(vialEmptyPart, tweenInformation, {["CFrame"] = vialEmptyPart.CFrame:ToWorldSpace(CFrame.new(-2, 0, 0))})
	local tween2 = game.TweenService:Create(vialWithPlasmaPart, tweenInformation, {["CFrame"] = vialWithPlasmaPart.CFrame:ToWorldSpace(CFrame.new(-2, 0, 0))})
	local tween3 = game.TweenService:Create(vialWithAcidPart, tweenInformation, {["CFrame"] = vialWithAcidPart.CFrame:ToWorldSpace(CFrame.new(-2, 0, 0))})
	tween1:Play()
	tween1.Completed:Wait()
	tween2:Play()
	tween2.Completed:Wait()
	tween3:Play()
	tween3.Completed:Wait()
	
	-- Nil Stuff
	tweenInformation = nil
	tween1 = nil
	tween2 = nil
	tween3 = nil
	
	-- Stop Machine Humn
	if machineHumSound.IsPlaying then
		-- Stop
		machineHumSound:Stop()
	end
	
	-- Make Mixing Sound..
	machineMixingSound:Play()
	machineMixingSound.Ended:Wait()
	
	---------------------
	-- Mixing Finished --
	---------------------

	-- Play Sound
	switchSound:Play()	

	-- Tween the switch up and down..
	local tweenInformation = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local tween = game.TweenService:Create(switchObject, tweenInformation, {["CFrame"] = switchObject.CFrame:ToWorldSpace(CFrame.new(0, -0.5, 0))})
	tween:Play()
	tween.Completed:Wait()
	
	-- Now Turn switch off
	switchOn = false
	
	-- Nil Stuff
	tweenInformation = nil
	tween = nil

	-- Turn running Light Off
	runningLight.Color = Color3.fromRGB(66,0,0)
	
	-- Destroy Old Samples..
	vialEmptyPart:Destroy()
	vialWithAcidPart:Destroy()
	vialWithPlasmaPart:Destroy()
	
	-- Turn on Part Highlights
	vialWithPoison.Ends.Highlight.Enabled = true
	vialWithPoison.Poison.Highlight.Enabled = true
	
	-- Spit out crafted Poison..
	local tweenInformation = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local tween = game.TweenService:Create(vialWithPoison, tweenInformation, {["CFrame"] = vialWithPoison.CFrame:ToWorldSpace(CFrame.new(0, 1, 0))})
	tween:Play()
	tween.Completed:Wait()
	
	-- Nil Stuff
	tweenInformation = nil
	tween = nil
	
	-- Enable the Prox to Pick it Up
	vialWithPoisonProx.Enabled = true
	
	-- Mission Stuff
	game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(7)
	
	-- Set Screen
	tvDecal.Texture = insertChemicalScreenID	
	
end

--------------------------------
-- Prox Triggered Connections --
--------------------------------

-- Switch Prox --
switchProx.Triggered:Connect(function()
	
	-- Play Sound
	switchSound:Play()

	-- If switch is off..
	if switchOn == false then

		-- Now switch is off
		switchOn = true
		
		-- Turn off switch Prox Prompt while we analyze..
		switchProx.Enabled = false

		-- Tween the switch UP
		local tweenInformation = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
		local tween = game.TweenService:Create(switchObject, tweenInformation, {["CFrame"] = switchObject.CFrame:ToWorldSpace(CFrame.new(0, 0.5, 0))})
		tween:Play()
		tween.Completed:Wait()
		
		-- Nil Stuff
		tweenInformation = nil
		tween = nil		
		
		-- Now Analyze the Sample!
		if powerOn and sampleIn and ranSample == false then
			
			-- we have now Ran Sample..
			ranSample = true
			
			--------------
			-- Analyze..--
			--------------
			
			-- Change TV Screen --
			tvDecal.Texture = analyzingScreen
			
			-- Turn Running Light On
			runningLight.BrickColor = BrickColor.new("Lime green")
			
			-- PLay Samples into Machine Hum
			machineHumSound:Play()
			
			-- Pull Samples Down into Machine..
			local tweenInformation = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
			local tween = game.TweenService:Create(vialWithBloodObject.PrimaryPart, tweenInformation, {["CFrame"] = vialWithBloodObject.PrimaryPart.CFrame:ToWorldSpace(CFrame.new(-2, 0, 0))})
			tween:Play()
			tween.Completed:Wait()
			
			-- Nil Stuff
			tweenInformation = nil
			tween = nil
			
			-- Stop Machine Humn
			if machineHumSound.IsPlaying then
				-- Stop
				machineHumSound:Stop()
			end
			
			-- PLay Computer Beep Sound -
			computerBeepsSound:Play()
			task.wait(computerBeepsSound.TimeLength)
			task.wait(1)
			computerBeepsSound:Play()
			task.wait(computerBeepsSound.TimeLength)
			
			------------------------
			-- Analyzing Finished --
			------------------------
			
			-- Now Turn switch off
			switchOn = false
			
			-- Play Sound
			switchSound:Play()

			-- Tween the switch up and down..
			local tweenInformation = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
			local tween = game.TweenService:Create(switchObject, tweenInformation, {["CFrame"] = switchObject.CFrame:ToWorldSpace(CFrame.new(0, -0.5, 0))})
			tween:Play()
			tween.Completed:Wait()
			
			-- Nil Stuff
			tweenInformation = nil
			tween = nil
			
			-- Turn running Light Off
			runningLight.Color = Color3.fromRGB(66,0,0)
			
			-- Destroy Sample
			vialWithBloodObject:Destroy()
			
			-- Display Results..
			tvDecal.Texture = itemsNeededScreen	
			
			-- Mission Stuff
			game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(3)
			
			-- Wait
			task.wait(1)
			
			-- Make New Item Prompts available --
			leftVialHolderProx.Enabled = true
			middleVialHolderProx.Enabled = true
			rightVialHolderProx.Enabled = true
			
		elseif allSamplesPlaced and craftedThePoison == false then
			
			-- Crafted the Poison
			craftedThePoison = true
			
			-- Craft the Poison..
			CraftThePoison()
			
		else
			
			-- Play Sound
			switchSound:Play()
			
			-- Tween it back down..
			local tweenInformation = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
			local tween = game.TweenService:Create(switchObject, tweenInformation, {["CFrame"] = switchObject.CFrame:ToWorldSpace(CFrame.new(0, -0.5, 0))})
			tween:Play()
			tween.Completed:Wait()

			-- Nil Stuff
			tweenInformation = nil
			tween = nil

			-- Turn it back off
			switchOn = false	
			
		end		
		
		-- Turn prox back on..
		switchProx.Enabled = true
		
	end	
end)

-- Fuse Prox --
fuseProx.Triggered:Connect(function(player)

	-- Reset tool in Backpack
	local playerHasFuse = false
	local playerFuseTool = nil

	-- Loop Through Player Childen that our tools..
	for _, child in pairs(player.Character:GetChildren()) do

		-- If its a tool..--
		if child:IsA("Tool") then

			-- check if its this tool--
			if child.Name == "Fuse" then

				-- Found Tool --
				playerHasFuse = true

				-- Set this Propane Tank
				playerFuseTool = child

				-- break
				break
			end
		end
	end

	-- IF Player had the tank in hand, then place it.. --
	if playerHasFuse then

		-- Take tank from player..
		playerFuseTool:Destroy()

		-- Turn off Prox Prompt
		fuseProx.Enabled = false

		-- Show Fuse
		fuseObject.Transparency = 0

		-- Turn on Power Light and Running Light
		powerLight.BrickColor = BrickColor.new("Lime green")
		runningLight.Color = Color3.fromRGB(255,0,0)
		
		-- Brighten Up Screens --
		script.Parent.CenterPanel.CenterPanelScreen.Decal.Color3 = Color3.fromRGB(1500,1500,1500)
		script.Parent.LeftPanel.LeftPanelScreen.Decal.Color3 = Color3.fromRGB(1500,1500,1500)
		script.Parent.TopPanel.TopPanelScreen.Decal.Color3 = Color3.fromRGB(1500,1500,1500)
		
		-- Machine Power is On
		powerOn = true
		
		-- If the Sample is in, Display ready screen, else show insert sample screen..
		if sampleIn then
			
			-- Change Screen
			tvDecal.Texture = analyzerReadyScreen
			
		else
			-- Change Screen
			tvDecal.Texture = insertChemicalScreenID
			
		end		

		-- Play Machine Sound--
		machineHumSound2:Play()
		
		-- Mission Stuff..
		game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(2)

	end	
	
	-- Nil Stuff
	playerFuseTool = nil
	playerHasFuse = nil
end)

-- Vial With Sample Prox --
vialWithBloodProx.Triggered:Connect(function(player)

	-- Reset tool in Backpack
	local playersHasVialWithBlood = false
	local playerVialWithBloodTool = nil

	-- Loop Through Player Childen that our tools..
	for _, child in pairs(player.Character:GetChildren()) do

		-- If its a tool..--
		if child:IsA("Tool") then

			-- check if its this tool--
			if child.Name == "VialWithBlood" then

				-- Found Tool --
				playersHasVialWithBlood = true

				-- Set this Propane Tank
				playerVialWithBloodTool = child

				-- break
				break
			end
		end
	end

	-- IF Player had the tank in hand, then place it.. --
	if playersHasVialWithBlood then

		-- Take tank from player..
		playerVialWithBloodTool:Destroy()
		
		-- Play Local sound
		game.ReplicatedStorage.PlayLocalSound:FireClient(player, "BloodExchange")

		-- Turn off Prox Prompt
		vialWithBloodProx.Enabled = false

		-- Show Fuse
		vialWithBloodObject.Handle.Transparency = 0.7
		vialWithBloodObject.Ends.Transparency = 0
		vialWithBloodObject.Blood.Transparency = 0
		
		-- Sample is in
		sampleIn = true
		
		-- Show Analyzer Ready Screen
		if powerOn then
			
			-- Change Screen
			tvDecal.Texture = analyzerReadyScreen			
		end		

	end	
	
	-- Nil Stuff
	playersHasVialWithBlood = nil
	playerVialWithBloodTool = nil
	
end)

-- Left Vial Holder Prompt --
leftVialHolderProx.Triggered:Connect(function(player)
	
	-- Reset tool in Backpack
	local playerHasEligibleVial = false
	local playerVialTool = nil
	local vialName = ""

	-- Loop Through Player Childen that our tools..
	for _, child in pairs(player.Character:GetChildren()) do

		-- If its a tool..--
		if child:IsA("Tool") then
			
			-- Only
			if child.Name == "VialWithAcid" and vialWithAcidPlaced == false then
				
				-- Found Tool --
				playerHasEligibleVial = true

				-- Set this Propane Tank
				playerVialTool = child

				-- Set vial type
				vialName = child.Name

				-- break
				break
				
			elseif child.Name == "VialWithPlasma" and vialWithPlasmaPlaced == false then
				
				-- Found Tool --
				playerHasEligibleVial = true

				-- Set this Propane Tank
				playerVialTool = child

				-- Set vial type
				vialName = child.Name

				-- break
				break

			elseif child.Name == "VialEmpty" and vialEmptyPlaced == false then

				-- Found Tool --
				playerHasEligibleVial = true

				-- Set this Propane Tank
				playerVialTool = child
				
				-- Set vial type
				vialName = child.Name

				-- break
				break
			end
		end
	end

	-- IF Player had the tank in hand, then place it.. --
	if playerHasEligibleVial then

		-- Take tank from player..
		playerVialTool:Destroy()
		
		-- Play Local sound
		game.ReplicatedStorage.PlayLocalSound:FireClient(player, "BloodExchange")

		-- Turn off Prox Prompt
		leftVialHolderProx.Enabled = false
		
		-- Init
		local clone = nil
		
		-- Find right clone
		if vialName == "VialEmpty" then			
			-- Clone this vial Into the Machine..
			clone = game.ServerStorage.Tools.EasterEggParts.VialEmptyPart:Clone()
			vialEmptyPlaced = true	
			clone.Parent = game.Workspace.Props.Room2.ChemicalAnalyzer.VialHolders.Left
			clone.Position = Vector3.new(103.826, 7.185, -16.592)
			clone.Ends.Position = Vector3.new(103.826, 7.185, -16.592)
			clone.ProximityPrompt.Enabled = false
			clone.Highlight.Enabled = false -- Disable Item Highlight
			clone.Ends.Highlight.Enabled = false
			-- Mission Stuff
			game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(6)
		elseif vialName == "VialWithPlasma" then
			-- Clone this vial Into the Machine..
			clone = game.ServerStorage.Tools.EasterEggParts.VialWithPlasmaPart:Clone()
			vialWithPlasmaPlaced = true
			clone.Parent = game.Workspace.Props.Room2.ChemicalAnalyzer.VialHolders.Left
			clone.Position = Vector3.new(103.826, 7.185, -16.592)
			clone.Ends.Position = Vector3.new(103.826, 7.185, -16.592)
			clone.Blood.Position = Vector3.new(103.826, 7.15, -16.592)
			-- Mission Stuff
			game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(5)		
		elseif vialName == "VialWithAcid" then
			-- Clone this vial Into the Machine..
			clone = game.ServerStorage.Tools.EasterEggParts.VialWithAcidPart:Clone()
			vialWithAcidPlaced = true
			clone.Parent = game.Workspace.Props.Room2.ChemicalAnalyzer.VialHolders.Left
			clone.Position = Vector3.new(103.826, 7.185, -16.592)
			clone.Ends.Position = Vector3.new(103.826, 7.185, -16.592)
			clone.Acid.Position = Vector3.new(103.826, 7.185, -16.592)
			-- Mission Stuff
			game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(4)
		end
		
		-- check if all vials have been placed..
		if vialEmptyPlaced and vialWithAcidPlaced and vialWithPlasmaPlaced then
			
			-- Make Special Rat Poison..
			allSamplesPlaced = true
			
			-- Mixer Ready Screen
			tvDecal.Texture = mixerReadyScreen
		end
		
		-- nil Stuff
		clone = nil

	end	

	-- Nil Stuff
	playerHasEligibleVial = nil
	playerVialTool = nil
	vialName = nil
	
end)

-- Middle Vial Holder Prompt --
middleVialHolderProx.Triggered:Connect(function(player)

	-- Reset tool in Backpack
	local playerHasEligibleVial = false
	local playerVialTool = nil
	local vialName = ""

	-- Loop Through Player Childen that our tools..
	for _, child in pairs(player.Character:GetChildren()) do

		-- If its a tool..--
		if child:IsA("Tool") then

			-- Only
			if child.Name == "VialWithAcid" and vialWithAcidPlaced == false then

				-- Found Tool --
				playerHasEligibleVial = true

				-- Set this Propane Tank
				playerVialTool = child

				-- Set vial type
				vialName = child.Name

				-- break
				break

			elseif child.Name == "VialWithPlasma" and vialWithPlasmaPlaced == false then

				-- Found Tool --
				playerHasEligibleVial = true

				-- Set this Propane Tank
				playerVialTool = child

				-- Set vial type
				vialName = child.Name

				-- break
				break

			elseif child.Name == "VialEmpty" and vialEmptyPlaced == false then

				-- Found Tool --
				playerHasEligibleVial = true

				-- Set this Propane Tank
				playerVialTool = child

				-- Set vial type
				vialName = child.Name

				-- break
				break
			end
		end
	end

	-- IF Player had the tank in hand, then place it.. --
	if playerHasEligibleVial then

		-- Take tank from player..
		playerVialTool:Destroy()
		
		-- Play Local sound
		game.ReplicatedStorage.PlayLocalSound:FireClient(player, "BloodExchange")

		-- Turn off Prox Prompt
		middleVialHolderProx.Enabled = false

		-- Init
		local clone = nil

		-- Find right clone
		if vialName == "VialEmpty" then			
			-- Clone this vial Into the Machine..
			clone = game.ServerStorage.Tools.EasterEggParts.VialEmptyPart:Clone()
			vialEmptyPlaced = true	
			clone.Parent = game.Workspace.Props.Room2.ChemicalAnalyzer.VialHolders.Middle
			clone.Position = Vector3.new(103.826, 7.176, -18.617)
			clone.Ends.Position = Vector3.new(103.826, 7.176, -18.617)
			clone.ProximityPrompt.Enabled = false
			clone.Highlight.Enabled = false -- Disable Item Highlight
			clone.Ends.Highlight.Enabled = false
			-- Mission Stuff
			game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(6)
		elseif vialName == "VialWithPlasma" then
			-- Clone this vial Into the Machine..
			clone = game.ServerStorage.Tools.EasterEggParts.VialWithPlasmaPart:Clone()
			vialWithPlasmaPlaced = true
			clone.Parent = game.Workspace.Props.Room2.ChemicalAnalyzer.VialHolders.Middle
			clone.Position = Vector3.new(103.826, 7.176, -18.617)
			clone.Ends.Position = Vector3.new(103.826, 7.176, -18.617)
			clone.Blood.Position = Vector3.new(103.826, 7.15, -18.617)
			-- Mission Stuff
			game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(5)			
		elseif vialName == "VialWithAcid" then
			-- Clone this vial Into the Machine..
			clone = game.ServerStorage.Tools.EasterEggParts.VialWithAcidPart:Clone()
			vialWithAcidPlaced = true
			clone.Parent = game.Workspace.Props.Room2.ChemicalAnalyzer.VialHolders.Middle
			clone.Position = Vector3.new(103.826, 7.176, -18.617)
			clone.Ends.Position = Vector3.new(103.826, 7.176, -18.617)
			clone.Acid.Position = Vector3.new(103.826, 7.176, -18.617)
			-- Mission Stuff
			game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(4)
		end
		
		-- check if all vials have been placed..
		if vialEmptyPlaced and vialWithAcidPlaced and vialWithPlasmaPlaced then

			-- Make Special Rat Poison..
			allSamplesPlaced = true
			
			-- Mixer Ready Screen
			tvDecal.Texture = mixerReadyScreen
		end
		
		-- nil Stuff
		clone = nil
	end	

	-- Nil Stuff
	playerHasEligibleVial = nil
	playerVialTool = nil
	vialName = nil

end)

-- Middle Vial Holder Prompt --
rightVialHolderProx.Triggered:Connect(function(player)

	-- Reset tool in Backpack
	local playerHasEligibleVial = false
	local playerVialTool = nil
	local vialName = ""

	-- Loop Through Player Childen that our tools..
	for _, child in pairs(player.Character:GetChildren()) do

		-- If its a tool..--
		if child:IsA("Tool") then

			-- Only
			if child.Name == "VialWithAcid" and vialWithAcidPlaced == false then

				-- Found Tool --
				playerHasEligibleVial = true

				-- Set this Propane Tank
				playerVialTool = child

				-- Set vial type
				vialName = child.Name

				-- break
				break

			elseif child.Name == "VialWithPlasma" and vialWithPlasmaPlaced == false then

				-- Found Tool --
				playerHasEligibleVial = true

				-- Set this Propane Tank
				playerVialTool = child

				-- Set vial type
				vialName = child.Name

				-- break
				break

			elseif child.Name == "VialEmpty" and vialEmptyPlaced == false then

				-- Found Tool --
				playerHasEligibleVial = true

				-- Set this Propane Tank
				playerVialTool = child

				-- Set vial type
				vialName = child.Name

				-- break
				break
			end
		end
	end

	-- IF Player had the tank in hand, then place it.. --
	if playerHasEligibleVial then

		-- Take tank from player..
		playerVialTool:Destroy()
		
		-- Play Local sound
		game.ReplicatedStorage.PlayLocalSound:FireClient(player, "BloodExchange")

		-- Turn off Prox Prompt
		rightVialHolderProx.Enabled = false

		-- Init
		local clone = nil

		-- Find right clone
		if vialName == "VialEmpty" then			
			-- Clone this vial Into the Machine..
			clone = game.ServerStorage.Tools.EasterEggParts.VialEmptyPart:Clone()
			vialEmptyPlaced = true	
			clone.Parent = game.Workspace.Props.Room2.ChemicalAnalyzer.VialHolders.Right
			clone.Position = Vector3.new(103.826, 7.168, -20.647)
			clone.Ends.Position = Vector3.new(103.826, 7.168, -20.647)
			clone.ProximityPrompt.Enabled = false
			clone.Highlight.Enabled = false -- Disable Item Highlight
			clone.Ends.Highlight.Enabled = false
			-- Mission Stuff
			game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(6)
		elseif vialName == "VialWithPlasma" then
			-- Clone this vial Into the Machine..
			clone = game.ServerStorage.Tools.EasterEggParts.VialWithPlasmaPart:Clone()
			vialWithPlasmaPlaced = true
			clone.Parent = game.Workspace.Props.Room2.ChemicalAnalyzer.VialHolders.Right
			clone.Position = Vector3.new(103.826, 7.168, -20.647)
			clone.Ends.Position = Vector3.new(103.826, 7.168, -20.647)
			clone.Blood.Position = Vector3.new(103.826, 7.15, -20.647)	
			-- Mission Stuff
			game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(5)
		elseif vialName == "VialWithAcid" then
			-- Clone this vial Into the Machine..
			clone = game.ServerStorage.Tools.EasterEggParts.VialWithAcidPart:Clone()
			vialWithAcidPlaced = true
			clone.Parent = game.Workspace.Props.Room2.ChemicalAnalyzer.VialHolders.Right
			clone.Position = Vector3.new(103.826, 7.168, -20.647)
			clone.Ends.Position = Vector3.new(103.826, 7.168, -20.647)
			clone.Acid.Position = Vector3.new(103.826, 7.168, -20.647)
			-- Mission Stuff
			game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(4)
		end
		
		-- check if all vials have been placed..
		if vialEmptyPlaced and vialWithAcidPlaced and vialWithPlasmaPlaced then

			-- Make Special Rat Poison..
			allSamplesPlaced = true
			
			-- Mixer Ready Screen
			tvDecal.Texture = mixerReadyScreen
		end
		
		-- nil stuff
		clone = nil

	end	

	-- Nil Stuff
	playerHasEligibleVial = nil
	playerVialTool = nil
	vialName = nil

end)
