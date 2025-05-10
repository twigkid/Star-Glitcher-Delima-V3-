local datastoreService = game:GetService("DataStoreService")
local Players = game:FindFirstChildOfClass("Players")
local Module = {}

function Module.BanUser(Player: Player, Reason: string, ActualLog: string, Duration: number)
	Players:BanAsync({
		UserIds = {Player.UserId},
		ApplyToUniverse = true,
		Duration = Duration,
		DisplayReason = Reason.. ' If you think this is a mistake, then join the communications server and message twigkid.',
		PrivateReason = ActualLog,
		ExcludeAltAccounts = false,
	})
end

function Module.BanExploiter_Default(Player: Player, reason)
	Players:BanAsync({
		UserIds = {Player.UserId},
		ApplyToUniverse = true,
		Duration = 10e10,
		DisplayReason = "...",
		PrivateReason = reason,
		ExcludeAltAccounts = false,
	})
end

return Module

