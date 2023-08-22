-- Wait
task.wait(3)

-- LightSwitch
local lightSwitchProxPrompt = script.Parent.Base.ProximityPrompt

-- state Vars
local lightsOn = true

-- Lights
local light1Part = workspace.Level.OfficeCeiling.CeilingLight1.LightPart
local light2Part = workspace.Level.OfficeCeiling.CeilingLight2.LightPart

-- Sound
local lightSwitchSound = script.Parent.Base.LightSwitch

---------------
-- Functions --
---------------

-- Lights On
local function TurnLightsOn()
	
	-- Play Sound
	lightSwitchSound:Play()
	
	-- Turn of Tubes..
	light1Part.Color = Color3.fromRGB(166,166,166)
	light2Part.Color = Color3.fromRGB(166,166,166)

	-- Turn off Surface Lights
	light1Part.SurfaceLight.Enabled = true
	light2Part.SurfaceLight.Enabled = true
	
end

-- Lights Off
local function TurnLightsOff()
	
	-- Play Sound
	lightSwitchSound:Play()
	
	-- Turn of Tubes..
	light1Part.Color = Color3.fromRGB(66,66,66)
	light2Part.Color = Color3.fromRGB(66,66,66)

	-- Turn off Surface Lights
	light1Part.SurfaceLight.Enabled = false
	light2Part.SurfaceLight.Enabled = false
	
end

-----------------
-- Connections --
-----------------

-- Prox Prompt
lightSwitchProxPrompt.Triggered:Connect(function()
	
	-- Check
	if lightsOn then
		
		-- turn them off
		TurnLightsOff()
		
		-- Now theyre off
		lightsOn = false
		
	else
		
		-- Turn them on
		TurnLightsOn()
		
		-- noe theyre on
		lightsOn = true
		
	end	
end)
