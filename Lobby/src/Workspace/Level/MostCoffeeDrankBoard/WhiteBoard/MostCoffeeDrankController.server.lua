-- Services --
local DataStoreService = game:GetService("DataStoreService")

-- Create Data Storage --
local MostCoffeeDrankDataStore = DataStoreService:GetOrderedDataStore("MostCoffeeDrankDataStore1")

-- Entities --
local mostCoffeeDrankTextBox = script.Parent.SurfaceGui:WaitForChild("MostCoffeeDrankListText")

-- vars --
local isAscending = false
local pageSize = 10 -- How Many Players will be displayed --

-- Change Specific Entry --
--MostCoffeeDrankDataStore:SetAsync("Potat0Parade", 0)

-------------------
-- Hacker List.. --
-------------------

-- "Potat0Parade"

---------------
-- Main Loop --
---------------

-- Always Update It --
while true do
	
	-----------------------------------------	
	-- Set Top Player List Every 5 Minutes --
	-----------------------------------------
	
	-- Define Sorted Data Container --
	local mostCoffeeDrankPages = nil
	
	-- Get Sorted Pages from DataStore --
	local success, errorMessage = pcall(function()

		-- Retrieve Data --
		mostCoffeeDrankPages = MostCoffeeDrankDataStore:GetSortedAsync(isAscending, pageSize)
	end)
	
	-- if it was successful
	if success then
		
		-- Define the First Page (Top Ten)
		local currentPage = mostCoffeeDrankPages:GetCurrentPage()

		-- Create the Empty String --
		local rankedList = ''

		-- Write all Data to one String with formatting --
		for rank, data in pairs(currentPage) do

			-- Write the String --
			rankedList = rankedList .. rank .. ": " .. data.key .. "    Drank: " .. tonumber(data.value) .. "\n" 
		end

		-- Now set the Text Box on the GlassWall --
		mostCoffeeDrankTextBox.Text = rankedList		
		
	else
		
		-- Show error
		warn(errorMessage)
	end	
	
	-- Wait
	task.wait(300)
end
