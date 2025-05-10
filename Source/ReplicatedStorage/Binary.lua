local Binary = {}

function Binary.ConvertBoolean(Value: boolean)
	if (Value == false) then return 0 end
	if (Value == true) then return 1 end
end

function Binary.ConvertBinary(Value: number)
	if (Value == 0) then return false end
	if (Value == 1) then return true end
end

return Binary