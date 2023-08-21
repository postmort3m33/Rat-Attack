---------------------
-- Start of Script --
---------------------

-- Services
local GUIService = game:GetService("GuiService")
GUIService.AutoSelectGuiEnabled = false -- turn this off for XBOX Suppo
local ContextActionService = game:GetService("ContextActionService")
local UIS = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")

-- Disable Mouse Cursor
UIS.MouseIconEnabled = false

-- This Player
local thisPlayer = game.Players.LocalPlayer
if not thisPlayer.Character then thisPlayer.CharacterAdded:Wait() end
local thisCharacter = thisPlayer.Character
local thisHumanoid = thisCharacter:WaitForChild("Humanoid")

-- Game States
local isTouchScreen = false
local isConsole = false

-- Frames
local hudFrame = script.Parent.HUDFrame
local bagFrame = script.Parent.BagFrame
local slotOptionsFrame = script.Parent.BagFrame.SlotOptionsFrame
local weaponsBenchFrame = script.Parent.WeaponsBenchFrame
local weaponsGridFrame = script.Parent.WeaponsBenchFrame.WeaponsGridFrame
local currentWeaponFrame = weaponsBenchFrame.CurrentWeaponFrame
local bagItemsFrame = bagFrame.BagItemsFrame
local hotbarFrame = script.Parent.Hotbar
local objectivesFrame = bagFrame.ObjectivesFrame
local creditsFrame = script.Parent.CreditsFrame
local deathFrame = script.Parent.DeathFrame

-- Buttons
local exitButton = weaponsBenchFrame.ExitButton
local backButton = weaponsBenchFrame.BackButton
local currentWeaponFrameDamageUpgradeButton = currentWeaponFrame.Buttons.DamageUpgradeButton
local currentWeaponFrameRadiusUpgradeButton = currentWeaponFrame.Buttons.RadiusUpgradeButton
local currentWeaponFrameSpecialUpgradeButton = currentWeaponFrame.Buttons.SpecialUpgradeButton
local currentWeaponFramePowerUpgradeButton = currentWeaponFrame.Buttons.PowerUpgradeButton

-- Hotbar Buttons
local hotbarButton1 = hotbarFrame:WaitForChild("1")
local hotbarButton2 = hotbarFrame:WaitForChild("2")
local hotbarButton3 = hotbarFrame:WaitForChild("3")
local hotbarButton4 = hotbarFrame:WaitForChild("4")
local hotbarButton5 = hotbarFrame:WaitForChild("5")
local hotbarButton6 = hotbarFrame:WaitForChild("6")
local hotbarButton7 = hotbarFrame:WaitForChild("7")
local hotbarButton8 = hotbarFrame:WaitForChild("8")
local hotbarButton9 = hotbarFrame:WaitForChild("9")
local hotbarTools = { {nil, 0}, {nil, 0}, {nil, 0}, {nil,0},
						{nil, 0}, {nil, 0}, {nil, 0}, {nil, 0}, {nil,0} }
local hotbarButtons = { hotbarButton1, hotbarButton2, hotbarButton3, hotbarButton4,
							hotbarButton5, hotbarButton6, hotbarButton7, hotbarButton8, hotbarButton9 }

-- Weapon Stuff
local equippedTool = nil
local equippedHotbar = nil
local toolThatsMoving = {nil, 0, nil} -- Name, Number of Items, TextureID

-- Objects --
local bagButton = hudFrame.BagButton
local skullCountTextLabel = hudFrame.MainFrame.SkullCount
local gameMessageTextLabel = hudFrame.GameMessage
local gameRoundTextLabel = hudFrame.GameRound
local gameTimeTextLabel = bagFrame.GameTimeFrame.GameTime
local playerLivesTextLabel = hudFrame.MainFrame.Lives
local bloodTextLabel = hudFrame.MainFrame.Blood
local weaponsBenchVialsLabel = weaponsBenchFrame.VialsLabel
local objectiveTemplate = objectivesFrame.ObjectiveTemplate
local subObjectiveTemplate = objectivesFrame.SubObjectiveTemplate
local objectiveIndicatorLabel = hudFrame.ObjectiveIndicator
local objectiveCompleteIndicatorLabel = hudFrame.ObjectiveCompleteIndicator
local playerDiedLabel = hudFrame.PlayerDiedText
local tutorialArrow = hudFrame.TutorialArrow

-- Bag Selection Buttons
local bagSelectionButton = bagFrame.BagButton
local objectivesSelectionButton = bagFrame.ObjectivesButton
local isAnimatingBagButton = false

-- Sounds
local notificationSound = script.Parent.Audio.Notifications.MessageNotification
local squeal1Sound = script.Parent.Audio.Notifications.Squeal1
local squeal2Sound = script.Parent.Audio.Notifications.Squeal2
local runDownSound = script.Parent.Audio.Notifications.RunDown
local lowBendSound = script.Parent.Audio.Notifications.LowBend
local zipperSound = script.Parent.Audio:WaitForChild("Zipper")
local zipperCloseSound = script.Parent.Audio:WaitForChild("ZipperClose")
local uiClick = script.Parent.Audio.UINavigation:WaitForChild("OrganicClick")
local uiClickSelect = script.Parent.Audio.UINavigation:WaitForChild("OrganicClickSelect")

-- Scientist Sounds
local thanks1Sound = script.Parent.Audio.Scientist:WaitForChild("Thanks1")
local thanks2Sound = script.Parent.Audio.Scientist:WaitForChild("Thanks2")
local thanks3Sound = script.Parent.Audio.Scientist:WaitForChild("Thanks3")
local thanksAudioArray = {thanks1Sound, thanks2Sound, thanks3Sound}
local carefulOutThereSound = script.Parent.Audio.Scientist.CarefulOutThere
local bringMoreBloodSound = script.Parent.Audio.Scientist.BringMoreBlood
local leaveWeaponsBenchAudioArray = {carefulOutThereSound, bringMoreBloodSound}
local notEnoughBlood1 = script.Parent.Audio.Scientist.NotEnoughBlood1
local notEnoughBlood2 = script.Parent.Audio.Scientist.NotEnoughBlood2
local notEnoughBloodAudioArray = {notEnoughBlood1, notEnoughBlood2}
local needThatInVial = script.Parent.Audio.Scientist.NeedThatInVial
local endGameMusicSound = script.Parent.Audio.EndGameMusic

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

-- Tutorial Vars...
local tutorialOpenedBag = false
local tutorialOpenedObjectives = false
local tutorialOpenedBagItemsFrame = false
local tutorialOpenedSlotOptionsFrame = false
local tutorialSelectedMove = false
local tutorialSetMovingTool = false
local gotBloodObjective = false

-- State Vars
local playerInBag = false
local isDisplayingMessage = false
local equipmentSoundPlaying = nil
local GAME_OVER = false
local currentWeaponGUIFrame = nil
local playerInWeaponsBench = false
local gotNewRecord = false
local isActivatingHotbar = false

-- Bag Vars --
local currentSelectedBagItem = nil
local slotConnection = nil
local dropConnection = nil
local equipConnection = nil
local moveConnection = nil
local slotConnections = {}
local bagSelectionButtonConnection = nil
local objectivesSelectionButtonConnection = nil

-- Table of Key Items that cant be dropped (Keep Updated with 2nd table in PLayerInitController except Flashlight!!)
local keyItemsTable = { "Flashlight", "AerosolCan", "Battery", "ElectronicComponent", "Fuse", 
	"PropaneTank", "RatDead", "SawBlade", "VialEmpty", "VialWithAcid",
	"VialWithAlbinoBlood", "VialWithPlasma", "VialWithPoison", "VialGunPoison", "FoggerMachine",
	"FoggerMachineModded"
}

-- Int to Roman Numeral Stuff
local romanNumeralNumberMap = {
	{1000, 'M'},
	{900, 'CM'},
	{500, 'D'},
	{400, 'CD'},
	{100, 'C'},
	{90, 'XC'},
	{50, 'L'},
	{40, 'XL'},
	{10, 'X'},
	{9, 'IX'},
	{5, 'V'},
	{4, 'IV'},
	{1, 'I'}
}

-- Inventory Item Display Name Table
local itemDisplayNameTable = {
	{"Flashlight", "Flashlight"},
	{"AerosolCan", "Aerosol Can"},
	{"Battery", "Battery"},
	{"ElectronicComponent", "Electronic Component"},
	{"Fuse", "Fuse"},
	{"PropaneTank", "Propane Tank"},
	{"RatDead", "Dead Rat"},
	{"SawBlade", "Saw Blade"},
	{"VialEmpty", "Empty Vial"},
	{"VialWithAcid", "Vial of Acid"},
	{"VialWithAlbinoBlood", "Vial of Albino Blood"},
	{"VialWithPlasma", "Vial of Albino Plasma"},
	{"VialWithPoison", "Vial of Poison"},
	{"VialGunPoison", "Poison Vial Gun"},
	{"FoggerMachine", "Fogger Machine"},
	{"FoggerMachineModded", "Modded Fogger Machine"},
	{"Cheese", "Cheese"},
	{"Coffee", "Coffee"},
	{"Energy", "Energy Drink"},
	{"AirBlaster", "Air Blaster"},
	{"BBGun", "BB Gun"},
	{"CrossbowExplosive", "Explosive Crossbow"},
	{"Flamethrower", "Flamethrower"},
	{"Frag", "Frag Grenade"},
	{"Nailgun", "Nail Gun"},
	{"PlasmaGun", "Plasma Gun"},
	{"Shotgun", "Shotgun"},
	{"VialGunBasic", "Vial Gun"},
	{"VialWithBlood", "Vial of Blood"}
}

-- Death Hinta Table
local deathHintsTable = {
	"The Scientist will Upgrade your Weapons if you give him Vials of Blood!",
	"If you die you will lose any Blood not kept in a Vial!",
	"There are multiple Medical Fridges around the warehouse to put your loose blood into a Vial!",
	"Rats love Cheese, try throwing them some!",
	"Drink Coffee to restore some of your Health!",
	"Try to find Skulls hidden around the warehouse to get better Weapons!",
	"Check out the GamePass Weapons wall for more powerful Weapons!",
	"Try climbing higher to get away from the rats!"
}
-----------------------
-- HUD GUI Functions --
-----------------------

-- Resize Objectives Frame..
local function ResizeObjectiveFrame()
	
	-- GEt Y length Needed..
	local yOffsetNeeded = hudFrame.CurrentObjectivesFrame.UIGridLayout.AbsoluteCellSize.Y * hudFrame.CurrentObjectivesFrame.UIGridLayout.AbsoluteCellCount.Y
	
	-- If offset is not 0..
	if yOffsetNeeded ~= 0 then
		
		-- Give it some extra padding on the bottom
		yOffsetNeeded += 20
	end
	
	-- Do it
	hudFrame.CurrentObjectivesFrame.Size = UDim2.new(hudFrame.CurrentObjectivesFrame.Size.X.Scale , 0, 0, yOffsetNeeded)

end

-- Animate Bag Button
local function AnimateBagButton()
	
	-- If we are still animating.. leave
	if isAnimatingBagButton then return end
	
	-- Debounce
	isAnimatingBagButton = true
	
	-- Original xScale
	local originalXScale = bagButton.Size.X.Scale
	local originalYScale = bagButton.Size.Y.Scale

	-- New Values
	local newYScale = originalYScale + 0.01

	-- ActiveYScale
	local currentYScale = originalYScale

	-- Loop Size Bigger
	while currentYScale < newYScale do

		-- Raise currentYScale
		currentYScale += 0.002

		-- Set UDim2
		bagButton.Size = UDim2.new(originalXScale, 0, currentYScale, 0)

		-- Wait
		task.wait()
	end

	-- Set to Proper
	currentYScale = newYScale

	-- Loop Size Back to Original
	while currentYScale > originalYScale do

		-- Raise currentYScale
		currentYScale -= 0.002

		-- Set UDim2
		bagButton.Size = UDim2.new(originalXScale, 0, currentYScale, 0)

		-- Wait
		task.wait()				
	end

	-- Reset To Proper..
	bagButton.Size = UDim2.new(originalXScale, 0, originalYScale, 0)
	
	-- Nil Stuff
	originalXScale = nil
	originalYScale = nil
	newYScale = nil
	currentYScale = nil
	
	-- Done Animating
	isAnimatingBagButton = false
end

-- Function to Update HUD MEssage
local function UpdateHUDMessage(message, length)
	
	-- Default Constructor
	if not length then length = 3 end

	-- If not already displaying..
	if isDisplayingMessage == false then

		-- Now displaying
		isDisplayingMessage = true

		-- Set Message
		gameMessageTextLabel.Text = message

		-- Play sound
		notificationSound:Play()

		-- Wait, then remove message
		task.wait(length)

		-- Empty Message
		gameMessageTextLabel.Text = ''

		-- No longer displaying Message
		isDisplayingMessage = false
	end
end

-- New Objective Indicator Coroutine
local function AnimatePlayerDiedLabel(playerName)
	
	-- Set Text..
	playerDiedLabel.Text = playerName .. " died!"

	-- Make sure its transparent.
	playerDiedLabel.TextTransparency = 1

	-- turn it on..
	playerDiedLabel.Visible = true

	-- Vars
	local textTransparency = 1

	-- Fad in
	while textTransparency > 0 do

		-- apply it
		playerDiedLabel.TextTransparency = textTransparency

		-- Lower It..
		textTransparency -= 0.1

		-- Wait
		task.wait()
	end

	-- Make it 0
	playerDiedLabel.TextTransparency = 0
	textTransparency = 0

	-- Wait
	task.wait(5)

	-- Fad Away
	while textTransparency < 1 do

		-- apply it
		playerDiedLabel.TextTransparency = textTransparency

		-- Lower It..
		textTransparency += 0.1

		-- Wait
		task.wait()
	end

	-- Make it 1
	playerDiedLabel.TextTransparency = 1
	textTransparency = nil

	-- turn it off
	playerDiedLabel.Visible = false

end

-- New Objective Indicator Coroutine
local function AnimateObjectiveIndicator()
	
	-- Make sure its transparent.
	objectiveIndicatorLabel.TextTransparency = 1
	
	-- turn it on..
	objectiveIndicatorLabel.Visible = true
	
	-- Vars
	local textTransparency = 1
	
	-- Fad in
	while textTransparency > 0 do
		
		-- apply it
		objectiveIndicatorLabel.TextTransparency = textTransparency
		
		-- Lower It..
		textTransparency -= 0.1
		
		-- Wait
		task.wait()
	end
	
	-- Make it 0
	objectiveIndicatorLabel.TextTransparency = 0
	textTransparency = 0
	
	-- Wait
	task.wait(5)
	
	-- Fad Away
	while textTransparency < 1 do

		-- apply it
		objectiveIndicatorLabel.TextTransparency = textTransparency

		-- Lower It..
		textTransparency += 0.1

		-- Wait
		task.wait()
	end
	
	-- Make it 1
	objectiveIndicatorLabel.TextTransparency = 1
	textTransparency = nil
	
	-- turn it off
	objectiveIndicatorLabel.Visible = false
	
end

-- New Objective Indicator Coroutine
local function AnimateObjectiveCompleteIndicator()

	-- Make sure its transparent.
	objectiveCompleteIndicatorLabel.TextTransparency = 1

	-- turn it on..
	objectiveCompleteIndicatorLabel.Visible = true

	-- Vars
	local textTransparency = 1

	-- Fad in
	while textTransparency > 0 do

		-- apply it
		objectiveCompleteIndicatorLabel.TextTransparency = textTransparency

		-- Lower It..
		textTransparency -= 0.1

		-- Wait
		task.wait()
	end

	-- Make it 0
	objectiveCompleteIndicatorLabel.TextTransparency = 0
	textTransparency = 0

	-- Wait
	task.wait(5)

	-- Fad Away
	while textTransparency < 1 do

		-- apply it
		objectiveCompleteIndicatorLabel.TextTransparency = textTransparency

		-- Lower It..
		textTransparency += 0.1

		-- Wait
		task.wait()
	end

	-- Make it 1
	objectiveCompleteIndicatorLabel.TextTransparency = 1
	textTransparency = nil

	-- turn it off
	objectiveCompleteIndicatorLabel.Visible = false

end

-- Function to turn an Int into a Roman Numeral..
function IntToRoman(num)

	-- Var
	local roman = ""

	-- Loop to Make Roman Numeral
	while num > 0 do

		-- For Loop..
		for _, v in pairs(romanNumeralNumberMap) do 

			-- Vars
			local romanChar = v[2]
			local int = v[1]

			-- Loop
			while num >= int do
				roman = roman..romanChar
				num = num - int
			end

			-- Nil Stuff
			romanChar = nil
			int = nil
		end
	end

	-- Return the Value
	return roman
end

-- Seconds to Minutes/Seconds
local function FormatTime(timeNumber)

	-- Ref
	local min, sec = tostring(math.floor(timeNumber / 60)), tostring(timeNumber % 60)

	-- Logic
	if #sec == 1 then
		sec = "0" .. sec
	end

	-- Return string..
	return tostring(min)..":"..tostring(sec)
end

-- Seconds to Minutes/Seconds
local function FormatTimeGameTime(timeNumber)

	-- Millisecond Support..
	local timeSeconds = math.floor(timeNumber)
	local timeMilliseconds = math.round((timeNumber - math.floor(timeNumber)) * 1000)

	-- Ref
	local min, sec = tostring(math.floor(timeSeconds / 60)), tostring(timeSeconds % 60)

	-- Logic
	if #sec == 1 then
		sec = "0" .. sec
	end

	-- Return string..
	return tostring(min)..":"..tostring(sec) .. ":" .. tostring(timeMilliseconds)

end

-- give Player New Objective
local function GivePlayerNewObjective(objectiveArray)
	
	--------------------------------------------
	-- Insert Object into Bag/Objectyive Menu --
	--------------------------------------------
	
	-- Make sure we dont already have this Objective..
	for _, objective in pairs(objectivesFrame.CurrentObjectivesFrame:GetChildren()) do

		-- Make sure its a Text Label
		if objective:IsA("TextLabel") then

			-- Check ID
			if objective.ID.Value == objectiveArray[1] then

				-- leave
				return
			end			
		end	
	end

	-- Determine if its an Objective or a SubObjective..
	if objectiveArray[1] <= 18 or objectiveArray[1] >= 26 then

		-------------------------------------------------------------
		-- Objective Array contains 1. Objective ID, 2. TextString --
		-------------------------------------------------------------

		-- Create New Objective Template and Place into Current Objectives Frame
		local newObjective = objectiveTemplate:Clone()

		-- Change Name
		newObjective.Name = tostring(objectiveArray[1])

		-- Parent
		newObjective.Parent = objectivesFrame.CurrentObjectivesFrame

		-- Set Text
		newObjective.Text = objectiveArray[2]

		-- Set Objective ID
		newObjective.ID.Value = objectiveArray[1]

		-- Turn it visible
		newObjective.Visible = true

		-- show Objective Indicator in a Coroutinre
		local animateGUI = coroutine.create(AnimateObjectiveIndicator)
		coroutine.resume(animateGUI)
		animateGUI = nil
		
		----------------------------------------------
		-- Insert Object Into HUD Objective Liost.. --
		--------------------------------------------

		-- Create New Objective Template and Place into Current Objectives Frame
		local newHUDObjective = hudFrame.CurrentObjectiveTemplate:Clone()

		-- Change Name
		newHUDObjective.Name = tostring(objectiveArray[1])

		-- Parent
		newHUDObjective.Parent = hudFrame.CurrentObjectivesFrame

		-- Set Text
		newHUDObjective.Text = objectiveArray[2]

		-- Set Objective ID
		newHUDObjective.ID.Value = objectiveArray[1]

		-- Turn it visible
		newHUDObjective.Visible = true

		-- Play Sound..
		if not squeal2Sound.IsPlaying then squeal2Sound:Play() end
		
	else
		------------------------------
		-- This is a Subobjective.. --
		------------------------------

		local newSubObjective = subObjectiveTemplate:Clone()

		-- Manually Place Name..
		if objectiveArray[1] >= 19 and objectiveArray[1] <= 21 then

			-- Mission 4 Submission Name
			newSubObjective.Name = "41"

		else

			-- Mission 5 Submissions
			newSubObjective.Name = "51"

		end		

		-- Parent
		newSubObjective.Parent = objectivesFrame.CurrentObjectivesFrame

		-- Set Text
		newSubObjective.Text = objectiveArray[2]

		-- Set Objective ID
		newSubObjective.ID.Value = objectiveArray[1]

		-- Turn it visible
		newSubObjective.Visible = true

	end
	
	-- Now Resize Menu
	ResizeObjectiveFrame()
	
end

-- Complete Objective
local function CompleteObjective(id)
	
	-------------------------------
	-- Clear Bag Objectives Menu --
	-------------------------------
	
	-- Get All Objectives..
	local objectiveList = objectivesFrame.CurrentObjectivesFrame:GetChildren()

	-- Loop Trhough
	for _, child in pairs(objectiveList) do

		-- If its a Text Label..
		if child:IsA("TextLabel") then

			-- Check ID
			if child.ID.Value == id then

				-- Remove It..
				child:Destroy()

				-- Play Notification Sound
				if not runDownSound.IsPlaying then

					-- Play It
					runDownSound:Play()				

				end				
			end
		end
	end

	-- show Objective Indicator in a Coroutinre
	local animateGUI = coroutine.create(AnimateObjectiveCompleteIndicator)
	coroutine.resume(animateGUI)
	animateGUI = nil	

	-- Nil Stuff
	objectiveList = nil
	
	-------------------------------
	-- Clear HUD Objectives Menu --
	-------------------------------
	
	-- Get All Objectives..
	local hudObjectiveList = hudFrame.CurrentObjectivesFrame:GetChildren()

	-- Loop Trhough
	for _, child in pairs(hudObjectiveList) do

		-- If its a Text Label..
		if child:IsA("TextLabel") then

			-- Check ID
			if child.ID.Value == id then

				-- Remove It..
				child:Destroy()
				
			end
		end
	end
	
	-- Nil Stuff
	hudObjectiveList = nil
	
	-- Now Resize Frame
	ResizeObjectiveFrame()
	
end

-- Death GUI with Hints --
local function DeathHintsGUI()
	
	-- Wait 1
	task.wait(1)
	
	-- Set a random hint..
	deathFrame.HintLabel.Text = deathHintsTable[math.random(1, #deathHintsTable)]
	
	-- New Transparency
	local transparency = 1
	
	-- Make sure frame is off
	deathFrame.BackgroundTransparency = transparency
	
	-- Make sure labels are off.
	deathFrame.HintLabel.TextTransparency = transparency
	deathFrame.HintTitleLabel.TextTransparency = transparency
	deathFrame.YouDiedLabel.TextTransparency = transparency
	
	-- Now make it visible
	deathFrame.Visible = true
	
	-- Fade in frame..
	while transparency > 0 do
		
		-- Subtract it
		transparency -= 0.01
		
		-- if less than 0
		if transparency < 0 then transparency = 0 end
		
		-- Set it
		deathFrame.BackgroundTransparency = transparency	
		
		-- wait
		task.wait()
		
	end
	
	-- Wait a sec
	task.wait(0.5)
	
	-- reset transparency
	transparency = 1
	
	-- Now Fade in text
	while transparency > 0 do

		-- Subtract it
		transparency -= 0.1

		-- if less than 0
		if transparency < 0 then transparency = 0 end

		-- Set it
		deathFrame.HintLabel.TextTransparency = transparency
		deathFrame.HintTitleLabel.TextTransparency = transparency
		deathFrame.YouDiedLabel.TextTransparency = transparency	

		-- wait
		task.wait()

	end	
end

----------------------
-- HotBar Functions --
----------------------

-- Get Num of item
local function GetItemCount(itemName)

	-- ItemCount
	local itemCount = 0

	-- Get player Tools..
	local playerTools = thisPlayer.Backpack:GetChildren()

	-- Add Tool in Hand as well
	for _, child in pairs(thisPlayer.Character:GetChildren()) do

		-- If its a tool
		if child:IsA("Tool") then

			-- Add it to the player tools
			table.insert(playerTools, child)
		end
	end

	-- go throuigh them
	for _, tool in pairs(playerTools) do

		-- If its this name..
		if tool.Name == itemName then

			-- Add
			itemCount += 1
		end		
	end

	-- Return it
	return itemCount

end

-- Fully Update Hotbar
local function RefreshHotbar()

	-- Update HotBar..
	for i, hotbarTool in pairs(hotbarTools) do

		-- Skip Empty Ones
		if not hotbarTools[1] then

			-- Go to next one
			continue

		else
			
			-- Get Item Num
			hotbarButtons[i].Count.CountValue.Value = GetItemCount(hotbarTool[1])

		end
	end	
end

-- Unhighlight all hotbars..
local function UnHighlightAllHotBars()

	-- UnHighlight everything else first..
	for i = 1, 9 do

		-- check all hotbar buttons
		hotbarButtons[i].BlueHighlight.Visible = false

	end
end

-- Hightlight Hotbar..
local function HightlightHotBars()

	-- Find this item on the hotbar..
	for i = 1, 9 do
		
		--- Highlight blue..
		hotbarButtons[i].BlueHighlight.Visible = true

	end
end

-- functions to refresh the Hotbar --
local function InitHotbar()

	-- Reset All HotbarButton Counts
	for _, button in pairs(hotbarButtons) do

		-- Set
		button.Count.CountValue.Value = 0

	end

	----------------------
	-- Get Player Tools --
	----------------------

	local playerTools = thisPlayer.Backpack:GetChildren()

	---------------------------------
	-- Now Set Tools to the hotbar --
	---------------------------------

	-- Apply Tools to the Hotbar..
	for _, tool in ipairs(playerTools) do

		-- If we already have this tool on our hotbar..
		for i, hotbarTool in pairs(hotbarTools) do

			-- if its not nill..
			if hotbarTool[1] ~= nil then

				--is it the same as this tool..
				if hotbarTool[1] == tool.Name then

					-- Add hotbarToolCount
					hotbarTool[2] += 1

					-- Just add to hotbarButtonCount
					hotbarButtons[i].Count.CountValue.Value += 1

					-- End this Loop
					break

				end
			else

				-- If we are above 9, cant set anymore hotbars..
				if i <= 9 then

					-- Set Image
					hotbarButtons[i].Image = tool.TextureId

					-- Set it to 1
					hotbarButtons[i].Count.CountValue.Value = 1

					-- Set Tool Value
					hotbarTools[i][1] = tool.Name

					-- Set Tool Count
					hotbarTools[i][2] = 1

					-- Break this Loop
					break

				end
			end
		end		
	end

	-- Nil Stuff
	playerTools = nil

end

-- function that runs when activating a hotbar button..
local function ActivateHotbar(hotbarNumber)

	-- If we are currently activating, leave..
	if isActivatingHotbar then return end

	-- Is Now Activating..
	isActivatingHotbar = true

	---------------------
	-- Ifs, Then Logic --
	---------------------

	-- If we are activating this with a tool thats moving..
	if toolThatsMoving[1] then

		-- If its NOT the same tool thats in the hotbar already..
		if toolThatsMoving[1] ~= hotbarTools[hotbarNumber][1] then

			-- put this tool into this hotbar spot..
			hotbarButtons[hotbarNumber].Image = toolThatsMoving[3]

			-- Add Border if this tool is equipped
			if equippedTool then				
				if toolThatsMoving[1] == equippedTool.Name then

					-- Highlight it..
					hotbarButtons[hotbarNumber].Border.Visible = true

				end				
			end			

			-- Make this hotbartool the new tool..
			hotbarTools[hotbarNumber][1] = toolThatsMoving[1]

			-- Set the Count
			hotbarTools[hotbarNumber][2] = toolThatsMoving[2]

			-- Set hotbarButton Count
			hotbarButtons[hotbarNumber].Count.CountValue.Value = hotbarTools[hotbarNumber][2]

			-- Remove Image from other toolbar spot..
			for i = 1, 9 do

				-- Skip 
				if hotbarTools[i][1] == nil or i == hotbarNumber then continue end

				-- Find the extra..
				if hotbarTools[i][1] == toolThatsMoving[1] then

					-- Remove rthis Image and Tool
					hotbarTools[i][1] = nil

					-- Reset Count
					hotbarTools[i][2] = 0

					-- Image
					hotbarButtons[i].Image = ""

					-- Reset Count
					hotbarButtons[i].Count.CountValue.Value = 0

					-- Remove border
					hotbarButtons[i].Border.Visible = false

					-- Turn off highlight
					hotbarButtons[i].BlueHighlight.Visible = false
				end		

			end			
		end

		-- tool thats moving is nil..
		toolThatsMoving[1] = nil

		-- Reset Count
		toolThatsMoving[2] = 0

		-- Reset TextureID
		toolThatsMoving[3] = nil

		-- Update Tutorial
		if tutorialSetMovingTool == false then tutorialSetMovingTool = true end

		-- Is no longer activating.
		isActivatingHotbar = false

		-- leave function
		return
	end

	-- If no Tool Exists in this Hotbar, LEave
	if hotbarTools[hotbarNumber][1] == nil then

		-- No longer Activating..
		isActivatingHotbar = false

		-- leave
		return
	end

	-- If we have an equipped Tool
	if equippedTool ~= nil then

		-- If we already have this weapon, unequip it..
		if equippedTool.Name == hotbarTools[hotbarNumber][1] then

			-- Unequip
			equippedTool.Parent = thisPlayer.Backpack

			-- No More equipped HotBar
			equippedHotbar = nil

			-- No More Equipped tool
			equippedTool = nil

		else -- Had another Weapon..

			--------------------------
			-- Unequip Current Tool --
			--------------------------

			-- Unequip Current weapon
			equippedTool.Parent = thisPlayer.Backpack

			-- Nil it
			equippedTool = nil

			-- Wait
			task.wait()

			---------------------
			-- Equip This Tool --
			---------------------

			-- Find this tool and equip it.
			for _, child in pairs(thisPlayer.Backpack:GetChildren()) do

				-- once we find one of these tools..
				if child.Name == hotbarTools[hotbarNumber][1] then

					-- Equip it
					child.Parent = thisCharacter

					-- Set Equipped Tool
					equippedTool = child

					-- Set Equipped HotBar
					equippedHotbar = hotbarButtons[hotbarNumber]

					-- Break
					break

				end
			end
		end		
	else -- No Equipped tool

		-- Find this tool and equip it.
		for _, child in pairs(thisPlayer.Backpack:GetChildren()) do			

			-- once we find one of these tools..
			if child.Name == hotbarTools[hotbarNumber][1] then

				-- Equip it
				child.Parent = thisCharacter

				-- Set Equipped Tool
				equippedTool = child

				-- Set Equipped HotBar
				equippedHotbar = hotbarButtons[hotbarNumber]

				-- break
				break

			end
		end
	end

	-- Not Activating ANymore
	isActivatingHotbar = false

end

-----------------------------
-- Weapons Bench Functions --
-----------------------------

-- Function to Fill upgrade boxes
local function FillUpgradeLevelBoxes(weaponString)

	-- Vars
	local damageLevel = nil
	local radiusLevel = nil
	local powerLevel = nil

	-- Get Levels Based on Weapon
	if weaponString == "PlasmaGun" then

		-- Damage level
		damageLevel = thisPlayer.weaponlevels.plasmagundamagelevel.Value
		radiusLevel = thisPlayer.weaponlevels.plasmagunradiuslevel.Value

	elseif weaponString == "Nailgun" then

		-- Damage level
		damageLevel = thisPlayer.weaponlevels.nailgundamagelevel.Value

	elseif weaponString == "CrossbowExplosive" then

		-- Damage level
		damageLevel = thisPlayer.weaponlevels.crossbowexplosivedamagelevel.Value
		radiusLevel = thisPlayer.weaponlevels.crossbowexplosiveradiuslevel.Value

	elseif weaponString == "VialGunBasic" then

		-- Damage level
		damageLevel = thisPlayer.weaponlevels.vialgundamagelevel.Value
		radiusLevel = thisPlayer.weaponlevels.vialgunradiuslevel.Value

	elseif weaponString == "BBGun" then

		-- Damage level
		damageLevel = thisPlayer.weaponlevels.bbgundamagelevel.Value
	elseif weaponString == "Flamethrower" then

		-- Damage level
		damageLevel = thisPlayer.weaponlevels.flamethrowerdamagelevel.Value
	elseif weaponString == "AirBlaster" then

		-- Damage level
		damageLevel = thisPlayer.weaponlevels.airblasterdamagelevel.Value

		-- Power Level
		powerLevel = thisPlayer.weaponlevels.airblasterpowerlevel.Value
	elseif weaponString == "Shotgun" then
		
		-- Damage level
		damageLevel = thisPlayer.weaponlevels.shotgundamagelevel.Value
	end

	----------------------------
	-- Fill in current Damage --
	----------------------------

	-- If we are using Damage
	if damageLevel then		

		-- Get All Level buttons..
		local damageBoxes = currentWeaponFrame.UpgradeLevels.DamageLevels:GetChildren()

		-- Reset Boxes to White..
		for _, v in pairs(damageBoxes) do

			-- If its a frame..
			if v:IsA("Frame") then

				-- Fill Box Red
				v.BackgroundColor3 = Color3.fromRGB(255,255,255)

			end							
		end	

		-- Levels to fill
		local levelsToFill = {}
		if damageLevel == 1 then
			levelsToFill = {"1"}
		elseif damageLevel == 2 then
			levelsToFill = {"1","2"}
		elseif damageLevel == 3 then
			levelsToFill = {"1", "2", "3"}
		elseif damageLevel == 4 then
			levelsToFill = {"1", "2", "3", "4"}
		elseif damageLevel == 5 then
			levelsToFill = {"1", "2", "3", "4", "5"}
		end

		-- Loop Through Frames and Fill in current Level
		for _, v in pairs(damageBoxes) do

			-- If its a frame..
			if v:IsA("Frame") then						

				-- find the same frame as the level
				if table.find(levelsToFill, v.Name) then

					-- Fill Box Red
					v.BackgroundColor3 = Color3.fromRGB(255,0,0)

				end									
			end							
		end	

		-- Nil Stuff
		levelsToFill = nil
		damageBoxes = nil

	end

	----------------------------
	-- Fill in current Radius --
	----------------------------

	-- If we are using Radius
	if radiusLevel then

		-- Get All Level buttons..
		local radiusBoxes = currentWeaponFrame.UpgradeLevels.RadiusLevels:GetChildren()

		-- Reset Boxes to White..
		for _, v in pairs(radiusBoxes) do

			-- If its a frame..
			if v:IsA("Frame") then

				-- Fill Box Red
				v.BackgroundColor3 = Color3.fromRGB(255,255,255)

			end							
		end	

		-- Levels to fill
		local levelsToFill = {}
		if radiusLevel == 1 then
			levelsToFill = {"1"}
		elseif radiusLevel == 2 then
			levelsToFill = {"1","2"}
		elseif radiusLevel == 3 then
			levelsToFill = {"1", "2", "3"}
		elseif radiusLevel == 4 then
			levelsToFill = {"1", "2", "3", "4"}
		elseif radiusLevel == 5 then
			levelsToFill = {"1", "2", "3", "4", "5"}
		end

		-- Loop Through Frames and Fill in current Level
		for _, v in pairs(radiusBoxes) do

			-- If its a frame..
			if v:IsA("Frame") then						

				-- find the same frame as the level
				if table.find(levelsToFill, v.Name) then

					-- Fill Box Red
					v.BackgroundColor3 = Color3.fromRGB(255,0,0)

				end									
			end							
		end

		-- Nil Stuff
		radiusBoxes = nil
		levelsToFill = nil		

	end

	----------------------------
	-- Fill in current Power --
	----------------------------

	-- If we are using Damage
	if powerLevel then

		-- Get All Level buttons..
		local powerBoxes = currentWeaponFrame.UpgradeLevels.PowerLevels:GetChildren()

		-- Reset Boxes to White..
		for _, v in pairs(powerBoxes) do

			-- If its a frame..
			if v:IsA("Frame") then

				-- Fill Box Red
				v.BackgroundColor3 = Color3.fromRGB(255,255,255)

			end							
		end	

		-- Levels to fill
		local levelsToFill = {}
		if powerLevel == 1 then
			levelsToFill = {"1"}
		elseif powerLevel == 2 then
			levelsToFill = {"1","2"}
		elseif powerLevel == 3 then
			levelsToFill = {"1", "2", "3"}
		elseif powerLevel == 4 then
			levelsToFill = {"1", "2", "3", "4"}
		elseif powerLevel == 5 then
			levelsToFill = {"1", "2", "3", "4", "5"}
		end

		-- Loop Through Frames and Fill in current Level
		for _, v in pairs(powerBoxes) do

			-- If its a frame..
			if v:IsA("Frame") then						

				-- find the same frame as the level
				if table.find(levelsToFill, v.Name) then

					-- Fill Box Red
					v.BackgroundColor3 = Color3.fromRGB(255,0,0)

				end									
			end							
		end	

		-- Nil Stuff
		levelsToFill = nil
		powerBoxes = nil

	end

	-- Nil Stuff
	damageLevel = nil
	radiusLevel = nil
	powerLevel = nil

end

-- Get Players Vials
local function GetPlayerVials()

	-- Reset it
	local vials = {}

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

	-------------------------------------------
	-- Loop Through Tools and Create Buttons --
	-------------------------------------------

	-- Go through Toold and Create a new Button
	for _, tool in pairs(playerTools) do

		-- find vials with Blood
		if tool.Name == "VialWithBlood" then

			-- Add to Number of Vials
			table.insert(vials, tool)
		end

	end

	-- Nil Stuff
	playerTools = nil

	-- Return Vials
	return vials

end

-- Open Weapons Bench
local function OpenWeaponsBench()

	-- If the weapons Bench is already open, leave this function..
	if weaponsBenchFrame.Visible == true or playerInBag then return end

	-- Stop Player from moving..
	thisPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 0
	thisPlayer.Character.Humanoid.JumpPower = 0
	
	-- Disable Mouse Cursor
	UIS.MouseIconEnabled = true

	-- Show Weapons Bench Frame
	weaponsBenchFrame.Visible = true
	weaponsGridFrame.Visible = true
	currentWeaponFrame.Visible = false
	hudFrame.Visible = false
	hotbarFrame.Visible = false

	-- focus on exit button (XBOX Support)
	GUIService.SelectedObject = exitButton

	-- While Loop Vars
	playerInWeaponsBench = true
	local exitButtonConnection = nil
	local backButtonConnection = nil
	local vialWithBloodButtonConnection = nil
	local localGamepadBButtonConnection = nil
	local localGamepadBButtonBackConnection = nil
	local guiFocusChangeConnection = nil
	local guiSelectionChangeConnection = nil

	-- State Vars
	local initializedButtons = false

	-- Connection Arrays
	local buttonConnections = {}
	local imageButtons = {}

	-- Other vars
	local vials = {}
	local currentWeapon = nil

	-----------------------------
	-- Main Loop PLayin in GUI --
	-----------------------------

	-- Start while Loop for being in the Weapons Bench
	while playerInWeaponsBench do

		----------------------------
		-- Exit Button Connection --
		----------------------------

		-- Setup Exit Button Connection
		if not exitButtonConnection then

			-- Setup connection
			exitButtonConnection = exitButton.MouseButton1Click:Connect(function()
				
				-- Ui Sound
				uiClickSelect:Play()

				-- End Loop
				playerInWeaponsBench = false

				-- Disconnect
				exitButtonConnection:Disconnect()
				exitButtonConnection = nil

				-- Disconnect Back Button if it was connected
				if backButtonConnection then

					-- Disconnect
					backButtonConnection:Disconnect()
					backButtonConnection = nil
				end

				-- If gamePad connection
				if localGamepadBButtonConnection then

					-- Disconnect
					localGamepadBButtonConnection:Disconnect()
					localGamepadBButtonConnection = nil
				end

			end)
		end	

		-----------------------
		-- Extra Life button --
		-----------------------

		if not vialWithBloodButtonConnection then

			-- Connect It..
			vialWithBloodButtonConnection = weaponsBenchFrame.VialWithBloodButton.MouseButton1Click:Connect(function()
				
				-- Prompt Purchase..
				MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, 1365597254)
				
			end)	
		end
		
		---------------------
		-- Menu GUI Sounds --
		---------------------
		
		-- Play Click when Selection Changes..
		if not guiFocusChangeConnection then

			-- Make Conection
			guiFocusChangeConnection = GUIService.Changed:Connect(function()

				-- Play Sound..
				uiClick:Play()

			end)
		end
		
		------------------
		-- Main If Loop --
		------------------

		-- If we are in Main Weapons Frame..
		if weaponsGridFrame.Visible == true and currentWeaponFrame.Visible == false then

			-- Disconnect Back Button
			if localGamepadBButtonBackConnection then

				-- Disocnne
				localGamepadBButtonBackConnection:Disconnect()
				localGamepadBButtonBackConnection = nil
			end

			-- XBOX Support Exit Button
			if not localGamepadBButtonConnection then

				-- Set it Up
				localGamepadBButtonConnection = UIS.InputBegan:Connect(function(input)

					-- B Button
					if input.KeyCode == Enum.KeyCode.ButtonB then
						
						-- UiSound
						uiClickSelect:Play()

						-- End Loop
						playerInWeaponsBench = false

						----------------------------------------------
						-- Delete All prior buttons and connections --
						----------------------------------------------

						for _, connection in pairs(buttonConnections) do

							-- Disconnect
							connection:Disconnect()
							connection = nil
						end

						-- Delet Images
						for _, imageButton in pairs(imageButtons) do

							-- Destroy
							imageButton:Destroy()
						end

						-- Disconnect
						localGamepadBButtonConnection:Disconnect()
						localGamepadBButtonConnection = nil

						-- Disconnect Back Button if it was connected
						if backButtonConnection then

							-- Disconnect
							backButtonConnection:Disconnect()
							backButtonConnection = nil
						end

						-- Close Exit Button Connection
						if exitButtonConnection then

							-- Disconnect
							exitButtonConnection:Disconnect()
							exitButtonConnection = nil
						end

					end
				end)			
			end

			-- If we have not yet Created the buttons... Create Them..
			if initializedButtons == false then

				-- Now we have init the Buttons
				initializedButtons = true

				-----------------------------------
				-- Initialize and Create Buttons --
				-----------------------------------

				-- Back button Invisble
				backButton.Visible = false

				----------------------------------------------
				-- Delete All prior buttons and connections --
				----------------------------------------------

				for _, connection in pairs(buttonConnections) do

					-- Disconnect
					connection:Disconnect()
					connection = nil
				end

				-- Delet Images
				for _, imageButton in pairs(imageButtons) do

					-- Destroy
					imageButton:Destroy()
				end		

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

				-------------------------------------------
				-- Loop Through Tools and Create Buttons --
				-------------------------------------------

				-- Go through Toold and Create a new Button
				for _, tool in pairs(playerTools) do

					-- Set Image and Connection Based on Weapon
					if tool.Name == "PlasmaGun" then

						-- Create Image Button
						local newImageButton = Instance.new("ImageButton")
						newImageButton.Parent = script.Parent.WeaponsBenchFrame.WeaponsGridFrame

						-- Put into Table
						table.insert(imageButtons, newImageButton)

						-- Set Image and Connection
						newImageButton.Image = tool.TextureId

						-- New Connection
						local plasmaGunConnection = nil

						-- Make Connection
						plasmaGunConnection = newImageButton.MouseButton1Click:Connect(function()

							-- Close weapons frame.
							weaponsGridFrame.Visible = false

							-- Open Frame for this weapon..
							currentWeaponFrame.Visible = true

							-- reset init button
							initializedButtons = false

							-- Set current Weapon
							currentWeapon = tool

						end)

						-- Add this to the Button Connections
						table.insert(buttonConnections, plasmaGunConnection)

					elseif tool.Name == "Nailgun" then

						-- Create Image Button
						local newImageButton = Instance.new("ImageButton")
						newImageButton.Parent = script.Parent.WeaponsBenchFrame.WeaponsGridFrame

						-- Put into Table
						table.insert(imageButtons, newImageButton)

						-- Set Image and Connection
						newImageButton.Image = tool.TextureId

						-- New Connection
						local nailgunConnection = nil

						-- Make Connection
						nailgunConnection = newImageButton.MouseButton1Click:Connect(function()

							-- Close weapons frame.
							weaponsGridFrame.Visible = false

							-- Open Frame for this weapon..
							currentWeaponFrame.Visible = true

							-- reset init button
							initializedButtons = false

							-- Set current Weapon
							currentWeapon = tool


						end)

						-- Add this to the Button Connections
						table.insert(buttonConnections, nailgunConnection)					

					elseif tool.Name == "CrossbowExplosive" then

						-- Create Image Button
						local newImageButton = Instance.new("ImageButton")
						newImageButton.Parent = script.Parent.WeaponsBenchFrame.WeaponsGridFrame

						-- Put into Table
						table.insert(imageButtons, newImageButton)

						-- Set Image and Connection
						newImageButton.Image = tool.TextureId

						-- New Connection
						local crossbowExplosiveConnection = nil

						-- Make Connection
						crossbowExplosiveConnection = newImageButton.MouseButton1Click:Connect(function()

							-- Close weapons frame.
							weaponsGridFrame.Visible = false

							-- Open Frame for this weapon..
							currentWeaponFrame.Visible = true

							-- reset init button
							initializedButtons = false

							-- Set current Weapon
							currentWeapon = tool

						end)

						-- Add this to the Button Connections
						table.insert(buttonConnections, crossbowExplosiveConnection)

					elseif tool.Name == "VialGunBasic" then

						-- Create Image Button
						local newImageButton = Instance.new("ImageButton")
						newImageButton.Parent = weaponsGridFrame

						-- Put into Table
						table.insert(imageButtons, newImageButton)

						-- Set Image and Connection
						newImageButton.Image = tool.TextureId

						-- New Connection
						local vialGunBasicConnection = nil

						-- Make Connection
						vialGunBasicConnection = newImageButton.MouseButton1Click:Connect(function()

							-- Close weapons frame.
							weaponsGridFrame.Visible = false

							-- Open Frame for this weapon..
							currentWeaponFrame.Visible = true

							-- reset init button
							initializedButtons = false

							-- Set current Weapon
							currentWeapon = tool

						end)

						-- Add this to the Button Connections
						table.insert(buttonConnections, vialGunBasicConnection)						

					elseif tool.Name == "BBGun" then

						-- Create Image Button
						local newImageButton = Instance.new("ImageButton")
						newImageButton.Parent = weaponsGridFrame

						-- Put into Table
						table.insert(imageButtons, newImageButton)

						-- Set Image and Connection
						newImageButton.Image = tool.TextureId

						-- New Connection
						local BBGunConnection = nil

						-- Make Connection
						BBGunConnection = newImageButton.MouseButton1Click:Connect(function()

							-- Close weapons frame.
							weaponsGridFrame.Visible = false

							-- Open Frame for this weapon..
							currentWeaponFrame.Visible = true

							-- reset init button
							initializedButtons = false

							-- Set current Weapon
							currentWeapon = tool

						end)

						-- Add this to the Button Connections
						table.insert(buttonConnections, BBGunConnection)

					elseif tool.Name == "Flamethrower" then

						-- Create Image Button
						local newImageButton = Instance.new("ImageButton")
						newImageButton.Parent = weaponsGridFrame

						-- Put into Table
						table.insert(imageButtons, newImageButton)

						-- Set Image and Connection
						newImageButton.Image = tool.TextureId

						-- New Connection
						local flameThrowerConnection = nil

						-- Make Connection
						flameThrowerConnection = newImageButton.MouseButton1Click:Connect(function()

							-- Close weapons frame.
							weaponsGridFrame.Visible = false

							-- Open Frame for this weapon..
							currentWeaponFrame.Visible = true

							-- reset init button
							initializedButtons = false

							-- Set current Weapon
							currentWeapon = tool

						end)

						-- Add this to the Button Connections
						table.insert(buttonConnections, flameThrowerConnection)

					elseif tool.Name == "AirBlaster" then

						-- Create Image Button
						local newImageButton = Instance.new("ImageButton")
						newImageButton.Parent = weaponsGridFrame

						-- Put into Table
						table.insert(imageButtons, newImageButton)

						-- Set Image and Connection
						newImageButton.Image = tool.TextureId

						-- New Connection
						local airBlasterConnection = nil

						-- Make Connection
						airBlasterConnection = newImageButton.MouseButton1Click:Connect(function()

							-- Close weapons frame.
							weaponsGridFrame.Visible = false

							-- Open Frame for this weapon..
							currentWeaponFrame.Visible = true

							-- reset init button
							initializedButtons = false

							-- Set current Weapon
							currentWeapon = tool

						end)

						-- Add this to the Button Connections
						table.insert(buttonConnections, airBlasterConnection)					

					elseif tool.Name == "Shotgun" then

						-- Create Image Button
						local newImageButton = Instance.new("ImageButton")
						newImageButton.Parent = weaponsGridFrame

						-- Put into Table
						table.insert(imageButtons, newImageButton)

						-- Set Image and Connection
						newImageButton.Image = tool.TextureId

						-- New Connection
						local shotgunConnection = nil

						-- Make Connection
						shotgunConnection = newImageButton.MouseButton1Click:Connect(function()

							-- Close weapons frame.
							weaponsGridFrame.Visible = false

							-- Open Frame for this weapon..
							currentWeaponFrame.Visible = true

							-- reset init button
							initializedButtons = false

							-- Set current Weapon
							currentWeapon = tool

						end)

						-- Add this to the Button Connections
						table.insert(buttonConnections, shotgunConnection)					

					end
				end

				-- Nil Stuff
				playerTools = nil

			end			

		elseif weaponsGridFrame.Visible == false and currentWeaponFrame.Visible == true then -- Now We are in Current Weapon Upgrade Window

			-- Setup Back Button Connection
			if not backButtonConnection then

				-- Setup connection
				backButtonConnection = backButton.MouseButton1Click:Connect(function()
					
					-- Play GUI Select sound.
					uiClickSelect:Play()

					-- Make this window dissapear
					currentWeaponFrame.Visible = false

					-- show Main Weapon Screen
					weaponsGridFrame.Visible = true

					-- Reset init buttons
					initializedButtons = false

					-- Disconnect
					backButtonConnection:Disconnect()
					backButtonConnection = nil

					-- Gamepad Disconnect
					if localGamepadBButtonBackConnection then

						-- Diseonnct
						localGamepadBButtonBackConnection:Disconnect()
						localGamepadBButtonBackConnection = nil
					end

				end)

			end

			-- Xbox Back Button Connection
			if not localGamepadBButtonBackConnection then

				-- Disconnect Exit Back button
				localGamepadBButtonConnection:Disconnect()
				localGamepadBButtonConnection = nil

				-- Setup connection
				localGamepadBButtonBackConnection = UIS.InputBegan:Connect(function(input)

					-- B Button
					if input.KeyCode == Enum.KeyCode.ButtonB then
						
						-- UI sound
						uiClickSelect:Play()

						-- Make this window dissapear
						currentWeaponFrame.Visible = false

						-- show Main Weapon Screen
						weaponsGridFrame.Visible = true

						-- Reset init buttons
						initializedButtons = false

						-- Disconnect
						localGamepadBButtonBackConnection:Disconnect()
						localGamepadBButtonBackConnection = nil	

						-- Back Button Disconnect
						if backButtonConnection then

							-- Disconnect
							backButtonConnection:Disconnect()
							backButtonConnection = nil
						end

					end
				end)
			end

			-- If we havent init
			if initializedButtons == false then

				-- init them
				initializedButtons = true

				-- show Back Button
				backButton.Visible = true

				----------------------------------------------
				-- Delete All prior buttons and connections --
				----------------------------------------------

				for _, connection in pairs(buttonConnections) do

					-- Disconnect
					connection:Disconnect()
					connection = nil
				end	

				-----------------------------------------
				-- Update Image and Fill Level Boxes.. --
				-----------------------------------------

				-- check for Current Weapon
				if currentWeapon.Name == "PlasmaGun" then

					-- Set Image Label to Plasma
					currentWeaponFrame.Image.WeaponImage.Image = currentWeapon.TextureId

					-- Get Current Weaopon Levels
					local damageLevel = thisPlayer.weaponlevels.plasmagundamagelevel.Value
					local radiusLevel = thisPlayer.weaponlevels.plasmagunradiuslevel.Value

					-------------------------------------------------------
					-- If Upgrades Levels Are Maxed out, Hide Some Stuff --
					-------------------------------------------------------

					-- If Damage is Max Level..
					if damageLevel == 5 then

						-- Hide Cost and Button
						currentWeaponFrame.Buttons.DamageUpgradeButton.Visible = false
						currentWeaponFrame.Labels.DamageCost.Visible = false

					else

						-- Show it
						currentWeaponFrame.Buttons.DamageUpgradeButton.Visible = true
						currentWeaponFrame.Labels.DamageCost.Visible = true
						currentWeaponFrame.Labels.DamageCost.Text = tostring(damageLevel)
					end

					-- If Radius is Max Level..
					if radiusLevel == 5 then

						-- Hide Button and Cost
						currentWeaponFrame.Buttons.RadiusUpgradeButton.Visible = false
						currentWeaponFrame.Labels.RadiusCost.Visible = false

					else

						-- show It
						currentWeaponFrame.Buttons.RadiusUpgradeButton.Visible = true
						currentWeaponFrame.Labels.RadiusCost.Visible = true
						currentWeaponFrame.Labels.RadiusCost.Text = tostring(radiusLevel)

					end						

					-- Default Radius Stuff..
					currentWeaponFrame.Labels.RadiusLabel.Visible = true
					currentWeaponFrame.UpgradeLevels.RadiusLevels.Visible = true

					-- Default Damage Stuff
					currentWeaponFrame.Labels.DamageLabel.Visible = true
					currentWeaponFrame.UpgradeLevels.DamageLevels.Visible = true

					-- Turn off Special Upgrades
					currentWeaponFrameSpecialUpgradeButton.Visible = false
					currentWeaponFrame.Labels.SpecialCost.Visible = false
					currentWeaponFrame.Labels.SpecialLabel.Visible = false

					-- Turn Off Power Levels
					currentWeaponFrame.Buttons.PowerUpgradeButton.Visible = false
					currentWeaponFrame.Labels.PowerCost.Visible = false
					currentWeaponFrame.Labels.PowerLabel.Visible = false
					currentWeaponFrame.UpgradeLevels.PowerLevels.Visible = false

					--------------------------------------
					-- Damage Upgrade button connection --
					--------------------------------------

					-- Create Upgrade button Connections
					local damageUpgradeButtonConnection = nil

					-- DamageUpgradeButton
					damageUpgradeButtonConnection = currentWeaponFrameDamageUpgradeButton.MouseButton1Click:Connect(function()
						
						-- Get Player Vials
						vials = GetPlayerVials()
						
						-- If we have no vials, but have blood..
						if #vials == 0 then
							
							-- If we have no blood..
							if thisPlayer.blood.Value == 0 then
								
								-- Not Enogh Blood
								notEnoughBloodAudioArray[math.random(1,2)]:Play()
							else
								
								-- Need that in a vial..
								needThatInVial:Play()
							end						

							-- Exit
							return
						end

						-- Get Player Gun Level
						local currentDamageLevel = thisPlayer.weaponlevels.plasmagundamagelevel.Value

						-- check if Player has enough vials
						if #vials >= currentDamageLevel then

							-- Take Needed Vials from Player..
							for i = 1, currentDamageLevel do

								-- Destroy Vials
								vials[1]:Destroy()

								-- If this tool was in the Hotbar, remove it..
								for i = 1, 9 do

									-- If they match
									if hotbarTools[i][1] == vials[1] then

										-- Remove It
										hotbarTools[i][1] = nil
										
										-- Reset Count
										hotbarTools[i][2] = 0

										-- Remove image
										hotbarButtons[i].Image = ""
										
										-- Reset Count
										hotbarButtons[i].Count.CountValue.Value = 0

									end

								end	

								-- Remove this Tool Server Side
								game.ReplicatedStorage.RemoveToolFromPlayerServerSide:FireServer(vials[1])

								-- Delete from tbale
								table.remove(vials, 1)
							end
					

							-- Update Weapon Levels from the server
							game.ReplicatedStorage.UpdateWeaponLevelsServerSide:FireServer("plasmagundamagelevel")

							-- Update Local weapon level
							thisPlayer.weaponlevels.plasmagundamagelevel.Value += 1

							-- Refill in new boxed..
							FillUpgradeLevelBoxes(currentWeapon.Name)

							-- Update
							currentDamageLevel = thisPlayer.weaponlevels.plasmagundamagelevel.Value

							-- Update Cost Labels
							if currentDamageLevel == 5 then

								-- Hide Cost and Button
								currentWeaponFrame.Buttons.DamageUpgradeButton.Visible = false
								currentWeaponFrame.Labels.DamageCost.Visible = false

							else

								-- Update It..
								currentWeaponFrame.Labels.DamageCost.Text = tostring(currentDamageLevel)								
							end
							
							-- Play Scientist Sound..
							local random = math.random(1, #thanksAudioArray)
							thanksAudioArray[random]:Play()
							random = nil
							
						else
							
							-- Not Enough Vials
							notEnoughBloodAudioArray[math.random(1,2)]:Play()
							
						end	

						-- Nil Stuff
						currentDamageLevel = nil

					end)

					-- Add to button connections
					table.insert(buttonConnections, damageUpgradeButtonConnection)

					--------------------------------------
					-- Radius Upgrade button connection --
					--------------------------------------

					-- RadiusUpgrade
					local radiusUpgradeButtonConnection = nil

					-- DamageUpgradeButton
					radiusUpgradeButtonConnection = currentWeaponFrameRadiusUpgradeButton.MouseButton1Click:Connect(function()
						
						-- Get Player Vials
						vials = GetPlayerVials()

						-- If we have no vials, but have blood..
						if #vials == 0 then

							-- If we have no blood..
							if thisPlayer.blood.Value == 0 then

								-- Not Enogh Blood
								notEnoughBloodAudioArray[math.random(1,2)]:Play()
								
							else

								-- Need that in a vial..
								needThatInVial:Play()
							end						

							-- Exit
							return
						end

						-- Get Player Gun Level
						local currentRadiusLevel = thisPlayer.weaponlevels.plasmagunradiuslevel.Value

						-- check if Player has enough vials
						if #vials >= currentRadiusLevel then

							-- Take Needed Vials from Player..
							for i = 1, currentRadiusLevel do

								-- Destroy Vials
								vials[1]:Destroy()

								-- If this tool was in the Hotbar, remove it..
								for i = 1, 9 do

									-- If they match
									if hotbarTools[i][1] == vials[1] then

										-- Remove It
										hotbarTools[i][1] = nil
										
										-- Reset Count
										hotbarTools[i][2] = 0

										-- Remove image
										hotbarButtons[i].Image = ""
										
										-- Reset Count
										hotbarButtons[i].Count.CountValue.Value = 0

									end

								end	

								-- Remove this Tool Server Side
								game.ReplicatedStorage.RemoveToolFromPlayerServerSide:FireServer(vials[1])

								-- Delete from tbale
								table.remove(vials, 1)

							end		

							-- Update Weapon Levels from the server
							game.ReplicatedStorage.UpdateWeaponLevelsServerSide:FireServer("plasmagunradiuslevel")

							-- Update Local weapon level
							thisPlayer.weaponlevels.plasmagunradiuslevel.Value += 1

							-- Refill in new boxed..
							FillUpgradeLevelBoxes(currentWeapon.Name)

							-- ReLoad Radius Level
							currentRadiusLevel = thisPlayer.weaponlevels.plasmagunradiuslevel.Value

							-- Update Cost Labels
							if currentRadiusLevel == 5 then

								-- Hide Button and Cost
								currentWeaponFrame.Buttons.RadiusUpgradeButton.Visible = false
								currentWeaponFrame.Labels.RadiusCost.Visible = false
							else

								-- Update It
								currentWeaponFrame.Labels.RadiusCost.Text = tostring(currentRadiusLevel)								
							end
							
							-- Play Scientist Sound..
							local random = math.random(1, #thanksAudioArray)
							thanksAudioArray[random]:Play()
							random = nil

						else

							-- Not Enough Vials
							notEnoughBloodAudioArray[math.random(1,2)]:Play()

						end		

						-- Nil Stuff
						currentRadiusLevel = nil

					end)

					-- Add to button connections
					table.insert(buttonConnections, radiusUpgradeButtonConnection)

				elseif currentWeapon.Name == "Nailgun" then

					-- Set Image Label to Plasma
					currentWeaponFrame.Image.WeaponImage.Image = currentWeapon.TextureId

					-- Get Current Weaopon Levels
					local damageLevel = thisPlayer.weaponlevels.nailgundamagelevel.Value

					-- If Damage is Max Level..
					if damageLevel == 5 then

						-- Hide Cost and Button
						currentWeaponFrame.Buttons.DamageUpgradeButton.Visible = false
						currentWeaponFrame.Labels.DamageCost.Visible = false

					else

						-- Show it
						currentWeaponFrame.Buttons.DamageUpgradeButton.Visible = true
						currentWeaponFrame.Labels.DamageCost.Visible = true
						currentWeaponFrame.Labels.DamageCost.Text = tostring(damageLevel)
					end

					-- Default Damage Stuff
					currentWeaponFrame.Labels.DamageLabel.Visible = true
					currentWeaponFrame.UpgradeLevels.DamageLevels.Visible = true

					-- turn off "Radius" Levels
					currentWeaponFrame.Buttons.RadiusUpgradeButton.Visible = false
					currentWeaponFrame.Labels.RadiusCost.Visible = false
					currentWeaponFrame.Labels.RadiusLabel.Visible = false
					currentWeaponFrame.UpgradeLevels.RadiusLevels.Visible = false

					-- Turn Off Power Levels
					currentWeaponFrame.Buttons.PowerUpgradeButton.Visible = false
					currentWeaponFrame.Labels.PowerCost.Visible = false
					currentWeaponFrame.Labels.PowerLabel.Visible = false
					currentWeaponFrame.UpgradeLevels.PowerLevels.Visible = false

					------------------------------
					-- Turn on Special Upgrades --
					------------------------------

					-- Only show upgrade stuff if we dont have this upgrade..
					if thisPlayer.weaponlevels.nailgunspecialupgrade.Value == false then

						-- Turn on Special upgrade Button
						currentWeaponFrameSpecialUpgradeButton.Visible = true
						currentWeaponFrame.Labels.SpecialCost.Visible = true
						currentWeaponFrame.Labels.SpecialLabel.Visible = true
						currentWeaponFrame.Labels.SpecialLabel.Text = "Automatic Conversion"
						currentWeaponFrame.Labels.SpecialCost.Text = "3"

					else

						-- Turn it off
						currentWeaponFrameSpecialUpgradeButton.Visible = false
						currentWeaponFrame.Labels.SpecialCost.Visible = false
						currentWeaponFrame.Labels.SpecialLabel.Visible = false
					end

					--------------------------------------
					-- Damage Upgrade button connection --
					--------------------------------------

					-- Create Upgrade button Connections
					local damageUpgradeButtonConnection = nil

					-- DamageUpgradeButton
					damageUpgradeButtonConnection = currentWeaponFrameDamageUpgradeButton.MouseButton1Click:Connect(function()
						
						-- Get Player Vials
						vials = GetPlayerVials()

						-- If we have no vials, but have blood..
						if #vials == 0 then

							-- If we have no blood..
							if thisPlayer.blood.Value == 0 then

								-- Not Enogh Blood
								notEnoughBloodAudioArray[math.random(1,2)]:Play()
							else

								-- Need that in a vial..
								needThatInVial:Play()
							end						

							-- Exit
							return
						end

						-- Get Player Gun Level
						local currentDamageLevel = thisPlayer.weaponlevels.nailgundamagelevel.Value

						-- check if Player has enough vials
						if #vials >= currentDamageLevel then

							-- Take Needed Vials from Player..
							for i = 1, currentDamageLevel do

								-- Destroy Vials
								vials[1]:Destroy()

								-- If this tool was in the Hotbar, remove it..
								for i = 1, 9 do

									-- If they match
									if hotbarTools[i][1] == vials[1] then

										-- Remove It
										hotbarTools[i][1] = nil
										
										-- Reset Count
										hotbarTools[i][2] = 0

										-- Remove image
										hotbarButtons[i].Image = ""
										
										-- Reset Count
										hotbarButtons[i].Count.CountValue.Value = 0

									end

								end	

								-- Remove this Tool Server Side
								game.ReplicatedStorage.RemoveToolFromPlayerServerSide:FireServer(vials[1])

								-- Delete from tbale
								table.remove(vials, 1)
							end						

							-- Update Weapon Levels from the server
							game.ReplicatedStorage.UpdateWeaponLevelsServerSide:FireServer("nailgundamagelevel")

							-- Update Local weapon level
							thisPlayer.weaponlevels.nailgundamagelevel.Value += 1

							-- Refill in new boxed..
							FillUpgradeLevelBoxes(currentWeapon.Name)

							-- Update
							currentDamageLevel = thisPlayer.weaponlevels.nailgundamagelevel.Value

							-- Update Cost Labels
							if currentDamageLevel == 5 then

								-- Hide Cost and Button
								currentWeaponFrame.Buttons.DamageUpgradeButton.Visible = false
								currentWeaponFrame.Labels.DamageCost.Visible = false

							else

								-- Update It..
								currentWeaponFrame.Labels.DamageCost.Text = tostring(currentDamageLevel)								
							end
							
							-- Play Scientist Sound..
							local random = math.random(1, #thanksAudioArray)
							thanksAudioArray[random]:Play()
							random = nil

						else

							-- Not Enough Vials
							notEnoughBloodAudioArray[math.random(1,2)]:Play()

						end	

						-- Nil
						currentDamageLevel = nil

					end)

					-- Add to button connections
					table.insert(buttonConnections, damageUpgradeButtonConnection)

					----------------------------
					-- Special Upgrade button --
					----------------------------

					local specialUpgradeButtonConnection = nil

					-- Special Upgrade button
					specialUpgradeButtonConnection = currentWeaponFrameSpecialUpgradeButton.MouseButton1Click:Connect(function()
						-- Get Player Vials
						vials = GetPlayerVials()

						-- If we have no vials, but have blood..
						if #vials == 0 then

							-- If we have no blood..
							if thisPlayer.blood.Value == 0 then

								-- Not Enogh Blood
								notEnoughBloodAudioArray[math.random(1,2)]:Play()
							else

								-- Need that in a vial..
								needThatInVial:Play()
							end						

							-- Exit
							return
						end

						-- check if Player has enough vials
						if #vials >= 3 then

							-- Take Needed Vials from Player..
							for i = 1, 3 do

								-- Destroy Vials
								vials[1]:Destroy()

								-- If this tool was in the Hotbar, remove it..
								for i = 1, 9 do

									-- If they match
									if hotbarTools[i][1] == vials[1] then

										-- Remove It
										hotbarTools[i][1] = nil
										
										-- Reset Count
										hotbarTools[i][2] = 0

										-- Remove image
										hotbarButtons[i].Image = ""
										
										-- Reset Count
										hotbarButtons[i].Count.CountValue.Value = 0

									end

								end	

								-- Remove this Tool Server Side
								game.ReplicatedStorage.RemoveToolFromPlayerServerSide:FireServer(vials[1])

								-- Delete from tbale
								table.remove(vials, 1)
							end

							-- Update Auto Conversion Value in Player From server..
							game.ReplicatedStorage.UpdateWeaponLevelsServerSide:FireServer("nailgunspecialupgrade")

							-- Turn it off now..
							currentWeaponFrameSpecialUpgradeButton.Visible = false
							currentWeaponFrame.Labels.SpecialCost.Visible = false
							currentWeaponFrame.Labels.SpecialLabel.Visible = false
							
							-- Play Scientist Sound..
							local random = math.random(1, #thanksAudioArray)
							thanksAudioArray[random]:Play()
							random = nil

						else

							-- Not Enough Vials
							notEnoughBloodAudioArray[math.random(1,2)]:Play()

						end						

					end)

					-- Add to button connections
					table.insert(buttonConnections, specialUpgradeButtonConnection)

				elseif currentWeapon.Name == "CrossbowExplosive" then

					-- Set Image Label to Plasma
					currentWeaponFrame.Image.WeaponImage.Image = currentWeapon.TextureId

					-- Get Current Weaopon Levels
					local damageLevel = thisPlayer.weaponlevels.crossbowexplosivedamagelevel.Value
					local radiusLevel = thisPlayer.weaponlevels.crossbowexplosiveradiuslevel.Value

					-------------------------------------------------------
					-- If Upgrades Levels Are Maxed out, Hide Some Stuff --
					-------------------------------------------------------

					-- If Damage is Max Level..
					if damageLevel == 5 then

						-- Hide Cost and Button
						currentWeaponFrame.Buttons.DamageUpgradeButton.Visible = false
						currentWeaponFrame.Labels.DamageCost.Visible = false

					else

						-- Show it
						currentWeaponFrame.Buttons.DamageUpgradeButton.Visible = true
						currentWeaponFrame.Labels.DamageCost.Visible = true
						currentWeaponFrame.Labels.DamageCost.Text = tostring(damageLevel)
					end

					-- If Radius is Max Level..
					if radiusLevel == 5 then

						-- Hide Button and Cost
						currentWeaponFrame.Buttons.RadiusUpgradeButton.Visible = false
						currentWeaponFrame.Labels.RadiusCost.Visible = false

					else

						-- show It
						currentWeaponFrame.Buttons.RadiusUpgradeButton.Visible = true
						currentWeaponFrame.Labels.RadiusCost.Visible = true
						currentWeaponFrame.Labels.RadiusCost.Text = tostring(radiusLevel)

					end

					-- Default Radius Stuff..
					currentWeaponFrame.Labels.RadiusLabel.Visible = true
					currentWeaponFrame.UpgradeLevels.RadiusLevels.Visible = true

					-- Default Damage Stuff
					currentWeaponFrame.Labels.DamageLabel.Visible = true
					currentWeaponFrame.UpgradeLevels.DamageLevels.Visible = true

					-- Turn off Special Upgrades
					currentWeaponFrameSpecialUpgradeButton.Visible = false
					currentWeaponFrame.Labels.SpecialCost.Visible = false
					currentWeaponFrame.Labels.SpecialLabel.Visible = false

					-- Turn Off Power Levels
					currentWeaponFrame.Buttons.PowerUpgradeButton.Visible = false
					currentWeaponFrame.Labels.PowerCost.Visible = false
					currentWeaponFrame.Labels.PowerLabel.Visible = false
					currentWeaponFrame.UpgradeLevels.PowerLevels.Visible = false

					--------------------------------------
					-- Damage Upgrade button connection --
					--------------------------------------

					-- Create Upgrade button Connections
					local damageUpgradeButtonConnection = nil

					-- DamageUpgradeButton
					damageUpgradeButtonConnection = currentWeaponFrameDamageUpgradeButton.MouseButton1Click:Connect(function()
						
						-- Get Player Vials
						vials = GetPlayerVials()

						-- If we have no vials, but have blood..
						if #vials == 0 then

							-- If we have no blood..
							if thisPlayer.blood.Value == 0 then

								-- Not Enogh Blood
								notEnoughBloodAudioArray[math.random(1,2)]:Play()
							else

								-- Need that in a vial..
								needThatInVial:Play()
							end						

							-- Exit
							return
						end

						-- Get Player Gun Level
						local currentDamageLevel = thisPlayer.weaponlevels.crossbowexplosivedamagelevel.Value

						-- check if Player has enough vials
						if #vials >= currentDamageLevel then

							-- Take Needed Vials from Player..
							for i = 1, currentDamageLevel do

								-- Destroy Vials
								vials[1]:Destroy()

								-- If this tool was in the Hotbar, remove it..
								for i = 1, 9 do

									-- If they match
									if hotbarTools[i][1] == vials[1] then

										-- Remove It
										hotbarTools[i][1] = nil
										
										-- Reset Count
										hotbarTools[i][2] = 0

										-- Remove image
										hotbarButtons[i].Image = ""
										
										-- Reset Count
										hotbarButtons[i].Count.CountValue.Value = 0

									end

								end	

								-- Remove this Tool Server Side
								game.ReplicatedStorage.RemoveToolFromPlayerServerSide:FireServer(vials[1])

								-- Delete from tbale
								table.remove(vials, 1)
							end						

							-- Update Weapon Levels from the server
							game.ReplicatedStorage.UpdateWeaponLevelsServerSide:FireServer("crossbowexplosivedamagelevel")

							-- Update Local weapon level
							thisPlayer.weaponlevels.crossbowexplosivedamagelevel.Value += 1

							-- Refill in new boxed..
							FillUpgradeLevelBoxes(currentWeapon.Name)

							-- Update It..
							currentDamageLevel = thisPlayer.weaponlevels.crossbowexplosivedamagelevel.Value

							-- Update Cost Labels
							if currentDamageLevel == 5 then

								-- Hide Cost and Button
								currentWeaponFrame.Buttons.DamageUpgradeButton.Visible = false
								currentWeaponFrame.Labels.DamageCost.Visible = false

							else

								-- Update It..
								currentWeaponFrame.Labels.DamageCost.Text = tostring(currentDamageLevel)								
							end
							
							-- Play Scientist Sound..
							local random = math.random(1, #thanksAudioArray)
							thanksAudioArray[random]:Play()
							random = nil
							
						else

							-- Not Enough Vials
							notEnoughBloodAudioArray[math.random(1,2)]:Play()

						end	
					end)

					-- Add to button connections
					table.insert(buttonConnections, damageUpgradeButtonConnection)

					--------------------------------------
					-- Radius Upgrade button connection --
					--------------------------------------

					-- RadiusUpgrade
					local radiusUpgradeButtonConnection = nil

					-- DamageUpgradeButton
					radiusUpgradeButtonConnection = currentWeaponFrameRadiusUpgradeButton.MouseButton1Click:Connect(function()
						
						-- Get Player Vials
						vials = GetPlayerVials()

						-- If we have no vials, but have blood..
						if #vials == 0 then

							-- If we have no blood..
							if thisPlayer.blood.Value == 0 then

								-- Not Enogh Blood
								notEnoughBloodAudioArray[math.random(1,2)]:Play()
							else

								-- Need that in a vial..
								needThatInVial:Play()
							end						

							-- Exit
							return
						end

						-- Get Player Gun Level
						local currentRadiusLevel = thisPlayer.weaponlevels.crossbowexplosiveradiuslevel.Value

						-- check if Player has enough vials
						if #vials >= currentRadiusLevel then

							-- Take Needed Vials from Player..
							for i = 1, currentRadiusLevel do

								-- Destroy Vials
								vials[1]:Destroy()

								-- If this tool was in the Hotbar, remove it..
								for i = 1, 9 do

									-- If they match
									if hotbarTools[i][1] == vials[1] then

										-- Remove It
										hotbarTools[i][1] = nil
										
										-- Reset Count
										hotbarTools[i][2] = 0

										-- Remove image
										hotbarButtons[i].Image = ""
										
										-- Reset Count
										hotbarButtons[i].Count.CountValue.Value = 0

									end

								end	

								-- Remove this Tool Server Side
								game.ReplicatedStorage.RemoveToolFromPlayerServerSide:FireServer(vials[1])

								-- Delete from tbale
								table.remove(vials, 1)

							end			

							-- Update Weapon Levels from the server
							game.ReplicatedStorage.UpdateWeaponLevelsServerSide:FireServer("crossbowexplosiveradiuslevel")

							-- Update Local weapon level
							thisPlayer.weaponlevels.crossbowexplosiveradiuslevel.Value += 1

							-- Refill in new boxed..
							FillUpgradeLevelBoxes(currentWeapon.Name)

							-- Update It..
							currentRadiusLevel = thisPlayer.weaponlevels.crossbowexplosiveradiuslevel.Value	

							-- Update Cost Labels
							if currentRadiusLevel == 5 then

								-- Hide Button and Cost
								currentWeaponFrame.Buttons.RadiusUpgradeButton.Visible = false
								currentWeaponFrame.Labels.RadiusCost.Visible = false
							else

								-- Update It
								currentWeaponFrame.Labels.RadiusCost.Text = tostring(currentRadiusLevel)								
							end
							
							-- Play Scientist Sound..
							local random = math.random(1, #thanksAudioArray)
							thanksAudioArray[random]:Play()
							random = nil
							
						else

							-- Not Enough Vials
							notEnoughBloodAudioArray[math.random(1,2)]:Play()

						end
					end)

					-- Add to button connections
					table.insert(buttonConnections, radiusUpgradeButtonConnection)

				elseif currentWeapon.Name == "VialGunBasic" then

					-- Set Image Label to Plasma
					currentWeaponFrame.Image.WeaponImage.Image = currentWeapon.TextureId	

					-- Get Current Weaopon Levels
					local damageLevel = thisPlayer.weaponlevels.vialgundamagelevel.Value
					local radiusLevel = thisPlayer.weaponlevels.vialgunradiuslevel.Value

					-------------------------------------------------------
					-- If Upgrades Levels Are Maxed out, Hide Some Stuff --
					-------------------------------------------------------

					-- If Damage is Max Level..
					if damageLevel == 5 then

						-- Hide Cost and Button
						currentWeaponFrame.Buttons.DamageUpgradeButton.Visible = false
						currentWeaponFrame.Labels.DamageCost.Visible = false

					else

						-- Show it
						currentWeaponFrame.Buttons.DamageUpgradeButton.Visible = true
						currentWeaponFrame.Labels.DamageCost.Visible = true
						currentWeaponFrame.Labels.DamageCost.Text = tostring(damageLevel)
					end

					-- If Radius is Max Level..
					if radiusLevel == 5 then

						-- Hide Button and Cost
						currentWeaponFrame.Buttons.RadiusUpgradeButton.Visible = false
						currentWeaponFrame.Labels.RadiusCost.Visible = false

					else

						-- show It
						currentWeaponFrame.Buttons.RadiusUpgradeButton.Visible = true
						currentWeaponFrame.Labels.RadiusCost.Visible = true
						currentWeaponFrame.Labels.RadiusCost.Text = tostring(radiusLevel)

					end						

					-- Default Radius Stuff..
					currentWeaponFrame.Labels.RadiusLabel.Visible = true
					currentWeaponFrame.UpgradeLevels.RadiusLevels.Visible = true

					-- Default Damage Stuff
					currentWeaponFrame.Labels.DamageLabel.Visible = true
					currentWeaponFrame.UpgradeLevels.DamageLevels.Visible = true

					-- Turn off Special Upgrades
					currentWeaponFrameSpecialUpgradeButton.Visible = false
					currentWeaponFrame.Labels.SpecialCost.Visible = false
					currentWeaponFrame.Labels.SpecialLabel.Visible = false

					-- Turn Off Power Levels
					currentWeaponFrame.Buttons.PowerUpgradeButton.Visible = false
					currentWeaponFrame.Labels.PowerCost.Visible = false
					currentWeaponFrame.Labels.PowerLabel.Visible = false
					currentWeaponFrame.UpgradeLevels.PowerLevels.Visible = false

					--------------------------------------
					-- Damage Upgrade button connection --
					--------------------------------------

					-- Create Upgrade button Connections
					local damageUpgradeButtonConnection = nil

					-- DamageUpgradeButton
					damageUpgradeButtonConnection = currentWeaponFrameDamageUpgradeButton.MouseButton1Click:Connect(function()
						
						-- Get Player Vials
						vials = GetPlayerVials()

						-- If we have no vials, but have blood..
						if #vials == 0 then

							-- If we have no blood..
							if thisPlayer.blood.Value == 0 then

								-- Not Enogh Blood
								notEnoughBloodAudioArray[math.random(1,2)]:Play()
							else

								-- Need that in a vial..
								needThatInVial:Play()
							end						

							-- Exit
							return
						end

						-- Get Player Gun Level
						local currentDamageLevel = thisPlayer.weaponlevels.vialgundamagelevel.Value

						-- check if Player has enough vials
						if #vials >= currentDamageLevel then

							-- Take Needed Vials from Player..
							for i = 1, currentDamageLevel do

								-- Destroy Vials
								vials[1]:Destroy()

								-- If this tool was in the Hotbar, remove it..
								for i = 1, 9 do

									-- If they match
									if hotbarTools[i][1] == vials[1] then

										-- Remove It
										hotbarTools[i][1] = nil
										
										-- Reset Count
										hotbarTools[i][2] = 0

										-- Remove image
										hotbarButtons[i].Image = ""
										
										-- Reset Count
										hotbarButtons[i].Count.CountValue.Value = 0

									end

								end	

								-- Remove this Tool Server Side
								game.ReplicatedStorage.RemoveToolFromPlayerServerSide:FireServer(vials[1])

								-- Delete from tbale
								table.remove(vials, 1)
							end						

							-- Update Weapon Levels from the server
							game.ReplicatedStorage.UpdateWeaponLevelsServerSide:FireServer("vialgundamagelevel")

							-- Update Local weapon level
							thisPlayer.weaponlevels.vialgundamagelevel.Value += 1

							-- Refill in new boxed..
							FillUpgradeLevelBoxes(currentWeapon.Name)

							-- Update It
							currentDamageLevel = thisPlayer.weaponlevels.vialgundamagelevel.Value

							-- Update Cost Labels
							if currentDamageLevel == 5 then

								-- Hide Cost and Button
								currentWeaponFrame.Buttons.DamageUpgradeButton.Visible = false
								currentWeaponFrame.Labels.DamageCost.Visible = false

							else

								-- Update It..
								currentWeaponFrame.Labels.DamageCost.Text = tostring(currentDamageLevel)								
							end
							
							-- Play Scientist Sound..
							local random = math.random(1, #thanksAudioArray)
							thanksAudioArray[random]:Play()
							random = nil
						else

							-- Not Enough Vials
							notEnoughBloodAudioArray[math.random(1,2)]:Play()

						end	
						
					end)

					-- Add to button connections
					table.insert(buttonConnections, damageUpgradeButtonConnection)

					--------------------------------------
					-- Radius Upgrade button connection --
					--------------------------------------

					-- RadiusUpgrade
					local radiusUpgradeButtonConnection = nil

					-- DamageUpgradeButton
					radiusUpgradeButtonConnection = currentWeaponFrameRadiusUpgradeButton.MouseButton1Click:Connect(function()
						
						-- Get Player Vials
						vials = GetPlayerVials()

						-- If we have no vials, but have blood..
						if #vials == 0 then

							-- If we have no blood..
							if thisPlayer.blood.Value == 0 then

								-- Not Enogh Blood
								notEnoughBloodAudioArray[math.random(1,2)]:Play()
							else

								-- Need that in a vial..
								needThatInVial:Play()
							end						

							-- Exit
							return
						end

						-- Get Player Gun Level
						local currentRadiusLevel = thisPlayer.weaponlevels.vialgunradiuslevel.Value

						-- check if Player has enough vials
						if #vials >= currentRadiusLevel then

							-- Take Needed Vials from Player..
							for i = 1, currentRadiusLevel do

								-- Destroy Vials
								vials[1]:Destroy()

								-- If this tool was in the Hotbar, remove it..
								for i = 1, 9 do

									-- If they match
									if hotbarTools[i][1] == vials[1] then

										-- Remove It
										hotbarTools[i][1] = nil
										
										-- Reset Count
										hotbarTools[i][2] = 0

										-- Remove image
										hotbarButtons[i].Image = ""
										
										-- Reset Count
										hotbarButtons[i].Count.CountValue.Value = 0

									end

								end	

								-- Remove this Tool Server Side
								game.ReplicatedStorage.RemoveToolFromPlayerServerSide:FireServer(vials[1])

								-- Delete from tbale
								table.remove(vials, 1)

							end			

							-- Update Weapon Levels from the server
							game.ReplicatedStorage.UpdateWeaponLevelsServerSide:FireServer("vialgunradiuslevel")

							-- Update Local weapon level
							thisPlayer.weaponlevels.vialgunradiuslevel.Value += 1

							-- Refill in new boxed..
							FillUpgradeLevelBoxes(currentWeapon.Name)

							-- Update It..
							currentRadiusLevel = thisPlayer.weaponlevels.vialgunradiuslevel.Value

							-- Update Cost Labels
							if currentRadiusLevel == 5 then

								-- Hide Button and Cost
								currentWeaponFrame.Buttons.RadiusUpgradeButton.Visible = false
								currentWeaponFrame.Labels.RadiusCost.Visible = false
							else

								-- Update It
								currentWeaponFrame.Labels.RadiusCost.Text = tostring(currentRadiusLevel)								
							end
							
							-- Play Scientist Sound..
							local random = math.random(1, #thanksAudioArray)
							thanksAudioArray[random]:Play()
							random = nil
						else

							-- Not Enough Vials
							notEnoughBloodAudioArray[math.random(1,2)]:Play()

						end	
						
					end)

					-- Add to button connections
					table.insert(buttonConnections, radiusUpgradeButtonConnection)


				elseif currentWeapon.Name == "BBGun" then

					-- Set Image Label to Plasma
					currentWeaponFrame.Image.WeaponImage.Image = currentWeapon.TextureId

					-- Get Current Weaopon Levels
					local damageLevel = thisPlayer.weaponlevels.bbgundamagelevel.Value

					-- If Damage is Max Level..
					if damageLevel == 5 then

						-- Hide Cost and Button
						currentWeaponFrame.Buttons.DamageUpgradeButton.Visible = false
						currentWeaponFrame.Labels.DamageCost.Visible = false

					else

						-- Show it
						currentWeaponFrame.Buttons.DamageUpgradeButton.Visible = true
						currentWeaponFrame.Labels.DamageCost.Visible = true
						currentWeaponFrame.Labels.DamageCost.Text = tostring(damageLevel)
					end

					-- Default Damage Stuff
					currentWeaponFrame.Labels.DamageLabel.Visible = true
					currentWeaponFrame.UpgradeLevels.DamageLevels.Visible = true

					-- turn off "Radius" Levels
					currentWeaponFrame.Buttons.RadiusUpgradeButton.Visible = false
					currentWeaponFrame.Labels.RadiusCost.Visible = false
					currentWeaponFrame.Labels.RadiusLabel.Visible = false
					currentWeaponFrame.UpgradeLevels.RadiusLevels.Visible = false

					-- Turn Off Power Levels
					currentWeaponFrame.Buttons.PowerUpgradeButton.Visible = false
					currentWeaponFrame.Labels.PowerCost.Visible = false
					currentWeaponFrame.Labels.PowerLabel.Visible = false
					currentWeaponFrame.UpgradeLevels.PowerLevels.Visible = false

					------------------------------
					-- Turn on Special Upgrades --
					------------------------------

					-- Only show upgrade stuff if we dont have this upgrade..
					if thisPlayer.weaponlevels.bbgunspecialupgrade.Value == false then

						-- Turn on Special upgrade Button
						currentWeaponFrameSpecialUpgradeButton.Visible = true
						currentWeaponFrame.Labels.SpecialCost.Visible = true
						currentWeaponFrame.Labels.SpecialLabel.Visible = true
						currentWeaponFrame.Labels.SpecialLabel.Text = "Automatic Conversion"
						currentWeaponFrame.Labels.SpecialCost.Text = "2"

					else

						-- Turn it off
						currentWeaponFrameSpecialUpgradeButton.Visible = false
						currentWeaponFrame.Labels.SpecialCost.Visible = false
						currentWeaponFrame.Labels.SpecialLabel.Visible = false
					end					

					--------------------------------------
					-- Damage Upgrade button connection --
					--------------------------------------

					-- Create Upgrade button Connections
					local damageUpgradeButtonConnection = nil

					-- DamageUpgradeButton
					damageUpgradeButtonConnection = currentWeaponFrameDamageUpgradeButton.MouseButton1Click:Connect(function()
						
						-- Get Player Vials
						vials = GetPlayerVials()

						-- If we have no vials, but have blood..
						if #vials == 0 then

							-- If we have no blood..
							if thisPlayer.blood.Value == 0 then

								-- Not Enogh Blood
								notEnoughBloodAudioArray[math.random(1,2)]:Play()
							else

								-- Need that in a vial..
								needThatInVial:Play()
							end						

							-- Exit
							return
						end

						-- Get Player Gun Level
						local currentDamageLevel = thisPlayer.weaponlevels.bbgundamagelevel.Value

						-- check if Player has enough vials
						if #vials >= currentDamageLevel then

							-- Take Needed Vials from Player..
							for i = 1, currentDamageLevel do

								-- Destroy Vials
								vials[1]:Destroy()

								-- If this tool was in the Hotbar, remove it..
								for i = 1, 9 do

									-- If they match
									if hotbarTools[i][1] == vials[1] then

										-- Remove It
										hotbarTools[i][1] = nil
										
										-- Reset Count
										hotbarTools[i][2] = 0

										-- Remove image
										hotbarButtons[i].Image = ""
										
										-- Reset Count
										hotbarButtons[i].Count.CountValue.Value = 0

									end

								end	

								-- Remove this Tool Server Side
								game.ReplicatedStorage.RemoveToolFromPlayerServerSide:FireServer(vials[1])

								-- Delete from tbale
								table.remove(vials, 1)
							end						

							-- Update Weapon Levels from the server
							game.ReplicatedStorage.UpdateWeaponLevelsServerSide:FireServer("bbgundamagelevel")

							-- Update Local weapon level so server doesnt have to update for GUI
							thisPlayer.weaponlevels.bbgundamagelevel.Value += 1

							-- Refill in new boxed..
							FillUpgradeLevelBoxes(currentWeapon.Name)

							-- Update It..
							currentDamageLevel = thisPlayer.weaponlevels.bbgundamagelevel.Value

							-- Update Cost Labels
							if currentDamageLevel == 5 then

								-- Hide Cost and Button
								currentWeaponFrame.Buttons.DamageUpgradeButton.Visible = false
								currentWeaponFrame.Labels.DamageCost.Visible = false

							else

								-- Update It..
								currentWeaponFrame.Labels.DamageCost.Text = tostring(currentDamageLevel)								
							end
							
							-- Play Scientist Sound..
							local random = math.random(1, #thanksAudioArray)
							thanksAudioArray[random]:Play()
							random = nil
							
						else

							-- Not Enough Vials
							notEnoughBloodAudioArray[math.random(1,2)]:Play()

						end	
						
					end)

					-- Add to button connections
					table.insert(buttonConnections, damageUpgradeButtonConnection)

					----------------------------
					-- Special Upgrade button --
					----------------------------

					local specialUpgradeButtonConnection = nil

					-- Special Upgrade button
					specialUpgradeButtonConnection = currentWeaponFrameSpecialUpgradeButton.MouseButton1Click:Connect(function()
						
						-- Get Player Vials
						vials = GetPlayerVials()

						-- If we have no vials, but have blood..
						if #vials == 0 then

							-- If we have no blood..
							if thisPlayer.blood.Value == 0 then

								-- Not Enogh Blood
								notEnoughBloodAudioArray[math.random(1,2)]:Play()
							else

								-- Need that in a vial..
								needThatInVial:Play()
							end						

							-- Exit
							return
						end

						-- check if Player has enough vials
						if #vials >= 2 then

							-- Take Needed Vials from Player..
							for i = 1, 2 do

								-- Destroy Vials
								vials[1]:Destroy()

								-- If this tool was in the Hotbar, remove it..
								for i = 1, 9 do

									-- If they match
									if hotbarTools[i][1] == vials[1] then

										-- Remove It
										hotbarTools[i][1] = nil
										
										-- Reset Count
										hotbarTools[i][2] = 0

										-- Remove image
										hotbarButtons[i].Image = ""
										
										-- Reset Count
										hotbarButtons[i].Count.CountValue.Value = 0

									end

								end	

								-- Remove this Tool Server Side
								game.ReplicatedStorage.RemoveToolFromPlayerServerSide:FireServer(vials[1])

								-- Delete from tbale
								table.remove(vials, 1)
							end

							-- Update Auto Conversion Value in Player From server..
							game.ReplicatedStorage.UpdateWeaponLevelsServerSide:FireServer("bbgunspecialupgrade")

							-- Turn it off now..
							currentWeaponFrameSpecialUpgradeButton.Visible = false
							currentWeaponFrame.Labels.SpecialCost.Visible = false
							currentWeaponFrame.Labels.SpecialLabel.Visible = false
							
							-- Play Scientist Sound..
							local random = math.random(1, #thanksAudioArray)
							thanksAudioArray[random]:Play()
							random = nil

						else

							-- Not Enough Vials
							notEnoughBloodAudioArray[math.random(1,2)]:Play()

						end	
						
					end)

					-- Add to button connections
					table.insert(buttonConnections, specialUpgradeButtonConnection)

				elseif currentWeapon.Name == "Flamethrower" then

					-- Set Image Label
					currentWeaponFrame.Image.WeaponImage.Image = currentWeapon.TextureId

					-- Get Current Weaopon Levels
					local damageLevel = thisPlayer.weaponlevels.flamethrowerdamagelevel.Value

					-- If Damage is Max Level..
					if damageLevel == 5 then

						-- Hide Cost and Button
						currentWeaponFrame.Buttons.DamageUpgradeButton.Visible = false
						currentWeaponFrame.Labels.DamageCost.Visible = false

					else

						-- Show it
						currentWeaponFrame.Buttons.DamageUpgradeButton.Visible = true
						currentWeaponFrame.Labels.DamageCost.Visible = true
						currentWeaponFrame.Labels.DamageCost.Text = tostring(damageLevel)
					end

					-- Default Damage Stuff
					currentWeaponFrame.Labels.DamageLabel.Visible = true
					currentWeaponFrame.UpgradeLevels.DamageLevels.Visible = true

					-- turn off "Radius" Levels
					currentWeaponFrame.Buttons.RadiusUpgradeButton.Visible = false
					currentWeaponFrame.Labels.RadiusCost.Visible = false
					currentWeaponFrame.Labels.RadiusLabel.Visible = false
					currentWeaponFrame.UpgradeLevels.RadiusLevels.Visible = false

					-- turn Off Special Upgrade..
					currentWeaponFrameSpecialUpgradeButton.Visible = false
					currentWeaponFrame.Labels.SpecialCost.Visible = false
					currentWeaponFrame.Labels.SpecialLabel.Visible = false

					-- Turn Off Power Levels
					currentWeaponFrame.Buttons.PowerUpgradeButton.Visible = false
					currentWeaponFrame.Labels.PowerCost.Visible = false
					currentWeaponFrame.Labels.PowerLabel.Visible = false
					currentWeaponFrame.UpgradeLevels.PowerLevels.Visible = false

					--------------------------------------
					-- Damage Upgrade button connection --
					--------------------------------------

					-- Create Upgrade button Connections
					local damageUpgradeButtonConnection = nil

					-- DamageUpgradeButton
					damageUpgradeButtonConnection = currentWeaponFrameDamageUpgradeButton.MouseButton1Click:Connect(function()
						
						-- Get Player Vials
						vials = GetPlayerVials()

						-- If we have no vials, but have blood..
						if #vials == 0 then

							-- If we have no blood..
							if thisPlayer.blood.Value == 0 then

								-- Not Enogh Blood
								notEnoughBloodAudioArray[math.random(1,2)]:Play()
							else

								-- Need that in a vial..
								needThatInVial:Play()
							end						

							-- Exit
							return
						end

						-- Get Player Gun Level
						local currentDamageLevel = thisPlayer.weaponlevels.flamethrowerdamagelevel.Value

						-- check if Player has enough vials
						if #vials >= currentDamageLevel then

							-- Take Needed Vials from Player..
							for i = 1, currentDamageLevel do

								-- Destroy Vials
								vials[1]:Destroy()

								-- If this tool was in the Hotbar, remove it..
								for i = 1, 9 do

									-- If they match
									if hotbarTools[i][1] == vials[1] then

										-- Remove It
										hotbarTools[i][1] = nil
										
										-- Reset Count
										hotbarTools[i][2] = 0

										-- Remove image
										hotbarButtons[i].Image = ""
										
										-- Reset Count
										hotbarButtons[i].Count.CountValue.Value = 0

									end

								end	

								-- Remove this Tool Server Side
								game.ReplicatedStorage.RemoveToolFromPlayerServerSide:FireServer(vials[1])

								-- Delete from tbale
								table.remove(vials, 1)
							end						

							-- Update Weapon Levels from the server
							game.ReplicatedStorage.UpdateWeaponLevelsServerSide:FireServer("flamethrowerdamagelevel")

							-- Update Local weapon level so server doesnt have to update for GUI
							thisPlayer.weaponlevels.flamethrowerdamagelevel.Value += 1

							-- Refill in new boxed..
							FillUpgradeLevelBoxes(currentWeapon.Name)

							-- Update It
							currentDamageLevel = thisPlayer.weaponlevels.flamethrowerdamagelevel.Value

							-- Update Cost Labels
							if currentDamageLevel == 5 then

								-- Hide Cost and Button
								currentWeaponFrame.Buttons.DamageUpgradeButton.Visible = false
								currentWeaponFrame.Labels.DamageCost.Visible = false

							else

								-- Update It..
								currentWeaponFrame.Labels.DamageCost.Text = tostring(currentDamageLevel)								
							end
							
							-- Play Scientist Sound..
							local random = math.random(1, #thanksAudioArray)
							thanksAudioArray[random]:Play()
							random = nil
						else

							-- Not Enough Vials
							notEnoughBloodAudioArray[math.random(1,2)]:Play()

						end	
						
					end)

					-- Add to button connections
					table.insert(buttonConnections, damageUpgradeButtonConnection)					

				elseif currentWeapon.Name == "AirBlaster" then

					-- Set Image Label
					currentWeaponFrame.Image.WeaponImage.Image = currentWeapon.TextureId

					-- Get Current Weaopon Levels
					local damageLevel = thisPlayer.weaponlevels.airblasterdamagelevel.Value
					local powerLevel = thisPlayer.weaponlevels.airblasterpowerlevel.Value

					-- If Damage is Max Level..
					if damageLevel == 5 then

						-- Hide Cost and Button
						currentWeaponFrame.Buttons.DamageUpgradeButton.Visible = false
						currentWeaponFrame.Labels.DamageCost.Visible = false

					else

						-- Show it
						currentWeaponFrame.Buttons.DamageUpgradeButton.Visible = true
						currentWeaponFrame.Labels.DamageCost.Visible = true
						currentWeaponFrame.Labels.DamageCost.Text = tostring(damageLevel)
					end

					-- Power Level
					if powerLevel == 5 then

						-- hide Power Level Button and Cost
						currentWeaponFrame.Buttons.PowerUpgradeButton.Visible = false
						currentWeaponFrame.Labels.PowerCost.Visible = false
					else

						-- Show It..
						currentWeaponFrame.Buttons.PowerUpgradeButton.Visible = true
						currentWeaponFrame.Labels.PowerCost.Visible = true
						currentWeaponFrame.Labels.PowerCost.Text = tostring(powerLevel)
					end

					-- Default Damage Stuff
					currentWeaponFrame.Labels.DamageLabel.Visible = true
					currentWeaponFrame.UpgradeLevels.DamageLevels.Visible = true

					-- default Power Stuff
					currentWeaponFrame.Labels.PowerLabel.Visible = true
					currentWeaponFrame.UpgradeLevels.PowerLevels.Visible = true

					-- turn off "Radius" Levels
					currentWeaponFrame.Buttons.RadiusUpgradeButton.Visible = false
					currentWeaponFrame.Labels.RadiusCost.Visible = false
					currentWeaponFrame.Labels.RadiusLabel.Visible = false
					currentWeaponFrame.UpgradeLevels.RadiusLevels.Visible = false

					-- turn Off Special Upgrade..
					currentWeaponFrameSpecialUpgradeButton.Visible = false
					currentWeaponFrame.Labels.SpecialCost.Visible = false
					currentWeaponFrame.Labels.SpecialLabel.Visible = false

					--------------------------------------
					-- Damage Upgrade button connection --
					--------------------------------------

					-- Create Upgrade button Connections
					local damageUpgradeButtonConnection = nil

					-- DamageUpgradeButton
					damageUpgradeButtonConnection = currentWeaponFrameDamageUpgradeButton.MouseButton1Click:Connect(function()
						
						-- Get Player Vials
						vials = GetPlayerVials()

						-- If we have no vials, but have blood..
						if #vials == 0 then

							-- If we have no blood..
							if thisPlayer.blood.Value == 0 then

								-- Not Enogh Blood
								notEnoughBloodAudioArray[math.random(1,2)]:Play()
							else

								-- Need that in a vial..
								needThatInVial:Play()
							end						

							-- Exit
							return
						end

						-- Get Player Gun Level
						local currentDamageLevel = thisPlayer.weaponlevels.airblasterdamagelevel.Value

						-- check if Player has enough vials
						if #vials >= currentDamageLevel then

							-- Take Needed Vials from Player..
							for i = 1, currentDamageLevel do

								-- Destroy Vials
								vials[1]:Destroy()

								-- If this tool was in the Hotbar, remove it..
								for i = 1, 9 do

									-- If they match
									if hotbarTools[i][1] == vials[1] then

										-- Remove It
										hotbarTools[i][1] = nil
										
										-- Reset Count
										hotbarTools[i][2] = 0

										-- Remove image
										hotbarButtons[i].Image = ""
										
										-- Reset Count
										hotbarButtons[i].Count.CountValue.Value = 0

									end

								end	

								-- Remove this Tool Server Side
								game.ReplicatedStorage.RemoveToolFromPlayerServerSide:FireServer(vials[1])

								-- Delete from tbale
								table.remove(vials, 1)
							end					

							-- Update Weapon Levels from the server
							game.ReplicatedStorage.UpdateWeaponLevelsServerSide:FireServer("airblasterdamagelevel")

							-- Update Local weapon level so server doesnt have to update for GUI
							thisPlayer.weaponlevels.airblasterdamagelevel.Value += 1

							-- Refill in new boxed..
							FillUpgradeLevelBoxes(currentWeapon.Name)

							-- Update It
							currentDamageLevel = thisPlayer.weaponlevels.airblasterdamagelevel.Value

							-- Update Cost Labels
							if currentDamageLevel == 5 then

								-- Hide Cost and Button
								currentWeaponFrame.Buttons.DamageUpgradeButton.Visible = false
								currentWeaponFrame.Labels.DamageCost.Visible = false

							else

								-- Update It..
								currentWeaponFrame.Labels.DamageCost.Text = tostring(currentDamageLevel)								
							end
							
							-- Play Scientist Sound..
							local random = math.random(1, #thanksAudioArray)
							thanksAudioArray[random]:Play()
							random = nil
						else

							-- Not Enough Vials
							notEnoughBloodAudioArray[math.random(1,2)]:Play()

						end	
						
					end)

					-- Add to button connections
					table.insert(buttonConnections, damageUpgradeButtonConnection)

					-------------------------------------
					-- Power Upgrade Button Connection --
					-------------------------------------

					local powerUpgradeButtonConnection = nil

					-- DamageUpgradeButton
					powerUpgradeButtonConnection = currentWeaponFramePowerUpgradeButton.MouseButton1Click:Connect(function()
						
						-- Get Player Vials
						vials = GetPlayerVials()

						-- If we have no vials, but have blood..
						if #vials == 0 then

							-- If we have no blood..
							if thisPlayer.blood.Value == 0 then

								-- Not Enogh Blood
								notEnoughBloodAudioArray[math.random(1,2)]:Play()
							else

								-- Need that in a vial..
								needThatInVial:Play()
							end						

							-- Exit
							return
						end

						-- Get Player Gun Level
						local currentPowerLevel = thisPlayer.weaponlevels.airblasterpowerlevel.Value

						-- check if Player has enough vials
						if #vials >= currentPowerLevel then

							-- Take Needed Vials from Player..
							for i = 1, currentPowerLevel do

								-- Destroy Vials
								vials[1]:Destroy()

								-- If this tool was in the Hotbar, remove it..
								for i = 1, 9 do

									-- If they match
									if hotbarTools[i][1] == vials[1] then

										-- Remove It
										hotbarTools[i][1] = nil
										
										-- Reset Count
										hotbarTools[i][2] = 0

										-- Remove image
										hotbarButtons[i].Image = ""
										
										-- Reset Count
										hotbarButtons[i].Count.CountValue.Value = 0

									end

								end	

								-- Remove this Tool Server Side
								game.ReplicatedStorage.RemoveToolFromPlayerServerSide:FireServer(vials[1])

								-- Delete from tbale
								table.remove(vials, 1)
							end						

							-- Update Weapon Levels from the server
							game.ReplicatedStorage.UpdateWeaponLevelsServerSide:FireServer("airblasterpowerlevel")

							-- Update Local weapon level so server doesnt have to update for GUI
							thisPlayer.weaponlevels.airblasterpowerlevel.Value += 1

							-- Refill in new boxed..
							FillUpgradeLevelBoxes(currentWeapon.Name)

							-- Update It
							currentPowerLevel = thisPlayer.weaponlevels.airblasterpowerlevel.Value

							-- Update Cost Labels
							if currentPowerLevel == 5 then

								-- Hide Cost and Button
								currentWeaponFrame.Buttons.PowerUpgradeButton.Visible = false
								currentWeaponFrame.Labels.PowerCost.Visible = false

							else

								-- Update It..
								currentWeaponFrame.Labels.PowerCost.Text = tostring(currentPowerLevel)							
							end
							
							-- Play Scientist Sound..
							local random = math.random(1, #thanksAudioArray)
							thanksAudioArray[random]:Play()
							random = nil
						else

							-- Not Enough Vials
							notEnoughBloodAudioArray[math.random(1,2)]:Play()

						end	
						
					end)

					-- Add to button connections
					table.insert(buttonConnections, powerUpgradeButtonConnection)					

				elseif currentWeapon.Name == "Shotgun" then
					
					-- Set Image Label to Plasma
					currentWeaponFrame.Image.WeaponImage.Image = currentWeapon.TextureId

					-- Get Current Weaopon Levels
					local damageLevel = thisPlayer.weaponlevels.shotgundamagelevel.Value

					-------------------------------------------------------
					-- If Upgrades Levels Are Maxed out, Hide Some Stuff --
					-------------------------------------------------------

					-- If Damage is Max Level..
					if damageLevel == 5 then

						-- Hide Cost and Button
						currentWeaponFrame.Buttons.DamageUpgradeButton.Visible = false
						currentWeaponFrame.Labels.DamageCost.Visible = false

					else

						-- Show it
						currentWeaponFrame.Buttons.DamageUpgradeButton.Visible = true
						currentWeaponFrame.Labels.DamageCost.Visible = true
						currentWeaponFrame.Labels.DamageCost.Text = tostring(damageLevel)
					end

					-- Default Damage Stuff
					currentWeaponFrame.Labels.DamageLabel.Visible = true
					currentWeaponFrame.UpgradeLevels.DamageLevels.Visible = true

					-- Turn Off Power Levels
					currentWeaponFrame.Buttons.PowerUpgradeButton.Visible = false
					currentWeaponFrame.Labels.PowerCost.Visible = false
					currentWeaponFrame.Labels.PowerLabel.Visible = false
					currentWeaponFrame.UpgradeLevels.PowerLevels.Visible = false
					
					-- turn off Radius Levels
					currentWeaponFrame.Buttons.RadiusUpgradeButton.Visible = false
					currentWeaponFrame.Labels.RadiusCost.Visible = false
					currentWeaponFrame.Labels.RadiusLabel.Visible = false
					currentWeaponFrame.UpgradeLevels.RadiusLevels.Visible = false

					-- turn Off Special Upgrade..
					currentWeaponFrameSpecialUpgradeButton.Visible = false
					currentWeaponFrame.Labels.SpecialCost.Visible = false
					currentWeaponFrame.Labels.SpecialLabel.Visible = false

					--------------------------------------
					-- Damage Upgrade button connection --
					--------------------------------------

					-- Create Upgrade button Connections
					local damageUpgradeButtonConnection = nil

					-- DamageUpgradeButton
					damageUpgradeButtonConnection = currentWeaponFrameDamageUpgradeButton.MouseButton1Click:Connect(function()

						-- Get Player Vials
						vials = GetPlayerVials()

						-- If we have no vials, but have blood..
						if #vials == 0 then

							-- If we have no blood..
							if thisPlayer.blood.Value == 0 then

								-- Not Enogh Blood
								notEnoughBloodAudioArray[math.random(1,2)]:Play()
							else

								-- Need that in a vial..
								needThatInVial:Play()
							end						

							-- Exit
							return
						end

						-- Get Player Gun Level
						local currentDamageLevel = thisPlayer.weaponlevels.shotgundamagelevel.Value

						-- check if Player has enough vials
						if #vials >= currentDamageLevel then

							-- Take Needed Vials from Player..
							for i = 1, currentDamageLevel do

								-- Destroy Vials
								vials[1]:Destroy()

								-- If this tool was in the Hotbar, remove it..
								for i = 1, 9 do

									-- If they match
									if hotbarTools[i][1] == vials[1] then

										-- Remove It
										hotbarTools[i][1] = nil
										
										-- Reset Count
										hotbarTools[i][2] = 0

										-- Remove image
										hotbarButtons[i].Image = ""
										
										-- Reset Count
										hotbarButtons[i].Count.CountValue.Value = 0

									end

								end	

								-- Remove this Tool Server Side
								game.ReplicatedStorage.RemoveToolFromPlayerServerSide:FireServer(vials[1])

								-- Delete from tbale
								table.remove(vials, 1)
							end					

							-- Update Weapon Levels from the server
							game.ReplicatedStorage.UpdateWeaponLevelsServerSide:FireServer("shotgundamagelevel")

							-- Update Local weapon level
							thisPlayer.weaponlevels.shotgundamagelevel.Value += 1

							-- Refill in new boxed..
							FillUpgradeLevelBoxes(currentWeapon.Name)

							-- Update
							currentDamageLevel = thisPlayer.weaponlevels.shotgundamagelevel.Value

							-- Update Cost Labels
							if currentDamageLevel == 5 then

								-- Hide Cost and Button
								currentWeaponFrame.Buttons.DamageUpgradeButton.Visible = false
								currentWeaponFrame.Labels.DamageCost.Visible = false

							else

								-- Update It..
								currentWeaponFrame.Labels.DamageCost.Text = tostring(currentDamageLevel)								
							end

							-- Play Scientist Sound..
							local random = math.random(1, #thanksAudioArray)
							thanksAudioArray[random]:Play()
							random = nil

						else

							-- Not Enough Vials
							notEnoughBloodAudioArray[math.random(1,2)]:Play()

						end	

						-- Nil Stuff
						currentDamageLevel = nil

					end)

					-- Add to button connections
					table.insert(buttonConnections, damageUpgradeButtonConnection)

					--------------------------------------
					-- Radius Upgrade button connection --
					--------------------------------------

					-- RadiusUpgrade
					local radiusUpgradeButtonConnection = nil

					-- DamageUpgradeButton
					radiusUpgradeButtonConnection = currentWeaponFrameRadiusUpgradeButton.MouseButton1Click:Connect(function()

						-- Get Player Vials
						vials = GetPlayerVials()

						-- If we have no vials, but have blood..
						if #vials == 0 then

							-- If we have no blood..
							if thisPlayer.blood.Value == 0 then

								-- Not Enogh Blood
								notEnoughBloodAudioArray[math.random(1,2)]:Play()

							else

								-- Need that in a vial..
								needThatInVial:Play()
							end						

							-- Exit
							return
						end

						-- Get Player Gun Level
						local currentRadiusLevel = thisPlayer.weaponlevels.plasmagunradiuslevel.Value

						-- check if Player has enough vials
						if #vials >= currentRadiusLevel then

							-- Take Needed Vials from Player..
							for i = 1, currentRadiusLevel do

								-- Destroy Vials
								vials[1]:Destroy()

								-- If this tool was in the Hotbar, remove it..
								for i = 1, 9 do

									-- If they match
									if hotbarTools[i][1] == vials[1] then

										-- Remove It
										hotbarTools[i][1] = nil
										
										-- Reset Count
										hotbarTools[i][2] = 0

										-- Remove image
										hotbarButtons[i].Image = ""
										
										-- Reset Count
										hotbarButtons[i].Count.CountValue.Value = 0

									end

								end	

								-- Remove this Tool Server Side
								game.ReplicatedStorage.RemoveToolFromPlayerServerSide:FireServer(vials[1])

								-- Delete from tbale
								table.remove(vials, 1)

							end		

							-- Update Weapon Levels from the server
							game.ReplicatedStorage.UpdateWeaponLevelsServerSide:FireServer("plasmagunradiuslevel")

							-- Update Local weapon level
							thisPlayer.weaponlevels.plasmagunradiuslevel.Value += 1

							-- Refill in new boxed..
							FillUpgradeLevelBoxes(currentWeapon.Name)

							-- ReLoad Radius Level
							currentRadiusLevel = thisPlayer.weaponlevels.plasmagunradiuslevel.Value

							-- Update Cost Labels
							if currentRadiusLevel == 5 then

								-- Hide Button and Cost
								currentWeaponFrame.Buttons.RadiusUpgradeButton.Visible = false
								currentWeaponFrame.Labels.RadiusCost.Visible = false
							else

								-- Update It
								currentWeaponFrame.Labels.RadiusCost.Text = tostring(currentRadiusLevel)								
							end

							-- Play Scientist Sound..
							local random = math.random(1, #thanksAudioArray)
							thanksAudioArray[random]:Play()
							random = nil

						else

							-- Not Enough Vials
							notEnoughBloodAudioArray[math.random(1,2)]:Play()

						end		

						-- Nil Stuff
						currentRadiusLevel = nil

					end)

					-- Add to button connections
					table.insert(buttonConnections, radiusUpgradeButtonConnection)
				end

				-- Fill Current Level boxes
				FillUpgradeLevelBoxes(currentWeapon.Name)						

			end			
		end
			
		-- Keep Num Vials Up To Date
		vials = GetPlayerVials()
		
		-- Set vials
		weaponsBenchVialsLabel.Text = "Vials: " .. #vials
		
		-- Wait
		task.wait()
	end

	------------------------------
	-- Close Weapons Bench Menu --
	------------------------------
	
	-- Refresh the Hotbar
	RefreshHotbar()
	
	-- Disable Mouse Cursor
	UIS.MouseIconEnabled = false

	-- Frame Visibiity
	weaponsBenchFrame.Visible = false
	currentWeaponFrame.Visible = false
	hudFrame.Visible = true
	hotbarFrame.Visible = true
	GUIService.SelectedObject = nil

	-- Delet Connections
	for _, connection in pairs(buttonConnections) do

		-- Disconnect
		connection:Disconnect()
		connection = nil
	end

	-- Delet Images
	for _, imageButton in pairs(imageButtons) do

		-- Destroy
		imageButton:Destroy()
	end

	-- Disconnect Extra Life button
	vialWithBloodButtonConnection:Disconnect()
	vialWithBloodButtonConnection = nil
	
	-- Disconnect GUio Focus Change
	guiFocusChangeConnection:Disconnect()
	guiFocusChangeConnection = nil

	-- Let Player Walk Again
	thisPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 16
	thisPlayer.Character.Humanoid.JumpPower = 50
	
	-- Playt Scientist LEave Bench Sound
	local random = math.random(1, #leaveWeaponsBenchAudioArray)
	leaveWeaponsBenchAudioArray[random]:Play()
	random = nil

	-- Nil Stuff
	initializedButtons = nil
	buttonConnections = nil
	imageButtons = nil
	vials = nil
	currentWeapon = nil
end

-----------------------------
-- Inventory Bag Functions --
-----------------------------

-- Function to Populate the Bag..
local function PopulateBag()
	
	--------------------------
	-- Get All Player Tools --
	--------------------------
	
	local playerTools = thisPlayer.Backpack:GetChildren()

	-- Add Tool in Hand as well
	for _, v in pairs(thisPlayer.Character:GetChildren()) do

		-- If its a tool
		if v:IsA("Tool") then

			-- Add it to the player tools
			table.insert(playerTools, v)
		end
	end
	
	--------------------
	-- Populate Bag.. --
	--------------------

	-- Loop through all toold and create buttons and click connections..
	for i, tool in ipairs(playerTools) do
		
		-----------------------------------------------------------
		-- If we already have this tool, just add to the count.. --
		-----------------------------------------------------------
		
		-- var for finding tool already
		local hasTool = false
		
		-- Make Sure we dont already have this tool in the bag..
		for _, child in pairs(bagItemsFrame:GetChildren()) do
			
			-- If we already have this..
			if child:IsA("ImageButton") then
				
				-- Check the name
				if child.Name == tool.Name then
					
					-- Add to the count..
					child.Count.CountValue.Value += 1
					
					-- Change the label
					child.Count.Text = "x" .. child.Count.CountValue.Value
					
					-- Now show the Label
					child.Count.Visible = true
					
					-- Now Break this iteration
					hasTool = true
					
				end
			end
		end
		
		-- If we already had this tool, continue to next loop
		if hasTool then continue end
		
		-- Nil
		hasTool = nil
		
		-----------------------------
		-- Create new button stuff --
		-----------------------------
		
		-- Create New Button..
		local newImageButton = Instance.new("ImageButton")
		newImageButton.Name = tool.Name
		newImageButton.Parent = bagItemsFrame
		newImageButton.Image = tool.TextureId
		newImageButton.Modal = true
		newImageButton.BorderSizePixel = 0
		newImageButton.ZIndex = 5
		local newAspectRatio = Instance.new("UIAspectRatioConstraint")
		newAspectRatio.Parent = newImageButton
		
		-- Create Text Label
		local newTextLabel = Instance.new("TextLabel")
		newTextLabel.Parent = newImageButton
		newTextLabel.BackgroundTransparency = 1
		newTextLabel.Position = UDim2.new(0,0,0.875,0)
		newTextLabel.Size = UDim2.new(1,0,0.125,0)
		newTextLabel.Visible = true
		newTextLabel.TextColor3 = Color3.fromRGB(255,255,255)
		newTextLabel.TextScaled = true
		newTextLabel.Font = Enum.Font.TitilliumWeb
		
		-- Set Proper Text Label Text..
		for _, itemArray in pairs(itemDisplayNameTable) do
			
			-- Look for this Tool/Item Name
			if itemArray[1] == tool.Name then
				
				-- Set Text Label
				newTextLabel.Text = itemArray[2]
			end
		end
		
		-- Create Count Label..
		local newCountLabel = Instance.new("TextLabel")
		newCountLabel.Name = "Count"
		newCountLabel.Parent = newImageButton
		newCountLabel.BackgroundTransparency = 1
		newCountLabel.Size = UDim2.new(0.2, 0,0.2, 0)
		newCountLabel.Position = UDim2.new(0.8,0,0,0)
		newCountLabel.Visible = false
		newCountLabel.TextColor3 = Color3.fromRGB(255,255,255)
		newCountLabel.TextScaled = true
		newCountLabel.Font = Enum.Font.TitilliumWeb
		
		-- Add UIStroke For Bold.
		local boldStroke = Instance.new("UIStroke")
		boldStroke.Parent = newCountLabel
		boldStroke.Color = Color3.fromRGB(255,255,255)
		boldStroke.Thickness = 0.3
		
		-- Create CoountValue
		local newCountValue = Instance.new("IntValue")
		newCountValue.Name = "CountValue"
		newCountValue.Parent = newCountLabel
		newCountValue.Value = 1
		
		-- Set Count Label
		newCountLabel.Text = "x" .. newCountValue.Value
		
		----------------------------------------
		-- Now Create the new Slot Connection --
		----------------------------------------

		-- New Connections
		local slotConnection = nil
		currentSelectedBagItem = nil

		-- Create a click COnnection
		slotConnection = newImageButton.MouseButton1Click:Connect(function()
			
			-- If we are moving a tool, leave this function
			if toolThatsMoving[1] then return end
			
			-- Set current
			currentSelectedBagItem = newImageButton
			
			-- If Options was Open.. Close it and sever previous connections..
			if slotOptionsFrame.Visible == true then
				
				-- Make it visible
				slotOptionsFrame.Visible = false
				
				-- Disconnect Old Connections
				if dropConnection then dropConnection:Disconnect() dropConnection = nil end
				if equipConnection then equipConnection:Disconnect() equipConnection = nil end
				if moveConnection then moveConnection:Disconnect() moveConnection = nil end
				
				-- focus on this button (XBOX Support)
				GUIService.SelectedObject = newImageButton
				
			elseif slotOptionsFrame.Visible == false then
				
				if tutorialOpenedSlotOptionsFrame == false then tutorialOpenedSlotOptionsFrame = true end
				
				-- Show Options Frame
				slotOptionsFrame.Visible = true

				-- Position it Above this item
				local relativePosition = newImageButton.AbsolutePosition - slotOptionsFrame.Parent.AbsolutePosition
				slotOptionsFrame.Position = UDim2.new(0, relativePosition.X + 50, 0, relativePosition.Y + 50)
				relativePosition = nil

				-- focus on this button (XBOX Support)
				GUIService.SelectedObject = slotOptionsFrame.Equip

				-------------------------------------------
				-- Create Slot Options Frame Connections --
				-------------------------------------------
				
				-- Disconnect Old Connections
				if dropConnection then dropConnection:Disconnect() dropConnection = nil end
				if equipConnection then equipConnection:Disconnect() equipConnection = nil end
				if moveConnection then moveConnection:Disconnect() moveConnection = nil end

				-- Make Connection To Drop this Item
				dropConnection = slotOptionsFrame.Drop.MouseButton1Click:Connect(function()
					
					-- Ref
					local toolName = tool.Name

					-- Dont Drop Key Items..
					if table.find(keyItemsTable, toolName) then

						-- Create coroutine..
						local updateHUDCoroutine = coroutine.create(UpdateHUDMessage)

						-- Run it..
						coroutine.resume(updateHUDCoroutine, "Cant drop this item!")

						-- Nil Stuff
						updateHUDCoroutine = nil

						-- Set Selected Object To Play Button (XBOX Support)
						GUIService.SelectedObject = newImageButton

					else
						
						-- Drop the Tool ..
						game.ReplicatedStorage.RemoveToolFromPlayerServerSide:FireServer(tool)					

						-- Delete this image button..
						newImageButton:Destroy()

						-- Select First Child
						for _, child in pairs(bagItemsFrame:GetChildren()) do
							
							-- Only select an ImageButton
							if child:IsA("ImageButton") then
								
								-- Select first Child.
								GUIService.SelectedObject = child
								
								-- Break
								break
								
							end														
						end						
					end	
					
					-- Hide Options Window with either choice
					slotOptionsFrame.Visible = false

					-- Disconnect Old Connections
					if dropConnection then dropConnection:Disconnect() dropConnection = nil end
					if equipConnection then equipConnection:Disconnect() equipConnection = nil end
					if moveConnection then moveConnection:Disconnect() moveConnection = nil end
					
				end)

				-- Make Connection for Clicking the Equip Button
				equipConnection = slotOptionsFrame.Equip.MouseButton1Click:Connect(function()
					
					-- Move Equipped Tool to Backpack
					if equippedTool then
						
						-- Move
						equippedTool.Parent = thisPlayer.Backpack	
						
						-- Nil Equipped Tool
						equippedTool = nil
						
						-- Wait a sec
						task.wait()
						
					end
					
					-- If this tool was in hotbar..
					local toolWasInHotbar = false
					
					-- If this tool was in the Hotbar, Equip it..
					for i = 1, 9 do

						-- If they match
						if hotbarTools[i][1] == tool.Name then
							
							toolWasInHotbar = true

							-- Activate
							ActivateHotbar(i)
						end

					end
					
					-- If it was not in hotbar, equip it still..
					if toolWasInHotbar == false then
						
						-- Move Tool we want to Equip to players hand..
						tool.Parent = thisPlayer.Character
						
						-- Set Equipped Tool
						equippedTool = tool
						
					end
					
					---------------------------------------
					-- Hide window and Sever Connections --
					---------------------------------------

					-- Set Selected Object To Play Button (XBOX Support)
					GUIService.SelectedObject = newImageButton
					
					-- Nil Stuff
					toolWasInHotbar = nil
					
					-- Player not in bag anymore
					playerInBag = false
					
					-- Hide Options Window
					slotOptionsFrame.Visible = false

					-- Disconnect Old Connections
					if dropConnection then dropConnection:Disconnect() dropConnection = nil end
					if equipConnection then equipConnection:Disconnect() equipConnection = nil end
					if moveConnection then moveConnection:Disconnect() moveConnection = nil end
					
				end)
				
				-- Move connection
				moveConnection = slotOptionsFrame.Move.MouseButton1Click:Connect(function()
					
					-- tutorial
					if tutorialSelectedMove == false then tutorialSelectedMove = true end					
					
					-- Select this Button..
					GUIService.SelectedObject = hotbarButton1
					
					-- Set tool Thats moving
					toolThatsMoving[1] = tool.Name
					
					--Set tool thats moving count..
					toolThatsMoving[2] = newImageButton.Count.CountValue.Value
					
					-- Set TextureID
					toolThatsMoving[3] = tool.TextureId
					
					-- Run coroutine to see when player has chosen a toolthats moving spot..
					local toolThatsMovingChosen = coroutine.wrap(function()
						
						-- Set Bag Items to non selectable
						for _, v in pairs(bagItemsFrame:GetChildren()) do
							
							-- If its an imagebutton
							if v:IsA("ImageButton") then
								
								-- Make Unselectable
								v.Selectable = false
							end
						end
						
						-- Highlight All Hotbars..
						HightlightHotBars()
						
						-- Unless Tool Thats moving has been placed.. keep waiting..
						while toolThatsMoving[1] do
							
							-- If Player leave bag, sever this..
							if playerInBag == false then
								
								-- Nil Toolthatsmoving
								toolThatsMoving[1] = nil
								
								-- Reset Count
								toolThatsMoving[2] = 0
								
								--reset TexID
								toolThatsMoving[3] = nil
								
								-- Break
								return
							end
							
							-- Do Nothing
							task.wait()
						end
						
						-- Set Bag Items back to selectable
						for _, v in pairs(bagItemsFrame:GetChildren()) do

							-- If its an imagebutton
							if v:IsA("ImageButton") then

								-- Make Unselectable
								v.Selectable = true
							end
						end
						
						-- UnHightlight ToolBars
						UnHighlightAllHotBars()
						
						------------------------------
						-- If tool has been moved.. --
						------------------------------
						GUIService.SelectedObject = newImageButton

					end)()
					
					-- Hide Options Window
					slotOptionsFrame.Visible = false

					-- Disconnect Old Connections
					if dropConnection then dropConnection:Disconnect() dropConnection = nil end
					if equipConnection then equipConnection:Disconnect() equipConnection = nil end
					if moveConnection then moveConnection:Disconnect() moveConnection = nil end
					
				end)

				-------------------------------------------------------------------
				-- If Drop or Equip Button is Unselected.. Delete the Connection --
				-----------------------  XBOX SUPPORT -----------------------------
				
				-- Coroutine..
				local guiChanged = coroutine.wrap(function()

					while GUIService.SelectedObject == slotOptionsFrame.Drop or GUIService.SelectedObject == slotOptionsFrame.Equip or GUIService.SelectedObject == slotOptionsFrame.Move do
						
						-- Break if the Bag Window Closes.
						if bagFrame.Visible == false then
							
							-- Break
							break
						end
						
						-- Do Nothing
						task.wait()
					end
					
					---------------------
					-- If it Changed.. --
					---------------------

					-- close slot options frame..
					slotOptionsFrame.Visible = false

					-- Disconnect Old Connections
					if dropConnection then dropConnection:Disconnect() dropConnection = nil end
					if equipConnection then equipConnection:Disconnect() equipConnection = nil end
					if moveConnection then moveConnection:Disconnect() moveConnection = nil end

				end)()				
			end
		end)
		
		-- Add to Connections Array
		table.insert(slotConnections, slotConnection)
			
	end
end

-- Bag Button Pressed
local function BagButtonPressed()
	
	-------------
	-- RETURNS --
	-------------
	
	-- If Game Over Leave
	if GAME_OVER then return end
	
	-- If this player is dead.. Dont Open..
	if thisPlayer.Character.Humanoid.Health <= 0 then return end
	
	-- If Weapons Bench is Open, Dont Open Bag
	if weaponsBenchFrame.Visible == true then return end
	
	-- If player is in bag, close it
	if playerInBag then playerInBag = false return end
	
	--------------------
	-- Tutorial Check --
	-------------------
	
	-- Check for Tutorial
	if tutorialOpenedBag == false then tutorialOpenedBag = true end
	
	-----------------
	-- Other Stuff --
	-----------------
	
	-- Disable Mouse Cursor
	UIS.MouseIconEnabled = true
	
	-- Play Ziper Sound
	zipperSound:Play()
	
	-- Let Toolhandler know we oopened the bag
	game.ReplicatedStorage.PlayerOpenedBagCTC:Fire()
	
	-- Animate Button..
	local animateIconCoroutine = coroutine.create(AnimateBagButton)
	coroutine.resume(animateIconCoroutine)
	animateIconCoroutine = nil
	
	-- Open Bag Frame
	bagFrame.Visible = true
	bagItemsFrame.Visible = true

	-- Show Bag Button Selected
	bagSelectionButton.BackgroundTransparency = 1
	slotOptionsFrame.Visible = false
	dropConnection = nil
	equipConnection = nil
	moveConnection = nil

	-- Show Objectives Button Unselected
	objectivesFrame.Visible = false
	objectivesSelectionButton.BackgroundTransparency = 0
	
	-- Populate bag
	PopulateBag()

	-- Set Selected Object To Play Button (XBOX Support)
	GUIService.SelectedObject = bagSelectionButton
	
	-----------------
	-- Connections --
	-----------------

	-- For Bag Button..
	bagSelectionButtonConnection = bagSelectionButton.MouseButton1Click:Connect(function()

		-- Close Objectives Frame
		objectivesFrame.Visible = false
		objectivesSelectionButton.BackgroundTransparency = 0

		-- Open and Select Bag Frame
		bagItemsFrame.Visible = true
		bagSelectionButton.BackgroundTransparency = 1
		GUIService.SelectedObject = bagSelectionButton
		
		-- Check for Tutorial
		if tutorialOpenedBagItemsFrame == false then tutorialOpenedBagItemsFrame = true end

	end)

	-- For Objectives Button
	objectivesSelectionButtonConnection = objectivesSelectionButton.MouseButton1Click:Connect(function()

		-- Tutorial..
		if tutorialOpenedObjectives == false then tutorialOpenedObjectives = true end

		-- Close Bag Frmae
		bagItemsFrame.Visible = false
		bagSelectionButton.BackgroundTransparency = 0

		-- Open and Select Objectives Frame
		objectivesFrame.Visible = true
		objectivesSelectionButton.BackgroundTransparency = 1
		GUIService.SelectedObject = objectivesSelectionButton
		
		-- Hide Options Window
		slotOptionsFrame.Visible = false

		-- Disconnect Old Connections
		if dropConnection then dropConnection:Disconnect() dropConnection = nil end
		if equipConnection then equipConnection:Disconnect() equipConnection = nil end
		if moveConnection then moveConnection:Disconnect() moveConnection = nil end

	end)
	
	--------------------
	-- Open/Close Bag --
	--------------------
	
	-- Loop Vars..
	playerInBag = true
	
	-- Connections Vars
	local exitConnection = nil
	local guiSelectionChangeConnection = nil
	local guiFocusChangeConnection = nil
	local bagItemFrameSelectionConnection = nil
	
	-----------------
	-- Connections --
	-----------------

	-- Setup Exit Connections
	if not exitConnection then

		-- XBOX Support Back Button
		exitConnection = UIS.InputBegan:Connect(function(input)

			-- B Button
			if input.KeyCode == Enum.KeyCode.ButtonB then

				-- If the slot options is open, leave this function..
				if slotOptionsFrame.Visible == true then

					-- Close Slot Options..
					slotOptionsFrame.Visible = false

					-- Disconnect Old Connections
					if dropConnection then dropConnection:Disconnect() dropConnection = nil end
					if equipConnection then equipConnection:Disconnect() equipConnection = nil end
					if moveConnection then moveConnection:Disconnect() moveConnection = nil end
					
					-- Set BAck to selected bag item
					GUIService.SelectedObject = currentSelectedBagItem

					-- Return
					return

				end

				-- Close Bag..
				playerInBag = false

				-- Disconnect
				exitConnection:Disconnect()
				exitConnection = nil

			end
		end)
	end

	-- Play Click when Selection Changes..
	if not guiFocusChangeConnection then

		-- Make Conection
		guiFocusChangeConnection = GUIService.Changed:Connect(function(object)

			-- Play Sound..
			uiClick:Play()

		end)
	end

	-- Play Click when Selection Changes..
	if not guiSelectionChangeConnection then

		-- Make Conection
		guiSelectionChangeConnection = GUIService.SelectedObject.Changed:Connect(function(object)				

			-- Play Sound..
			uiClickSelect:Play()
			uiClick:Play()

		end)
	end

	-- Used for Pc when clicking in blank space of bag..
	if not bagItemFrameSelectionConnection then

		-- Connect it
		bagItemFrameSelectionConnection = bagFrame.BagItemsFrameButton.MouseButton1Click:Connect(function()

			-- If Slot Options Was Open..
			if slotOptionsFrame.Visible == true then

				-- Hide Options Window
				slotOptionsFrame.Visible = false

				-- Disconnect Old Connections
				if dropConnection then dropConnection:Disconnect() dropConnection = nil end
				if equipConnection then equipConnection:Disconnect() equipConnection = nil end
				if moveConnection then moveConnection:Disconnect() moveConnection = nil end
				
				-- Set back to what item we had..
				GUIService.SelectedObject = currentSelectedBagItem
				
			end			
		end)			
	end
	
	-- The Loop
	while playerInBag do	
		
		-- Wait
		task.wait()
	end
	
	-----------------------
	-- Now Close the Bag --
	-----------------------
	
	-- Disable Mouse Cursor
	UIS.MouseIconEnabled = false

	-- Play Sound
	zipperCloseSound:Play()

	-- Animate Button..
	local animateIconCoroutine = coroutine.create(AnimateBagButton)
	coroutine.resume(animateIconCoroutine)
	animateIconCoroutine = nil

	-- Bag Frame Visibility
	bagFrame.Visible = false
	
	-- Make Sure To Unhighlkight Hotbars
	UnHighlightAllHotBars()

	----------------------------
	-- Delete All Connections --
	----------------------------

	-- Slot Connections
	for _, v in pairs(slotConnections) do

		-- Disconnect
		v:Disconnect()
		v = nil
	end

	-- Disconnect BagSelection Button Connection
	if bagSelectionButtonConnection then

		-- Disconnect
		bagSelectionButtonConnection:Disconnect()
		
		-- We dont Nil it becasue its a Global Reusable Connection Variable
		
	end

	-- Disconnect Objectives Selection Button Connection
	if objectivesSelectionButtonConnection then

		-- Disconnect
		objectivesSelectionButtonConnection:Disconnect()
		
		-- We dont Nil it becasue its a Global Reusable Connection Variable
		
	end
	
	-- Clsoe Exit connection..
	if exitConnection then
		
		-- Disconnect
		exitConnection:Disconnect()
		exitConnection = nil
	end
	
	-- Clsoe Selection Change connection..
	if guiFocusChangeConnection then

		-- Disconnect
		guiFocusChangeConnection:Disconnect()
		guiFocusChangeConnection = nil
	end
	
	-- Clsoe Selection Change connection..
	if guiSelectionChangeConnection then

		-- Disconnect
		guiSelectionChangeConnection:Disconnect()
		guiSelectionChangeConnection = nil
	end
	
	-- Reset connections Arrays
	slotConnections = {}

	-------------------------------------------
	-- Delete All Image Buttons in Bag Frame --
	-------------------------------------------

	for _, button in pairs(bagItemsFrame:GetChildren()) do

		-- if its a image button, delete it..
		if button:IsA("ImageButton") then

			-- Destroy it
			button:Destroy()
		end
	end
	
	-- Make sure all hotbars highlights are turned off..
	for i = 1, 9 do
		
		-- For each one..
		hotbarButtons[i].BlueHighlight.Visible = false
	end

	-- Reset Selected GUI
	GUIService.SelectedObject = nil			
	
end

-- Bag Button Action --
local function BagButtonActionPressed(actionName, inputState, inputObj)

	-- Make sure we only fire function once on Input Begin.. --
	if inputState == Enum.UserInputState.Begin then
		
		-- Open Bag
		BagButtonPressed()

	elseif inputState == Enum.UserInputState.End or inputState == Enum.UserInputState.Cancel or inputState == Enum.UserInputState.Change then -- Button Released

		-- Incase I ever need to use this..
	end

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
		
		-- Show Proper Tool GUI Frame..
		if child.Name == "PlasmaGun" then
			
			-- Turn off Current GUI
			if currentWeaponGUIFrame then
				
				-- Turn off
				currentWeaponGUIFrame.Visible = false
				
				-- Make it nil
				currentWeaponGUIFrame = nil
				
			end
			
			-- Set Current
			currentWeaponGUIFrame = script.Parent.HUDFrame.MainFrame.WeaponGUIFrame.PlasmaGunFrame
			
			-- Turn on this Weapon Fram,e
			currentWeaponGUIFrame.Visible = true
			
		elseif child.Name == "Flamethrower" then
			
			-- Turn off Current GUI
			if currentWeaponGUIFrame then

				-- Turn off
				currentWeaponGUIFrame.Visible = false

				-- Make it nil
				currentWeaponGUIFrame = nil

			end

			-- Set Current
			currentWeaponGUIFrame = script.Parent.HUDFrame.MainFrame.WeaponGUIFrame.FlamethrowerFrame

			-- Turn on this Weapon Fram,e
			currentWeaponGUIFrame.Visible = true			
			
		elseif child.Name == "Nailgun" then
			
			-- Turn off Current GUI
			if currentWeaponGUIFrame then

				-- Turn off
				currentWeaponGUIFrame.Visible = false

				-- Make it nil
				currentWeaponGUIFrame = nil

			end

			-- Set Current
			currentWeaponGUIFrame = script.Parent.HUDFrame.MainFrame.WeaponGUIFrame.NailgunFrame

			-- Turn on this Weapon Fram,e
			currentWeaponGUIFrame.Visible = true	
			
		elseif child.Name == "Shotgun" then
			
			-- Turn off Current GUI
			if currentWeaponGUIFrame then

				-- Turn off
				currentWeaponGUIFrame.Visible = false

				-- Make it nil
				currentWeaponGUIFrame = nil

			end

			-- Set Current
			currentWeaponGUIFrame = script.Parent.HUDFrame.MainFrame.WeaponGUIFrame.ShotgunFrame

			-- Turn on this Weapon Fram,e
			currentWeaponGUIFrame.Visible = true	
			
		elseif child.Name == "BBGun" then
			
			-- Turn off Current GUI
			if currentWeaponGUIFrame then

				-- Turn off
				currentWeaponGUIFrame.Visible = false

				-- Make it nil
				currentWeaponGUIFrame = nil

			end

			-- Set Current
			currentWeaponGUIFrame = script.Parent.HUDFrame.MainFrame.WeaponGUIFrame.BBGunFrame

			-- Turn on this Weapon Fram,e
			currentWeaponGUIFrame.Visible = true	
			
		elseif child.Name == "VialGunBasic" then
			
			-- Turn off Current GUI
			if currentWeaponGUIFrame then

				-- Turn off
				currentWeaponGUIFrame.Visible = false

				-- Make it nil
				currentWeaponGUIFrame = nil

			end

			-- Set Current
			currentWeaponGUIFrame = script.Parent.HUDFrame.MainFrame.WeaponGUIFrame.VialGunFrame

			-- Turn on this Weapon Fram,e
			currentWeaponGUIFrame.Visible = true
			
		elseif child.Name == "CrossbowExplosive" then
			
			-- Turn off Current GUI
			if currentWeaponGUIFrame then

				-- Turn off
				currentWeaponGUIFrame.Visible = false

				-- Make it nil
				currentWeaponGUIFrame = nil

			end

			-- Set Current
			currentWeaponGUIFrame = script.Parent.HUDFrame.MainFrame.WeaponGUIFrame.CrossbowFrame

			-- Turn on this Weapon Fram,e
			currentWeaponGUIFrame.Visible = true
			
		else
			
			-- Turn off any weaponGUI
			if currentWeaponGUIFrame then
				
				-- Tunr off
				currentWeaponGUIFrame.Visible = false
				
				-- Make it nil
				currentWeaponGUIFrame = nil
			end
		end
		
		-- Play Sound
		equipmentSoundPlaying = equipSoundArray[math.random(1, #equipSoundArray)]
		equipmentSoundPlaying:Play()

		--------------------------------------------------
		-- If it was a hotbar Item, Turn on "Highlight" --
		--------------------------------------------------

		-- If this item was a Hotbar item..
		for i = 1, 9 do

			-- If they match
			if hotbarTools[i][1] == child.Name then

				-- Remove "Equipped" Border
				hotbarButtons[i].Border.Visible = true

			end
		end
	end
end)

-- Check When a tool is added ot the player --
thisCharacter.ChildRemoved:Connect(function(child)

	-- If the Child Added was a Tool..
	if child:IsA("Tool") then

		-- Ref it --
		equippedTool = nil
		
		-- Turn off Current GUI
		if currentWeaponGUIFrame then

			-- Turn off
			currentWeaponGUIFrame.Visible = false

			-- Make it nil
			currentWeaponGUIFrame = nil

		end
		
		-- Play Sound If not Playing
		if not equipmentSoundPlaying.IsPlaying then
			
			-- Play it
			equipmentSoundPlaying =  unequipSoundArray[math.random(1, #unequipSoundArray)]
			equipmentSoundPlaying:Play()
		end		

		-- If this item was a Hotbar item..
		for i = 1, 9 do
			
			-- If hotbartool is not nill..
			if hotbarTools[i][1] ~= nil then
				
				-- If they match
				if hotbarTools[i][1] == child.Name then
					
					-- No more equipped hotbar
					equippedHotbar = nil
					
					-- Delete Border if this was equipped..
					hotbarButtons[i].Border.Visible = false
					
					-- Get ItemNums..
					local itemNum = GetItemCount(hotbarTools[i][1])
					
					-- If we have the same amount of items..
					if itemNum < hotbarTools[i][2] and itemNum > 0 then
						
						-- Var
						local wasStacked = false
						
						-- Code to ReActivate Hotbar if more than one item left..
						if hotbarTools[i][2] > 1 then wasStacked = true end
						
						-- Update hotbarTools
						hotbarTools[i][2] = itemNum
						
						-- Update HotbarCount
						hotbarButtons[i].Count.CountValue.Value = itemNum
						
						-- Now if was stacked, run hotbar again..
						if wasStacked then
							
							-- Var
							local foundATool = false
							
							-- Loop until no tool exists..
							while true do
								
								-- reset foundatool
								foundATool = false
								
								-- Search Character
								for _, child in pairs(thisCharacter:GetChildren()) do
									
									-- if its a tool
									if child.Name == "Item" or child.Name == "Gun" then
										
										-- Found a tool
										foundATool = true
										
									end
								end
								
								-- If we didnt find a tool then break loop...
								if foundATool == false then break end
								
								-- Wait
								task.wait()
							end
							
							-- Activate
							ActivateHotbar(i)
							
							-- Nil Stuff
							foundATool = nil
							
						end
						
						-- Nil Stuff
						wasStacked = nil
						
					elseif itemNum <= 0 then
						
						-- Remove It
						hotbarTools[i][1] = nil

						-- Reset Count
						hotbarTools[i][2] = 0						

						-- Remove image
						hotbarButtons[i].Image = ""

						-- Reset Count
						hotbarButtons[i].Count.CountValue.Value = 0					
						
					end
				end			
			end		
		end
	end
end)

-- check for item Added to Player Backpack..
thisPlayer.Backpack.ChildAdded:Connect(function(child)
	
	-- Animate Button..
	local animateIconCoroutine = coroutine.create(AnimateBagButton)
	coroutine.resume(animateIconCoroutine)
	animateIconCoroutine = nil

	-- Ref has Tool Already..
	local toolInHotbar = false

	-- First make sure this tool is not on a hotbar..
	for i = 1, 9 do
		
		-- Make sure this toolslot is not nil..
		if hotbarTools[i][1] ~= nil then
			
			-- If..
			if hotbarTools[i][1] == child.Name then

				-- tool is in hotbar..
				toolInHotbar = true
				
				-- Count total number of this item..
				hotbarTools[i][2] = GetItemCount(hotbarTools[i][1])				

				-- Add to HotBarCount
				hotbarButtons[i].Count.CountValue.Value = hotbarTools[i][2]

				-- Break
				break
			end			
		end		
	end

	-- If tool was not in hotbar, then search for an empty spot..
	if toolInHotbar == false then

		-- Add tool to hotbar if there is an empty space..
		for i = 1, 9 do

			-- First tool that is nil, add this tool
			if hotbarTools[i][1] == nil then

				-- Add tool to this Hotbar
				hotbarButtons[i].Image = child.TextureId
				
				-- Set Count to 1
				hotbarButtons[i].Count.CountValue.Value = 1

				-- Set Tool Value
				hotbarTools[i][1] = child.Name
				
				-- Set Count
				hotbarTools[i][2] = 1				

				-- break Function
				break

			end		
		end		
	end	

	-- Nil Stuff
	toolInHotbar = nil
	
	-- For tutorial..
	if child.Name == "VialWithBlood" then

		-- Only if we have not completed it
		if thisPlayer.completedbloodobjective.Value == false then

			-- Update Server Side
			game.ReplicatedStorage.UpdateCompletedBloodObjectiveServerSide:FireServer()

			-- Complete Objective
			CompleteObjective(26)

		end			
	end
end)

-- Item Removed from Backpack..
thisPlayer.Backpack.ChildRemoved:Connect(function(child)
	
	-- If this item was a Hotbar item..
	for i = 1, 9 do

		-- If hotbartool is not nill..
		if hotbarTools[i][1] ~= nil then

			-- If they match
			if hotbarTools[i][1] == child.Name then
				
				-- Get ItemNums..
				local itemNum = GetItemCount(hotbarTools[i][1])	
				
				-- If we have less than before
				if itemNum > 0 then

					-- Update hotbarTools
					hotbarTools[i][2] = itemNum

					-- Update HotbarCount
					hotbarButtons[i].Count.CountValue.Value = itemNum

				elseif itemNum <= 0 then

					-- Remove It
					hotbarTools[i][1] = nil

					-- Reset Count
					hotbarTools[i][2] = 0						

					-- Remove image
					hotbarButtons[i].Image = ""

					-- Reset Count
					hotbarButtons[i].Count.CountValue.Value = 0				

				end
			end			
		end		
	end
end)

--------------------------------
-- HUD GUI Update Connections --
--------------------------------

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
		
	elseif health < (maxHealth - ((maxHealth / 3) * 2)) and health > 0 then
		
		-- Turn off other bloodScreen Effects
		bloodScreenLight.Visible = false
		bloodScreenLight.ImageTransparency = 0
		bloodScreenMedium.Visible = false
		bloodScreenMedium.ImageTransparency = 0

		-- Blood Screen Light Effect
		bloodScreenHeavy.Visible = true
		bloodScreenHeavy.ImageTransparency = 0
		
	elseif health <= 0 then
		
		-- run Death GUI
		DeathHintsGUI()
	end
end)

-- Updates Skull GUI When it Changes...
thisPlayer.leaderstats.skulls.Changed:Connect(function()

	-- Update GUI
	skullCountTextLabel.Text = thisPlayer.leaderstats.skulls.Value
	
end)

-- Update Blood GUI When it changes..
thisPlayer.blood.Changed:Connect(function()

	-- Update Blood Label
	bloodTextLabel.Text = thisPlayer.blood.Value
	
	-- If we havent seen the tutorial message..
	if gotBloodObjective == false then
		
		-- If we reached 50.. do tutorial..
		if thisPlayer.blood.Value >= 50 then

			-- Add new Objective..
			GivePlayerNewObjective({26, "You have enough blood to fill up a vial! Head to a Medical Fridge to exchange your blood for a vial of blood!"})
			
			-- Update Wether Got Objective..
			game.ReplicatedStorage.UpdateGotBloodObjectiveServerSide:FireServer()
			
			-- Got Objective
			gotBloodObjective = true
		end		
	end
end)

-- Lives Changes
thisPlayer.lives.Changed:Connect(function()

	-- Update Lives
	playerLivesTextLabel.Text = thisPlayer.lives.Value
	
end)

-- Recieving HUD Messages from Server --
game.ReplicatedStorage.SendPlayerHUDMessage.OnClientEvent:Connect(function(message)
	
	-- Update Message..
	UpdateHUDMessage(message)

end)

-- Event Sent from ServerUpTimeTracker to Update Current Round GUI..
game.ReplicatedStorage.NewRound.OnClientEvent:Connect(function(round)

	-- Update Round Labewl with Roman Numerals
	gameRoundTextLabel.Text = IntToRoman(round)

end)

-- Receieve Round when Player starts
game.ReplicatedStorage.SendRoundToClient.OnClientEvent:Connect(function(currentRound)

	-- Update GUI
	gameRoundTextLabel.Text = IntToRoman(currentRound)
end)

-- Check for Player Died Notification..
game.ReplicatedStorage.PlayerDiedSTC.OnClientEvent:Connect(function(playerName)
	
	-- If its this player..
	if playerName == thisPlayer.Name then
		
		-- Leave
		return
	end
	
	-- show Player Died in a Coroutinee
	local animateGUI = coroutine.create(AnimatePlayerDiedLabel)
	coroutine.resume(animateGUI, playerName)
	animateGUI = nil
end)


-- Listening for Game Time sent from ServerUpTimeTracker Script..
game.ReplicatedStorage.SendGameTimeSTC.OnClientEvent:Connect(function(gameTimeSeconds)
	
	gameTimeTextLabel.Text = FormatTime(gameTimeSeconds)
	
end)

-------------------------------------
-- Open Menus and Bags Connections --
-------------------------------------

-- Open Bag Button
bagButton.MouseButton1Click:Connect(BagButtonPressed)

-- Show GUI for Weapons Bench
game.ReplicatedStorage.PlayerOpenedWeaponsBench.OnClientEvent:Connect(OpenWeaponsBench)

-- Close Weapons Bench..
game.ReplicatedStorage.ClosePlayerWeaponsBenchSTC.OnClientEvent:Connect(function()
	
	-- Close the Weapopns Bench..
	if playerInWeaponsBench then	playerInWeaponsBench = false end
	
end)

------------------------
-- HotBar Connections --
------------------------

-- User Input Connection
UIS.InputBegan:Connect(function(input)
	
	-- If Game Over LEave
	if GAME_OVER then return end
	
	-- Xbox Support..
	if input.KeyCode == Enum.KeyCode.ButtonL1 then
		
		-- Ref Equipped Hotbar index..
		local index = nil
		local newIndex = nil
		
		-- If we have an equipped hotbar item right now...
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
		
		-- If we have moved to an empty hotbar position... then find the next non empty one..
		if hotbarTools[newIndex][1] == nil then
			
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
				if hotbarTools[newIndex][1] ~= nil then
					
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
		if hotbarTools[newIndex][1] == nil then

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
				if hotbarTools[newIndex][1] ~= nil then

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


----------------------------
-- Objectives Connections --
----------------------------

-- Receive New Objective
game.ReplicatedStorage.MissionEvents.GivePlayersObjective.OnClientEvent:Connect(function(objectiveArray)
	
	-- Run Function
	GivePlayerNewObjective(objectiveArray)
	
end)

-- Check for Completed Objectives..
game.ReplicatedStorage.MissionEvents.ObjectiveCompleteToClient.OnClientEvent:Connect(function(id)
	
	-- Run Function
	CompleteObjective(id)
	
end)

--------------------------------
-- Prompt Purchase Connection --
--------------------------------

-- Purchase Prompt
game.ReplicatedStorage.PromptGamePassPurchaseSTC.OnClientEvent:Connect(function(gamePassID)

	-- Player does NOT own the Pass; prompt them to purchase
	MarketplaceService:PromptGamePassPurchase(game.Players.LocalPlayer, gamePassID)

end)

-- Purchase Dev Item Connection
game.ReplicatedStorage.PromptDevItemPurchaseSTC.OnClientEvent:Connect(function(devItemID)

	-- Prompt Purchase..
	MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, devItemID)

end)

--------------------------------
-- Outro Custscene Connection --
--------------------------------

-- Get Game tIme when game is beat fort displaying..
game.ReplicatedStorage.SendGameTimeDataSTC.OnClientEvent:Connect(function(finalTime, isNewRecord)

	-- Is New Record?
	if isNewRecord == "true" then gotNewRecord = true end
	
	-- Format the time into minutes and seconds..
	local formattedTime = FormatTimeGameTime(finalTime/1000)

	-- Change Game Time Label..
	creditsFrame.GameBeatFrame.GameBeatTime.Text = formattedTime .. "!"

end)

game.ReplicatedStorage.MissionEvents.ScientistClearedWarehouseSTC.OnClientEvent:Connect(function()
	
	-- Game is Over
	GAME_OVER = true
	
	-- Turn off all HUD Stuff
	hudFrame.Visible = false
	hotbarFrame.Visible = false
	bagFrame.Visible = false
	weaponsBenchFrame.Visible = false
	objectiveIndicatorLabel.Visible = false
	objectiveCompleteIndicatorLabel.Visible = false
	playerDiedLabel.Visible = false
	gameTimeTextLabel.Visible = false
	creditsFrame.Visible = false
	script.Parent.HUDFrame.MainFrame.WeaponGUIFrame.Visible = false
	
	---------------------------------------
	-- Disable Controls and Reset button --
	---------------------------------------

	-- disable Player controls..
	local playerModule = require(thisPlayer.PlayerScripts:WaitForChild("PlayerModule"))
	local playerControlsModule = playerModule:GetControls()
	playerControlsModule:Disable()

	-- Stop Player from resetting Character during Cutscene..
	game:GetService("StarterGui"):SetCore("ResetButtonCallback", false)

	-- Unbind Actions
	ContextActionService:UnbindAllActions()
	
	----------------------------
	-- End Disabling Controls --
	----------------------------
	
	-- Enable Credits Frame -  Invisible First.;
	creditsFrame.SpecialThanks.TextTransparency = 1
	creditsFrame.TextBox.TextTransparency = 1
	creditsFrame.TitleLabel.ImageTransparency = 1
	creditsFrame.BackgroundTransparency = 1
	creditsFrame.GameBeatFrame.Visible = true
	creditsFrame.GameBeatFrame.GameBeatTime.Visible = false
	creditsFrame.GameBeatFrame.GameBeatTimeLabel.Visible = false
	creditsFrame.GameBeatFrame.NewRecordLabel.Visible = false
	creditsFrame.Visible = true
	
	-- Vars
	local transparency = 1	

	-- Make Screen Fade to Black..
	while transparency > 0 do

		-- Lower
		transparency -= 0.01

		-- Apply
		creditsFrame.BackgroundTransparency = transparency

		-- Wait
		task.wait()
	end
	
	-- Transparency is 0
	transparency = 0
	
	-- Play Engame Music
	endGameMusicSound:Play()
	
	-- Make Camera Scriptable
	workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
	
	-- Tween to Outro Cam CFrame..
	local TweenInformation = TweenInfo.new(5, Enum.EasingStyle.Circular, Enum.EasingDirection.Out)
	local TweenDetails = {
		["CFrame"] = workspace.OutroCutsceneCamPart.CFrame
	}

	local Tween = game.TweenService:Create(workspace.CurrentCamera, TweenInformation, TweenDetails)
	Tween:Play()	
	
	-- Wait
	task.wait(1)
	
	-- Flash Game Time
	while Tween.PlaybackState ~= Enum.PlaybackState.Completed do
		
		-- If its a record.. display that..
		if gotNewRecord then
			
			-- Show new Record
			if creditsFrame.GameBeatFrame.NewRecordLabel.Visible == false then
				
				-- Show it
				creditsFrame.GameBeatFrame.NewRecordLabel.Visible = true
			end
		end
		
		-- Flash Game Time..
		if creditsFrame.GameBeatFrame.GameBeatTime.Visible == false then
			
			-- Turn it on..
			creditsFrame.GameBeatFrame.GameBeatTime.Visible = true
		end
		
		-- Flash Game Time..
		if creditsFrame.GameBeatFrame.GameBeatTimeLabel.Visible == false then

			-- Turn it on..
			creditsFrame.GameBeatFrame.GameBeatTimeLabel.Visible = true
		end
		
		-- Wait
		task.wait()
	end
	
	-- fade back to white.. also fade game beat time..
	while transparency < 1 do

		-- Lower
		transparency += 0.01

		-- Apply
		creditsFrame.BackgroundTransparency = transparency
		
		-- Fade out game time too
		creditsFrame.GameBeatFrame.GameBeatTime.TextTransparency = transparency
		creditsFrame.GameBeatFrame.NewRecordLabel.TextTransparency = transparency
		creditsFrame.GameBeatFrame.GameBeatTimeLabel.TextTransparency = transparency

		-- Wait
		task.wait()
	end
	
	-- Transparewncy is 1
	transparency = 1
	
	-- Wait  a Sec
	task.wait(5)
	
	-------------------
	-- Roll Credits..--
	-------------------
	
	-- Show Credits Frame..
	while transparency > 0.33 do
		
		-- Lower
		transparency -= 0.01
		
		-- Apply
		creditsFrame.BackgroundTransparency = transparency
		
		-- Wait
		task.wait()
	end
	
	-- Reset and Re-use transparency for other elements...
	transparency = 1
	
	-- Wait
	task.wait(1)
	
	-- Show Game Title..
	while transparency > 0 do
		
		-- Lower
		transparency -= 0.01

		-- Apply
		creditsFrame.TitleLabel.ImageTransparency = transparency

		-- Wait
		task.wait()
	end
	
	-- Reset transparency
	transparency = 1
	
	-- Wait
	task.wait(1)

	-- Show Special Thanks ..
	while transparency > 0 do

		-- Lower
		transparency -= 0.01

		-- Apply
		creditsFrame.SpecialThanks.TextTransparency = transparency

		-- Wait
		task.wait()
	end
	
	-- Reset transparency
	transparency = 1
	
	-- Wait
	task.wait(1)

	-- Show TExtBox Thanks ..
	while transparency > 0 do

		-- Lower
		transparency -= 0.01

		-- Apply
		creditsFrame.TextBox.TextTransparency = transparency

		-- Wait
		task.wait()
	end	
	
end)

----------------------
-- Initialize Stuff --
----------------------

-- Setup Open Bag Binding..--
local bagButtonCAS = ContextActionService:BindActionAtPriority("BagButton", BagButtonActionPressed, true, 3333, Enum.KeyCode.ButtonSelect, Enum.KeyCode.I)

-- Now Adjust button if we are on a Touchscreen --
if UIS.TouchEnabled then
	
	-- State Var
	isTouchScreen = true

	-- Size button for screen --
	local bagButtonGUI = ContextActionService:GetButton("BagButton")
	bagButtonGUI.Size = UDim2.new(0,0,0,0)	

	-- Nil Stuff
	bagButtonGUI = nil
	
	-- Make sure bag button is showing..
	script.Parent.HUDFrame.BagButton.Visible = true
	
	-- Hide all Control Frames and only show bag..
	script.Parent.HUDFrame.PCControlsFrame.Visible = false
	script.Parent.HUDFrame.ConsoleControlsFrame.Visible = false

elseif GUIService:IsTenFootInterface() then
	
	-- Is Console
	isConsole = true
	
	-- Hide Mobile Bag
	script.Parent.HUDFrame.BagButton.Visible = false
	
	-- hide PC Frame
	script.Parent.HUDFrame.PCControlsFrame.Visible = false
	
	-- Show Console Controls Frame
	script.Parent.HUDFrame.ConsoleControlsFrame.Visible = true
	
else -- Is on PC
	
	-- Hide Mobile Bag
	script.Parent.HUDFrame.BagButton.Visible = false
	
	-- Hude Console Controls Frame
	script.Parent.HUDFrame.ConsoleControlsFrame.Visible = false

	-- Show PC Frame
	script.Parent.HUDFrame.PCControlsFrame.Visible = true	
	
end	

--------------
-- Init HUD --
--------------

-- Turn on HUD
hudFrame.Visible = true

-- Turn off BagFrame..
bagFrame.Visible = false

-- turn on Hotbar
hotbarFrame.Visible = true

-- Turn off Weapons Bench Frame
weaponsBenchFrame.Visible = false

-- Turn off Current Weapon Frame.
currentWeaponFrame.Visible = false

-- Turn off Object Indicator..
objectiveIndicatorLabel.Visible = false

-- Turn off Object  Complete Indicator..
objectiveCompleteIndicatorLabel.Visible = false

-- Turn off Playewr Died Indicator
playerDiedLabel.Visible = false

-- disable Credits Frame
creditsFrame.Visible = false

-- Turn off Tutorial Arrow
tutorialArrow.Visible = false

-- Initialize Hotbar
InitHotbar()

-- Update Init Skull count --
skullCountTextLabel.Text = thisPlayer.leaderstats.skulls.Value

-- Update Lives Left..
playerLivesTextLabel.Text = thisPlayer.lives.Value

-- Update Blood Label
bloodTextLabel.Text = thisPlayer.blood.Value

-- Game Message Blank
gameMessageTextLabel.Text = ''

-- Game Time Blank
gameTimeTextLabel.Visible = true
gameTimeTextLabel.Text = ""

-- Make Sure Blod Screen Efffec tis off..
bloodScreenLight.Visible = false
bloodScreenLight.ImageTransparency = 0
bloodScreenMedium.Visible = false
bloodScreenMedium.ImageTransparency = 0
bloodScreenHeavy.Visible = false
bloodScreenHeavy.ImageTransparency = 0

-- Make sure deathframe is off
deathFrame.Visible = false

-- Turn off all weapon GUIs
script.Parent.HUDFrame.MainFrame.WeaponGUIFrame.Visible = true

--------------------
-- GUI Tutorial.. --
--------------------

-- Check if got blood objectivew
if thisPlayer.gotbloodobjective.Value == true then
	
	-- Got it
	gotBloodObjective = true
	
	-- If we have not already completed it.. give objective again..
	if thisPlayer.completedbloodobjective.Value == false then
		
		--wait
		task.wait(3)

		-- Give player the Objective until it is complete...
		GivePlayerNewObjective({26, "You have enough blood to fill up a vial! Head to a Medical Fridge to exchange your blood for a vial of blood!"})		
		
	end	
end

-- Wait until playerInit pull DataStore tutorial info..
task.wait(6)


--[[
-- Open Bag Tutorial..,
if thisPlayer.finishedtutorial.Value == false then

	-- Is Displaying MEssage
	isDisplayingMessage = true
	
	-- if this is touchscreen..
	if isTouchScreen then
		
		-- Change Message
		gameMessageTextLabel.Text = "Open and Close your bag by clicking on the Bag icon to see your Items and Objectives."
		
	else
		
		-- Change Message
		gameMessageTextLabel.Text = "Open and Close your Bag with I (Keyboard) or Select (Xbox) to see your Items and Objectives."	
		
	end	

	-- Play sound
	notificationSound:Play()
	
	-- Reset player opened bag
	tutorialOpenedBag = false
	
	-- Wait until playr opens bag..
	while not tutorialOpenedBag do task.wait() end
	
	-- reset game message
	gameMessageTextLabel.Text = ""
	
	-- Not displaying message
	isDisplayingMessage = false
	
	-- Set it	
	game.ReplicatedStorage.UpdateTutorialStatusServerSide:FireServer()
	
end
]]

--[[
---------------------------------
-- HotBar tutorial Not Wokring --
---------------------------------

-- Check if finished tutorial.
if thisPlayer.finishedtutorial.Value == false then
	
	-- Is Displaying MEssage
	isDisplayingMessage = true
	
	-- Change Message
	gameMessageTextLabel.Text = "Open your Bag with I (Keyboard) or View (Xbox) to see your Items and Objectives."

	-- Play sound
	notificationSound:Play()
	
	-- Arrow Vars
	local arrowOffset = 25 -- Movement in Pixels
	local arrowStartPosX = nil
	local arrowStartPosY = nil
	local arrowPosX = nil
	local reachedLimit = true
	local arrowGUIOffset = UDim2.new(0,(tutorialArrow.Size.X.Scale * workspace.CurrentCamera.ViewportSize.X) + arrowOffset,0,36) -- 36 for Roblox GUIInset
	
	-- Main Flags
	local objectiveTutorialDone = false
	local hotbarTutorialDone = false
	local finishedPart1 = false
	
	-- States
	local playerInBagLast = playerInBag	
	local bagItemsFrameLast = bagItemsFrame.Visible
	local slotOptionsFrameLast = slotOptionsFrame.Visible	
	
	-- Arrow Positions..
	local arrowPos1 = UDim2.new(0, hudFrame.BagButton.AbsolutePosition.X + (hudFrame.BagButton.AbsoluteSize.X / 2), 0, hudFrame.BagButton.AbsolutePosition.Y + (hudFrame.BagButton.AbsoluteSize.Y / 2))  + arrowGUIOffset  --UDim2.new(-0.36, 0,0.135, 0) -- Bag Button 
	local arrowPos2 = UDim2.new(0, bagFrame.ObjectivesButton.AbsolutePosition.X + (bagFrame.ObjectivesButton.AbsoluteSize.X / 2), 0, bagFrame.ObjectivesButton.AbsolutePosition.Y + (bagFrame.ObjectivesButton.AbsoluteSize.Y / 2))  + arrowGUIOffset  --UDim2.new(0.875, 0,0.05, 0) -- Objectives Button
	local arrowPos3 = UDim2.new(0, bagFrame.BagButton.AbsolutePosition.X + (bagFrame.BagButton.AbsoluteSize.X / 2), 0, bagFrame.BagButton.AbsolutePosition.Y + (bagFrame.BagButton.AbsoluteSize.Y / 2)) + arrowGUIOffset -- Bag Menu Button
	local arrowPos4 = nil -- Flashlight Item Button
	local arrowPos5 = nil -- Move Slot Options Button
	local arrowPos6 = UDim2.new(1.115, 0,1.1, 0) -- HotBar Selection
	----------
	-- Init --
	----------
	
	-- Reset Flags..
	tutorialOpenedBag = false
	tutorialOpenedObjectives = false
	
	-- Show Arrow
	tutorialArrow.Visible = true
	
	-- Set into Position 1
	tutorialArrow.Position = arrowPos1

	-- Loop Vars..
	arrowStartPosX = tutorialArrow.Position.X.Offset
	arrowStartPosY = tutorialArrow.Position.Y.Offset
	arrowPosX = arrowStartPosX
	reachedLimit = true
	
	-- Loop until tutorial is done..
	while not (objectiveTutorialDone and hotbarTutorialDone) do
		
		-------------------
		-- Animate Arrow --
		-------------------
		if arrowPosX < arrowStartPosX + arrowOffset and reachedLimit then

			-- Move
			arrowPosX += 1 -- For Scale: -0.001

			-- Set It
			tutorialArrow.Position = UDim2.new(0, arrowPosX, 0, arrowStartPosY)

			-- Reached Limiti
			if arrowPosX >= arrowStartPosX + arrowOffset then

				-- Reached
				reachedLimit = false
			end		
		else

			-- Move Back Up
			arrowPosX -= 1 -- For Scale: 0.001

			-- Set It
			tutorialArrow.Position = UDim2.new(0, arrowPosX, 0, arrowStartPosY)

			-- Reached Limiti
			if arrowPosX <= arrowStartPosX then

				-- Reached
				reachedLimit = true
			end		
		end
		
		---------------------
		-- Check GUI State --
		---------------------

		-- If objectives has finished..
		if not objectiveTutorialDone then
			
			-- Only Change Arrow Pos when the Variable Changes..
			if playerInBagLast ~= playerInBag then

				-- Set PlayerInBag
				playerInBagLast = playerInBag

				-- Change Arrow Position..
				if playerInBag then
					
					-- Change Message
					gameMessageTextLabel.Text = "Click Objectives to see all of your current objectives."

					-- Set to Arrow Pos 2
					tutorialArrow.Position = arrowPos2

					-- Vars
					arrowStartPosX = tutorialArrow.Position.X.Offset
					arrowStartPosY = tutorialArrow.Position.Y.Offset
					arrowPosX = arrowStartPosX
					reachedLimit = true

				else
					
					-- Change Message
					gameMessageTextLabel.Text = "Open your Bag with I (Keyboard) or View (Xbox) to see your Items and Objectives."

					-- Set into Position..
					tutorialArrow.Position = arrowPos1

					-- Loop Vars..
					arrowStartPosX = tutorialArrow.Position.X.Offset
					arrowStartPosY = tutorialArrow.Position.Y.Offset
					arrowPosX = arrowStartPosX
					reachedLimit = true

				end			
			end
			
			-- Tut Done when player has completed both opening..
			if tutorialOpenedBag and tutorialOpenedObjectives then

				-- Tut done
				objectiveTutorialDone = true
				
				----------
				-- Init --
				----------

				-- Reset tutorialFlags
				tutorialOpenedSlotOptionsFrame = false
				tutorialOpenedBagItemsFrame = false

				-- Set into Position 1
				tutorialArrow.Position = arrowPos3

				-- Loop Vars..
				arrowStartPosX = tutorialArrow.Position.X.Offset
				arrowStartPosY = tutorialArrow.Position.Y.Offset
				arrowPosX = arrowStartPosX
				reachedLimit = true

				-- Turn off message
				gameMessageTextLabel.Text = "You can also Equip, Move, or Drop items by clicking on them in your bag!"

			end
			
		else
			
			-- Check if player closes bag..
			if playerInBagLast ~= playerInBag then
				
				-- Set PlayerInBag
				playerInBagLast = playerInBag

				-- Change Arrow Position..
				if not playerInBag then
					
					-- Change Message
					gameMessageTextLabel.Text = "Open your Bag with I (Keyboard) or View (Xbox) to see your Items and Objectives."

					-- Set into Position..
					tutorialArrow.Position = arrowPos1

					-- Loop Vars..
					arrowStartPosX = tutorialArrow.Position.X.Offset
					arrowStartPosY = tutorialArrow.Position.Y.Offset
					arrowPosX = arrowStartPosX
					reachedLimit = true
					
					-- Reset Flags
					bagItemsFrameLast = bagItemsFrame.Visible
					slotOptionsFrameLast = slotOptionsFrame.Visible

				else
					
					-- Change Message
					gameMessageTextLabel.Text = "Now click on the item to open the Item Options Menu."

					-- Set to Flashlight..
					arrowPos4 = UDim2.new(0, bagItemsFrame.ImageButton1.AbsolutePosition.X + (bagItemsFrame.ImageButton1.AbsoluteSize.X / 2), 0, bagItemsFrame.ImageButton1.AbsolutePosition.Y + (bagItemsFrame.ImageButton1.AbsoluteSize.Y / 2)) + arrowGUIOffset

					-- Set to Arrow Pos 2
					tutorialArrow.Position = arrowPos4

					-- Vars
					arrowStartPosX = tutorialArrow.Position.X.Offset
					arrowStartPosY = tutorialArrow.Position.Y.Offset
					arrowPosX = arrowStartPosX
					reachedLimit = true

					-- Reset other flags
					slotOptionsFrameLast = slotOptionsFrame.Visible
					playerInBagLast = playerInBag					
					
				end	
				
			elseif bagItemsFrameLast ~= bagItemsFrame.Visible then
				
				-- Set PlayerInBag
				bagItemsFrameLast = bagItemsFrame.Visible

				-- Change Arrow Position..
				if bagItemsFrame.Visible then

					-- Change Message
					gameMessageTextLabel.Text = "Now click on the item to open the Item Options Menu."

					-- Set to Flashlight..
					arrowPos4 = UDim2.new(0, bagItemsFrame.ImageButton1.AbsolutePosition.X + (bagItemsFrame.ImageButton1.AbsoluteSize.X / 2), 0, bagItemsFrame.ImageButton1.AbsolutePosition.Y + (bagItemsFrame.ImageButton1.AbsoluteSize.Y / 2)) + arrowGUIOffset

					-- Set to Arrow Pos 2
					tutorialArrow.Position = arrowPos4

					-- Vars
					arrowStartPosX = tutorialArrow.Position.X.Offset
					arrowStartPosY = tutorialArrow.Position.Y.Offset
					arrowPosX = arrowStartPosX
					reachedLimit = true
					
					-- Reset other flags
					slotOptionsFrameLast = slotOptionsFrame.Visible
					playerInBagLast = playerInBag

				else

					-- Turn off message
					gameMessageTextLabel.Text = "You can also Equip, Move, or Drop items by clicking on them in your bag!"

					-- Set into Position..
					tutorialArrow.Position = arrowPos3

					-- Loop Vars..
					arrowStartPosX = tutorialArrow.Position.X.Offset
					arrowStartPosY = tutorialArrow.Position.Y.Offset
					arrowPosX = arrowStartPosX
					reachedLimit = true
					
					-- Reset Flags
					slotOptionsFrameLast = slotOptionsFrame.Visible
					playerInBagLast = playerInBag

				end	
			elseif slotOptionsFrameLast ~= slotOptionsFrame.Visible and playerInBag then
				
				-- Set PlayerInBag
				slotOptionsFrameLast = slotOptionsFrame.Visible
				
				-- Leave if not the flashlight
				if currentSelectedBagItem then
					
					-- make sure
					if currentSelectedBagItem.Name == "ImageButton1" then
						
						-- Change Arrow Position..
						if slotOptionsFrame.Visible then

							-- Turn off message
							gameMessageTextLabel.Text = "Now click the HotBar Option..."

							-- Set ArrowPos
							arrowPos5 = UDim2.new(0, slotOptionsFrame.Move.AbsolutePosition.X + (slotOptionsFrame.Move.AbsoluteSize.X / 2), 0, slotOptionsFrame.Move.AbsolutePosition.Y + (slotOptionsFrame.Move.AbsoluteSize.Y / 2)) + arrowGUIOffset					

							-- Set to Arrow Pos 
							tutorialArrow.Position = arrowPos5

							-- Vars
							arrowStartPosX = tutorialArrow.Position.X.Offset
							arrowStartPosY = tutorialArrow.Position.Y.Offset
							arrowPosX = arrowStartPosX
							reachedLimit = true

							-- Reset flags
							bagItemsFrameLast = bagItemsFrame.Visible
							playerInBagLast = playerInBag

						else

							-- If we are not moving Tool yet..
							if not toolThatsMoving[1] then

								-- Change Message
								gameMessageTextLabel.Text = "Now click on the Item to open the Item Options Menu."

								-- Set to Flashlight..
								arrowPos4 = UDim2.new(0, bagItemsFrame.ImageButton1.AbsolutePosition.X + (bagItemsFrame.ImageButton1.AbsoluteSize.X / 2), 0, bagItemsFrame.ImageButton1.AbsolutePosition.Y + (bagItemsFrame.ImageButton1.AbsoluteSize.Y / 2)) + arrowGUIOffset

								-- Set to Arrow Pos 2
								tutorialArrow.Position = arrowPos4

								-- Vars
								arrowStartPosX = tutorialArrow.Position.X.Offset
								arrowStartPosY = tutorialArrow.Position.Y.Offset
								arrowPosX = arrowStartPosX
								reachedLimit = true

								-- Reset Flags
								bagItemsFrameLast = bagItemsFrame.Visible
								playerInBagLast = playerInBag

							else

								-- Turn off message
								gameMessageTextLabel.Text = "Now choose a new spot for your item on the HotBar."

								-- Set HotBar Arrow
								arrowPos6 = UDim2.new(0, hotbarFrame.AbsolutePosition.X + (hotbarFrame.AbsoluteSize.X / 2) , 0, hotbarFrame.AbsolutePosition.Y + (hotbarFrame.AbsoluteSize.Y / 2)) + arrowGUIOffset

								-- Set into Position..
								tutorialArrow.Position = arrowPos6

								-- Loop Vars..
								arrowStartPosX = tutorialArrow.Position.X.Offset
								arrowStartPosY = tutorialArrow.Position.Y.Offset
								arrowPosX = arrowStartPosX
								reachedLimit = true

								-- Reset Flags
								bagItemsFrameLast = bagItemsFrame.Visible
								playerInBagLast = playerInBag

							end
						end
					else
						
						-- Change Message
						gameMessageTextLabel.Text = "Now click on the Item to open the Item Options Menu."

						-- Set to Flashlight..
						arrowPos4 = UDim2.new(0, bagItemsFrame.ImageButton1.AbsolutePosition.X + (bagItemsFrame.ImageButton1.AbsoluteSize.X / 2), 0, bagItemsFrame.ImageButton1.AbsolutePosition.Y + (bagItemsFrame.ImageButton1.AbsoluteSize.Y / 2)) + arrowGUIOffset

						-- Set to Arrow Pos 2
						tutorialArrow.Position = arrowPos4

						-- Vars
						arrowStartPosX = tutorialArrow.Position.X.Offset
						arrowStartPosY = tutorialArrow.Position.Y.Offset
						arrowPosX = arrowStartPosX
						reachedLimit = true

						-- Reset Flags
						bagItemsFrameLast = bagItemsFrame.Visible
						playerInBagLast = playerInBag						
						
					end
				end							
			end
			
			-- Tut Done when player has completed both opening..
			if tutorialSelectedMove and tutorialSetMovingTool and tutorialOpenedBagItemsFrame and tutorialOpenedSlotOptionsFrame then

				-- Finish Tutorial
				hotbarTutorialDone = true

			end
		end	
		
		-- Wait
		task.wait()
	end
	
	-----------------------
	-- Tutorial Finished --
	-----------------------
	
	-- Turn off message
	gameMessageTextLabel.Text = ""

	-- Not Displaying MEssage
	isDisplayingMessage = false
	
	-- hide Arrow
	tutorialArrow.Visible = false

	-- Set it	
	game.ReplicatedStorage.UpdateTutorialStatusServerSide:FireServer()
	
end
]]