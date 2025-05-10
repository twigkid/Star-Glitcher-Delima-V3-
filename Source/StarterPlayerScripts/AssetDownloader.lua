task.wait(3)

local ContentProvider = game.ContentProvider
local ContentToLoad = {}

for _, v in pairs(game.ReplicatedStorage.System:GetDescendants()) do -- All songs / album covers
	if v:IsA("ModuleScript") then
		pcall(function()
			local rq = require(v)
			if typeof(rq) ~= "function" and rq.ModeName then -- is a mode
				table.insert(ContentToLoad, rq.SoundID)
				if rq.AlbumCover then
					table.insert(ContentToLoad, "rbxassetid://"..rq.AlbumCover)
				end
			else
				rq = nil
			end
		end)
	elseif v:IsA("ParticleEmitter") or v:IsA("Beam") or v:IsA("Texture") or v:IsA("Decal") then
		table.insert(ContentToLoad, v.Texture)
	end
end

for _, v in pairs(workspace:GetDescendants()) do
	if v:IsA("Decal") or v:IsA("Beam") or v:IsA("Texture") or v:IsA("ParticleEmitter") then
		table.insert(ContentToLoad, v.Texture)
	end
end

local Static = {	
	"rbxassetid://121639508029517",
	"rbxassetid://83454011813444",
	"rbxassetid://101981462937785",
	"rbxassetid://133430706000846",
	"rbxassetid://77147452580696",
	"rbxassetid://131892955704023",
	"rbxassetid://97550455560596",
	"rbxassetid://106153726823475",
	"rbxassetid://106395134268597",
	"rbxassetid://93657189188970",
}

for i, v in ipairs(Static) do
	table.insert(ContentToLoad, v)
end

local function beginLoad()
	local Total = #ContentToLoad
	local TotalLoaded = 0
	local TelapsedTime = 0
	
	local isLoading = true
	
	local function Count()
		TotalLoaded = TotalLoaded + 1
	end
	
	task.spawn(function()
		while isLoading do
			TelapsedTime  = TelapsedTime + .1
			task.wait(.1)
		end
	end)
	
	ContentProvider:PreloadAsync(ContentToLoad, Count)
	
	isLoading = false
	
	print("Preloaded: " .. TotalLoaded .. "/" .. Total.. " assets in ".. string.format("%.2f", TelapsedTime) .. " seconds.")
	game.TextChatService["TextChannels"].RBXGeneral:DisplaySystemMessage(string.format('<font color="%s">%s</font>', "#6f04f6", "Star Glitcher ~ Delima is currently in development, Report any bugs to the communications server with a screenshot of the F9 console."))
	game.TextChatService["TextChannels"].RBXGeneral:DisplaySystemMessage(string.format('<font color="%s">%s</font>', "#Ffffff", "or use /console to open the F9 console for mobile users."))

	script:Destroy()
end

beginLoad()