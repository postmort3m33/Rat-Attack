-- Teleport service
local TeleportService = game:GetService("TeleportService")
local MessagingService = game:GetService("MessagingService")

-- Connections --
local receiveServerInfoConnection = nil

-- Stuff
local thisProx = script.Parent.Body:WaitForChild("ProximityPrompt")

-- State Vars
local numPlayers = 0
local gameStarted = false

-- GUI Stuff
local textLabel1 = script.Parent.PlayerCountGUI.SurfaceGui1:WaitForChild("TextLabel")
local textLabel2 = script.Parent.PlayerCountGUI.SurfaceGui2:WaitForChild("TextLabel")

-- Ref
local serverCode, serverID

-- Wait a Second..
task.wait(3)

----------
-- Init --
----------

textLabel1.Text = "0/1"
textLabel2.Text = "0/1"

-----------------
-- Connections --
-----------------

-- Create Resevred Server
serverCode, serverID = TeleportService:ReserveServer(11675254893)

-- Call MessagingService (Is a Connection)
receiveServerInfoConnection = MessagingService:SubscribeAsync(serverID, function(message)

	-- Data
	local data = message.Data
	
	-- If this came from the server..
	if data.Sender == "Server" then
		
		-- Set NumPlayers
		numPlayers = tonumber(data.Players)

		-- Set Game Started..
		if data.GameStarted == "true" then gameStarted = true else gameStarted = false end

		-- Update GUI
		textLabel1.Text = numPlayers .. "/1"
		textLabel2.Text = numPlayers .. "/1"

		-- nil Stuff
		data = nil
		
	end	
	
	------------------------------------------------------------------------
	-- Send Server A Message Stating How Many Players to Set the Lobby... --
	------------------------------------------------------------------------
	
	-- Create Data to Send
	local dataArray = {Sender = "Lobby", MaxPlayers = 1} -- This is a Duo Server..

	-- Publish Player Cont in PCall
	local success, errorMessage = pcall(MessagingService.PublishAsync, MessagingService, tostring(serverID), dataArray)

	-- Nil Stuff
	dataArray = nil
	
end)	

-- Prox prompty
thisProx.Triggered:Connect(function(player)
	
	-- Dont Teleport Players if the Server is full..
	if numPlayers < 1 then
		
		-- Using a PCall
		local success, result = pcall(TeleportService.TeleportToPrivateServer, TeleportService, 11675254893, serverCode, {player})

		-- If Failed..
		if success == false then

			-- Let Player Know..
			game.ReplicatedStorage.SendPlayerHUDMessage:FireClient(player, "Join Failed!")

			-- Leave
			return

		else

			-- If True
			game.ReplicatedStorage.PlayerTeleporting:FireClient(player)			

		end	
		
	else
		
		-- Tell Player the Serve ris full
		game.ReplicatedStorage.SendPlayerHUDMessage:FireClient(player, "Server is full!")
	end
	
end)

---------------
-- Main Loop --
---------------

while task.wait() do
	
	-- When a server gets full..
	if gameStarted then
		
		-- Debounce
		gameStarted = false
		
		-- Reset
		sentMaxPlayers = false
		
		-- Other Vars
		numPlayers = 0
		
		-- Re-Init
		textLabel1.Text = "0/1"
		textLabel2.Text = "0/1"
		
		-- Make New Server..
		serverCode, serverID = TeleportService:ReserveServer(11675254893)
		
		-- Wait
		task.wait()
		
		-- Break Old Server Info Connection..
		if receiveServerInfoConnection then receiveServerInfoConnection:Disconnect() end
		
		-- Wait
		task.wait()
		
		-- Make New Connection..
		receiveServerInfoConnection = MessagingService:SubscribeAsync(serverID, function(message)
			
			-- Data
			local data = message.Data

			-- If this came from the server..
			if data.Sender == "Server" then

				-- Set NumPlayers
				numPlayers = tonumber(data.Players)

				-- Set Game Started..
				if data.GameStarted == "true" then gameStarted = true else gameStarted = false end

				-- Update GUI
				textLabel1.Text = numPlayers .. "/1"
				textLabel2.Text = numPlayers .. "/1"

				-- nil Stuff
				data = nil

			end	

			------------------------------------------------------------------------
			-- Send Server A Message Stating How Many Players to Set the Lobby... --
			------------------------------------------------------------------------
			
			-- Create Data to Send
			local dataArray = {Sender = "Lobby", MaxPlayers = 1} -- This is a Duo Server..

			-- Publish Player Cont in PCall
			local success, errorMessage = pcall(MessagingService.PublishAsync, MessagingService, tostring(serverID), dataArray)

			-- Nil Stuff
			dataArray = nil
			
		end)		
	end
end

