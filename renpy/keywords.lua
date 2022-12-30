function ren.keyword_collector()
	ren.keyword_label()
	keywords_mods.label()
	
	local line = ""
	for pos = 1, #reader.file["scenario.rpy"].line do
		line = reader.file["scenario.rpy"].line[pos]:trim()
		if line:sub(1,1) == "m" or line:sub(1,1) == "i" then
			if line:sub(1,2) == "if" then
				ren.keyword_if("scenario.rpy", pos)
			elseif line:sub(1,4) == "menu" then
				ren.keyword_menu("scenario.rpy", pos)
			end
		end
	end

	local line = ""
	for id, mod in pairs(mods) do
		local files = mods[id].rpy_scenario
		local folder = mods[id].folder

		for id2, file in pairs(files) do
			for pos = 1, #reader.file[folder.."/"..file].line do
				line = reader.file[folder.."/"..file].line[pos]:trim()
				if line:sub(1,1) == "m" or line:sub(1,1) == "i" then
					if line:sub(1,2) == "if" then
						keywords_mods.ifs(folder.."/"..file, pos)
					elseif line:sub(1,4) == "menu" then
						keywords_mods.menu(folder.."/"..file, pos)
					end
				end
			end
		end
	end
end
function ren.keyword_menu(fName, pos)
	local start = tostring(pos)
	
	local line, level
	local cases, clevel
	
	line = reader.file["scenario.rpy"].line[pos]
	level = getLevel(line, fName, pos)
	
	cases = {}
	for i = pos+1, #reader.file["scenario.rpy"].line do
		line = reader.file["scenario.rpy"].line[i]
		clevel = getLevel(line, fName, i)
		
		if clevel == level+1 then
			if not line:denote():trim():match("(.*):.-") then
				error("menu-case expected, got '"..line.."' in file "..fName.." at line "..i)
			end
			table.insert(cases, {pos=i, name=line:denote():trim():match("(.*):.-")})
		elseif clevel <= level then
			pass = i-1
			break;
		end
	end
	
	if not ren.keyword.switch[fName] then ren.keyword.switch[fName] = {} end
	ren.keyword.switch[fName][start] = {level=level, case=cases, pass=pass}
end
function makeExec(str)
	if not str:match("(.*):.-$"):match("^e?l?i?f?s?e? (.*)") then error(str, 2) end
	return str:match("(.*):.-$"):match("^e?l?i?f?s?e? (.*)"):putRenVars()
end
function ren.keyword_if(fName, pos)
	local start = tostring(pos)
	
	local line, level
	local i, elifs, el, pass
	
	line = reader.file["scenario.rpy"].line[pos]
	level = getLevel(line, fName, pos)
	i = {pos=pos, level=level, exec=makeExec(line:denote():trim())}
	
	elifs = {}
	el = {}
	for i2 = pos+1, #reader.file["scenario.rpy"].line do
		line = reader.file["scenario.rpy"].line[i2]
		level = getLevel(line, fName, i2)
		
		if level <= i.level then
			line = line:denote():trim()
			if line:sub(1,1) ~= "e" then
				pass = i2-1
				break;
			else
				if line:sub(1,4) == "elif" then
					table.insert(elifs, {pos=i2, level=level, exec=makeExec(line)})
				elseif line:sub(1,4) == "else" then
					el = {pos=i2, level=level}
				else
					pass = i2-1
					break;
				end
			end
		end
		
		if i2 == #reader.file["scenario.rpy"].line then
			pass = i2
			break;
		end
	end
	
	if not ren.keyword.key_if[fName] then ren.keyword.key_if[fName] = {} end
	ren.keyword.key_if[fName][start] = {i=i, elifs=elifs, el=el, pass=pass}
end
function ren.keyword_label()
	local line = ""
	for pos = 1, #reader.file["scenario.rpy"].line do
		line = reader.file["scenario.rpy"].line[pos]
		if line:sub(1,1) == "l" and line:sub(1,5) == "label" then
			ren.keyword.label[line:match("label (.*):")] = {fName="scenario.rpy", pos=pos}
		end
	end
end
function keywords_mods.label()
	local line = ""

	for id, mod in pairs(mods) do
		local files = mods[id].rpy_scenario
		local folder = mods[id].folder

		for id2, file in pairs(files) do
			for pos = 1, #reader.file[folder.."/"..file].line do
				line = reader.file[folder.."/"..file].line[pos]
				if line:sub(1,1) == "l" and line:sub(1,5) == "label" then
					ren.keyword.label[line:match("label (.*):")] = {fName=folder.."/"..file, pos=pos}
				end
			end
		end
	end
end
function keywords_mods.menu(fName, pos)
	local start = tostring(pos)
	
	local line, level
	local cases, clevel
	
	line = reader.file[fName].line[pos]
	level = getLevel(line, fName, pos)
	
	cases = {}
	for i = pos+1, #reader.file[fName].line do
		line = reader.file[fName].line[i]
		clevel = getLevel(line, fName, i)
		
		if clevel == level+1 then
			if not line:denote():trim():match("(.*):.-") then
				error("menu-case expected, got '"..line.."' in file "..fName.." at line "..i)
			end
			table.insert(cases, {pos=i, name=line:denote():trim():match("(.*):.-")})
		elseif clevel <= level then
			pass = i-1
			break;
		end
	end
	
	if not ren.keyword.switch[fName] then ren.keyword.switch[fName] = {} end
	ren.keyword.switch[fName][start] = {level=level, case=cases, pass=pass}
end
function keywords_mods.ifs(fName, pos)
	local start = tostring(pos)
	
	local line, level
	local i, elifs, el, pass
	
	line = reader.file[fName].line[pos]
	level = getLevel(line, fName, pos)
	i = {pos=pos, level=level, exec=makeExec(line:denote():trim())}
	
	elifs = {}
	el = {}
	for i2 = pos+1, #reader.file[fName].line do
		line = reader.file[fName].line[i2]
		level = getLevel(line, fName, i2)
		
		if level <= i.level then
			line = line:denote():trim()
			if line:sub(1,1) ~= "e" then
				pass = i2-1
				break;
			else
				if line:sub(1,4) == "elif" then
					table.insert(elifs, {pos=i2, level=level, exec=makeExec(line)})
				elseif line:sub(1,4) == "else" then
					el = {pos=i2, level=level}
				else
					pass = i2-1
					break;
				end
			end
		end
		
		if i2 == #reader.file[fName].line then
			pass = i2
			break;
		end
	end
	
	if not ren.keyword.key_if[fName] then ren.keyword.key_if[fName] = {} end
	ren.keyword.key_if[fName][start] = {i=i, elifs=elifs, el=el, pass=pass}
end