-- Do not run script until it is placed onto a proper door --
while script.Parent.Name ~= "FireAlarm" do
	task.wait()
end

-- Objects
local thisModel = script.Parent
local thisLight = script.Parent.LightCover.SurfaceLight

-- Sounds
local alarmSound = thisModel.LightCover.Alarm

-- State Vars
local eventDone = false

-- BrightNess
local brightnessValue = 0 --  Must Start as 0 if Lights Start at 0
local lightMax = false

-- Event time
local EVENT_LENGTH = 10

---------------
-- Functions --
---------------

local function RunEvent()
	
	-- Reset Event Done
	eventDone = false
	
	-- Start a coroutine timer
	local timerCoroutine = coroutine.wrap(function()

		-- Timer
		task.wait(EVENT_LENGTH)

		-- Stop Sound
		alarmSound:Stop()

		-- Light
		lightMax = false
		brightnessValue = 0
		thisLight.Brightness = 0

		-- Event is done
		eventDone = true
		
	end)()
	
	-----------------
	-- Sound Alarm --
	-----------------

	alarmSound:Play()

	-- Continuously Flash the Lights
	while eventDone == false do

		-------------------
		-- Strobe Lights --
		-------------------		
		if lightMax then

			-- Lower Red Value
			brightnessValue -= .1

			-- Apply Eye Color
			thisLight.Brightness = brightnessValue	

			-- If it gets to 0, then its off
			if brightnessValue <= 0 then

				-- Signal is now off
				lightMax = false

				-- Set RedValue
				brightnessValue = 0
			end		

		else

			-- Lower Red Value
			brightnessValue += .1

			-- Apply Eye Color
			thisLight.Brightness = brightnessValue

			-- If it gets to 0, then its off
			if brightnessValue >= 3.3 then

				-- Signal is now off
				lightMax = true

				-- Reset redvalue
				brightnessValue = 3.3
			end		
		end		

		-- Wait
		task.wait()
	end
end

-----------------
-- Connections --
-----------------

-- Listen for Contaiment Breach Start
game.ServerStorage.ServerEvents.ContainmentBreachStarted.Event:Connect(function()
	
	-- Create A Random Wait SO alarms dont go off all at the same time..	
	local seed = Random.new(tick())
	task.wait(seed:NextNumber(0.1, 0.3))
	
	-- Run the Event
	RunEvent()
	
	-- Nil Stuff
	seed = nil
end)

-- Listen for Setting the Bomb
game.ReplicatedStorage.MissionEvents.BombSetSTS.Event:Connect(function()
	
	-- Make EVENt Way longer
	EVENT_LENGTH = 30
	
	-- Create A Random Wait SO alarms dont go off all at the same time..	
	local seed = Random.new(tick())
	task.wait(seed:NextNumber(0.1, 0.3))

	-- Run the Event
	RunEvent()

	-- Nil Stuff
	seed = nil
end)