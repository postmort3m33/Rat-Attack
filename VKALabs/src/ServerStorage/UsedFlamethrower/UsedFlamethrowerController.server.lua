-- Services --
local DebrisService = game:GetService("Debris")

-- this Object
local thisFlamethrower = script.Parent

----------------
-- Connections--
----------------

-- What the Bolt touches..
thisFlamethrower.Touched:Connect(function(part)
	
	-- Wait
	task.wait()
	
	-- If the Part has a parent..
	if part.Parent then

		-- Did we hit a humanoid..
		if part.Parent:FindFirstChild("Humanoid") then

			-- If its still alive..
			if part.Parent.Humanoid.Health > 0 then

				-- Make sure its a rat..
				if part.Parent.Name == "Rat" or part.Parent.Name == "RatKing" or part.Parent.Name == "RatAlbino" or part.Parent.Name == "RatAlbinoMinion" then

					-- Make sure we only do this once per rat..
					if part == part.Parent.PrimaryPart then
						
						-- Only Attach one..
						local ratHRPChildren = part:GetChildren()
						local foundFireEmitter = false

						-- Look for FireEmitter..
						for _, child in pairs(ratHRPChildren) do

							-- If we have a fireEmitter already, leave..
							if child.Name == "FireImpact" then

								-- Found one
								foundFireEmitter = true

								-- Break
								break
							end
						end

						-- If we found one leave
						if foundFireEmitter then

							-- return
							return
						else

							-- Attach a Fire Emitter to the Rat..
							local fireEmitter = game.ServerStorage.Particles.FireImpact:Clone()

							-- Workspace
							fireEmitter.Parent = part

							-- Position it to part..
							fireEmitter.Position = part.Position

							-- Transfer Player Name
							fireEmitter.PlayerName.Value = script.Parent.PlayerName.Value

							-- Weld this part to RAT HRP..
							local weld = Instance.new("Weld")

							-- Parent
							weld.Parent = part

							-- Set it
							weld.Part0 = part
							weld.Part1 = fireEmitter

							-- Nil
							fireEmitter = nil
							weld = nil			

						end
					end
				end
			end
		end
	end
end)

-- Toucheded
thisFlamethrower.TouchEnded:Connect(function(part)
	
	-- Wait
	task.wait()

	-- If its concrete.. Destroy it.
	if part.Material.Name == "Concrete" or part.Material.Name == "Glass" then

		-- Wait
		task.wait()

		-- Destroy it..
		--thisFlamethrower:Destroy()
	end
end)