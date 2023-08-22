-- Connections
script.Parent.CountValue.Changed:Connect(function()
	
	-- Update the Label
	script.Parent.Text = "x" .. script.Parent.CountValue.Value
	
	-- If its zero, dont show it..
	if script.Parent.CountValue.Value > 1 then
		
		-- show Label
		script.Parent.Visible = true
	else
		
		-- Hide It
		script.Parent.Visible = false
		
	end	
end)
