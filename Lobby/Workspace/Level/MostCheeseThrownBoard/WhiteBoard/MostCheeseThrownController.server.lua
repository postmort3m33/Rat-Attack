-- Services --
local DataStoreService = game:GetService("DataStoreService")

-- Create Data Storage --
local MostCheeseThrownDataStore = DataStoreService:GetOrderedDataStore("MostCheeseThrownDataStore1")

-- Entities --
local mostCheeseThrownTextBox = script.Parent.SurfaceGui:WaitForChild("MostCheeseThrownListText")

-- vars --
local isAscending = false
local pageSize = 8 -- How Many Players will be displayed --

-- Change Specific Entry --
--MostCheeseThrownDataStore:SetAsync("Potat0Parade", 0)

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
	local mostCheeseThrownPages = nil
	
	-- Get Sorted Pages from DataStore --
	local success, errorMessage = pcall(function()

		-- Retrieve Data --
		mostCheeseThrownPages = MostCheeseThrownDataStore:GetSortedAsync(isAscending, pageSize)
	end)
	
	-- if it was successful
	if success then
		
		-- Define the First Page (Top Ten)
		local currentPage = mostCheeseThrownPages:GetCurrentPage()

		-- Create the Empty String --
		local rankedList = ''

		-- Write all Data to one String with formatting --
		for rank, data in pairs(currentPage) do

			-- Write the String --
			rankedList = rankedList .. rank .. ": " .. data.key .. "    Thrown: " .. tonumber(data.value) .. "\n" 
		end

		-- Now set the Text Box on the GlassWall --
		mostCheeseThrownTextBox.Text = rankedList		
		
	else
		
		-- Show error
		warn(errorMessage)
	end	
	
	-- Wait
	task.wait(300)
end
