-- Let Server Boot --
task.wait(5)

-- Services --
local RunService = game:GetService("RunService")

-- This entity --
local thisShip = script.Parent

-- Tween Stuff
local mainTween = nil
local currentTweenDegree = 220
local tweenRadius = 300
local timeForOneDegree = (math.floor((((math.pi * tweenRadius) / 5) / 360) * 100)) / 100
local tweenOriginPos = Vector3.new(-433, 400, -1000)

-- Connections --
local heartbeatConnection = nil

-- Other vars --
local tweening = false

-----------------------------
-- Main heartbeat Loop --
-----------------------------
heartbeatConnection = RunService.Heartbeat:Connect(function()	
	
	---------------------------------------
	-- Tween in an orbit above the level --
	---------------------------------------	
	
	-- If not tweening --
	if not tweening then
		
		-- Tweening
		tweening = true
		
		-- Move to the next degree
		currentTweenDegree += 1
		
		-- Circular degree
		if currentTweenDegree == 361 then currentTweenDegree = 1 end
		
		-- Calculate new Position
		local X = tweenRadius * math.cos(math.rad(currentTweenDegree))
		local Y = tweenRadius * math.sin(math.rad(currentTweenDegree))
		
		-- New Pos
		local newPosition = Vector3.new(X, 0, Y) + tweenOriginPos
		
		-- Move from Start to End Waypoint --
		local TweenInformation = TweenInfo.new(timeForOneDegree, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
		local TweenDetails = {
			["CFrame"] = CFrame.lookAt(newPosition, tweenOriginPos)
		}

		mainTween = game.TweenService:Create(thisShip.PrimaryPart, TweenInformation, TweenDetails)
		mainTween:Play()
		mainTween.Completed:Wait()
		
		-- Done Tweening -- 
		tweening = false
		
		-- Nil Stuff
		TweenInformation = nil
		TweenDetails = nil
	end
end)

