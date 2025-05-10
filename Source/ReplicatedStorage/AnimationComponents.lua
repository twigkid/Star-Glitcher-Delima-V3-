local Comp = {}

function Comp.getMetamethodFromErrorStack(userdata,f,test) -- mw, please stop changing the lerps every god-damn week.
	local ret=nil
	xpcall(f,function()
		ret=debug.info(2,"f")
	end,userdata,nil,0)
	if (type(ret)~="function") or not test(ret) then
		return f
	end
	return ret
end

return Comp