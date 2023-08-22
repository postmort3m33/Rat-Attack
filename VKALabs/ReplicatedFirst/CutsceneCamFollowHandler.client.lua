-- Remove Default Loading Bar..
script.Parent:RemoveDefaultLoadingScreen()

-- Debugging Stuff
local TEST_MODE = true -- Default: false

-- If in studio, is test mode
--if game:GetService("RunService"):IsStudio() then	TEST_MODE = true end

-- Services
local ContentProviderService = game:GetService("ContentProvider")
local StarterGUIService = game:GetService("StarterGui")

-- Disable Mouse Cursor
game:GetService("UserInputService").MouseIconEnabled = false

-- Disable Default HotBar..
StarterGUIService:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false) -- Disable hotbar
--StarterGUIService:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)

-----------------------------------
-- Retry Function for Core Calls --
-----------------------------------
-- Note: Sometimes Core Callss are 
-- not available so we have to keep
-- retrying until we get a result..

-- Vars
local MAX_RETRIES = 8
local CALL_WAIT_TIME = 0.5

-- the Core Call Function.
function CoreCall(method, ...)
	
	-- Define our pcall results..
	local result = {}
	
	-- Retry until we get a result..
	for retries = 1, MAX_RETRIES do
		result = {pcall(StarterGUIService[method], StarterGUIService, ...)}
		if result[1] then
			break
		end
		task.wait(CALL_WAIT_TIME)
	end
	
	-- Return results..
	return unpack(result)
end

-- Call it..
CoreCall('SetCore', 'ResetButtonCallback', false)

--------------------------
-- Core Call Finished.. --
--------------------------

-- This Player
local thisPlayer = game.Players.LocalPlayer

-- Place Loading Screen into Player GUI
local loadingGUI = script:WaitForChild("LoadingGUI")
loadingGUI.Parent = thisPlayer.PlayerGui

-- Player Count Stuff
local numPlayers = 1
local totalPlayers = 1

-- Wait for and disable mainGui
thisPlayer.PlayerGui:WaitForChild("MainGUI").Enabled = false
thisPlayer.PlayerGui.MainGUI.MainGUIController.Enabled = false

-----------------------------
-- Load Cutscene Van Stuff --
-----------------------------

-- Define Level To Load..
local toLoad1 = workspace:WaitForChild("CutsceneStuff"):GetDescendants()

-- Asset Nums
local totalToLoad1 = #toLoad1

-- Load 1st Assets..
for i, asset in ipairs(toLoad1) do

	-- Show Text..
	loadingGUI.Frame.AssetsLabel.Text = math.floor((i / totalToLoad1) * 100) .. "%"

	-- Preload..
	ContentProviderService:PreloadAsync({asset})
end

-- Wait
task.wait(1)

-- Cameras
local swatVanPlayersCamPart = workspace.CutsceneStuff.SwatVan:WaitForChild("WaitingForPlayersCameraPart")
local swatVanDriversCamPart = workspace.CutsceneStuff.SwatVan:WaitForChild("DriversCameraPart")
local mainCam = workspace.CurrentCamera

-- State Vars
local CUTSCENE_STARTED = false
local CUTSCENE_OVER = false
local VAN_STOPPED = false
local camToFollow = nil

-- Cutscene Started Connection
game.ReplicatedStorage.CutSceneEvents.CutSceneStartedFromServer.OnClientEvent:Connect(function()

	-- started
	CUTSCENE_STARTED = true
end)

-- Get Debugging Datyae
game.ReplicatedStorage.SendDebuggingDataSTC.OnClientEvent:Connect(function(data1, data2)
	
	-- Update screen
	if data1 then
		thisPlayer.PlayerGui.DebuggingGUI.DebugFrame.TextLabel1.Text = data1
	end
	
	if data2 then
		thisPlayer.PlayerGui.DebuggingGUI.DebugFrame.TextLabel2.Text = data2
	end
	
	-- wait
	task.wait(3)
	
	-- Delete
	thisPlayer.PlayerGui.DebuggingGUI.DebugFrame.TextLabel1.Text = ""
	thisPlayer.PlayerGui.DebuggingGUI.DebugFrame.TextLabel2.Text = ""

end)

-- Make sure Character Exists
if not thisPlayer.Character then thisPlayer.CharacterAdded:Wait() end

---------------------------
-- Begin Level Loading.. --
---------------------------

-- Change to Loading..
loadingGUI.Frame.LoadingLabel.Text = "" -- Default: = "Loading:"
loadingGUI.Frame.AssetsLabel.Text = ""

-- Coroutine To Shake Camera..
local camCoroutine = coroutine.wrap(function()
	
	-- Wait until it has started..
	while CUTSCENE_STARTED == false do
		
		-- Make Sure Gamepad Cursor is disabled
		if game:GetService("GamepadService").GamepadCursorEnabled then
			
			-- Disable It
			game:GetService("GamepadService"):DisableGamepadCursor()
		end

		-- Make Sure camera is On the Van
		if mainCam.CameraType ~= Enum.CameraType.Scriptable then

			-- Make it Scriptable
			mainCam.CameraType = Enum.CameraType.Scriptable			
			mainCam.CFrame = swatVanPlayersCamPart.CFrame
			camToFollow = swatVanPlayersCamPart
		end
		
		-- Make sure Loading Screen is turned off..
		if loadingGUI.Frame.BackgroundTransparency ~= 1 then
			
			-- Make sure it does..
			loadingGUI.Frame.BackgroundTransparency = 1
		end

		-- Shake Camera..
		mainCam.CFrame *= CFrame.new(math.random(-100,100) / 10000, math.random(-100,100) / 10000, math.random(-100,100) / 10000)

		-- Wait
		task.wait()

		-- Follow it
		mainCam.CFrame = camToFollow.CFrame	
	end
	
end)()

-------------------------
-- Load Rest of Assets --
-------------------------

-- Lists
local toLoad2 = workspace:WaitForChild("Level"):GetDescendants()
--local toLoad3 = workspace:WaitForChild("Props"):GetDescendants()

-- Numbered Lists
local totalToLoad2 = #toLoad2
--local totalToLoad3 = #toLoad3

-- If Not Test_Mode, run regularly..
if not TEST_MODE then
	
	-- Load 2nd Assets..
	for i, asset in ipairs(toLoad2) do

		-- Show Text..
		loadingGUI.Frame.AssetsLabel.Text = math.floor(((i / totalToLoad2) * 100)) .. "%" -- Default: add /2 after the 100
		
		-- If its a decal, dont preload it..
		if asset:IsA("Decal") or asset:IsA("Sound") or asset:IsA("Script") then

			-- Do Nothing

		else
			-- Preload..
			ContentProviderService:PreloadAsync({asset})

		end
	end
	
	--[[

	-- Wait
	task.wait(0.5)

	-- Load 3rd Assets..
	for i, asset in ipairs(toLoad3) do

		-- Show Text..
		loadingGUI.Frame.AssetsLabel.Text = math.floor( (((i / totalToLoad3) * 100)/2)+50) .. "%"
		
		-- If its a decal, dont preload it..
		if asset:IsA("Decal") or asset:IsA("Sound") then

			-- Do Nothing

		else
			-- Preload..
			ContentProviderService:PreloadAsync({asset})

		end
	end
	]]	
	
end

-- Wait
task.wait(1)

-- Clear Load Percentage..
loadingGUI.Frame.AssetsLabel.Text = ""

loadingGUI.Frame.LoadingLabel.Text = "Waiting for Players to Load..." -- Default: = "Waiting for Players to Join/Load..."

-- Wait
task.wait(1)

-- Client now loaded in.
game.ReplicatedStorage.CutSceneEvents.ClientLoadedInToServer:FireServer()

-- Wait for Cutscene To Start..
while CUTSCENE_STARTED == false do
	
	-- Wait
	task.wait()
	
end

--------------------------
-- CutScene Has Started --
--------------------------

-- Destroy Loadfing GUI..
loadingGUI:Destroy()

-----------------
-- Connections --
-----------------

-- Requests For Cam To Follow Parts..
game.ReplicatedStorage.CutSceneEvents.CameraFollowCFrame.OnClientEvent:Connect(function(camToFollowString)
	
	-- Set Csam to follow
	if camToFollowString == "SwatVanPlayersCam" then
		
		-- Set
		camToFollow = swatVanPlayersCamPart
		
	elseif camToFollowString == "SwatVanDriversCam" then
		
		-- Set
		camToFollow = swatVanDriversCamPart
		
	end	
end)

-- Van Not Moving Connection..
game.ReplicatedStorage.CutSceneEvents.VanStopped.OnClientEvent:Connect(function()
	
	-- Out of Van
	VAN_STOPPED = true
end)

-- Connection for CUTSCENE to be over..
game.ReplicatedStorage.CutSceneEvents.CutSceneOverFromServer.OnClientEvent:Connect(function()
	
	-- Set it
	CUTSCENE_OVER = true
end)

-- Loop
while CUTSCENE_OVER == false do
	
	-- Always Follow Cam to FOllow
	if camToFollow and VAN_STOPPED == false then
		
		-- Vars
		local xOffset = math.random(-100,100) / 10000
		local yOffset = math.random(-100,100) / 10000
		local zOffset = math.random(-100,100) / 10000

		-- Shake Camera..
		mainCam.CFrame *= CFrame.new(xOffset, yOffset, zOffset)
			
	end
	
	-- Wait
	task.wait()
	
	-- Follow it
	mainCam.CFrame = camToFollow.CFrame
end

-- Reset To PLayer
mainCam.CameraType = Enum.CameraType.Custom
thisPlayer.CameraMode = Enum.CameraMode.LockFirstPerson

-- Stop Player from resetting Character during Cutscene..
CoreCall('SetCore', 'ResetButtonCallback', true)

-- Enable GUI
thisPlayer.PlayerGui.MainGUI.Enabled = true
thisPlayer.PlayerGui.MainGUI.MainGUIController.Enabled = true

-- Enable ToolHandler..
thisPlayer.Character.ToolHandler.Enabled = true

-- Enable Pinger
thisPlayer.Character.PingHandler.Enabled = true

-- Wait and Destroy
task.wait(3)

-- Destroy
script:Destroy()



