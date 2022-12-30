-- Better PGE Lib
function string:write(data)
	local pFile = io.open(self, "a")
	pFile:write(data)
	pFile:close()
end
function string:replace(data)
	error('test'..'|'..self..'|'..data)
	local pFile = io.open(self, "w")
	pFile:write(data)
	pFile:close()
end
function string:read()
	local pFile = io.open(self, "r")
	local data = pFile:read()
	pFile:close()
end
asyncCycle = {
	array = {},
	update = function(self)
		if not bool(self) then self = asyncCycle end
		
		local n = 0
		local i = 1
		while i-n <= #self.array do
			self.array[i-n]:update()
			if self.array[i-n].i == self.array[i-n].max then
				table.splice(self.array, i-n, 1)
				n = n + 1
			end
			i = i + 1
		end
	end,
	new = function(self, from, to, step, ms, func)
		if not bool(self) then self = asyncCycle end
		local o = {}
		function o:update()
			if API.timer.time(self.time)>self.ms then
				self.i = self.i+self.step
				API.timer.update(self.time)
			end
			if (step>0 and self.i>self.max) or (step<0 and self.i<self.max) then
				self.i = self.max
			end
			func(self.i)
		end
		
		o.ms = ms/10000
		o.time = API.timer.new()
		API.timer.update(o.time)
		
		o.i = from
		o.max = to
		o.step = step
		
		table.insert(self.array, o)
	end
}

function getFile(fName)
	local file = assert(io.open(fName, "rb"))
	local str = file:read("*all")
	file:close()
	return str
end

function getLines(fName) return getFile(fName):split("\n") end

dircontents = files.listfiles("")
dirsed = #dircontents
function GoToTypes(typ,massive)
    local newfile = 1
    for index, entry in ipairs(dircontents) do    
        if entry.name:lower():find(typ) then
            massive[newfile] = entry.name:lower()
            newfile = newfile + 1
        end
    end
    local newfile = 1
end

function getHour()
	local date = os.getdate()
	local hour = date:sub(18,19)
	return tonumber(hour)
end
function getMinute()
	local date = os.getdate()
	local hour = date:sub(18,19)
	return tonumber(hour)
end
function getSecond()
	local date = os.getdate()
	local hour = date:sub(18,19)
	return tonumber(hour)
end