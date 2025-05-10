repeat task.wait() until game.Loaded

local MainObject = workspace:WaitForChild("BossUI")
local MainUI = MainObject.UI
local ReplicatedStorage = game:FindFirstChildOfClass("ReplicatedStorage").System

local Bosses = ReplicatedStorage.Bosses
local BossTables = {}

local Tabs = {}

local Main = MainUI.Main
local MainSelector = Main.MainSelector

local DifficultySelector = MainSelector.DifficultySelector
local BossSelector = MainSelector.BossSelector

local DifficultyExample = DifficultySelector.UIListLayout.Boss
local BossExample = BossSelector.UIListLayout.Boss

for _, v in pairs(Bosses:GetChildren()) do
	local Difficulty = v.Name
	local Bosses = v:GetChildren()
	
	table.insert(BossTables, {Difficulty = Difficulty, Bosses = Bosses})
end

for i, x in pairs(BossTables) do
	local NewDifficulty = DifficultyExample:Clone()
	local NewBoss = BossExample:Clone()
	
	NewDifficulty.Text = x.Difficulty
	
	local NewTab = BossSelector:Clone()
	
	NewTab.Parent = MainSelector
	if i == 1 then
		
	end
end