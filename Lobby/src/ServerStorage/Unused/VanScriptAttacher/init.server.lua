-- Wait a sec
task.wait(2)

-- Objects to attach --
local vanTeleportScriptSolo = script:WaitForChild("VanTeleportScriptSolo")
local vanTeleportScriptMulti = script:WaitForChild("VanTeleportScriptMulti")

-- Place New Door Controllers --
for i, v in pairs(game.Workspace:GetDescendants()) do

	-- Check if name is a door, then attach script..
	if v.Name == "SwatVanSolo" then

		-- Attach Script
		local scriptClone = vanTeleportScriptSolo:Clone()
		scriptClone.Parent = v
		scriptClone.Enabled = true
		
	elseif v.Name == "SwatVanDuo" then
		
		-- Attach Script
		local scriptClone = vanTeleportScriptMulti:Clone()
		scriptClone.MinPlayers.Value = 2
		scriptClone.Parent = v
		scriptClone.Enabled = true	
		
	elseif v.Name == "SwatVanTrio" then

		-- Attach Script
		local scriptClone = vanTeleportScriptMulti:Clone()
		scriptClone.MinPlayers.Value = 3
		scriptClone.Parent = v
		scriptClone.Enabled = true		

	elseif v.Name == "SwatVanQuad" then

		-- Attach Script
		local scriptClone = vanTeleportScriptMulti:Clone()
		scriptClone.MinPlayers.Value = 4
		scriptClone.Parent = v
		scriptClone.Enabled = true		

	end
end
