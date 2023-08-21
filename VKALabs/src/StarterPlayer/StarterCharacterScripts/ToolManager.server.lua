----------
-- Vars --
----------

-- Animation Stuff..
local thisHumanoid = script.Parent:WaitForChild("Humanoid")
local toolAnim = script:WaitForChild("ToolNoneAnim")
local toolAnimTrack = thisHumanoid:LoadAnimation(toolAnim)

-----------------
-- Connections --
-----------------

-- Child Added..
script.Parent.ChildAdded:Connect(function(child)
	
	-- If its a tool..
	if child:IsA("Tool") then
		
		-- Play Anim Track
		toolAnimTrack:Play()
		
	end
	
end)

-- Child Removed..
script.Parent.ChildRemoved:Connect(function(child)
	
	-- if we removed a tool..
	if child:IsA("Tool") then
		
		-- Search Character for Model..
		for _, child in pairs(script.Parent:GetChildren()) do
			
			-- Delete Anything named Model..
			if child.Name == "Model" or child.Name == "Item" or child.Name == "Gun" then
				
				-- Remove it too
				child:Destroy()
				
			end
		end
		
		-- Stop Playing Tool Animation
		toolAnimTrack:Stop()
		
	end
end)
