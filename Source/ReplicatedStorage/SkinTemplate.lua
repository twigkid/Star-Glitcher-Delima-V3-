local ws, gm = workspace, game
local ffc, ffcoc, wfc = ws.FindFirstChild, ws.FindFirstChildOfClass, ws.WaitForChild
local ReplicatedStorage = ffcoc(gm, "ReplicatedStorage")
local ud2=UDim2.new

local System = ReplicatedStorage.System
local Animations = System.Animations
local Lyric = System.Lyrics
local Spectrum, Origin = Animations.Modes.Spectrum, Animations.Modes.Origin
local Fonts, c3, c3RGB = Enum.Font, Color3.new, Color3.fromRGB
local Models = System.Models
local Auras = System.Auras
local Attacks = System.Attacks
local Phases = System.Phases
local Intros = System.Intro
local Parents = System.Modes

local cf, angles, rad, nr, ns, cs, csk, nsk, v3 = CFrame.new, CFrame.Angles, math.rad, NumberRange.new, NumberSequence.new, ColorSequence.new, ColorSequenceKeypoint.new, NumberSequenceKeypoint.new, Vector3.new

local Mode = {
	IsSub = false,
	ParentMode = Parents.Spectrum.Main.Mayhem,
	
	ModeName = "Name",
	SubText = "SubText",
	
	ModeFont = Fonts.Arcade,
	TextBoardSize = ud2(25.5, 0, 4, 0),
	TextBoardOffset = v3(0, 0, 0),
	TextBoardAnimationSpeed = 1.85,
	TextBoardAnimationOffset = 6,
	TextBoardXMovement = 0.8,
	TextBoardRotation = 5,
	TextBoardYLevel = 5,
	--ModeFontAdvanced = Font.new("rbxasset://fonts/families/RomanAntique.json"),

	AutoUIColor = false,
	UIColor1 = c3(1, 1, 1),
	UIColor2 = c3(0.5, 0, 0),
	
	MainColor1 = c3(1, 1, 1),
	MainColor2 = c3(0.5, 0.5, 0.5),
	ReactiveColors = false,
	
	LeftWingColor = c3(1, 1, 1),
	RightWingColor = c3(1, 1, 1),

	--LeftWingColor2 = c3(213, 115, 61), -- ONLY USED WITH MODEL WINGS
	--RightWingColor2 = c3(213, 115, 61), -- ONLY USED WITH MODEL WINGS

	WalkSpeed = 24,
	RunSpeed = 150,
	JumpPower = 50,
	
	WeldOrder = 0,
	WingModel = Models.WingSEP,
	RingModel = Models.Ring,

	WingAnimationSpeedMultiple = 1,
	SineWingAnimationSpeed = 2,
	SineWingAnimationOffset = 1.75,
	WingAnimation = Animations.Wings.Rotational,
	CustomWingColorEnabled = false,
	CustomWingColorTable = {
		Left = {};
		Right = {};
	};
	
	WingSize = v3(0.03, 2.9, 0.9),

	ReactiveWings = false,
	RingTable = {Enabled = {Small = true, Large = false}, SmallSize = v3(0.1, 2.112, 2.112), LargeSize = v3(.14, 3.2, 3.2), SmallCFrame = cf(-1.5, -0.65, 0), LargeCFrame = cf(-3, -1.45, 0), SmallColor = c3(1, 1, 1), LargeColor = c3(1, 1, 1)};

	UnlockedWings = true,
	UnlockedCount = 6,
	
	LeftWingCount = 6,
	RightWingCount = 6,
	LeftWingEnabled = true,
	RightWingEnabled = true,
	
	MoveAnimation = Animations.Movement.Float.Float,
	SprintAnimation = Animations.Movement.Float.Sprint,
	Animation = Animations.Skins.Spectrum.Main.Detonator,
	JumpAnimation = Animations.Movement.Walk.Jump,
	FallAnimation = Animations.Movement.Walk.Fall,
	YLevelEnabled = true,
	YLevel = 2.75,
	
	SoundBPM = 0,
	SoundPitch = 1,
	StartPos = 0,
	SoundID = "rbxassetid://",
	Lyrics = {Enabled = true, LyricsType = "V3", ModulePath = Lyric.Detonator};
	SongArtist = "",
	AlbumCover = "",
	SongTitle = "",
	Album = "",
	
	TextShakeRate = (1/30),
	TextShakeEnabled = false,
	TextShakeIntensity = 5,
	TextShakeSpeed = 120,

	UIShakeEnabled = false,
	UIShakeIntensity = 0,
	UIShakeSpeed = 0,

	
	UISlantedLineSpeedDivider = 20,
	UISlantedLineRotation = 0,
	UISlantedLineSpeed = 0,

	ColorFlashRate = (1/30), -- Per second

	RandomColorFlashMain = false,
	RandomColorFlashSub = false,

	UIColorSyncReversed = true,
	UISyncRandomColorFlashMain = false,
	UISyncRandomColorFlashSub = true,

	CustomColorFlash = false,
	CustomColorFlashValues = {
		Main = {},
		Sub = {},
	};

	WingCustomColorFlashEnabled = false,
	WingCustomColorFlashValues = {
		Left = {
			Main = {},
			Sub = {},
		},
		
		Right = {
			Main = {},
			Sub = {},
		},
	};
	
	TextGlitchRate = (1/30), -- per second
	TextGlitchEnabled = false,
	TextGlitchValues = {
		
	};
	
	CameraShakeDistance = 150,
	CameraShakeEnabled = false,
	CameraShakeIntensity = 1,
	
	EffectsEnabled = false,
	AuraObjectPositionType = "Raycast",
	AuraObject = Auras,

	SmokeColor = c3(1, 1, 1),
	SmokeColorSync = false,
	SmokeEnabled = false,
	SmokeDrag = 5,

	
	PhasesEnabled = false,
	PhaseModule = Phases,
	
	IntroEnabled = false,
	IntroModule = Intros,
	
	Creator = "None",

	QuotesEnabled = true,
	QuotesTable = {
		[1] = {
			Text = "Quote",
			Animated = true,
			Animation = Animations.Quotes.Wave,
			AnimationSpeedMultiplier = 1, 
			
			TextColor3 = c3(1, 1, 1),
			TextStrokeColor3 = c3(.5, 0, 0),
			
			Lifetime = 3,
			TextDelay = .01,
			
			TextFont = Enum.Font.Sarpanch,
			FontFace = nil,
		}
	},
}

return Mode