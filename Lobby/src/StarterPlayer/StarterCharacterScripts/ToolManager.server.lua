----------
-- Vars --
----------

-- Tool Stuff
local currentTool = nil
local currentToolObjectValue = nil
local currentToolModel = nil

-- Animation Stuff..
local thisHumanoid = script.Parent:WaitForChild("Humanoid")
local toolAnim = script:WaitForChild("ToolNoneAnim")
local toolAnimTrack = thisHumanoid:LoadAnimation(toolAnim)

-----------------
-- Connections --
-----------------

-- Child Added..
script.Parent.ChildAdded:Connect(function(child)
	
	-- if it was a gun or item..
	if child.Name == "Gun" or child.Name == "Item" then
		
		-- Set current ObjectValue
		currentToolObjectValue = child
		
		-- Play Tool Animation
		toolAnimTrack:Play()
		
	elseif child:IsA("Tool") then
		
		-- Set Current TOol
		currentTool = child
		
	elseif child.Name == "Model" then
		
		-- Set
		currentToolModel = child
	end
	
end)

-- Child Removed..
script.Parent.ChildRemoved:Connect(function(child)
	
	-- if we removed a tool..
	if child:IsA("Tool") then
		
		-- Set current Tool to Nil
		currentTool = nil
		
		-- Remove the current ObjectValue as well
		if currentToolObjectValue then
			
			-- Remove
			currentToolObjectValue:Destroy()
			currentToolObjectValue = nil
			
		end
		
		-- Remove the Model as well..
		if currentToolModel then
			
			-- Remove It..
			currentToolModel:Destroy()
			currentToolModel = nil
		end	
		
		-- Stop Playing Tool Animation
		toolAnimTrack:Stop()
		
	end
end)
