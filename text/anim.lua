textAnim = {
	create = function(db, msg, ms)
		local o = {
			get = function(self)
				if self.i == self.i1 then 
					API.timer.update(self.time)
					return self.text
				end
				if API.timer.time(self.time) > self.ms then
					for i = 1, math.floor(API.timer.time(self.time)/self.ms) do
						self.i = self.i + self.text:sub(self.i+1):getChar():len()
					end
					API.timer.update(self.time)
				end
				return self.text:sub(1, self.i)
			end,
			
			next = function(self)
				--do step
				if self.i == self.i1 then
					if self.wait == self.wait1 then
						return true --nothing done => ren.eval()
					end
					self.wait = self.wait + 1
				else
					self.i = self.i1
				end
				
				--remake text
				self.text = ""
				for i = 1, self.wait do
					self.text = self.text..self.arr[i]
				end
				self.i1 = self.text:len()
				
				return false --done step => call again
			end,
			add = function(self, text)
				--save current
				local i = self.i
				local wait = self.wait
				
				--add new text
				self = timeText(self.text0.." "..text)
				self.i = i
				self.wait = wait
				
				--remake text
				self.text = ""
				for i = 1, self.wait do
					self.text = self.text..self.arr[i]
				end
				self.i1 = self.text:len()
				
				return self
			end,
			save = function(self)
				return {
					ms = self.ms,
					wait = self.wait,
					wait1 = self.wait1,
					arr = self.arr,
					i = self.i,
					i1 = self.i1,
					text0 = self.text0,
					text = self.text
				}
			end,
			load = function(self, data)
				self.ms = data.ms
				self.wait = data.wait
				self.wait1 = data.wait1
				self.arr = data.arr
				self.i = data.i
				self.i1 = data.i1
				self.text0 = data.text0
				self.text = data.text
			end
		}
		
		o.ms = ms
		o.time = API.timer.new()
		API.timer.update(o.time)
		
		o.arr = msg:split("{w}")
		
		o.i = msg:getChar():len()
		o.i1 = o.arr[1]:len()
		
		o.wait = 1
		o.wait1 = #o.arr
		
		o.text0 = db
		o.text = o.arr[1]
		return o
	end
}


function timeText(msg)
	return textAnim.create(
		msg,
		table.join(msg:splitLimit(ren.settings.dialog.box.limit, (""):utfLen()), "\n"),
		11
	)
end