-- Prox
local thisProx = script.Parent:WaitForChild("ProximityPrompt")

-- Objects
local thisPhone = script.Parent
local thisHighlight = script.Parent.Highlight

-- State
local playerMinDistance = 30 -- Used to be 25

-- Playe rRange Emitter
local playerRangePart = script.Parent.PlayerRange
local playerRangeEmitter = playerRangePart.ParticleEmitter
playerRangePart.Size = Vector3.new(0.125, playerMinDistance * 2, playerMinDistance * 2)

-- Init..
thisProx.Enabled = false
playerRangeEmitter.Enabled = false

-- Sounds
local phoneCallSound = script.Parent.PhoneCall
local phoneHangUpSound = script.Parent.HangUp


----------
-- Init --
----------

-- Keep Phone highlight off
thisHighlight.Enabled = false

-----------------
-- Connections --
-----------------

-- Look for Prox to be ready..
game.ReplicatedStorage.MissionEvents.PhoneCallReadyToServer.Event:Connect(function()
	
	-- Enable Prox
	thisProx.Enabled = true
	
	-- turn on highlight
	thisHighlight.Enabled = true
	
end)

-- Prox Connection
thisProx.Triggered:Connect(function()
	
	-- Get PLayer Liost
	local playerList = game.Players:GetPlayers()
	local playerDistance = 0
	
	-- Check if all players are nearby..
	for _, player in pairs(playerList) do

		-- Get distance
		playerDistance = (player.Character.PrimaryPart.CFrame.Position - thisPhone.CFrame.Position).Magnitude

		-- If a player is too far leave..
		if playerDistance > playerMinDistance then
			
			-- Send GUI Message
			game.ReplicatedStorage.SendPlayerHUDMessage:FireAllClients("All players must be in the Office!")
			
			-- Nil Stuff
			playerList = nil
			playerDistance = nil
			
			-- leave..
			return
		end	

		-- Wait
		task.wait()			
	end	
	
	-- turn off prox Prompt..
	thisProx.Enabled = false
	
	-- Wait
	task.wait(1)
	
	-- Turn on Range EMitter
	playerRangeEmitter.Enabled = true
	
	-- Phone Call has started..
	game.ReplicatedStorage.MissionEvents.PhoneCallStartedToServer:Fire()
	
	-- Play Phone Call Sound..
	phoneCallSound:Play()
	
	-- state
	local phoneCallActive = true
	local phoneCallEndedConnection = nil
	
	-- Start Loop..
	while phoneCallActive do
		
		-- Make Sure Players stay in distance..
		for _, player in pairs(playerList) do
			
			-- Get distance
			playerDistance = (player.Character.PrimaryPart.CFrame.Position - thisPhone.CFrame.Position).Magnitude
			
			-- If a player gets too far.. Hand Up Phone Call..
			if playerDistance > playerMinDistance then
				
				-- Stop Phone Call Sound
				phoneCallSound:Stop()
				
				-- hang Up
				phoneHangUpSound:Play()
				
				-- Send GUI Message
				game.ReplicatedStorage.SendPlayerHUDMessage:FireAllClients("All players must be in the Office!")
				
				-- Change to Red
				playerRangeEmitter.Color = ColorSequence.new(Color3.fromRGB(255,0,0))
				
				-- Wait for a sec
				task.wait(1)
				
				-- Turn off Emitter
				playerRangeEmitter.Enabled = false
				
				-- Change Back to Blue
				playerRangeEmitter.Color = ColorSequence.new(Color3.fromRGB(0,174,255))
				
				-- Re-enable Prox
				thisProx.Enabled = true
				
				-- Disconnect End Connection
				if phoneCallEndedConnection then
					
					-- Dis
					phoneCallEndedConnection:Disconnect()
					phoneCallEndedConnection = nil
				end
				
				-- Hang Up
				return
			end			
		end
		
		-- Make Connection
		if not phoneCallEndedConnection then
			
			-- Make connection
			phoneCallEndedConnection = phoneCallSound.Ended:Connect(function()
				
				-- Wait..
				task.wait(1)
				
				-- Phone call No Longer Cative..
				phoneCallActive = false
				
				-- Disconnect
				phoneCallEndedConnection:Disconnect()
				phoneCallEndedConnection = nil
				
			end)
		end
		
		-- Wait
		task.wait(1)
	end
	
	------------------------
	-- Phone call is over --
	------------------------
	
	-- turn off Range EMitter
	playerRangeEmitter.Enabled = false
	
	-- Turn off highlight..
	thisHighlight.Enabled = false
	
	-- Call Events (Tells Front Gate Script to start)
	game.ReplicatedStorage.MissionEvents.PhoneCallOverServerToServer:Fire()
	
	-- Complete Event
	game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(12)	
	
end)
