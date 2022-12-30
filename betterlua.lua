-- Better Lua Lib

table.join = table.concat
function bool(arg) return not (arg == "" or arg == nil or arg == false or arg == 0) end
function dump(o)
    if type(o) == 'table' then
			local s = '{'
			for k,v in ipairs(o) do
				s = s..'['..k..']='..dump(v)..','
			end
			for k,v in pairs(o) do
				if type(k) ~= 'number' then
					s = s..'["'..k..'"]='..dump(v)..','
				end
			end
			return s..'}'
    elseif type(o) ~= 'string' then
			return tostring(o)
		else
			return '"'..o:gsub('"','\\"')..'"'
		end
end
function string:eval()
	if pcall(function() assert(loadstring(string.format("return %s", self)))() return true end) then
		return assert(loadstring(string.format("return %s", self)))()
	else
		error("unexpected evaluation: "..self, 2)
	end
end
function string:trim() return self:gsub("^%s*(.-)%s*$","%1") end
function string:escape() return self:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])","%%%1") end
function string:toRGB()
    local hex = self:gsub("#","")
    return {tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))}
end
function string:split(symbols)
	if not bool(symbols) then symbols = " " end
	local o = 1
	local k = 1
	local l = symbols:len()-1
	local res = {}
	while k <= self:len() do
		if self:sub(k, k+l) == symbols then
			table.insert(res, self:sub(o, k-1))
			k=k+l
			o=k+1
		end
		k=k+1
	end
	table.insert(res, self:sub(o, k))
	return res
end
function string:splitIndex(symbols, i)
	if not bool(symbols) then symbols = " " end
	if not bool(i) then i = 1 end
	local o = 1
	local k = 1
	local l = symbols:len()-1
	local splits = 0
	local res = {}
	while k <= self:len() do
		if self:sub(k, k+l) == symbols then
			splits = splits+1
			if splits == i then
				table.insert(res, self:sub(o, k-1))
				k=k+l
				o=k+1
			end
		end
		k=k+1
	end
	table.insert(res, self:sub(o, k))
	return res
end
function string:splitLimit(number,offset0)
	local offset = offset0 or 0
	local words = self:split(" ")
	local res = {}
	local str = ""
	local i = 1
	for i = 1, #words do
		if offset + str:utfLen() + words[i]:utfLen() > number then
			if str ~= "" then
				table.insert(res, str)
			end
			str = ""
			if words[i]:utfLen() > number then
				table.insert(res, words[i])
			else
				str = words[i]
			end
			offset = 0
		else
			if str~="" then str = str.." " end
			str = str..words[i]
		end
	end
	table.insert(res, str)
	return res
end

function table.joinRange(array, pos0, pos)
	return table.join(table.slice(array, pos0, pos),' ')
end
function table.toObject(array)
	local res = {}
	for i in pairs(array) do
		if type(i)~="number" then res[i] = array[i] end
	end
	return res
end
function table.slice(array, pos0, pos)
	if not bool(pos) then pos = #array end
	local res = {}
	for i = 1, #array do
		if i>=pos0 and i<=pos then
			table.insert(res,array[i])
		end
	end
	return res
end
function table.indexOf(array, str)
	for i, v in ipairs(array) do
		if v == str then
			return i
		end
	end
	return 0
end
function table.concat(array0, array)
	local res = array0
	if type(array) == "string" then msg = timeText("ERROR:"..array) return array0 end
	for i in ipairs(array) do
		table.insert(res, array[i])
	end
	return res
end
function table.splice(array, index, length)
	length = math.min(#array-index+1, length)
	local arr = {}

	for i = index, index+length-1 do
		arr[i-index+1] = array[i]
        array[i] = array[i+length]
	end

	for i = index+length-1, #array do
		if i+length <= #array then
			array[i] = array[i+length]
		else
			array[i] = nil
		end
	end
	return arr
end

function error2(arr)
	local str = ""
	for i = 1, #arr do
		str = str.."<-->"..tostring(arr[i])
	end
	error(str:sub(5), 2)
end