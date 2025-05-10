local BadgeService = game:FindFirstChildOfClass("BadgeService")
local Players = game:FindFirstChildOfClass("Players")

local CurrentPhase = "Alpha"
local Phases = {
	{"Alpha", 3363166125966653},
	{"Beta", 3475786686916261},
	{"Public", 2002965104515677},
}

Players.PlayerAdded:Connect(function(player: Player) 
	task.wait(.5)

	for _, v in pairs(Phases) do
		local Name, BadgeID = v[1], v[2]
		
		if Name == CurrentPhase then
			BadgeService:AwardBadge(player.UserId, BadgeID)
			break
		end
	end
end)