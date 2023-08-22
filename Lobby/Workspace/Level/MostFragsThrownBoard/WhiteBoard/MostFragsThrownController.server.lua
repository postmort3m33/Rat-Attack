-- Services --
local DataStoreService = game:GetService("DataStoreService")

-- Create Data Storage --
local MostFragsThrownDataStore = DataStoreService:GetOrderedDataStore("MostFragsThrownDataStore1")

-- Entities --
local mostFragsThrownTextBox = script.Parent.SurfaceGui:WaitForChild("MostFragsThrownListText")

-- vars --
local isAscending = false
local pageSize = 10 -- How Many Players will be displayed --

---------------
-- Main Loop --
---------------

-- Always Update It --
while true do
	
	-----------------------------------------	
	-- Set Top Player List Every 5 Minutes --
	-----------------------------------------
	
	-- Define Sorted Data Container --
	local mostFragsThrownPages = nil
	
	-- Get Sorted Pages from DataStore --
	local success, errorMessage = pcall(function()

		-- Retrieve Data --
		mostFragsThrownPages = MostFragsThrownDataStore:GetSortedAsync(isAscending, pageSize)
	end)
	
	-- if it was successful
	if success then
		
		-- Define the First Page (Top Ten)
		local currentPage = mostFragsThrownPages:GetCurrentPage()

		-- Create the Empty String --
		local rankedList = ''

		-- Write all Data to one String with formatting --
		for rank, data in pairs(currentPage) do

			-- Write the String --
			rankedList = rankedList .. rank .. ": " .. data.key .. "    Thrown: " .. tonumber(data.value) .. "\n" 
		end

		-- Now set the Text Box on the GlassWall --
		mostFragsThrownTextBox.Text = rankedList		
		
	else
		
		-- Show error
		warn(errorMessage)
	end	
	
	-- Wait
	task.wait(300)
end
