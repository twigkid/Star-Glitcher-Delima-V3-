local Players = game.Players
Players.PlayerAdded:Connect(function(Player: Player)
	local localcons = {}
	local exiting = false
	
	repeat task.wait() until Player.Character
	local Character = Player.Character
	repeat task.wait() until Character:FindFirstChildOfClass("Accessory")
	for _, v in pairs(Character:GetChildren()) do
		if v:IsA("Accessory") then
			local weld = v:FindFirstChildOfClass("Part"):FindFirstChildOfClass("Weld")
			if weld then
				weld.Changed:Once(function(property)
					if property == "Parent" and not exiting then
						local handle = v:FindFirstChildOfClass("Part")
						handle:Destroy()
					end
				end)
			end
		end
	end
end)

workspace.ChildAdded:Connect(function(Part)
	if Part:IsA("Accessory") or Part.Name == "Handle" then
		Part:Destroy()
	end
end)