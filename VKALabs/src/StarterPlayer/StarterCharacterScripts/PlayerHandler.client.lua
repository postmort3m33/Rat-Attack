-- Wait for game loaded..
while task.wait() do

	-- Break when game is loaded..
	if game:IsLoaded() then

		-- Leave
		break
	end
end

-- Load Character --
local thisPlayer = game.Players.LocalPlayer
if not thisPlayer.Character then thisPlayer.CharacterAdded:wait() end
local thisCharacter = thisPlayer.Character
local thisHumanoid = thisCharacter:WaitForChild("Humanoid")

-- Health Changed Variables --
local oldHealth = thisHumanoid.MaxHealth

-- Damage Sound Variables --
local damageSoundInterval = 0.33
local lastDamageSound = time()

-- Sounds --
local damageSound = thisCharacter:WaitForChild("DamageSound")
local skullPickupSound = thisCharacter:WaitForChild("SkullPickup")
local ratFleshImpactSound = thisCharacter:WaitForChild("BulletFleshImpact")
local sipDrinkSound = thisCharacter:WaitForChild("SipDrink")
local mmmCheese = thisCharacter:WaitForChild("MmmCheese")
local dingSound = thisCharacter:WaitForChild("Ding")
local outsideRainSound = thisCharacter:WaitForChild("OutsideRain")
local insideRainSound = thisCharacter:WaitForChild("InsideRain")

local doorLock = thisCharacter:WaitForChild("DoorLock")
local roundGuitar = thisCharacter:WaitForChild("RoundGuitar")
local ceramicHandle = thisCharacter:WaitForChild("CeramicHandle")
local niceSound = thisCharacter:WaitForChild("Nice")
local sweetSound = thisCharacter:WaitForChild("Sweet")
local gunPickupSoundsArray = {niceSound, sweetSound}
local checkTraps1Sound = thisCharacter:WaitForChild("CheckTraps1")
local checkTraps2Sound = thisCharacter:WaitForChild("CheckTraps2")
local checkTraps3Sound = thisCharacter:WaitForChild("CheckTraps3")
local checkTrapsSoundArray = {checkTraps1Sound, checkTraps2Sound, checkTraps3Sound}
local thunderSoundsFolder = thisCharacter:WaitForChild("Thunder")
local thunderClose1Sound = thunderSoundsFolder:WaitForChild("ThunderCloseLoud1")
local thunderClose2Sound = thunderSoundsFolder:WaitForChild("ThunderCloseLoud2")
local thunderDistant1Sound = thunderSoundsFolder:WaitForChild("ThunderDistant1")
local thunderDistant2Sound = thunderSoundsFolder:WaitForChild("ThunderDistant2")
local thunderDistantQuietSound = thunderSoundsFolder:WaitForChild("ThunderDistantQuiet")
local biteSoundsFolder = thisCharacter:WaitForChild("BiteSounds")
local bite1 = biteSoundsFolder:WaitForChild("Bite1")
local bite2 = biteSoundsFolder:WaitForChild("Bite2")
local bite3 = biteSoundsFolder:WaitForChild("Bite3")
local bite4 = biteSoundsFolder:WaitForChild("Bite4")
local biteSoundArray = {bite1, bite2, bite3, bite4}
local frontGateDrumsSound = thisCharacter:WaitForChild("FrontGateDrums")

-- Thunder Volume
local thunderVolumeOutside = 0.4
local thunderVolumeInside = thunderVolumeOutside / 2

-- Sound Table
local soundTable = {
	{"BloodExchange", ceramicHandle}
}

-- Connection Vars --
local playButtonConnection = nil

-- state Vars
local isInside = true

----------
-- Init --
----------

-- Start By Playing Inside Rain Sound..
insideRainSound:Play()

---------------
-- Functions --
---------------

-- Functions --
local function FadeOutSound(sound)

	-- Get Original Volume
	local ogVolume = sound.Volume

	-- Loop
	for x = ogVolume , 0, -0.1 do
		sound.Volume = x
		wait(0.05)
	end

	-- Stop It
	sound:Stop()

	-- Reset the Volume
	sound.Volume = ogVolume
end

-- Functions --
local function FadeInSound(sound)

	-- Get Original Volume
	local ogVolume = sound.Volume

	-- Play It
	sound:Play()

	-- Loop
	for x = 0 , ogVolume, 0.1 do
		sound.Volume = x
		wait(0.05)
	end

	-- Reset the Volume
	sound.Volume = ogVolume
end

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

-----------------------
-- Sound Connections --
-----------------------

-- Listen for Gun Pickup Sound
game.ReplicatedStorage.GunPickupSound.OnClientEvent:Connect(function()
	
	-- Random Number
	local random = math.random(1, #gunPickupSoundsArray)
	
	-- Play it
	gunPickupSoundsArray[random]:Play()
	
	-- Nil Stuff
	random = nil
end)

-- Play a Local Sound
game.ReplicatedStorage.PlayLocalSound.OnClientEvent:Connect(function(soundString)
	
	-- Loop through Sound Table
	for _, v in pairs(soundTable) do
		
		-- If the string matches.. PLay sound
		if soundString == v[1] then
			
			-- Play
			v[2]:Play()
		end
	end
end)

-- When Server Skull Tells Client to Play Skull Pickup Sound --
game.ReplicatedStorage.SkullPickupSound.OnClientEvent:Connect(function()
	
	-- Play Sound Locally
	skullPickupSound:Play()
	
end)

-- Player Shoots a Rat, Hear flesh sound only locally --
game.ReplicatedStorage.RatFleshImpactSound.OnClientEvent:Connect(function()

	-- Play Sound Locally
	ratFleshImpactSound:Play()

end)

-- Player Shoots a Rat, Hear flesh sound only locally --
game.ReplicatedStorage.SipDrinkSound.OnClientEvent:Connect(function()

	-- Play Sound Locally
	sipDrinkSound:Play()

end)

-- Player Shoots a Rat, Hear flesh sound only locally --
game.ReplicatedStorage.MmmCheeseSound.OnClientEvent:Connect(function()

	-- Play Sound Locally
	mmmCheese:Play()

end)

-- Easter Egg Ding Sound --
game.ReplicatedStorage.DingSound.OnClientEvent:Connect(function()
	
	-- Play sound Locall -
	dingSound:Play()
end)

-- Play Outdoor Rain Sound
game.ReplicatedStorage.PlayOutdoorAmbienceSound.OnClientEvent:Connect(function()
	
	-- Is outside
	isInside = false
end)

-- Play Indoor Rain Sound
game.ReplicatedStorage.PlayDungeonAmbienceSound.OnClientEvent:Connect(function()
	
	-- Is
	isInside = true
	
end)

-- Door Unlcok Game Start Sound
game.ReplicatedStorage.DoorUnlockSound.OnClientEvent:Connect(function()

	-- Play sound Locall -
	doorLock:Play()
end)

-- Check Traps Sound
game.ReplicatedStorage.CheckTrapsSound.OnClientEvent:Connect(function()
	
	-- Play Random One
	checkTrapsSoundArray[math.random(1, #checkTrapsSoundArray)]:Play()
end)

-- Thunder Sound..
game.ReplicatedStorage.PlayThunderSoundSTC.OnClientEvent:Connect(function(soundString)
	
	-- check sound..
	if soundString == "Close1" then
		
		-- Make sure we are outside..
		if outsideRainSound.IsPlaying then
			
			-- Play It
			thunderClose1Sound:Play()
		else
			
			-- turn Volume Down
			thunderDistant1Sound.Volume = thunderVolumeInside
			
			-- Play an Inside one..
			thunderDistant1Sound:Play()
		end		
		
	elseif soundString == "Close2" then
		
		-- Make sure we are outside..
		if outsideRainSound.IsPlaying then
			
			-- Play It
			thunderClose2Sound:Play()
			
		else
			
			-- turn Volume Down
			thunderDistant2Sound.Volume = thunderVolumeInside
			
			-- Play an Inside one..
			thunderDistant2Sound:Play()
		end		
		
	elseif soundString == "Distant1" then
		
		-- Make sure we are outside..
		if outsideRainSound.IsPlaying then
			
			-- Set Volume..
			thunderDistant1Sound.Volume = thunderVolumeOutside
			
			-- Play It
			thunderDistant1Sound:Play()
			
		else
			
			-- Play Quit One
			thunderDistantQuietSound:Play()
		end		

	elseif soundString == "Distant2" then
		
		-- Make sure we are outside..
		if outsideRainSound.IsPlaying then
			
			-- Set Volume..
			thunderDistant2Sound.Volume = thunderVolumeOutside

			-- Play It
			thunderDistant2Sound:Play()

		else

			-- Play Quit One
			thunderDistantQuietSound:Play()
		end

	elseif soundString == "DistantQuiet" then

		-- Play It
		thunderDistantQuietSound:Play()

	end	
end)

-- Play Front Gate Drums
game.ReplicatedStorage.FrontGateEventStartedSTC.OnClientEvent:Connect(function()
	
	-- PLay it
	if not frontGateDrumsSound.IsPlaying then frontGateDrumsSound:Play() end
	
end)

-- End Front Gate Drums
game.ReplicatedStorage.FrontGateEventEndedSTC.OnClientEvent:Connect(function()

	-- PLay it
	if frontGateDrumsSound.IsPlaying then frontGateDrumsSound:Stop() end

end)


-----------------------
-- Other Connections --
-----------------------

-- Connection to Shake the Camera
game.ReplicatedStorage.CameraShake.OnClientEvent:Connect(function(timeToShake)
	
	-- Ref Start Time
	local startTime = time()
	
	-- Loop
	while time() < startTime + timeToShake do
		
		-- Vars
		local xOffset = math.random(-100,100) / 333
		local yOffset = math.random(-100,100) / 333
		local zOffset = math.random(-100,100) / 333
		
		-- Shake Camera..
		thisHumanoid.CameraOffset = Vector3.new(xOffset, yOffset, zOffset)
		
		-- wait
		task.wait()
	end
	
	-- Reset Camera..
	thisHumanoid.CameraOffset = Vector3.new(0,0,0)	
	
end)

---------------
-- Main Loop --
---------------

while task.wait() do	

	-- If
	if isInside then

		-- Play Inside Rain If its not Playing..
		if not insideRainSound.IsPlaying then

			-- Play It
			FadeInSound(insideRainSound)
		end

		-- Stop Playing outside Sound
		if outsideRainSound.IsPlaying then

			-- Fade Out
			FadeOutSound(outsideRainSound)
		end		
	else

		-- Play Outside Rain
		if not outsideRainSound.IsPlaying then

			-- Play It
			FadeInSound(outsideRainSound)		
		end

		-- Stop Inside Rain
		if insideRainSound.IsPlaying then

			-- Fade Out
			FadeOutSound(insideRainSound)
		end		
	end
end


