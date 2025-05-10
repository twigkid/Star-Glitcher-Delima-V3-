local sp, st, tw = task.spawn, string, task.wait
local Text = {}

function Text.Textsp(txt: string, textobject: Instance, t: number)
	sp(function()
		if textobject:IsA("TextLabel") or textobject:IsA("TextButton") then
			for i = 1, #txt do
				tw(t or 0.025)
				textobject.Text = st.sub(txt, 1, i)
			end
		elseif textobject:IsA("StringValue") then
			for i = 1, #txt do
				tw(t or 0.025)
				textobject.Value = st.sub(txt, 1, i)
			end
		end
	end)
end

function Text.TextDel(txt: string, textobject: Instance, t: number)
	sp(function()
		if textobject:IsA("TextLabel") or textobject:IsA("TextButton") then
			for i = #txt, 1, -1 do
				tw(t or 0.025)
				textobject.Text = st.sub("", 1, i)
			end
		elseif textobject:IsA("StringValue") then
			for i = #txt, 1, -1 do
				tw(t or 0.025)
				textobject.Value = st.sub("", 1, i)
			end
		end
	end)
end

return Text