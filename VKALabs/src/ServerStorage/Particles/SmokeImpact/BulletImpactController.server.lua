-- Services --
local Debris = game:GetService("Debris")

-- vars --
local emitter = script.Parent:WaitForChild("Impact")

-- Enable Emitter --
emitter.Enabled = true

task.wait(3)

-- disable Emitter
emitter.Enabled = false

-- Destroy this..
Debris:AddItem(script.Parent, 3)

