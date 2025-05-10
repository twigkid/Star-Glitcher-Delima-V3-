-- StarterCharacterScripts

repeat task.wait() until game.Loaded
task.wait(1/60)

local rad = math.rad
local rand = math.random
local clamp = math.clamp
local ceil = math.ceil
local tw = task.wait
local sp = task.spawn

local clk = os.clock
local sine = math.sin

local ffcoc = workspace.FindFirstChildOfClass
local ffc = workspace.FindFirstChild
local wfc = workspace.WaitForChild

local Style = Enum.EasingStyle
local Dir = Enum.EasingDirection

local Remotes = script.Remotes
local cs = ColorSequence.new
local Angles = CFrame.Angles
local lower = string.lower
local IsA = workspace.IsA
local clear = table.clear
local inse = table.insert
local ins = Instance.new
local v3 = Vector3.new
local kc = Enum.KeyCode
local sub = string.sub
local cf = CFrame.new
local ud2 = UDim2.new
local sub = string.sub
local c3 = Color3.new
local prs = pairs

local Players = game.Players

local Sine = Style.Sine
local Linear = Style.Linear
local Elastic = Style.Elastic
local Exponential = Style.Exponential

local In = Dir.In
local Out = Dir.Out
local InOut = Dir.InOut

local br = false

local function getLimb(Character: Model, Name: string)
	local l:BasePart=Character:FindFirstChild(Name,true)
	return l
end

local function getJoint(Limb: BasePart, Name: string)
	local l:Motor6D=Limb:FindFirstChild(Name,true)
	return l
end

local function config(part: BasePart, value: boolean)
	part.Anchored=not value
	part.CanCollide=value 
	part.CanTouch=value 
	part.CanQuery=value
	part.Massless=value
end

local Players = game.Players

local LocalPlayer = Players:GetPlayerFromCharacter(script.Parent)
local Character = LocalPlayer.Character

local PlayerGui = LocalPlayer.PlayerGui
local UI = PlayerGui.UI

local Torso, LeftArm, RightArm, LeftLeg, RightLeg, Head, RootPart = getLimb(Character, "Torso"), getLimb(Character, "Left Arm"), getLimb(Character, "Right Arm"), getLimb(Character, "Left Leg"), getLimb(Character, "Right Leg"), getLimb(Character, "Head"), getLimb(Character, "HumanoidRootPart")
local ls, rs, lh, rh, nj, rj = getJoint(Torso, "Left Shoulder"), getJoint(Torso, "Right Shoulder"), getJoint(Torso, "Left Hip"), getJoint(Torso, "Right Hip"), getJoint(Torso, "Neck"), getJoint(RootPart, "RootJoint")
local Humanoid = ffcoc(Character, "Humanoid")

local RunService = ffcoc(game, "RunService")
local TweenService = ffcoc(game, "TweenService")
local ReplicatedStorage = ffcoc(game, "ReplicatedStorage")

local Heartbeat = RunService.Heartbeat
local Stepped = RunService.Stepped

local System = ReplicatedStorage.System

local Modules = System.Modules
local Modes = System.Modes
local Skins = System.Skins
local Misc = Modules.Misc

local Tweening = Modules.Tweening
local Tween = require(Tweening.Tween).normalTween
local SoundModule = require(Modules.Sound.Sound)

local Storage = ins("Folder", workspace.Storage)Storage.Name = LocalPlayer.Name
local BillboardGui = ins("BillboardGui",Torso)BillboardGui.Name="NameLabel"BillboardGui.Size = ud2(26, 0, 4.5, 0)BillboardGui.Enabled=false BillboardGui.StudsOffsetWorldSpace = v3(0,0,0)BillboardGui.Brightness=2
local TextLabel = ins("TextLabel", BillboardGui)TextLabel.Size=ud2(1,0,1,0)TextLabel.BackgroundTransparency=1 TextLabel.TextScaled=true TextLabel.TextStrokeTransparency=0 TextLabel.RichText=true
local MSound = ins("Sound", Torso)MSound.Looped=true MSound.Volume=0.5 MSound.Name="Theme" MSound.Playing = true MSound.RollOffMaxDistance=50
local current_mod=ins("ObjectValue",Storage)
current_mod.Name="cur_mod"
local current_mod_2=ins("ObjectValue",Storage)
current_mod_2.Name="cur_mod_2"
local Sound = ins("Sound",RootPart)Sound.Volume=0.5 Sound.Looped=true

local Effects = System.Effects

local Play = Sound.Play
local Emit = Effects.SwitchV2.Attachment.sub.Emit
local FireClient = Remotes.ResetLyrics.FireClient
local GetState = ins("Humanoid").GetState
local GetChildren = workspace.GetChildren
local GetDescendants = workspace.GetDescendants
local Destroy = workspace.Destroy

local Side = System.Sides.Spectrum
local NewSoundEffect = SoundModule.NewSoundEffect
local FireAllClients = Remotes.Attacks.FireAllClients
local OnAttack = ReplicatedStorage.Players.Remotes.OnAttack

local Vars = script.Vars
local Sprint = Vars.Sprint
local VWalkSpeed = Vars.WalkSpeed
local VRunSpeed = Vars.RunSpeed
local VLyrics = Vars.Lyrics

local Motor=ins("Motor6D")
local Base=ins("Part")
local FHum=ins("Humanoid")

local SwitchX = Effects.switch:Clone()
SwitchX = SwitchX.par SwitchX.Parent = Torso

local BodyTable = {LeftArm=LeftArm, RightArm=RightArm, LeftLeg=LeftLeg, RightLeg=RightLeg, Torso=Torso, Head=Head, RootPart=RootPart, Humanoid=Humanoid}
local JointTable = {Motor, Motor, Motor, Motor, Motor, Motor}

local cf0 = cf()
local c30 = c3()
local v30 = v3()
local c31 = c3(1, 1, 1)

local WalkSpeed = 0
local RunSpeed = 0
local AttackCombo=1

local curmod
local attackComboHighest

local PhaseEnabled=false
local RepeatPhase=false
local m1_debouce=false
local Debounce=false
local cur_phase=nil
local Attack=false
local dead=false
local sw=false

local attackDebounce={}
local connections={}
local currentAttacks={}
local temp_connections={}
local PhaseTable={}
local CurrentM1Attacks={}
local blacklist = {
	kc.Unknown,
	kc.Slash,
	kc.W,
	kc.A,
	kc.D,
	kc.S,
	"W",
	"A",
	"S",
	"D",
	"Space",
	"Slash",
	"Unknown"
}

sp(function()
	tw(2)
	
	if Head.Mesh.MeshId == "rbxassetid://14563696956" then
		Head.Mesh.Offset = v3(0, .3, 0)
	end
end)

local function truncate_string(s, length)
	length = length or 20
	if #s > length then
		return sub(s,1, length) .. "..."
	else
		return s
	end
end

local clearsp = false

local function Textsp(txt: string, textobject: Instance, t: number)
	sp(function()
		if textobject:IsA("TextLabel") or textobject:IsA("TextButton") then
			for i = 1, #txt do
				if br then
					break
				end
				
				tw(t or 0.02)
				textobject.Text = sub(txt, 1, i)
			end
		elseif textobject:IsA("StringValue") then
			for i = 1, #txt do
				
				if br then
					break
				end
				
				tw(t or 0.02)
				textobject.Value = sub(txt, 1, i)
			end
		end
	end)
end

local skinMain = require(ReplicatedStorage.MainModules.SkinMain)

local function GetMouse()
	local Value = cf(0,0,0)
	
	FireClient(Remotes.GetMouse, LocalPlayer)
	local RBXConnection = Remotes.GetMouse.OnServerEvent:Connect(function(Player, Hit)
		if Player == LocalPlayer then
			Value = Hit
		end
	end)

	repeat tw() until Value ~= cf(0,0,0)
	
	RBXConnection:Disconnect() 
	RBXConnection = nil
	
	return Value
end

local function Switch(ModeModule: ModuleScript, phase)
	if current_mod_2.Value ~= ModeModule and not Debounce then
		for _, v in prs(temp_connections) do
			v:Disconnect()
			v=nil
		end

		Remotes.OnSwitch:FireClient(LocalPlayer)
		
		clear(temp_connections)
			br = true
			local Mode = require(ModeModule)
			local SkinModule = skinMain.getEquippedSkin(LocalPlayer, Side.Name, ModeModule.Name)

			RootPart.Anchored = false			

			local Skin = Mode
			if SkinModule == nil then
				Skin = Mode
			else
				Skin = require(SkinModule)
			end
			
			local Color1, Color2 = Skin.MainColor1, Skin.MainColor2
			local ModeName, SubText = Skin.ModeName, Skin.SubText
			local Walk, Run = Mode.WalkSpeed, Mode.RunSpeed
			local SongArtist, SongTitle = Skin.SongArtist, Skin.SongTitle
			local Lyrics = Skin.Lyrics
			local Enabled = Lyrics.Enabled
			
			local ChangeSong = true
			if Skin.IntroEnabled then
				if Skin.IntroModule:IsA("ModuleScript") then
					local IntroModule = require(Skin.IntroModule)
					if IntroModule.TransitionMode then
						SwitchPhase(IntroModule.TransitionMode,{TransistionEffect = false, UpdateAppearance = IntroModule.UpdateAppearance or true})
					end
					
					if IntroModule.ChangeSong then
						MSound.SoundId = Skin.SoundID
						MSound.TimePosition = Skin.StartPos
						MSound.Volume = Skin.SoundVolume or 0.5
						MSound.PlaybackSpeed = Skin.SoundPitch or 1

						Play(MSound)
						
						if Skin.AlbumCover then
							Vars.UI.AlbumCover.Value = Skin.AlbumCover
						else
							Vars.UI.AlbumCover.Value = "0"
						end
						ChangeSong = false
						--repeat task.wait() until MSound.IsLoaded --decided this is a bad idea
					end
					
					RootPart.Anchored = true
					Debounce = true
					if IntroModule.PauseAnim then ReplicatedStorage.Players.Remotes.OnIntro:FireClient(LocalPlayer, IntroModule.Duration) end
					IntroModule.Intro({Sound = MSound, UI = UI, Player = LocalPlayer, Character = Character, Billboard = BillboardGui, Vars = Vars, VFXFolder = Storage, Color1 = Color1, Color2 = Color2})
					RootPart.Anchored = false
					Debounce = false
				end
			end

			current_mod.Value = SkinModule
			current_mod_2.Value = ModeModule
			curmod = ModeModule

			if Mode.CustomM1Attacks then
				CurrentM1Attacks=Mode.CustomM1Attacks
			else
				CurrentM1Attacks={System.Attacks.M1_Test}
			end
			
			attackComboHighest=#CurrentM1Attacks

			PhaseTable=nil
			PhaseEnabled = Skin.PhasesEnabled
			
			if IsA(Skin.PhaseModule, "ModuleScript") then
				local rqd=require(Skin.PhaseModule)
				PhaseTable=rqd[2]
				RepeatPhase=rqd[1]
			end
			
			cur_phase=Skin.PhaseModule
			
			VLyrics.LyricsEnabled.Value = Enabled
			VLyrics.LyricsPath.Value = Lyrics.ModulePath
			VLyrics.LyricsType.Value = Lyrics.LyricsType
			
			if Sprint.Value then
				Humanoid.WalkSpeed = Run
			else
				Humanoid.WalkSpeed = Walk
			end
			
			VWalkSpeed.Value = Walk
			VRunSpeed.Value = Run

			Humanoid.JumpPower = Mode.JumpPower

			VWalkSpeed.Value = Walk
			VRunSpeed.Value = Run
			
			WalkSpeed, RunSpeed = Walk, Run
			
			BillboardGui.Size = Skin.TextBoardSize
			BillboardGui.StudsOffsetWorldSpace = Skin.TextBoardOffset
			
			if ChangeSong == true then
				MSound.SoundId = Skin.SoundID
				MSound.TimePosition = Skin.StartPos or 0
				MSound.Volume = Skin.SoundVolume or 0.5
				MSound.PlaybackSpeed = Skin.SoundPitch or 1

				Play(MSound)
			end
			ChangeSong = nil

			br = false

			TextLabel.TextColor3=Color1 TextLabel.TextStrokeColor3=Color2
			TextLabel.Font=Skin.ModeFont

			if Skin.ModeFontAdvanced then
				TextLabel.FontFace = Skin.ModeFontAdvanced
			end

			NewSoundEffect(6875009415, 1, .95 + rand(-1, 1) / 10, true, Torso)
			Tween(Vars.Color1, Sine, Out, .5, {Value = Color1}) Tween(Vars.Color2, Sine, Out, .5, {Value = Color2})			

			if Color2 == c30 then
				SwitchX.smoke.LightEmission=0
			else
				SwitchX.smoke.LightEmission=1
			end
			
			if Sprint.Value then
				Humanoid.WalkSpeed = Run
			else
				Humanoid.WalkSpeed = Walk
			end
			
			local col=cs(Color1)
			local col2=cs(Color2)
			SwitchX.slash.Color = col
			SwitchX.smoke.Color = col2
			SwitchX.beam.Color = col
			SwitchX.force.Color = col
			
			for i, v in prs(GetDescendants(SwitchX)) do
				if IsA(v,"ParticleEmitter") and v.Name ~= "force" then
					Emit(v,15)
				elseif IsA(v,"ParticleEmitter") and v.Name == "force" then
					Emit(v,3)
				end
			end
		
			FireClient(Remotes.ResetLyrics, LocalPlayer)
			FireClient(Remotes.AttackTable, LocalPlayer, Mode.AttackModules)

			clear(currentAttacks)
			clear(attackDebounce)
			
			for _, v in prs(Mode.AttackModules) do
				inse(currentAttacks, v)
				inse(attackDebounce, {Module=v.Module,Time=v.DebounceTime,CurrentTime=0, Ready=true})
			end
			
			FireClient(Remotes.Attacks, LocalPlayer, currentAttacks)
			
			local looped=false
			if PhaseEnabled then
				local function Run()
					sp(function()
						local mod=cur_phase
						while true do
							tw(.1)
							if cur_phase == mod then
								local Pos=MSound.TimePosition
								for i,v in prs(PhaseTable) do
									if looped and not RepeatPhase then
										break
									end
									if Pos > v.Start and Pos < v.Start + .6 then
										SwitchPhase(v.Module, v)
									end
								end
							else
								break
							end
						end
					end)
				end
				
			inse(temp_connections, MSound.DidLoop:Connect(function()
				if RepeatPhase then
					tw(.1)
					Run()
				end
				looped=true
			end))
		
			Run()
		end

		Debounce = true tw(.1) Debounce=false
	end
end

function SwitchPhase(Module: ModuleScript, PhaseTable)
	if current_mod.Value ~= Module and not Debounce then
		local Success, Output = pcall(function()
			RootPart.AssemblyLinearVelocity = v30
			RootPart.AssemblyAngularVelocity = v30

			current_mod.Value = Module
			--curmod = Module --messes with mode switching

			local Mode = require(Module)
			local Color1 = Mode.MainColor1
			local Color2 = Mode.MainColor2
			
			local ModeName = Mode.ModeName
			local SubText = Mode.SubText
			
			Textsp(ModeName, TextLabel, .03)

			RootPart.Anchored = Mode.Anchored
			
			if RootPart.Anchored then
				RootPart.AssemblyLinearVelocity = v30
				RootPart.AssemblyAngularVelocity = v30
			end
			
			if PhaseTable.UpdateAppearance == true then
				TextLabel.TextColor3=Color1 
				TextLabel.TextStrokeColor3=Color2
				TextLabel.Font = Mode.ModeFont

				BillboardGui.Size = Mode.TextBoardSize
				BillboardGui.StudsOffsetWorldSpace = Mode.TextBoardOffset

				if Mode.ModeFontAdvanced then
					TextLabel.FontFace = Mode.ModeFontAdvanced
				end

				Tween(Vars.Color1, Sine, Out, .5, {Value = Color1}) Tween(Vars.Color2, Sine, Out, .5, {Value = Color2})	
			end	
			
			if PhaseTable.TransistionEffect then
				if PhaseTable.Effect == System.Effects or PhaseTable.Effect == System.Effects.switch then
					NewSoundEffect(6875009415, 1, .95 + rand(-1, 1) / 10, true, Torso)
					
					if Color2 == c30 then
						SwitchX.smoke.LightEmission=0
					else
						SwitchX.smoke.LightEmission=1
					end
					local col=cs(Color1)
					local col2=cs(Color2)
					SwitchX.slash.Color = col
					SwitchX.smoke.Color = col2
					SwitchX.beam.Color = col
					SwitchX.force.Color = col

					for i, v in prs(GetDescendants(SwitchX)) do
						if IsA(v,"ParticleEmitter") and v.Name ~= "force" then
							Emit(v, 1)
						elseif	IsA(v,"ParticleEmitter") and v.Name == "force" then
							Emit(v, 3)
						end
					end

					local UIColor1Value = Vars.UI.UIColor1
					local UIColor2Value = Vars.UI.UIColor2
					
					Vars.FColor1.Value = Color1
					Vars.FColor2.Value = Color2

					if not Mode.AutoUIColor then
						UIColor1Value.Value = Mode.UIColor1
						UIColor2Value.Value = Mode.UIColor2
					else
						UIColor1Value.Value = Color1
						UIColor2Value.Value = Color2
					end
				end
			--elseif PhaseTable.Effect:IsA("ModuleScript") then
			--	require(PhaseTable.TransistionEffect):Transition()
			elseif PhaseTable.Effect:IsA("Part") then
				local trans = PhaseTable.Effect:Clone()
				config(trans,false)
				trans.CFrame = cf(Torso.Position)
				trans.Parent = Storage
				for _,v in pairs(trans:GetDescendants()) do
					if v:IsA("ParticleEmitter") then v:Emit(v.Rate) elseif v:IsA("Sound") then v:Play() end
				end
				game.Debris:AddItem(trans,5)
				trans = nil
			end
		end)
	end
end

local Main = Modes.Spectrum.Main
local Sub = Modes.Spectrum.Sub
local Sides = System.Sides
local LastKey

inse(connections, Remotes.KeyDown.OnServerEvent:Connect(function(APlayer, Key)
	if APlayer == LocalPlayer and not blacklist[Key] then
		for _, v in prs(GetChildren(Sides)) do
			if IsA(v, "ModuleScript") then
				local x=require(v)
				local Binds = x.Binds
				local A, B
				if Binds.A and Binds.B then A, B = lower(Binds.A), lower(Binds.B) else A, B = nil, nil end

				if not (Binds.A and Binds.B) then
					if Side ~= Modes.Spectrum and x.ModeFolder == Modes.Spectrum and curmod == require(Sides:FindFirstChild(Side.Name)).StartingMode and Key == "q" and LastKey == "q" then
						x = require(Sides.Spectrum)

						Side = x.ModeFolder
						Main = Side.Main
						Sub = Side.Sub

						Switch(x.StartingMode)
						break
					elseif Side == Modes.Spectrum and x.ModeFolder == Modes.Subliminal and curmod == require(Sides:FindFirstChild(Side.Name)).StartingMode and Key == "q" and LastKey == "q" then
						x = require(Sides.Subliminal)

						Side = x.ModeFolder
						Main = Side.Main
						Sub = Side.Sub

						Switch(x.StartingMode)
						break	
					elseif lower(x.Binds) == Key and curmod == x.ParentMode then
						if not x.Locked then
							Side = x.ModeFolder
							Main = Side.Main
							Sub = Side.Sub

							Switch(x.StartingMode)
							break
						else
							for _, v in prs(x.PlayerLock) do
								if v == LocalPlayer.Name then
									Side = x.ModeFolder
									Main = Side.Main
									Sub = Side.Sub

									Switch(x.StartingMode)
									break
								end
							end
						end
						break
					end
				elseif A == LastKey and B == Key and x.ModeFolder ~= Side then 
					if (A and B) == "q" and x.Order == 1 and Side == Modes.Spectrum then
						x = require(Sides.Subliminal)

						Side = x.ModeFolder
						Main = Side.Main
						Sub = Side.Sub

						Switch(x.StartingMode)
						RootPart.Anchored=false
						break
					elseif (A and B) == "q" and x.Order ~= 0 then
						x = require(Sides.Spectrum)

						Side = x.ModeFolder
						Main = Side.Main
						Sub = Side.Sub

						Switch(x.StartingMode)
						break
					else
						if not x.Locked then
							Side = x.ModeFolder
							Main = Side.Main
							Sub = Side.Sub

							Switch(x.StartingMode)
							break
						else
							for _, v in prs(x.PlayerLock) do
								if v == LocalPlayer.Name then
									Side = x.ModeFolder
									Main = Side.Main
									Sub = Side.Sub

									Switch(x.StartingMode)
									break
								end
							end
						end
						break
					end
				end
			end
		end

		
		for i, v in prs(GetChildren(Main)) do
			if IsA(v,"ModuleScript") then
				local xv=require(v)
				if xv.Key == Key then
					Switch(v)
					break
				end
			end
		end

		for _, v in prs(GetChildren(Sub)) do
			if IsA(v,"ModuleScript") then
				local xv=require(v)
				if xv.Key == Key and xv.ParentMode == curmod then
					Switch(v)
					break
				end
			end
		end


		LastKey = Key

		for _, v in prs(currentAttacks) do
			local AKey = v.Key
			if AKey == Key  then
				for _, x in prs(attackDebounce) do
					if x.Module == v.Module and x.CurrentTime == 0 and x.Ready then
						task.spawn(function()
							x.CurrentTime=x.Time x.Ready=false
							FireClient(Remotes.Ready, LocalPlayer, v.Module, x.Ready)

							local Mouse = GetMouse()
							repeat tw() until Mouse
							FireAllClients(OnAttack, v, LocalPlayer, Mouse, workspace.Terrain)

							Attack=true
							local Module=require(v.Module)
							Module.Attack(nil, {BodyParts = BodyTable, JointTable=JointTable, Color1=Vars.Color1, Color2=Vars.Color2, MousePosition = Mouse})
							Module=nil
						end)
						
						break
					end
				end
			end
		end
	end
end))
System.Remotes.SendSprintType.OnServerEvent:Connect(function(sprinter,value)
	Vars.Sprinttoggle.Value = value
end)


inse(connections, Remotes.InputBegan.OnServerEvent:Connect(function(Player, Key)
	if Player == LocalPlayer and not blacklist[Key] then
		if Vars.Sprinttoggle.Value == false then
			if Key == kc.LeftShift then
				Sprint.Value = true
			end
		else
			if Key == kc.LeftShift then
				if Sprint.Value == false then
					Sprint.Value = true
				else
					Sprint.Value = false
				end
			end
		end
	end
end))


inse(connections, Remotes.InputEnded.OnServerEvent:Connect(function(Player, Key)
	if Player == LocalPlayer and not blacklist[Key] then			
		if Key == kc.LeftShift and Vars.Sprinttoggle.Value == false then
			Sprint.Value = false
		end
	end
end))

inse(connections, Remotes.MouseButton1Down.OnServerEvent:Connect(function(Player)
	if Player == LocalPlayer then
		if not m1_debouce then	
			for i, v in prs(CurrentM1Attacks) do
				if i == AttackCombo then
					m1_debouce=true
					
					local v={Module=v}
					local Mouse = GetMouse()
					FireAllClients(OnAttack, v, LocalPlayer, Mouse, workspace.Terrain)

					local Module = require(v.Module)
					local Kills = Module.Attack(nil, {BodyParts = BodyTable, JointTable=JointTable, Color1=Vars.Color1, Color2=Vars.Color2, MousePosition = Mouse})
					tw(.28)
					if Kills and Kills > 0 then
						local Currency = LocalPlayer.Vars:WaitForChild("Currency")
						for i=1, Kills do
							Currency.Value = Currency.Value + 100
						end
						
						Currency = nil
					end

					m1_debouce=false
					v=nil
					Module=nil	
					Mouse=nil
				end
			end
			AttackCombo=AttackCombo+1
			if (AttackCombo and attackComboHighest) then
				if AttackCombo > attackComboHighest then
					AttackCombo=1
				end
			end
		end
	end	
end))

inse(connections, Players.PlayerRemoving:Connect(function(Leaving)
	if Leaving == LocalPlayer then
		Destroy(Storage)
		for _,v in prs(connections) do
			v:Disconnect()
			v=nil
		end
		clear(connections)connections=nil
	end
end))

local function Stop()
	for i,_ in pairs(connections) do
		connections[i]:Disconnect()
		connections[i]=nil
	end
	
	clear(connections) 
	connections=nil
	
	dead=true
	Storage:Destroy() Storage=nil
	
	script.Parent=game.ServerScriptService
	script:ClearAllChildren()
	script:Destroy()
end

Humanoid.Died:Once(Stop)
LocalPlayer.CharacterAdded:Once(Stop)

tw(1)

for _, v in prs(GetDescendants(Character)) do
	if IsA(v, "BasePart") then
		v.CanCollide=false v.CanTouch=false v.CanQuery=false
	end
end

Humanoid.MaxHealth = 10000
Humanoid.Health = 10000

Vars.Parent = Storage
Humanoid.UseJumpPower = true

tw(.7)

Switch(System.Modes.Spectrum.Main.Mayhem)

sp(function()
	while true do
		tw(1)
		for _, v in prs(attackDebounce) do
			if v.CurrentTime ~= 0 then
				v.CurrentTime = v.CurrentTime - 1
			elseif not v.Ready then
				v.Ready=true
				FireClient(Remotes.Ready, LocalPlayer, v.Module, true)
			end
		end
		if dead then
			break
		end
	end
end)

local lastDamage=0
local pause=false
sp(function()
	while true do
		tw(1)
		if lastDamage > 5 then
			local Health=Humanoid.Health
			if Health < Humanoid.MaxHealth and not pause then
				Humanoid.Health=Health+80
			end
		else
			lastDamage=lastDamage+1
		end
	end
end)

local beforeHealth=Humanoid.Health
inse(connections, Humanoid.HealthChanged:Connect(function(NewHealth)
	pause=true
	
	if NewHealth < 1000 then
		MSound.Pitch = .8
	else
		MSound.Pitch = 1
	end
	
	if NewHealth < beforeHealth then
		lastDamage=0
	end
	beforeHealth=NewHealth
	pause=false
end))

BillboardGui.Enabled=true
