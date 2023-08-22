-- This Part
local thisPart = script.Parent
local redValue = 0
local signalOn = false

-- Run a while Loop --
while true do
	
	-- If signal is on, make it go off --		
	if signalOn then
		
		-- Lower Red Value
		redValue -= 1

		-- Apply Eye Color
		thisPart.Color = Color3.fromRGB(redValue, 0, 0)	
		
		-- If it gets to 0, then its off
		if redValue <= 0 then
			
			-- Signal is now off
			signalOn = false
			
			-- Set RedValue
			redValue = 0
		end		
		
	else
		
		-- Lower Red Value
		redValue += 1

		-- Apply Eye Color
		thisPart.Color = Color3.fromRGB(redValue, 0, 0)

		-- If it gets to 0, then its off
		if redValue >= 255 then

			-- Signal is now off
			signalOn = true

			-- Reset redvalue
			redValue = 255
		end		
	end
	
	-- Wait
	task.wait()
end

-- Make sure its off after Loop..
thisPart.Color = Color3.fromRGB(0, 0, 0)
