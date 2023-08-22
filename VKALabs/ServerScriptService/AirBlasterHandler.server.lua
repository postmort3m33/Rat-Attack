-- Services --
local DebrisService = game:GetService("Debris")

-----------------
-- Connections --
-----------------

-- Collider Maker
game.ReplicatedStorage.CreateAirBlasterCollider.OnServerEvent:Connect(function(player, tool, LocalLightOrigin, localLightLookVector)

	-- Play Sound..
	tool.Handle.Fire:Play()
	
	------------------------
	-- Run Smoke Emitters --
	------------------------
	
	-- Ref Emitter
	local emitter = tool.Light.SmokeImpact.Impact
	local emitterRing = tool.Light.SmokeRing.Impact
	
	-- Enable Emitter --
	emitter.Enabled = true
	emitterRing.Enabled = true

	-- Cleqar, Then Emit 10 particels --
	emitter:Clear()
	emitterRing:Clear()
	emitter:Emit(333)
	emitterRing:Emit(333)

	-- disable Emitter
	emitter.Enabled = false
	emitterRing.Enabled = false
	
	--------------------
	-- Shoot Collider --
	--------------------

	-- Create New Crossbow
	local airCollider = game.ServerStorage.UsedAirBlaster:Clone()
	
	-- Parent
	airCollider.Parent = workspace

	-- Set Position
	airCollider.CFrame = CFrame.lookAt(LocalLightOrigin, LocalLightOrigin + localLightLookVector)
	
	-- Set Player Name
	airCollider.PlayerName.Value = player.Name
	
	-- Spawn Position
	airCollider.SpawnPosition.Value = LocalLightOrigin

	-- Apply Impulse
	airCollider:ApplyImpulse(localLightLookVector * 150 * airCollider.AssemblyMass)
	
	-- Debirs
	DebrisService:AddItem(airCollider, 1)
	
end)
