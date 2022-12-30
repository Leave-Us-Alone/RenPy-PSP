function table.reverse(arr)
    local len = #arr
    local arr2 = {}
    for i, v in ipairs (arr) do
        arr2[len - i] = v
    end
    return arr2
end
function bits(x)
	local arr = {}
	while x > 0 do
		table.insert(arr, x % 2)
		x = math.floor(x / 2)
	end
	while #arr < 8 do
	    table.insert(arr, 0)
	end
	return table.reverse(arr)
end
function string:getChar()
	if self == "" then return "" end
	
  local code = self:byte(1)
  if code < 128 then
    return self:sub(1, 1)
	end
  
  local bits = bits(code)
  for i = 1, #bits do
    if bits[i] == 0 then
      return self:sub(1, i)
    end
  end
end
function string:toCharArray()
	local arr = {}
  local len = self:len()
  local w = 0
	local char = ""
  while w < len do
    char = self:sub(w+1, len):getChar()
  	table.insert(arr, char)
    w = w + char:len()
	end
  return arr
end
function string:utfLen()
	return #self:toCharArray()
end