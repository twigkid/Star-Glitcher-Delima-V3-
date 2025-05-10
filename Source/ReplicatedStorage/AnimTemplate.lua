local Animation = {}
local AnimationComponents = require(game:FindFirstChildOfClass("ReplicatedStorage").System.Modules.AnimationComponents.AnimationComponents)
local cf, angles, rad, rand, clamp, cos = CFrame.new, CFrame.Angles, math.rad, math.random, math.clamp, math.cos
local sin = math.sin

local cf_0 = cf(0,0,0)
local cfMul=AnimationComponents.getMetamethodFromErrorStack(cf_0,function(a,b) return a*b end,function(f) return angles(1,2,3)*angles(1,2,3)==f(angles(1,2,3),angles(1,2,3)) end)
local Inverse=cf_0.Inverse
local Lerp=cf_0.Lerp

function Animation.Animate(JointTable, sine, deltaTime)
	local LeftShoulder, RightShoulder, LeftHip, RightHip, Neck, RootJoint = JointTable[1], JointTable[2], JointTable[3], JointTable[4], JointTable[5], JointTable[6]

end

return Animation