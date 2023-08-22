-- Wait
task.wait(3)

-- Stuff
local thisProx = script.Parent:WaitForChild("Body"):WaitForChild("ProximityPrompt")

-- Set Min Players but wait for value to update..
while script.MinPlayers.Value == 0 do task.wait() end

-- Wait a sec
task.wait(1)

-- Set Min PLayers
local MIN_PLAYERS_TO_START = script.MinPlayers.Value

-- Ref
local serverCode = nil
local isTeleporting = false
local countdownActual = 5

-- Seat /Stuff
local playerList = {}
local filledSeatsArray = {}
local playerInSeatArray = {}
local seat1 = script.Parent.CabAndBed.Seat1
local seat2 = script.Parent.CabAndBed.Seat2
local seat3 = script.Parent.CabAndBed.Seat3
local seat4 = script.Parent.CabAndBed.Seat4
local seatArray = {seat1, seat2, seat3, seat4}
local playerEnteringExiting = false

-- Positions
local exitVehiclePart = script.Parent.ExitPositionPart

-- Play Count GUI Vars
local insidePlayerCountGUI = script.Parent.InsidePlayerCountGUI
local outsidePlayerCountGUI = script.Parent.OutsidePlayerCountGUI

-- Lights Stuff
local lightsOn = false
local whiteLightsPart = script.Parent.Lights.White
local amberLightsPart = script.Parent.Lights.Amber
local redLightsPart = script.Parent.Lights.Red
local defaultLightsPart = script.Parent.LightsOff
local headlightRightLight = whiteLightsPart.HeadLightRight.SurfaceLight
local headlightLeftLight = whiteLightsPart.HeadLightLeft.SurfaceLight

-- Sounds
local engineIdleSound = script.Parent.Body.EngineIdle

---------------
-- Functions --
---------------

-- Remove player from ready list..
local function RemoveReadyPlayer(playerToRemove)

	-- remove from seat..
	for _, array in pairs(playerInSeatArray) do

		-- Data
		local seat = array[1]
		local playerInSeat = array[2]

		-- Check
		if playerInSeat == playerToRemove then
			
			-- Stop From Sitting
			playerToRemove.Character.Humanoid.Sit = false
			
			-- Wait until seat is unoccupied..
			while #seat:GetChildren() > 0 do task.wait() end
			
			-- Wait a little longer..
			task.wait()

			-- break
			break
		end

		-- Nil Stuff
		seat = nil
		playerInSeat = nil
	end
	
	-- Teleport Player out of van..
	playerToRemove.Character.PrimaryPart.CFrame = exitVehiclePart.CFrame
	
	-- Re-enable Walk and Jump
	playerToRemove.Character.Humanoid.WalkSpeed = 16
	playerToRemove.Character.Humanoid.JumpPower = 50
	
end

-- Turn Lights On..
local function TurnOnLights()
	
	-- Play Engine Idle
	engineIdleSound:Play()
		
	-- Hide default Lights
	defaultLightsPart.Transparency = 1
	
	-- Show New Lights
	redLightsPart.Transparency = 0
	whiteLightsPart.Transparency = 0
	amberLightsPart.Transparency = 0
	
	-- Headlights
	headlightLeftLight.Enabled = true
	headlightRightLight.Enabled = true
	
end

-- Turn Lights On..
local function TurnOffLights()
	
	-- Play Engine Idle
	if engineIdleSound.IsPlaying then engineIdleSound:Stop() end
	
	-- Hide default Lights
	defaultLightsPart.Transparency = 0

	-- Show New Lights
	redLightsPart.Transparency = 1
	whiteLightsPart.Transparency = 1
	amberLightsPart.Transparency = 1

	-- Headlights
	headlightLeftLight.Enabled = false
	headlightRightLight.Enabled = false


end

-- Handling Failed Teleports..
local function HandleFailedTeleport(player, teleportResult)
	
	-- Remove them
	RemoveReadyPlayer(player)
	
	-- turn off Join Game GUI..
	game.ReplicatedStorage.PlayerTeleportingCanceled:FireClient(player)

end

----------
-- Init --
----------

-- Turn off Lights
TurnOffLights()

-- Lights are off
lightsOn = false

-- Make sure ALl seats are disabled mode..
for _, seat in pairs(seatArray) do
	
	-- Disable it
	seat.Disabled = true
end

-----------------
-- Connections --
-----------------

-- Prox prompty
thisProx.Triggered:Connect(function(player)
	
	-- If someone is entering or exiting, cancel..
	if playerEnteringExiting then return end
	
	-- Someone is entering or exiting..
	playerEnteringExiting = true
	
	-- Are we already in the van?
	for _, listPlayer in pairs(playerList) do
		
		-- same player?
		if player == listPlayer then
			
			-- Exit the vehicle..
			RemoveReadyPlayer(player)
			
			-- Someone is entering or exiting..
			playerEnteringExiting = false
			
			-- Exit functions
			return
			
		end
	end
	
	-- Dont Teleport Players if the Server is full..
	if #playerList < MIN_PLAYERS_TO_START then
		
		-- Wait until humanoid is accessible
		local thisHumanoid = player.Character:WaitForChild("Humanoid")

		------------------------------------------
		-- M0ve Player into an available seat.. --
		------------------------------------------

		-- Freeze Jump and Movement Power
		thisHumanoid.WalkSpeed = 0
		thisHumanoid.JumpPower = 0

		-- Place them into an empty seat in the van..
		if #filledSeatsArray > 0 then

			-- Loop through seat array..
			for _, seat in pairs(seatArray) do

				-- Check if its already filled..
				if table.find(filledSeatsArray, seat) then continue end

				-- Add to Array
				table.insert(filledSeatsArray, seat)

				-- Set player in seat
				table.insert(playerInSeatArray, {seat, player})

				-- Move Character to Proper Seat..
				seat:Sit(thisHumanoid)			

				-- Break
				break
			end

		else

			-- Seat filled
			table.insert(filledSeatsArray, seat1)

			-- Set player in seat
			table.insert(playerInSeatArray, {seat1, player})

			-- Make Player Sit
			seat1:Sit(thisHumanoid)

		end
		
		-- Add player to list
		table.insert(playerList, player)

		-- Nil Stuff
		thisHumanoid = nil		
		
	else
		
		-- Tell Player the Serve ris full
		game.ReplicatedStorage.SendPlayerHUDMessage:FireClient(player, "Vehicle is full!")
	end
	
	-- Someone is entering or exiting..
	playerEnteringExiting = false
	
end)

-- Seat Occupants Changes
seat1:GetPropertyChangedSignal("Occupant"):Connect(function()
	
	-- If we have no occupant, update..
	if not seat1.Occupant then

		-- Array to remove..
		local seatArrayToRemove = nil

		-- Remove from Array
		for _, array in pairs(playerInSeatArray) do

			-- Data
			local seat = array[1]
			local playerInSeat = array[2]

			-- Check
			if seat == seat1 then

				-- Empty it
				table.remove(filledSeatsArray, table.find(filledSeatsArray, seat))

				-- Remove this player..
				table.remove(playerList, table.find(playerList, playerInSeat))

				-- set to remove this array
				seatArrayToRemove = array

				-- break
				break
			end

			-- Nil Stuff
			seat = nil
		end

		-- Remove that array..
		table.remove(playerInSeatArray, table.find(playerInSeatArray, seatArrayToRemove))

	end	
end)

-- Seat Occupants Changes
seat2:GetPropertyChangedSignal("Occupant"):Connect(function()

	-- If we have no occupant, update..
	if not seat2.Occupant then
		
		-- Array to remove..
		local seatArrayToRemove = nil

		-- Remove from Array
		for _, array in pairs(playerInSeatArray) do			

			-- Data
			local seat = array[1]
			local playerInSeat = array[2]

			-- Check
			if seat == seat2 then

				-- Empty it
				table.remove(filledSeatsArray, table.find(filledSeatsArray, seat))

				-- Remove this player..
				table.remove(playerList, table.find(playerList, playerInSeat))

				-- set to remove this array
				seatArrayToRemove = array

				-- break
				break
			end

			-- Nil Stuff
			seat = nil
		end
		
		-- Remove that array..
		table.remove(playerInSeatArray, table.find(playerInSeatArray, seatArrayToRemove))
		
	end	
end)

-- Seat Occupants Changes
seat3:GetPropertyChangedSignal("Occupant"):Connect(function()

	-- If we have no occupant, update..
	if not seat3.Occupant then
		
		-- Array to remove..
		local seatArrayToRemove = nil

		-- Remove from Array
		for _, array in pairs(playerInSeatArray) do			

			-- Data
			local seat = array[1]
			local playerInSeat = array[2]

			-- Check
			if seat == seat3 then

				-- Empty it
				table.remove(filledSeatsArray, table.find(filledSeatsArray, seat))

				-- Remove this player..
				table.remove(playerList, table.find(playerList, playerInSeat))
				
				-- set to remove this array
				seatArrayToRemove = array

				-- break
				break
			end

			-- Nil Stuff
			seat = nil
		end
		
		-- Remove that array..
		table.remove(playerInSeatArray, table.find(playerInSeatArray, seatArrayToRemove))
		
	end	
end)

-- Seat Occupants Changes
seat4:GetPropertyChangedSignal("Occupant"):Connect(function()

	-- If we have no occupant, update..
	if not seat4.Occupant then
		
		-- Array to remove..
		local seatArrayToRemove = nil

		-- Remove from Array
		for _, array in pairs(playerInSeatArray) do			

			-- Data
			local seat = array[1]
			local playerInSeat = array[2]

			-- Check
			if seat == seat4 then

				-- Empty it
				table.remove(filledSeatsArray, table.find(filledSeatsArray, seat))

				-- Remove this player..
				table.remove(playerList, table.find(playerList, playerInSeat))
				
				-- set to remove this array
				seatArrayToRemove = array

				-- break
				break
			end

			-- Nil Stuff
			seat = nil
		end
		
		-- Remove that array..
		table.remove(playerInSeatArray, table.find(playerInSeatArray, seatArrayToRemove))
		
	end	
end)

-- Player Leaving
game:GetService("Players").PlayerRemoving:Connect(function(player)
	
	-- Remove from player list..
	if table.find(playerList, player) then
		
		-- Remove Player
		RemoveReadyPlayer(player)
		
	end	
end)

-- Teleport Failed
game:GetService("TeleportService").TeleportInitFailed:Connect(HandleFailedTeleport)

-- Main Loop for Lights --
while task.wait() do
	
	-- Keep GUIS Updated
	insidePlayerCountGUI.SurfaceGui1.TextLabel.Text = #playerList .. "/" .. MIN_PLAYERS_TO_START
	outsidePlayerCountGUI.SurfaceGui1.TextLabel.Text = #playerList .. "/" .. MIN_PLAYERS_TO_START
	outsidePlayerCountGUI.SurfaceGui2.TextLabel.Text = #playerList .. "/" .. MIN_PLAYERS_TO_START
	
	-- Lights on and Off..
	if #playerList > 0 and not lightsOn then

		-- Lights on now
		lightsOn = true

		-- turn on Lights
		TurnOnLights()

	elseif #playerList == 0 and lightsOn then

		-- now lights off
		lightsOn = false

		-- Turn them Off
		TurnOffLights()

	end	
	
	-- Check if we have enough players to start..
	if #playerList == MIN_PLAYERS_TO_START and isTeleporting == false then
		
		-- Now we are teleporting
		isTeleporting = true
		
		----------------
		-- Couintdown --
		----------------
		
		-- Set Countdown
		countdownActual = 5
		
		-- Loop
		while countdownActual > 0 do
			
			-- If a Player leaves, cancel countdown..
			if #playerList < MIN_PLAYERS_TO_START then
				
				-- LEave
				break				
				
			end
			
			-- Update Inside GUI
			insidePlayerCountGUI.SurfaceGui1.TextLabel.Text = countdownActual
			
			-- Wait
			task.wait(1)
			
			-- Subtract
			countdownActual -=1			
			
		end
		
		-- Countdown says 0..
		insidePlayerCountGUI.SurfaceGui1.TextLabel.Text = "0"
		
		-------------------------
		-- Now Join the Game.. --
		-------------------------
		
		-- turn off Prox Prompt
		thisProx.Enabled = false
		
		-- If we stil have enough players to start..
		if #playerList == MIN_PLAYERS_TO_START then
			
			-- Fire Joining Game..
			for _, player in pairs(playerList) do

				-- fire it
				game.ReplicatedStorage.PlayerTeleporting:FireClient(player)

			end

			-- Create Server Code only if not in Studio..
			if not game:GetService("RunService"):IsStudio() then
				
				-- Create It
				serverCode = game:GetService("TeleportService"):ReserveServer(11675254893)

			end			

			-- Wait a sec
			task.wait(1)

			-- List to teleport..
			local playersToTeleport = playerList

			-- Using a PCall
			local success, result = pcall(game:GetService("TeleportService").TeleportToPrivateServer, game:GetService("TeleportService"), 11675254893, serverCode, playersToTeleport)

			-- If not success, turn
			if not success then

				-- Turn off GUI
				for _, player in pairs(playerList) do

					-- Remove Player
					RemoveReadyPlayer(player)

					-- fire it
					game.ReplicatedStorage.PlayerTeleportingCanceled:FireClient(player)

				end
			else

				-- Wait for all players to leave..
				while #playerList > 0 do

					-- Wait
					task.wait()						
				end

				-- Wait one more sec
				task.wait(1)					

			end
			
				
		end				
		
		-- Reset teleporting..
		isTeleporting = false
		
		-- Re Enable Prox
		thisProx.Enabled = true
		
	end
end