function dumpfile(file, o)
	if type(o) == 'table' then
		file:write('{')
		for k,v in ipairs(o) do
			file:write('['..k..']=')
			dumpfile(file, v)
			file:write(',')
		end
		for k,v in pairs(o) do
			if type(k) ~= 'number' then
				file:write('["'..k..'"]=')
				dumpfile(file, v)
				file:write(',')
			end
		end
		file:write('}')
	elseif type(o) ~= 'string' then
		file:write(tostring(o))
	else
		file:write('"'..o:gsub('"','\\"')..'"')
	end
end