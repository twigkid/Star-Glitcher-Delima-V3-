local LocalPlayer=game.Players.LocalPlayer or game.Players:FindFirstChildOfClass("Player")
local Character=LocalPlayer.Character
local ws=workspace

local ReplicatedStorage = game:FindFirstChildOfClass("ReplicatedStorage")
local RunService, Debris, TweenService = game:FindFirstChildOfClass("RunService"), game:FindFirstChildOfClass("Debris"), game:FindFirstChildOfClass("TweenService")
local Heartbeat, RenderStepped, Stepped = RunService.Heartbeat, RunService.RenderStepped, RunService.Stepped

local System = ReplicatedStorage.System
local Modules, Effects, Animations = System.Modules, System.Effects, System.Animations

local Misc, Sound, Tweening, Wings = Modules.Misc, Modules.Sound, Modules.Tweening, Modules.Wings
local SoundModule, Configuration, Text, Binary, normalTween = Sound.Sound, Misc.Configuration, Misc.Text, Misc.Binary, require(Tweening.Tween).normalTween
local Particles, Ragdoll = Misc.Particles, Misc.Ragdoll

local Damage = Modules.Damage
local HitRange = Damage.HitRange

local cf, angles, v3, v3z = CFrame.new, CFrame.Angles, Vector3.new, Vector3.zero
local rad, clamp, ceil, floor, rand = math.rad, math.clamp, math.ceil, math.floor, math.random
local ins, sp, tw = Instance.new, task.spawn, task.wait
local prs = pairs
local clk=os.clock
local cs=ColorSequence.new
local ns=NumberSequence.new
local nr=NumberRange.new
local csk, nsk = ColorSequenceKeypoint.new, NumberSequenceKeypoint.new
local c3=Color3.new

local getstate=ins("Humanoid").GetState
local disconnect=RunService.Stepped:Connect(function() end).Disconnect
local getChildren=ws.GetChildren
local getDescendants=ws.GetDescendants
local destroy=ws.Destroy
local connect=ws.Destroying.Connect
local sev=RunService:IsServer()

local style, dir = Enum.EasingStyle, Enum.EasingDirection
local mat=Enum.Material
local ptype=Enum.PartType

local Camera=workspace.CurrentCamera or workspace.Camera
local ScanPosition = require(HitRange).ScanPosition

local Effect = require(System.Modules.Effects.MainEffects).Effect
local Objects = System.Effects.Objects

local attack = {}

local funcs = require(Modules.Misc.MiscFuncs)
local damage,PlayAnimation,CameraShake,NewSoundEffect,GetFloor,config,dWait = funcs.damage, funcs.PlayAnimation , funcs.CameraShake, funcs.NewSoundEffect, funcs.GetFloor, funcs.config, funcs.dWait

function attack.Attack(Parent, ItemTable)
	local BodyTable, JointTable = ItemTable.BodyParts, ItemTable.JointTable
	local LeftArm, RightArm = BodyTable.LeftArm, BodyTable.RightArm
	local LeftLeg, RightLeg = BodyTable.LeftLeg, BodyTable.RightLeg
	local Head, Torso, Humanoid = BodyTable.Head, BodyTable.Torso, BodyTable.Humanoid
	local MainColor1, MainColor2 = ItemTable.Color1, ItemTable.Color2
	local MousePosition = ItemTable.MousePosition
	local RootPart=BodyTable.RootPart
	local Floor=GetFloor(RootPart).Position
	
	local LeftShoulder, RightShoulder, LeftHip, RightHip, Neck, RootJoint = JointTable[1], JointTable[2], JointTable[3], JointTable[4], JointTable[5], JointTable[6]
	
	return true
end

return attack