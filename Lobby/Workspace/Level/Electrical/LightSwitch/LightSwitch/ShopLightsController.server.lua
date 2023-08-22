-- Wait
task.wait(3)

-- LightSwitch
local lightSwitchProxPrompt = script.Parent.Base.ProximityPrompt

-- state Vars
local lightsOn = true

-- Lights
local light1Tube1 = workspace.Level.ShopLights.ShopLight1.Light1.Tube
local light1Tube2 = workspace.Level.ShopLights.ShopLight1.Light2.Tube
local light2Tube1 = workspace.Level.ShopLights.ShopLight2.Light1.Tube
local light2Tube2 = workspace.Level.ShopLights.ShopLight2.Light2.Tube
local light3Tube1 = workspace.Level.ShopLights.ShopLight3.Light1.Tube
local light3Tube2 = workspace.Level.ShopLights.ShopLight3.Light2.Tube
local light4Tube1 = workspace.Level.ShopLights.ShopLight4.Light1.Tube
local light4Tube2 = workspace.Level.ShopLights.ShopLight4.Light2.Tube

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
	light1Tube1.Color = Color3.fromRGB(255,255,255)
	light1Tube2.Color = Color3.fromRGB(255,255,255)
	light2Tube1.Color = Color3.fromRGB(255,255,255)
	light2Tube2.Color = Color3.fromRGB(255,255,255)
	light3Tube1.Color = Color3.fromRGB(255,255,255)
	light3Tube2.Color = Color3.fromRGB(255,255,255)
	light4Tube1.Color = Color3.fromRGB(255,255,255)
	light4Tube2.Color = Color3.fromRGB(255,255,255)

	-- Turn off Surface Lights
	light1Tube1.SurfaceLight.Enabled = true
	light1Tube2.SurfaceLight.Enabled = true
	light2Tube1.SurfaceLight.Enabled = true
	light2Tube2.SurfaceLight.Enabled = true
	light3Tube1.SurfaceLight.Enabled = true
	light3Tube2.SurfaceLight.Enabled = true
	light4Tube1.SurfaceLight.Enabled = true
	light4Tube2.SurfaceLight.Enabled = true
	
	
end

-- Lights Off
local function TurnLightsOff()
	
	-- Play Sound
	lightSwitchSound:Play()
	
	-- Turn of Tubes..
	light1Tube1.Color = Color3.fromRGB(66,66,66)
	light1Tube2.Color = Color3.fromRGB(66,66,66)
	light2Tube1.Color = Color3.fromRGB(66,66,66)
	light2Tube2.Color = Color3.fromRGB(66,66,66)
	light3Tube1.Color = Color3.fromRGB(66,66,66)
	light3Tube2.Color = Color3.fromRGB(66,66,66)
	light4Tube1.Color = Color3.fromRGB(66,66,66)
	light4Tube2.Color = Color3.fromRGB(66,66,66)
	
	-- Turn off Surface Lights
	light1Tube1.SurfaceLight.Enabled = false
	light1Tube2.SurfaceLight.Enabled = false
	light2Tube1.SurfaceLight.Enabled = false
	light2Tube2.SurfaceLight.Enabled = false
	light3Tube1.SurfaceLight.Enabled = false
	light3Tube2.SurfaceLight.Enabled = false
	light4Tube1.SurfaceLight.Enabled = false
	light4Tube2.SurfaceLight.Enabled = false	
	
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
