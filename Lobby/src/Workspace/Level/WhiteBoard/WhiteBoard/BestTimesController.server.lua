-- Services --
local DataStoreService = game:GetService("DataStoreService")

-- Create Data Storage --
local BestBossTimeDataStore = DataStoreService:GetOrderedDataStore("BestBossTimeDataStore5")

-- Entities --
local bestTimesTextBox = script.Parent.SurfaceGui:WaitForChild("BestTimesListText")

-- vars --
local isAscending = true
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
	local bestTimesPages = nil
	
	-- Get Sorted Pages from DataStore --
	local success, errorMessage = pcall(function()

		-- Retrieve Data --
		bestTimesPages = BestBossTimeDataStore:GetSortedAsync(isAscending, pageSize)
	end)
	
	-- if it was successful
	if success then
		
		-- Define the First Page (Top Ten)
		local currentPage = bestTimesPages:GetCurrentPage()

		-- Create the Empty String --
		local timesList = ''

		-- Write all Data to one String with formatting --
		for rank, data in pairs(currentPage) do

			-- Write the String --
			timesList = timesList .. rank .. ": " .. data.key .. "    Time: " .. ((tonumber(data.value))/1000) .. "\n" 
		end

		-- Now set the Text Box on the GlassWall --
		bestTimesTextBox.Text = timesList		
		
	else
		
		-- Show error
		warn(errorMessage)
	end	
	
	-- Wait
	task.wait(300)
end
