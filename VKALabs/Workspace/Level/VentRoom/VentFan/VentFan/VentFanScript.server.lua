-- Objects
local thisFan = script.Parent
local thisFanCenter = thisFan.PrimaryPart

-- Sounds
local fanSound = thisFan.Parent.Holder.Bottom1.Fan

----------
-- Init --
----------

-- Fan Sound
fanSound:Play()

-- Main Loop --
while task.wait() do
	
	-- Rotate Fan..
	thisFanCenter.CFrame *= CFrame.Angles(math.rad(66), 0, 0)
	
end
