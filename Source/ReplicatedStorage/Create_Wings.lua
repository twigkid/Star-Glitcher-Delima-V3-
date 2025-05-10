local ReplicatedStorage = game.ReplicatedStorage
local ffc, ffcoc, wfc = workspace.FindFirstChild, workspace.FindFirstChildOfClass, workspace.WaitForChild
local ins, cf, angles, rad, clamp = Instance.new, CFrame.new, CFrame.Angles, math.rad, math.clamp
local inse = table.insert
local v3 = Vector3.new
local isa=workspace.IsA
local cf0=cf(0,0,0)
local Tween = require(ReplicatedStorage.System.Modules.Tweening.Tween)
local sp=task.spawn
local tw=task.wait
local style, dir=Enum.EasingStyle,Enum.EasingDirection

local CFAACG = function(x,y,z) return CFrame.Angles(math.rad(x),math.rad(y),math.rad(z)) end
local Create = {}

function SetAllParticles(Wing, Value: boolean)
	for i,v in pairs(Wing:GetDescendants()) do
		if v:IsA("Trail") then
			v.Enabled=Value
		end
		if v:IsA("ParticleEmitter") then
			v.Enabled=Value
		end
		if v:IsA("Light") then
			v.Enabled=Value
		end
		if v:IsA("BasePart") then
			v.Transparency=1
		end
	end
end

function CreateMotor6D(Part0, Part1, C0, C1, Parent)
	local Motor6D=ins("Motor6D",Parent)
	Motor6D.C0=C0 Motor6D.C1=C1
	if (Part0:IsA("BasePart") and Part1:IsA("BasePart")) then
		Motor6D.Part0=Part0 Motor6D.Part1=Part1
	else
		print(Part0.Name.." or "..Part1.Name.." isn't a basepart.")
	end
	return Motor6D
end

function Create:CreateWings(WingCount: number, WingModel: Instance, RingModel: Instance, Parent: Instance, AnchorPoint: Instance, RingTable, WeldOrder: number)
	local Left, Right = {}, {}
	local LJoint, RJoint = {}, {}

	local RingSmall = RingModel:Clone()
	local RingLarge = RingModel:Clone()

	local RingSmallWeld = CreateMotor6D(AnchorPoint, RingSmall, cf0, RingTable.SmallCFrame * angles(rad(0), rad(90), rad(0)), AnchorPoint)
	local RingLargeWeld = CreateMotor6D(AnchorPoint, RingLarge, cf0, RingTable.LargeCFrame * angles(rad(0), rad(90), rad(0)), AnchorPoint)
	AnchorPoint.Name = "AnchorPoint"

	RingSmall.Size = RingTable.SmallSize RingLarge.Size = RingTable.LargeSize

	for i=1, WingCount do
		local IsModel = false
		local Model: BasePart = WingModel:Clone()
		local WeldPoint = Model

		IsModel=isa(Model, "Model")
		if IsModel then
			WeldPoint = Model.PrimaryPart
		end

		local Obj={Weld=nil, Anchor=nil}
		if WeldOrder == 0 then
			Obj.Weld = AnchorPoint
			Obj.Anchor = WeldPoint
		else
			Obj.Weld = WeldPoint
			Obj.Anchor = AnchorPoint
		end

		local Weld = CreateMotor6D(Obj.Anchor, Obj.Weld, cf(0,0,0),cf(0,0,0),AnchorPoint)

		if not IsModel then
			local Size = Model.Size

			local mul=0.5 + i / 2
			Model.Size = v3(Size.X, Size.Y+mul, Size.Z)
		else
			local Wing = ffc(Model, "Wing", true)
		end

		Model.Parent = Parent

		inse(Left, {Model, Weld, i})
		inse(LJoint, Weld)
	end

	for i=1, WingCount do
		local IsModel = false
		local Model: BasePart = WingModel:Clone()
		local WeldPoint = Model

		IsModel=isa(Model, "Model")
		if IsModel then
			WeldPoint = Model.PrimaryPart
		end

		local Obj={Weld=nil, Anchor=nil}
		if WeldOrder == 0 then
			Obj.Weld = AnchorPoint
			Obj.Anchor = WeldPoint
		else
			Obj.Weld = WeldPoint
			Obj.Anchor = AnchorPoint
		end

		local Weld = CreateMotor6D(Obj.Anchor, Obj.Weld, cf(0,0,0),cf(0,0,0),AnchorPoint)

		if not IsModel then
			local Size = Model.Size

			local mul=0.5 + i / 2
			Model.Size = v3(Size.X, Size.Y+mul, Size.Z+mul/6)
		else
			local Wing = ffc(Model, "Wing", true)
		end

		Model.Parent = Parent

		inse(Right, {Model, Weld, i})
		inse(RJoint, Weld)
	end

	RingLarge.Parent = Parent
	RingSmall.Parent = Parent

	return {L=Left,
		R=Right,
		LJ=LJoint,
		RJ=RJoint,

		Rings = 
			{
				Small = RingSmall, 
				Large = RingLarge, 
				Welds = {Small = RingSmallWeld, Large = RingLargeWeld}};
	}
end

function Create:DestroyWings(Wings)
	if Wings then
		for _, v in pairs(Wings.L) do
			v[1]:Destroy()
			v[2]:Destroy()

		end
		for _, v in pairs(Wings.R) do
			v[1]:Destroy()
			v[2]:Destroy()

		end

		Wings.Rings.Small:Destroy()
		Wings.Rings.Large:Destroy()

		table.clear(Wings)
	end
end

function Create.SetWingCount(Wings, LeftCount, RightCount, LeftEnabled, RightEnabled)
	local Left, Right = Wings.L, Wings.R
	for i, v in pairs(Left) do
		if i > LeftCount or not RightEnabled then
			local Wing=v[1]
			SetAllParticles(Wing, false)
			if Wing:IsA("BasePart") then
				Wing.Transparency=1
				for _,x in pairs(Wing:GetDescendants()) do
					if x:IsA("Trail") or x:IsA("ParticleEmitter") or x:IsA("Light") or x:IsA("Beam") then
						x.Enabled = false
					end
				end
			end
		end
	end
	for i, v in pairs(Right) do
		if i > RightCount or not LeftEnabled then
			local Wing=v[1]
			SetAllParticles(Wing, false)
			if Wing:IsA("BasePart") then
				Wing.Transparency=1
				for _,x in pairs(Wing:GetDescendants()) do
					if x:IsA("Trail") or x:IsA("ParticleEmitter") or x:IsA("Light") or x:IsA("Beam") then
						x.Enabled = false
					end
				end
			end
		end
	end
end

return Create