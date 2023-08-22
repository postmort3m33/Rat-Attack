-- Player vars
local thisPlayer = game.Players.LocalPlayer
if not thisPlayer.Character then thisPlayer.CharacterAdded:Wait() end
local thisCharacter = thisPlayer.Character
local thisHumanoid = thisCharacter:WaitForChild("Humanoid")

-- State Vars --
local oldHealth = thisHumanoid.MaxHealth

-- Sounds --
local insideRainSound = script:WaitForChild("InsideRain")
local insideRainOGVolume = insideRainSound.Volume
local outsideRain = script:WaitForChild("OutsideRain")
local outsideRainOGVolume = outsideRain.Volume
local celloAmbience = script:WaitForChild("CelloAmbience")
local outsideCrickets = script:WaitForChild("OutsideCrickets")
local lobbyMusic = script:WaitForChild("LobbyMusic")

-- Thunder sounds
local thunderClose1Sound = script:WaitForChild("ThunderCloseLoud1")
local thunderClose2Sound = script:WaitForChild("ThunderCloseLoud2")
local thunderDistant1Sound = script:WaitForChild("ThunderDistant1")
local thunderDistant2Sound = script:WaitForChild("ThunderDistant2")
local thunderDistantQuietSound = script:WaitForChild("ThunderDistantQuiet")
local biteSoundsFolder = thisCharacter:WaitForChild("BiteSounds")
local bite1 = biteSoundsFolder:WaitForChild("Bite1")
local bite2 = biteSoundsFolder:WaitForChild("Bite2")
local bite3 = biteSoundsFolder:WaitForChild("Bite3")
local bite4 = biteSoundsFolder:WaitForChild("Bite4")
local biteSoundArray = {bite1, bite2, bite3, bite4}

-- Damage Sound Stuff
local damageSoundInterval = 0.33
local lastDamageSound = time()
local damageSound = thisCharacter:WaitForChild("DamageSound")

-- state vars
local isInside = false
local isRaining = false

---------------
-- Functions --
---------------

-- Fade Out
local function FadeOutSound(sound)
	
	-- Get Original Volume
	local ogVolume = sound.Volume
	
	-- Loop
	for x = ogVolume , 0, -0.01 do
		sound.Volume = x
		task.wait()
	end
	
	-- Stop It
	sound:Stop()
	
	-- Reset the Volume
	sound.Volume = ogVolume
end

-- Fade In
local function FadeInSound(sound)

	-- Get Original Volume
	local ogVolume = sound.Volume
	
	-- Play It
	sound:Play()

	-- Loop
	for x = 0 , ogVolume, 0.01 do
		sound.Volume = x
		task.wait()
	end

	-- Reset the Volume
	sound.Volume = ogVolume
end

-----------------
-- Connections --
-----------------

-- If Players Health Has changed.. --
thisHumanoid.HealthChanged:Connect(function(health)

	-- If health went down... --
	if oldHealth > health then		

		-- Control Sound PLay Overlap
		if (time() - lastDamageSound) > damageSoundInterval then

			-- Update Last Damage Sound --
			lastDamageSound = time()

			-- Clone the Sound and PLay it on removal --
			if not damageSound.IsPlaying then damageSound:Play() end

			----------------
			-- Bite sound --
			----------------

			-- The Sound
			local biteSound = biteSoundArray[math.random(1, #biteSoundArray)]

			-- Edit volume..
			biteSound.Volume = math.random(27,40) * 0.01 -- (0.25 - 0.5)

			-- Random Pitch
			biteSound.PlaybackSpeed = math.random(80, 120) * 0.01

			-- Play Rat Bite Sound too
			biteSound:Play()

			-- Nil
			biteSound = nil

		end		
	end

	-- Update Old Health
	oldHealth = health	
end)

-- Thunder Connection
game.ReplicatedStorage.PlayThunderSoundSTC.OnClientEvent:Connect(function(soundString)
	
	-- check sound..
	if soundString == "Close1" then

		-- Play It
		thunderClose1Sound:Play()

	elseif soundString == "Close2" then

		-- Play It
		thunderClose2Sound:Play()

	elseif soundString == "Distant1" then

		-- Play It
		thunderDistant1Sound:Play()

	elseif soundString == "Distant2" then

		-- Play It
		thunderDistant2Sound:Play()

	elseif soundString == "DistantQuiet" then

		-- Play It
		thunderDistantQuietSound:Play()

	end	
end)

-- Play Indoor Sound..
game.ReplicatedStorage.PlayIndoorRainSTC.OnClientEvent:Connect(function()
	
	-- set it
	isInside = true
	
end)

-- Play Outdoor
game.ReplicatedStorage.PlayOutdoorRainSTC.OnClientEvent:Connect(function()
	
	-- Is Not
	isInside = false
	
end)

-- Toggle Rain
game.ReplicatedStorage.ToggleRainSTC.OnClientEvent:Connect(function(stateString)
	
	-- If on..
	if stateString == "on" then
		
		-- Set rain state
		isRaining = true
		
	else
		
		-- Not raining
		isRaining = false
		
	end
end)

----------
-- Init --
----------

-- See if its raining when joining..
if workspace.Level.RainFX.Rain.ParticleEmitter.Enabled == true then
	
	-- Is raining
	isRaining = true
else
	
	-- Not raining
	isRaining = false
end

-- Always play outside Crickets
outsideCrickets:Play()
--celloAmbience:Play()
lobbyMusic:Play()

---------------
-- Main Loop --
---------------

while task.wait() do
	
	-- If its raining..
	if isRaining then
		
		-- If
		if isInside then

			-- Play Inside Rain If its not Playing..
			if not insideRainSound.IsPlaying then

				-- Play It
				FadeInSound(insideRainSound)
			end

			-- Stop Playing outside Sound
			if outsideRain.IsPlaying then

				-- Fade Out
				FadeOutSound(outsideRain)
			end		
		else

			-- Play Outside Rain
			if not outsideRain.IsPlaying then

				-- Play It
				FadeInSound(outsideRain)			
			end

			-- Stop Inside Rain
			if insideRainSound.IsPlaying then

				-- Fade Out
				FadeOutSound(insideRainSound)
			end		
		end
		
		-- Turn oiff crickets
		if outsideCrickets.IsPlaying then FadeOutSound(outsideCrickets) end
		
	else
		
		-- If we are inside..
		if isInside then
			
			-- If crickets are playing turn them off..
			if outsideCrickets.IsPlaying then
				
				-- Fadout
				FadeOutSound(outsideCrickets)
				
			end
		else
			
			-- If outside play crickets..
			if not outsideCrickets.IsPlaying then
				
				-- Fade in
				FadeInSound(outsideCrickets)
			end
		end
		
		-- Make sure all rain sounds are off..
		if insideRainSound.IsPlaying then FadeOutSound(insideRainSound) end
		if outsideRain.IsPlaying then FadeOutSound(outsideRain) end
		
	end
end
