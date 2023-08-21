-- Wait
task.wait(3)

-- Prox
local proxPrompt = script.Parent.Body.ProximityPrompt

-- Parts
local screenPart = script.Parent.Screen

-- Sounds --
local astroLoverSound = script.Parent.Body:WaitForChild("AstroLover")
local songInitVolume = astroLoverSound.Volume

-- On/Off Vars --
local radioOn = false

-- turn Radio off to Start
astroLoverSound.Volume = 0

-- Always Be Looping the Song
astroLoverSound:Play()

----------------
-- Connection --
----------------

-- Prox Prompt --
proxPrompt.Triggered:Connect(function()
	
	-- if radio is off turn it on
	if radioOn == false then
		
		-- Radio on
		radioOn = true
		
		-- Turn on Screen
		screenPart.Color = Color3.fromRGB(255,255,255)
		
		-- Turn on
		astroLoverSound.Volume = songInitVolume		
		
	else
		
		-- off
		radioOn = false
		
		-- Turn off Screen
		screenPart.Color = Color3.fromRGB(0,0,0)
		
		-- Turn off
		astroLoverSound.Volume = 0		
		
	end
	
end)

