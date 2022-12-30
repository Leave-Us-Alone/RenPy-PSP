ren.map = {
	ground = function(level)
		local i = reader.pos+1
		while i <= #reader.file[reader.fName].line do
			local line = reader.file[reader.fName].line[i]
			local level2 = getLevel(line)
			local str = line:denote():trim()
			if str ~= "" then
				if level2 < level then
					error(reader.fName.."->"..i.." incorrect level or no ground statement", 2)
				end
				if str:match("^ground") then
					return str:match("ground (.*)"):eval()
				end
			end
			i = i+1
		end
	end,
	hover = function(level)
		local i = reader.pos+1
		while i <= #reader.file[reader.fName].line do
			local line = reader.file[reader.fName].line[i]
			local level2 = getLevel(line, reader.fName, reader.pos)
			local str = line:denote():trim()
			if str ~= "" then
				if level2 < level then
					error(reader.fName.."->"..i.." incorrect level or no hover statement", 2)
				end
				if str:match("^hover") then
					return str:match("hover (.*)"):eval()
				end
			end
			i = i+1
		end
	end,
	hotspot = function(level)
		local arr = {}
		local i = reader.pos+1
		while i <= #reader.file[reader.fName].line do
			local line = reader.file[reader.fName].line[i]
			local level2 = getLevel(line, reader.fName, reader.pos)
			local str = line:denote():trim()
			if str ~= "" then
				if level2 < level then
					return arr
				end
				if str:match("^hotspot") then
					table.insert(arr, ren.map.spot(str))
				end
			end
			i = i+1
		end
	end,
	spot = function(str)
		local hotspot = str:match("hotspot %((.-)%)")
		local jump = str:match("action Jump%((.-)%)")
		local hovered = str:match("hovered play%(.-, (.-)%)") or nil
		local spot = {}
		spot.x = tonumber(hotspot:match("^(.-),.-,.-,.-"))
		spot.y = tonumber(hotspot:match(".-,(.-),.-,.-"))
		spot.w = tonumber(hotspot:match(".-,.-,(.-),.-"))
		spot.h = tonumber(hotspot:match(".-,.-,.-,(.-)$"))
		spot.jump = function()
			ren.func.jump("jump "..jump)
			ren.pause = false
			ren.next = true
			ren.settings.map.active = false
			ren.settings.map.hotspot = {}
		end
		spot.hovered = function()
			if hovered then 
				ren.func.play("play sound "..hovered.." fadein 0")
			end
		end
		return spot
	end
}
ren.func.imagemap = function(str, level)
	local ground = ren.map.ground(level+1)
	local hover = ren.map.hover(level+1)
	local hotspot = ren.map.hotspot(level+1)
	ren.settings.map.active = true
	ren.settings.map.hotspot = hotspot
	
	ren.ground_new = API.image.load(ground)
	ren.hover = API.image.load(hover)
	ren.gui.cursor = API.image.load("resources/images/gui/cursor/cursor.png")
	
	ren.settings.map.ground_new = 0
	ren.settings.map.ground = 255
	
	asyncCycle:new(0, 255, 20, 2,
	function(i)
		ren.settings.map.ground_new = i
		if i == 255 then
			ren.ground = ren.ground_new
			ren.ground_new = nil
			ren.settings.map.ground = ren.settings.map.ground_new
			ren.settings.map.ground_new = 0
		end
	end)
	collectgarbage()
	ren.next = false
	ren.pause = true
end