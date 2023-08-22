-- Services --
local Debris = game:GetService("Debris")

-- vars --
local emitter = script.Parent:WaitForChild("Impact")

-- Enable Emitter --
emitter.Enabled = true

-- Cleqar, Then Emit 10 particels --
emitter:Clear()
emitter:Emit(5)

-- disable Emitter
emitter.Enabled = false

-- Destroy this..
Debris:AddItem(script.Parent, 1)

