-- Grab Skull We are going to Clone --
local skull = game.ServerStorage.Prefabs.Skull

-- Spawn Vars --
local totalSkullsToSpawn = 5

-- Skull spawn Positions --
local spawn1 = Vector3.new(-38.747, 15.769, 192.488) -- Shipping Room, Top of Crates
local spawn2 = Vector3.new(3.023, 15.975, 197.194) -- Shipping Room, Top of Shelves 1
local spawn11 = Vector3.new(47.138, 1.093, 197.701) -- Shipping Room, Ground, Room Corner By Shelves
local spawn13 = Vector3.new(24.674, 15.984, 102.559) -- Shipping Room, Top of Shelves 2
local spawn3 = Vector3.new(194.575, 6.791, 111.008) -- Office Room, Back Corner Shelf
local spawn4 = Vector3.new(105.683, 0.966, 191.163) -- Office Room, Ground, Back Corner
local spawn7 = Vector3.new(177.66, 12.718, 29.668) -- Lab Room, Storage Room, Top of Boxes
local spawn8 = Vector3.new(121.91, 3.968, -47.207) -- Lab Room, Vial Storage
local spawn10 = Vector3.new(192.138, 0.968, -26.424) -- Lab Room, Mens BathRoom, Stall
local spawn12 = Vector3.new(41.519, -2.875, 217.118) -- Outside, Dumpstger
local spawn14 = Vector3.new(168.888, 0.968, -29.424) -- Lab Room, Womens BathRoom, Stall

-- Unused Skull Spawns
--local spawn9 = Vector3.new(182.388, 5.093, -47.799) -- Lab Room, Meeting Room Bookshelf
--local spawn5 = Vector3.new(139.625, 5, 126.375) -- Storage Room, In Bus
--local spawn12 = Vector3.new(112.888, 1.093, 182.951) -- Storage Room, Ground, Corner of Containers
--local spawn6 = Vector3.new(-45.223, 3.875, 106.25) -- Shipping Room, Work Desk


-- Skull Spawn Position Array --
local skullSpawns = {spawn1, spawn2, spawn3, spawn4,
						spawn7, spawn8, spawn10, spawn11, spawn13, spawn12, spawn14}

----------------------------------
-- Randomly Choose Skull Spawns --
----------------------------------
for i = 1, totalSkullsToSpawn do
	
	-- Random number --
	local randomNumber = math.random(1, #skullSpawns)
	
	-- Spawn the skull --
	local clone = skull:Clone()
	clone.Parent = game.Workspace
	clone.Position = skullSpawns[randomNumber]
	
	-- Delete that table entry --
	table.remove(skullSpawns, randomNumber)
	
	-- NIl Stuff
	clone = nil
	randomNumber = nil
	
	-- wait
	task.wait()	
end

-- Non-Random Spawns

--[[
-- Lava Room Skull --
local clone = skull:Clone()
clone.Parent = game.Workspace
clone.Position = Vector3.new(76.375, 36, 200.25)
]]

-- NIl Stuff
clone = nil
