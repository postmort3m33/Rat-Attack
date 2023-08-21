-- Grab Skull We are going to Clone --
local mouseTrap = game.ServerStorage.Prefabs:WaitForChild("MouseTrap")

-- Spawn Vars --
local totalTrapsToSpawn = 5

-- Trap spawn Positions --
local spawn1 = Vector3.new(-4.926, 0.795, 107.325) -- Shipping Room, Bottom of Shelf
local spawn2 = Vector3.new(71.197, 55.556, 75.138) -- Observatory Room, Astronaut
local spawn3 = Vector3.new(11.986, 0.801, 131.008) -- Shipping Room, Bottom of Shelf
local spawn4 = Vector3.new(-23.547, 0.506, -3.91) -- Assembly Room, Under Table
local spawn5 = Vector3.new(35.078, 0.605, -30.355) -- AssemblyRoom, Under Belt
local spawn6 = Vector3.new(-34.547, 0.517, -30.267) -- AssemblyRoom, Under Belt
local spawn7 = Vector3.new(-45.048, 0.561, 106.426) -- SHippingRoom, Under Craft Bench
local spawn8 = Vector3.new(121.739, 1.189, 101.952) -- Office Room, Conference, Bookshelf
local spawn9 = Vector3.new(179.453, 0.534, 129.218) -- Office Room, Cubicle
local spawn10 = Vector3.new(134.203, 0.524, 192.016) -- Office Room, Cubicle
local spawn11 = Vector3.new(190.953, 17.541, 48.248) -- Lab Room, Top of Pipe in Sotrage Room
local spawn12 = Vector3.new(102.2, 9.675, 8.636) -- Lab Room, Caged Rats On Top of Bench Storage
local spawn13 = Vector3.new(141.755, 0.55, 10.579) -- Lab Room, Caged Rats, Under Bench
local spawn14 = Vector3.new(182.89, 0.666, -25.627) -- Lab Room, Bathroom, Stall



-- Skull Spawn Position Array --
local trapSpawns = {spawn1, spawn2, spawn3, spawn4,
	spawn5, spawn6, spawn7, spawn8, spawn9, spawn10, spawn11, spawn12, spawn13, spawn14}
	

----------------------------------
-- Randomly Choose Skull Spawns --
----------------------------------
for i = 1, totalTrapsToSpawn do

	-- Random number --
	local randomNumber = math.random(1, #trapSpawns)

	-- Spawn the skull --
	local clone = mouseTrap:Clone()
	clone.Parent = game.Workspace
	clone.Position = trapSpawns[randomNumber]

	-- Delete that table entry --
	table.remove(trapSpawns, randomNumber)

	-- NIl Stuff
	clone = nil
	randomNumber = nil

	-- wait
	task.wait()	
end

