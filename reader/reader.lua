function Reader()
	local o = {
    order = {},
		file = {},
		fName = "",
		pos = 0
	}
	function o:new(fNames, fName, pos)
    self.order = fNames
		for _, fName in ipairs(fNames) do
			self.file[fName] = {
        name = fName,
        line = getLines(fName)
    	}
		end
		if fName then -- load
			self.fName = fName
			self.pos = pos
			return self
		end
    self.fName = fNames[1]
		return self
	end
	function o:save()
		return {
			order = self.order,
			fName = self.fName,
			pos = self.pos
		}
	end
	function o:getLine(pos) return self.file[self.fName].line[pos] end
	function o:toLine(pos) self.pos = pos end
	function o:toFile(fName)
		if fName == nil then
			error("reader:toFile(fName) got arguments[self="..dump(self)..", fName="..dump(fName).."]", 2)
		end
		self.fName = fName
    self:toLine(0)
  end
  function o:nextFile()
    if self.fName == self.order[#self.order] then
      return false -- EOFs
    end
		
    for fPos, fName in ipairs(self.order) do
      if self.fName == fName then
        self:toFile(self.order[fPos + 1])
        return true
      end
    end	
	error("impossible reader error")
  end
	function o:next()
	    ren.history.current.sprites = ren.settings.show.images
		if self.pos == #self.file[self.fName].line then -- EOF
			if not self:nextFile() then
				return false -- EOFs
			end
		end
		self.pos = self.pos + 1
		return self.file[self.fName].line[self.pos]
	end
	function o:previous()
		if ren.history.current.image ~= ren.history.previous[#ren.history.previous]["image"] then
			ren.func.scene("scene "..ren.history.previous[#ren.history.previous]["image"])
		end
		if ren.history.current.picture ~= ren.history.previous[#ren.history.previous]["picture"] then
			if ren.history.previous[#ren.history.previous]["picture"] == "none" then 
			ren.func.hide("hide " ..ren.history.current.picture)
			elseif ren.history.previous[#ren.history.previous]["picture"] ~= nil then
			ren.func.show("show "..ren.history.previous[#ren.history.previous]["picture"])
			else
			--шо?
			end
		end
		if ren.history.current.sprite1 ~= ren.history.previous[#ren.history.previous]["sprite1"] then
			if ren.history.previous[#ren.history.previous]["sprite1"] == "none" then 
			ren.func.hide("hide " ..ren.history.current.sprite1)
			else
			ren.func.hide("hide " ..ren.history.current.sprite1)
			ren.func.show("show sl shy pioneer at center")--..ren.history.previous[#ren.history.previous]["sprite1"].." at "..ren.history.previous[#ren.history.previous]["point1"])
			end
		else
			if ren.history.current.point1 ~= ren.history.previous[#ren.history.current]["point1"] then
			ren.func.show("show "..ren.history.current.sprite1.." at "..ren.history.previous[#ren.history.previous]["point1"])
			end
		end
		--[[if ren.history.current.sprite2 ~= ren.history.previous[#ren.history.previous]["sprite2"] then
			if ren.history.previous[#ren.history.previous]["sprite2"] == "none" then 
			ren.func.hide("hide " ..ren.history.current.sprite2)
			else
			ren.func.hide("hide " ..ren.history.current.sprite2)
			ren.func.show("show "..ren.history.previous[#ren.history.previous]["sprite2"].." at "..ren.history.previous[#ren.history.previous]["point2"])
			end
		else
			if ren.history.current.point2 ~= ren.history.previous[#ren.history.current]["point2"] then
			ren.func.show("show "..ren.history.current.sprite2.." at "..ren.history.previous[#ren.history.previous]["point2"])
			end
		end
		if ren.history.current.sprite3 ~= ren.history.previous[#ren.history.previous]["sprite3"] then
			if ren.history.previous[#ren.history.previous]["sprite3"] == "none" then 
			ren.func.hide("hide " ..ren.history.current.sprite3)
			else
			ren.func.hide("hide " ..ren.history.current.sprite3)
			ren.func.show("show "..ren.history.previous[#ren.history.previous]["sprite3"].." at "..ren.history.previous[#ren.history.previous]["point3"])
			end
		else
			if ren.history.current.point3 ~= ren.history.previous[#ren.history.current]["point3"] then
			ren.func.show("show "..ren.history.current.sprite3.." at "..ren.history.previous[#ren.history.previous]["point3"])
			end
		end
		if ren.history.current.sprite4 ~= ren.history.previous[#ren.history.previous]["sprite4"] then
			if ren.history.previous[#ren.history.previous]["sprite4"] == "none" then 
			ren.func.hide("hide " ..ren.history.current.sprite4)
			else
			ren.func.hide("hide " ..ren.history.current.sprite4)
			ren.func.show("show "..ren.history.previous[#ren.history.previous]["sprite4"].." at "..ren.history.previous[#ren.history.previous]["point4"])
			end
		else
			if ren.history.current.point4 ~= ren.history.previous[#ren.history.current]["point4"] then
			ren.func.show("show "..ren.history.current.sprite4.." at "..ren.history.previous[#ren.history.previous]["point4"])
			end
		end
		if ren.history.current.sprite5 ~= ren.history.previous[#ren.history.previous]["sprite5"] then
			if ren.history.previous[#ren.history.previous]["sprite5"] == "none" then 
			ren.func.hide("hide " ..ren.history.current.sprite5)
			else
			ren.func.hide("hide " ..ren.history.current.sprite5)
			ren.func.show("show "..ren.history.previous[#ren.history.previous]["sprite5"].." at "..ren.history.previous[#ren.history.previous]["point5"])
			end
		else
			if ren.history.current.point5 ~= ren.history.previous[#ren.history.current]["point5"] then
			ren.func.show("show "..ren.history.current.sprite5.." at "..ren.history.previous[#ren.history.previous]["point5"])
			end
		end
		if ren.history.current.sprite6 ~= ren.history.previous[#ren.history.previous]["sprite6"] then
			if ren.history.previous[#ren.history.previous]["sprite6"] == "none" then 
			ren.func.hide("hide " ..ren.history.current.sprite6)
			else
			ren.func.hide("hide " ..ren.history.current.sprite6)
			ren.func.show("show "..ren.history.previous[#ren.history.previous]["sprite6"].." at "..ren.history.previous[#ren.history.previous]["point6"])
			end
		else
			if ren.history.current.point6 ~= ren.history.previous[#ren.history.current]["point6"] then
			ren.func.show("show "..ren.history.current.sprite6.." at "..ren.history.previous[#ren.history.previous]["point6"])
			end
		end
		if ren.history.current.sprite7 ~= ren.history.previous[#ren.history.previous]["sprite7"] then
			if ren.history.previous[#ren.history.previous]["sprite7"] == "none" then 
			ren.func.hide("hide " ..ren.history.current.sprite7)
			else
			ren.func.hide("hide " ..ren.history.current.sprite7)
			ren.func.show("show "..ren.history.previous[#ren.history.previous]["sprite7"].." at "..ren.history.previous[#ren.history.previous]["point7"])
			end
		else
			if ren.history.current.point7 ~= ren.history.previous[#ren.history.current]["point7"] then
			ren.func.show("show "..ren.history.current.sprite7.." at "..ren.history.previous[#ren.history.previous]["point7"])
			end
		end
		if ren.history.current.sprite8 ~= ren.history.previous[#ren.history.previous]["sprite8"] then
			if ren.history.previous[#ren.history.previous]["sprite8"] == "none" then 
			ren.func.hide("hide " ..ren.history.current.sprite8)
			else
			ren.func.hide("hide " ..ren.history.current.sprite8)
			ren.func.show("show "..ren.history.previous[#ren.history.previous]["sprite8"].." at "..ren.history.previous[#ren.history.previous]["point8"])
			end
		else
			if ren.history.current.point8 ~= ren.history.previous[#ren.history.current]["point8"] then
			ren.func.show("show "..ren.history.current.sprite8.." at "..ren.history.previous[#ren.history.previous]["point8"])
			end
		end]]--
		if ren.history.current.music ~= ren.history.previous[#ren.history.previous]["music"] then
			if ren.history.previous[#ren.history.previous]["music"] == "none" then
				ren.func.stop("stop music")
			else
				ren.func.play("play music music_list[\""..ren.history.previous[#ren.history.previous]["music"].."\"]")
			end
		end
		if ren.history.current.ambience ~= ren.history.previous[#ren.history.previous]["ambience"] then
			if ren.history.previous[#ren.history.previous]["ambience"] == "none" then
				ren.func.stop("stop ambience")
			else
				ren.func.play("play ambience "..ren.history.previous[#ren.history.previous]["ambience"])
			end
		end
		if ren.history.current.sound_loop ~= ren.history.previous[#ren.history.previous]["sound_loop"] then
			if ren.history.previous[#ren.history.previous]["sound_loop"] == "none" then
				ren.func.stop("stop sound_loop")
			else
				ren.func.play("play sound_loop "..ren.history.previous[#ren.history.previous]["sound_loop"])
			end
		end
		ren.history.current = {
			sprite1 = ren.history.previous[#ren.history.previous]["sprite1"],
			sprite2 = ren.history.previous[#ren.history.previous]["sprite2"],
			sprite3 = ren.history.previous[#ren.history.previous]["sprite3"],
			sprite4 = ren.history.previous[#ren.history.previous]["sprite4"],
			sprite5 = ren.history.previous[#ren.history.previous]["sprite5"],
			sprite6 = ren.history.previous[#ren.history.previous]["sprite6"],
			sprite7 = ren.history.previous[#ren.history.previous]["sprite7"],
			sprite8 = ren.history.previous[#ren.history.previous]["sprite8"],
			point1 = ren.history.previous[#ren.history.previous]["point1"],
			point2 = ren.history.previous[#ren.history.previous]["point2"],
			point3 = ren.history.previous[#ren.history.previous]["point3"],
			point4 = ren.history.previous[#ren.history.previous]["point4"],
			point5 = ren.history.previous[#ren.history.previous]["point5"],
			point6 = ren.history.previous[#ren.history.previous]["point6"],
			point7 = ren.history.previous[#ren.history.previous]["point7"],
			point8 = ren.history.previous[#ren.history.previous]["point8"],
			picture = ren.history.previous[#ren.history.previous]["picture"],
			image = ren.history.previous[#ren.history.previous]["image"],
			music = ren.history.previous[#ren.history.previous]["music"],
			sound = ren.history.previous[#ren.history.previous]["sound"],
			sound_loop = ren.history.previous[#ren.history.previous]["sound_loop"],
			ambience = ren.history.previous[#ren.history.previous]["ambience"],
			text = ren.history.previous[#ren.history.previous]["text"],
			pos = ren.history.previous[#ren.history.previous]["pos"]
		}
		self.pos = ren.history.previous[#ren.history.previous]["pos"]
		ren.history.previous[#ren.history.previous] = nil
		
		return self.file[self.fName].line[self.pos]
	end
	function o:history_back(title)
		if ren.history.current.image ~= ren.history.previous[title]["image"] then
			ren.func.scene("scene "..ren.history.previous[title]["image"])
		end
		if ren.history.current.music ~= ren.history.previous[title]["music"] then
			if ren.history.previous[title]["music"] == "none" then
				ren.func.stop("stop music")
			else
				ren.func.play("play music music_list[\""..ren.history.previous[title]["music"].."\"]")
			end
		end
		if ren.history.current.ambience ~= ren.history.previous[title]["ambience"] then
			if ren.history.previous[title]["ambience"] == "none" then
				ren.func.stop("stop ambience")
			else
				ren.func.play("play ambience "..ren.history.previous[title]["ambience"])
			end
		end
		if ren.history.current.sound_loop ~= ren.history.previous[title]["sound_loop"] then
			if ren.history.previous[title]["sound_loop"] == "none" then
				ren.func.stop("stop sound_loop")
			else
				ren.func.play("play sound_loop "..ren.history.previous[title]["sound_loop"])
			end
		end
		ren.history.current = {
			image = ren.history.previous[title]["image"],
			music = ren.history.previous[title]["music"],
			sound = ren.history.previous[title]["sound"],
			sound_loop = ren.history.previous[title]["sound_loop"],
			ambience = ren.history.previous[title]["ambience"],
			text = ren.history.previous[title]["text"],
			pos = ren.history.previous[title]["pos"],
			sprites = ren.history.previous[title]["sprites"]
		}
		ren.settings.show.images = ren.history.previous[title]["sprites"]
		self.pos = ren.history.previous[title]["pos"]
		for i in pairs(ren.history.previous) do
			if #ren.history.previous ~= title then
				ren.history.previous[#ren.history.previous] = nil
			else
				ren.history.previous[title] = nil
				break
			end
		end
		
		
		return self.file[self.fName].line[self.pos]
	end
	return o
end
function readFiles(files)
    reader = Reader():new(files)
end

function findMods(folder, table)
	local modcontent = files.listdirs(folder)

	for index, entry in ipairs(modcontent) do
        if files.exists(folder.."/"..entry.name.."/modinit.init") then
            dofile(folder.."/"..entry.name.."/modinit.init")
        end
    end
end
function mods_start()
	local n = 1

	for i, value in pairs(mods) do
		mods[n] = {}
		mods[n].name = mods[i].name
        mods[n].folder = mods[i].folder
		mods[n].files = mods[i].files
		mods[n].memory_needed = mods[i].memory_needed
		mods[n].save_folder = mods[i].save_folder
		mods[n].label = mods[i].label
		mods[n].rpy_resources = mods[i].rpy_resources
		mods[n].rpy_scenario = mods[i].rpy_scenario

		mods[i] = nil

		n=n+1
    end
end

keywords_mods = {}

function readMods(folder, array)
	findMods(folder, array)
    mods_start()
end