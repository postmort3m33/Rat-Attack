-- Services --
local DataStoreService = game:GetService("DataStoreService")

-- Create Data Storage --
local MostRatsKilledDataStore = DataStoreService:GetOrderedDataStore("MostRatsKilledDataStore1")

-- Entities --
local ratsKilledTextBox = script.Parent.SurfaceGui:WaitForChild("RatsKilledListText")

-- vars --
local isAscending = false
local pageSize = 8 -- How Many Players will be displayed --

-----------------------
-- Manual RatsKilled --
-----------------------
--MostRatsKilledDataStore:SetAsync("postTester1", 9990)

---------------
-- Main Loop --
---------------

-- Always Update It --
while true do
	
	-----------------------------------------	
	-- Set Top Player List Every 5 Minutes --
	-----------------------------------------
	
	-- Define Sorted Data Container --
	local ratsKilledPages = nil
	
	-- Get Sorted Pages from DataStore --
	local success, errorMessage = pcall(function()

		-- Retrieve Data --
		ratsKilledPages = MostRatsKilledDataStore:GetSortedAsync(isAscending, pageSize)
	end)
	
	-- if it was successful
	if success then
		
		-- Define the First Page (Top Ten)
		local currentPage = ratsKilledPages:GetCurrentPage()

		-- Create the Empty String --
		local mostKilledList = ''

		-- Write all Data to one String with formatting --
		for rank, data in pairs(currentPage) do

			-- Write the String --
			mostKilledList = mostKilledList .. rank .. ": " .. data.key .. "    Killed: " .. data.value .. "\n"
		end

		-- Now set the Text Box on the GlassWall --
		ratsKilledTextBox.Text = mostKilledList	
		
		-- Nil Stuff
		currentPage = nil
		mostKilledList = nil
		success = nil
		errorMessage = nil
		
	else
		
		-- Show error
		warn(errorMessage)
		
		-- Nil
		success = nil
		errorMessage = nil
	end	
	
	-- Nil Stuff
	ratsKilledPages = nil
	
	-- Wait
	task.wait(300)
end
