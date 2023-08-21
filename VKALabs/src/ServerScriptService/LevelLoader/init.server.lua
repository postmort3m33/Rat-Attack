-- Objects to attach --
local doorControllerNewScript = script:WaitForChild("DoorControllerNew")
local fireAlarmScript = script:WaitForChild("FireAlarmScript")

-- Let Level Load In
task.wait(2)

-- Place New Door Controllers --
for i, v in pairs(game.Workspace:GetDescendants()) do

	-- Check if name is a door, then attach script..
	if v.Name == "DoorObjectNew" then

		-- Attach Script
		local scriptClone = doorControllerNewScript:Clone()
		scriptClone.Parent = v
		scriptClone.Enabled = true
		scriptClone = nil		
	end
end

-- Place FireAlarm Controllers --
for i, v in pairs(game.Workspace:GetDescendants()) do

	-- Check if name is a door, then attach script..
	if v.Name == "FireAlarm" then

		-- Attach Script
		local scriptClone = fireAlarmScript:Clone()
		scriptClone.Parent = v
		scriptClone.Enabled = true
		scriptClone = nil		
	end
end


