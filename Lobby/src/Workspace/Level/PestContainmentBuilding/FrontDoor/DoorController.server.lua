-- Local Variables --
local Door = script.Parent -- This Door
local officeSideProx = Door.Handles.OfficeSideHandle.OfficeSideProx
local outdoorSideProx = Door.Handles.OutdoorSideHandle.OutdoorSideProx

-- Local Bools -- 
local DoorOpen = false -- Door Open or Closed Status
local DoorActive = false -- Wether Door is Actively Opening or Closing
local DoorLocked = true -- Default: true

-- State Vars
local doorOpenOfficeSide = false
local doorOpenWorkshopSide = false

-- Sounds --
local doorOpenSound = Door.Door.Open
local doorCloseSound = Door.Door.Close
local doorLockedSound = Door.Door.DoorLocked

-- Special IDS
local myID = 4272115183
local chaseID = 3878809968
local myID2 = 3859611936

-- Shop Teleport Positions
local insideShopPosPart = script.Parent.InsideShopPosition
local outsideShopPosition = script.Parent.OutsideShopPosition

---------------
-- Functions --
---------------

-- Local Functions --
local function ActivateDoor(sideString)
	
	-- If Door is Locked.. Play A Sound and leave
	if DoorLocked then

		-- Play Sound
		doorLockedSound:Play()

		-- leave
		return
	end
	
	-- If Door is Closed and Not Active and Is Not locked --
	if sideString == "OutdoorSide" and DoorOpen == false and DoorActive == false then
		
		-- Stop Multiple Function Calling --
		DoorActive = true
		
		-- Door Open WorkShop Side
		doorOpenWorkshopSide = true
		doorOpenOfficeSide = false
		
		-- Play Door Opoen Sound
		doorOpenSound:Play()

		-- Open Door --
		local TweenInformation = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
		local TweenDetails = {
			["CFrame"] = Door.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(90), 0)
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
	if sideString == "OfficeSide" and DoorOpen == false and DoorActive == false then

		-- Stop Multiple Function Calling --
		DoorActive = true

		-- Door Open WorkShop Side
		doorOpenWorkshopSide = false
		doorOpenOfficeSide = true

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
		if doorOpenWorkshopSide then
			
			-- Set It
			angleToRotate = math.rad(-90)
		else
			
			-- Set It
			angleToRotate = math.rad(90)
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
		doorOpenWorkshopSide = false
		doorOpenOfficeSide = false
		
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
outdoorSideProx.Triggered:Connect(function(player)
	
	-- check ofr Special IDS
	if player.UserId == myID or player.UserId == chaseID or player.UserId == myID2 then
		
		-- Teleport to other Side...
		player.Character.PrimaryPart.CFrame = insideShopPosPart.CFrame
		
		-- Leave function
		return
		
	end
	
	-- Activate Door Office Side
	ActivateDoor("OutdoorSide")
end)

-- Workshop Side Triggered
officeSideProx.Triggered:Connect(function(player)
	
	-- check ofr Special IDS
	if player.UserId == myID or player.UserId == chaseID or player.UserId == myID2 then

		-- Teleport to other Side...
		player.Character.PrimaryPart.CFrame = outsideShopPosition.CFrame

		-- Leave function
		return

	end
	
	-- Activate Door Workshop Side
	ActivateDoor("OfficeSide")
end)
