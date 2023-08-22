-- Backed Up: 02/15/2023

---------------------
-- Start of Script --
---------------------

-- Services
local GUIService = game:GetService("GuiService")
GUIService.AutoSelectGuiEnabled = false -- turn this off for XBOX Support
local ContextActionService = game:GetService("ContextActionService")
local UIS = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")

-- This Player
local thisPlayer = game.Players.LocalPlayer
if not thisPlayer.Character then thisPlayer.CharacterAdded:Wait() end
local thisCharacter = thisPlayer.Character
local thisHumanoid = thisCharacter:WaitForChild("Humanoid")

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

-- Buttons
local exitButton = weaponsBenchFrame.ExitButton
local backButton = weaponsBenchFrame.BackButton
local currentWeaponFrameDamageUpgradeButton = currentWeaponFrame.Buttons.DamageUpgradeButton
local currentWeaponFrameRadiusUpgradeButton = currentWeaponFrame.Buttons.RadiusUpgradeButton
local currentWeaponFrameSpecialUpgradeButton = currentWeaponFrame.Buttons.SpecialUpgradeButton
local currentWeaponFramePowerUpgradeButton = currentWeaponFrame.Buttons.PowerUpgradeButton

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

-- Weapon Stuff
local equippedTool = nil
local equippedHotbar = nil
local toolThatsMoving = nil

-- Objects --
local bagButton = hudFrame.BagButton
local skullCountTextLabel = hudFrame.SkullCount
local gameMessageTextLabel = hudFrame.GameMessage
local gameRoundTextLabel = hudFrame.GameRound
local gameTimeTextLabel = hudFrame.GameTime
local playerLivesTextLabel = hudFrame.Lives
local bloodTextLabel = hudFrame.Blood
local weaponsBenchVialsLabel = weaponsBenchFrame.VialsLabel
local objectiveTemplate = objectivesFrame.ObjectiveTemplate
local subObjectiveTemplate = objectivesFrame.SubObjectiveTemplate
local objectiveIndicatorLabel = hudFrame.ObjectiveIndicator
local objectiveCompleteIndicatorLabel = hudFrame.ObjectiveCompleteIndicator
local playerDiedLabel = hudFrame.PlayerDiedText
local tutorialArrow = hudFrame.Arrow

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
local gotBloodObjective = false

-- Connections Vars
local playButtonPressedConnection = nil

-- State Vars
local playerInBag = false
local isDisplayingMessage = false
local currentWeapon = nil
local equipmentSoundPlaying = nil
local GAME_OVER = false

-- Bag Vars --
local slotConnections = {}
local dropConnections = {}
local equipConnections = {}
local moveConnections = {}
local gamepadBButtonBagConnection = nil
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
-----------------------
-- HUD GUI Functions --
-----------------------

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
		task.wait(3)

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

-- give Player New Objective
local function GivePlayerNewObjective(objectiveArray)
	
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

		-- Play Sound..
		if not squeal2Sound.IsPlaying then

			-- Play it
			squeal2Sound:Play()

		end		
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
end

-- Complete Objective
local function CompleteObjective(id)
	
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
	if weaponsBenchFrame.Visible == true then return end

	---------------------------------
	-- Turn off any Equipped Tools --
	---------------------------------

	-- If we have an equipped tool
	if equippedTool then

		-- If its the flamethrower..
		if equippedTool.Name == "Flamethrower" then

			-- Turn it off
			game.ReplicatedStorage.FlamethrowerOff:FireServer()
		end
	end

	-- Stop Player from moving..
	thisPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 0
	thisPlayer.Character.Humanoid.JumpPower = 0

	-- Show Weapons Bench Frame
	weaponsBenchFrame.Visible = true
	weaponsGridFrame.Visible = true
	currentWeaponFrame.Visible = false
	hudFrame.Visible = false
	hotbarFrame.Visible = false

	-- focus on exit button (XBOX Support)
	GUIService.SelectedObject = exitButton

	-- While Loop Vars
	local playerInWeaponsBench = true
	local exitButtonConnection = nil
	local backButtonConnection = nil
	local vialWithBloodButtonConnection = nil
	local localGamepadBButtonConnection = nil
	local localGamepadBButtonBackConnection = nil

	-- State Vars
	local initializedButtons = false

	-- Connection Arrays
	local buttonConnections = {}
	local imageButtons = {}

	-- Other vars
	local vials = {}

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

			-- Setup Exit Button Connection
			if not backButtonConnection then

				-- Setup connection
				backButtonConnection = backButton.MouseButton1Click:Connect(function()

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
									if hotbarTools[i] == vials[1] then

										-- Remove It
										hotbarTools[i] = nil

										-- Remove image
										hotbarButtons[i].Image = ""

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
									if hotbarTools[i] == vials[1] then

										-- Remove It
										hotbarTools[i] = nil

										-- Remove image
										hotbarButtons[i].Image = ""

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
									if hotbarTools[i] == vials[1] then

										-- Remove It
										hotbarTools[i] = nil

										-- Remove image
										hotbarButtons[i].Image = ""

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
									if hotbarTools[i] == vials[1] then

										-- Remove It
										hotbarTools[i] = nil

										-- Remove image
										hotbarButtons[i].Image = ""

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
									if hotbarTools[i] == vials[1] then

										-- Remove It
										hotbarTools[i] = nil

										-- Remove image
										hotbarButtons[i].Image = ""

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
									if hotbarTools[i] == vials[1] then

										-- Remove It
										hotbarTools[i] = nil

										-- Remove image
										hotbarButtons[i].Image = ""

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
									if hotbarTools[i] == vials[1] then

										-- Remove It
										hotbarTools[i] = nil

										-- Remove image
										hotbarButtons[i].Image = ""

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
									if hotbarTools[i] == vials[1] then

										-- Remove It
										hotbarTools[i] = nil

										-- Remove image
										hotbarButtons[i].Image = ""

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
									if hotbarTools[i] == vials[1] then

										-- Remove It
										hotbarTools[i] = nil

										-- Remove image
										hotbarButtons[i].Image = ""

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
									if hotbarTools[i] == vials[1] then

										-- Remove It
										hotbarTools[i] = nil

										-- Remove image
										hotbarButtons[i].Image = ""

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
									if hotbarTools[i] == vials[1] then

										-- Remove It
										hotbarTools[i] = nil

										-- Remove image
										hotbarButtons[i].Image = ""

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
									if hotbarTools[i] == vials[1] then

										-- Remove It
										hotbarTools[i] = nil

										-- Remove image
										hotbarButtons[i].Image = ""

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
									if hotbarTools[i] == vials[1] then

										-- Remove It
										hotbarTools[i] = nil

										-- Remove image
										hotbarButtons[i].Image = ""

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
									if hotbarTools[i] == vials[1] then

										-- Remove It
										hotbarTools[i] = nil

										-- Remove image
										hotbarButtons[i].Image = ""

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
									if hotbarTools[i] == vials[1] then

										-- Remove It
										hotbarTools[i] = nil

										-- Remove image
										hotbarButtons[i].Image = ""

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

	-- Let Player Walk Again
	thisPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 16
	thisPlayer.Character.Humanoid.JumpPower = 50
	
	-- Playt Scientist LEave Bench Sound
	local random = math.random(1, #leaveWeaponsBenchAudioArray)
	leaveWeaponsBenchAudioArray[random]:Play()
	random = nil

	-- Nil Stuff
	playerInWeaponsBench = nil
	initializedButtons = nil
	buttonConnections = nil
	imageButtons = nil
	vials = nil
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
			
			-- Add Border
			if toolThatsMoving == equippedTool then
				
				-- Highlight it..
				hotbarButton.BorderSizePixel = 2
				
			end

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
					
					-- Remove border
					hotbarButtons[i].BorderSizePixel = 0
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
		
		-- Create New Buttons..
		local newImageButton = Instance.new("ImageButton")
		newImageButton.Name = "ImageButton" .. tostring(i)
		newImageButton.Parent = bagItemsFrame
		newImageButton.Image = tool.TextureId
		newImageButton.Modal = true
		newImageButton.BorderSizePixel = 0
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
		newTextLabel.Font = Enum.Font.PermanentMarker
		
		-- Set Labelk Text..
		for _, itemArray in pairs(itemDisplayNameTable) do
			
			-- Look for this Tool/Item Name
			if itemArray[1] == tool.Name then
				
				-- Set Text Label
				newTextLabel.Text = itemArray[2]
			end
		end

		-- New Connections
		local slotConnection = nil
		local dropConnection = nil
		local equipConnection = nil
		local moveConnection = nil		

		-- Create a click COnnection
		slotConnection = newImageButton.MouseButton1Click:Connect(function()
			
			-- If we are moving a tool, leave this function
			if toolThatsMoving then
				
				-- Leave
				return
			end
			
			-- If Options was Open.. Close it and sever previous connections..
			if slotOptionsFrame.Visible == true then
				
				-- Make it visible
				slotOptionsFrame.Visible = false
				
				-- Delete Last Options Connection
				if dropConnection then
					dropConnection:Disconnect()
					dropConnection = nil
				end

				-- Delete Last Options Connection
				if equipConnection then
					equipConnection:Disconnect()
					equipConnection = nil	
				end
				
				-- focus on this button (XBOX Support)
				GUIService.SelectedObject = newImageButton
				
			elseif slotOptionsFrame.Visible == false then
				
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

						-- Hide Options Window
						slotOptionsFrame.Visible = false

						-- Delete Last Options Connection
						if dropConnection then
							dropConnection:Disconnect()
							dropConnection = nil
						end

						-- Delete Last Options Connection
						if equipConnection then
							equipConnection:Disconnect()
							equipConnection = nil	
						end

						-- Delete Last Options Connection
						if moveConnection then
							moveConnection:Disconnect()
							moveConnection = nil	
						end						

						-- Set Selected Object To Play Button (XBOX Support)
						GUIService.SelectedObject = newImageButton

					else
						
						-- Drop the Tool ..
						game.ReplicatedStorage.RemoveToolFromPlayerServerSide:FireServer(tool)					

						-- Hide Options Window
						slotOptionsFrame.Visible = false

						-- Delete Last Options Connection
						if dropConnection then
							dropConnection:Disconnect()
							dropConnection = nil
						end

						-- Delete Last Options Connection
						if equipConnection then
							equipConnection:Disconnect()
							equipConnection = nil	
						end

						-- Delete Last Options Connection
						if moveConnection then
							moveConnection:Disconnect()
							moveConnection = nil	
						end

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
				end)
				
				-- Add Drop Connection
				table.insert(dropConnections, dropConnection)

				-- Make Connection for Clicking the Equip Button
				equipConnection = slotOptionsFrame.Equip.MouseButton1Click:Connect(function()
					
					-- Move Equipped Tool to Backpack
					if equippedTool then
						
						-- Equip It
						equippedTool.Parent = thisPlayer.Backpack	
						
					end
					
					-- If this tool was in hotbar..
					local toolWasInHotbar = false
					
					-- If this tool was in the Hotbar, Equip it..
					for i = 1, 9 do

						-- If they match
						if hotbarTools[i] == tool then
							
							toolWasInHotbar = true

							-- Activate
							ActivateHotbar(i)
						end

					end
					
					-- If it was not in hotbar, equip it still..
					if toolWasInHotbar == false then
						
						-- Move Tool we want to Equip to players hand..
						tool.Parent = thisPlayer.Character
						
					end
					
					---------------------------------------
					-- Hide window and Sever Connections --
					---------------------------------------

					-- Hide Options Window
					slotOptionsFrame.Visible = false

					-- Delete Last Options Connection
					if dropConnection then
						dropConnection:Disconnect()
						dropConnection = nil
					end

					-- Delete Last Options Connection
					if equipConnection then
						equipConnection:Disconnect()
						equipConnection = nil	
					end
					
					-- Delete Last Options Connection
					if moveConnection then
						moveConnection:Disconnect()
						moveConnection = nil	
					end

					-- Set Selected Object To Play Button (XBOX Support)
					GUIService.SelectedObject = newImageButton
					
					-- Nil Stuff
					toolWasInHotbar = nil
				end)
				
				-- Insert into Table
				table.insert(equipConnections, equipConnection)
				
				-- Move connection
				moveConnection = slotOptionsFrame.Move.MouseButton1Click:Connect(function()
					
					-- Hise Slot Options Frame
					slotOptionsFrame.Visible = false
					
					-- Select this Button..
					GUIService.SelectedObject = hotbarButton1
					
					-- Set tool Thats moving
					toolThatsMoving = tool
					
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
						
						-- Unless Tool Thats moving has been placed.. keep waiting..
						while toolThatsMoving do
							
							-- If Player leave bag, sever this..
							if playerInBag == false then
								
								-- Nil Toolthatsmoving
								toolThatsMoving = nil
								
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
						
						-- Deactivate Backpack GUI
						bagItemsFrame.Active = true
						
						------------------------------
						-- If tool has been moved.. --
						------------------------------
						GUIService.SelectedObject = newImageButton

					end)()
					
					-- Delete Last Options Connection
					if dropConnection then
						dropConnection:Disconnect()
						dropConnection = nil
					end

					-- Delete Last Options Connection
					if equipConnection then
						equipConnection:Disconnect()
						equipConnection = nil	
					end

					-- Delete Last Options Connection
					if moveConnection then
						moveConnection:Disconnect()
						moveConnection = nil	
					end
				end)
				
				-- Add to Table
				table.insert(moveConnections, moveConnection)

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

					-- Delete Last Options Connection
					if dropConnection then
						dropConnection:Disconnect()
						dropConnection = nil	
					end

					-- Delete Last Options Connection
					if equipConnection then
						equipConnection:Disconnect()
						equipConnection = nil	
					end
					
					-- Delete Last Options Connection
					if moveConnection then
						moveConnection:Disconnect()
						moveConnection = nil
					end

				end)()				
				
			end
		end)

		-- Add to Connections Array
		table.insert(slotConnections, slotConnection)		
		
	end
	
end

-- Bag Button Pressed
local function BagButtonPressed()
	
	-- If Game Over Leave
	if GAME_OVER then return end
	
	-- If this player is dead.. Dont Open..
	if thisPlayer.Character.Humanoid.Health <= 0 then return end
	
	-- Check for Tutorial
	if tutorialOpenedBag == false then tutorialOpenedBag = true end
	
	-- If Weapons Bench is Open, Leave Function
	if weaponsBenchFrame.Visible == true then return end
	
	-- If bag was closed.. Open It..
	if playerInBag == false then
		
		-- Now Player in Bag
		playerInBag = true
		
		---------------------------------
		-- Turn off any Equipped Tools --
		---------------------------------
		
		-- If we have an equipped tool
		if equippedTool then

			-- If its the flamethrower..
			if equippedTool.Name == "Flamethrower" then

				-- Turn it off
				game.ReplicatedStorage.FlamethrowerOff:FireServer()
			end
		end

		-- Play Ziper Sound
		zipperSound:Play()
		
		-- Animate Button..
		local animateIconCoroutine = coroutine.create(AnimateBagButton)
		coroutine.resume(animateIconCoroutine)
		animateIconCoroutine = nil

		-- Open Bag Frame
		bagFrame.Visible = true
		bagItemsFrame.Visible = true
		
		-- Show Objectives Button Selected
		bagSelectionButton.BackgroundTransparency = 1
		slotOptionsFrame.Visible = false
		
		-- Show Objectives Button Unselected
		objectivesFrame.Visible = false
		objectivesSelectionButton.BackgroundTransparency = 0
		
		-- Get Player vials
		local vials = GetPlayerVials()

		-- Show Number of Vials
		if vials == {} then

			-- Zero Vials
			bagFrame.VialsLabel.Text = "Vials: 0"
			
			-- Nil
			vials = nil

		else

			-- Set vials
			bagFrame.VialsLabel.Text = "Vials: " .. #vials
			
			-- Nil
			vials = nil

		end

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
			
		end)
		
		-- For Objectives Button
		objectivesSelectionButtonConnection = objectivesSelectionButton.MouseButton1Click:Connect(function()
			
			-- Tutorial..
			if tutorialOpenedObjectives == false then tutorialOpenedObjectives = true end
			
			-- Close Bag Frmae
			bagItemsFrame.Visible = false
			slotOptionsFrame.Visible = false
			bagSelectionButton.BackgroundTransparency = 0
			
			-- Open and Select Objectives Frame
			objectivesFrame.Visible = true
			objectivesSelectionButton.BackgroundTransparency = 1
			GUIService.SelectedObject = objectivesSelectionButton
			
		end)
		
		-- XBOX Support Back Button
		gamepadBButtonBagConnection = UIS.InputBegan:Connect(function(input)
			
			-- B Button
			if input.KeyCode == Enum.KeyCode.ButtonB then
				
				-- Close Bag..
				BagButtonPressed()
				
			end
		end)
		
	elseif playerInBag == true then -- If Bag was Open.. Close It..
		
		-- Player not in Bag
		playerInBag = false
		
		-- Play Sound
		zipperCloseSound:Play()
		
		-- Animate Button..
		local animateIconCoroutine = coroutine.create(AnimateBagButton)
		coroutine.resume(animateIconCoroutine)
		animateIconCoroutine = nil

		-- Bag Frame Visibility
		bagFrame.Visible = false
		
		----------------------------
		-- Delete All Connections --
		----------------------------
		
		-- Slot Connections
		for _, v in pairs(slotConnections) do

			-- Disconnect
			v:Disconnect()
			v = nil
		end
		
		-- Disconnect Back Button Connection
		if gamepadBButtonBagConnection then
			
			-- Disconnect
			gamepadBButtonBagConnection:Disconnect()
			gamepadBButtonBagConnection = nil
		end
		
		-- Disconnect BagSelection Button Connection
		if bagSelectionButtonConnection then

			-- Disconnect
			bagSelectionButtonConnection:Disconnect()
			bagSelectionButtonConnection = nil
		end
		
		-- Disconnect Objectives Selection Button Connection
		if objectivesSelectionButtonConnection then

			-- Disconnect
			objectivesSelectionButtonConnection:Disconnect()
			objectivesSelectionButtonConnection = nil
		end
		
		-- Drop connections
		for _, connection in pairs(dropConnections) do
			
			if connection then
				
				-- Disconnect
				connection:Disconnect()
				connection = nil
			end
		end
		
		-- Equip connections
		for _, connection in pairs(equipConnections) do

			if connection then

				-- Disconnect
				connection:Disconnect()
				connection = nil
			end
		end
		
		-- Hotbar connections
		for _, connection in pairs(moveConnections) do

			if connection then

				-- Disconnect
				connection:Disconnect()
				connection = nil
			end
		end
		
		-- Reset connections Arrays
		slotConnections = {}
		dropConnections = {}
		equipConnections = {}
		
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

		-- Reset Selected GUI
		GUIService.SelectedObject = nil	
		
	end					
	
end

-- Bag Button Action --
local function BagButtonActionPressed(actionName, inputState, inputObj)

	-- Make sure we only fire function once on Input Begin.. --
	if inputState == Enum.UserInputState.Begin then
		
		-- Runc Function
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
				hotbarButtons[i].BorderSizePixel = 2				

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
					
					-- Delete Border if this was equipped..
					hotbarButtons[i].BorderSizePixel = 0

					-- Nil Stuff
					itemWentToBackpack = nil
					
				else -- Item was Thrown, or dropped from Bag..

					-- Remove It
					hotbarTools[i] = nil

					-- Remove image
					hotbarButtons[i].Image = ""

					-- Delete Border if this was equipped..
					hotbarButtons[i].BorderSizePixel = 0

					-- Nil Stuff
					itemWentToBackpack = nil

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

	-- Update HUD Message as a Coroutine since it has a wait time
	local updateHUDCoroutine = coroutine.create(UpdateHUDMessage)

	-- Run it..
	coroutine.resume(updateHUDCoroutine, message)

	-- Nil Stuff
	updateHUDCoroutine = nil

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

--[[
-- Listening for Game Time sent from ServerUpTimeTracker Script..
game.ReplicatedStorage.SendGameTimeSTC.OnClientEvent:Connect(function(gameTimeSeconds)
	
	gameTimeTextLabel.Text = FormatTime(gameTimeSeconds)
	
end)
]]

-------------------------------------
-- Open Menus and Bags Connections --
-------------------------------------

-- Open Bag Button
bagButton.MouseButton1Click:Connect(BagButtonPressed)

-- Show GUI for Weapons Bench
game.ReplicatedStorage.PlayerOpenedWeaponsBench.OnClientEvent:Connect(OpenWeaponsBench)

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
	local TweenInformation = TweenInfo.new(3, Enum.EasingStyle.Circular, Enum.EasingDirection.Out)
	local TweenDetails = {
		["CFrame"] = workspace.OutroCutsceneCamPart.CFrame
	}

	local Tween = game.TweenService:Create(workspace.CurrentCamera, TweenInformation, TweenDetails)
	Tween:Play()
	Tween.Completed:Wait()
	
	-- fade back to white..
	while transparency < 1 do

		-- Lower
		transparency += 0.01

		-- Apply
		creditsFrame.BackgroundTransparency = transparency

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

	-- Size button for screen --
	local bagButtonGUI = ContextActionService:GetButton("BagButton")
	bagButtonGUI.Size = UDim2.new(0,0,0,0)	

	-- Nil Stuff
	bagButtonGUI = nil

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

-- Check if finished tutorial.
if thisPlayer.finishedtutorial.Value == false then
	
	-- Wait until Get New Objective..
	task.wait(3)
	
	-- Show Message
	local messageCoroutine = coroutine.create(UpdateHUDMessage)
	coroutine.resume(messageCoroutine, "Open the bag to see your current objectives.")
	messageCoroutine = nil
	
	-- State Vars
	local tutorialDone = false
	local playerInBagLast = playerInBag
	local reachedLimit = true
	
	-- Arrow Vars
	local arrowPos1 = UDim2.new(0.09 , 0 , 0.2 , 0)
	local arrowPos2 = UDim2.new(0.77, 0,0.139, 0)
	local arrowOffset = 0.015
	local arrowStartPosX = nil
	local arrowStartPosY = nil
	local arrowPosX = nil
	
	----------
	-- Init --
	----------
	
	-- Show Arrow
	tutorialArrow.Visible = true
	
	-- Set into Position 1
	tutorialArrow.Position = arrowPos1

	-- Loop Vars..
	arrowStartPosX = tutorialArrow.Position.X.Scale
	arrowStartPosY = tutorialArrow.Position.Y.Scale
	arrowPosX = arrowStartPosX
	reachedLimit = true
	
	-- Loop until tutorial is done..
	while tutorialDone == false do
		
		-- Only Change Arrow Pos when the Variable Changes..
		if playerInBagLast ~= playerInBag then
			
			-- Set PlayerInBag
			playerInBagLast = playerInBag
			
			-- Change Arrow Position..
			if playerInBag then
				
				-- Set to Arrow Pos 2
				tutorialArrow.Position = arrowPos2

				-- Vars
				arrowStartPosX = tutorialArrow.Position.X.Scale
				arrowStartPosY = tutorialArrow.Position.Y.Scale
				arrowPosX = arrowStartPosX
				reachedLimit = true

			else

				-- Set into Position..
				tutorialArrow.Position = arrowPos1

				-- Loop Vars..
				arrowStartPosX = tutorialArrow.Position.X.Scale
				arrowStartPosY = tutorialArrow.Position.Y.Scale
				arrowPosX = arrowStartPosX
				reachedLimit = true
				
			end			
		end
		
		-------------------
		-- Animate Arrow --
		-------------------
		if arrowPosX > arrowStartPosX - arrowOffset and reachedLimit then

			-- Move
			arrowPosX -= 0.001

			-- Set It
			tutorialArrow.Position = UDim2.new(arrowPosX, 0, arrowStartPosY, 0)

			-- Reached Limiti
			if arrowPosX <= arrowStartPosX - arrowOffset then

				-- Reached
				reachedLimit = false
			end		
		else

			-- Move Back Up
			arrowPosX += 0.001

			-- Set It
			tutorialArrow.Position = UDim2.new(arrowPosX, 0, arrowStartPosY, 0)

			-- Reached Limiti
			if arrowPosX >= arrowStartPosX then

				-- Reached
				reachedLimit = true
			end		
		end
				
		-- Tut Done when player has completed both opening..
		if tutorialOpenedBag and tutorialOpenedObjectives then
			
			-- Tut done
			tutorialDone = true
			
		end
		
		-- Wait
		task.wait()
	end
	
	-- Turn off Arrow
	tutorialArrow.Visible = false

	-----------------------
	-- Tutorial Finished --
	-----------------------

	-- Set it	
	game.ReplicatedStorage.UpdateTutorialStatusServerSide:FireServer()
	
end

--------------
-- Old Code --
--------------

--[[
-----------------------
-- Extra Life button --
-----------------------

if not extraLifeButtonConnection then

	-- Connect It..
	extraLifeButtonConnection = weaponsBenchFrame.ExtraLifeButton.MouseButton1Click:Connect(function()

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
		if #vials >= 5 then

			-- Take Needed Vials from Player..
			for i = 1, 5 do

				-- Destroy Vials
				vials[1]:Destroy()

				-- If this tool was in the Hotbar, remove it..
				for i = 1, 9 do

					-- If they match
					if hotbarTools[i] == vials[1] then

						-- Remove It
						hotbarTools[i] = nil

						-- Remove image
						hotbarButtons[i].Image = ""

					end

				end	

				-- Remove this Tool Server Side
				game.ReplicatedStorage.RemoveToolFromPlayerServerSide:FireServer(vials[1])

				-- Delete from tbale
				table.remove(vials, 1)
			end

			-- Update Vials Label
			if vials == {} then
				-- Zero Vials
				weaponsBenchVialsLabel.Text = "Vials: 0"
			else
				-- Set vials
				weaponsBenchVialsLabel.Text = "Vials: " .. #vials
			end

			-- Update Player Lives Server Side..
			game.ReplicatedStorage.AddLifeToPlayerServerSide:FireServer()

			-- Play Scientist Sound..
			local random = math.random(1, #thanksAudioArray)
			thanksAudioArray[random]:Play()
			random = nil

		else

			-- Not Enough Vials
			notEnoughBloodAudioArray[math.random(1,2)]:Play()					

		end
	end)	
end
]]