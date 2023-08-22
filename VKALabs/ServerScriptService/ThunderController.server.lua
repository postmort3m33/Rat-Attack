-- Table
local soundStringTable = {"Close1", "Close2", "Distant1", "Distant2", "DistantQuiet"}

-- Main Loop
while task.wait(math.random(10, 60)) do
	
	-- Random number
	local random = math.random(1, #soundStringTable)
	
	-- Send To GUI
	game.ReplicatedStorage.PlayThunderSoundSTC:FireAllClients(soundStringTable[random])
	
	-- Nil
	random = nil
end
