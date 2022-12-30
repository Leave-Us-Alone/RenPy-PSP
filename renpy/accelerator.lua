function ren.py.saveDefault()
	ren.file = io.open("renpy/acc/accelerator.lua", "r")
	if not ren.file then
		ren.file = io.open("renpy/acc/accelerator.lua", "w")
		ren.file:write("ren.settings=")
		reader.pos = reader.pos - 1
		dumpfile(ren.file, ren.settings)
		reader.pos = reader.pos + 1
		ren.file:close()
	else
		ren.file:close()
	end
	
	ren.file = io.open("renpy/acc/keyword_accelerator.lua", "r")
	if not ren.file then
		ren.keyword_collector()
		
		ren.file = io.open("renpy/acc/keyword_accelerator.lua", "w")
		ren.file:write("ren.keyword=")
		dumpfile(ren.file, ren.keyword)
		ren.file:close()
	else
		ren.file:close()
	end
end
function ren.py.loadDefault()
	ren.file = io.open("renpy/acc/keyword_accelerator.lua", "r")
	if ren.file then
		ren.file:close()
		dofile("renpy/acc/keyword_accelerator.lua")
	end
	
	ren.file = io.open("renpy/acc/accelerator.lua", "r")
	if ren.file then
		ren.file:close()
		dofile("renpy/acc/accelerator.lua")
		
		for name in pairs(ren.settings.character) do
			ren.func[name] = character_speech
		end
		
		msg:load(ren.settings.msg)--text
		reader = Reader():new(ren.settings.reader.order, ren.settings.reader.fName, ren.settings.reader.pos)--reader
		
		for type, path in pairs(ren.settings.track) do
			if path then
				soundPlay(path, type ~= "sound", SOUND_CHANNEL[type])
			end
		end
	end
end