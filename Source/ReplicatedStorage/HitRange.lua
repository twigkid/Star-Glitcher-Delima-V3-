local Range = {}

function Range.ScanPosition(Parent:Instance, Magnitude: number, Position: Vector3, Blacklisted)
	local Results = {}
	for i, v in pairs(Parent:GetDescendants()) do
		if v:IsA("Humanoid") and not Blacklisted[v] then
			local RootPart = v.RootPart
			if RootPart then
				if (RootPart.Position - Position).Magnitude < Magnitude then
					table.insert(Results, v)
				end
			end
		end
	end
	
	return Results
end

return Range