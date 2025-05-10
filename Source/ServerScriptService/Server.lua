local FindFirstChild = game.FindFirstChild
local FindFirstChildOfClass = game.FindFirstChildOfClass
local WaitForChild = game.WaitForChild

local IsA = game.IsA
local GetChildren = game.GetChildren
local GetDescendants = game.GetDescendants

local Players = FindFirstChildOfClass(game, "Players")
local ReplicatedStorage = FindFirstChildOfClass(game, "ReplicatedStorage")
local System = ReplicatedStorage.System
local DatastoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")

local GlobalRemotes = ReplicatedStorage.GlobalRemotes
local Modes = System.Modes

local Clone = workspace.Clone
local ins = Instance.new

local Vars = script.Vars
local Skins = script.Skins

local skinMain = require(ReplicatedStorage.MainModules.SkinMain)
local userData = DatastoreService:GetDataStore("userData_uncorrupt")

local skinsLocal = {
	
}

local function CreateNewUserData()
	local userData = {
		Currency = 0,
		Level = 0,

		Skins = {

		},
		
		Equipped = {
			
		},
	}

	local allSkins = skinMain.getAllSkins()
	for index, skin in allSkins do
		table.insert(userData.Skins, {skin.Name:lower(), false})
	end
	
	for index, side in ipairs(GetChildren(System.Modes)) do
		local name = side.Name:lower()
		table.insert(userData.Equipped, {name, {}})
		for _, main in GetChildren(side.Main) do
			table.insert(userData.Equipped[index][2], {main.Name, main.Name})
		end
		
		for _, sub in GetChildren(side.Sub) do
			table.insert(userData.Equipped[index][2], {sub.Name, sub.Name})
		end
	end
	
	return userData
end

local function CheckUserdata(UserId: number)
	local output = {}
	local success, _output = pcall(function()
		local SkinData = HttpService:JSONDecode(userData:GetAsync(tostring(UserId)))
		output = SkinData
	end)

	if not success then -- Datastore doesn't exist, creating it.
		local newUserData = HttpService:JSONEncode(CreateNewUserData())
		userData:SetAsync(tostring(UserId), newUserData)
		
		output = HttpService:JSONDecode(newUserData)
	end

	task.wait(1 / 60)
	
	return output
end

-- Sorting Skins

for _, v in pairs(GetDescendants(System.Modes)) do
	if v:IsA("ModuleScript") then
		local NewFolder = ins("Folder", System.Skins[v.Parent.Parent.Name][v.Parent.Name])
		NewFolder.Name = v.Name
	end
end

for _, v in pairs(GetDescendants(System.Skins)) do
	if v:IsA("ModuleScript") then
		local required=require(v)
		local ParentMode, ModeName = required.ParentMode, required.ModeName

		local a = FindFirstChild(v.Parent, ParentMode.Name, true)

		if a and IsA(a, "Folder") then
			v.Parent = a
		end
	end
end

for _, v in pairs(GetChildren(System.Modes)) do
	local Folder = ins("Folder",Skins)

	local Main = ins("Folder", Folder)
	local Sub = ins("Folder", Folder)

	Main.Name = "Main"
	Sub.Name = "Sub"
	Folder.Name = v.Name

	for _, x in pairs(GetChildren(FindFirstChild(v, "Main"))) do
		if x:IsA("ModuleScript") then
			local ObjectValue=ins("ObjectValue",Main)
			ObjectValue.Name=x.Name
			ObjectValue.Value=x
		end
	end

	for _, x in pairs(GetChildren(FindFirstChild(v, "Sub"))) do
		if IsA(x, "ModuleScript") then
			local ObjectValue=ins("ObjectValue",Sub)
			ObjectValue.Name = x.Name
			ObjectValue.Value = x
		end
	end
end

local vital = {
	"Storage",
	"Terrain",
	"Camera",
	"Models",
	"Shop",
	"ActiveVFX",
	"Vars",
	"DistortionEffects",
}

local liteModeIDS = {
	1461835038,
}

Players.PlayerAdded:Connect(function(Player: Player)
	local UserId = Player.UserId
	local localVars = Vars:Clone()
	localVars.Parent = Player

	local DatastoreCheck = CheckUserdata(UserId)
	localVars.Currency.Value = DatastoreCheck.Currency
	localVars.Level.Value = DatastoreCheck.Level

	if Player:IsInGroup(33503630) then
		Player:Kick("btw \"Stuudio\" has a history of stealing & profiting off other people's work (SG ~ PF), so I recommend leaving their group.")
	end

	table.insert(skinsLocal, {UserId, DatastoreCheck.Equipped})
	
	if table.find(liteModeIDS, Player.UserId) and (game["Run Service"]:IsStudio() or game.PrivateServerId ~= "") then
		workspace.Terrain.Clouds:Destroy()
		for _, v in pairs(workspace:GetChildren()) do
			if not table.find(vital, v.Name) then
				if not v:FindFirstChildOfClass("Humanoid") then
					v:Destroy()
				end
			end
		end
		for _, v in pairs(workspace.Models:GetChildren()) do
			if v.Name ~= "Baseplates" then
				v:Destroy()
			end
		end

		for _, v in pairs(workspace.Models.Baseplates:GetChildren()) do
			local texture = script.Texture:Clone()
			texture.Parent = v
			v.Material = "Plastic"
			v.Color = Color3.new(0.203922, 0.203922, 0.203922)
		end
		
		game.Lighting.ClockTime = 7.5
	end
end)

local Storage = workspace.Storage
Players.PlayerRemoving:Connect(function(Player: Player)	
	local Folder = Storage:FindFirstChild(Player.Name)
	if Folder then
		Folder:Destroy()
		Folder = nil
	end
	
	local UserId = Player.UserId
	local localVars = Player:WaitForChild("Vars")
	local DatastoreCheck = HttpService:JSONDecode(userData:GetAsync(UserId))

	for _, v in pairs(skinsLocal) do
		if v[1] == UserId then
			DatastoreCheck.Equipped = v[2]
			break
		end
	end

	userData:SetAsync(tostring(Player.UserId), HttpService:JSONEncode(DatastoreCheck))
	localVars, DatastoreCheck = nil, nil
	
	for i, v in pairs(skinsLocal) do
		if v[1] == Player.UserId then
			table.remove(skinsLocal, i)
		end
	end
end)

System.Remotes.SendPlatform.OnServerEvent:Connect(function(Player: Player, Platform: Enum.UserInputType)
	local VarsFolder = Player:FindFirstChild("Vars")
	if VarsFolder then
		if Platform == Enum.UserInputType.Touch then
			VarsFolder.Platform.Value = "Mobile"
		elseif Platform == Enum.UserInputType.MouseMovement or Platform == Enum.UserInputType.Keyboard then
			VarsFolder.Platform.Value = "Computer"
		end
	end
end)


GlobalRemotes.EquipSkin.OnServerEvent:Connect(function(player: Player, Side: string, MainMode: string, SkinName: string)
	local SkinModule
	if MainMode:lower() == SkinName:lower() then
		SkinModule = skinMain.getModeByName(SkinName)
	else	
		SkinModule = skinMain.getSkinByName(SkinName)
	end

	if SkinModule then
		local DatastoreCheck
		local Index = 0
		
		for i, v in pairs(skinsLocal) do
			if v[1] == player.UserId then
				DatastoreCheck = v[2]
				Index = i
				break
			end
		end
		
		if DatastoreCheck then
			for sIndex, side_a in pairs(DatastoreCheck) do
				if side_a[1] == Side:lower() then
					for mIndex, skinTab  in pairs(side_a[2]) do
						if skinTab[1] == MainMode then
							skinsLocal[Index][2][sIndex][2][mIndex][2] = SkinModule.Name
						end
					end
				end
			end
		else
			print("couldn't find skin table")
		end
	end
end)

GlobalRemotes.OwnsSkin.OnServerEvent:Connect(function(player: Player, Name: string)

end)

script.GetSkinTable.Event:Connect(function(Player)
	for _, v in pairs(skinsLocal) do
		if v[1] == Player.UserId then
			script.ReturnSkinTable:Fire(Player, v[2])
		end
	end
end)

skinMain.indexSkins()