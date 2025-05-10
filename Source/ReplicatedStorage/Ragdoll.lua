local cf, angles, clamp = CFrame.new, CFrame.Angles, math.clamp
local v3, sp, tw, prs = Vector3.new, task.spawn, task.wait, pairs
local ins = Instance.new
local ragdoll = {}


function ragdoll.Ragdoll(Rig: Model)
	for _, x in prs(Rig:GetDescendants()) do
		if x:IsA("Motor6D") and x.Parent.Name ~= "Handle" then
			local Root = x.Part0
			local Attachment0, Attachment1 = ins("Attachment", x.Part0), ins("Attachment", x.Part1)
			Attachment0.CFrame = x.C0 Attachment1.CFrame = x.C1

			local Collision = ins("Part", Rig)
			Collision.Size = v3(0.25, 0.25, 0.25)
			Collision.Transparency = 1

			local Weld = ins("Weld", Collision)
			Weld.Part0 = Collision
			Weld.Part1 = x.Part1

			local Socket = ins("BallSocketConstraint", x.Part0)
			Socket.Attachment0 = Attachment0 Socket.Attachment1 = Attachment1

			Socket.LimitsEnabled = true

			Socket.TwistLimitsEnabled = true
			Socket.TwistUpperAngle = 45 Socket.TwistLowerAngle = -45

			Root.CanCollide = false Root.CanTouch = false Root.CanQuery = false
			Root.Massless = true

			if Root.Name == "HumanoidRootPart" then
				Root:Destroy()
			end

			x:Destroy() x = nil
		end
	end
end

return ragdoll