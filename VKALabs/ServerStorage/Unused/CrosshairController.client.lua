-- Wait for game loaded..
while task.wait() do

	-- Break when game is loaded..
	if game:IsLoaded() then

		-- Leave
		break
	end
end

---------------------
-- Start of Script --
---------------------

-- Load Character --
local thisPlayer = game.Players.LocalPlayer
if not thisPlayer.Character then thisPlayer.CharacterAdded:wait() end
local thisCharacter = thisPlayer.Character

-- Services --
local UIS = game:GetService("UserInputService")

-- Get and Set Mouse Icon --
local thisMouse = thisPlayer:GetMouse()
thisMouse.Icon = "rbxasset://SystemCursors/Arrow" -- Default Menu to the arrow when game starts/restarts

-- Camera --
local thisCamera = game.Workspace:WaitForChild("Camera")

-- Connections --
local playButtonConnection = nil
local canShowCrosshair = false

-- GUI Vars --
local playerGUI = script.Parent
local crossHair1st = playerGUI.Crosshair1st
local crossHair3rd = playerGUI.Crosshair3rd
local camDistance = 0
local isTouchScreen = false

--------------------
-- Initialization --
--------------------

-- Check if this PLayer has a touch enabled device --
if UIS.TouchEnabled then
	
	-- If we are on a touhc screen then add crosshair to the middle of the screen,  --
	isTouchScreen = true
	
else
	
	-- No Crosshair Image --
	isTouchScreen = false
end

----------------
-- Init Stuff --
----------------

-- Set Mouse Icon to Crossshaire
thisMouse.Icon = "http://www.roblox.com/asset/?id=9524023207"

--------------------------------------------
-- Main Loop for Mobile Crosshair Support --
--------------------------------------------

-- Let character Load
task.wait(3)

-- Loop
while true do
	
	-- If its a touchscreen.. --
	if isTouchScreen then

		-- Check distance between players camera and head to determine first person --
		camDistance = (thisCharacter.Head.CFrame.Position - thisCamera.CFrame.Position).Magnitude

		-- If less than 2, we're in 1st person --
		if camDistance < 2 then

			-- Make 1st person crosshair visible --
			crossHair1st.Visible = true
			crossHair3rd.Visible = false

		else

			-- Make 3st person crosshair visible --
			crossHair1st.Visible = false
			crossHair3rd.Visible = true
		end		
	end

	-- Wait
	task.wait(1)
end


