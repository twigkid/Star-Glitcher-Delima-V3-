local ts=game:FindFirstChildOfClass("TweenService")
local tf=TweenInfo.new
local tween = {}

function tween.normalTween(Object: Instance, Style: Enum.EasingStyle, Direction: Enum.EasingDirection, Time:number, PropertyTable, ret)
	local nt = ts:Create(Object, tf(Time, Style, Direction, 0, false, 0), PropertyTable)

	nt:Play() 
	nt.Completed:Once(function()
		nt:Destroy() nt=nil
	end)
	
	if ret then
		return nt
	end
end

return tween