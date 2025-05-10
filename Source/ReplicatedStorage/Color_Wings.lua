local Color = {}
local cs=ColorSequence.new
local rep=game.ReplicatedStorage.System.Models

function Color.ColorWing(Wing: BasePart, Color: Color3, ParticleColor: Color3, LightColor: Color3, Color2: Color3)
	local MWing = Wing[1]
	
	if MWing.ClassName == "Model" then
		if MWing ~= rep.Wing then
			for _, v in pairs(MWing:GetChildren()) do
				if v:IsA("BasePart") then
					local UseColor2 = v:FindFirstChild("UseColor2")
					if UseColor2 and UseColor2:IsA("BoolValue") then UseColor2 = UseColor2.Value else UseColor2 = false end
					if Color2 and UseColor2 == true then
						v.Color = Color2
					elseif v.Color ~= Color3.new(0,0,0) then
						v.Color = Color
					else
						if Color2 then
							v.Color = Color2
						else
							v.Color = Color3.new(0,0,0)
						end
					end
				end
			end
		else
			MWing.Wing.Color = Color
		end
	else
		MWing.Color = Color		
	end

	for i,v in pairs(Wing[1]:GetDescendants()) do
		if v:IsA("Trail") or v:IsA("Beam") then
			v.Color = cs(Color)
			if Color == Color3.new(0,0,0) then
				v.LightEmission=0
			end
		end
		if v:IsA("ParticleEmitter") then
			v.Color = cs(ParticleColor)
		end
		if v:IsA("Light") then
			v.Color = LightColor
		end
	end
end

return Color

