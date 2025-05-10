local cf=CFrame.new
local angles = CFrame.Angles
local rad = math.rad
local rand = math.random
local v3 = Vector3.new
local clamp = math.clamp
local ud2 = UDim2.new
local sp = task.spawn
local tw = task.wait
local ceil = math.ceil

local c3 = Color3.new

local inse=table.insert
local clk=os.clock
local sin=math.sin

local linear = Enum.EasingStyle.Linear
local in0 = Enum.EasingDirection.In

local ReplicatedStorage = game:FindFirstChildOfClass("ReplicatedStorage")
local System = ReplicatedStorage.System

local RunService = game:FindFirstChildOfClass("RunService")
local renderStepped = RunService.RenderStepped
local heartbeat = RunService.Heartbeat
local stepped = RunService.Stepped

local normalTween = require(System.Modules.Tweening.Tween).normalTween

local connect = workspace.Destroying.Connect
local disconnect = workspace.Destroying:Connect(function() end).Disconnect
local once = workspace.Destroying.Once

local cs = ColorSequence.new
local ins = Instance.new
local lookat = CFrame.lookAt

local debris = game.Debris

local function SetParticles(Part, Color)
	for _, v in pairs(Part:GetDescendants()) do
		if v:IsA("ParticleEmitter") or v:IsA("Trail") then
			v.Color = cs(Color)
		end
	end
end

local function config(part: BasePart, value: boolean)
	part.Anchored=not value
	part.CanCollide=value 
	part.CanTouch=value 
	part.CanQuery=value
	part.Massless=value
end

local Effect = require(System.Modules.Effects.MainEffects).Effect
local function CameraShake(Root,Range, Intensity, DecreaseValue, SpeedDecrease)
	local con
	local Camera = workspace.CurrentCamera
	local CurrentPower=Intensity
	local CurrentSpeed=DecreaseValue
	local Root=Root
	con = connect(renderStepped,function(deltaTime)
		if CurrentPower > 0 then
			if CurrentPower < DecreaseValue * 10 and CurrentSpeed > 0 then
				CurrentSpeed=CurrentSpeed-SpeedDecrease
			end

			CurrentPower=CurrentPower-CurrentSpeed

			if (Root.Position - Camera.CFrame.p).Magnitude < Range then
				local CurrentPower=CurrentPower*10
				Camera.CFrame = Camera.CFrame * cf(rand(-CurrentPower, CurrentPower)/10,rand(-CurrentPower, CurrentPower)/10,rand(-CurrentPower, CurrentPower)/10) * angles(rad(rand(-CurrentPower, CurrentPower)/10),rad(rand(-CurrentPower, CurrentPower)/10),rad(rand(-CurrentPower, CurrentPower)/10))
			end
		else
			con:Disconnect()
		end
	end)
end

local mode = function(Table)
	local Settings = {
		TakeControlOfUI = false,
		TakeControlOfBillboard = false,
	}
	
	local Sound, UI = Table.Sound, Table.UI
	local Player = Table.Player
	local Character = Table.Character
	
	local BillboardGui = Table.Billboard
	local TextLabel = BillboardGui:FindFirstChildOfClass("TextLabel")
	
	local Wings = Table.Wings
	local Vars = Table.Vars
	
	local Models = Table.Models
	local connections = {}
	
	local UIVars = Vars.UI

	local speed = 0
	
	local VUI = Vars.UI
	
	local HumanoidRootPart = Character.Torso
	local UI3D = VUI.UI3D
	local GlobalPositionOffset = UI3D.GlobalOffset
	local LeftPositionOffset = UI3D.LeftOffset
	local RightPositionOffset = UI3D.RightOffset

	local Camera = workspace.CurrentCamera

	normalTween(GlobalPositionOffset, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut, 1, {Value = cf(0, -5, 0)})

	local hum = Character:FindFirstChildOfClass("Humanoid")
	local rootj = hum.RootPart:FindFirstChildOfClass("Motor6D")
	inse(connections, connect(renderStepped, function()
		local sine = clk()

		speed = speed + .003
		
		local HPos = HumanoidRootPart.Position
		local n = 50 + speed * 4
		local offset = v3(rand(-n, n), rand(-n, n), rand(-n, n))
		local initialPosition = HPos + offset

		Effect("Sphere", {
			Parent = Models,
			Size = v3(0.6, 0.6, 5),
			StartCFrame = lookat(initialPosition, HPos),
			UseMultiplication = true,
			TransparencyMultiplier = 0.03 + speed / 50,
			CFrameMultiplier = cf(0, 0, -0.8 - speed),
			ColorTime = 0.5 + speed,
			EndColor = c3(1, 1, 1),
			StartColor = c3(0, 1, 1),
		})
		
		local offset = v3(rand(-n, n), rand(-n, n), rand(-n, n))
		local initialPosition = HPos + offset
		Effect("Sphere", {
			Parent = Models,
			Size = v3(.6, .6, .6),
			StartCFrame = lookat(initialPosition, HPos),
			UseMultiplication = true,
			TransparencyMultiplier = 0.03 + speed / 50,
			CFrameMultiplier = cf(0, 0, -0.8 - speed),
			ColorTime = 0.5 + speed,
			EndColor = c3(1, 1, 1),
			StartColor = c3(1, 1, 1),
		})

		
		Effect("Sphere", {
			Parent = Models,
			Size = v3(0.6, 0.6, 5  + speed * 20),
			StartCFrame = HumanoidRootPart.CFrame * angles(rad(rand(-360,360)),rad(rand(-360,360)),rad(rand(-360,360))),
			UseMultiplication = true,
			TransparencyMultiplier = 0.03,
			CFrameMultiplier = cf(0, 0, 0),
			ColorTime = 0.5,
			EndColor = c3(1, 1, 1),
			StartColor = c3(0, 1, 1),
			EndSize = v3(.6, .6, 120 + speed * 100),
			SizeTime = .8,
		})
		

	end))
	
	if Player == game.Players.LocalPlayer then
		table.insert(_G.localConnections, connections)
	end
	
	UI.subtext.TextColor3 = c3(1,1,1)
	
	return Settings, connections
end

return mode