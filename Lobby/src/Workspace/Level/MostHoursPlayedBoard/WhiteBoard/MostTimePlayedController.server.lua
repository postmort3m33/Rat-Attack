-- Services --
local DataStoreService = game:GetService("DataStoreService")

-- Create Data Storage --
local MostTimePlayedDataStore = DataStoreService:GetOrderedDataStore("MostTimePlayedDataStore1")

-- Entities --
local mostTimePlayedTextBox = script.Parent.SurfaceGui:WaitForChild("MostTimePlayedListText")

-- vars --
local isAscending = false
local pageSize = 8 -- How Many Players will be displayed --

---------------
-- Functions --
---------------

-- Seconds to Minutes/Seconds
local function FormatTime(timeNumber)
	
	-- Millisecond Support..
	local timeSeconds = timeNumber
	
	-- Ref
	local min, sec = math.floor(timeSeconds / 60), timeSeconds % 60
	local hours = math.floor(min/60)
	min -= hours * 60
	
	-- Change to strings
	hours = tostring(hours)
	min = tostring(min)
	sec = tostring(sec)

	-- Logic
	if #sec == 1 then -- If there is only 1 character, put a 0 before the second..
		sec = "0" .. sec
	end
	
	-- Min Logic..
	if #min == 1 then
		min = "0" .. min
	end

	-- Return string..
	return tostring(hours).. ":" .. tostring(min) .. ":" ..tostring(sec)
	
end


---------------
-- Main Loop --
---------------

-- Always Update It --
while true do
	
	-----------------------------------------	
	-- Set Top Player List Every 5 Minutes --
	-----------------------------------------

	-- Define Sorted Data Container --
	local mostTimePlayedPages = nil

	-- Get Sorted Pages from DataStore --
	local success, errorMessage = pcall(function()

		-- Retrieve Data --
		mostTimePlayedPages = MostTimePlayedDataStore:GetSortedAsync(isAscending, pageSize)
	end)

	-- if it was successful
	if success then

		-- Define the First Page (Top Ten)
		local currentPage = mostTimePlayedPages:GetCurrentPage()

		-- Create the Empty String --
		local rankedList = ''

		-- Write all Data to one String with formatting --
		for rank, data in pairs(currentPage) do
			
			-- Format the time into minutes and seconds..
			local formattedTime = FormatTime(tonumber(data.value))

			-- Write the String --
			rankedList = rankedList .. rank .. ": " .. data.key .. "    Time: " .. formattedTime .. "\n"
			
			-- Nil
			formattedTime = nil
		end

		-- Now set the Text Box on the GlassWall --
		mostTimePlayedTextBox.Text = rankedList		

	else

		-- Show error
		warn(errorMessage)
	end	

	-- Wait
	task.wait(300)
end
