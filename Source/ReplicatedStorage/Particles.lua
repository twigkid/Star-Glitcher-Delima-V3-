local cs, prs = ColorSequence.new, pairs
local particles = {}

function particles.SetAllParticles(Parent: Instance, Value: boolean)
	for i, v in prs(Parent:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v.Enabled=Value
		end
		if v:IsA("Trail") then
			v.Enabled=Value
		end
		if v:IsA("PointLight") then
			v.Enabled=Value
		end
	end
end

function particles.ColorAllParticles(Parent: Instance, Value: ColorSequence)
	for i, v in prs(Parent:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v.Color = Value
		end
		if v:IsA("Trail") then
			v.Color=Value
		end
		if v:IsA("PointLight") then
			v.Color = Color3.new(Value)
		end
	end
end

return particles