-- Services
local DebrisService = game:GetService("Debris")

-----------------
-- Connections --
-----------------

-- Flamethrower On
game.ReplicatedStorage.FlamethrowerOn.OnServerEvent:Connect(function(player, flamethrowerTool)
	
	
	-- This Player
	local thisPlayer = player
	
	-- Connection vARS
	local flamethrowerOffConnection = nil
	
	-- Connection for turning it off.
	flamethrowerOffConnection = game.ReplicatedStorage.FlamethrowerOff.OnServerEvent:Connect(function(playerOffEvent)
		
		-- If this is not the same player, leave..
		if playerOffEvent ~= thisPlayer then
			
			-- Leave
			return
		end
		
		----------------------------
		-- Flamethrower now off.. --
		----------------------------	
		
		-- Turn off Sound
		if flamethrowerTool.Parent ~= nil then
			
			-- Turn off
			flamethrowerTool.Handle.Fire:Stop()

			-- Turn Particles off..
			flamethrowerTool.Light.FireEmitter.Enabled = false
			flamethrowerTool.Light.PilotEmitter.Enabled = true
			
		end		
		
		-- Disconnect
		if flamethrowerOffConnection then
			
			-- Disconnect
			flamethrowerOffConnection:Disconnect()
			flamethrowerOffConnection = nil
			
		end		
	end)
	
	----------
	-- Init --
	----------
	
	-- Turn on Particle Emitter
	if flamethrowerTool.Parent ~= nil then
		
		
	end
	
	
	-- Playe Sound
	if flamethrowerTool.Parent ~= nil then
		
		-- Turn on PArticles..
		flamethrowerTool.Light.FireEmitter.Enabled = true
		flamethrowerTool.Light.PilotEmitter.Enabled = false
		
		-- Play Sound
		flamethrowerTool.Handle.Fire.TimePosition = 2
		flamethrowerTool.Handle.Fire:Play()
	end	
	
end)

-- Connection to create a collider from the flamethrower..
game.ReplicatedStorage.CreateFlamethrowerCollider.OnServerEvent:Connect(function(player, localLightOrigin, localLightLookVector)
	
	------------------------------------
	-- Shoot Flamethrower Colliders.. --
	------------------------------------
	
	-- Define Direction of this Shot..
	local shotDirection = localLightLookVector

	-- Create New Crossbow
	local flameCollider = game.ServerStorage.UsedFlamethrower:Clone()			

	-- Parent
	flameCollider.Parent = game.Workspace

	-- Set Player Name who shot It
	flameCollider.PlayerName.Value = tostring(player.Name)

	-- Set Position
	flameCollider.Position = localLightOrigin

	-- Apply Impulse
	flameCollider:ApplyImpulse(shotDirection * 100 * flameCollider.AssemblyMass)
	
	-- Debris
	DebrisService:AddItem(flameCollider, 0.66) -- Set this time to the Particle Emitter Lifetime..
	
end)
