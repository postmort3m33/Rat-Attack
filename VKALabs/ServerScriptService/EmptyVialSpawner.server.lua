-- Grab Skull We are going to Clone --
local emptyVialObject = game.ServerStorage.Tools.EasterEggParts.VialEmptyPart

-- Spawn Vars --
local totalVialsToSpawn = 3

-- Skull spawn Positions --
local spawn1 = Vector3.new(197.64, 2.95, 10.652) -- Lab, Storage, Bottom Shelf
local spawn2 = Vector3.new(161.397, 9.94, 47.5) -- Lab, Storage, top Shelf
local spawn3 = Vector3.new(103.465, 4.338, 164.867) -- Office Room, Cubicle by Shipping Door
local spawn4 = Vector3.new(-0.374, 5.194, 9.5) -- Assembly Room, Shelves
local spawn5 = Vector3.new(2.772, 9.931, -7.875) -- Assembly Room, Shelves
local spawn6 = Vector3.new(46.836, -4.262, 214.25) -- Outside, behind Dumpster

-- Skull Spawn Position Array --
local skullSpawns = {spawn1, spawn2, spawn3, spawn4,
						spawn5, spawn6}

----------------------------------
-- Randomly Choose Skull Spawns --
----------------------------------
for i = 1, totalVialsToSpawn do
	
	-- Random number --
	local randomNumber = math.random(1, #skullSpawns)
	
	-- Spawn the skull --
	local clone = emptyVialObject:Clone()
	clone.Parent = game.Workspace
	clone.CFrame = CFrame.new(skullSpawns[randomNumber]) * CFrame.Angles(math.rad(90),0,0)
	clone.Ends.CFrame = CFrame.new(skullSpawns[randomNumber]) * CFrame.Angles(math.rad(90),0,0)	
	
	-- Delete that table entry --
	table.remove(skullSpawns, randomNumber)
	
	-- NIl Stuff
	clone = nil
	randomNumber = nil
	
	-- wait
	task.wait()	
end
