local module = {}

local cf = CFrame.new
local c3 = Color3.new
local la = CFrame.lookAt
local angles = CFrame.Angles
local rad = math.rad
local rand = math.random
local v3 = Vector3.new
local clamp = math.clamp
local ud2 = UDim2.new
local sp = task.spawn
local tw = task.wait
local ceil = math.ceil

local inse=table.insert
local clk=os.clock
local sin=math.sin

local linear = Enum.EasingStyle.Linear
local in0 = Enum.EasingDirection.In

local ReplicatedStorage = game:FindFirstChildOfClass("ReplicatedStorage")
local System = ReplicatedStorage.System

local RunService = game:FindFirstChildOfClass("RunService")
local renderStepped = RunService.RenderStepped
local heartbeat = RunService.Heartbeat
local stepped = RunService.Stepped
local sev = RunService:IsServer()

local normalTween = require(System.Modules.Tweening.Tween).normalTween
local debris = game.Debris
local ins = Instance.new
local connect = workspace.Destroying.Connect
local disconnect = workspace.Destroying:Connect(function() end).Disconnect
local once = workspace.Destroying.Once

local cs = ColorSequence.new

local function config(part: BasePart, value: boolean)
	part.Anchored=not value
	part.CanCollide=value 
	part.CanTouch=value 
	part.CanQuery=value
	part.Massless=value
end

function module.Effect(Type, Table)
	local StartColor = Table.StartColor
	local EndColor = Table.EndColor
	local Material = Table.Material or "Neon"
	local Part

	if typeof(Type) == "string" then
		Part = ins("Part", Table.Parent)

		if Type == "Sphere" then
			local Mesh = ins("SpecialMesh", Part)
			Mesh.MeshType = "Sphere"
		end
	elseif typeof(Type) == "Instance" then -- use meshpart
		Part = Type:Clone()
		Part.Parent = Table.Parent
	end
	
	Part.Size = Table.Size
	Part.CFrame = Table.StartCFrame
	Part.Material = Material

	config(Part)

	if Table.UseMultiplication then
		local connection
		local TransparencyMultiplier = Table.TransparencyMultiplier * 100
		local CFrameMultiplier = Table.CFrameMultiplier
		local CFrameUpdate = Table.CFrameUpdate or cf()
		local EndColor = Table.EndColor
		local ColorTime = Table.ColorTime
		local lastUpdateTime = tick()
		local EndSize = Table.EndSize
		local SizeTime = Table.SizeTime

		Part.Color = Table.StartColor
		Part.Transparency = Table.TransparencyStart or 0
	
		connection = connect(if not sev then renderStepped else stepped, function(deltaTime)
			local Multi = (TransparencyMultiplier * deltaTime)
			Part.Transparency = Part.Transparency + Multi
			local Fixed = CFrame.fromMatrix(v3((CFrameMultiplier.X*100) * deltaTime, (CFrameMultiplier.Y*100) * deltaTime, (CFrameMultiplier.Z*100) * deltaTime), (CFrameMultiplier.XVector*100) * deltaTime, (CFrameMultiplier.YVector*100) * deltaTime, (CFrameMultiplier.ZVector*100) * deltaTime)
			Part.CFrame = Part.CFrame * Fixed
			CFrameMultiplier = CFrameMultiplier * CFrameUpdate

			if Part.Transparency > 1 then
				Part:Destroy()
				disconnect(connection) connection=nil
			end
		end)

		if SizeTime then
			normalTween(Part, linear, in0, SizeTime, {Size = EndSize})
		end
		normalTween(Part, linear, in0, ColorTime, {Color = EndColor})
	else
		local TweenTable = Table.Tween
		local Style = TweenTable.TweenStyle
		local TweenDir = TweenTable.TweenDirection

		local TransparencyDelay = TweenTable.TransparencyDelay
		local TransparencyStart, TransparencyEnd = TweenTable.TransparencyStart, TweenTable.TransparencyEnd
		local TransparencySpeed = TweenTable.TransparencySpeed

		local SizeDelay = TweenTable.SizeDelay
		local SizeEnd = TweenTable.SizeEnd
		local SizeSpeed = TweenTable.SizeSpeed

		local ColorDelay = TweenTable.ColorDelay
		local ColorStart, ColorEnd = TweenTable.ColorStart, TweenTable.ColorEnd
		local ColorSpeed = TweenTable.ColorSpeed

		local CFrameEnd = TweenTable.CFrameEnd -- Uses Table.StartCFrame
		local CFrameSpeed = TweenTable.CFrameSpeed

		normalTween(Part, Style, TweenDir, CFrameSpeed, {CFrame = CFrameEnd})

		sp(function()
			tw(TransparencyDelay)
			normalTween(Part, Style, TweenDir, TransparencySpeed, {Transparency = TransparencyEnd})
		end)

		sp(function()
			tw(ColorDelay)
			normalTween(Part, Style, TweenDir, ColorSpeed, {Color = EndColor})
		end)

		sp(function()
			tw(SizeDelay)
			normalTween(Part, Style, TweenDir, SizeSpeed, {Size = SizeEnd})
		end)

		Part.Transparency = TransparencyStart
		Part.Color = ColorStart

		debris:AddItem(Part, TransparencySpeed)
	end
end

return module