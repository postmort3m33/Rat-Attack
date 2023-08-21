-- Wait a sec
task.wait(2)

-- Objects to attach --
local newVanTeleportScript = script:WaitForChild("NewVanTeleportScript")

-- Place Controllers for VKA Labs
for i, v in pairs(game.Workspace:GetDescendants()) do

	-- Check if name is a door, then attach script..
	if v.Name == "NewSwatVanSolo" then

		-- Attach Script
		local scriptClone = newVanTeleportScript:Clone()
		scriptClone.MinPlayers.Value = 1
		scriptClone.Parent = v
		scriptClone.Enabled = true
		
	elseif v.Name == "NewSwatVanDuo" then
		
		-- Attach Script
		local scriptClone = newVanTeleportScript:Clone()
		scriptClone.MinPlayers.Value = 2
		scriptClone.Parent = v
		scriptClone.Enabled = true	
		
	elseif v.Name == "NewSwatVanTrio" then

		-- Attach Script
		local scriptClone = newVanTeleportScript:Clone()
		scriptClone.MinPlayers.Value = 3
		scriptClone.Parent = v
		scriptClone.Enabled = true		

	elseif v.Name == "NewSwatVanQuad" then

		-- Attach Script
		local scriptClone = newVanTeleportScript:Clone()
		scriptClone.MinPlayers.Value = 4
		scriptClone.Parent = v
		scriptClone.Enabled = true		

	end
end
