
local rad = math.rad
local random = math.random
local clamp = math.clamp

local Angles = CFrame.Angles
local cf = CFrame.new

local cf0 = cf(0, 0, 0)

local RunService = game:GetService("RunService")
local HapticService = game:GetService("HapticService")
local IsSupported = HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large)

local Camera = workspace.CurrentCamera

local cameraShake = {}

function cameraShake.Shake(Intensity, Duration, AnglesShake, LerpAlpha)
	local start = tick()
	local render_stepped_con
	
	local localIntensity = Intensity
	local lerpedCFrame = cf0
	render_stepped_con = RunService.RenderStepped:Connect(function()
		local current = tick()
		local progress = clamp((current - start) / Duration, 0, 1)
		
		if (current - start) > Duration then
			render_stepped_con:Disconnect()
			render_stepped_con = nil
			
			if IsSupported then
				HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0)
				HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 0)
			end
		else
			localIntensity = Intensity * (1 - progress)
			local localIntensity = localIntensity * 100

			local extraCFrame = cf0
			if AnglesShake then
				extraCFrame = Angles(
					rad(random(-localIntensity, localIntensity) / 100), 
					rad(random(-localIntensity, localIntensity) / 100),
					rad(random(-localIntensity, localIntensity) / 100)
				)
			end
			
			lerpedCFrame = lerpedCFrame:Lerp(cf(
				random(-localIntensity, localIntensity) / 100, 
				random(-localIntensity, localIntensity) / 100, 
				random(-localIntensity, localIntensity) / 100
				) * extraCFrame, 
				LerpAlpha
			)

			Camera.CFrame = Camera.CFrame * lerpedCFrame
			
			if IsSupported then
				local shakePercentage = 1 * (1 - progress)
				HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, shakePercentage)
				HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, shakePercentage)
			end
		end
	end)
end

return cameraShake