-- Wait for game loaded..
while task.wait() do

	-- Break when game is loaded..
	if game:IsLoaded() then

		-- Leave
		break
	end
end

----------
-- Vars --
----------

-- Load Character --
local thisPlayer = game.Players.LocalPlayer
if not thisPlayer.Character then thisPlayer.CharacterAdded:Wait() end
local thisCharacter = thisPlayer.Character
local thisHumanoid = thisCharacter:WaitForChild("Humanoid")

-- State Vars
local isTouchScreen = false
local pingFunctionRunning = false
local isHoldingButton = false

-- Ping Stuff
local PING_RAYCAST_RANGE = 5000

---------------
-- Functions --
---------------

-- Set Ping
local function SetPing()
	
	-- Raycast Origin
	local origin = nil

	-- Empty Direction Var
	local direction = Vector3.new(0,0,0)
	
	-- Viewport Center Points --
	local viewportPoint = workspace.CurrentCamera.ViewportSize / 2

	-- Create Ray from Viewport Center.. --
	local unitRay = workspace.CurrentCamera:ViewportPointToRay(viewportPoint.X, viewportPoint.Y, 0)	

	-- Origina is Ray origin --
	origin = unitRay.Origin

	-- Direction is Ray direction with 5000 length --
	direction = unitRay.Direction * PING_RAYCAST_RANGE	
	
	-- Create new Raycast Handle --
	local newRay = RaycastParams.new()

	-- Dont let raycast hit the player shooting it --
	newRay.FilterDescendantsInstances = {thisPlayer.Character, workspace.CurrentCamera}

	-- FilterType
	--newRay.FilterType = Enum.RaycastFilterType.Blacklist
	
	-- Collision
	newRay.CollisionGroup = "WeaponRaycasts"

	-- Cast the Ray --
	local result = workspace:Raycast(origin, direction, newRay)	

	-- IF we hit anything
	if result then

		-- Tell Server to Fire the ShootGun Event.. 
		game.ReplicatedStorage.PingCTS:FireServer(true, result.Position)

	else -- We Hit nothing

		-- Tell Server to Fire the ShootGun Event.. 
		game.ReplicatedStorage.PingCTS:FireServer(false, Vector3.new(0,0,0))			

	end
	
	-- Nil Stuff
	viewportPoint = nil
	unitRay = nil
	origin = nil
	direction = nil
	newRay = nil
	result = nil
	
end

-- Tell Server to Remove this Ping
local function RemovePing()
	
	-- Run Event to remove this players Ping
	game.ReplicatedStorage.RemovePingCTS:FireServer(thisPlayer)
	
end

-- PingButtonPressed
local function PingButtonPressed(actionName, inputState, inputObj)
	
	-- If dead..
	if thisHumanoid.Health <= 0 then return end

	-- Make sure we only fire function once on Input Begin.. --
	if inputState == Enum.UserInputState.Begin then
		
		-- Is holding Button
		isHoldingButton = true
		
		-- Run coroutine to see if player holds button
		local holdingCoroutine = coroutine.wrap(function()
			
			-- Vars
			local timerActual = 0
			
			-- Wait a second..
			while isHoldingButton do
				
				-- Add to timerActual
				timerActual += 0.02
				
				-- If we reach the holding target.. Run function
				if timerActual > 1 then
					
					-- Remove Ping
					RemovePing()
					
					-- Break this loop
					break
					
				end
				
				-- Wait
				task.wait()
			end			
		end)()

		-- If Activate Tool is not running, then Run it.. --
		if not pingFunctionRunning then

			-- Now it is running --
			pingFunctionRunning = true
			
			-- Set Ping
			SetPing()

			-- NOw it is not running --
			pingFunctionRunning = false
			
		end
		
	elseif inputState == Enum.UserInputState.End or inputState == Enum.UserInputState.Cancel then -- Button Released

		-- Not holding ANymore
		isHoldingButton = false

	end	
end

--------------------------------
-- Setup ContextAction Button --
--------------------------------

-- Screen Variables --
local screenSizeX = game.Workspace.CurrentCamera.ViewportSize.X
local screenSizeY = game.Workspace.CurrentCamera.ViewportSize.Y
local aspectRatio = screenSizeX/screenSizeY

-- Mobile button Stuff
local pingButtonPosX = (screenSizeX * 0.1) + (screenSizeX * 0.02)
local pingButtonPosY = (screenSizeY * -0.02) + (screenSizeY * -0.14)
local pingButtonSizeX = 0.066 * screenSizeX
local pingButtonSizeY = (0.066 * aspectRatio) * screenSizeY

-- Setup
local pingButton = game:GetService("ContextActionService"):BindAction("PingButton", PingButtonPressed, true, Enum.KeyCode.F, Enum.KeyCode.ButtonR3)
game:GetService("ContextActionService"):SetImage("PingButton", "rbxassetid://13198171960")

-- Now Adjust button if we are on a Touchscreen --
if game:GetService("UserInputService").TouchEnabled then

	-- This is touchscreen
	isTouchScreen = true

	-- Resize Reload Button --
	local reloadButtonGUI = game:GetService("ContextActionService"):GetButton("PingButton")
	reloadButtonGUI.Size = UDim2.new(0,pingButtonSizeX,0,pingButtonSizeY)
	reloadButtonGUI.Position = UDim2.new(0,pingButtonPosX,0,pingButtonPosY)

end
