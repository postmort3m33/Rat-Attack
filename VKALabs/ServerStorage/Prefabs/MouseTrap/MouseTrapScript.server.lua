-- Services
local DebrisService = game:GetService("Debris")

-- Refs --
local proxPrompt = script.Parent.ProximityPrompt
local mouseTrapWithCheese = game.ServerStorage.Prefabs.MouseTrapWithCheese

-- var --
local playerHasCheese = false
local playerCheeseTool = nil

-----------------
-- Connections --
-----------------

-- Prox Prompt
proxPrompt.Triggered:Connect(function(player)

	-- Reset tool in Backpack
	playerHasCheese = false

	-- Loop Through Player Childen that our tools..
	for _, child in pairs(player.Character:GetChildren()) do

		-- If its a tool..--
		if child:IsA("Tool") then

			-- check if its this tool--
			if child.Name == "Cheese" then

				-- Found Tool --
				playerHasCheese = true

				-- Set this Propane Tank
				playerCheeseTool = child

				-- break
				break
			end
		end
	end

	-- IF Player had the tank in hand, then place it.. --
	if playerHasCheese then

		-- Take tank from player..
		playerCheeseTool:Destroy()

		-- Place Trap with Cheese
		local clone = mouseTrapWithCheese:Clone()
		
		-- Workspace
		clone.Parent = game.Workspace
		
		-- Position
		clone.CFrame = script.Parent.CFrame
		clone.Cheese.CFrame = script.Parent.CFrame * CFrame.new(0.5,0.66,0)
		
		-- Set Trap Sound
		clone.SetTrap:Play()
		
		-- Fire Mouse Trap Set event
		game.ReplicatedStorage.EasterEggEvents.MouseTrapSet:Fire(player, clone)
		
		-- Wait
		task.wait()
		
		-- Destroy Old one
		DebrisService:AddItem(script.Parent, 0.5)
	else
		
		-- Send Message
		game.ReplicatedStorage.SendPlayerHUDMessage:FireClient(player, "You'll need some Cheese to do that!")
	end		

end)

-- Check for Dead Rat Spawned..
game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer.Event:Connect(function(id)
	
	-- If this was number 22 (Dead Rat was spawned..)
	if id == 22 then
		
		-- Turn off this highlight and proxomity prompty..
		script.Parent.Highlight.Enabled = false
		script.Parent.ProximityPrompt.Enabled = false
	end
end)