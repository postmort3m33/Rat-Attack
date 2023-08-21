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

-- Sound Vars
local celloAmbienceSound = thisCharacter:WaitForChild("CelloAmbience")

-- Other Vars..
local playerPosY = nil
local isDownStairs = true
local currentTimePosition = 0

---------------
-- Functions --
---------------

-- Functions --
local function FadeOutSound(sound)

	-- Get Original Volume
	local ogVolume = sound.Volume

	-- Loop
	for x = ogVolume , 0, -0.001 do
		sound.Volume = x
		wait(0.1)
	end
	
	-- Set Time Position
	currentTimePosition = sound.TimePosition

	-- Stop It
	sound:Stop()

	-- Reset the Volume
	sound.Volume = ogVolume

end

-- Functions --
local function FadeInSound(sound, timePosition)

	-- Get Original Volume
	local ogVolume = sound.Volume
	
	-- Set Volume to 0
	sound.Volume = 0
	
	-- Set time position
	sound.TimePosition = timePosition

	-- Play It
	sound:Play()

	-- Loop
	for x = 0 , ogVolume, 0.001 do
		sound.Volume = x
		wait(0.1)
	end

	-- Reset the Volume
	sound.Volume = ogVolume
end


---------------
-- Main Loop --
---------------

while task.wait(1) do
	
	-- Get Player Position..
	playerPosY = thisCharacter.PrimaryPart.CFrame.Position.Y
	
	-- Iff
	if playerPosY < 22 then
		
		-- is Down
		isDownStairs = true
		
		-- If Not Playing.. Play it
		if not celloAmbienceSound.IsPlaying then
			
			-- Fade it in
			FadeInSound(celloAmbienceSound, currentTimePosition)
		end		
		
	else
		
		-- Not
		isDownStairs = false
		
		-- If its playing.. Stop it
		if celloAmbienceSound.IsPlaying then
			
			-- Fade it out..
			FadeOutSound(celloAmbienceSound)
			
		end		
	end
end
