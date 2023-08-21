-- Grab Skull We are going to Clone --
local aerosolCanObject = game.ServerStorage.Tools.EasterEggParts.AerosolCanPart

-- Spawn Vars --
local totalCansToSpawn = 3

-- Skull spawn Positions --
local spawn1 = Vector3.new(-45.962, 1, 112.998) -- Shipping, By Crafting Bench 
local spawn2 = Vector3.new(156.11, 4.523, 177.419) -- Office Room Cubicle Shelf 
local spawn3 = Vector3.new(197.164, 7.626, 42.263) -- Lab, Storage Room 
local spawn4 = Vector3.new(144.241, 10.304, 44.612) -- Lab, Office Room 
local spawn5 = Vector3.new(47.266, 4.098, -43.311) -- Assembly, Corner Table 
local spawn6 = Vector3.new(-47.378, 0.898, -4.576) -- Assembly, IBeam Corner 
local spawn7 = Vector3.new(-24.312, 1.029, 28.913) -- Assembly, In Box by Belt and Propane Tank 
local spawn8 = Vector3.new(2.523, 5.361, -8.851) -- Assembly, Middle Shelves 
local spawn9 = Vector3.new(45.219, 4.674, 187.93) -- Shipping, Corner ShelfStack
local spawn10 = Vector3.new(33.09, 2.977, 197.255) -- Shipping, Corner ShelfStack, Opposite
local spawn11 = Vector3.new(-33.418, -4.102, 200.426) -- Outside, By Ramp 
local spawn12 = Vector3.new(-18.657, -4.102, 209.752) -- Outside, Under Truck 
local spawn13 = Vector3.new(4.599, -4.114, 300.351) -- Outside, In Car Backseat 
local spawn14 = Vector3.new(77.018, 0.898, 156.288) -- Shipping/Storage Hallway Vent 
local spawn15 = Vector3.new(198.699, 0.911, 198.665) -- OFfice, Cubicles Empty Corner 
local spawn16 = Vector3.new(198.339, 4.617, -48.477) -- Lab, Meeting Room, Bookshelf

-- Skull Spawn Position Array --
local canSpawns = { spawn1, spawn2, spawn3, spawn4, spawn5, spawn6, spawn7, spawn8, spawn9, spawn10,
	spawn11, spawn12, spawn13, spawn14, spawn15, spawn16 }

----------------------------------
-- Randomly Choose Skull Spawns --
----------------------------------
for i = 1, totalCansToSpawn do
	
	-- Random number --
	local randomNumber = math.random(1, #canSpawns)
	
	-- Spawn the skull --
	local clone = aerosolCanObject:Clone()
	clone.Parent = game.Workspace
	clone.CFrame = CFrame.new(canSpawns[randomNumber]) * CFrame.new(0, 0.15, 0) * CFrame.Angles(0, math.rad(math.random(0,360)), 0)
	
	-- Delete that table entry --
	table.remove(canSpawns, randomNumber)
	
	-- NIl Stuff
	clone = nil
	randomNumber = nil
	
	-- wait
	task.wait()	
end
