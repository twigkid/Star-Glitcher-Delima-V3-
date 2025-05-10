local Configuration = {}
local Binary = require(game.ReplicatedStorage.System.Modules.Misc.Binary)

function Configuration.ConfigPart(Part: BasePart, Value: boolean)
	Part.CanCollide = Value Part.CanTouch = Value Part.CanQuery = Value
	Part.Massless = Value Part.CastShadow = Value Part.Transparency = Binary.ConvertBoolean(Value) Part.Anchored = Value
end

return Configuration