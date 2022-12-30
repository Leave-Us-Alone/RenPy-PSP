ren.func["if"] = function(str, level)
	local keyword = ren.keyword.key_if[reader.fName][tostring(reader.pos)] --if
	local was = false
	
	if keyword.i.exec:eval() then
		ren.settings.level[level+1] = keyword.i
		ren.settings.level[level+1].keyword = "if"
		ren.settings.level[level+1].pass = keyword.pass
		reader:toLine(keyword.i.pos)
		was = true
	elseif #keyword.elifs > 0 then
		for i = 1, #keyword.elifs do
			if keyword.elifs[i].exec:eval() then
				ren.settings.level[level+1] = keyword.elifs[i]
				ren.settings.level[level+1].keyword = "if"
				ren.settings.level[level+1].pass = keyword.pass
				reader:toLine(keyword.elifs[i].pos)
				was = true
				break;
			end
		end
	end
	
	if was then
		--nothing
	elseif keyword.el.level ~= nil then
		ren.settings.level[level+1] = keyword.el
		ren.settings.level[level+1].keyword = "if"
		ren.settings.level[level+1].pass = keyword.pass
		reader:toLine(keyword.el.pos)
	else
		reader:toLine(keyword.pass)
	end
end
ren.func.elif = function(str, level)
	--no need, because it's doing [if] statement
end
ren.func["else"] = function(str, level)
	--no need, because it's doing [if] statement
end