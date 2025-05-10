local connections = {}

local MainUI = script.Parent

local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local skinMain = require(ReplicatedStorage.MainModules.SkinMain)
local sorting = require(ReplicatedStorage.System.Sorting.Modes)
local Resources = MainUI.Resources
local Load = script.load

local LocalPlayer = Players.LocalPlayer

local MainSelector = MainUI.Main
local Sides = MainSelector.Sides

local Info = MainUI.Info

local isStudio = RunService:IsStudio()
local sides = skinMain.getSides()
local tabs = {}
local tabButtons = {
	
}

local v20 = Vector2.zero
local insert = table.insert
local spawn = task.spawn
local twait = task.wait
local sub = string.sub
local ud2 = UDim2.new

local defaultud2An = ud2(1, 0, 0, 0)

local selectSound = script.select
local exitSound = script.exit

local isTouch = UserInputService.TouchEnabled

local selectedMode = ""
local selectedSide = ""
local selectedMain = ""

local defaultAppearTween = Enum.EasingStyle.Exponential
local Out = Enum.EasingDirection.Out
local In = Enum.EasingDirection.In

local normalTween = require(ReplicatedStorage.System.Modules.Tweening.Tween).normalTween
local break_t = false

local function IsADeveloper(Player: Player)
	local GroupRole = Player:GetRoleInGroup(34348811)
	
	return if GroupRole == "Developer" or GroupRole == "Owner" then true else false
end

local function Textsp(textobject, txt)
	spawn(function()
		if textobject:IsA("TextLabel") or textobject:IsA("TextButton") then
			for i = 1, #txt do
				if break_t then
					break
				end

				twait(0.008)
				textobject.Text = sub(txt, 1, i)
			end
		end
	end)
end

local function Select(Mode, Main)
	if typeof(Mode) == "string" then
		local Mode = skinMain.getSkinByName(Mode)
	end

	if Mode then
		selectSound:Play()
		
		break_t = true
		
		twait(0.008)
	
		break_t = false
		
		local require_Data = Mode
		Textsp(Info.MainLabel, require_Data.ModeName)
		Textsp(Info.SubLabel, require_Data.SubText)
		Textsp(Info.Song, require_Data.SongTitle .. " @"..require_Data.SongArtist)
		Textsp(Info.Desc, require_Data.ShopDesc or "No Description")
		Textsp(Info.Credits, "By: " .. (require_Data.Creator or "Creator Not Set"))
		
		selectedMode = Main.Name

		require_Data = nil
	end
end

local function newSound()
	local nLoad = Load:Clone()
	nLoad.Parent = script
	nLoad:Play()
	Debris:AddItem(nLoad, nLoad.TimeLength)
end

local function animateButton(Button)
	local size = 0.035
	if isTouch then
		size = 0.08
	end
	normalTween(Button, defaultAppearTween, Out, .4, {BackgroundTransparency = 0, TextTransparency = 0, Size = UDim2.new(1, 0, size, 0)})
end

local function animateButtons(Frame: Frame)
	spawn(function()
		for _, v in pairs(Frame:GetChildren()) do
			if v:IsA("TextButton") then
				v.BackgroundTransparency = 1
				v.TextTransparency = 1
				v.Size = defaultud2An
			end
		end

		for _, v in pairs(Frame:GetChildren()) do
			if v:IsA("TextButton") then
				animateButton(v)
				twait(.05)
				newSound()
			end
		end
	end)
end

local function defaultExitFunction(Tab)
	exitSound:Play()
	
	Tab.Visible = false
	Sides.Visible = true
	
	animateButtons(Sides.Scrolling)
end

local function defaultModeExitFunction(Tab, MainTab)
	exitSound:Play()
	
	Tab.Visible = false
	MainTab.Visible = true
	
	animateButtons(MainTab.Scrolling)
end

local function createNewButton(Parent, Text, _function)
	local Button = Resources.Button:Clone()
	Button.Parent = Parent
	Button.Text = Text
	Button.Visible = true

	insert(connections, Button.MouseButton1Up:Connect(_function))

	return Button
end

local function createNewTab(Parent, Name, _function, tab)
	local Tab = tab or Resources.Tab
	local Tab = Tab:Clone()

	Tab.Parent = Parent
	Tab.Name = Name

	insert(tabs, Tab)
	if _function then
		insert(connections, Tab.Exit.MouseButton1Up:Connect(_function))
	else
		insert(connections, Tab.Exit.MouseButton1Up:Connect(function()
			defaultExitFunction(Tab)
		end))
	end

	return Tab
end

if isTouch then
	Resources.Button.Size = ud2(1, 0, 0.1)
end

skinMain.indexSkins()
local orderedSides = {}
for sideKey, _ in pairs(sorting) do
	for _, side in ipairs(sides) do
		if side:lower() == sideKey then
			insert(orderedSides, side)
			break
		end
	end
end

for _, side in pairs(orderedSides) do
	local newTab
	newTab = createNewTab(MainSelector, side, function()
		exitSound:Play()
		
		for _, tab in pairs(tabs) do
			tab.Visible = false
		end

		Sides.Visible = true

		animateButtons(Sides.Scrolling)	
	end)
	
	local nb_last_touch = tick()
	local newButton = createNewButton(Sides.Scrolling, side, function() 
		if isTouch then
			if not (tick() - nb_last_touch <= .5) then
				nb_last_touch = tick()
				return
			end
			
			nb_last_touch = tick()
		end
		
		for _, tab in pairs(tabs) do
			if tab.Name ~= side then
				tab.Visible = false
			else
				tab.Visible = true
			end
		end

		Sides.Visible = false

		animateButtons(newTab.Scrolling)
	end)

	local ParentModes = {}
	local modes = skinMain.indexModesBySide(side, true)
	
	local sortedMainModes = {}
	local sortOrder = sorting[side:lower()]
	if sortOrder then
		for _, modeName in ipairs(sortOrder) do
			for _, mode in ipairs(modes.Main) do
				if mode.Name:lower() == modeName:lower() then
					insert(sortedMainModes, mode)
					break
				end
			end
		end
	else
		sortedMainModes = modes.Main
	end
	
	for _, mode in pairs(sortedMainModes) do
		local mode_data = require(mode)
		local ModeName = mode_data.ModeName
		
		local sub_skins
		sub_skins = createNewTab(MainSelector, ModeName, function() 
			defaultModeExitFunction(sub_skins, newTab)	
		end, Resources.Tab_2)

		local mb_last_touch = tick()
		local modeButton = createNewButton(newTab.Scrolling, ModeName, function() 
			if isTouch then
				if not (tick() - mb_last_touch <= .5) then
					mb_last_touch = tick()
					return
				end

				mb_last_touch = tick()
			end
			
			newTab.Visible = false
			sub_skins.Visible = true

			newTab.Scrolling.CanvasPosition = v20

			if sub_skins.Holder:FindFirstChild("Skin") then
				animateButtons(sub_skins.Holder.Skin)
			end

			animateButtons(sub_skins.Holder.Sub)
		end)

		local skins = skinMain.indexSkinsByMode(side, "Main", mode.Name)
		if #skins ~= 0 then
			for _, skin in pairs(skins) do
				local skin_last_touch = tick()
				local skinData = require(skin)
				if not skinData.IsHidden or IsADeveloper(LocalPlayer) or isStudio then
					local skin_data = require(skin)
					local skinButton = createNewButton(sub_skins.Holder.Skin, skin_data.ModeName, function() 
						if isTouch then
							if not (tick() - skin_last_touch <= .5) then
								skin_last_touch = tick()
								return
							end

							skin_last_touch = tick()
						end
							
						Select(skin_data, skin)
						selectedMain = mode.Name
						selectedSide = side
					end)
				end
			end
		else
			sub_skins.Holder.Skin:Destroy()
		end
		
		local mb_2_touch = tick()
		local modeButton_2 = createNewButton(sub_skins.Holder.Sub, ModeName, function() 
			if isTouch then
				if not (tick() - mb_2_touch <= .5) then
					mb_2_touch = tick()
					return
				end

				mb_2_touch = tick()
			end
			
			Select(mode_data, mode)
			selectedMain = mode.Name
			selectedSide = side
		end)

		insert(ParentModes, {mode.Name, sub_skins})
	end

	for i, mode in pairs(modes.Sub) do
		local ParentName = require(mode).ParentMode.Name
		local ParentMode

		for _, v in pairs(ParentModes) do
			if v[1]:lower() == ParentName:lower() then
				ParentMode = v[2]
				break
			end
		end

		if ParentMode then
			local mode_data = require(mode)
			local ModeName = mode_data.ModeName
			
			local sub_skins
			sub_skins = createNewTab(MainSelector, ModeName, function() 
				sub_skins.Visible = false
				ParentMode.Visible = true

				if ParentMode.Holder:FindFirstChild("Skin") then
					animateButtons(ParentMode.Holder.Skin)
				end
				animateButtons(ParentMode.Holder.Sub)
			end, Resources.Tab_2)

			local modeButton = createNewButton(ParentMode.Holder.Sub, ModeName, function() 
				newTab.Visible = false
				ParentMode.Visible = false
				sub_skins.Visible = true

				newTab.Scrolling.CanvasPosition = v20

				if sub_skins.Holder:FindFirstChild("Skin") then
					animateButtons(sub_skins.Holder.Skin)
				end
				animateButtons(sub_skins.Holder.Sub)
			end)
			
			local modeSkinButton = createNewButton(sub_skins.Holder.Sub, ModeName, function() 
				Select(mode_data, mode)
				selectedMain = mode.Name
				selectedSide = side
			end)

			local skins = skinMain.indexSkinsByMode(side, "Sub", mode.Name)
			if #skins ~= 0 then
				for _, skin in pairs(skins) do
					local skinData = require(skin)
					if not skinData.IsHidden or IsADeveloper(LocalPlayer) or isStudio then
						local skin_data = require(skin)
						local skinButton = createNewButton(sub_skins.Holder.Skin, skin_data.ModeName, function() 
							Select(skin_data, skin)
							selectedMain = mode.Name
							selectedSide = side
						end)
					end
				end
			else
				sub_skins.Holder.Skin:Destroy()
			end

			for _, subMode in pairs(modes.Sub) do
				local SubParentName = require(subMode).ParentMode.Name
				
				if SubParentName:lower() == mode.Name:lower() then
					local mode_data = require(subMode)
					local ModeName = mode_data.ModeName
					
					local deeper_skins
						deeper_skins = createNewTab(MainSelector, ModeName, function() 
						deeper_skins.Visible = false
						sub_skins.Visible = true

						if sub_skins.Holder:FindFirstChild("Skin") then
							animateButtons(sub_skins.Holder.Skin)
						end
						animateButtons(sub_skins.Holder.Sub)
					end, Resources.Tab_2)

					local deeperButton = createNewButton(sub_skins.Holder.Sub, ModeName, function() 
						newTab.Visible = false
						sub_skins.Visible = false
						deeper_skins.Visible = true

						newTab.Scrolling.CanvasPosition = v20

						if deeper_skins.Holder:FindFirstChild("Skin") then
							animateButtons(deeper_skins.Holder.Skin)
						end
						animateButtons(deeper_skins.Holder.Sub)
					end)

					local deeperSkinButton = createNewButton(deeper_skins.Holder.Sub, ModeName, function() 
						Select(mode_data, subMode)
						selectedMain = subMode.Name
						selectedSide = side
					end)


					local deepSkins = skinMain.indexSkinsByMode(side, "Sub", subMode.Name)
					if #deepSkins ~= 0 then
						for _, deepSkin in pairs(deepSkins) do
							local deepSkinData = require(deepSkin)
							if not deepSkinData.IsHidden or IsADeveloper(LocalPlayer) or isStudio then
								local skin_data = require(deepSkin)
								local deepSkinButton = createNewButton(deeper_skins.Holder.Skin, skin_data.ModeName, function() 
									Select(skin_data, deepSkin)
									selectedMain = subMode.Name
									selectedSide = side
								end)
							end
						end
					else
						deeper_skins.Holder.Skin:Destroy()
					end
				end
			end
		end
	end
end

insert(connections, Info.Button.MouseButton1Down:Connect(function()
	if selectedMode then
		selectSound:Play()
		ReplicatedStorage.GlobalRemotes.EquipSkin:FireServer(selectedSide, selectedMain, selectedMode)
	end
end))