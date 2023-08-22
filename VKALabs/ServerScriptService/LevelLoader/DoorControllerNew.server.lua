-- Do not run script until it is placed onto a proper door --
while script.Parent.Name ~= "DoorObjectNew" do
	task.wait()
end

-- Local Variables --
local Door = script.Parent -- This Door
local proxRightSide = Door.Handles.HandleRightSide.ProxRightSide
local proxLeftSide = Door.Handles.HandleLeftSide.ProxLeftSide

-- Local Bools -- 
local DoorOpen = false -- Door Open or Closed Status
local DoorActive = false -- Wether Door is Actively Opening or Closing

-- State Vars
local doorOpenRightSide = false
local doorOpenLeftSide = false

-- Sounds --
local doorOpenSound = Door.Door.Open
local doorCloseSound = Door.Door.Close


---------------
-- Functions --
---------------

-- Local Functions --
local function ActivateDoor(sideString)
	
	-- If Door is Closed and Not Active and Is Not locked --
	if sideString == "RightSide" and DoorOpen == false and DoorActive == false then
		
		-- Stop Multiple Function Calling --
		DoorActive = true
		
		-- Door Open WorkShop Side
		doorOpenRightSide = false
		doorOpenLeftSide = true
		
		-- Play Door Opoen Sound
		doorOpenSound:Play()

		-- Open Door --
		local TweenInformation = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
		local TweenDetails = {
			["CFrame"] = Door.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(105), 0)
		}

		local Tween = game.TweenService:Create(Door.PrimaryPart, TweenInformation, TweenDetails)
		Tween:Play()
		Tween.Completed:Wait()	
		
		-- Set Door Open to True and no longer active --	
		DoorOpen = true
		DoorActive = false
		
		-- Nil Stuff
		TweenInformation = nil
		TweenDetails = nil
		Tween = nil
		
		-- Leave Function --
		return
			
	end	
	
	-- If Door is Closed and Not Active and Is Not locked --
	if sideString == "LeftSide" and DoorOpen == false and DoorActive == false then

		-- Stop Multiple Function Calling --
		DoorActive = true

		-- Door Open WorkShop Side
		doorOpenRightSide = true
		doorOpenLeftSide = false

		-- Play Door Opoen Sound
		doorOpenSound:Play()

		-- Open Door --
		local TweenInformation = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
		local TweenDetails = {
			["CFrame"] = Door.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(-90), 0)
		}

		local Tween = game.TweenService:Create(Door.PrimaryPart, TweenInformation, TweenDetails)
		Tween:Play()
		Tween.Completed:Wait()	

		-- Set Door Open to True and no longer active --	
		DoorOpen = true
		DoorActive = false

		-- Nil Stuff
		TweenInformation = nil
		TweenDetails = nil
		Tween = nil

		-- Leave Function --
		return

	end
	
	-- If Door is Open and not active, close it --
	if DoorOpen and DoorActive == false then
		
		-- Stop glitching --
		DoorActive = true
		
		-- Door Close Sound --
		doorCloseSound:Play()

		-- Local Ref
		local angleToRotate = 0
		
		-- Check which side its open to..
		if doorOpenRightSide then
			
			-- Set It
			angleToRotate = math.rad(90)
		else
			
			-- Set It
			angleToRotate = math.rad(-105)
		end		
		
		-- Now Tween Bitch
		local TweenInformation = TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
		local TweenDetails = {
			["CFrame"] = Door.PrimaryPart.CFrame * CFrame.Angles(0, angleToRotate, 0)
		}

		local Tween = game.TweenService:Create(Door.PrimaryPart, TweenInformation, TweenDetails)
		Tween:Play()
		Tween.Completed:Wait()	
		
		-- Set Door Closed to True and not active--	
		DoorOpen = false
		DoorActive = false
		
		-- States
		doorOpenRightSide = false
		doorOpenLeftSide = false
		
		-- Nil Stuff
		TweenInformation = nil
		TweenDetails = nil
		Tween = nil
		angleToRotate = nil
		
		-- Leave Function --
		return
	end		
end

-----------------
-- Connections --
-----------------

-- Office Side Triggered
proxRightSide.Triggered:Connect(function()
	
	-- Activate Door Office Side
	ActivateDoor("RightSide")
end)

-- Workshop Side Triggered
proxLeftSide.Triggered:Connect(function()
	
	-- Activate Door Workshop Side
	ActivateDoor("LeftSide")
end)
