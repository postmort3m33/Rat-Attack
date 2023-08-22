-- This Player
local thisPlayer = game.Players.LocalPlayer
if not thisPlayer.Character then thisPlayer.CharacterAdded:Wait() end
local thisCharacter = thisPlayer.Character
local thisHumanoid = thisCharacter:WaitForChild("Humanoid")

-- Services
local GUIService = game:GetService("GuiService")
GUIService.AutoSelectGuiEnabled = false -- turn this off for XBOX Support
local UIS = game:GetService("UserInputService")

-- Frames
local hudFrame = script.Parent.HUDFrame
local hotbarFrame = script.Parent.Hotbar

-- Hotbar Buttons
local hotbarButton1 = hotbarFrame:WaitForChild("1")
local hotBar1Tool = nil
local hotbarButton2 = hotbarFrame:WaitForChild("2")
local hotBar2Tool = nil
local hotbarButton3 = hotbarFrame:WaitForChild("3")
local hotBar3Tool = nil
local hotbarButton4 = hotbarFrame:WaitForChild("4")
local hotBar4Tool = nil
local hotbarButton5 = hotbarFrame:WaitForChild("5")
local hotBar5Tool = nil
local hotbarButton6 = hotbarFrame:WaitForChild("6")
local hotBar6Tool = nil
local hotbarButton7 = hotbarFrame:WaitForChild("7")
local hotBar7Tool = nil
local hotbarButton8 = hotbarFrame:WaitForChild("8")
local hotBar8Tool = nil
local hotbarButton9 = hotbarFrame:WaitForChild("9")
local hotBar9Tool = nil
local hotbarTools = { hotBar1Tool, hotBar2Tool, hotBar3Tool, hotBar4Tool,
							hotBar5Tool, hotBar6Tool, hotBar7Tool, hotBar8Tool, hotBar9Tool }
local hotbarButtons = { hotbarButton1, hotbarButton2, hotbarButton3, hotbarButton4,
							hotbarButton5, hotbarButton6, hotbarButton7, hotbarButton8, hotbarButton9 }

-- Weaopon Stuff
local equippedTool = nil
local equippedHotbar = nil
local equipmentSoundPlaying = nil
local toolThatsMoving = nil

-- Equipment Sounds
local equip1Sound = script.Parent.Audio.Equipment.Equip1
local equip2Sound = script.Parent.Audio.Equipment.Equip2
local equipSoundArray = {equip1Sound, equip2Sound}
local unequip1Sound = script.Parent.Audio.Equipment.Unequip1
local unequip2Sound = script.Parent.Audio.Equipment.Unequip2
local unequipSoundArray = {unequip1Sound, unequip2Sound}

-- Blood Screen Effect Vars
local maxHealth = thisHumanoid.MaxHealth
local bloodScreenLight = hudFrame.BloodScreen1
local bloodScreenMedium = hudFrame.BloodScreen2
local bloodScreenHeavy = hudFrame.BloodScreen3

-- Objects --
local gameMessageTextLabel = hudFrame.GameMessage

-- Join Game Label Wait Time
local JOIN_WAIT_TIME = 12

-- Debug Stuff
local debugFrame = script.Parent.DebugFrame

-- Sounds
local notificationSound = script.Parent.Audio.Notifications.MessageNotification

-- State Vars
local isDisplayingMessage = false


--------------
-- GUI Init --
--------------

-- Turn on The GUI
script.Parent.Enabled = true

-- Object States
gameMessageTextLabel.Text = ''

-- Frame States
hudFrame.Visible = false
hotbarFrame.Visible = false

-----------------------
-- HUD GUI Functions --
-----------------------

-- Function to Update HUD MEssage
local function UpdateHUDMessage(message)

	-- If not already displaying.
	if isDisplayingMessage == false then

		-- Now displaying
		isDisplayingMessage = true

		-- Set Message
		gameMessageTextLabel.Text = message

		-- Play sound
		notificationSound:Play()

		-- Wait, then remove message
		task.wait(2)

		-- Empty Message
		gameMessageTextLabel.Text = ''

		-- No longer displaying Message
		isDisplayingMessage = false
	end	

end

----------------------
-- HotBar Functions --
----------------------

-- functions to refresh the Hotbar --
local function InitHotbar()

	----------------------
	-- Get Player Tools --
	----------------------

	local playerTools = thisPlayer.Backpack:GetChildren()

	-- Add Tool in Hand as well
	for _, v in pairs(thisPlayer.Character:GetChildren()) do

		-- If its a tool
		if v:IsA("Tool") then

			-- Add it to the player tools
			table.insert(playerTools, v)
		end
	end

	---------------------------------
	-- Now Set Tools to the hotbar --
	---------------------------------

	-- Apply Tools to the Hotbar..
	for i, tool in ipairs(playerTools) do

		-- Set Image
		hotbarButtons[i].Image = tool.TextureId

		-- Set Tool Value
		hotbarTools[i] = tool		

		-- If this is the 9th, tool, break function..
		if i == 9 then
			break
		end
	end

	-- Nil Stuff
	playerTools = nil

end

-- function that runs when activating a hotbar button..
local function ActivateHotbar(hotbarNumber)

	-- Ref this Hotbar Button
	local hotbarButton = hotbarButtons[hotbarNumber]

	-- If we are activating this with a tool thats moving..
	if toolThatsMoving then

		-- If its the same tool thats in the hotbar already.. leave..
		if toolThatsMoving ~= hotbarTools[hotbarNumber] then

			-- put this tool into this hotbar spot..
			hotbarButton.Image = toolThatsMoving.TextureId

			-- Make this hotbartool the new tool..
			hotbarTools[hotbarNumber] = toolThatsMoving

			-- Remove Image from other toolbar spot..
			for i = 1, 9 do

				-- Skip if its nil
				if hotbarTools[i] == nil then

					-- Skip
					continue
				end

				-- Check for this Hotbar..
				if i == hotbarNumber then

					-- Skip
					continue
				end

				-- Find the extra..
				if hotbarTools[i] == toolThatsMoving then

					-- Remove rthis Image and Tool
					hotbarTools[i] = nil

					-- Image
					hotbarButtons[i].Image = ""
				end		

			end			
		end

		-- tool thats moving is nil..
		toolThatsMoving = nil	

		-- leave function
		return
	end

	-- If no Tool Exists in this Hotbar, LEave
	if hotbarTools[hotbarNumber] == nil then		
		-- leave
		return
	end

	-- If we already have this weapon, unequip it..
	if equippedTool == hotbarTools[hotbarNumber] then

		-- Unequip
		equippedTool.Parent = thisPlayer.Backpack

		-- No More equipped HotBar
		equippedHotbar = nil

	elseif equippedTool ~= hotbarTools[hotbarNumber] and equippedTool ~= nil then -- Had Another Weapon..

		--------------------------
		-- Unequip Current Tool --
		--------------------------

		-- Unequip Current weapon
		equippedTool.Parent = thisPlayer.Backpack

		---------------------
		-- Equip This Tool --
		---------------------

		-- Equip this weaopon
		hotbarTools[hotbarNumber].Parent = thisCharacter

		-- Set Equipped HotBar
		equippedHotbar = hotbarButton

	else -- No Weapon Equipped..

		-- Only Equip the weapon if the HotBar has a tool..
		if hotbarTools[hotbarNumber] ~= nil then

			-- Equip It..
			hotbarTools[hotbarNumber].Parent = thisCharacter

			-- Set Equipped HotBar
			equippedHotbar = hotbarButton

		end
	end

	-- Nil Stuff
	hotbarButton = nil
end

-----------------------------------
-- Equip and Unequip Connections --
-----------------------------------

-- Check When a tool is added ot the player --
thisCharacter.ChildAdded:Connect(function(child)

	-- If the Child Added was a Tool, reference it.. --
	if child:IsA("Tool") then

		-- Ref it --
		equippedTool = child
		
		-- Play Sound
		equipmentSoundPlaying = equipSoundArray[math.random(1, #equipSoundArray)]
		equipmentSoundPlaying:Play()

		--------------------------------------------------
		-- If it was a hotbar Item, Turn on "Highlight" --
		--------------------------------------------------

		-- If this item was a Hotbar item..
		for i = 1, 9 do

			-- If they match
			if hotbarTools[i] == child then

				-- Remove "Equipped" Border	
				hotbarButtons[i].Border.Visible = true

			end
		end
	end
end)

-- Check When a tool is added ot the player --
thisCharacter.ChildRemoved:Connect(function(child)

	-- If the Child Added was a Tool, reference it.. --
	if child:IsA("Tool") then

		-- Ref it --
		equippedTool = nil
		
		-- Play Sound If not Playing
		if not equipmentSoundPlaying.IsPlaying then

			-- Play it
			equipmentSoundPlaying =  unequipSoundArray[math.random(1, #unequipSoundArray)]
			equipmentSoundPlaying:Play()
		end		

		-- If this item was a Hotbar item..
		for i = 1, 9 do

			-- If they match
			if hotbarTools[i] == child then

				-- No more equipped hotbar
				equippedHotbar = nil

				-----------------------------------------------
				-- check if this item went to the backpack.. --
				-----------------------------------------------

				-- Ref
				local itemWentToBackpack = false

				-- Loop
				for _, tool in pairs(thisPlayer.Backpack:GetChildren()) do

					-- Match the tool
					if tool == child then

						-- Ite went to Backpack
						itemWentToBackpack = true
					end
				end

				-- If it just went to backpack..
				if itemWentToBackpack then

					-- do nothing..						
				else -- Item was Thrown, or dropped from Bag..

					-- Remove It
					hotbarTools[i] = nil

					-- Remove image
					hotbarButtons[i].Image = ""

					-- Delete Border if this was equipped..
					hotbarButtons[i].Border.Visible = false

					-- Nil Stuff
					itemWentToBackpack = nil

					-- Break Loop
					break						

				end					

				-- Delete Border if this was equipped..
				hotbarButtons[i].Border.Visible = false

				-- Nil Stuff
				itemWentToBackpack = nil

			end
		end
	end
end)

-- check for item Added to Player Backpack..
thisPlayer.Backpack.ChildAdded:Connect(function(child)

	-- Ref has Tool Already..
	local toolInHotbar = false

	-- First make sure this tool is not on a hotbar..
	for i = 1, 9 do

		-- If..
		if hotbarTools[i] == child then

			-- tool is in hotbar..
			toolInHotbar = true

			-- Break
			break
		end
	end

	-- If tool was not in hotbar, then search for an empty spot..
	if toolInHotbar == false then

		-- Add tool to hotbar if there is an empty space..
		for i = 1, 9 do

			-- First tool that is nil, add this tool
			if hotbarTools[i] == nil then

				-- Add tool to this Hotbar
				hotbarButtons[i].Image = child.TextureId

				-- Set Tool Value
				hotbarTools[i] = child

				-- break Function
				break

			end		
		end		
	end	

	-- Nil Stuff
	toolInHotbar = nil
end)

-- Item Removed from Backpack..
thisPlayer.Backpack.ChildRemoved:Connect(function(child)

	----------------------
	-- Get Player Tools --
	----------------------

	local playerTools = thisPlayer.Backpack:GetChildren()

	-- Add Tool in Hand as well
	for _, v in pairs(thisPlayer.Character:GetChildren()) do

		-- If its a tool
		if v:IsA("Tool") then

			-- Add it to the player tools
			table.insert(playerTools, v)
		end
	end

	-- Go through all hotbarTools and make sure we actually have that tool..
	for i = 1, 9 do

		-- Local ref..
		local toolFound = false

		-- Go through playerTools
		for _, tool in pairs(playerTools) do

			-- if we have a matching tool, continye
			if hotbarTools[i] == tool then

				-- Tool was found
				toolFound = true

				-- break
				break
			end
		end

		-- If the tool wasnt found..
		if not toolFound then

			-- Delete this hotbarTool
			hotbarTools[i] = nil

			-- Button Image
			hotbarButtons[i].Image = ""
		end

		-- Nil Stuff
		toolFound = nil

	end
	
	-- Nil Stuff
	playerTools = nil
end)

-- When Health is changed for Blood Screen Effect
thisHumanoid.HealthChanged:Connect(function(health)

	-- Set Screen Effect According to current health..
	if health == maxHealth then

		-- Fade old blood out..
		local fadeOutCoroutine = coroutine.wrap(function()

			-- Fade out..
			while bloodScreenLight.Visible == true and bloodScreenLight.ImageTransparency < 1 do

				-- Fade out
				bloodScreenLight.ImageTransparency += 0.01

				-- If health becomes less, cancel this..
				if thisHumanoid.Health < maxHealth then

					-- Break
					break
				end

				-- Wait
				task.wait()
			end

			-- turn it off as long as health is still max
			if thisHumanoid.Health == maxHealth then

				-- Do it
				bloodScreenLight.Visible = false
				bloodScreenLight.ImageTransparency = 0				
			end			

		end)()

		-- Nil
		fadeOutCoroutine = nil

		-- No Blood Screens
		bloodScreenMedium.Visible = false
		bloodScreenMedium.ImageTransparency = 0
		bloodScreenHeavy.Visible = false
		bloodScreenHeavy.ImageTransparency = 0

	elseif health < maxHealth and health > (maxHealth - (maxHealth / 3)) then

		-- Turn off other bloodScreen Effects
		bloodScreenMedium.Visible = false
		bloodScreenMedium.ImageTransparency = 0
		bloodScreenHeavy.Visible = false
		bloodScreenHeavy.ImageTransparency = 0

		-- Blood Screen Light Effect
		bloodScreenLight.Visible = true
		bloodScreenLight.ImageTransparency = 0

	elseif health < (maxHealth - (maxHealth / 3)) and health > (maxHealth - ((maxHealth / 3) * 2)) then

		-- Turn off other bloodScreen Effects
		bloodScreenLight.Visible = false
		bloodScreenLight.ImageTransparency = 0
		bloodScreenHeavy.Visible = false
		bloodScreenHeavy.ImageTransparency = 0

		-- Blood Screen Light Effect
		bloodScreenMedium.Visible = true
		bloodScreenMedium.ImageTransparency = 0

	elseif health < (maxHealth - ((maxHealth / 3) * 2)) then

		-- Turn off other bloodScreen Effects
		bloodScreenLight.Visible = false
		bloodScreenLight.ImageTransparency = 0
		bloodScreenMedium.Visible = false
		bloodScreenMedium.ImageTransparency = 0

		-- Blood Screen Light Effect
		bloodScreenHeavy.Visible = true
		bloodScreenHeavy.ImageTransparency = 0

	end	
end)

--------------------------------
-- HUD GUI Update Connections --
--------------------------------

-- Recieving HUD Messages from Server --
game.ReplicatedStorage.SendPlayerHUDMessage.OnClientEvent:Connect(function(message)

	-- Update HUD Message as a Coroutine since it has a wait time
	local updateHUDCoroutine = coroutine.create(UpdateHUDMessage)

	-- Run it..
	coroutine.resume(updateHUDCoroutine, message)

	-- Nil Stuff
	updateHUDCoroutine = nil

end)

-- Debugign
game.ReplicatedStorage.SendDebuggingDataSTC.OnClientEvent:Connect(function(data1, data2)
	
	-- Update screen
	if data1 then
		thisPlayer.PlayerGui.DebuggingGUI.DebugFrame.TextLabel1.Text = data1
	end

	if data2 then
		thisPlayer.PlayerGui.DebuggingGUI.DebugFrame.TextLabel2.Text = data2
	end

	-- wait
	--task.wait(2)

	-- Delete
	--thisPlayer.PlayerGui.DebuggingGUI.DebugFrame.TextLabel1.Text = ""
	--thisPlayer.PlayerGui.DebuggingGUI.DebugFrame.TextLabel2.Text = "" 
end)

------------------------
-- HotBar Connections --
------------------------

-- User Input Connection
UIS.InputBegan:Connect(function(input)
	
	-- Xbox Support..
	if input.KeyCode == Enum.KeyCode.ButtonL1 then
		
		-- Ref Equipped Hotbar index..
		local index = nil
		local newIndex = nil
		
		-- If we have an equipped item..
		if equippedHotbar then
			
			-- Find Equipped HotBar Index
			index = table.find(hotbarButtons, equippedHotbar)
			
			-- If index is at 1, move to number 9
			if index == 1 then			
				-- New is 9
				newIndex = 9
			else			
				-- New Index is minus 1
				newIndex = index - 1			
			end
			
		else
			newIndex = 1
		end	
		
		-- If newIndex is nil..
		if hotbarTools[newIndex] == nil then
			
			-- Ref
			local foundHotbarTool = false
						
			-- Lets find a new hotbar..
			while foundHotbarTool == false do
				
				-- subtract from newIndex
				if newIndex == 1 then
					
					-- New New index
					newIndex = 9
				else
					newIndex -= 1					
				end
				
				-- Is this tool active
				if hotbarTools[newIndex] ~= nil then
					
					-- Found HotBar
					foundHotbarTool = true
				end
			end
			
			-- Nil Stuff
			foundHotbarTool = nil
		end
		
		-- Change Equipped HotBar
		ActivateHotbar(newIndex)
		
		-- Nil Stuff
		index = nil
		newIndex = nil
	end
	
	-- Xbox Support..
	if input.KeyCode == Enum.KeyCode.ButtonR1 then

		-- Ref Equipped Hotbar index..
		local index = nil
		local newIndex = nil

		-- If we have an equipped item..
		if equippedHotbar then

			-- Find Equipped HotBar Index
			index = table.find(hotbarButtons, equippedHotbar)

			-- If index is at 1, move to number 9
			if index == 9 then			
				-- New is 9
				newIndex = 1
			else			
				-- New Index is minus 1
				newIndex = index + 1			
			end

		else
			newIndex = 1
		end	
		
		-- If newIndex is nil..
		if hotbarTools[newIndex] == nil then

			-- Ref
			local foundHotbarTool = false

			-- Lets find a new hotbar..
			while foundHotbarTool == false do

				-- subtract from newIndex
				if newIndex == 9 then

					-- New New index
					newIndex = 1
				else
					newIndex += 1					
				end

				-- Is this tool active
				if hotbarTools[newIndex] ~= nil then

					-- Found HotBar
					foundHotbarTool = true
				end
			end

			-- Nil Stuff
			foundHotbarTool = nil
		end

		-- Change Equipped HotBar
		ActivateHotbar(newIndex)

		-- Nil Stuff
		index = nil
		newIndex = nil
	end

	-- Check for hotbar Inputs
	if input.KeyCode == Enum.KeyCode.One then
		
		-- Activate HotBar
		ActivateHotbar(1)		
	end
	
	-- Check for hotbar Inputs
	if input.KeyCode == Enum.KeyCode.Two then

		-- Activate HotBar
		ActivateHotbar(2)	
	end
	
	-- Check for hotbar Inputs
	if input.KeyCode == Enum.KeyCode.Three then

		-- Activate HotBar
		ActivateHotbar(3)		
	end

	-- Check for hotbar Inputs
	if input.KeyCode == Enum.KeyCode.Four then

		-- Activate HotBar
		ActivateHotbar(4)	
	end
	
	-- Check for hotbar Inputs
	if input.KeyCode == Enum.KeyCode.Five then

		-- Activate HotBar
		ActivateHotbar(5)		
	end

	-- Check for hotbar Inputs
	if input.KeyCode == Enum.KeyCode.Six then

		-- Activate HotBar
		ActivateHotbar(6)	
	end

	-- Check for hotbar Inputs
	if input.KeyCode == Enum.KeyCode.Seven then

		-- Activate HotBar
		ActivateHotbar(7)		
	end

	-- Check for hotbar Inputs
	if input.KeyCode == Enum.KeyCode.Eight then

		-- Activate HotBar
		ActivateHotbar(8)	
	end
	
	-- Check for hotbar Inputs
	if input.KeyCode == Enum.KeyCode.Nine then

		-- Activate HotBar
		ActivateHotbar(9)	
	end
	
end)

-- 1
hotbarButton1.MouseButton1Click:Connect(function()
	
	-- Activate Hotbar
	ActivateHotbar(1)	
	
end)

-- 2
hotbarButton2.MouseButton1Click:Connect(function()
	
	-- Activate Hotbar
	ActivateHotbar(2)

end)

-- 3
hotbarButton3.MouseButton1Click:Connect(function()
	
	-- Activate Hotbar
	ActivateHotbar(3)

end)

-- 4
hotbarButton4.MouseButton1Click:Connect(function()
	
	-- Activate Hotbar
	ActivateHotbar(4)

end)

-- 5
hotbarButton5.MouseButton1Click:Connect(function()
	
	-- Activate Hotbar
	ActivateHotbar(5)

end)

-- 6
hotbarButton6.MouseButton1Click:Connect(function()
	
	-- Activate Hotbar
	ActivateHotbar(6)

end)

-- 7
hotbarButton7.MouseButton1Click:Connect(function()
	
	-- Activate Hotbar
	ActivateHotbar(7)

end)

-- 8
hotbarButton8.MouseButton1Click:Connect(function()
	
	-- Activate Hotbar
	ActivateHotbar(8)

end)

-- 9
hotbarButton9.MouseButton1Click:Connect(function()
	
	-- Activate Hotbar
	ActivateHotbar(9)

end)

-- Teleporting Connections --
game.ReplicatedStorage.PlayerTeleporting.OnClientEvent:Connect(function()
	
	-- Turn On Teleporting Label
	hudFrame.JoinGameLabel.Visible = true
	
	-- Mark a start time
	local startTime = time()
	
	-- while this is visible, start a countdown..
	while hudFrame.JoinGameLabel.Visible == true do
		
		-- has it been more than waitime?
		if (time() - startTime) > JOIN_WAIT_TIME then
			
			-- Change Label..
			hudFrame.JoinGameLabelLonger.Visible = true
			hudFrame.JoinGameLabel.Visible = false
			
		end	
		
		-- Wait
		task.wait()
	end
	
end)

-- Teleporting Connections --
game.ReplicatedStorage.PlayerTeleportingCanceled.OnClientEvent:Connect(function()

	-- Turn On Teleporting Label
	hudFrame.JoinGameLabel.Visible = false
	hudFrame.JoinGameLabelLonger.Visible = false

end)


--------------
-- Init HUD --
--------------

-- Turn on HUD
hudFrame.Visible = true

-- turn on Hotbar
hotbarFrame.Visible = true

-- Make Sure Blod Screen Efffec tis off..
bloodScreenLight.Visible = false
bloodScreenLight.ImageTransparency = 0
bloodScreenMedium.Visible = false
bloodScreenMedium.ImageTransparency = 0
bloodScreenHeavy.Visible = false
bloodScreenHeavy.ImageTransparency = 0

-- Turn On Teleporting Label
hudFrame.JoinGameLabel.Visible = false
hudFrame.JoinGameLabelLonger.Visible = false

-- Initialize Hotbar
InitHotbar()