-- Services --
local DataStoreService = game:GetService("DataStoreService")

-- Create Data Storage --
local BestGameTimeDataStore = DataStoreService:GetOrderedDataStore("BestGameTimeDataStore1")

-- Entities --
local bestGameTimeTextBox = script.Parent.SurfaceGui:WaitForChild("BestGameTimeList")

-- vars --
local isAscending = true
local pageSize = 8 -- How Many Players will be displayed --

---------------
-- Functions --
---------------

-- Seconds to Minutes/Seconds
local function FormatTime(timeNumber)
	
	-- Millisecond Support..
	local timeSeconds = math.floor(timeNumber)
	local timeMilliseconds = math.round((timeNumber - math.floor(timeNumber)) * 1000)
	
	-- Ref
	local min, sec = tostring(math.floor(timeSeconds / 60)), tostring(timeSeconds % 60)

	-- Logic
	if #sec == 1 then
		sec = "0" .. sec
	end

	-- Return string..
	return tostring(min)..":"..tostring(sec) .. ":" .. tostring(timeMilliseconds)
	
end

--------------------------
-- Resetting a Gametime --
--------------------------
--BestGameTimeDataStore:SetAsync("postmort3mdev", 1233333)

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
		bestTimesPages = BestGameTimeDataStore:GetSortedAsync(isAscending, pageSize)
	end)

	-- if it was successful
	if success then

		-- Define the First Page (Top Ten)
		local currentPage = bestTimesPages:GetCurrentPage()

		-- Create the Empty String --
		local timesList = ''

		-- Write all Data to one String with formatting --
		for rank, data in pairs(currentPage) do
			
			-- Format the time into minutes and seconds..
			local formattedTime = FormatTime((tonumber(data.value))/1000)

			-- Write the String --
			timesList = timesList .. rank .. ": " .. data.key .. "    Time: " .. formattedTime .. "\n"
			
			-- Nil
			formattedTime = nil
		end

		-- Now set the Text Box on the GlassWall --
		bestGameTimeTextBox.Text = timesList		

	else

		-- Show error
		warn(errorMessage)
	end	

	-- Wait
	task.wait(300)
end
