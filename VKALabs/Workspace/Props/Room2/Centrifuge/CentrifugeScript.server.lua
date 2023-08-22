-- Vars --
local thisObject = script.Parent
local thisProx = thisObject.Middle.ProximityPrompt
local vialWithPlasmaProx = thisObject.BloodTube.Glass.ProximityPrompt
local thisVial = script.Parent.BloodTube
local thisVialWithBloodEndsPart = script.Parent.BloodTube.Ends
local thisVialWithBloodBloodPart = script.Parent.BloodTube.Blood
local thisVialWithBloodGlassPart = script.Parent.BloodTube.Glass -- 0.7 Transparency

-- Vars
local playersHasVialWithAlbinoBlood = false
local playerVialWithAlbinoBloodTool = nil

----------
-- Init --
----------

-- Prox Prompt Ready
thisProx.Enabled = true

-----------------
-- Connections --
-----------------

-- Prox Prompt
thisProx.Triggered:Connect(function(player)

	-- Reset tool in Backpack
	playersHasVialWithAlbinoBlood = false

	-- Loop Through Player Childen that our tools..
	for _, child in pairs(player.Character:GetChildren()) do

		-- If its a tool..--
		if child:IsA("Tool") then

			-- check if its this tool--
			if child.Name == "VialWithAlbinoBlood" then

				-- Found Tool --
				playersHasVialWithAlbinoBlood = true

				-- Set this Propane Tank
				playerVialWithAlbinoBloodTool = child

				-- break
				break
			end
		end
	end

	-- IF Player had the tank in hand, then place it.. --
	if playersHasVialWithAlbinoBlood then
		
		-- Turn off Prox Prompt
		thisProx.Enabled = false

		-- Take tank from player..
		playerVialWithAlbinoBloodTool:Destroy()
		
		-- Vial Sound
		game.ReplicatedStorage.PlayLocalSound:FireClient(player, "BloodExchange")

		-- ShowVialWithBlood
		thisVialWithBloodEndsPart.Transparency = 0
		thisVialWithBloodBloodPart.Transparency = 0
		thisVialWithBloodGlassPart.Transparency = 0.7
		
		-- Wait
		task.wait(1)
		
		-- Play SpinuSound
		script.Parent.Middle.SpinUp:Play()
		
		-- Animate Centrifuge Spinning --
		local TweenInformation = TweenInfo.new(.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
		local Tween1 = game.TweenService:Create(thisObject.PrimaryPart, TweenInformation, {["CFrame"] = thisObject.PrimaryPart.CFrame * CFrame.Angles(math.rad(120), 0, 0)})
		local Tween2 = game.TweenService:Create(thisObject.PrimaryPart, TweenInformation, {["CFrame"] = thisObject.PrimaryPart.CFrame * CFrame.Angles(math.rad(240), 0, 0)})
		local Tween3 = game.TweenService:Create(thisObject.PrimaryPart, TweenInformation, {["CFrame"] = thisObject.PrimaryPart.CFrame * CFrame.Angles(math.rad(360), 0, 0)})
		local Tween4 = game.TweenService:Create(thisObject.PrimaryPart, TweenInformation, {["CFrame"] = thisObject.PrimaryPart.CFrame * CFrame.Angles(math.rad(480), 0, 0)})
		local Tween5 = game.TweenService:Create(thisObject.PrimaryPart, TweenInformation, {["CFrame"] = thisObject.PrimaryPart.CFrame * CFrame.Angles(math.rad(600), 0, 0)})
		local Tween6 = game.TweenService:Create(thisObject.PrimaryPart, TweenInformation, {["CFrame"] = thisObject.PrimaryPart.CFrame * CFrame.Angles(math.rad(720), 0, 0)})
		Tween1:Play()
		Tween1.Completed:Wait()
		Tween2:Play()
		Tween2.Completed:Wait()
		Tween3:Play()
		Tween3.Completed:Wait()
		Tween4:Play()
		Tween4.Completed:Wait()
		Tween5:Play()
		Tween5.Completed:Wait()
		Tween6:Play()
		Tween6.Completed:Wait()
		
		-- Play Winddown
		script.Parent.Middle.WindDown:Play()
		
		-- Make Vial with Blood Look Green..
		thisVialWithBloodBloodPart.BrickColor = BrickColor.new("Dark orange")
		thisVialWithBloodBloodPart.Material = Enum.Material.Metal
		
		-- Wait
		task.wait(0.5)
		
		-- Enable Vial With Sample Prox
		vialWithPlasmaProx.Enabled = true

		-- Objective Complete..
		game.ReplicatedStorage.MissionEvents.ObjectiveCompleteServerToServer:Fire(25)
		
		-- Nil Stuff
		TweenInformation = nil
		Tween1 = nil
		Tween2 = nil
		Tween3 = nil
		Tween4 = nil
		Tween5 = nil
		Tween6 = nil
	end	
end)

-- Vial With Sample Prox Prompt
vialWithPlasmaProx.Triggered:Connect(function(player)
	
	-- clone the gun so every player cam have one --
	local clone =  game.ServerStorage.Tools.EasterEggParts.VialWithPlasma:Clone()

	-- If Pistol was picked up... add it as child to the player
	clone.Parent = player:WaitForChild("Backpack")

	-- Nil Stuff
	clone = nil
	
	-- Vial Sound
	game.ReplicatedStorage.PlayLocalSound:FireClient(player, "BloodExchange")
	
	-- Destroy It..
	thisVial:Destroy()	

end)
