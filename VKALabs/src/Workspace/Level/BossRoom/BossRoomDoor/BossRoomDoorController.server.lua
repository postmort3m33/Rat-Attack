-- Local Variables --
local Door = script.Parent -- This Door
local doorProximityPrompt = Door.Door.Door:WaitForChild("ProximityPrompt") -- This Doors Prox Prompt
local disappearingFloor = Door:WaitForChild("DisappearingFloor")

-- Main Vars
local BOSS_TIMER = 30 -- Boss Fight Timer -- DONT CHANGE --

-- Timer Labels
local bossTimerTextLabel1 = script.Parent.TimerDisplay.Screen.SurfaceGuiBossTimer1:WaitForChild("BossTimerText")
local bossTimerTextLabel2 = script.Parent.TimerDisplay2.Screen.SurfaceGuiBossTimer2:WaitForChild("BossTimerText")

-- Timer Vars
local bossTimerValue = BOSS_TIMER -- Actual Counting Boss Timer --
local bossTimerRunning = false -- Is the Timer Counting Down? --
local bossTimerDone = false -- Boss Timer is Done Counting Down --
local bossTimerDoneRunning = false -- Boss Time Done Instructions Running --
local bossTimerReady = true -- Boss Fight is over, timer is ready again --

-- Boss Beat Vars
local bossWasBeat = false

-- Sounds --
local trapDoorSound = Door.DisappearingFloor:WaitForChild("TrapDoor")
local beepSound = Door.TimerDisplay.Screen:WaitForChild("Beep")

-- Vars --
local maxPlayersInBossRoom = false

---------------
-- Functions --
---------------

-- Local Functions --
local function ActivateDoor(player)
	
	-- If Active
	if player.Character then
		
		-- Move to Boss Room --
		player.Character:MoveTo(Vector3.new(48.25, 38.5, 23.5))

		-- Tell Server Player is in the Boss room --
		game.ReplicatedStorage.PlayerInBossRoom:Fire(player)		
		
	end
end

-----------------
-- Connections --
-----------------

-- Check for Max Players in Boss Room --
game.ReplicatedStorage.MaxPlayersInBossRoom.Event:Connect(function()
	
	-- Max Players
	maxPlayersInBossRoom = true
	
end)

-- Boss fight is Over -- Reset vars --
game.ReplicatedStorage.BossFightOver.Event:Connect(function(bossBeat)

	-- Reset Max Players
	maxPlayersInBossRoom = false
	
	-- Put Floor Back --
	disappearingFloor.Transparency = 0
	disappearingFloor.CanCollide = true
	
	-- Wait --
	task.wait(2)
	
	-- Boss timer is Ready again --
	bossTimerReady = true
	
	-- Boss was Beat.,
	bossWasBeat = bossBeat

end)

doorProximityPrompt.Triggered:Connect(function(player)
	
	-- Only Teleport players if bossroom isnt full.. --
	if maxPlayersInBossRoom == false and bossTimerReady == true then
		
		-- Run ActivateDoor Function --
		ActivateDoor(player)
	end	
end)	


---------------
-- Main Loop --
---------------

while bossWasBeat == false do
	
	--------------------
	-- Run Boss Timer --
	--------------------

	-- If we are ready for a new countdown --
	if bossTimerReady then
		
		--------------------------
		-- Countdown Timer Loop --
		--------------------------

		-- If the BossTimer is not running and is not finished counting down.. -
		if bossTimerRunning == false and bossTimerDone == false then

			-- Now Timer is running --
			bossTimerRunning = true

			-- Display Timer --
			bossTimerTextLabel1.Text = ":" .. bossTimerValue
			bossTimerTextLabel2.Text = ":" .. bossTimerValue
			
			-- PLay Countdown Beeps on last 3 Seconds.. --
			if bossTimerValue <= 3 and bossTimerValue ~= 0 then

				-- Play Beep Sound
				beepSound:Play()
			end
			
			-------------------------
			-- The One Second Wait --
			-------------------------
			
			task.wait(1)

			-- Update Timer Value -
			bossTimerValue -= 1

			-- Check for finished boss timer --
			if bossTimerValue < 0 then

				-- Timer Done --
				bossTimerDone = true
			end		

			-- Timer not running anymore --
			bossTimerRunning = false	

		end	

		----------------------------------------
		-- Once Boss timer is Up Drop Players --
		----------------------------------------

		if bossTimerDone and bossTimerDoneRunning == false then

			-- Boss Timer Done Debounce --
			bossTimerDoneRunning = true		

			-- Play TrapDoor Sound --
			trapDoorSound:Play()

			-- Make Dloor Dissapear --
			disappearingFloor.CanCollide = false
			disappearingFloor.Transparency = 1

			-- IMPORTANT WAIT AFTER TRAPDOOR --
			--task.wait(2)

			-- Start Boss Fight --
			game.ReplicatedStorage.BossFightStart:Fire()

			-- Reset Timer Display Value
			bossTimerValue = BOSS_TIMER			

			-- Ahh
			bossTimerDone = false

			-- Boss Timer is not ready anymore, and only becomes ready when boss fight is over --
			bossTimerReady = false
			
			-- Reset BossTimer --
			bossTimerDoneRunning = false
		end		
	end	
	
	-- Wait
	task.wait()
end

----------------------------------------
-- Boss Was Beat now keep Door Open.. --
----------------------------------------

-- Open Floor --
disappearingFloor.Transparency = 1
disappearingFloor.CanCollide = false

-- Reset Timer..
bossTimerTextLabel1.Text = ""
bossTimerTextLabel2.Text = ""
