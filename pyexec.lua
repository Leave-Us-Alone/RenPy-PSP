-- Py Exec Lib
function string:uwordClear() return self:gsub("u('.-')","%1"):gsub('u(".-")','%1') end

function string:key_tree()
	local tree = {}
	
	local pos = 1
	for i = 1, self:len() do
		if self:sub(i, i) == "." or self:sub(i, i) == "[" then
			if self:sub(i-1, i-1) ~= "]" then
				table.insert(tree, self:sub(pos, i - 1))
				if self:sub(i, i) == "." then pos = i + 1
				else
					if self:sub(i+1, i+1) == '"' or self:sub(i+1, i+1) == "'" then
						pos = i + 2
					else
						pos = i + 1
					end
				end
			end
		elseif self:sub(i, i) == "]" then
			if self:sub(i-1, i-1) == '"' or self:sub(i-1, i-1) == "'" then
				table.insert(tree, self:sub(pos, i - 2))
			else
				table.insert(tree, tonumber(self:sub(pos, i - 1)))
			end
		end
	end
	if self:sub(self:len(), self:len()) ~= "]" then
		table.insert(tree, self:sub(pos, self:len()))
	end
	return tree
end
function string:var2pointer(pointer)
	return getPointer(pointer, self:key_tree())
end
function getPointer(pointer, tree)
	if #tree == 0 then return pointer end
	for _, key in ipairs(tree) do
		if pointer[key] == nil then error("pointer by tree "..dump(tree).." is no exist") end
		pointer = pointer[key]
	end
	return pointer
end





--[[
	FUNC = smth.or.smth["other"](.*)
	OP
	NUM
	EXPR
--]]
function string:isString()
	local type = self:sub(1, 1)
	if not (type == "'" or type == '"') then return false end
	
	local open = false
	for i = 1, self:len() do
		if self:sub(i, i) == type and self:sub(i-1, i-1) ~= "\\" then
			if open == true then
				return i == self:len()
			else
				open = true
			end
		end
	end
end
function string:isNumber()
	return tonumber(self) ~= nil
end
function string:isObject()
	if not (self:sub(1, 1) == "{" and self:sub(self:len(), self:len()) == '}') then return false end
	
	local open_count = 0
	for i = 1, self:len() do
		if self:sub(i, i) == "{" then
			open_count = open_count + 1
		elseif self:sub(i, i) == "}" then
			open_count = open_count - 1
			if open_count == 0 then
				return i == self:len()
			end
		end
	end
	
	return false
end
function string:isFunc()
	return self:match("[%a_][%w_%.%[%]\"'%s]-%(.*%)") == self
end
function string:isVar(pointer)
	local tree = self:key_tree()
	if #tree == 0 then return false end
	for _, key in ipairs(tree) do
		if pointer[key] == nil then return false end
		pointer = pointer[key]
	end
	return true
end



function string:charInString(pos)
	local open = false
	local type = ""
	
	for i = 1, self:len() do
		if self:sub(i, i) == "'" or self:sub(i, i) == '"' then
			if self:sub(i-1, i-1) ~= "\\" then
				if type == self:sub(i, i) then
					open = false
					type = ""
				else
					open = true
					type = self:sub(i, i)
				end
			end
		end
		
		if i == pos then
			return open
		end
	end
	
	return false
end
function string:testOp(regexp)
	local tmp = 1
	
	local replaces = {}
	
	local pos = 0
	local pos2 = 0
	
	while true do
		pos, pos2 = self:find(regexp, tmp)
		if pos == nil then return replaces end
		
		if not self:charInString(pos) then
			table.insert(replaces, {pos,pos2})
		end
		
		tmp = pos2 + 1
	end
end



function cast(result)
	if type(result) == 'number' then
		result = tostring(result)
	elseif type(result) == 'string' then
		result = '"'..result..'"'
	elseif type(result) == 'table' then
		result = dump(result)
	end
	return result
end


function string:putRenVars()
	local len, dx, names
	
	len = self:len()
	dx = 0
	names = self:testOp("[%a_][%w_%.]*")
	for _,pos in ipairs(names) do
		local name = self:sub(dx + pos[1], dx + pos[2]):trim()
		if name:isVar(ren.settings.var) then
			self = self:sub(1, dx + pos[1] - 1) .. 'ren.settings.var.'..name .. self:sub(dx + pos[2] + 1)
			dx = self:len() - len
		end
	end
	
	return self
end
function string:execVars()
	local len, dx, names
	
	len = self:len()
	dx = 0
	names = self:testOp("[%a_][%w_%.]*")
	for _,pos in ipairs(names) do
		local name = self:sub(dx + pos[1], dx + pos[2]):trim()
		if name:isVar(ren.settings.var) then
			self = self:sub(1, dx + pos[1] - 1) .. cast(name:var2pointer(ren.settings.var)) .. self:sub(dx + pos[2] + 1)
			dx = self:len() - len
		end
	end
	
	return self
end
function string:execBrackets()
	local len, dx, names
	
	len = self:len()
	dx = 0
	names = self:testOp("[^%a_]%(([%%%+%-%*/%s%d%.eE]+)%)")
	for _,pos in ipairs(names) do
		self = self:sub(1, dx + pos[1] - 1) .. cast(self:sub(dx + pos[1], dx + pos[2]):eval()) .. self:sub(dx + pos[2] + 1)
		dx = self:len() - len
	end
	
	return self
end
function string:execMath()
	local len, dx, names
	
	len = self:len()
	dx = 0
	names = self:testOp("[^%a%p]([%%%+%-%*/%s%d%.eE]+)[^%a%p]")
	for _,pos in ipairs(names) do
		self = self:sub(1, dx + pos[1] - 1) .. cast(self:sub(dx + pos[1], dx + pos[2]):eval()) .. self:sub(dx + pos[2] + 1)
		dx = self:len() - len
	end
	
	return self
end
function string:execFunc()
	local len, dx, names
	
	len = self:len()
	dx = 0
	names = self:testOp("[%a_][%w_%.]*")
	for _,pos in ipairs(names) do
		local name = self:sub(dx + pos[1], dx + pos[2]):trim()
		if self:sub(dx+pos[2]+1, dx+pos[2]+1) == "(" then
			local pos3 = self:nextBracket(dx + pos[2] + 1)
			self = self:sub(1, dx + pos[1] - 1) .. cast(name:var2pointer(ren.py)(self:sub(dx + pos[2] + 2, dx + pos3 - 1):uwordClear()) or '') .. self:sub(dx + pos3 + 1)
			dx = self:len() - len
		--elseif name ~= 'true' and name ~= 'false' then
			--error2({"not var and not func?!", self, name})
		end
	end
	
	return self
end
function string:expr_exec()
	self = self:trim()
	
	self = self:execVars() -- variable -> value
	self = self:execBrackets() -- calculations in brackets
	self = self:execMath() -- calculations
	self = self:execFunc() -- func -> value
	
	return self
end
function string:evalpy() -- $ lp_dv = 0
	local str = self:sub(3) -- delete $
	
	local op = str:match("[%a_][%w_%.%[%]\"'%s]- (=) .*")
	if op ~= nil then
		--do right expression
		local tree = str:match("([%a_][%w_%.%[%]\"'%s]-) = .*"):key_tree()
		local last = table.splice(tree, #tree, 1)[1]
		
		local pointer = getPointer(ren.settings.var, tree)
		pointer[last] = str:match("[%a_][%w_%.%[%]\"'%s]- = (.*)"):expr_exec():eval()
	else
		str:expr_exec()
	end
end

function string:nextBracket(pos)
	local counter = 0
  for i = pos, #self do
  	if self[i] == "(" then
      counter = counter + 1
    elseif self[i] == ")" then
    	counter = counter - 1
      if counter == 0 then
        return pos
      end
    end
  end
  return #self
end

function string:func2obj()
	return self:uwordClear():match("%(.*%)"):gsub("[%[%(]","{"):gsub("[%]%)]","}"):eval()
end
