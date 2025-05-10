local atk = {}

local LocalPlayer=game.Players.LocalPlayer or game.Players:FindFirstChildOfClass("Player")
local Character=LocalPlayer.Character
local ws=workspace
local Camera=workspace.CurrentCamera or workspace.Camera

local ReplicatedStorage = game:FindFirstChildOfClass("ReplicatedStorage")
local RunService, Debris, TweenService = game:FindFirstChildOfClass("RunService"), game:FindFirstChildOfClass("Debris"), game:FindFirstChildOfClass("TweenService")
local Heartbeat, RenderStepped, Stepped = RunService.Heartbeat, RunService.RenderStepped, RunService.Stepped

local System = ReplicatedStorage.System
local Modules, Effects, Animations = System.Modules, System.Effects, System.Animations

local Misc, Sound, Tweening, Wings = Modules.Misc, Modules.Sound, Modules.Tweening, Modules.Wings
local SoundModule, Configuration, Text, Binary, normalTween = Sound.Sound, Misc.Configuration, Misc.Text, Misc.Binary, require(Tweening.Tween).normalTween
local Particles, Ragdoll = Misc.Particles, Misc.Ragdoll

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

local wfc=ws.WaitForChild
local ffc=ws.FindFirstChild
local ffcoc=ws.FindFirstChildOfClass

local getstate=ins("Humanoid").GetState
local disconnect=RunService.Stepped:Connect(function() end).Disconnect
local getChildren=ws.GetChildren
local getDescendants=ws.GetDescendants
local destroy=ws.Destroy
local connect=ws.Destroying.Connect
local sev=RunService:IsServer()

function atk.damage(blacklisted, position, range, hdamage, show_hitbox, death_color)
	if sev then
		local killed = 0
		for _, v in pairs(game.Players:GetChildren()) do
			local Character = v.Character
			if Character then
				local Humanoid = Character:FindFirstChildOfClass("Humanoid")
				local RootPart=Humanoid.RootPart
				if RootPart ~= blacklisted then
					if (RootPart.Position - position).Magnitude < range then
						Humanoid.Health = Humanoid.Health - hdamage

						if Humanoid.Health <= 0 then
							killed = killed + 1
						end
					end
				end
				Humanoid=nil
				RootPart=nil
			end
			Character=nil
		end
		
		local damaged = {}
		local hits = workspace:GetPartBoundsInRadius(position,range,OverlapParams.new())
		for _,v in pairs(hits) do
			v = v.Parent
			if v:FindFirstChildOfClass("Humanoid") and v.Humanoid.Health > 0 and not table.find(damaged,v) and not game.Players:FindFirstChild(v.Name) and not v:FindFirstChild("DontDamage") then
				local Humanoid = v:FindFirstChildOfClass("Humanoid")
				Humanoid.Health = Humanoid.Health - hdamage

				if Humanoid.Health <= 0 then
					killed = killed + 1
				end
				table.insert(damaged,v)
			end
		end

		return killed
	elseif show_hitbox == true then
		local hitbox = ins("Part")
		hitbox.Shape = Enum.PartType.Ball
		hitbox.BrickColor = BrickColor.new("Really red")
		hitbox.Material = Enum.Material.ForceField
		hitbox.Size = v3(range,range,range)
		hitbox.CFrame = cf(position)
		atk.config(hitbox,false)
		hitbox.Parent = workspace.ActiveVFX
		normalTween(hitbox,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,1,{Transparency = 1})
		Debris:AddItem(hitbox,1)
		hitbox = nil
	end
end

function atk.PlayAnimation(jointTable, Module, delta, frames, yeild)
	local func=require(Module).Animate

	if not yeild then
		task.spawn(function()
			local cframes=0
			while true do
				local deltav=0
				if not sev then
					deltav= RunService.RenderStepped:Wait()
				else
					deltav= RunService.Heartbeat:Wait()
				end

				local sine=clk()
				cframes=cframes+(60*deltav)

				func(jointTable, sine, delta+deltav)

				if cframes > frames then
					break
				end
			end
		end)
	else
		local cframes=0
		while true do
			local deltav=0
			if not sev then
				deltav= RunService.RenderStepped:Wait()
			else
				deltav= RunService.Heartbeat:Wait()
			end

			local sine=clk()
			cframes=cframes+(60*deltav)

			func(jointTable, sine, delta)

			if cframes > frames then
				break
			end
		end
	end
end

function atk.CameraShake(Root,Range, Intensity, DecreaseValue, SpeedDecrease)
	if not sev then
		local con
		local CurrentPower=Intensity
		local CurrentSpeed=DecreaseValue
		con = connect(RenderStepped,function(deltaTime)
			if CurrentPower > 0 then
				if CurrentPower < DecreaseValue * 10 and CurrentSpeed > 0 then
					CurrentSpeed=CurrentSpeed-SpeedDecrease
				end

				CurrentPower=CurrentPower-CurrentSpeed

				if (Root.Position - Camera.CFrame.p).Magnitude < Range then
					local CurrentPower=CurrentPower*(Range - (Root.Position - Camera.CFrame.p).Magnitude)/Range*10
					Camera.CFrame = Camera.CFrame * cf(rand(-CurrentPower, CurrentPower)/10,rand(-CurrentPower, CurrentPower)/10,rand(-CurrentPower, CurrentPower)/10) * angles(rad(rand(-CurrentPower, CurrentPower)/10),rad(rand(-CurrentPower, CurrentPower)/10),rad(rand(-CurrentPower, CurrentPower)/10))
				end
			else
				con:Disconnect()
			end
		end)
	end
end

function atk.NewSoundEffect(SoundID: number, Volume: number, Pitch: number, DestroyOnFinish: boolean, Parent: Instance, StartPos: number)
	local Sound = Instance.new("Sound")
	Sound.SoundId = "rbxassetid://"..SoundID
	Sound.Volume = Volume
	Sound.PlaybackSpeed = Pitch
	Sound.Parent = Parent
	Sound.TimePosition = StartPos or 0
	Sound:Play()
	
	Sound.Ended:Once(function()
		Sound:Destroy()
		Sound = nil
	end)

	return Sound
end

function atk.GetFloor(Target: BasePart)
	local rc=ws:Raycast(Target.Position, Target.CFrame.UpVector*-100, RaycastParams.new())
	if rc then
		return rc
	else
		return Target
	end
end

function atk.config(part: BasePart, value: boolean)
	part.Anchored=not value part.CanCollide=value part.CanTouch=value part.CanQuery=value part.Massless=not value
end

function atk.dWait(waitTime: number) --basically just task.wait() but in heartbeats instead of seconds
	if not waitTime then waitTime = 1 end
	
	local i = 0
	repeat
		tw()
		local deltav=0
		if not sev then
			deltav = RunService.RenderStepped:Wait()
		else
			deltav = RunService.Heartbeat:Wait()
		end
		i += 60*deltav
	until i >= waitTime
end

return atk