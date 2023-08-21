-- Let it preload..
task.wait(5)

---------------
-- Sound Ids --
---------------

-- Static Loop
local staticLoopID = script.Parent.Static

-- News
local newsIntroID = script.Parent.NewsIntro

-- Chuck
local chuckSignOnID = script.Parent.ChuckSignOn
local chuckFinalSignOffID = script.Parent.ChuckFinalSignOff
local chuckThanksBillID = script.Parent.ChuckThanksBill
local chuckSignOffToBillID = script.Parent.ChuckSignOffToBill
local chuckInOtherNewsID = script.Parent.ChuckInOtherNews

-- Chuck Stories
local chuckToysRUID = script.Parent.ChuckToysRU
local chuckTruckCrashID = script.Parent.ChuckTruckCrash
local chuckStairSlideID = script.Parent.ChuckStairSlide
local chuckStoriesSoundIDArray = {chuckToysRUID, chuckTruckCrashID, chuckStairSlideID}

-- Bill
local billThanksChuckID = script.Parent.BillThanksChuck
local billlBackToYouChuckID = script.Parent.BillBackToYouChuck
local billWeatherReportID = script.Parent.BillWeatherReport

-- Commercials
local vitaminsID = script.Parent.Vitamins
local oatmealID = script.Parent.Oatmeal
local shinyTruckID = script.Parent.ShinyTruck
local clintsAutoID = script.Parent.ClintsAuto
local commercialSoundIDArray = {vitaminsID, oatmealID, clintsAutoID, shinyTruckID}

-- Other Sounds
local windShieldWipersSound = script.Parent.WindShieldWipers

-- State Vars
local CUTSCENE_OVER = false
local PLAY_LOBBY_RADIO = true -- Default: True

-- State Stuff
-- 1: Static
-- 2: News
-- 3: Commercials
local stateChanger = 1 -- start with static
local state2Complete = false
local state3Complete = false
-----------------
-- Connections --
-----------------

-- Listen for Cutscene Over
game.ReplicatedStorage.CutSceneEvents.CutSceneOverSTS.Event:Connect(function()

	-- Cutscene is Over...
	CUTSCENE_OVER = true

end)

----------
-- Init --
----------

-- Loop Windshield Wipers
if windShieldWipersSound.IsLoaded then windShieldWipersSound:Play() end

---------------------
-- Main While Loop --
---------------------

while CUTSCENE_OVER == false and PLAY_LOBBY_RADIO do
	
	-- Which State are we in
	if stateChanger == 1 then
		
		-- Reset state Changer
		stateChanger = 0
		
		-- Set Current Sound
		if staticLoopID.IsLoaded then staticLoopID:Play() end
		
		-- Ony wait if its the beginning..
		if not (state3Complete and state2Complete) then
			
			task.wait(math.random(7,20))
			
			-- If still playing, turn off..
			if staticLoopID.IsPlaying then

				-- Stop it
				staticLoopID:Stop()
			end
			
			-- Pick commercial or radio..
			stateChanger = math.random(2,3)
			
		end		
		
	elseif stateChanger == 2 then
		
		-- Reset state Changer
		stateChanger = 0
		
		-- Start News Stuff
		if newsIntroID.IsLoaded then newsIntroID:Play() end
		
		-- Wait until finished playing..
		while newsIntroID.IsPlaying do task.wait() end
		
		-- Chuck Sign On..
		if chuckSignOnID.IsLoaded then chuckSignOnID:Play() end
		
		-- Let it finish
		while chuckSignOnID.IsPlaying do task.wait() end
		
		--------------------------
		-- Chuck Random Stories --
		--------------------------
		
		-- Vars
		local newIndex = 1
		local nextStory = nil
		
		-- for loop for all commercials.
		for i = 1, #chuckStoriesSoundIDArray, 1 do

			-- Find a commercial index
			newIndex = math.random(1, #chuckStoriesSoundIDArray)

			-- Set Sound
			nextStory = chuckStoriesSoundIDArray[newIndex]

			-- Now Play it
			if nextStory.IsLoaded then nextStory:Play() end

			-- Subtract from Array
			table.remove(chuckStoriesSoundIDArray, newIndex)		

			-- Wait for it
			while nextStory.IsPlaying do task.wait() end

			-- Wait between commercials
			task.wait(1)

		end
		
		-- chuck sign off to bill..
		if chuckSignOffToBillID.IsLoaded then chuckSignOffToBillID:Play() end
		
		-- Wait for it
		while chuckSignOffToBillID.IsPlaying do task.wait() end
		
		-- Wait a little longer
		task.wait(1.5)
		
		-- Bill sign on
		if billThanksChuckID.IsLoaded then billThanksChuckID:Play() end
		
		-- Wait for it
		while billThanksChuckID.IsPlaying do task.wait() end
		
		-- Wait
		task.wait(1)
		
		-- Weather Reporty
		if billWeatherReportID.IsLoaded then billWeatherReportID:Play() end
		
		-- Wait for it
		while billWeatherReportID.IsPlaying do task.wait() end
		
		-- Bill back to chuck
		if billlBackToYouChuckID.IsLoaded then billlBackToYouChuckID:Play() end
		
		-- Wait for it
		while billlBackToYouChuckID.IsPlaying do task.wait() end
		
		-- Wait
		task.wait(1.5)
		
		-- Chuck thanks bill
		if chuckThanksBillID.IsLoaded then chuckThanksBillID:Play() end
		
		-- Wait for it
		while chuckThanksBillID.IsPlaying do task.wait() end
		
		-- chuck sign off
		if chuckFinalSignOffID.IsLoaded then chuckFinalSignOffID:Play() end
		
		-- Wait for it
		while chuckFinalSignOffID.IsPlaying do task.wait() end
		
		-- Now state 2 played.
		state2Complete = true
		
		-- Which state next
		if state3Complete == false then
			
			-- state 3
			stateChanger = 3
		else
			
			-- 1
			stateChanger = 1
		end
		
		
	elseif stateChanger == 3 then
		
		-- Reset state Changer
		stateChanger = 0
		
		-- if allCommercials played, leave
		if state3Complete then
			
			-- If not state 2
			if not state2Complete then
				
				-- Change
				stateChanger = 2
			else
				
				-- back to static
				stateChanger = 1
			end
		end
		
		-- Vars
		local newIndex = 1
		local nextCommercial = nil
		local numToPlay = 0
		
		-- Set num to Play
		if state2Complete then
			
			-- Play all commercials
			numToPlay = #commercialSoundIDArray			
			
		else
			
			-- Play random amount.;.
			numToPlay = math.random(1, #commercialSoundIDArray)
			
		end
		
		-------------------------
		-- Random Comercials.. --
		-------------------------
		
		-- for loop for all commercials.
		for i = 1, numToPlay, 1 do
			
			-- Find a commercial index
			newIndex = math.random(1, #commercialSoundIDArray)

			-- Set Sound
			nextCommercial = commercialSoundIDArray[newIndex]

			-- Now Play it
			if nextCommercial.IsLoaded then nextCommercial:Play() end

			-- Subtract from Array
			table.remove(commercialSoundIDArray, newIndex)		

			-- Wait for it
			while nextCommercial.IsPlaying do task.wait() end
			
			-- Wait between commercials
			task.wait(2)
			
		end
		
		-- Nil Stuff
		newIndex = nil
		nextCommercial = nil
		
		-- State 3 played
		if #commercialSoundIDArray == 0 then
			
			-- All were Played
			state3Complete = true
		end		

		-- Other States
		if not state2Complete then

			-- Play state 2
			stateChanger = 2
			
		elseif state3Complete == false then		

			-- back to commercials
			stateChanger = 3
		else
			
			-- Back to statuc
			stateChanger = 1
		end		
	end
	
	-- Wait
	task.wait()
	
end
