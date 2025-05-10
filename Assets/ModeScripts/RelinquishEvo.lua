local cf = CFrame.new
local c3 = Color3.new
local la = CFrame.lookAt
local angles = CFrame.Angles
local rad = math.rad
local rand = math.random
local v3 = Vector3.new
local clamp = math.clamp
local ud2 = UDim2.new
local sp = task.spawn
local tw = task.wait
local ceil = math.ceil

local inse=table.insert
local clk=os.clock
local sin=math.sin

local linear = Enum.EasingStyle.Linear
local in0 = Enum.EasingDirection.In

local ReplicatedStorage = game:FindFirstChildOfClass("ReplicatedStorage")
local HapticService = game:GetService("HapticService")
local System = ReplicatedStorage.System

local RunService = game:FindFirstChildOfClass("RunService")
local renderStepped = RunService.RenderStepped
local heartbeat = RunService.Heartbeat
local stepped = RunService.Stepped

local normalTween = require(System.Modules.Tweening.Tween).normalTween
local debris = game.Debris
local ins = Instance.new
local connect = workspace.Destroying.Connect
local disconnect = workspace.Destroying:Connect(function() end).Disconnect
local once = workspace.Destroying.Once

local cs = ColorSequence.new

local function SetParticles(Part, Color)
	for _, v in pairs(Part:GetDescendants()) do
		if v:IsA("ParticleEmitter") or v:IsA("Trail") then
			v.Color = cs(Color)
		end
	end
end

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

			if (Root.Position - Camera.CFrame.Position).Magnitude < Range then
				local CurrentPower=CurrentPower*10
				HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, clamp(CurrentPower / 10,0, 1))
				HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, clamp(CurrentPower / 10,0, 1))
				Camera.CFrame = Camera.CFrame * cf(rand(-CurrentPower, CurrentPower)/10,rand(-CurrentPower, CurrentPower)/10,rand(-CurrentPower, CurrentPower)/10) * angles(rad(rand(-CurrentPower, CurrentPower)/10),rad(rand(-CurrentPower, CurrentPower)/10),rad(rand(-CurrentPower, CurrentPower)/10))
			end
		else
			HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0)
			HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 0)
			con:Disconnect()
		end
	end)
end

local function config(part: BasePart, value: boolean)
	part.Anchored=not value
	part.CanCollide=value 
	part.CanTouch=value 
	part.CanQuery=value
	part.Massless=value
end

local Effect = require(System.Modules.Effects.MainEffects).Effect
local mode = function(Table)
	local Settings = {
		TakeControlOfUI = false,
		TakeControlOfBillboard = false,
	}
	
	local Sound:Sound, UI = Table.Sound, Table.UI
	local Player = Table.Player
	local Character = Table.Character
	
	local BillboardGui = Table.Billboard
	local TextLabel = BillboardGui:FindFirstChildOfClass("TextLabel")
	
	local Wings = Table.Wings
	local Vars = Table.Vars
	
	local Models = Table.Models
	local connections = {}
	
	local UIVars = Vars.UI
	
	UI.subtext.TextColor3 = c3(1,1,1)
	
	-- relinquish evolve vfx
	
	-- defining stuff
	
	local VUI = Vars.UI

	local UI3D = VUI.UI3D
	local GlobalPositionOffset = UI3D.GlobalOffset
	local LeftPositionOffset = UI3D.LeftOffset
	local RightPositionOffset = UI3D.RightOffset
	
	local white = c3(1, 1, 1)
	local cyan = c3(0, 1, 1)
	
	local s1Speed = cf(0,0,3)
	local s2Speed = cf(0,0,2.8)
	local s3Speed = cf(0,0,1.5)
	
	local s1Size = v3(1,1,15)
	local s23Size = v3(.8,.8,.8)
	
	local HumanoidRootPart = Character.Torso
	local HumanoidRootPos = HumanoidRootPart.Position
	
	for i=1, 180 do
		local offset = v3(rand(-5, 5), rand(-5, 5), rand(-5, 5))
		local position = HumanoidRootPos + offset

		Effect("Sphere", {
			Parent = Models,
			Size = s1Size,
			StartCFrame = la(position, HumanoidRootPos), 
			UseMultiplication = true,
			TransparencyMultiplier = 0.01,
			CFrameMultiplier = s1Speed,
			ColorTime = 0.5,
			EndColor = cyan,
			StartColor = cyan,
		})
		
		local offset = v3(rand(-5, 5), rand(-5, 5), rand(-5, 5))
		local initialPosition = HumanoidRootPos + offset
		
		Effect("Sphere", {
			Parent = Models,
			Size = s23Size,
			StartCFrame = la(initialPosition, HumanoidRootPos),
			UseMultiplication = true,
			TransparencyMultiplier = 0.01,
			CFrameMultiplier = s2Speed,
			ColorTime = 0.5,
			EndColor = white,
			StartColor = white,
		})
		
		local offset = v3(rand(-5, 5), rand(-5, 5), rand(-5, 5))
		local initialPosition = HumanoidRootPos + offset

		if (i % 2 == 0) then -- checks if the number is a multiple of two (basically dividing it, so that there will only be half of x)
			Effect("Sphere", {
				Parent = Models,
				Size = s23Size,
				StartCFrame = la(initialPosition, HumanoidRootPos),
				UseMultiplication = true,
				TransparencyMultiplier = 0.01,
				CFrameMultiplier = s3Speed,
				ColorTime = 0.5,
				EndColor = white,
				StartColor = white,
			})
		end
	end
	
	CameraShake(HumanoidRootPart,2048,2,.01,.0001)
	
	sp(function()
		if game.Players.LocalPlayer == Player then
			local WhiteScreen = ins("ScreenGui", Player.PlayerGui)
			WhiteScreen.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
			local Frame = ins("Frame", WhiteScreen)
			Frame.Size = ud2(1, 0, 1, 0)
			Frame.BorderSizePixel = 0
			Frame.BackgroundColor3 = c3(1,1,1)
			normalTween(Frame, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, .3, {BackgroundTransparency = 1})
			debris:AddItem(WhiteScreen, 1)
		end
		
		local SoundEvolve = ins("Sound", Character)
		SoundEvolve.SoundId = "rbxassetid://763717897"
		SoundEvolve.Volume = 1.25
		SoundEvolve.Pitch = 1
		SoundEvolve:Play()
		debris:AddItem(SoundEvolve,5)
		
		tw(.1)
		
		local SoundEvolve = ins("Sound", Character)
		SoundEvolve.SoundId = "rbxassetid://1664711478"
		SoundEvolve.Volume = .8
		SoundEvolve.Pitch = 1
		SoundEvolve:Play()
		debris:AddItem(SoundEvolve,6)

	end)
	
	Effect("Sphere", {
		Parent = Models,
		Size = v3(0, 0, 0),
		StartCFrame = HumanoidRootPart.CFrame, 
		UseMultiplication = true,
		TransparencyMultiplier = 0.01,
		CFrameMultiplier = cf(0, 0, 0),
		ColorTime = 2,
		EndColor = c3(0, 1, 1),
		StartColor = c3(1, 1, 1),
		EndSize = v3(800, 800, 800),
		SizeTime = 3,
		Material = "ForceField"
	})
	
	Effect("Sphere", {
		Parent = Models,
		Size = v3(0, 0, 0),
		StartCFrame = HumanoidRootPart.CFrame, 
		UseMultiplication = true,
		TransparencyMultiplier = 0.01,
		CFrameMultiplier = cf(0, 0, 0),
		ColorTime = 3,
		EndColor = c3(1, 1, 1),
		StartColor = c3(0, 1, 1),
		EndSize = v3(512, 512, 512),
		SizeTime = 3,
		Material = "ForceField"
	})
	
	Effect("Sphere", {
		Parent = Models,
		Size = v3(0, 0, 0),
		StartCFrame = HumanoidRootPart.CFrame, 
		UseMultiplication = true,
		TransparencyMultiplier = 0.01,
		CFrameMultiplier = cf(0, 0, 0),
		ColorTime = 2,
		EndColor = c3(0, 1, 1),
		StartColor = c3(0, 1, 1),
		EndSize = v3(1024, 1024, 1024),
		SizeTime = 3,
		Material = "ForceField"
	})
	
	-- evolved: phase two
	
	sp(function()
		if Player == game.Players.LocalPlayer then -- You can only see this.
			local UI = Player.PlayerGui["UI"]
			UI.subtext.Text = "[ EVOLVED ]"
			UI.subshadow.Text = "[ EVOLVED ]"
			UI.modetext.Text = "[ RELINQUISH ]"
			UI.mainshadow.Text = "[ RELINQUISH ]"
			
			tw()
			
			local EvolvedGUI = System.Models.Phase:Clone()
			local Splitter = EvolvedGUI.Splitter
			local MainGlow, SubGlow = EvolvedGUI.MainGlow, EvolvedGUI.SubGlow
			local ModeLabel, SubLabel = EvolvedGUI.ModeLabel, EvolvedGUI.PhaseLabel
			
			EvolvedGUI.Parent = Player.PlayerGui
			
			ModeLabel.Position = ud2(0.31, 0,0.25, 0)
			SubLabel.Position = ud2(0.31, 0,0.75, 0)
			
			MainGlow.Position = ud2(0.31, 0,0.25, 0)
			SubGlow.Position = ud2(0.31, 0,0.75, 0)
			
			ModeLabel.TextTransparency = 1
			SubLabel.TextTransparency = 1
			
			MainGlow.ImageTransparency = 1
			SubGlow.ImageTransparency = 1
			
			Splitter.BackgroundTransparency = 1
			
			normalTween(ModeLabel, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, .7, {Position = ud2(0.31, 0,0.412, 0), TextTransparency = 0})
			normalTween(MainGlow, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, .7, {Position = ud2(0.219, 0,0.364, 0), ImageTransparency = .3})

			normalTween(SubLabel, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, .7, {Position = ud2(0.311, 0,0.57, 0), TextTransparency = 0})
			normalTween(SubGlow, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, .7, {Position = ud2(0.266, 0,0.477, 0), ImageTransparency = .3})

			normalTween(Splitter, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, .7, {BackgroundTransparency = 0})
			
			local SoundEvolve = ins("Sound", workspace)
			SoundEvolve.SoundId = "rbxassetid://9116427328"
			SoundEvolve.Volume = 1.25
			SoundEvolve.Pitch = 1
			SoundEvolve:Play()
			debris:AddItem(SoundEvolve,5)
			
			tw(2.5)
			
			normalTween(ModeLabel, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, .7, {Position = ud2(0.31, 0,0.25, 0), TextTransparency = 1})
			normalTween(MainGlow, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, .7, {Position = ud2(0.31, 0,0.25, 0), ImageTransparency = 1})
			
			normalTween(SubLabel, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, .7, {Position = ud2(0.31, 0,0.75, 0), TextTransparency = 1})
			normalTween(SubGlow, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, .7, {Position = ud2(0.31, 0,0.75, 0), ImageTransparency = 1})
			
			normalTween(Splitter, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, .7, {BackgroundTransparency = 1})

		end
	end)
	
	task.spawn(function()
		local con
		con = connect(Sound.DidLoop, function()
			Sound.SoundId = "rbxassetid://18365232159"
			Sound.TimePosition = 23.7
			Sound.Volume = 1.2

			disconnect(con)
			con = nil
		end)

		GlobalPositionOffset.Value = cf(0, -5, 0)
		normalTween(GlobalPositionOffset, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut, 1, {Value = cf(0, 0, 0)})

		tw(1)

		inse(connections, connect(renderStepped, function(deltaTime)
			local sine = clk()
			GlobalPositionOffset.Value = cf(0, 0 + .23 * sin(sine*2), 0) * angles(0, 0, rad(0))
			LeftPositionOffset.Value = angles(0, 0, rad(0 + 4 * sin((sine+6)*2)))
			RightPositionOffset.Value = angles(0, 0, rad(0 - 4 * sin((sine+6)*2)))
		end))

		inse(connections, con)
	end)
	
	if Player == game.Players.LocalPlayer then
		table.insert(_G.localConnections, connections)
	end

	return Settings, connections
end

return mode