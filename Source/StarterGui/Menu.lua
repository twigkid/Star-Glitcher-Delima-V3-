local camera = workspace.CurrentCamera

	local ws, tw, sp = workspace, task.wait, task.spawn
	local v3=Vector3.new
	local v30=v3(0,0,0)
	local vlerp = v30.Lerp
	local clamp = math.clamp

	local ffc=ws.FindFirstChild
	local ffcoc=ws.FindFirstChildOfClass
	local wfc=ws.WaitForChild

	local cf=CFrame.new
	local angles=CFrame.Angles
	local rad, rand, clamp, ceil=math.rad, math.random, math.clamp, math.ceil
	local ins=Instance.new
	local clk, sine = os.clock, math.sin
	local sc=script
	local ud2=UDim2.new
	local v3 = Vector3.new
	local sin=math.sin
	local lerp = cf(0,0,0).Lerp
	local expon=Enum.EasingStyle.Exponential
	local kc=Enum.KeyCode
	local sine0, out, in1 = Enum.EasingStyle.Sine, Enum.EasingDirection.Out, Enum.EasingDirection.In
	local linear = Enum.EasingStyle.Linear
	local info, ts = TweenInfo.new, ffcoc(game, "TweenService")
	local floor = math.floor
	local fromRGB = Color3.fromRGB
	local c3=Color3.new
	local c31=c3(1,1,1)
	local c30=c3(0,0,0)
	local c3_1=c3(.1,.1,.1)
	local v3_0,cf0=v3(0,0,0),cf(0,0,0)
	local schar=string.char
	local isa=workspace.IsA
	local elastic=Enum.EasingStyle.Elastic
	local prs=pairs
	local clone=ws.Clone
	local create_t=ts.Create
	local destroy=ws.Destroy
	local sub=string.sub


	local ui = script.Parent
	local connect=ws.Destroying.Connect
	local once=ws.Destroying.Once
	local inse=table.insert
	local Camera=ws.CurrentCamera
	local tclear=table.clear
	local inOut=Enum.EasingDirection.InOut
	local udlerp=ud2(0,0,0).Lerp
	local cs, csk, ns, nsk = ColorSequence.new, ColorSequenceKeypoint.new, NumberSequence.new, NumberSequenceKeypoint.new

	local Player = game.Players.LocalPlayer
	local Character = Player.Character

	local PlayerGui = Player.PlayerGui
	local Camera = workspace.CurrentCamera
	local rs=game["Run Service"]
	local uis=game.UserInputService
	local ts=game.TweenService
	local tf=TweenInfo.new

	local pulsev=ui.pulse
	local pres=false
	local stop=false

	local overide=false

	local Start=ui.Start
	local song=sc.song

	uis.MouseIconEnabled = false

	ui.Enabled = true
	camera.CameraType = "Scriptable"
	camera.CFrame = cf(0,500,0)


	local function normaltween(Object: Instance, Style: Enum.EasingStyle, Direction: Enum.EasingDirection, Time:number, PropertyTable)
		local nt = ts:Create(Object, tf(Time, Style, Direction, 0, false, 0), PropertyTable)

		nt:Play() nt.Completed:Once(function()
			nt:Destroy() nt=nil
		end)
		return nt
	end

	local function pulse(rev,v,a,d)
		local t=a or .5
		local del=d or .1
		if not rev then
			normaltween(pulsev, linear, out, t, {BackgroundTransparency=0})
			tw(t+del)
			normaltween(pulsev, linear, out, t, {BackgroundTransparency=1})
		else
			normaltween(pulsev, linear, out, 0.5, {BackgroundTransparency=v})
		end
	end

	local tween

	local uielements = {}
	local camera_positions = {
		{a=cf(-1.883, 12.978, -605.27) * angles(rad(0.599), rad(180), rad(-0)),
			b=cf(-2.537, 15.423, -136.971) * angles(rad(0.599), rad(180), rad(-0))	
		},
		{
			a=cf(-137.676, 252.442, -437.2)*angles(rad(70),rad(180), rad(0)),
			b=cf(-124.935, 252.442, 98.249)*angles(rad(70),rad(180), rad(0))
		},
		{a=cf(82.758, 43.728, -171.967) * angles(rad(10.504), rad(-177.802), rad(-0)),
			b=cf(-83.776, 43.728, -165.575) * angles(rad(10.504), rad(-177.802), rad(-0))	
		},
		{a=cf(134.342, 29.123, 84.125) * angles(rad(-4.204), rad(89.394), rad(-0)),
			b=cf(136.088, 29.092, -80.735) * angles(rad(-4.204), rad(89.394), rad(-0))	
		},
		{a=cf(0.984, 16.169, -34.927) * angles(rad(1.198), rad(-179.002), rad(-0)),
			b=cf(0.959, 85.154, -36.369) * angles(rad(1.198), rad(-179.002), rad(-0))	
		},
		{a=cf(59.159, 18.178, 128.343) * angles(rad(-0.9), rad(37.017), rad(-0)),
			b=cf(113.654, 18.178, 87.253) * angles(rad(-0.9), rad(37.017), rad(-0))	
		},
		{
			a=cf(-0.199, 16.012, 108.709)*angles(rad(-0.031),rad(178.918), rad(0)),
			b=cf(0.415, 15.516, 282.803)*angles(rad(-0.031),rad(178.918), rad(0))
		},
	}

	local theme

	Camera.ChildAdded:Connect(function(child)
		if child:IsA("BasePart")  then
			child.Parent = game.ReplicatedStorage
			table.insert(uielements, child)
		end
		if child:IsA("Sound") then
			theme=child
			child.Volume=0
		end
	end)

	pulsev.BackgroundTransparency = 0
	repeat tw(1) until game.Loaded
	tw(2)
	uis.MouseIconEnabled = false
	PlayerGui.UI.Enabled=false
	pulse(true,1)

	song:Play()
	theme.Pitch=0
	uis.MouseIconEnabled=true

	local Bot, Top = ui.Bot, ui.Top
	local bot_1, bot_2 = Bot.bot, Top.bot
	local sbot_1, sbot_2 = Bot.bot2, Top.bot2

	local function random_pos()
		while true do
			if stop then
				break
			end
			for _, v in pairs(camera_positions) do
				if stop then
					break
				end
				local a,b=v.a,v.b
				Camera.CFrame=a
				pulsev.ZIndex=1
				tween=normaltween(Camera, linear, out, 10, {CFrame = b})
				repeat tw(9.3) until tween.Completed
				if stop then
					break
				end
				if not overide then
					pulse()
				else
					tw(.6)
				end
			end
			tw()
		end
	end

	local function finish()
		for _, v in pairs(uielements) do
			v.Parent = workspace
		end
		if tween then
			tween:Cancel()
		end
		Player.Vars.SkinShopOpen.Value=false
		theme.TimePosition=0
		normaltween(theme, linear, out, 1, {Pitch=1,Volume=1})
		pres=true
		Camera.CameraType="Custom"
		PlayerGui.UI.Enabled=true
		for _, v in prs(sc.Parent:GetChildren()) do
			if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("ImageLabel") or v:IsA("Frame") and v ~= pulsev then
				v:Destroy()
			end
		end

		sp(function()
			PlayerGui.Calibration.Enabled = true
			PlayerGui.Calibration.Main.Position = ud2(0.288, 0,1.1, 0)
			
			Camera["Theme"].Volume = 1
			normaltween(PlayerGui.Calibration.Main, expon, out, 1, {Position = ud2(0.288, 0,0.378, 0)})
			tw(4)
			ui:Destroy()
		end)
	end
	script.Parent.Settings.MouseButton1Down:Connect(function()
		if 	PlayerGui.Settings.Enabled == false then
			PlayerGui.Settings.Enabled = true
		else
			PlayerGui.Settings.Enabled = false
		end

	end)
	local deb=false
	Start.MouseButton1Down:Connect(function()
		if not deb then
			deb=true
			song:Stop()
			sc.start:Play()
			Start.Text="Get Ready."
			normaltween(Top, sine0, inOut, 1.5, {Position=ud2(0, 0, -0.25,0)})
			normaltween(Bot, sine0, inOut, 1.5, {Position=ud2(0, 0, 1.15,0)})
			pulsev.BackgroundColor3=c3(1,1,1)
			pulsev.BackgroundTransparency=0
			pulsev.ZIndex=4
			pulse(true,1)
			sp(function()
				repeat tw(.1) Start.BorderColor3=c3(1,1,1) 	Start.TextStrokeColor3=c3(1,1,1) tw(.1) Start.BorderColor3=Color3.fromRGB(85, 0, 255) Start.TextStrokeColor3=Color3.fromRGB(85, 0, 255)
				until pres
			end)
			ui.SG.Text="[ Good Luck! ]"
			for _, v:Instance in prs(ui:GetChildren()) do
				if v:IsA("TextLabel") or v:IsA("TextButton") and v ~= Start then
					local glow=v:FindFirstChild("glow")
					local Pos=v.Position
					local X,Y=Pos.X,Pos.Y
					normaltween(v, expon, in1, 1.2, {Position=ud2(-1, 0, Y.Scale, 0), Rotation=-25})
					normaltween(glow.Value, expon, in1, 1.2, {Position=ud2(-1, 0, Y.Scale, 0), Rotation=-25})
				end
			end
			normaltween(Start, expon, inOut, .8, {Position=ud2(0.376, 0,0.468, 0)})
			normaltween(Start.glow.Value, expon, inOut, .8, {Position=ud2(0.249, 0,0.408, 0)})
			sp(function()
				tw(.75)
				normaltween(Start.glow.Value, sine0, inOut, 1, {ImageTransparency=1})
				normaltween(Start, expon, inOut, 1, {Position=ud2(0.376, 0,0.5185, 0),Size=ud2(0.247, 0,0, 0)})
				tw(1)
				normaltween(Start, expon, inOut, 1, {Position=ud2(0.4995, 0,0.5185, 0),Size=ud2(0, 0,0, 0)})
			end)
			overide=true
			tw(2.5)
			sp(function()
				for _, v:Instance in prs(ui.select:GetChildren()) do
					if v:IsA("TextLabel") or v:IsA("TextButton") then
						local glow=v:FindFirstChild("glow")
						local Pos=v.Position
						local g_Pos=glow.Value.Position
						local X,Y=Pos.X,Pos.Y
						v.Position=ud2(X.Scale,0,1.15,0)
						glow.Value.Position=ud2(X.Scale,0,1.15)
						local rot=rand(-15,15)
						v.Rotation, glow.Value.Rotation=rot,rot
						sp(function()
							tw(5.65)
							normaltween(v, expon, out, 1.5, {Position=Pos,Rotation=0})
							normaltween(glow.Value, expon, out, 1.5, {Position=g_Pos,Rotation=0})
						end)
					end
				end
				tw(5.65)
				Top.Position=ud2(0, 0, -0.25,0)
				Bot.Position=ud2(0, 0, 1.15,0)
				normaltween(Top, expon, out, 1.5, {Position=ud2(0, 0,0, 0)})
				normaltween(Bot, expon, out, 1.5, {Position=ud2(0, 0,0.96, 0)})
			end)

			pulsev.BackgroundColor3=c3(1,1,1)
			normaltween(song, linear, out, 1, {Pitch=0})
			pulse(nil,nil,1.5, 3)
			sc.modeselect_loop:Play()
			ui.select.Visible=true
			stop=false
			sp(function()
				tw(3)
				pulsev.BackgroundColor3=c3(0,0,0)
				overide=false
			end)

			local select_ui=ui.select
			local single, multi = nil, nil

			local multi_button = select_ui.Multi
			deb=false
			multi=select_ui.Multi.MouseButton1Down:Connect(function()
				if not deb then
					deb=true
					if single then
						single:Disconnect()
					end

					pulsev.BackgroundColor3=c3(1,1,1)
					sc.modeselect_loop:Stop()
					sc.start_2:Play()
					stop=true

					for _, v in prs(select_ui:GetChildren()) do
						if v ~= multi_button and v ~= multi_button.glow.Value then
							local glow=v:FindFirstChild("glow")
							if glow then
								local Pos=v.Position
								local g_Pos=glow.Value.Position
								local X,Y=Pos.X,Pos.Y
								normaltween(v, expon, in1, 1.5, {Position=ud2(X.Scale,0,1.5), Rotation = rand(-25, 25)})
								normaltween(glow.Value, expon, in1, 1.5, {Position=ud2(X.Scale,0,1.5), Rotation = rand(-25, 25)})
							end
						end
					end

					sp(function()
						repeat tw(.1) multi_button.BorderColor3=c3(1,1,1) 	multi_button.TextStrokeColor3=c3(1,1,1) tw(.1) multi_button.BorderColor3=Color3.fromRGB(85, 0, 255) multi_button.TextStrokeColor3=Color3.fromRGB(85, 0, 255)
						until pres
					end)

					sp(function()
						tw(1)
						normaltween(multi_button, expon, inOut, .8, {Position=ud2(0.376, 0,0.468, 0)})
						normaltween(multi_button.glow.Value, expon, inOut, .8, {Position=ud2(0.249, 0,0.408, 0)})
						tw(.75)
						normaltween(multi_button.glow.Value, sine0, inOut, 1, {ImageTransparency=1})
						normaltween(multi_button, expon, inOut, 1, {Position=ud2(0.376, 0,0.5185, 0),Size=ud2(0.247, 0,0, 0)})
						tw(1)
						normaltween(multi_button, expon, inOut, 1, {Position=ud2(0.4995, 0,0.5185, 0),Size=ud2(0, 0,0, 0)})
					end)

					normaltween(Top, expon, in1, 1.5, {Position=ud2(0, 0,-0.25, 0)})
					normaltween(Bot, expon, in1, 1.5, {Position=ud2(0, 0,1.15, 0)})

					pulsev.BackgroundTransparency=0
					pulsev.ZIndex=4
					normaltween(pulsev, linear, out, 0.5, {BackgroundTransparency=1})
					tw(2)
					pulse(nil,nil,1.5, 3)
					pulsev.BackgroundColor3 = c3(1,1,1)
					finish() 
				end
			end)

			Start:Destroy()
		end
	end)

	for _, v in pairs(ui:GetDescendants()) do
		if v:IsA("TextButton") then
			v.MouseEnter:Connect(function()
				normaltween(v, sine0, out, .2, {TextStrokeColor3=c3(1,1,1),BorderColor3=c3(1,1,1)})
				normaltween(v.glow.Value, sine0, out, .2, {ImageColor3=c3(1,1,1)})
				sc.hover:Play()
			end)
			v.MouseLeave:Connect(function()
				normaltween(v.glow.Value, sine0, in1, .2, {ImageColor3=fromRGB(85, 0, 255)})
				normaltween(v, sine0, in1, .2, {TextStrokeColor3=fromRGB(85, 0, 255),BorderColor3=fromRGB(85, 0, 255)})
				sc.press:Play()
			end)
		end
	end


	sp(function()
		while true do
			tw()
			if pres then
				break
			end
			local globalsine=clk()
			bot_1.Position=ud2(((globalsine+3)/20)%.5, 0,  0, 0)
			bot_2.Position=ud2((-(globalsine+3)/20)%.5, 0, 0, 0)

			local t=Bot.bot.Position
			local x,y=t.X,t.Y
			sbot_1.Position=ud2(x.Scale - 1, x.Offset, y.Scale, y.Offset)

			local t=Top.bot.Position
			local x,y=t.X,t.Y
			sbot_2.Position=ud2(x.Scale - 1, x.Offset, y.Scale, y.Offset)
		end
	end)
	normaltween(song, sine0, out, 2, {Pitch=1})

	for _, v:Instance in prs(ui:GetChildren()) do
		if v:IsA("TextLabel") or v:IsA("TextButton") then
			local glow=v:FindFirstChild("glow")
			local Pos=v.Position
			local g_Pos=glow.Value.Position
			local X,Y=Pos.X,Pos.Y
			v.Position=ud2(-1,0,Y.Scale,0)
			glow.Value.Position=ud2(-1,0,Y.Scale)
			normaltween(v, expon, out, 1.5, {Position=Pos})
			normaltween(glow.Value, expon, out, 1.5, {Position=g_Pos})
		end
	end

	local ab, ab2 = Top.Position, Bot.Position
	Top.Position=ud2(0, 0, -0.25,0)
	Bot.Position=ud2(0, 0, 1.15,0)
	normaltween(Top, expon, out, 1.5, {Position=ab})
	normaltween(Bot, expon, out, 1.5, {Position=ab2})

	random_pos()
