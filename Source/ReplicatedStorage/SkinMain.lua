local DatastoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
local ServerScriptService = game:GetService("ServerScriptService")

local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local system = replicatedStorage.System

local globalRemotes = replicatedStorage.GlobalRemotes
local modes = system.Modes

local equipSkin = globalRemotes.EquipSkin

local allSkins = {}
local allModes = {}

local skinMain = {}

local responseIDs = {
	["001"] = "Success"; --Successfully equipped skin
	["002"] = "Invalid Skin"; -- Skin doesn't exist or cannot be found
	["003"] = "Illegal Skin"; -- User doesn't own the skin. (Adds to exploiting record)
}

--Indexes all skins in the game.
function skinMain.indexSkins()
	for _, skin in pairs(system.Skins:GetDescendants()) do
		if skin:IsA("ModuleScript") then
			table.insert(allSkins, skin)
		end
	end
	
	for _, mode in pairs(system.Modes:GetDescendants()) do
		if mode:IsA("ModuleScript") then
			table.insert(allModes, mode)
		end
	end
end

--Returns the skin module that matches the "Name" argument. (Case-Insensitive) 
function skinMain.getSkinByName(Name: string)
	local Name = Name:lower()
	for index, skin in ipairs(allSkins) do
		if skin.Name:lower() == Name then
			return skin
		end
	end
end

--Returns the mode module that maches the "Name" argument. (Case-Insensitive)
function skinMain.getModeByName(Name: string)
	local Name = Name:lower()
	for index, skin in ipairs(allModes) do
		if skin.Name:lower() == Name then
			return skin
		end
	end
end

--Returns all skins parented to the main mode.
--ModeType: Main / Sub
function skinMain.indexSkinsByMode(Side: string, ModeType: string, Name: string)
	local Skins = {}
	for _, skin in pairs(system.Skins[Side][ModeType][Name]:GetChildren()) do
		table.insert(Skins, skin)
	end
	
	return Skins
end

function skinMain.indexModesBySide(Side: string, includeMain: boolean)
	local modes = {
		Main = {},
		Sub = {}
	}
	
	for _, mode in pairs(system.Modes[Side]:GetDescendants()) do
		if mode:IsA("ModuleScript") then
			if mode.Parent.Name == "Main" then
				table.insert(modes.Main, mode)
			else
				table.insert(modes.Sub, mode)
			end
		end
	end
	
	return modes
end

--Returns Skins that include the "Name" string. eg: skinMain.indexSkinsByName("EXORBITANT")
function skinMain.indexSkinsByName(Name: string)
	local Name = Name:lower()
	local localSkins = {}
	
	for index, skin in pairs(allSkins) do
		if string.find(skin.Name:lower(), Name) then
			table.insert(localSkins, skin)
		end
	end
	
	return localSkins
end

--Returns all skins in the game
function skinMain.getAllSkins()
	return allSkins
end

--[[
(Case-Insensitive)
Sends a request to the server to equip a skin.
The server checks wether you own the skin or not.
]]
function skinMain.sendSkinEquipSignal(Name: string, listenForResponse: boolean)
	if runService:IsClient() then
		equipSkin:FireServer(Name)
		if listenForResponse then
			local responseString, responseStarted = "Timeout", tick()
			
			local response_Connection = equipSkin.OnClientEvent:Connect(function(responseID)
				local indexed = responseIDs[responseID]
				if indexed then
					responseString = indexed
				else
					responseString = "Invalid ResponseID."
				end
			end)
			
			repeat task.wait(1) until responseString ~= "Timeout" or tick() > responseStarted
			response_Connection:Disconnect() response_Connection = nil
			return responseString
		end
	else
		return "sendSkinEquipSignal can only be called from the client!"
	end
end

--(Server) Gets the currently equipped skin for a specific mode.
function skinMain.getEquippedSkin(Player: Player, Side: string, MainMode: string)
	if runService:IsServer() then
		local equipped
		local Server = ServerScriptService.Server
		local wait_con
		wait_con = Server.ReturnSkinTable.Event:Connect(function(BindPlayer, SkinTable)
			if BindPlayer == Player then
				equipped = SkinTable
				wait_con:Disconnect()
				wait_con = nil
			end
		end)

		Server.GetSkinTable:Fire(Player)

		repeat task.wait(.1) until equipped

		local table_e

		local sideLow, MainModeLow = Side:lower(), MainMode:lower()
		for _, side in pairs(equipped) do
			if side[1] == sideLow then
				table_e = side[2]
				break
			end
		end
		
		if not table_e then
			for _, v in pairs(system.Modes[Side]:GetDescendants()) do
				if v.Name:lower() == MainModeLow then
					return v
				end
			end
		end

		for _, mode in pairs(table_e) do
			if mode[1]:lower() == MainModeLow then
				for i, skinModule: ModuleScript in pairs(system.Skins[Side]:GetDescendants()) do
					if skinModule.Name:lower() == mode[2]:lower() then
						if skinModule:IsA("Folder") then
							for _, v in pairs(system.Modes[Side]:GetDescendants()) do
								if v.Name:lower() == MainModeLow then
									return v
								end
							end
						else
							return skinModule
						end
					end
				end
				break
			end
		end
	else
		return "getEquippedSkin can only be called from the server!"
	end
end

--Returns all sides in string format.
function skinMain.getSides()
	local sides = {}
	for _, side in pairs(system.Sides:GetChildren()) do
		table.insert(sides, side.Name)
	end
	
	return sides
end

return skinMain