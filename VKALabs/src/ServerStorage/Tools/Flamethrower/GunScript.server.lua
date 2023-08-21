-----------------
-- Connections --
-----------------

-- When Equipped
script.Parent.Equipped:Connect(function()	
	
	------------------------------------------
	-- Attach Gun to Character, server side --
	------------------------------------------
	
	-- Clone It
	local holdmodel = game.ReplicatedStorage.GunSystem.Guns.Flamethrower.Model:Clone()
	
	-- Unchanchor it
	holdmodel.Handle.Anchored=false
	
	-- Create A weld to the right hand..
	local weld = Instance.new("Weld", holdmodel.Handle)
	weld.Part0=holdmodel.Handle
	weld.Part1=script.Parent.Parent.RightHand
	weld.C0=weld.C0*CFrame.new(0,0,1)
	weld.C1=CFrame.Angles(-1.5,0,0)
	holdmodel.Parent=script.Parent.Parent
	
	-- Places an ObjectValue copy of the gun on the players character
	local gunobj=Instance.new("ObjectValue")
	gunobj.Name = "Gun"
	gunobj.Value = script.Parent
	gunobj.Parent = script.Parent.Parent
	
end)