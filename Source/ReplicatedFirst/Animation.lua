_G.localConnections = {}

repeat task.wait() until game.Loaded
task.wait(1)

local sp = task.spawn
local tw = task.wait
local ffc, ffcoc, wfc = game.FindFirstChild, game.FindFirstChildOfClass, game.WaitForChild
local ClearAllChildren = game.ClearAllChildren

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local LocalCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer.PlayerGui
local Storage = workspace:WaitForChild("Storage", 10)

local System = ReplicatedStorage:WaitForChild("System")
local Modules = System:WaitForChild("Modules")
local Modes = System:WaitForChild("Modes")
local Animations = System:WaitForChild("Animations")
local Auras = System:WaitForChild("Auras")
local Lyrics = System:WaitForChild("Lyrics")
local Create = require(Modules.Wings.Create)
local Color = require(Modules.Wings.Color)
local Lighting = game.Lighting

local ReplicatedFirst = game.ReplicatedFirst
local Heartbeat, RenderStepped, Stepped = RunService.Heartbeat, RunService.RenderStepped, RunService.Stepped
local rcp = RaycastParams.new
local globalsine = 0
local firstRan = true
local PlayerCount = 0

local cs = ColorSequence.new
local cf = CFrame.new
local angles = CFrame.Angles
local rad, rand, clamp, ceil = math.rad, math.random, math.clamp, math.ceil
local ins = Instance.new
local clk, sin = os.clock, math.sin
local ud2 = UDim2.new
local v3 = Vector3.new
local isA = game.IsA
local sp, tw = task.spawn, task.wait
local func = function() end
local hst = Enum.HumanoidStateType
local tf = TweenInfo.new
local style, dir = Enum.EasingStyle, Enum.EasingDirection
local linear, sine, in0, out = style.Linear, style.Sine, dir.In, dir.Out
local isfocused = false
local find = string.find
local c3 = Color3.new
local cf0 = cf(0, 0, 0)
local tc, hsv = tick(), Color3.fromHSV
local clear = table.clear
local ShiftLock = false

local Remotes = ReplicatedStorage.Players.Remotes

local TailWagEnabled = true
local getstate = ins("Humanoid").GetState
local disconnect = RenderStepped:Connect(function() end).Disconnect
local SetWingCount = Create.SetWingCount
local DestroyWings = Create.DestroyWings
local CreateWings = Create.CreateWings
local ColorWing = Color.ColorWing
local getChildren = game.GetChildren
local getDescendants = game.GetDescendants
local destroy = game.Destroy
local connect = game.Destroying.Connect
local once = game.Destroying.Once
local inse = table.insert
local Camera = workspace.CurrentCamera
local ps = PhysicalProperties.new
local Hexagon = System.Effects.Hexagon
local clone = game.Clone
local lower = string.lower
local schar = string.char
local rc = workspace.Raycast

local v3_0 = v3(0, 0, 0)
local lerp = cf0.Lerp
local vlerp = v3_0.Lerp
local prop = ps(5, 0.3, 0.5, 1, 1)
local lockCenter = Enum.MouseBehavior.LockCenter

local c3_0 = c3()

local braceletLimbs = {
	{"Left Arm", cf(0,.5,0)};
	{"Right Arm", cf(0,.5,0)};
	{"Left Leg", cf(0,-.5,0)};
	{"Right Leg", cf(0,-.5,0)};
}

local Quotes = require(Modules.Quotes.Quotes)
local sub = string.sub

local unrendered=ReplicatedStorage.Unrendered

local function sin_func(val, speed, off)
	return sin((val+off)*speed)
end

local function getLimb(Character, Name: string)
	local l=Character:FindFirstChild(Name)
	return l
end

local function getJoint(Limb, Name: string)
	local l=Limb:FindFirstChild(Name)
	return l
end

local function config(part, value: boolean)
	part.Anchored=not value
	part.CanCollide=value
	part.CanTouch=value
	part.CanQuery=value
end

local function getdistance(pos1, pos2)
	return (pos1.Magnitude - pos2.Magnitude)
end

local function binaryBool(boolean)
	if boolean then return 1 else return 0 end
end

local function ColorWings(Wings, LeftWingColor, RightWingColor, ModelWingColors)
	local L = c3_0
	local R = c3_0
	
	if ModelWingColors then
		L = ModelWingColors.L
		R = ModelWingColors.R
	end
	
	for i, v in pairs(Wings.L) do
		ColorWing(v, LeftWingColor,LeftWingColor,LeftWingColor, L)
	end
	for i, v in pairs(Wings.R) do
		ColorWing(v, RightWingColor,RightWingColor,RightWingColor, R)
	end
	
	L = nil
	R = nil
end

local function CreateMotor6D(Part0, Part1, C0, C1, Parent)
	local Motor6D=ins("Motor6D",Parent)
	Motor6D.C0=C0
	Motor6D.C1=C1
	Motor6D.Part0=Part0
	Motor6D.Part1=Part1
	return Motor6D
end


local function CreateBraceletSet(Character: Model)
	local bracelets = {}
	local braceletFolder = ins("Folder", Character)
	local braceModel = System.Models.bracelet
	
	for i,v in pairs(braceletLimbs) do
		local targetLimb = v[1]
		
		local Limb = Character[v[1]]
		local NewBracelet = clone(braceModel)
		
		NewBracelet.Parent = braceletFolder
		
		CreateMotor6D(Limb, NewBracelet.PrimaryPart, v[2], cf0, NewBracelet.PrimaryPart)
		inse(bracelets, {NewBracelet, targetLimb:split(" ")[1]})
	end
	
	braceletFolder.Name = "Bracelets"
	
	return bracelets
end

local function truncate_string(s, length)
	length = length or 20
	if #s > length then
		return sub(s,1, length) .. "..."
	else
		return s
	end
end


local function ColorBracelets(BTable, Left: Color3, Right: Color3)
	local a, b = pcall(function()
		for _, v in pairs(BTable) do
			local BraceletModel, Side = v[1], v[2]

			if Side == "Left" then
				BraceletModel.Glow.Color = Left
				BraceletModel.WeldPoint.Trail.Color = cs(Left)
			else
				BraceletModel.Glow.Color = Right
				BraceletModel.WeldPoint.Trail.Color = cs(Right)
			end
		end
	end)
end

local function normalTween(Object: Instance, Style: Enum.EasingStyle, Direction: Enum.EasingDirection, Time:number, PropertyTable)
	local nt = ts:Create(Object, tf(Time, Style, Direction, 0, false, 0), PropertyTable)

	nt:Play() once(nt.Completed,function()
		nt:Destroy() nt=nil
	end)

	return nt
end

local function ChangeTextColor(Textlabel, Color1, Color2)
	Textlabel.TextColor3 = Color1
	Textlabel.TextStrokeColor3 = Color2
end

local function SetAllParticles(Wing, Value)
	for i,v in pairs(getDescendants(Wing[1])) do
		if isA(v,"Trail") then
			v.Enabled = Value
		end
		if isA(v,"ParticleEmitter") then
			v.Enabled = Value
		end
		if isA(v,"Light") then
			v.Enabled = Value
		end
	end
end

local screenWidth = Camera.ViewportSize.X
local screenHeight = Camera.ViewportSize.Y


local function onScreen(object)
	if PlayerCount > 1 then
		local screenPoint, onScreen = Camera:WorldToScreenPoint(object.Position)
		if onScreen then
			if screenPoint.X >= 0 and screenPoint.X <= screenWidth and screenPoint.Y >= 0 and screenPoint.Y <= screenHeight then
				return true
			end
		end
		return false
	else
		return true
	end
end

local function Animate(child, RCharacter)
	local Player = nil
	if not RCharacter then
		Player = Players:FindFirstChild(child.Name)
	end

	if Player or RCharacter then	
		local br = false
		tw(.5)
		
		local function Textsp(txt: string, textobject: Instance, t: number)
			sp(function()
				if textobject:IsA("TextLabel") or textobject:IsA("TextButton") then
					for i = 1, #txt do
						tw(t or 0.02)
						textobject.Text = sub(txt, 1, i)
					end
				elseif textobject:IsA("StringValue") then
					for i = 1, #txt do
						tw(t or 0.02)
						textobject.Value = sub(txt, 1, i)
					end
				end
			end)
		end

		local Mode = false
		if RCharacter then
			Mode = true
		end
		
		local loop_Table={}

		local Character
		if Mode then
			Character = RCharacter
		else
			Character = Player.Character or Player.CharacterAdded:Wait()
		end

		local Torso, LeftArm, RightArm, LeftLeg, RightLeg, Head, RootPart = Character.Torso, Character["Left Arm"], Character["Right Arm"], Character["Left Leg"], Character["Right Leg"], Character.Head, Character.HumanoidRootPart
		local ls, rs, lh, rh, nj, rj = Torso["Left Shoulder"], Torso["Right Shoulder"], Torso["Left Hip"], Torso["Right Hip"], Torso.Neck, RootPart.RootJoint
		local Humanoid = ffcoc(Character, "Humanoid")

		local JointTable = {ls, rs, lh, rh, nj, rj, ls.C0, rs.C0, lh.C0, rh.C0, nj.C0, rj.C0}

		local cur_mod = ffc(child, "cur_mod", 9e9)
		local cur_mod_2 = ffc(child, "cur_mod_2", 9e9)

		local ldt = 0
		local billBoard = ffcoc(Torso, "BillboardGui")
		local textLabel = ffcoc(billBoard, "TextLabel")
		local textShake = false

		local tempAuras = ins("Folder", child)

		local Core = clone(System.Models.Core)

		local modelStorage = ins("Folder", child)
		local wingStorage = ins("Folder",child)

		local Vars:Folder = wfc(child, "Vars", 9e9)
		local Sprint:ObjectValue = Vars:WaitForChild("Sprint")
		local current_vfx
		local RColor
		
		local ran = 0
		local MainFont

		local bilboardQuote = ins("BillboardGui", Head)
		bilboardQuote.Size = ud2(0, 2709, 0, 150)
		bilboardQuote.ExtentsOffset = v3(0, 4, 0)
		bilboardQuote.MaxDistance = 60
		bilboardQuote.Brightness = 4

		local DAnchorPoint

		local currentAnimation = func
		local currentWingAnimation = func
		
		local currentWalkAnimation = func
		local currentWalkAnimationLeft
		local currentWalkAnimationRight
		local currentWalkAnimationBack
		
		local currentRunAnimation = func
		local currentRunAnimationLeft
		local currentRunAnimationRight
		local currentRunAnimationBack
		
		local currentJumpAnimation = func
		local currentFallAnimation = func

		local MovementType = ""

		local WingSpeed, WingOffset = 0, 0
		local WingModel

		local CameraShakeEnabled = false
		local CameraShakeIntensity = false
		local CameraShakeDistance = 0

		local ColorFlashRate = (1/1)
		local CustomColorFlash = false
		local CustomColorFlashValues = {}

		local Wings
		local JointTableL, JointTableR
		local wingSpeedOffset = 0
		local SineWingAnimationSpeed = 0
		local SineWingAnimationOffset = 0

		local TextBoardAnimationSpeed = 0
		local TextBoardAnimationOffset = 0
		local TextBoardXMovement = 0
		local TextBoardRotation = 0
		local TextBoardYLevel = 0

		local RandomColorFlashMain
		local RandomColorFlashSub

		local UIColorSyncReversed
		local UISyncRandomColorFlashMain
		local UISyncRandomColorFlashSub

		local LeftWingRandomColorFlashSync
		local RightWingRandomColorFlashSync

		local LeftWingRainbowSync
		local RightWingRainbowSync

		local RainbowMainEnabled
		local RainbowSubEnabled

		local UIRainbowReversed
		local UISyncRainbowMain
		local UISyncRainbowSub

		local LeftWingColor
		local RightWingColor

		local UIShakeEnabled
		local UIShakeIntensity

		local YLevelEnabled = false
		local YLevel = 0

		local modelWelds={}

		local EffectsEnabled
		local AuraObjectPositionType
		local AuraObject
		local AuraObjectColorSync

		local AnimatedAurasEnabled = false
		local AnimatedAurasTable = {}

		local AuraRaycastsEnabled = false
		local AuraRaycasts = {}

		local WingCustomColorFlashEnabled = false
		local WingCustomColorFlashValues = {
			Left = {
				Main = {},
				Sub = {},
			},

			Right = {
				Main = {},
				Sub = {},
			},
		};
		
		local Bracelets = CreateBraceletSet(Character)
		
		local AdvancedModeScriptingEnabled = false
		local TakeControlOfBillboard = false
		local AdvancedModeSettings = {}
		local AdvancedModeConnections = {}

		local CoreWeld = CreateMotor6D(Core.PrimaryPart, Torso, cf0, cf0, Core.PrimaryPart)
		local CoreOut = Core.out

		local UI = Vars.UI
		local TextShakeEnabled, TextShakeIntensity, TextShakeRate, TextShakeSpeed = false, 0, (1/30), 0

		local TailC1
		local TailMotor

		local Color1, Color2 = Vars.Color1, Vars.Color2
		local UIColor1, UIColor2 = Vars.UI.UIColor1, Vars.UI.UIColor2
		local ReactiveWings

		local Theme = ffc(Torso, "Theme") or wfc(Camera, "Theme")

		local Cycle0 = 0
		local Cycle1 = 0

		local CHexagon
		local HexSpeed = 0	
		local Label

		local HexagonSize
		local HexagonSizeSpeed
		local HexagonSizeSine

		local AdvancedWingsEnabled
		local CDAdvancedWingTable={}

		local function update(module)	
			br = true
			
			if DAnchorPoint then
				DAnchorPoint:Destroy()
				DAnchorPoint = nil
			end
			
			for _, v in pairs(getChildren(Torso)) do
				if v.Name == "AnchorPoint" then
					v:Destroy()
					v = nil
				end
			end
			
			sp(function()
				for i, v in pairs(AdvancedModeConnections) do
					AdvancedModeConnections[i]:Disconnect()
					AdvancedModeConnections[i] = nil
				end
				
				for i, v in pairs(_G.localConnections) do
					for _, connection in pairs(v) do
						connection:Disconnect()
					end
				end
			end)
			
			ran = 0
				
			local DontRefreshAura=false

			RainbowMainEnabled = false
			RainbowSubEnabled = false

			LeftWingRainbowSync = false
			RightWingRainbowSync = false

			UIRainbowReversed = false
			UISyncRainbowMain = false
			UISyncRainbowSub = false
			CustomColorFlash = false
			RandomColorFlashSub = false
			RandomColorFlashMain = false
			RightWingRandomColorFlashSync = false
			LeftWingRandomColorFlashSync = false

			ClearAllChildren(wingStorage)
			ClearAllChildren(modelStorage)
			ClearAllChildren(tempAuras)

			RenderStepped:Wait(ColorFlashRate * 2)
			
			br = false

			local MainColor1 = module.MainColor1
			local MainColor2 = module.MainColor2

			DestroyWings(nil, Wings) 
			
			if Wings then
				clear(Wings) 
			end
			
			clear(AnimatedAurasTable)
			clear(CDAdvancedWingTable)
			
			Wings = nil
			AuraRaycastsEnabled = false

			currentAnimation = require(module.Animation)
			currentWalkAnimation = require(module.MoveAnimation)
			currentRunAnimation = require(module.SprintAnimation)
			currentJumpAnimation = require(module.JumpAnimation)
			currentFallAnimation = require(module.FallAnimation)
			
			currentWalkAnimationLeft = nil
			currentWalkAnimationRight = nil
			currentWalkAnimationBack = nil
			
			currentRunAnimationLeft = nil
			currentRunAnimationRight = nil
			currentRunAnimationBack = nil
			
			if currentRunAnimation.Left then
				currentRunAnimationLeft = currentRunAnimation.Left
				currentRunAnimationRight = currentRunAnimation.Right
				currentRunAnimationBack = currentRunAnimation.Back
			end
			
			if currentWalkAnimation.Left then
				currentWalkAnimationLeft = currentWalkAnimation.Left
				currentWalkAnimationRight = currentWalkAnimation.Right
				currentWalkAnimationBack = currentWalkAnimation.Back
			end
			
			currentAnimation = currentAnimation.Animate
			currentWalkAnimation = currentWalkAnimation.Animate
			currentRunAnimation = currentRunAnimation.Animate
			currentJumpAnimation = currentJumpAnimation.Animate
			currentFallAnimation = currentFallAnimation.Animate
			
			MovementType = module.MoveAnimation.Parent.Name
			MainFont = module.ModeFont
			
			AdvancedWingsEnabled = false 
	
			local WingTable = module.AdvancedWingTable
			if WingTable and module.AdvancedWings then
				AdvancedWingsEnabled = true
				local Count = module.UnlockedCount or 7

				for _, v in ipairs(WingTable) do
					local AnchorPoint = ins("Part", Torso)
					AnchorPoint.Size = v3_0

					local AnchorMotor = CreateMotor6D(AnchorPoint, Torso, cf0, cf0, Torso)

					AnchorPoint.CanCollide = false
					AnchorPoint.CanTouch = false
					AnchorPoint.CanQuery = false

					local Wings = CreateWings(nil, Count, v.WingModel, v.RingModel, wingStorage, AnchorPoint, v.RingTable, v.WeldOrder)

					local New_Table = {
						LeftWingColor = v.LeftWingColor,
						RightWingColor = v.RightWingColor,
						SineWingAnimationSpeed = v.SineWingAnimationSpeed,
						SineWingAnimationOffset = v.SineWingAnimationOffset,
						speedOff = v.WingAnimationSpeedMultiple or 1,
						Wings = Wings,
						JointTableL = Wings.LJ,
						JointTableR = Wings.RJ,
						WingAnimation = require(v.WingAnimation).Animate,
						AnchorMotor = AnchorMotor,
						AnchorPoint = AnchorPoint
					}

					local RingTable = v.RingTable
					local Enabled = v.RingTable.Enabled
					local Small, Large = New_Table.Wings.Rings.Small, New_Table.Wings.Rings.Large
					local A, B = RingTable.SmallColor, RingTable.LargeColor

					Small.Color = A
					Large.Color = B

					local col_1 = cs(A)
					local SmallE = Enabled.Small
					local LargeE = Enabled.Large

					Small.Glow.Color = A
					Small.A.Glow.Color = col_1

					Small.Glow.Enabled = SmallE
					Small.A.Glow.Enabled = SmallE
					Small.Transparency = binaryBool(not SmallE)

					Large.Glow.Color = B
					Large.A.Glow.Color = cs(B)

					Large.Glow.Enabled = LargeE
					Large.A.Glow.Enabled = LargeE
					Large.Transparency = binaryBool(not LargeE)

					Large.A.ringg.Enabled = LargeE
					Small.A.ringg.Enabled = SmallE
					Large.A.ringg.Color = col_1
					Small.A.ringg.Color = col_1
					
					ColorBracelets(Bracelets, RightWingColor, LeftWingColor)

					inse(CDAdvancedWingTable, New_Table)

					ColorWings(New_Table.Wings, New_Table.LeftWingColor, New_Table.RightWingColor)
					SetWingCount(Wings, v.LeftWingCount, v.RightWingCount, v.LeftWingEnabled, v.RightWingEnabled)
				end
			end
			WingTable = nil

			if not AdvancedWingsEnabled then
				currentWingAnimation = require(module.WingAnimation).Animate
			end

			TextShakeEnabled = module.TextShakeEnabled
			TextShakeIntensity = module.TextShakeIntensity
			TextShakeRate = module.TextShakeRate
			TextShakeSpeed = module.TextShakeSpeed

			CameraShakeEnabled = module.CameraShakeEnabled
			CameraShakeIntensity = module.CameraShakeIntensity
			CameraShakeDistance = module.CameraShakeDistance

			wingSpeedOffset = module.WingAnimationSpeedMultiple

			Textsp(module.ModeName, textLabel, .03)

			if LocalPlayer == Player then
				if module.SongArtist and module.SongTitle then
					Textsp(truncate_string(module.SongArtist, 24), Vars.ArtistName, .013)
					Textsp(truncate_string(module.SongTitle, 24), Vars.SongName, .013)


					if module.Album == "" then
						Textsp("None", Vars.UI.Album, .012)
					else
						Textsp(truncate_string(module.Album,24), Vars.UI.Album, .012)  
					end
				end
				
				Vars.FColor1.Value = Color1.Value
				Vars.FColor2.Value = Color2.Value
				
				local UIColor1Value = Vars.UI.UIColor1
				local UIColor2Value = Vars.UI.UIColor2

				if not module.AutoUIColor then
					if not module.UISyncRainbowMain and not module.UISyncRainbowSub then
						if not (module.UISyncRandomColorFlashMain and module.UISyncRandomColorFlashSub) then
							normalTween(UIColor1Value, style.Exponential, out, .8, {Value = module.UIColor1})
							normalTween(UIColor2Value, style.Exponential, out, .8, {Value = module.UIColor2})
						end
					else
						UIColor1Value.Value = module.MainColor1
						UIColor2Value.Value = module.MainColor2
					end
				else
					if not module.UISyncRainbowMain and not module.UISyncRainbowSub then
						if not (module.UISyncRandomColorFlashMain and module.UISyncRandomColorFlashSub) then
							normalTween(UIColor1Value, style.Exponential, out, .8, {Value = module.MainColor1})
							normalTween(UIColor2Value, style.Exponential, out, .8, {Value = module.MainColor2})
						end
					else
						UIColor1Value.Value = module.MainColor1
						UIColor2Value.Value = module.MainColor2
					end
				end
				
				sp(function()
					Vars.ModeName.Value = ""
					Vars.SubText.Value = ""

					Textsp(module.ModeName, Vars.ModeName, .013)
					tw(.1)
					Textsp(module.SubText, Vars.SubText, .013)
				end)
				
				if module.AlbumCover then
					Vars.UI.AlbumCover.Value = module.AlbumCover
				else
					Vars.UI.AlbumCover.Value = "0"
				end
			end

			if not AdvancedWingsEnabled then
				SineWingAnimationSpeed = module.SineWingAnimationSpeed
				SineWingAnimationOffset = module.SineWingAnimationOffset
			else
				SineWingAnimationSpeed = 0
				SineWingAnimationOffset = 0
			end

			TextBoardAnimationSpeed = module.TextBoardAnimationSpeed
			TextBoardAnimationOffset = module.TextBoardAnimationOffset
			TextBoardXMovement = module.TextBoardXMovement
			TextBoardRotation = module.TextBoardRotation
			TextBoardYLevel = module.TextBoardYLevel

			RandomColorFlashMain = module.RandomColorFlashMain
			RandomColorFlashSub = module.RandomColorFlashSub

			UIColorSyncReversed = module.UIColorSyncReversed
			UISyncRandomColorFlashSub = module.UISyncRandomColorFlashSub
			UISyncRandomColorFlashMain = module.UISyncRandomColorFlashMain

			if MainColor1 == c3_0 then
				CoreOut.Color = MainColor2
			else
				CoreOut.Color = MainColor1
			end

			RainbowMainEnabled = module.RainbowMainEnabled
			RainbowSubEnabled = module.RainbowSubEnabled

			LeftWingRainbowSync = module.LeftWingRainbowSync
			RightWingRainbowSync = module.RightWingRainbowSync

			UIRainbowReversed = module.UIRandomReversed
			UISyncRainbowMain = module.UISyncRainbowMain
			UISyncRainbowSub = module.UISyncRainbowSub

			UI.UIShakeEnabled.Value = module.UIShakeEnabled
			UI.UIShakeIntensity.Value = module.UIShakeIntensity

			UI.UISlantedLineSpeedDivider.Value = module.UISlantedLineSpeedDivider
			UI.UISlantedLineSpeed.Value = module.UISlantedLineSpeed
			UI.UISlantedLineRotation.Value = module.UISlantedLineRotation

			YLevelEnabled = module.YLevelEnabled
			YLevel = module.YLevel

			CustomColorFlash = module.CustomColorFlash
			CustomColorFlashValues = module.CustomColorFlashValues
			Cycle0, Cycle1 = #CustomColorFlashValues.Main, #CustomColorFlashValues.Sub

			ColorFlashRate = module.ColorFlashRate

			clear(AuraRaycasts)
			ClearAllChildren(tempAuras) AuraRaycastsEnabled = false
			clear(AnimatedAurasTable)

			if module.AdvancedAuraObjectsEnabled then
				local AdvancedAuraObjectsTable = module.AdvancedAuraObjectsTable 

				for _, v in pairs(AdvancedAuraObjectsTable) do
					local NewObject: BasePart = clone(v.Object)
					local Parent: Instance = ffc(Character, v.Parent, true)

					if v.RaycastEnabled then
						NewObject.Parent = tempAuras
						AuraRaycastsEnabled = true

						inse(AuraRaycasts, {v.RaycastOffset, NewObject})
					else
						if (Parent and NewObject) then
							NewObject.Parent = tempAuras
							local MainColor = cs(v.MainColor)

							if v.SetColors then
								if v.AdvancedColorsEnabled then
									local AdvancedTable = v.AdvancedColors

									for _, x in pairs(AdvancedTable) do
										local ParticleName = x[1]

										local ParticleObject = ffc(NewObject, ParticleName, true)
										if ParticleObject then
											ParticleObject.Color = x[2]
										end
									end
								else
									for _, x in pairs(getDescendants(NewObject)) do
										if isA(x, "ParticleEmitter") then
											x.Color = MainColor1
										end
									end
								end
							end

							local NewWeld = CreateMotor6D(NewObject, Parent, v.Offset, cf0, NewObject)

							if v.IsAnimated then
								AnimatedAurasEnabled = true

								inse(AnimatedAurasTable, {NewWeld, v.AnimationModule})
							end
						end
					end

				end
			end
			
			local VUI = Vars.UI.UI3D
			VUI.GlobalOffset.Value = cf0
			VUI.LeftOffset.Value = cf0
			VUI.RightOffset.Value = cf0

			VUI = nil

			if not AdvancedWingsEnabled then
				local Count = module.UnlockedCount or 7
				local AnchorPoint = ins("Part", Torso)
				AnchorPoint.Size = v3_0
				local AnchorMotor = CreateMotor6D(AnchorPoint, Torso, cf0, cf0, Torso)
				DAnchorPoint = AnchorMotor

				local ModelWingColors = {
					L = module.LeftWingColor2,
					R = module.RightWingColor2,
				}

				Wings = CreateWings(nil, Count, module.WingModel, module.RingModel, wingStorage, AnchorPoint, module.RingTable, module.WeldOrder, ModelWingColors)
				JointTableL, JointTableR = Wings.LJ, Wings.RJ

				LeftWingColor = module.LeftWingColor
				RightWingColor = module.RightWingColor
				ColorWings(Wings, LeftWingColor, RightWingColor, ModelWingColors)

				local RingTable = module.RingTable
				local Enabled = module.RingTable.Enabled
				local Small, Large = Wings.Rings.Small, Wings.Rings.Large
				local A, B = RingTable.SmallColor, RingTable.LargeColor

				Small.Color = A
				Large.Color = B

				local col_1 = cs(A)
				local SmallE, LargeE = Enabled.Small, Enabled.Large
				Small.Glow.Color = A
				Small.A.Glow.Color = col_1
				Small.Glow.Enabled = SmallE
				Small.A.Glow.Enabled = SmallE
				Small.Transparency = binaryBool(not SmallE)

				Large.Glow.Color = B
				Large.A.Glow.Color = col_1
				Large.Glow.Enabled = LargeE
				Large.A.Glow.Enabled = LargeE
				Large.Transparency = binaryBool(not LargeE)

				Large.A.ringg.Enabled = LargeE
				Small.A.ringg.Enabled = SmallE
				Large.A.ringg.Color = col_1
				Small.A.ringg.Color = col_1

				ColorBracelets(Bracelets, RightWingColor, LeftWingColor)
				SetWingCount(Wings, module.LeftWingCount, module.RightWingCount, module.LeftWingEnabled, module.RightWingEnabled)

				LeftWingRandomColorFlashSync = module.LeftWingRandomColorFlashSync or false
				RightWingRandomColorFlashSync = module.RightWingRandomColorFlashSync or false

				if module.CustomWingColorEnabled then
					local ColorTable = module.CustomWingColorTable
					local Left, Right = ColorTable.Left, ColorTable.Right

					for i, v in pairs(Left) do
						for x, n in pairs(Wings.L) do
							if x == i then
								ColorWing(n, v, v, v)
								break
							end
						end
					end

					for i, v in pairs(Right) do
						for x, n in pairs(Wings.R) do
							if x == i then
								ColorWing(n, v, v, v)
								break
							end
						end
					end
					
					ColorTable = nil	
				end
				
				RingTable = nil
			end


			ReactiveWings = module.ReactiveWings

			if CHexagon then
				destroy(CHexagon)
				CHexagon = nil
			end

			if module.HexagonEnabled then
				CHexagon = clone(Hexagon)
				CHexagon.Parent = Torso

				Label = CHexagon.Label

				Label.ImageColor3=module.HexagonColor
				Label.Image = module.HexagonImage or "rbxassetid://2312119891"

				HexSpeed=module.HexagonSpeed
				HexagonSize=module.HexagonSize
				HexagonSizeSine=module.HexagonSizeSine
				HexagonSizeSpeed=module.HexagonSizeSpeed
			end

			if module.DontRefreshAura then
				DontRefreshAura = module.DontRefreshAura
			else
				if AuraObject and not isA(AuraObject, "Folder") and AuraObject.Parent == child and AuraObject ~= Auras then
					destroy(AuraObject) AuraObject = nil
				end
			end

			EffectsEnabled = module.EffectsEnabled
			AuraObjectPositionType = module.AuraObjectPositionType
			AuraObject = module.AuraObject
			AuraObjectColorSync = module.AuraObjectColorSync or false

 			if EffectsEnabled then
				if not DontRefreshAura then
					if AuraObject and AuraObject ~= Auras and AuraObject ~= Auras.Modes then
						AuraObject = clone(AuraObject)

						if AuraObjectPositionType == "Raycast" then
							AuraObject.Parent = child
							AuraObject.Transparency = 1
							AuraObject.Position = RootPart.Position
							config(AuraObject, false)
						elseif AuraObjectPositionType == "Torso" then
							local obj_Weld = CreateMotor6D(AuraObject, Torso, cf0, module.TorsoOffset or cf0, AuraObject)
							AuraObject.Parent = child
							config(AuraObject, false)
							AuraObject.Anchored = false
						elseif AuraObjectPositionType == "RootPart" then
							local obj_Weld = CreateMotor6D(AuraObject, RootPart, cf0, module.TorsoOffset or cf0, AuraObject)
							AuraObject.Parent = child
							config(AuraObject, false)
							AuraObject.Anchored = false
						end
					end
				end
			end


			ClearAllChildren(modelStorage)
			clear(modelWelds)

			if module.ModelsEnabled  then
				for _, v in pairs(module.ModelsTable) do
					local WeldObject = v.WeldObject
					local Object = v.Object
					local Offset = v.Offset

					local CharacterObject = ffc(Character, WeldObject, true)
					if CharacterObject then
						local NewOBJ = clone(Object)
						local WeldPoint = NewOBJ
						if isA(NewOBJ, "Model") then
							WeldPoint = NewOBJ.PrimaryPart
						end

						local NewWeld = CreateMotor6D(WeldPoint, CharacterObject, Offset, cf0, WeldPoint)
						inse(modelWelds,NewWeld)

						NewOBJ.Parent = modelStorage
					end
				end
			end
			
			ClearAllChildren(bilboardQuote)
			
			if module.QuotesEnabled then
				ClearAllChildren(bilboardQuote)
				normalTween(textLabel, linear, out, .5, {TextTransparency=1})

				local qtable = module.QuotesTable
				local quoteCount = #qtable
				local quote = qtable[quoteCount]
				if quoteCount ~= 1 then
					local random = rand(1, quoteCount)
					quote = qtable[random]
				end
				
				if quote then
					sp(function()
						normalTween(textLabel, linear, out, .5, {TextTransparency = 1})
						local val = Quotes.AnimateText(Torso,bilboardQuote, quote.Text, quote.Lifetime, quote.TextFont, quote.TextDelay, quote.TextColor3, quote.TextStrokeColor3, quote.FontFace, quote.Animated, require(quote.Animation), quote.AnimationSpeedMultiplier)
						normalTween(textLabel, linear, out, .5, {TextTransparency = 0})
					end)
				end
				
			else
				normalTween(textLabel, linear, out, .5, {TextTransparency=0})
			end
			
			AdvancedModeScriptingEnabled = module.AdvancedModeScriptingEnabled

			if Player == LocalPlayer then
				local UI = PlayerGui.UI
				
				
				Lighting.BW.Enabled = false
				Lighting.BW.Saturation = -1
				Lighting.Inverted.Enabled = false
				if Vars.UI.UIBarsToggle == true then
					UI["Top"].Visible = true
					UI["Bot"].Visible = true
				end
				UI["Left"].Visible = false
				UI["Right"].Visible = false
				UI["visTop"].Visible = false
				PlayerGui.Static.Enabled = false
				
				UI.modetext.TextStrokeTransparency = 1
				UI.subtext.TextStrokeTransparency = 1
			end

			if AdvancedModeScriptingEnabled and ran == 0 then
				ran = ran + 1
				
				local WingsA = Wings
				if AdvancedWingsEnabled then
					WingsA = CDAdvancedWingTable
				end

				local LUI
				if LocalPlayer == Player then
					LUI = Player.PlayerGui["UI"]
				else
					LUI = ReplicatedFirst.UI
				end

				local Table = {Sound = Theme, UI = LUI,
					Player = Player, Character = Character,
					Billboard = billBoard, Wings = WingsA,
					Vars = Vars, Models = modelStorage,
					Core = Core, modelWelds = modelWelds
				}
				
				AdvancedModeSettings, AdvancedModeConnections = require(module.AdvancedModeModule)(Table)
				TakeControlOfBillboard = AdvancedModeSettings.TakeControlOfBillboard
			end

			MainColor1 = nil
			MainColor2 = nil
		end
		
		local ls0 = ls.C1
		local rs0 = rs.C1
		local lh0 = lh.C1
		local rh0 = rh.C1
		
		local rj0 = rj.C1
		local nj0 = nj.C1

		local BodyTable = {LeftArm=LeftArm, RightArm=RightArm, LeftLeg=LeftLeg, RightLeg=RightLeg, Torso=Torso, Head=Head, RootPart=RootPart, Humanoid=Humanoid}
		local jt=JointTable
		
		local enabled=true
		
		inse(loop_Table, connect(Remotes.OnAttack.OnClientEvent, function(Table, NPlayer, Mouse, Parent)
			if NPlayer == Player and onScreen(NPlayer.Character.HumanoidRootPart) then
				local Module = require(Table.Module)

				if Module then
					enabled = false

					local c1,c2=Color1,Color2
					if NPlayer then
						local a=Module.Attack(Parent, {BodyParts = BodyTable, JointTable=jt, Color1=c1, Color2=c2, MousePosition = Mouse, Welds=modelWelds, Player = Player})
					end

					enabled = true
					
					Module = nil
					c1 = nil
					c2 = nil
				end
			end
		end))
		
		inse(loop_Table, connect(Remotes.OnIntro.OnClientEvent, function(Duration)
			enabled = false
			
			tw(Duration)
			
			enabled = true
		end))
		
		local pre_rcp = rcp()
		local RootOffset = v3(0, -1, 0)
		
		pre_rcp.FilterType = Enum.RaycastFilterType.Exclude
		pre_rcp.FilterDescendantsInstances = {Storage, Character, workspace.ActiveVFX}
		
		inse(loop_Table, connect(RenderStepped, function(delta)

			local RCF = RootPart.CFrame
			local RPos = RCF.Position
			
			local dist = getdistance(Camera.CFrame.Position, RPos)
			local isOnScreen = onScreen(Torso)

			if dist < 1600 and isOnScreen then	
				local Velocity = RootPart.AssemblyLinearVelocity
				local RotVelocity = RootPart.AssemblyAngularVelocity
				
				local y_Vel = Velocity.Y
				local y_rot = RotVelocity.Y
				local MoveDirection = Humanoid.MoveDirection
				local current_state = getstate(Humanoid)
				local Sprint = Sprint.Value
				local relativeMoveDirection = RootPart.CFrame:VectorToObjectSpace(MoveDirection)

				local Anchored = RootPart.Anchored
				local globaljointdt = clamp((delta * 120) * .09, .01, 2)
				local delta_calculation = (delta * 120)

				local Raycast = rc(workspace, RPos + RootOffset, RCF.UpVector * -200, pre_rcp)

				if (billBoard and textLabel) and dist < 1024 and not (TextShakeEnabled or TakeControlOfBillboard) then
					textLabel.Rotation = 5 * sin(globalsine * TextBoardAnimationSpeed)
					billBoard.StudsOffsetWorldSpace = v3(1.25 * sin((globalsine+TextBoardAnimationOffset) * TextBoardAnimationSpeed), TextBoardYLevel, 0)
				end	

				local delta_01 = delta_calculation * .1
				if dist < 1024 and enabled and Raycast then
					local RaycastDistance = Raycast.Distance
					if y_Vel > 3 and RaycastDistance > 4 then
						currentJumpAnimation(JointTable, globalsine, globaljointdt, delta_calculation * .04, YLevel)
					elseif y_Vel < -3 and RaycastDistance > 4 then
						currentFallAnimation(JointTable, globalsine, globaljointdt, delta_calculation * .04, YLevel)
					elseif MoveDirection == v3_0 or Anchored then
						currentAnimation(JointTable, globalsine, .03 + delta * 6,Character)

						if not YLevelEnabled and MovementType == "Float" then
							YLevel = rj.C0.Y
						end
					end	

					if Raycast.Distance < 4 and MoveDirection ~= v3_0 and not Anchored then
						if not Sprint then
							if currentWalkAnimationLeft then
								if relativeMoveDirection.Z > .5 then
									currentWalkAnimationBack(JointTable, globalsine, delta_01, YLevel)
								elseif relativeMoveDirection.Z < -.5 then
									currentWalkAnimation(JointTable, globalsine, delta_calculation * .125, YLevel)
								end

								if relativeMoveDirection.X > .5 then
									currentWalkAnimationRight(JointTable, globalsine, delta_01, YLevel)
								elseif relativeMoveDirection.X < -.5 then
									currentWalkAnimationLeft(JointTable, globalsine, delta_01, YLevel)
								end
							else
								currentWalkAnimation(JointTable, globalsine, delta_calculation * .125, YLevel)
							end 
						else
							if currentRunAnimationLeft then
								if relativeMoveDirection.Z > .5 then
									currentRunAnimationBack(JointTable, globalsine, delta_01, YLevel)
								elseif relativeMoveDirection.Z < -.5 then
									currentRunAnimation(JointTable, globalsine, delta_01, YLevel)
								end

								if relativeMoveDirection.X > .5 then
									currentRunAnimationRight(JointTable, globalsine, delta_01, YLevel)
								elseif relativeMoveDirection.X < -.5 then
									currentRunAnimationLeft(JointTable, globalsine, delta_01, YLevel)
								end
							else
								currentRunAnimation(JointTable, globalsine, delta_calculation * .125, YLevel)
							end 
						end
					end
				end	

				if CHexagon then
					local X = HexagonSize.X
					local Y = HexagonSize.Y
					
					Label.Rotation = Label.Rotation + ((HexSpeed * 240) * delta)
					CHexagon.Size = ud2(X.Scale + HexagonSizeSine * sin_func(globalsine, HexagonSizeSpeed, 0), X.Offset, Y.Scale + HexagonSizeSine * sin_func(globalsine, HexagonSizeSpeed, 0), Y.Offset)
				end

				if dist < 1024 and currentWingAnimation and Wings then
					if MovementType == "Float" then
						if MoveDirection == v3_0 then
							currentWingAnimation(Wings, JointTableL, JointTableR, globalsine * wingSpeedOffset, SineWingAnimationSpeed, SineWingAnimationOffset, delta, DAnchorPoint)
						else
							currentWingAnimation(Wings, JointTableL, JointTableR, globalsine, -3, 0, delta, DAnchorPoint)
						end
					else
						currentWingAnimation(Wings, JointTableL, JointTableR, globalsine * wingSpeedOffset, SineWingAnimationSpeed, SineWingAnimationOffset, delta, DAnchorPoint)
					end
				end

				if AdvancedWingsEnabled then
					for _, v in pairs(CDAdvancedWingTable) do
						v.WingAnimation(v.Wings, v.JointTableL, v.JointTableR, globalsine * v.speedOff, v.SineWingAnimationSpeed, v.SineWingAnimationOffset, delta, v.AnchorMotor)
					end
				end

				if CameraShakeEnabled and dist < CameraShakeDistance then
					Humanoid.CameraOffset = v3(rand(-CameraShakeIntensity, CameraShakeIntensity)/10, rj.C0.Y + rand(-CameraShakeIntensity, CameraShakeIntensity)/10, rand(-CameraShakeIntensity, CameraShakeIntensity)/10)
				end

				if AuraRaycastsEnabled and Raycast then
					for _, v in pairs(AuraRaycasts) do
						local b = v[2]
						b.Position = Raycast.Position + v[1]
						b.Orientation = Raycast.Normal
						b = nil
					end
				end

				if TailWagEnabled and dist < 80 and TailMotor then
					local TC1 = TailMotor.C1
					if MoveDirection == v3_0 or Anchored then
						TailMotor.C1 = lerp(TC1, TailC1 * angles(rad(clamp(-y_Vel*2.5, -15, 15)), rad(15 * sin((globalsine+SineWingAnimationOffset+6)*SineWingAnimationSpeed)), 0), .1)
					else
						TailMotor.C1 = lerp(TC1, TailC1 * angles(rad(clamp(y_Vel, -50, 50)), rad((y_rot * 2) + 15 * sin(globalsine*3)), 0), delta_calculation * 0.07)
					end
				end

				if dist < 80 then
					if MovementType == "Float" then
						if Sprint then
							y_rot = y_rot * 2.5
						end
						
						local yrot3 = y_rot * 3
						rj.C1 = lerp(rj.C1, rj0  * angles(0, rad(clamp(-y_rot*2, -25, 25)), rad(clamp(y_rot*2, -45, 45))), globaljointdt)
						nj.C1 = lerp(nj.C1, nj0 * angles(0, rad(clamp(-y_rot, -10, 10)), rad(clamp(-y_rot, -10, 10))), globaljointdt)
						ls.C1 = lerp(ls.C1, ls0 * angles(rad(clamp(yrot3, -15, 15)), rad(clamp(yrot3, -45, 45)), rad(clamp(yrot3, -45, 45))), globaljointdt)
						rs.C1 = lerp(rs.C1, rs0 * angles(rad(clamp(-yrot3, -15, 15)), rad(clamp(yrot3, -22, 22)), rad(clamp(yrot3, -45, 45))), globaljointdt)
						lh.C1 = lerp(lh.C1, lh0 * angles(rad(clamp(yrot3, -15, 15)), rad(clamp(-yrot3, -15, 15)), 0), globaljointdt)
						rh.C1 = lerp(rh.C1, rh0 * angles(rad(clamp(-yrot3, -15, 15)), rad(clamp(-yrot3, -15, 15)), 0), globaljointdt)
					else
						local yrot3 = y_rot * 3
						rj.C1 = lerp(rj.C1, rj0  * angles(0, rad(clamp(-y_rot*2, -25, 25)), rad(clamp(y_rot*2, -12.5, 12.5))), globaljointdt)
						nj.C1 = lerp(nj.C1, nj0 * angles(0, rad(clamp(-y_rot, -10, 10)), rad(clamp(-y_rot, -5, 5))), globaljointdt)
						ls.C1 = lerp(ls.C1, ls0 * angles(rad(clamp(yrot3, -15, 15)), rad(clamp(yrot3, -22, 22)), rad(clamp(yrot3, -45, 45))), globaljointdt)
						rs.C1 = lerp(rs.C1, rs0 * angles(rad(clamp(-yrot3, -15, 15)), rad(clamp(yrot3, -22, 22)), rad(clamp(yrot3, -45, 45))), globaljointdt)
						lh.C1 = lerp(lh.C1, lh0 * angles(rad(clamp(yrot3, -15, 15)), rad(clamp(-yrot3, -12.5, 12.5)), 0), globaljointdt)
						rh.C1 = lerp(rh.C1, rh0 * angles(rad(clamp(-yrot3, -15, 15)), rad(clamp(-yrot3, -12.5, 12.5)), 0), globaljointdt)
					end
				end

				if EffectsEnabled and AuraObject and isA(AuraObject, "BasePart") then
					if dist < 1024 then
						if AuraObjectPositionType == "Raycast" then
							if Raycast and AuraObject.ClassName ~= "Folder" then
								AuraObject.Position = Raycast.Position
								--AuraObject.Orientation = v3(0, RootPart.Orientation.Y, 0) -- NO. 
							end
						end

						if AuraObjectColorSync then
							local col = UIColor1.Value
							for _, v in pairs(getDescendants(AuraObject)) do
								if isA(v, "ParticleEmitter") then
									v.Color = cs(col)
									v = nil
								end
							end
						end
					end
				end
			end
		end))

		local framed=0
		local V0=0
		local V1=0
		inse(loop_Table, connect(RenderStepped, function(delta)
			framed=framed+delta
			if framed > ColorFlashRate then
				framed=0

				if CustomColorFlash then
					V0 = V0 + 1
					V1 = V1 + 1

					if (V0 and V1) > (Cycle0 or Cycle1) then
						V0 = 0
						V1 = 0
					end

					local CurColor1, CurColor2 = CustomColorFlashValues.Main[V0], CustomColorFlashValues.Sub[V1]
					if (CurColor1 and CurColor2) then
						local cur_cs=cs(CurColor1)
						if not AdvancedWingsEnabled then
							local Small=Wings.Rings.Small
							Small.Color = CurColor1
							Small.Glow.Color = CurColor1
							Small.A.Glow.Color = cur_cs
							Small.A.ringg.Color = cur_cs
							
							ColorWings(Wings, CurColor1, CurColor1)
						else
							for _, v in pairs(CDAdvancedWingTable) do
								local Small=v.Wings.Rings.Small
								Small.Color = CurColor1
								Small.Glow.Color = CurColor1
								Small.A.Glow.Color = cur_cs
								
								ColorWings(v.Wings, CurColor1, CurColor1)
							end
						end

						UIColor1.Value=CurColor1
						CoreOut.Color=CurColor1
						
						ChangeTextColor(textLabel, CurColor1, CurColor2)
					end
				end
			end
		end))

		local iidx = 0
		inse(loop_Table,connect(Heartbeat, function(delta)
			if TextShakeEnabled then
				iidx = iidx + delta
				if iidx >= TextShakeRate then
					textLabel.Rotation = rand(-TextShakeIntensity, TextShakeIntensity)
					billBoard.StudsOffsetWorldSpace = v3(rand(-TextShakeIntensity, TextShakeIntensity)/10, TextBoardYLevel + rand(-TextShakeIntensity, TextShakeIntensity)/10,0)
					iidx = 0
				end		
			end
		end))

		local tdt=0
		inse(loop_Table, connect(Heartbeat, function(deltaTime)
			local RandomFlash = (RandomColorFlashMain or RandomColorFlashSub)
			if (RandomFlash or CustomColorFlash) then
				tdt = tdt + deltaTime
				if tdt >= ColorFlashRate then
					if RandomFlash then
						if RandomColorFlashMain then
							Color1.Value=c3(rand(0, 255)/255, rand(0, 255)/255, rand(0, 255)/255)
						end
						if RandomColorFlashSub then
							Color2.Value=c3(rand(0, 255)/255, rand(0, 255)/255, rand(0, 255)/255)
						end

						ChangeTextColor(textLabel, Color1.Value, Color2.Value)

						local Color2V = Color2.Value
						if (LeftWingRandomColorFlashSync and RightWingRandomColorFlashSync) then
							UIColor1.Value=Color2V
							ColorWings(Wings, Color2V, Color2V)
							CoreOut.Color=Color2V
						else
							local RColor, LColor = RightWingColor, LeftWingColor

							if LeftWingRandomColorFlashSync then
								LColor = Color2V
							end
							if RightWingRandomColorFlashSync then
								RColor = Color2V
							end

							UIColor1.Value=Color2V
							ColorWings(Wings, LColor, RColor)
							CoreOut.Color=Color2V
						end

						local colcs=cs(Color2V)
						local Small=Wings.Rings.Small
						Small.A.ringg.Color=colcs
						Small.Color=Color2V
						Small.Glow.Color=Color2V
						Small.A.ringg.Color=colcs
						Small.A.Glow.Color=colcs
					end


					tdt = 0
				end
			end
		end))

		local rdelta=0
		inse(loop_Table, connect(Heartbeat, function(delta)
			rdelta = rdelta + delta
			if rdelta >= (1/60) then
				if RainbowMainEnabled or RainbowSubEnabled then
					local hue = tick() % 3.5 / 3.5
					RColor = hsv(hue, 1, 1) 

					if RainbowMainEnabled then
						Color1.Value = RColor
					end

					if RainbowSubEnabled then
						Color2.Value = RColor
					end

					CoreOut.Color = RColor
					ChangeTextColor(textLabel, Color1.Value, Color2.Value)

					if (LeftWingRainbowSync and RightWingRainbowSync) then
						ColorWings(Wings, RColor, RColor)

						local rcolc = cs(RColor)
						local Small = Wings.Rings.Small
						Small.Color = RColor
						Small.Glow.Color = RColor
						Small.A.ringg.Color = rcolc
						Small.A.Glow.Color = rcolc
					else
						local RColor2 = LeftWingColor
						local LColor = RightWingColor

						if LeftWingRainbowSync then
							LColor = RColor
						end

						if RightWingRainbowSync then
							RColor2 = RColor
						end

						UIColor1.Value = RColor ColorWings(Wings, LColor, RColor2)

						local rcolc = cs(RColor)
						local Small = Wings.Rings.Small
						Small.Color = RColor
						Small.Glow.Color = RColor
						Small.A.Glow.Color = rcolc
						Small.A.ringg.Color = rcolc
					end

					if UISyncRainbowMain then
						UIColor1.Value = RColor
					end

					if UISyncRainbowSub then
						UIColor2.Value = RColor
					end
					
					hue = nil
				end

				rdelta=0
			end
		end))
		
		inse(loop_Table, connect(cur_mod.Changed, function(value)
			if not value then
				value = cur_mod_2.Value
			end
			
			if isA(value, "ModuleScript") and value then
				local mod=require(value)
				update(mod)
				mod = nil
			end
			
			value = nil
		end))

		local function ClearOnDeath()
			local a, b = pcall(function()
				if AuraObject and AuraObject ~= Auras and isA(AuraObject, "BasePart") then
					AuraObject:Destroy()
					AuraObject = nil
				end
				
				for i=1, #loop_Table do
					loop_Table[i]:Disconnect()
					loop_Table[i] = nil
				end
				
				for i=1, #AdvancedModeConnections do
					AdvancedModeConnections[i]:Disconnect()
					AdvancedModeConnections[i] = nil
				end

				for i=1, #Bracelets do
					Bracelets[i][1]:Destroy()
					Bracelets[i] = nil
				end
				
				if Wings then
					clear(Wings)
				end

				ClearAllChildren(wingStorage)
				ClearAllChildren(modelStorage)
				ClearAllChildren(tempAuras)
				
				clear(CDAdvancedWingTable)
				clear(loop_Table)
				clear(AdvancedModeConnections)
				
				destroy(child)
			end)
		end

		once(Character.Destroying, ClearOnDeath)
		once(Player.CharacterAdded, ClearOnDeath)
		once(child.Destroying, ClearOnDeath)

		inse(loop_Table, connect(Players.PlayerRemoving, function(LeavingPlayer)
			if LeavingPlayer == Player then
				for _, v in pairs(loop_Table) do
					disconnect(v)
					v=nil
				end

				clear(loop_Table)
			end
		end))
	
		if TailWagEnabled then
			for _, v in pairs(getChildren(Character)) do
				if isA(v, "Accessory") then
					local ld = lower(v.Name)
					if find(ld, "tail") or find(ld, "floof_cube") then
						TailMotor = ffcoc(v.Handle, "Weld")
						if TailMotor.Part1.Name == "Head" then TailMotor = nil break end --it was detecting ponytails lol
						TailC1 = TailMotor.C1
						break
					end
				end
			end
		end

		modelStorage.Parent = child
		modelStorage.Name = "modelStorage"
		wingStorage.Name = "wingStorage"

		Core.Parent = child
		RootPart.CustomPhysicalProperties = prop

		if cur_mod.Value then
			update(require(cur_mod.Value))
		end
	end
end

connect(uis:GetPropertyChangedSignal("MouseBehavior"), function()
	if uis.MouseBehavior == lockCenter then
		ShiftLock = true
	else
		ShiftLock = false
	end
end)

Animate(Storage:WaitForChild(LocalPlayer.Name, 9e9))

connect(Storage.ChildAdded, function(child)
	if child.Name == LocalPlayer.Name then
		if not firstRan then
			Animate(child)
		end
	else
		Animate(child)
	end
end)

for i, v in pairs(getChildren(Storage)) do
	if v.Name ~= LocalPlayer.Name and v.Name ~= "ShopDummy" then
		print(5)
		Animate(v)
	end
end

connect(RenderStepped, function()
	globalsine = clk()
end)

sp(function()
	while true do
		tw(6)
		screenWidth = Camera.ViewportSize.X
		screenHeight = Camera.ViewportSize.Y
		PlayerCount = #getChildren(Players)
	end
end)

if workspace.Models:FindFirstChild("Time") then
	local Options = {
		["Night"] = 0,
		["Day"] = 14,
		["Sunset"] = 18,
		["Cycle"] = 0,
	}

	local Cycle = false
	local Board = workspace.Models.Time
	local SurfaceGui = Board.SurfaceGui

	local Scroller = SurfaceGui.Holder.ScrollingFrame

	for _, v in pairs(getChildren(Scroller)) do
		if isA(v, "TextButton") then
			connect(v.MouseButton1Down, function()
				local Name=v.Name
				Cycle = false
				if Options[Name] then
					if Name ~= "Cycle" then
						normalTween(Lighting, sine, dir.InOut, 1, {ClockTime=Options[Name]})
					else
						Cycle = true
					end
				end
			end)
		end
	end
end

tw(1)

firstRan = false