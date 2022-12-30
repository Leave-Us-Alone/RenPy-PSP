function ren.eval(str)
	ren.next = true
	
	if str == false then --EOFs
		ren.exit = true
		return false
	end
	
	if str:denote():trim() == "" then
		return true
	end
	
	local level = getLevel(str, reader.fName, reader.pos)
	if level > #ren.settings.level then
		while level > #ren.settings.level do
			ren.settings.level[#ren.settings.level+1] = {keyword="scenario"}
		end
	elseif level < #ren.settings.level then
		local struct = ren.settings.level[#ren.settings.level]
		local keyword = struct.keyword
		
		if keyword == "scenario" or keyword == "label" then
			--ignored
			table.splice(ren.settings.level, level, #ren.settings.level - level)
		elseif keyword == "menu" then
			reader:toLine(struct.pass)
			ren.settings.level[#ren.settings.level] = nil
			ren.settings.level[#ren.settings.level] = nil
			return true
		elseif keyword == "case" then
			--what?
			error2({reader.fName..'->'..reader.pos, 'what?'})
		elseif keyword == "if" then
			reader:toLine(struct.pass)
			ren.settings.level[#ren.settings.level] = nil
			return true
		end
	end
	
	str = str:denote():trim()
	
	if str:sub(1,1) == "$" then
		if str:sub(1,13) == "$ persistent." then
			if str:sub(1,24) == "$ persistent.sprite_time" then
				--nothing
			else
				ren.file = io.open("saves/persistent", "a")
				ren.file:write("ren.settings.var."..str:sub(3,40).."\n")
				ren.file:close()
			end
		end
		str:evalpy()
	elseif str:sub(1,1) == "\"" then
		ren.message(str:sub(2, str:len()-1))
	else
		ren.action(str, level)
	end
	
	ren.settings.reader = reader:save()
	ren.settings.msg = msg:save()
end
function ren.message(str)
	msg_clear(1)
	
	ren.history.current.text = str
	ren.history.current.pos = reader.pos
		
	if ren.settings.dialog.box.mode == "dialogue" then
		msg_new(str)
	else
		msg = msg:add(str)
	end
	
	ren.next = false
end
function ren.action(str, level)
	local funcName = str:match("^[%a_][%w_]*")
	if not ren.func[funcName] then
		error2({reader.fName..'->'..reader.pos, "str: "..str, "No such function: "..tostring(funcName)})
	end
  ren.func[funcName](str, level)
end