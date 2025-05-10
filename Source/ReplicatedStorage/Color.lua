local Color = {}

function Color.CheckCS(Color)
	if typeof(Color) == "Color3" then
		return ColorSequence.new(Color)
	elseif typeof(Color) == "ColorSequence" then
		return Color
	end
end

return Color