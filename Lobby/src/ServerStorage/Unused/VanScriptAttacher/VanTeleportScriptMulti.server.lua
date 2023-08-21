-- Wait
task.wait(3)

-- Connections --
local receiveServerInfoConnection = nil

-- Stuff
local thisProx = script.Parent:WaitForChild("Body"):WaitForChild("ProximityPrompt")

-- Set Min Players but wait for value to update..
while script.MinPlayers.Value == 0 do task.wait() end

-- Wait a sec
task.wait(1)

-- Set Min PLayers
local MIN_PLAYERS_TO_START = script.MinPlayers.Value

-- State Vars
local numPlayers = 0

-- GUI Stuff
local textLabel1 = script.Parent.PlayerCountGUI.SurfaceGui1:WaitForChild("TextLabel")
local textLabel2 = script.Parent.PlayerCountGUI.SurfaceGui2:WaitForChild("TextLabel")

-- Ref
local serverCode, serverID
local initializedReserveServer = false

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

-- Send Server Max PLayers --
local function SendServerMaxPlayers(maxPlayers)
	
	------------------------------------------------------------------------
	-- Send Server A Message Stating How Many Players to Set the Lobby... --
	------------------------------------------------------------------------

	-- Vars
	local success, errorMessage = nil

	-- Create Data to Send
	local dataArray = {Sender = "Lobby", MaxPlayers = maxPlayers}

	-- Publish Player Cont in PCall
	success, errorMessage = pcall(game:GetService("MessagingService").PublishAsync, game:GetService("MessagingService"), tostring(serverID), dataArray)
	
end

-- Create New Server Connection
local function CreateNewServerConnection()
	
	-- If in studio, leave
	if game:GetService("RunService"):IsStudio() then return end	
	
	-- Nil Server Codes..
	serverCode = nil
	serverID = nil
	
	-- Create New ONe..
	serverCode, serverID = game:GetService("TeleportService"):ReserveServer(11675254893)

	-- Wait
	task.wait(1)
	
	-- Reset NumPlayers
	numPlayers = 0
	
	-- Reset GUI
	textLabel1.Text = "0/" .. MIN_PLAYERS_TO_START
	textLabel2.Text = "0/" .. MIN_PLAYERS_TO_START
	
	-- Disconnect Old Connnection
	if receiveServerInfoConnection then receiveServerInfoConnection:Disconnect() end

	-- Call MessagingService (Is a Connection)
	receiveServerInfoConnection = game:GetService("MessagingService"):SubscribeAsync(tostring(serverID), function(message)

		-- Data
		local data = message.Data

		-- If this came from the server..
		if data.Sender == "Server" then

			-- Set NumPlayers
			numPlayers = tonumber(data.Players)

			-- Update GUI
			textLabel1.Text = numPlayers .. "/" .. MIN_PLAYERS_TO_START
			textLabel2.Text = numPlayers .. "/" .. MIN_PLAYERS_TO_START
			
			-- Set Game Started..
			if data.GameStarted == "true" then
				
				-- Nil Data
				data = nil
				
				-- Create New Server Instance..
				CreateNewServerConnection()				
				
				-- Leave Function
				return
				
			else
				
				-- Now Send Serve Data
				SendServerMaxPlayers(MIN_PLAYERS_TO_START)				
				
			end			

			-- nil Stuff
			data = nil

		end
	end)	
end

-- Bind to Close Function
local function BindToCloseFunction()

	-- Leave this if in studio
	if game:GetService("RunService"):IsStudio() then return end

	-- Wait
	task.wait(10)

	-- Create Data to Send
	local dataArray = {Sender = "Lobby", MaxPlayers = 1}

	-- Publish Player Cont in PCall
	local success, errorMessage = pcall(game:GetService("MessagingService").PublishAsync, game:GetService("MessagingService"), tostring(serverID), dataArray)

	-- Wait one more second..
	task.wait(3)

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

-----------------
-- Connections --
-----------------

-- Prox prompty
thisProx.Triggered:Connect(function(player)
	
	-- Dont Teleport Players if the Server is full..
	if numPlayers < MIN_PLAYERS_TO_START then
		
		-- Using a PCall
		local success, result = pcall(game:GetService("TeleportService").TeleportToPrivateServer, game:GetService("TeleportService"), 11675254893, serverCode, {player})

		-- If Failed..
		if success == false then

			-- Let Player Know..
			game.ReplicatedStorage.SendPlayerHUDMessage:FireClient(player, "Teleport Failed, Try Again!")

			-- Leave
			return

		else

			-- Teleport call was successful..
			game.ReplicatedStorage.PlayerTeleporting:FireClient(player)		

		end	
		
	else
		
		-- Tell Player the Serve ris full
		game.ReplicatedStorage.SendPlayerHUDMessage:FireClient(player, "Server is full!")
	end
	
end)

-- Teleport Failed
game:GetService("TeleportService").TeleportInitFailed:Connect(HandleFailedTeleport)

-- Bind to Close Functions..
--game:BindToClose(BindToCloseFunction)

-- Main Loop for Lights --
while task.wait() do
	
	-- If server has not been initialized, do it..
	if not initializedReserveServer then

		-- Now has done it
		initializedReserveServer = true

		-- Create New One
		CreateNewServerConnection()	

	end
	
	-- If More than one player..
	if numPlayers > 0 and not lightsOn then
		
		-- Lights on now
		lightsOn = true
		
		-- turn on Lights
		TurnOnLights()
		
	elseif numPlayers == 0 and lightsOn then
		
		-- now lights off
		lightsOn = false
		
		-- Turn them Off
		TurnOffLights()
		
	end	
end
