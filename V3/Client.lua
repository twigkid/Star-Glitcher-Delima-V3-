-- StarterCharacterScripts > PlayerServer > Scripts

repeat task.wait(1) until game.Loaded
wait(.5)

tw = task.wait
sp = task.spawn

local ffc = workspace.FindFirstChild
local ffcoc = workspace.FindFirstChildOfClass
local wfc = workspace.WaitForChild

local Style = Enum.EasingStyle
local Direction = Enum.EasingDirection

local rad = math.rad
local rand = math.random
local clamp = math.clamp
local ceil = math.ceil
local clk = os.clock
local sine = math.sin

local atan2 = math.atan2
local fromRGB = Color3.fromRGB

local cf = CFrame.new
local v3 = Vector3.new
local angles = CFrame.Angles
local ins = Instance.new
local ud2 = UDim2.new
local KeyCode = Enum.KeyCode
local info = TweenInfo.new
local floor = math.floor
local c3 = Color3.new

local Sine = Style.Sine
local Linear = Style.Linear
local Out = Direction.Out
local In = Direction.In
local InOut = Direction.InOut

local ud2_0 = ud2()
local c31 = c3(1,1,1)
local c30 = c3(0,0,0)
local c3_1 = c3(.1,.1,.1)
local v3_0 = v3()
local cf0 = cf()

local vlerp = v3_0.Lerp
local ud2lerp = ud2_0.Lerp
local lerp = cf0.Lerp

local schar = string.char

repeat tw() until (ffc(script, "Sounds"))

function GetLimb(Character: Model, Name: string)
	local Limb: BasePart = ffc(Character, Name, true)
	return Limb
end

function GetJoint(Limb: BasePart, Name: string)
	local Joint: Motor6D = ffc(Limb, Name, true)
	return Joint
end

function Textsp(txt: string, textobject: Instance, t: number, startst, endst)
	sp(function()
		for i = 1, #txt do
			tw(t or 0.02)
			textobject.Text = startst..sub(txt, 1, i)..endst
		end
	end)
end

function TransformNumber(seconds)
	seconds =  floor(seconds+.5)
	local minutes,extra = 0,""

	if seconds >= 60 then
		repeat
			if seconds >= 60 then
				seconds = seconds - 60
				minutes = minutes + 1
			end
		until seconds < 60
	end
	if seconds < 10 then
		extra = "0"
	end
	return(minutes..":"..extra..seconds)
end

IsA = workspace.IsA
Elastic = Style.Elastic
clone = workspace.Clone
create_t = game.TweenService.Create
destroy = workspace.Destroy
sub = string.sub

Connect = workspace.Destroying.Connect
Once = workspace.Destroying.Once

remove = table.remove
inse = table.insert

tclear = table.clear
play = script.Sounds.select.Play
cs = ColorSequence.new
csk = ColorSequenceKeypoint.new
ns = NumberSequence.new
nsk = NumberSequenceKeypoint.new 

local Player = ffcoc(game, "Players").LocalPlayer
local Mouse = Player:GetMouse()
local Character = Player.Character or Player.CharacterAdded:Wait()

local PlayerGui = Player.PlayerGui
local UI = PlayerGui.UI

local Torso, LeftArm, RightArm, LeftLeg, RightLeg, Head, RootPart = 
	GetLimb(Character, "Torso"), 
	GetLimb(Character, "Left Arm"), 
	GetLimb(Character, "Right Arm"), 
	GetLimb(Character, "Left Leg"), 
	GetLimb(Character, "Right Leg"), 
	GetLimb(Character, "Head"), 
	GetLimb(Character, "HumanoidRootPart")

local ls, rs, lh, rh, nj, rj = 
	GetJoint(Torso, "Left Shoulder"), 
	GetJoint(Torso, "Right Shoulder"), 
	GetJoint(Torso, "Left Hip"), 
	GetJoint(Torso, "Right Hip"), 
	GetJoint(Torso, "Neck"), 
	GetJoint(RootPart, "RootJoint")

local hum = ffcoc(Character, "Humanoid")

local Players = ffcoc(game, "Players")
local RunService = ffcoc(game, "RunService")
local TweenService = ffcoc(game, "TweenService")
local ReplicatedStorage = ffcoc(game, "ReplicatedStorage")
local UserInputService = ffcoc(game, "UserInputService")
local StarterGui = ffcoc(game, "StarterGui")
local Debris = ffcoc(game, "Debris")
local Haptic = ffcoc(game, "HapticService")

local Sounds = script.Sounds
local Remotes = script.Parent.Parent.Remotes
local FireServer = Remotes.ResetLyrics.FireServer
local Camera = workspace.CurrentCamera

local System = ReplicatedStorage.System
local Models = System.Models
local Modules = System.Modules
local Modes = System.Modes
local Skins = System.Skins

local Tween = require(Modules.Tweening.Tween)
local normalTween = Tween.normalTween

local inputBegan = UserInputService.InputBegan
local inputEnded = UserInputService.InputEnded
local inputBeganRem = Remotes.InputBegan
local inputEndedRem = Remotes.InputEnded
local keyDown = Mouse.KeyDown
local keyDownRem = Remotes.KeyDown

local MainD = clone(Models.Main)
local LyricsD = clone(Models.Lyrics)
local Leaderboard = clone(Models.LeaderBoard)

local Heartbeat = RunService.Heartbeat
local RenderStepped = RunService.RenderStepped


local ldt=0

local QualityTables = {
	[1] = {
		Max = 10,
		Min = 6,

		Value = 200,
	};

	[2] = {
		Max = 6,
		Min = 4,

		Value = 140,
	};

	[3] = {
		Max = 4,
		Min = 0,
		Value = 60
	}
}

local Connections={}
local blacklist = {
	KeyCode.Unknown,
	KeyCode.Slash,
	KeyCode.W,
	KeyCode.A,
	KeyCode.D,
	KeyCode.S,
}

dead = false
isOpen = false
WarningEnabled = false
TouchscreenEnabled = UserInputService.TouchEnabled
currentSelected = nil
currentMovementTween = nil

alarm = Sounds.alarm
censor = Sounds.Censor
select_s = Sounds.select
press = Sounds.press
ready = Sounds.Ready

fun = 0
last_f = 0

R1 = 0
G1 = 0
B1 = 0
globalSine = 0 

local function OnFinished(tween:Tween)
	tween.Completed:Once(function()
		tween:Destroy()
		tween = nil
	end)
end


UIStatus = {
	[1] = {
		Name = "GREAT",
		Max = 10001,
		Min = 6999,
	},

	[2] = {
		Name = "OK",
		Max = 7001,
		Min = 4999,
	},

	[3] = {
		Name = "BAD",
		Max = 5001,
		Min = 1999,
	},

	[4] = {
		Name = "WARNING",
		Max = 2001,
		Min = 0,
	}, 
}

local Disconnect = Connect(Heartbeat, function() end).Disconnect

local GetChildren = workspace.GetChildren
local GetDescendants = workspace.GetDescendants

local Storage = wfc(workspace.Storage, Player.Name, 9e9)
local Vars = wfc(Storage, "Vars")

local UI = PlayerGui.UI

local Main = MainD.SurfaceGui.Main
local Top = UI.Top
local Bot = UI.Bot

local ModeText = UI.modetext
local SubText = UI.subtext
local ModeShadow = UI.mainshadow
local SubShadow = UI.subshadow

local Warning = UI.Warning
local Lyrics = LyricsD.SurfaceGui.Lyrics

local VUI = Vars.UI
local Color1 = Vars.Color1
local Color2 = Vars.Color2
local UIColor1 = VUI.UIColor1
local UIColor2 = VUI.UIColor2

local VModeText = Vars.ModeName
local VSubText = Vars.SubText

local Theme = wfc(Torso, "Theme", 9e9)
local Title = wfc(Main, "SongName", 9e9)

local repeatCon = nil
local UISlantedLineSpeedDivider = Vars.UI.UISlantedLineSpeedDivider
local UISlantedLineSpeed = Vars.UI.UISlantedLineSpeed
local UISlantedLineRotation = Vars.UI.UISlantedLineRotation
local LyricsGUI = LyricsD.SurfaceGui
local MainGUI = MainD.SurfaceGui

UI3D = VUI.UI3D
GlobalPositionOffset = UI3D.GlobalOffset
LeftPositionOffset = UI3D.LeftOffset
RightPositionOffset = UI3D.RightOffset

local ArtistName = Vars.ArtistName
local SongTitle = Vars.SongName

local LyricsFolder = Vars.Lyrics
local Holder = Lyrics.Holder
local Cursor = clone(Models.Cursor)

local BillGui = Cursor.CursorBoard
local Outer = BillGui.Outer
local Middle = BillGui.Middle
local Spinner = BillGui.Spinner

local UIOffset = 0
local a = v3_0
local b = v3_0
local LyricsVisible = false
local ShiftLock = false
local clear = false

local spd = 5
local Lifetime = 0
local tim = 0
local am = 0

local SN = false
local TouchUI = PlayerGui.Touch
local SelectorUI = TouchUI.Touchscreen.MainSelector


local CurrentAttacklabels = {}
local CurrentAttacktables = {}

local Pos = cf0

playerVars = wfc(Player, "Vars", 5)

lockcenter = Enum.MouseBehavior.LockCenter
Exponential = Style.Exponential
rot_lerp = v3_0

RemoteBind = script.RemoveLyrics

local function nlerp(start, goal, alpha)
	return start + (goal - start) * alpha
end

local function SlideWarning(Enabled: boolean)
	if Enabled then
		normalTween(Warning, Exponential, Out, 1.5, {Position = ud2(0, 0,0.25, 0)})
		alarm:Play()
		normalTween(alarm, Linear, Out, 1, {Pitch = .6})
	else
		normalTween(Warning, Exponential, Out, 1.5, {Position = ud2(0, 0, -.65, 127)})
		normalTween(alarm, Linear, Out, 1, {Pitch = 0})
		tw(1)
		alarm:Stop()
	end
end

local function ClearLyrics()
	am=0
	
	for _, v in pairs(GetChildren(Holder)) do
		if IsA(v, "TextLabel") then
			destroy(v)
		end
	end

	tim = 10
	RemoteBind:Fire()
	
	
	clear = true
	tw(.1)
	clear = false
end

local function config_ui(UI)
	for _, v in pairs(GetDescendants(UI)) do
		if IsA(v,"Frame") then
			if v.BackgroundColor3 == c30 then
				local val = ins("BoolValue",v)
				val.Name = "SUB"
			end
		end
	end
end

inse(Connections, Connect(UserInputService:GetPropertyChangedSignal("MouseBehavior"), function()
	if UserInputService.MouseBehavior == lockcenter then
		Player.CameraMaxZoomDistance = 2
		Player.CameraMinZoomDistance = 2
		normalTween(Player, Sine, Out, 0.5, {CameraMaxZoomDistance = 200, CameraMinZoomDistance = 21})
		ShiftLock = true
	else
		ShiftLock = false
		Player.CameraMaxZoomDistance = 10000
		Player.CameraMinZoomDistance = 2.5
	end
end))

local function LoadNewCover(ID: string)
	local AlbumCover = Main.AlbumCover

	normalTween(AlbumCover, Sine, InOut, 0.35, {ImageColor3 = c30})
	tw(0.35)

	AlbumCover.Image = ID ~= "0" and "rbxassetid://"..ID or "rbxassetid://8503408498"

	tw(0.35)
	repeat
		tw()
	until AlbumCover.IsLoaded

	normalTween(AlbumCover, Sine, InOut, 0.35, {ImageColor3 = c31})
	AlbumCover = nil

end

local function col_ui(ui, Value, f)
	for _, v in pairs(GetDescendants(ui)) do
		local className = v.ClassName
		if className == "Frame" then
			v.BorderColor3 = Value
			if not ffc(v, "SUB") and not f then
				v.BackgroundColor3 = Value
			end
		elseif className == "TextLabel" or className == "TextButton" then
			v.TextColor3 = Value
			if className == "TextButton" then
				v.BorderColor3 = Value
			end
		elseif className == "ImageLabel" then
			if v.Name ~= "AlbumCover" then
				v.ImageColor3 = Value
			else
				v.BorderColor3 = Value
			end
		elseif className == "ScrollingFrame" then
			if v.ScrollBarThickness ~= 0 then
				v.ScrollBarImageColor3 = Value
			end
		end
	end

end

ui_Elements = {Leaderboard,MainD,LyricsD,Cursor}

config_ui(UI)
config_ui(LyricsD)
config_ui(MainD)
config_ui(Leaderboard)

defaultTouchColor = c3(1, 0, 0)
uiButtons = PlayerGui.UIButtons

uiElements = {UI, LyricsD.Second, MainGUI, Leaderboard, uiButtons, PlayerGui.SkinShop,PlayerGui.Settings}
inse(Connections, Connect(UIColor1.Changed, function(Value: Color3)
	if UIColor1.Value == c30 then
		Value = UIColor2.Value
	end

	for _, element in pairs(uiElements) do
		col_ui(element, Value, element == PlayerGui.SkinShop)
	end

	local shopInfoDividers = {PlayerGui.SkinShop.Info.Divider, PlayerGui.SkinShop.Info.Divider2}
	for _, divider in pairs(shopInfoDividers) do
		divider.BackgroundColor3 = Value
	end

	local uc2 = UIColor2.Value
	LyricsGUI.Lyrics.BorderColor3 = Value
	Spinner.ImageColor3 = Value
	Middle.ImageColor3 = uc2
	Outer.ImageColor3 = Value
	Cursor.CursorTrail.Color = cs(Value)
	Cursor.ParticleEmitter.Color = cs(Value)
	Cursor.PointLight.Color = Value
	
	LyricsD.SurfaceGui.Lyrics.ImageLabel.ImageColor3 = Value
	uiButtons.LV.BorderColor3 = Value
	uiButtons.Currency.BorderColor3 = Value

	if TouchscreenEnabled then
		local FColor1 = Vars.FColor1.Value
		local FColor2 = Vars.FColor2.Value
		
		if (FColor1.R > .6 or FColor1.G > .6 or FColor1.B > .6) then
			Value = FColor1
		elseif (FColor2.R > .6 or FColor2.G > .6 or FColor2.B > .6) then
			Value = FColor2
		end
		
		for _, v in pairs(GetDescendants(TouchUI.Touchscreen)) do
			local className = v.ClassName
			if className == "TextLabel" or className == "TextButton" then
				v.TextColor3 = Value 
				v.BorderColor3 = Value
			elseif className == "Frame" then
				v.BorderColor3 = Value
			end
		end
		
		defaultTouchColor = Value
	end
end))


inse(Connections,Connect(VModeText.Changed,function(Value: string)
	ModeText.Text=Value
	ModeShadow.Text=Value
end))

inse(Connections,Connect(VSubText.Changed,function(Value: string)
	SubText.Text=Value
	SubShadow.Text=Value
end))

inse(Connections,Connect(Vars.UI.Album.Changed,function(Value: string)
	Main.AlbumName.Text = "[ "..Value.." ]"
end))

inse(Connections,Connect(ArtistName.Changed,function(Value: string)
	Main.Artist.Text="[ "..Value.." ]"
end))

inse(Connections,Connect(Remotes.ResetLyrics.OnClientEvent,function()
	ClearLyrics()
	if repeatCon then
		repeatCon:Disconnect()
		repeatCon = nil
	end
	
	censor:Stop()
end))

inse(Connections,Connect(SongTitle.Changed,function(Value: string)
	Title.Text="[ "..Value.." ]"
end))

inse(Connections, Connect(Vars.UI.AlbumCover.Changed, function(Value: string)
	LoadNewCover(Value)
end))

inse(Connections, Connect(Remotes.GetMouse.OnClientEvent, function()
	FireServer(Remotes.GetMouse, Pos)
end))

NoAttacks=LyricsD.Second.Attacks.UIGradient.NoAttacks
inse(Connections, Connect(Remotes.Attacks.OnClientEvent, function(AttackTable)
	for _, label in pairs(CurrentAttacklabels) do
		destroy(label[1])
	end

	tclear(CurrentAttacklabels)
	tclear(CurrentAttacktables)

	CurrentAttacktables = AttackTable
	local Example = LyricsD.Second.Attacks.UIGradient.AttackName
	NoAttacks.Parent = LyricsD.Second.Attacks.UIGradient
	Example.Parent.Parent.ScrollingFrame.CanvasPosition = Vector2.new()

	if #AttackTable > 0 then
		if #AttackTable > 2 then
			LyricsD.CanTouch = true
			LyricsD.CanQuery = true
		end

		for _, attack in pairs(AttackTable) do
			local New = clone(Example)
			New.Parent = Example.Parent.Parent.ScrollingFrame

			New.Text = string.format("[ %s ] [ %s ]", attack.Key:upper(), attack.Name)
			New.TextTransparency = 1

			normalTween(New, Sine, Out, 0.5, {TextTransparency = 0})

			inse(CurrentAttacklabels, {New, attack.Module})
			tw(0.1)
		end
	else
		NoAttacks.TextTransparency = 1
		NoAttacks.Parent = Example.Parent.Parent.ScrollingFrame

		LyricsD.CanTouch = false
		LyricsD.CanQuery = false

		normalTween(NoAttacks, Sine, Out, 0.5, {TextTransparency = 0})
	end

	Example = nil
	tclear(AttackTable)
end))


Tab = SelectorUI.MainTab
Example = SelectorUI.UIGradient.Example
SelectButton = SelectorUI.Select

gamepad1 = Enum.UserInputType.Gamepad1
large_motor = Enum.VibrationMotor.Large
small_motor = Enum.VibrationMotor.Small

local SHold = false
local lead_x = -10
local lead_r = 5

if TouchscreenEnabled then
	local MainTouch = TouchUI.Touchscreen
	local SlideOut = MainTouch.SlideOut
	local HideSlide = MainTouch.TG
	local SlideVisible = true

	HideSlide.BackgroundTransparency = 1
	HideSlide.TextTransparency = 1

	local function hideSlideUI()
		normalTween(SlideOut, Sine, In, .2, {Position = ud2(-1.1,0,0.192,0)})
		normalTween(HideSlide, Sine, In, .2, {BackgroundTransparency = 0, TextTransparency = 0})
		SlideVisible = false
	end

	inse(Connections, Connect(HideSlide.MouseButton1Down, function()
		SlideVisible = not SlideVisible
		
		if SlideVisible then
			normalTween(SlideOut, Sine, Out, .2, {Position = ud2(0.046,0,0.192,0)})
			normalTween(HideSlide, Sine, Out, .2, {BackgroundTransparency = 1, TextTransparency = 1})
		end
	end))
	
	inse(Connections, Connect(SlideOut.TG.MouseButton1Down,function()
		hideSlideUI()
	end))
	
	Cursor.CursorTrail.Enabled = false
	Cursor.CursorBoard.Enabled = false

	local function beginSelection()
		for _, v in pairs(GetChildren(MainTouch)) do
			if v:IsA("TextButton") then
				normalTween(v, Exponential, Out, 1, {BackgroundTransparency = 1, TextTransparency = 1})
			end
		end

		if last_f == 0 then
			SelectButton.Text = "[ Exit ]"
			fun = 0
		else
			SelectButton.Text = "[ Select ]"
			fun = 1
		end


		vibratePhone()
		hideSlideUI()
		
		SelectorUI.Visible = true

		SelectorUI.Size = ud2(1, 0,-0.002, 0)
		SelectorUI.Position = ud2(0, 0,0.548, 0)

		normalTween(SelectorUI, Exponential, Out, .45, {Position = ud2(0, 0,0.238, 0), Size = ud2(1, 0,0.523, 0)})

		for _, v in pairs(GetChildren(SelectorUI)) do
			if IsA(v, "ScrollingFrame") and v.Name ~= "MainTab" then
				v.Visible = false
			end
		end
	end

	inse(Connections, Connect(SlideOut.LC.MouseButton1Down, function()
		SN = not SN
		if SN then
			normalTween(SlideOut.LC, Sine, Out, .3, {TextColor3 = c31, BorderColor3 = c31})
		else
			normalTween(SlideOut.LC, Sine, Out, .3, {TextColor3 = defaultTouchColor, BorderColor3 = defaultTouchColor})
		end
		
		vibratePhone()
		select_s:Play()
		
		Cursor.CursorTrail.Enabled = SN
		Cursor.CursorBoard.Enabled = SN
		
		hideSlideUI()
	end))
	
	inse(Connections, Connect(MainTouch.M1.MouseButton1Down, function()
		Remotes.MouseButton1Down:FireServer()
		vibratePhone()
	end))
	
	inse(Connections, Connect(SlideOut.LB.MouseButton1Down, function()
		lead_x= -5.3
		lead_r = 0
		select_s:Play()
		normalTween(SlideOut.LB, Sine, Out, .3, {TextColor3 = c31, BorderColor3 = c31})
	end))
	
	inse(Connections, Connect(SlideOut.LB.MouseButton1Up, function()
		lead_x = -10
		lead_r = 90
		select_s:Play()
		normalTween(SlideOut.LB, Sine, Out, .3, {TextColor3 = defaultTouchColor, BorderColor3 = defaultTouchColor})
	end))
	
	inse(Connections, Connect(MainTouch.Sprint.MouseButton1Down, function()
		select_s:Play()
		SHold = not SHold
		if SHold then
			FireServer(inputBeganRem, KeyCode.LeftShift)
			normalTween(MainTouch.Sprint, Sine, Out, .3, {TextColor3 = c31, BorderColor3 = c31})
			
			normalTween(hum, Linear, Out, .7, {WalkSpeed = Vars.RunSpeed.Value})
			Vars.Sprint.Value = true
		else
			FireServer(inputEndedRem, KeyCode.LeftShift)
			normalTween(MainTouch.Sprint, Sine, Out, .3, {TextColor3 = defaultTouchColor, BorderColor3 = defaultTouchColor})
			normalTween(hum, Linear, Out, .2, {WalkSpeed = Vars.WalkSpeed.Value})
			if Vars.Sprinttoggle.Value == false then
				Vars.Sprint.Value = false
			end
		
		end
		
		vibratePhone()
	end))
	
	inse(Connections, Connect(SlideOut.SW.MouseButton1Down, beginSelection))

	TouchUI.Enabled = true
else	
	inse(Connections, Connect(Mouse.Button1Down, function()
		Remotes.MouseButton1Down:FireServer()
	end))

	inse(Connections, Connect(Mouse.Button1Up, function()
		Remotes.MouseButton1Up:FireServer()
	end))
end

function vibratePhone()
	sp(function()
		Haptic:SetMotor(gamepad1, large_motor, .4)
		Haptic:SetMotor(gamepad1, small_motor, .4)
		tw(.08)
		Haptic:SetMotor(gamepad1, large_motor, 0)
		Haptic:SetMotor(gamepad1, small_motor, 0)
	end)
end

local camZ = 0
local FOVEnabled = Vars.UI.FOVEnabled
inse(Connections,Connect(RenderStepped,function(dt)
	ldt=ldt+dt
	if ldt >= (1/144) and not isOpen then
		local C0 = rj.C0
		local off = hum.CameraOffset
		local camcf = Camera.CFrame
		local RootVelocity = RootPart.AssemblyLinearVelocity
		local RotVelocity = RootPart.AssemblyAngularVelocity
		local MoveDir = hum.MoveDirection
		local RootMagnitude = (RootVelocity.Magnitude - RootVelocity.Y) - RotVelocity.Y
		local dis = (RootPart.Position - camcf.Position).Magnitude
		local xr = rot_lerp.X

		if not (ShiftLock and TouchscreenEnabled) then
			camZ = nlerp(camZ, RotVelocity.Y, 4 * dt)
		else
			camZ = 0
		end

		if RootVelocity.Y < 0 then
			RootMagnitude = RootVelocity.Magnitude + RootVelocity.Y
		end

		if ShiftLock or SN then
			hum.CameraOffset = vlerp(hum.CameraOffset, v3(
				(C0.X + clamp((dis - 21) / 2, 0, 20)) + clamp(RotVelocity.Y / 2, -1, 1),
				(C0.Y + clamp((dis - 21) / 2, 0, 20)) + RootVelocity.Y / 50,
				C0.Z + clamp(MoveDir.Magnitude, -1, 1)
				), 0.015)
		else
			hum.CameraOffset = vlerp(hum.CameraOffset, v3(
				(C0.X * 2.3) + clamp(RotVelocity.Y / 2, -1, 1),
				(C0.Y) + RootVelocity.Y / 50,
				(C0.Z * 2.3) + clamp(MoveDir.Magnitude, -1, 1)
				), 0.015)
		end

		if SN then
			RootPart.CFrame = cf(RootPart.Position) * angles(0, atan2(-camcf.LookVector.X, -camcf.LookVector.Z), 0)
		end

		if FOVEnabled.Value then
			Tween.normalTween(Camera, Sine, Out, 2, {FieldOfView = 75 + clamp(RootMagnitude * 2, 0, 9)})
		end

		a = vlerp(a, v3(clamp(RootMagnitude, -25, 25), 0, 0), 0.03)

		MoveDir = nil
		RootMagnitude = nil
		RootVelocity = nil
		RotVelocity = nil
		dis = nil
		camcf = nil
		C0 = nil
		off = nil
	end
end))

local function deltaClamp(value)
	return clamp(value, 0, 4)
end

use = Vars.UI.UIShakeEnabled
usi = Vars.UI.UIShakeIntensity

local n = v3_0
local p = v3(-205,0,0)
local lead_lerp = v3_0
local surfaceGUI = Leaderboard.SurfaceGui

inse(Connections, Connect(RenderStepped, function(deltaTime)
	if not isOpen then
		local rootvel = RootPart.AssemblyLinearVelocity
		local mag = rootvel.Magnitude - rootvel.Y
		local loudness = Theme.PlaybackLoudness
		local UIShakeEnabled = use.Value
		local UIShakeIntensity = usi.Value
		local y_rot = RootPart.AssemblyAngularVelocity.Y
		local ax = a.X
		local speed = loudness / 470
		local deltaTime = deltaClamp(deltaTime * 240)
		local camcf = Camera.CFrame

		n = vlerp(n, v3(speed, 0, 0), deltaClamp(deltaTime * 0.1))

		local n = n.X
		local xr = rot_lerp.X
		local pxDelta = deltaClamp(deltaTime * 0.05)
		
		if tim > Lifetime then
			if p.X ~= -205 then
				p = vlerp(p, v3(-205, 0, 0), pxDelta)
			end
		else
			if p.X ~= -25 then
				p = vlerp(p, v3(-25, 0, 0), pxDelta)
			end
		end

		local llx = lead_lerp.X
		if llx < -9 then
			surfaceGUI.Enabled = false
		else
			surfaceGUI.Enabled = true
		end
		
		local halfed = ax / 25
		local commonSine = sine(globalSine * 1.25 + n)
		local GlobalPositionOffset0 = GlobalPositionOffset.Value
		local LeftPositionOffset0 = LeftPositionOffset.Value
		local RightPositionOffset0 = RightPositionOffset.Value
		

		Leaderboard.CFrame = (camcf * GlobalPositionOffset0) * cf(((llx + xr) + halfed) - 0.1 * commonSine, 1.2 + 0.1 * sine((globalSine + 6) * 1.25 + n), -4.7) * angles(rad(lead_lerp.Y + 5 * commonSine), rad(25 + ax - (3.5 * commonSine)), rad(0))
		MainD.CFrame = (camcf * GlobalPositionOffset0 * LeftPositionOffset0) * cf(((-3.63 + UIOffset + xr * 2) - halfed) - 0.1 * commonSine, -1.45 + 0.1 * sine((globalSine + 6) * 1.25 + n), -4.7) * angles(rad(-5 * commonSine), rad(25 + ax + (3.5 * commonSine)), rad(0))
		LyricsD.CFrame = (camcf * GlobalPositionOffset0 * RightPositionOffset0) * cf(((3.63 + (-UIOffset) + xr * 2) + halfed) + 0.1 * commonSine, -1.45 + 0.1 * sine((globalSine + 6) * 1.25 + n), -4.7) * angles(rad(-5 * commonSine), rad(p.X - ax + (3.5 * commonSine)), rad(0))

		normalTween(Spinner, Linear, InOut, 0.05, {Rotation = Spinner.Rotation - spd * clamp(loudness / 35, 1, 1000)})
		normalTween(Outer, Linear, InOut, 0.05, {Rotation = -Spinner.Rotation + spd * clamp(loudness / 35, 1, 1000)})

		if TouchscreenEnabled then
			Pos = cf(camcf.Position + camcf.LookVector * 1200)
			Cursor.CFrame = lerp(Cursor.CFrame, Pos, deltaClamp(deltaTime * 0.3))
		else
			Cursor.CFrame = lerp(Cursor.CFrame, Mouse.Hit, deltaClamp(deltaTime * 0.3))
			Pos = Mouse.Hit
		end

		BillGui.Size = ud2lerp(BillGui.Size, ud2(0, 50 + loudness / 20, 0, 50 + loudness / 20), 0.125)

		lead_lerp = vlerp(lead_lerp, v3(lead_x, lead_r, 0), deltaClamp(deltaTime * 0.09))
		rot_lerp = vlerp(rot_lerp, v3(clamp(y_rot / 17, -0.3, 0.3), 0, 0), deltaClamp(deltaTime * 0.1))
	end
end))

local WalkSpeed, RunSpeed = Vars.WalkSpeed, Vars.RunSpeed
local Sprint = Vars.Sprint

local vis = true

inse(Connections, Connect(UserInputService.InputBegan, function(InputObject:InputObject)
	if InputObject.KeyCode == KeyCode.Tab then
		lead_x= -5.3
		lead_r = 0
	end

	if InputObject.KeyCode == KeyCode.LeftShift then
		if Vars.Sprinttoggle.Value == false then
			currentMovementTween = normalTween(hum, Linear, Out, .7, {WalkSpeed = RunSpeed.Value}, true)
			Sprint.Value = true
		else
			if Sprint.Value == false then
				Sprint.Value = true
				currentMovementTween = normalTween(hum, Linear, Out, .7, {WalkSpeed = RunSpeed.Value}, true)
			else
				Sprint.Value = false
				currentMovementTween = normalTween(hum, Linear, Out, .2, {WalkSpeed = WalkSpeed.Value}, true)
				
			end
		end

	end
end))

inse(Connections, Connect(UserInputService.InputEnded, function(InputObject:InputObject)
	if InputObject.KeyCode == KeyCode.Tab then
		lead_x = -10
		lead_r = 90
	end

	if InputObject.KeyCode == KeyCode.LeftShift and Vars.Sprinttoggle.Value == false then
		currentMovementTween = normalTween(hum, Linear, Out, .2, {WalkSpeed = WalkSpeed.Value}, true)
		Sprint.Value = false
	end
end))

local LyricsType = Vars.Lyrics.LyricsType
local lyricsVal: BoolValue = Vars.Lyrics.LyricsEnabled

LY_Debounce = false
inse(Connections,Connect(LyricsFolder.LyricsEnabled.Changed,function(Value: boolean)
	if not LY_Debounce then
		repeat tw() until not clear
		ClearLyrics() tim=0 
		
		if repeatCon then
			repeatCon:Disconnect()
			repeatCon = nil
		end
		
		tw(.2)

		am = am + 1

		if Value and am == 1 then
			local stop = false
			local deb_2 = tick()
			local rep = false
			
			local function playLyrics()
				if (tick() - deb_2) > 10 or not rep then
					deb_2 = tick()
				else
					return
				end
				
				local CurrentLine
				local function CreateNewLine(Lyric)
					if CurrentLine then
						normalTween(CurrentLine, Sine, Out, .8, {TextColor3 = UIColor1.Value})
						if ffc(CurrentLine, "glow") then
							normalTween(CurrentLine.glow, Sine, Out, .8, {ImageColor3 = UIColor1.Value})
						end
					end


					local NewLine = clone(Lyrics.Holder.UIListLayout.example)
					NewLine.TextColor3 = c31
					NewLine.Parent = Lyrics.Holder
					NewLine.TextTransparency=1
					NewLine.glow.ImageColor3=c30

					NewLine.Text = "[ "..Lyric.Line.." ]"

					normalTween(NewLine, Sine, Out, .85, {TextTransparency = 0})
					normalTween(NewLine.glow, Sine, Out, .85, {ImageColor3 = c31})

					CurrentLine = NewLine

					sp(function()
						LY_Debounce = true
						tw(.1)
						LY_Debounce = false
					end)

					sp(function()
						tw(Lyric.Lifetime)
						normalTween(NewLine, Sine, In, .6, {TextTransparency = 1, TextColor3 = c30})
						if ffc(NewLine, "glow", true) then
							normalTween(NewLine.glow, Sine, Out, .6, {ImageColor3 = c30, ImageTransparency = 1})
						end
						tw(.7)
						destroy(NewLine)
						NewLine=nil
					end)
				end

				local LyricsModule = require(LyricsFolder.LyricsPath.Value)

				for _, i in pairs(LyricsModule) do
					local Data, Lyrics = i.Data, i.Lyrics
					local Start = Data.Start

					local Censors = i.Censors


					sp(function() 
						RemoteBind.Event:Once(function()
							stop = true
						end)

						if stop then
							return
						end

						repeat tw() until Theme.TimePosition >= Start
						for x, b in pairs(Lyrics) do
							if x == 1 then
								Lifetime = ceil(b.Lifetime + 1)
							end

							sp(function()
								local Timestamp = b.Timestamp

								repeat tw(.1) until Theme.TimePosition > Timestamp or stop

								if stop then
									return
								end

								CreateNewLine(b) tim=0
							end)
						end
					end)



					if Censors and typeof(Censors) == "table" and not stop then
						local a, b = pcall(function()
							for _,v in pairs(Censors) do
								local Start = v.Start
								local End = v.End

								repeat tw() until Theme.TimePosition > Start or stop

								if stop then
									break
								end

								tw(.05)

								local prev_color = CurrentLine.TextColor3
								local prev_Loudness = Theme.Volume

								normalTween(CurrentLine, Sine, Out, .1, {TextColor3 = c3(1,0,0)})
								normalTween(CurrentLine.glow, Sine, Out, .1, {ImageColor3 = c3(1,0,0)})

								censor:Play()
								Theme.Volume = .05

								repeat tw() CurrentLine.Rotation = rand(-4, 4) until Theme.TimePosition > End
								CurrentLine.Rotation = 0
								normalTween(CurrentLine, Sine, Out, .1, {TextColor3 = prev_color})
								normalTween(CurrentLine.glow, Sine, Out, .1, {ImageColor3 = prev_color})


								censor:Stop()
								Theme.Volume = prev_Loudness
							end
						end)
					end
				end
			end
			
			playLyrics()
			
			repeatCon = Theme.DidLoop:Connect(function()
				rep = true
				stop = true
				tw(.2)
				stop = false
				playLyrics()
			end)
		end
	end
end))

sp(function()
	while not dead do
		tw(1)
		
		if tim < Lifetime + 1.1 then
			tim=tim+1
		end
	end
end)

inse(Connections, Connect(Vars.Health.Changed, function(Health: number)
	Main.Health.Text = "[ " .. ceil(Health) .. " // " .. ceil(hum.MaxHealth) .. " ]"

	for _, v in pairs(UIStatus) do
		local Min, Max = v.Min, v.Max
		if Health > Min and Health < Max then
			Main.Status.Text = "[ STAT: " .. v.Name .. " ]"
			WarningEnabled = (v.Name == "WARNING")
			SlideWarning(WarningEnabled)
			break
		end
	end
end))


movestart = ud2(-1.5, 0, .155, 0)
anim_start = ud2(1.15, 0, .155, 0)
txt=Warning.txt
sp(function()
	while true do
		tw()
		if WarningEnabled then
			txt.Position = movestart
			normalTween(txt, Linear, In, 8, {Position = anim_start})

			tw(8)
		end
	end
end)

local ldt=0
local current_rot = 0
local bot_1 = Bot.bot
local bot_2 = Top.bot
local sbot_1 = Bot.bot2
local sbot_2 = Top.bot2
local Time = Main.Time

Left = UI.Left
Right = UI.Right

Left_1 = Left.bot
Left_2 = Left.bot2

Right_1 = Right.bot
Right_2 = Right.bot2

local uiGlow = GetChildren(UI.uiglow)

inse(Connections, Connect(Heartbeat, function(deltaTime: number)
	ldt = ldt + deltaTime

	if ldt >= (1 / 144) and not isOpen then
		local Divider = UISlantedLineSpeedDivider.Value
		local Rot = UISlantedLineRotation.Value
		local Speed = UISlantedLineSpeed.Value
		local deltaTime = deltaClamp(deltaTime * 240)

		local UIShakeEnabled = use.Value
		local UIShakeIntensity = usi.Value
		local xr = rot_lerp.X
		local xr5 = xr / 50
		local xr5m = xr * 5
		local additionSine = globalSine + 3

		if not UIShakeEnabled then
			UI.vis.Rotation = (-xr5m * 2) - 180

			ModeText.Position = ud2(0.329 + xr5, 0, 0.03 + 0.01 * sine((globalSine + 4) * 1.5 + n.X), 0)
			ModeShadow.Position = ud2(0.337 + xr5, 0, 0.043 + 0.01 * sine((globalSine + 4) * 1.5 + n.X), 0)
			SubText.Position = ud2(0.329 + xr5, 0, 0.114 + 0.01 * sine((globalSine + 7) * 1.5 + n.X), 0)
			SubShadow.Position = ud2(0.337 + xr5, 0, 0.123 + 0.01 * sine((globalSine + 7) * 1.5 + n.X), 0)

			ModeText.Rotation, ModeShadow.Rotation = xr5m, xr5m
			SubText.Rotation, SubShadow.Rotation = xr5m, xr5m
		else
			UI.vis.Rotation = -180 + rand(-UIShakeIntensity, UIShakeIntensity)

			ModeText.Position = ud2(0.329 + rand(-UIShakeIntensity, UIShakeIntensity) / 200, 0, 0.03 + rand(-UIShakeIntensity, UIShakeIntensity) / 200, 0)
			ModeText.Rotation = rand(-UIShakeIntensity, UIShakeIntensity) * 2
			ModeShadow.Position, ModeShadow.Rotation = ModeText.Position, ModeText.Rotation

			SubText.Position = ud2(0.329 + rand(-UIShakeIntensity, UIShakeIntensity) / 200, 0, 0.114 + rand(-UIShakeIntensity, UIShakeIntensity) / 200, 0)
			SubText.Rotation = rand(-UIShakeIntensity, UIShakeIntensity) * 2
			SubShadow.Position, SubShadow.Rotation = SubText.Position, SubText.Rotation
		end

		current_rot = Rot * sine(globalSine * Speed)
		bot_1.Position = ud2((additionSine / Divider) % 0.5, 0, 0, 0)
		bot_2.Position = ud2((-additionSine / Divider) % 0.5, 0, 0, 0)
		sbot_1.Position = ud2(bot_1.Position.X.Scale - 1, bot_1.Position.X.Offset, bot_1.Position.Y.Scale, bot_1.Position.Y.Offset)
		sbot_2.Position = ud2(Top.bot.Position.X.Scale - 1, Top.bot.Position.X.Offset, Top.bot.Position.Y.Scale, Top.bot.Position.Y.Offset)

		Left_1.Position = ud2((additionSine / Divider) % 0.5, 0, 0, 0)
		Right_1.Position = ud2((-additionSine / Divider) % 0.5, 0, 0, 0)


		Left_2.Position = ud2(Left_1.Position.X.Scale - 1, Left_1.Position.X.Offset, Left_1.Position.Y.Scale, Left_1.Position.Y.Offset)
		Right_2.Position = ud2(Right_1.Position.X.Scale - 1, Right_1.Position.X.Offset, Right_1.Position.Y.Scale, Right_1.Position.Y.Offset)

		if WarningEnabled then
			Warning.bot.Position = ud2((additionSine / Divider) % 0.5, 0, -0.003, 0)
			Warning.top.Position = ud2((-additionSine / Divider) % 0.5, 0, 0.746, 0)

			Warning.bot2.Position = ud2(Warning.bot.Position.X.Scale - 1, Warning.bot.Position.X.Offset, Warning.bot.Position.Y.Scale, Warning.bot.Position.Y.Offset)
			Warning.top2.Position = ud2(Warning.top.Position.X.Scale - 1, Warning.top.Position.X.Offset, Warning.top.Position.Y.Scale, Warning.top.Position.Y.Offset)

			Warning.Rotation = xr5m + (UIShakeEnabled and rand(-1, 1) / 2 or 2 * sine(globalSine * 1.25))
		end

		if dead then
			destroy(UI)
		end

		normalTween(Top, Linear, Out, 0.1, {Rotation = current_rot})
		normalTween(Bot, Linear, Out, 0.1, {Rotation = current_rot})

		ldt = 0
	end

	globalSine = clk()
end))

sp(function()
	while not dead do
		tw(.5)
		if Theme.IsLoaded and Theme.Playing then
			Time.Text = "[ " .. TransformNumber(Theme.TimePosition/Theme.PlaybackSpeed) .. " // " .. TransformNumber(Theme.TimeLength/Theme.PlaybackSpeed) .. " ]"
		end
	end
end)

local start = ud2(0, 0, 0, 127)
local endp = ud2(0, 0, -.65, 127)
local movestart = ud2(-1.5, 0, .155, 0)
local anim_start = ud2(1.15, 0, .155, 0)
local txt = Warning.txt
local Music = GetChildren(UI.vis)

for _, v in ipairs(GetChildren(UI.visTop)) do
	inse(Music, v)
end


sp(function()
	for i, v in ipairs(Music) do
		local mult = Instance.new("NumberValue", v)
		mult.Name = "mt"

		sp(function()
			while tw() do
				if not isOpen then
					local sine = clk()
					local loudness = Theme.PlaybackLoudness

					mult.Value = -0.1 + clamp(loudness / 1000, 0, 0.1) * math.sin((sine * i) * 1.5 + loudness / 500)
				end
			end
		end)
	end
end)

sp(function()
	while tw() do
		if not isOpen then
			for _, v in ipairs(Music) do
				if v:IsA("Frame") then
					local playbackLoudness = Theme.PlaybackLoudness / 452
					if v:FindFirstChild("mt") then
						normalTween(v, Exponential, Out, 0.1, {
							Size = ud2(0.075, 0, v.mt.Value + clamp(playbackLoudness, 0.2, 1), 0)
						})
					end
				end
			end
		end
	end
end)


local function Animate(Button: TextButton, Glow: ImageLabel)
	inse(Connections,Connect(Button.MouseEnter,function()
		play(select_s)
		normalTween(Button, Elastic, Out, .25, {Rotation = - 15, BorderColor3 = c31, TextColor3 = c31})
		normalTween(Glow, Sine, In, .1, {ImageColor3 = c31})
	end))

	inse(Connections,Connect(Button.MouseLeave,function()
		local col=Vars.UI.UIColor1.Value
		normalTween(Button, Sine, Out, .1, {Rotation = 0, BorderColor3 = col, TextColor3 = col})
		normalTween(Glow, Sine, Out, .25, {ImageColor3 = col})
	end))

	inse(Connections,Connect(Button.MouseButton1Down,function()
		Button.Rotation = -360
		play(press)
		vibratePhone()
		normalTween(Button, Sine, Out, .4, {Rotation = 0})
	end))
end

Animate(uiButtons.Skins, uiButtons.sglow)
Animate(uiButtons.Settings, uiButtons.skglow)

inse(Connections, Connect(hum.HealthChanged, function(NewHealth)
	if Vars:FindFirstChild("Health") then
		normalTween(Vars.Health, Exponential, InOut, .2, {Value = NewHealth})
	end
end))

function onDeath()
	Theme:Destroy()

	destroy(MainD) destroy(LyricsD)
	destroy(Cursor)
	destroy(Leaderboard)


	for _,v in pairs(Connections) do
		Disconnect(v)
		v = nil
	end

	if typeof(Connections) == "table" then
		tclear(Connections)
	end

	tw(.1)
	destroy(UI)
end

hum.Died:Once(onDeath)
Player.CharacterAdded:Once(onDeath)

local Icons = {
	{"Computer", 12684119225};
	{"Mobile", 13021320268};
	{"Unknown", 12905962634}
}

local BadgeService = ffcoc(game, "BadgeService")
local BoardFrame=Leaderboard.SurfaceGui.Leaderboard
local PlayerFrame=BoardFrame.UIGradient.Player

local function IsADeveloper(Player: Player)
	local GroupRole = Player:GetRoleInGroup(34348811)
	if GroupRole == "Developer" or GroupRole == "Owner" then
		return true
	else
		return false
	end
end

local function IsAlphaTester(Player: Player)
	local a,b = pcall(function()
		if BadgeService:UserHasBadgeAsync(Player.UserId, 3363166125966653) then
			return true
		end
	end)

	if a and b then
		return true
	else
		return false
	end
end

local function GetPlatform(Player: Player)
	local VarsFolder = Player:WaitForChild("Vars", 3)
	if VarsFolder then
		local Platform = VarsFolder.Platform.Value
		return Platform
	else
		return "Unknown"
	end
end

local function GetVarsFolder(Player: Player)
	local Vars
	local a, b = pcall(function()
		for _,v in pairs(GetChildren(workspace.Storage)) do
			if IsA(v,"Folder") and v.Name == Player.Name then
				Vars = v.Vars
				break
			end
		end
	end)
	
	return Vars
end

local function CreateNewIcon(IconHolder: Frame, ImageID: number)
	local Icon = IconHolder.UIListLayout.Developer:Clone()
	Icon.Image = "rbxassetid://"..ImageID
	Icon.Parent = IconHolder

	return Icon
end

local function AssignIcons(Player: Player, IconHolder: Frame)
	local Developer = IsADeveloper(Player)
	local Alpha = IsAlphaTester(Player)
	local Platform = GetPlatform(Player)

	if Developer then
		CreateNewIcon(IconHolder, 11860859170)
	end

	if Alpha then
		CreateNewIcon(IconHolder, 9172667965)
	end

	for _, v in pairs(Icons) do
		local Name = v[1]

		if Name == Platform then
			CreateNewIcon(IconHolder, v[2])
			break
		end
	end

end
inse(Connections, Connect(Vars.ModeName.Changed, function(Value)
	if Vars.UI.BritishMode.Value == true then
		Vars.ModeName.Value = string.gsub(Value,"T","'")
		task.defer(function()
			task.wait(.2)
			Torso.NameLabel.TextLabel.Text = string.gsub(Value,"T","'")
		end)
	end
end))
local function OnPlayer(Player, Remove)
	if not Remove then	
		local Frame = clone(PlayerFrame)
		Frame.Name = Player.Name
		Frame.Player.Text = "[ "..Player.DisplayName.." ]"
		Frame.Parent=BoardFrame.ScrollingFrame

		local Vars = GetVarsFolder(Player)
		if Vars then
			inse(Connections, Connect(Vars.ModeName.Changed, function(Value)
				if Vars.UI.BritishMode.Value == true then
					Frame.Mode.Text = "[ "..string.gsub(Value,"T","'").." ]"
				else
					Frame.Mode.Text = "[ "..Value.." ]"
				end
			end))
		end

		sp(function()
			tw(1)

			AssignIcons(Player, Frame.IconHolder)
		end)
	else
		for _,v in pairs(GetChildren(BoardFrame.ScrollingFrame)) do
			if IsA(v, "Frame") and v.Name == Player.Name then
				destroy(v)
			end
		end
	end
end

inse(Connections,Connect(keyDown,function(Key: string)
	FireServer(keyDownRem, Key)
end))

inse(Connections,Connect(inputBegan,function(Input: InputObject, proc)
	local KeyCode = Input.KeyCode
	if not proc and not blacklist[KeyCode] then
		FireServer(inputBeganRem, Input.KeyCode)
	end

	KeyCode=nil
end))

inse(Connections,Connect(inputEnded,function(Input: InputObject, proc)
	local KeyCode=Input.KeyCode
	if not proc and not blacklist[KeyCode] then
		FireServer(inputEndedRem, KeyCode)
	end

	KeyCode = nil
end))

local nattacks={}
inse(Connections, Connect(Remotes.Ready.OnClientEvent, function(Module, Value)
	if Value then
		for _, v in pairs(nattacks) do
			local Mod=v.Module
			if Module == Mod then
				ready:Play()
			end
		end
	end
end))

inse(Connections, Connect(Remotes.AttackTable.OnClientEvent, function(Table)
	nattacks=Table
end))

inse(Connections, Connect(RenderStepped, function()
	if WarningEnabled then
		local uiCol=UIColor1.Value
		local SineValue = sine(globalSine*8)
		local colorValue = 1 + .5 * SineValue

		local col2 = c3(
			uiCol.r * colorValue,
			uiCol.g * colorValue,
			uiCol.b * colorValue
		)

		col_ui(UI, col2)
		col_ui(LyricsD.Second, col2)
		col_ui(MainGUI, col2)
		col_ui(Leaderboard, col2)

		local uc2 = UIColor2.Value
		LyricsGUI.Lyrics.BorderColor3 = col2
		Spinner.ImageColor3 = col2
		Outer.ImageColor3 = uc2
	end
end))

UserSettings().GameSettings.Changed:Connect(function(Property)
	if Property == "SavedQualityLevel" then
		local UIQuality
		local SavedQualityLevel = UserSettings().GameSettings.SavedQualityLevel.Value

		for _, v in pairs(QualityTables) do
			if SavedQualityLevel >= v.Min and SavedQualityLevel <= v.Max then
				UIQuality = v.Value
				break
			end
		end

		for _, v in pairs(ui_Elements) do
			for _, b in pairs(GetDescendants(v)) do
				if b:IsA("SurfaceGui") then
					b.PixelsPerStud = UIQuality
				end
			end
		end
	end
end)


-- UI Calibration:

CalibartionConnections = {}

CalibrationWindow = PlayerGui.Calibration
CalibrationMain = CalibrationWindow.Main

DoneButton = CalibrationMain.Finish
SliderCursor = CalibrationMain.Cursor
Bar = CalibrationMain.Bar

DraggingCursor = false
Rot = 0

Icon = SliderCursor.Icon

inse(CalibartionConnections, Connect(Icon.InputBegan, function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then
		DraggingCursor = true 
	end
end))

inse(CalibartionConnections, Connect(Icon.InputEnded, function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1  then
		DraggingCursor = false
	end
end))

inse(CalibartionConnections, Connect(RenderStepped, function()
	if DraggingCursor then
		local sliderPosition = Bar.AbsolutePosition.X 
		local sliderSize = Bar.AbsoluteSize.X 
		local mousePos = UserInputService:GetMouseLocation().X
		local percentage = clamp((mousePos - sliderPosition) / sliderSize, 0, 1) 
		local center = (percentage - 0.5) * 2
		SliderCursor.Position = ud2(percentage, 0, SliderCursor.Position.Y.Scale, 0)

		UIOffset = center * 2

		Rot = Rot + 2
	end

	Icon.Rotation = nlerp(Icon.Rotation, Rot, .1)
end))

Once(DoneButton.MouseButton1Down, function()
	for _, v in pairs(CalibartionConnections) do
		Disconnect(v) v = nil
	end

	CalibrationWindow:Destroy()
end)

for _, v in ipairs(ui_Elements) do
	v.Parent = Camera
end

Theme.Parent = Camera

Warning.Position = ud2(0, 0, -.65, 127)

BillGui.Enabled = true
UI.Enabled = true

UserInputService.MouseIconEnabled = true
UserInputService.MouseIcon = "rbxassetid://9619665977"
Player.CameraMinZoomDistance = 2.5

-- SETTINGS - pap :3 maek this save into datastores so you dont have to redo ur settings every rejoin im bad at datastores
Settings = PlayerGui.Settings

uiButtons.Settings.MouseButton1Down:Connect(function()
	if Settings.Enabled == false then
		Settings.Enabled = true
	else
		Settings.Enabled = false
	end
end)
InterfaceSettings = PlayerGui.Settings.Main.interface
GraphicSettings = PlayerGui.Settings.Main.graphics
AudioSettings = PlayerGui.Settings.Main.audio
GameplaySettings = PlayerGui.Settings.Main.gameplay

Settings.Main.interfacebutton.MouseButton1Click:Connect(function()
	if InterfaceSettings.Visible == false then
		InterfaceSettings.Visible = true
		GraphicSettings.Visible = false
		GameplaySettings.Visible = false
		AudioSettings.Visible = false
	end
end)
Settings.Main.graphicsbutton.MouseButton1Click:Connect(function()
	if GraphicSettings.Visible == false then
		InterfaceSettings.Visible = false
		GraphicSettings.Visible = true
		GameplaySettings.Visible = false
		AudioSettings.Visible = false
	end
end)
Settings.Main.gameplaybutton.MouseButton1Click:Connect(function()
	if GameplaySettings.Visible == false then
		InterfaceSettings.Visible = false
		GraphicSettings.Visible = false
		GameplaySettings.Visible = true
		AudioSettings.Visible = false
	end
end)
Settings.Main.audiobutton.MouseButton1Click:Connect(function()
	if AudioSettings.Visible == false then
		InterfaceSettings.Visible = false
		GraphicSettings.Visible = false
		GameplaySettings.Visible = false
		AudioSettings.Visible = true
	end
end)

-- INTERFACE

-- basically copy pasted callibration code so you can edit after doing it once
OffsetConnectors = {}

OffsetSliderCursor = InterfaceSettings["3duioffset"].Cursor
OffsetBar = InterfaceSettings["3duioffset"].Bar

offDraggingCursor = false
Rot = 0

OffsetIcon = OffsetSliderCursor.Icon

inse(OffsetConnectors, Connect(OffsetIcon.InputBegan, function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then
		offDraggingCursor = true 
	end
end))

inse(OffsetConnectors, Connect(OffsetIcon.InputEnded, function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1  then
		offDraggingCursor = false
	end
end))

inse(OffsetConnectors, Connect(RenderStepped, function()
	if offDraggingCursor then
		local sliderPosition = OffsetBar.AbsolutePosition.X 
		local sliderSize = OffsetBar.AbsoluteSize.X 
		local mousePos = UserInputService:GetMouseLocation().X
		local percentage = clamp((mousePos - sliderPosition) / sliderSize, .05, .9) 
		local center = (percentage - 0.5) *2
		OffsetSliderCursor.Position = ud2(percentage, 0, OffsetSliderCursor.Position.Y.Scale, 0)

		UIOffset = center * 2

		Rot = Rot + 2
	end

	OffsetIcon.Rotation = nlerp(OffsetIcon.Rotation, Rot, .1)
end))
-- SCALEUI
ScaleSliderCursor = InterfaceSettings["3duiscale"].Cursor
ScaleBar = InterfaceSettings["3duiscale"].Bar

scaleDraggingCursor = false
Rot = 0
ScaleConnectors = {}

ScaleIcon = ScaleSliderCursor.Icon

inse(ScaleConnectors, Connect(ScaleIcon.InputBegan, function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then
		scaleDraggingCursor = true 
	end
end))

inse(ScaleConnectors, Connect(ScaleIcon.InputEnded, function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1  then
		scaleDraggingCursor = false
	end
end))

inse(ScaleConnectors, Connect(RenderStepped, function()
	if scaleDraggingCursor then
		local sliderPosition = ScaleBar.AbsolutePosition.X 
		local sliderSize = ScaleBar.AbsoluteSize.X 
		local mousePos = UserInputService:GetMouseLocation().X
		local percentage = clamp((mousePos - sliderPosition) / sliderSize, .05, .9) 
		local center = percentage
		ScaleSliderCursor.Position = ud2(percentage, 0, ScaleSliderCursor.Position.Y.Scale, 0)

		MainD.Size = v3(center*3+(3.132/2),center*2+ (2.197/2),0.168)
		LyricsD.Size = v3(center*3+(3.132/2),center*2+ (2.197/2),0.168)
		
		Rot = Rot + 2
	end

	ScaleIcon.Rotation = nlerp(ScaleIcon.Rotation, Rot, .1)
end))
-- INTERFACE BUTTONS
InterfaceSettings["3duitoggles"].left.MouseButton1Down:Connect(function()
	local button = InterfaceSettings["3duitoggles"].left
	if button.Text == "[ + ]" then
		button.Text = "[ x ]"
		MainGUI.Enabled = false
	else
		button.Text = "[ + ]"
		MainGUI.Enabled = true
	end
end)

InterfaceSettings["3duitoggles"].right.MouseButton1Down:Connect(function()
	local button = InterfaceSettings["3duitoggles"].right
	if button.Text == "[ + ]" then
		button.Text = "[ x ]"
		LyricsGUI.Enabled = false
		LyricsD.Second.Enabled = false

	else
		button.Text = "[ + ]"
		LyricsGUI.Enabled = true
		LyricsD.Second.Enabled = true
	end
end)

InterfaceSettings.uitoggles.visualizertoggle.MouseButton1Down:Connect(function()
	local button = InterfaceSettings.uitoggles.visualizertoggle
	if button.Text == "[ + ]" then
		button.Text = "[ x ]"
		PlayerGui.UI.vis.Visible = false
	else
		button.Text = "[ + ]"
		PlayerGui.UI.vis.Visible = true
	end
end)

InterfaceSettings.uitoggles.glowtoggle.MouseButton1Down:Connect(function()
	local button = InterfaceSettings.uitoggles.glowtoggle
	if button.Text == "[ + ]" then
		button.Text = "[ x ]"
		PlayerGui.UI.topglow.Visible = false
		PlayerGui.UI.botglow.Visible = false
		PlayerGui.UI.sideglow1.Visible = false
		PlayerGui.UI.sideglow2.Visible = false
		for _,v in pairs(PlayerGui.UI.uiglow:GetChildren()) do
			v.Visible = false
		end
	else
		button.Text = "[ + ]"
		PlayerGui.UI.topglow.Visible = true
		PlayerGui.UI.botglow.Visible = true
		PlayerGui.UI.sideglow1.Visible = true
		PlayerGui.UI.sideglow2.Visible = true	
		for _,v in pairs(PlayerGui.UI.uiglow:GetChildren()) do
			v.Visible = true
		end
	end
end)

InterfaceSettings.uitoggles.barstoggle.MouseButton1Down:Connect(function()
	local button = InterfaceSettings.uitoggles.barstoggle
	if button.Text == "[ + ]" then
		button.Text = "[ x ]"
		PlayerGui.UI.Top.Visible = false
		PlayerGui.UI.Bot.Visible = false
		Vars.UI.UIBarsToggle.Value = false
	else
		button.Text = "[ + ]"
		PlayerGui.UI.Top.Visible = true
		PlayerGui.UI.Bot.Visible = true
		Vars.UI.UIBarsToggle.Value = false
	end
end)
InterfaceSettings.uitoggles.nametoggle.MouseButton1Down:Connect(function()
	local button = InterfaceSettings.uitoggles.nametoggle
	if button.Text == "[ + ]" then
		button.Text = "[ x ]"
		PlayerGui.UI.modeglow.Visible = false
		PlayerGui.UI.modetext.Visible = false
		PlayerGui.UI.subtext.Visible = false
		PlayerGui.UI.mainshadow.Visible = false
		PlayerGui.UI.subshadow.Visible = false
		--Vars.UI.UINameToggle.Value = false
	else
		button.Text = "[ + ]"
		PlayerGui.UI.modeglow.Visible = true
		PlayerGui.UI.modetext.Visible = true
		PlayerGui.UI.subtext.Visible = true
		PlayerGui.UI.mainshadow.Visible = true
		PlayerGui.UI.subshadow.Visible = true
		--Vars.UI.UINameToggle.Value = true
	end
end)
InterfaceSettings.uitoggles.cursortoggle.MouseButton1Down:Connect(function()
	local button = InterfaceSettings.uitoggles.cursortoggle
	if button.Text == "[ + ]" then
		button.Text = "[ x ]"
		Cursor.CursorBoard.Enabled = false
	else
		button.Text = "[ + ]"
		Cursor.CursorBoard.Enabled = false
	end
end)

-- GRAPHICS
GraphicSettings.toggles.cursorparttoggle.MouseButton1Down:Connect(function()
	local button = GraphicSettings.toggles.cursorparttoggle
	if button.Text == "[ + ]" then
		button.Text = "[ x ]"
		Cursor.CursorTrail.Enabled = false
		Cursor.ParticleEmitter.Enabled = false
		Cursor.PointLight.Enabled = false
	else
		button.Text = "[ + ]"
		Cursor.CursorTrail.Enabled = false
		Cursor.ParticleEmitter.Enabled = false
		Cursor.PointLight.Enabled = false
	end
end)
-- AUDIO

-- GAMEPLAY
GameplaySettings.toggles.togglesprint.MouseButton1Down:Connect(function()
	local button = GameplaySettings.toggles.togglesprint
	if button.Text == "[ + ]" then
		button.Text = "[ x ]"
		System.Remotes.SendSprintType:FireServer(false)
	else
		button.Text = "[ + ]"
		System.Remotes.SendSprintType:FireServer(true)
	end
end)

GameplaySettings.toggles.britishmode.MouseButton1Down:Connect(function()
	local button = GameplaySettings.toggles.britishmode -- BRITISH MODE!!!!!!!!
	if button.Text == "[ + ]" then
		button.Text = "[ x ]"
		Vars.UI.BritishMode.Value = false
	else
		button.Text = "[ + ]"
		Vars.UI.BritishMode.Value = true
	end
end)
-- Loading the leaderboard down here since it barely works

if TouchscreenEnabled then
	Cursor.CursorTrail.Enabled = false
	Cursor.CursorBoard.Enabled = false
end

sp(function()
	tw(2)
	
	inse(Connections, Connect(Players.PlayerAdded, function(Player)
		OnPlayer(Player, false)
	end))

	inse(Connections, Connect(Players.PlayerRemoving, function(Player)
		OnPlayer(Player, true)
	end))

	OnPlayer(Player, false)

	for _, v in pairs(GetChildren(Players)) do
		if IsA(v, "Player") and v ~= Player then
			OnPlayer(v, false)
		end
	end
end)

System.Remotes.SendPlatform:FireServer(UserInputService:GetLastInputType())

function close()
	normalTween(SelectorUI, Exponential, Out, .35, {Position = ud2(-1, 0,0.548, 0), Size = ud2(1, 0,-0.002, 0)})	
	
	for _, v in pairs(GetChildren(TouchUI.Touchscreen)) do
		if v:IsA("TextButton") then
			normalTween(v, Exponential, Out, 1, {BackgroundTransparency = 0, TextTransparency = 0})
		end
	end
end

function newButton(module)
	local NewUI = Example:Clone()
	NewUI.TextButton.Text = module.ModeName
	NewUI.Parent = Tab
	
	inse(Connections, Connect(NewUI.TextButton.MouseButton1Down, function()
		if currentSelected then	
			normalTween(currentSelected[1].TextButton, Sine, Out, .15, {TextColor3 = defaultTouchColor})
			normalTween(currentSelected[1], Sine, Out, .15, {BorderColor3 = defaultTouchColor})
		end

		vibratePhone()
		
		currentSelected = {NewUI, module}

		SelectButton.Text = "[ Select ]"
		fun = 1
		
		normalTween(NewUI, Sine, Out, .15, {BorderColor3 = c31})
		normalTween(NewUI.TextButton, Sine, Out, .15, {TextColor3 = c31})
		select_s:Play()
	end))
end

if UserInputService.TouchEnabled then
	for _, v in pairs(GetChildren(Modes.Spectrum.Main)) do
		local Mode = require(v)
		
		local NewTab = clone(Tab)
		
		NewTab.Parent = SelectorUI
		NewTab.Visible = false
		
		newButton(Mode)
	end	
end 

inse(Connections, Connect(SelectButton.MouseButton1Down, function()
	if last_f == 0 then
		if fun == 0 then
			vibratePhone()
			close()
		else
			if currentSelected then
				Remotes.KeyDown:FireServer(currentSelected[2].Key)
				vibratePhone()
				close()
			end
		end
	else
		if currentSelected then
			Remotes.KeyDown:FireServer(currentSelected[2].Key)
			vibratePhone()
			close()
		end
		
		last_f = 0
	end
end))

Keys = {SelectorUI.N, SelectorUI.M, SelectorUI.V, SelectorUI.B, SelectorUI.P}
for _, v in pairs(Keys) do
	local Button = v
	inse(Connections, Connect(v.MouseButton1Down, function()
		Remotes.KeyDown:FireServer(v.Name:lower())
		vibratePhone()
		
		press:Play()

		close()
		
		last_f = 1
	end))
end

inse(Connections, Remotes.OnSwitch.OnClientEvent:Connect(function()
	if currentMovementTween then
		currentMovementTween:Cancel()
		currentMovementTween:Destroy()
		currentMovementTween = nil
	end
end))

-- Loading Currency

sp(function()
	repeat tw(.1) until Player:FindFirstChild("Vars")

	local Currency = uiButtons.Currency
	local CurrencyVars = Player.Vars.Currency

	Currency.Text = "C: "..tostring(CurrencyVars.Value):match("^-?%d+")

	local CurrencyLocal = ins("NumberValue")
	inse(Connections, CurrencyVars.Changed:Connect(function(Value)
		normalTween(CurrencyLocal, Exponential, Out, 2, {Value = Value})
	end))

	inse(Connections, CurrencyLocal.Changed:Connect(function(Value)
		Currency.Text = "C: "..tostring(Value):match("^-?%d+")
	end))

	local LevelVars = Player.Vars.Level
	local LevelText = uiButtons.LV

	LevelText.Text = "LV: "..tostring(LevelVars.Value):match("^-?%d+")

	inse(Connections, LevelVars.Changed:Connect(function(Value)
		normalTween(CurrencyLocal, Exponential, Out, 2, {Value = Value})
	end))

	inse(Connections, LevelVars.Changed:Connect(function(Value)
		LevelText.Text = "LV: "..tostring(Value):match("^-?%d+")
	end))
end)

local function FadeOut()
	local WhiteScreen = ins("ScreenGui", PlayerGui)
	WhiteScreen.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
	WhiteScreen.DisplayOrder = 5

	local Frame = ins("Frame", WhiteScreen)
	Frame.Size = ud2(1, 0, 1, 0)
	Frame.BorderSizePixel = 0
	Frame.BackgroundColor3 = c3(0, 0, 0)
	Frame.ZIndex = 5
	
	Frame.BackgroundTransparency = 1
	normalTween(Frame, Linear, Out, .5, {BackgroundTransparency = 0})
	tw(.6)
	normalTween(Frame, Linear, Out, .5, {BackgroundTransparency = 1})
	Debris:AddItem(WhiteScreen, 2.2)
end

local uiglow_a = UI.uiglow
local def_Vol = Theme.Volume

local opened = -20
local SkinShop = PlayerGui.SkinShop
MainSkin, InfoSkin = SkinShop.Main, SkinShop.Info

inse(Connections, uiButtons.Skins.MouseButton1Down:Connect(function()
	if (tick() - opened) > .9 then
		isOpen = not isOpen


		if isOpen then
			FadeOut()
			
			if TouchscreenEnabled then
				TouchUI.Enabled = false
			end

			UI.Enabled = not isOpen
			SkinShop.Enabled = isOpen
			Camera.CameraSubject = workspace.Shop.Rig.Humanoid

			for _, v in pairs(ui_Elements) do
				v.Parent = ReplicatedStorage
			end

			Theme.Volume = 0

			tw(.2)
			normalTween(MainSkin, Exponential, Out, .5, {Position = ud2(0.004, 0,0.01, 0)})
			normalTween(InfoSkin, Exponential, Out, .5, {Position = ud2(0.695, 0,0.558, 0)})
		else
			normalTween(MainSkin, Exponential, In, .5, {Position = ud2(-1, 0,0.01, 0)})
			normalTween(InfoSkin, Exponential, In, .5, {Position = ud2(1.2, 0,0.558, 0)})
			tw(.3)
			FadeOut()

			if TouchscreenEnabled then
				TouchUI.Enabled = true
			end

			SkinShop.Enabled = isOpen
			Camera.CameraSubject = hum
			UI.Enabled = not isOpen

			for _, v in pairs(ui_Elements) do
				v.Parent = Camera
			end

			Theme.Volume = def_Vol
		end
		
		opened = tick()
	end
end))

uiButtons.Enabled = true

InfoSkin.Position = ud2(1.2, 0, 0.558, 0)
MainSkin.Position = ud2(-1, 0, 0.01, 0)

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)

hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
