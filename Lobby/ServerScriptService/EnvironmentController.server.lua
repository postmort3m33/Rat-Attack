-- Vars
local RAIN_ON = false

-- Rain Stuff
local rainEmitter = workspace.Level.RainFX.Rain.ParticleEmitter
local rainSmokeEmitter = workspace.Level.RainFX.Smoke.ParticleEmitter
local lastRainToggle = time()
local RAIN_TOGGLE_MIN = 30 -- Default: 30
local RAIN_TOGGLE_MAX = 1800 -- Default: 1800 (15 Minutes)
local rainToggleInterval = math.random(RAIN_TOGGLE_MIN, RAIN_TOGGLE_MAX) -- Default: 30 seconds, 1800 seconds(15 minutes)

-- Thunder Stuff
local soundStringTable = {"Close1", "Close2", "Distant1", "Distant2", "DistantQuiet"}
local lastThunderStrike = time()
local thunderStrikeInterval = 10

-- Indoor/OutDoor Region Change..
local pmpcShopRegionTrigger = workspace.Level.AmbienceTriggers.AmbienceTriggerShop1
local pmpcTriggerXPos = pmpcShopRegionTrigger.Position.X
local stateParkShopRegionTrigger = workspace.Level.AmbienceTriggers.AmbienceTriggerShop2
local stateParkTriggerZPos = stateParkShopRegionTrigger.Position.Z

-----------------
-- Connections --
-----------------

-- pmpc Shop Trigger
pmpcShopRegionTrigger.TouchEnded:Connect(function(entity)
	
	-- If this Part is touched by a player, check if they are in the outdoor area..
	if game.Players:GetPlayerFromCharacter(entity.Parent) then

		-- Get PLayer
		local thisPlayer = game.Players:GetPlayerFromCharacter(entity.Parent)

		-- If a HumanoidRootPart has passed through
		if entity == entity.Parent.PrimaryPart then

			-- Get HRP Pos
			local hrpPos = entity.Parent.PrimaryPart.Position.X

			-- See which side the HRP is on NOw..
			if hrpPos > pmpcTriggerXPos then

				-- Play Outside Ambience
				game.ReplicatedStorage.PlayOutdoorRainSTC:FireClient(thisPlayer)
			else

				-- Play Dungeon Ambience
				game.ReplicatedStorage.PlayIndoorRainSTC:FireClient(thisPlayer)
			end

			-- Nil Stuff
			hrpPos = nil
		end	

		-- Nil Stuff
		thisPlayer = nil

	end
end)

-- statePark Ambience Trigger
stateParkShopRegionTrigger.TouchEnded:Connect(function(entity)
	
	-- If this Part is touched by a player, check if they are in the outdoor area..
	if game.Players:GetPlayerFromCharacter(entity.Parent) then

		-- Get PLayer
		local thisPlayer = game.Players:GetPlayerFromCharacter(entity.Parent)

		-- If a HumanoidRootPart has passed through
		if entity == entity.Parent.PrimaryPart then

			-- Get HRP Pos
			local hrpPos = entity.Parent.PrimaryPart.Position.Z

			-- See which side the HRP is on NOw..
			if hrpPos < stateParkTriggerZPos then

				-- Play Outside Ambience
				game.ReplicatedStorage.PlayOutdoorRainSTC:FireClient(thisPlayer)
			else

				-- Play Dungeon Ambience
				game.ReplicatedStorage.PlayIndoorRainSTC:FireClient(thisPlayer)
			end

			-- Nil Stuff
			hrpPos = nil
		end	

		-- Nil Stuff
		thisPlayer = nil

	end	
end)

---------------
-- Functions --
---------------

-- Rain On/OFF --
local function ToggleRain()
	
	-- If rain was on..
	if RAIN_ON then
		
		-- Turn it off
		RAIN_ON = false
		
		-- Rain Off
		rainEmitter.Enabled = false
		rainSmokeEmitter.Enabled = false	
		
		-- Tell Client
		game.ReplicatedStorage.ToggleRainSTC:FireAllClients("off")
		
	else -- Turn it on
		
		-- Rain On
		RAIN_ON = true
		
		-- Turn on..
		rainEmitter.Enabled = true
		rainSmokeEmitter.Enabled = true
		
		-- Tell Client
		game.ReplicatedStorage.ToggleRainSTC:FireAllClients("on")
		
		-- Reset Thunder Interval
		lastThunderStrike = time()
		
		-- Random Interval
		thunderStrikeInterval = math.random(10, 60)
		
	end
end

----------
-- Init --
----------

-- Rain
if RAIN_ON then
	
	-- Turn on..
	rainEmitter.Enabled = true
	rainSmokeEmitter.Enabled = true	
	
else
	
	-- Rain Off
	rainEmitter.Enabled = false
	rainSmokeEmitter.Enabled = false	
	
end

---------------
-- Main Loop --
---------------

-- Main Loop
while task.wait() do
	
	-- Randsomly Toggle Rain
	if (time() - lastRainToggle) > rainToggleInterval then
		
		-- Reset Last rain
		lastRainToggle = time()
		
		-- Set new RainToggle interval
		rainToggleInterval = math.random(RAIN_TOGGLE_MIN, RAIN_TOGGLE_MAX)
		
		-- Toggle It
		ToggleRain()
		
	end
	
	------------------
	-- When Raining --
	------------------
	
	-- If raining
	if RAIN_ON then		
		
		-- Play random thunderstrikes..
		if (time() - lastThunderStrike) > thunderStrikeInterval then

			-- Set last strike
			lastThunderStrike = time()

			-- reset interval
			thunderStrikeInterval = math.random(10, 60)

			-- Random sound clip
			local random = math.random(1, #soundStringTable)

			-- Send To GUI
			game.ReplicatedStorage.PlayThunderSoundSTC:FireAllClients(soundStringTable[random])

			-- Nil
			random = nil		

		end		
	end
end
