local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MainUI = script.Parent
local UIButtons = ReplicatedStorage.Interface.UIButtons

if UserInputService.TouchEnabled then
	for _, v in pairs(UIButtons.Mobile:GetChildren()) do
		v:Clone().Parent = MainUI
	end
else
	for _, v in pairs(UIButtons.Desktop:GetChildren())	 do
		v:Clone().Parent = MainUI
	end
end