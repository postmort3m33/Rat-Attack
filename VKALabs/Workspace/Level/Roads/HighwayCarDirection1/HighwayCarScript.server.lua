-- Let Server Boot --
task.wait(5)

-- State Vars
local GAME_STARTED = false

-- This entity --
local thisCar = script.Parent

-- Start Position --
local startPos = thisCar.Position
local part1StartPos = thisCar.Part1.Position
local part2StartPos = thisCar.Part2.Position

-- Other vars --
local tweening = false

-----------------
-- Connections --
-----------------

-- Dont Run until game Starts..
game.ServerStorage.ServerEvents.StartGame.Event:Connect(function()

	-- Game has started..
	GAME_STARTED = true	

end)

----------
-- Init --
----------

-- Wait until game has started..
while GAME_STARTED == false do task.wait() end

-----------------------------
-- Main heartbeat Loop --
-----------------------------
while task.wait() do	

	-------------------------------------
	-- Tween constantly across the sky --
	-------------------------------------	

	-- If not tweening --
	if not tweening then

		-- Tweening
		tweening = true

		-- Move from Start to End Waypoint --
		local TweenInformation = TweenInfo.new(math.random(9, 13), Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
		local TweenDetails = {
			["CFrame"] = thisCar.CFrame * CFrame.new(0, 0, -1000)
		}

		local Tween = game.TweenService:Create(thisCar, TweenInformation, TweenDetails)
		Tween:Play()
		Tween.Completed:Wait()
		
		-- Wait a Random Amount of Time..
		task.wait(math.random(10,30))

		-- Move Satellite BAck to beginning --
		thisCar.Position = startPos
		thisCar.Part1.Position = part1StartPos
		thisCar.Part2.Position = part2StartPos

		-- Done Tweening -- 
		tweening = false

		-- Nil Stuff
		TweenInformation = nil
		TweenDetails = nil
		Tween = nil
	end
end



