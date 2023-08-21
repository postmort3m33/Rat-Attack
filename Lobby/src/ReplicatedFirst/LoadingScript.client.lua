-- Wait
task.wait()

-- Remove Default Loading Bar..
script.Parent:RemoveDefaultLoadingScreen()

-- Test Mode
local TEST_MODE = true

-- If in studio, is test mode
--if game:GetService("RunService"):IsStudio() then	TEST_MODE = true end

-- Services
local StarterGUIService = game:GetService("StarterGui")

-- Disable Default HotBar..
StarterGUIService:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false) -- Disable hotbar

-- This Player
local thisPlayer = game.Players.LocalPlayer

-- Place Loading Screen into Player GUI
local loadingGUI = script.LoadingGUI
loadingGUI.Parent = thisPlayer.PlayerGui

-- Get Image
local studioImage = loadingGUI.StudioImageFrame.StudioImage

-- Init
loadingGUI.Frame.Visible = false
loadingGUI.StudioImageFrame.Visible = true

-- Init Image
studioImage.Visible = true
studioImage.ImageTransparency = 1

-- Wait
task.wait(1)

------------------------
-- Show Studio Banner --
------------------------

-- Trans Var..
local transparency = 1

-- Fade In
while transparency > 0 do
	
	-- Lower Trans
	transparency -= 0.01
	
	-- Apply
	studioImage.ImageTransparency = transparency	
	
	-- Wait
	task.wait()
end

-- Set to 0
studioImage.ImageTransparency = 0

-- Show for a few seconds..
task.wait(3)

-- Fade Out..
while transparency < 1 do

	-- Lower Trans
	transparency += 0.01

	-- Apply
	studioImage.ImageTransparency = transparency	

	-- Wait
	task.wait()
end

-- Set to 1
studioImage.ImageTransparency = 1

-- Wait
task.wait(1)

-- Turn on loading screen.
--loadingGUI.Frame.Visible = true
--loadingGUI.StudioImageFrame.Visible = false

-- Turn off Image
studioImage.Visible = false

-- Wait
task.wait(1)

-- Get Services
local GUIService = game:GetService("GuiService")
local ContentProviderService = game:GetService("ContentProvider")

-- Define Level To Load..
local levelToLoad = workspace:WaitForChild("Level"):GetDescendants()

-- Represent Loading on GUI
local totalAssets = #levelToLoad

-- Load Assets one at a time..
if not TEST_MODE then
	
	-- Loop
	for i, asset in ipairs(levelToLoad) do

		-- Show Text..
		loadingGUI.Frame.AssetsLabel.Text = math.floor((i / totalAssets) * 100) .. "%"
		
		-- If its a decal, dont preload it..
		if asset:IsA("Decal") or asset:IsA("Sound") or asset:IsA("Script") then
			
			-- Do Nothing
			
		else
			-- Preload..
			ContentProviderService:PreloadAsync({asset})
			
		end	
	end	
end

-- Make Sure Game is loaded..
if not game:IsLoaded() then
	
	-- Wait
	game.Loaded:Wait()

end

-- When Finished.. Destroy Screen
loadingGUI:Destroy()

----------------------------
-- Start Menu Code Starts --
----------------------------

-- Move StartMenu GUI to player GUI
local startMenuGUI = script.StartMenuGUI
startMenuGUI.Parent = thisPlayer.PlayerGui

-- Camera Stuff
local mainCam = workspace.CurrentCamera
local menuCam = workspace.Level:WaitForChild("MenuCameraPart")

-- Connections --
local playButtonConnection = nil

------------------------------------
-- Now Reference Player GUI Stuff --
------------------------------------

local startMenuFrame = thisPlayer.PlayerGui.StartMenuGUI.StartMenuFrame
local playButton = thisPlayer.PlayerGui.StartMenuGUI.StartMenuFrame.PlayButton
local skullSound = startMenuFrame.SkullPickup
local menuMusic = startMenuFrame.MenuMusic
local outsideRainSound = startMenuFrame.OutsideRain
local outsideCrickets = startMenuFrame.OutsideCrickets

---------------
-- Functions --
---------------

-- Fade Menu Music..
local function FadeOutMenuMusic()

	-- Vars
	local volumeIncrement = menuMusic.Volume

	-- Loop
	while volumeIncrement > 0 do

		-- Set Music Volume
		menuMusic.Volume = volumeIncrement
		outsideRainSound.Volume = volumeIncrement

		-- Decrease Volume..
		volumeIncrement -= 0.1

		-- Wait
		task.wait(0.15)
	end

	-- Stop the Music
	menuMusic:Stop()
	outsideRainSound:Stop()

	-- Nil Stuff
	volumeIncrement = nil
end

-------------------------------------
-- Display Background Level Menu.. --
-------------------------------------

-- Make Camera Scriptable
mainCam.CameraType = Enum.CameraType.Scriptable

-- Show Menu Camera..
mainCam.CFrame = menuCam.CFrame

-- Play Menu Music
menuMusic:Play()

-- Play Outside Rain Sound
--outsideRainSound:Play()
outsideCrickets:Play()

-- Wait --
task.wait(3)

-- Show Play Button --
playButton.Visible = true

-- Set Selected Object To Play Button (XBOX Support)
GUIService.SelectedObject = playButton

-----------------
-- Connections --
-----------------

-- If Play button is pressed.. --
playButtonConnection = playButton.MouseButton1Click:Connect(function()

	-- Play Skull It --
	skullSound:Play()

	-- Now move Camera to player..
	mainCam.CameraType = Enum.CameraType.Custom

	-- Fire Playbutton for Server Use too
	game.ReplicatedStorage.PlayButtonPressedLocally:FireServer()

	-- Tuen the Main Menu Off to Play game --
	startMenuFrame.Visible = false

	-- Reset Selected GUI (Xbox Support)
	GUIService.SelectedObject = nil
	
	-- Disable Mouse Cursor
	game:GetService("UserInputService").MouseIconEnabled = false

	-- Fade out Music
	FadeOutMenuMusic()

	-- Disconnect this
	playButtonConnection:Disconnect()
	playButtonConnection = nil
	
	-- Destroy this GUI
	startMenuGUI:Destroy()

end)
