local TweenService = game:GetService("TweenService")
local Tweens = {}
local sp = task.spawn
local ti = TweenInfo.new

function Tweens.normalTween(Object: Instance, Style: Enum.EasingStyle, Direction: Enum.EasingDirection, Time: number, PropertyTable, Request: boolean)
	local Tweeninf = ti(Time, Style, Direction, 0, false, 0)
	local Tween = TweenService:Create(Object, Tweeninf, PropertyTable)
	
	sp(function()
		Tween:Play()

		Tween.Completed:Once(function()
			Tween:Destroy()
			Tween=nil

			Tweeninf=nil
		end)
	end)
	
	if Request then
		return Tween
	end
end

return Tweens