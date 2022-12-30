msg_clear = function(num)
	if num == nil then
		msg = timeText("")
	end
	ren.settings.dialog.box.name = ""
	ren.settings.dialog.box.name_clr = {255, 255, 255}
end
msg_new = function(str) msg = timeText(str) end
spritepos = "none"
ren = {
	rpy_files = {},
	history = {
		current = {
			image = "none",
			picture = "none",
			sprite1 = "none",
			sprite2 = "none",
			sprite3 = "none",
			sprite4 = "none",
			sprite5 = "none",
			sprite6 = "none",
			sprite7 = "none",
			sprite8 = "none",
			point1 = "none",
			point2 = "none",
			point3 = "none",
			point4 = "none",
			point5 = "none",
			point6 = "none",
			point7 = "none",
			point8 = "none",
			music = "none",
			sound = "none",
			sound_loop = "none",
			ambience = "none",
			text = "none",
			pos = "none"
			
		},
		previous = {},
		rollback = true,
		active = false
	},
	gate = {},
	gate_c = {},
	ground = nil,
	ground_new = nil,
	hover = nil,
	block_show = false, -- block show animations, if scene animates with it
	block_hide = false, -- block hide animations, if show animates with it
	
	block_show_final = false, -- block _next_ show animations when several show animating
	block_hide_final = false, -- block _next_ hide animations when several hide animating
	
	path = {}, --ren.path[path] == file resource (music/wav/image/...)
	gui = { -- gui images
		menu = {},
		dialog = {},
		dialogue_box = "resources/images/gui/dialogue_box/",
		char_box = "resources/images/gui/dialogue_box/",
		ingame_menu_idle = "resources/images/gui/ingame_menu/",
		ingame_menu_hover = "resources/images/gui/ingame_menu/",
		cursorpath = "resources/images/gui/cursor/"
	},

	next = true, --do first command
	pause = false,
	exit = false,
	clearText = false,
	
	keyword = {
		label = {},
		switch = {},
		key_if = {}
	},
	
	settings = {
		msg = {},
		reader = {},
		
		chapter = "~chapter~",
		
		map = {
			active = false,
			x = 480/2,
			y = 272/2,
			ground = 255,
			ground_new = 0,
			hotspot = {}
		},
		current_menu = {},
    
    level = {{keyword="label"}}, -- {start = 0, end = 00}
    
    character = {}, --define
  	image = {}, --image
		
		track = {false, false, false, false},

		var = {
			persistent = {
				rollforward = false,
				text_size = 1,
				intertype = 1,
				blackfilter = "disabled",
				coloredfilter = "disabled",
				nostalgicfilter = "disabled",
				hentaifilter = "disabled",
				mods = "disabled",
				sprite_time = "night",
				lang = "none"
			}, -- Persistent load when game opened.
			gui = {
				dialogue_box = "resources/images/gui/dialogue_box/",
				char_box = "resources/images/gui/dialogue_box/",
				ingame_menu_idle = "resources/images/gui/ingame_menu/",
				ingame_menu_hover = "resources/images/gui/ingame_menu/",
				cursorpath = "resources/images/gui/cursor/"
				
			},
			config = {}
		},

		scene = {
			images = {},
			images_new = {}
		},

		show = {
			images = {},
			images_new = {}
		},
		
		dialog = {
			visible = {
				text = false,
				box = false
			},
			box = {
				limit = 70,
				mode = "dialogue",
				time = "prologue",
				pos = {0, 203},
				
				name = "",
				name_clr = {255, 255, 255},
				namepos = {3, 204},
				
				textpos = {3, 221},
				alpha = 0
			}
		}
  },
	
	get = {}, --for func
	
	effect = {}, --fade/with/...
	func = {}, --func
	py = {
		renpy = {},
		im = {},
		gui = {}
	} --$func()
}




--Check and Parse Strings
dofile("renpy/renpy/strings.lua")
--Keyword System
dofile("renpy/renpy/keywords.lua")
--Dump Function
dofile("renpy/renpy/dump.lua")
--Accelerator System
dofile("renpy/renpy/accelerator.lua")
--Simple Eval Py and Lua System
dofile("renpy/renpy/eval.lua")
--Get Functions
dofile("renpy/renpy/get.lua")
--Characters and Speech System
dofile("renpy/renpy/charspeech.lua")
--Image Functions
dofile("renpy/renpy/image.lua")
--Simple Functions (NONE)
dofile("renpy/renpy/none.lua")
--Basic RenPy Jump (Label, Screen) Function
dofile("renpy/renpy/jump.lua")
--Basic RenPy Menu Function
dofile("renpy/renpy/menu.lua")
--Adds Support for Python (If, Elif, Else)
dofile("renpy/renpy/pyif.lua")
--RenPy Window (GUI) Function
dofile("renpy/renpy/window.lua")
--RenPy Imagemap Function
dofile("renpy/images/imagemap.lua")
--Basic IMAGE Functions
dofile("renpy/images/image.lua")
--"With" Function
dofile("renpy/images/with.lua")
--RenPy Show Function
dofile("renpy/images/show.lua")
--RenPy Hide Function
dofile("renpy/images/hide.lua")
--RenPy Scene Function
dofile("renpy/images/scene.lua")
--Linear Functions
dofile("renpy/images/linear.lua")
--RenPy Image's Transitions
dofile("renpy/images/effects.lua")
--RenPy Pause Function
dofile("renpy/renpy/pause.lua")
--RenPy Movie Library
dofile("renpy/movie/movie.lua")
--RenPy Sound Library
dofile("renpy/sound/snds.lua")

function ren.py.renpy.quit()
	ren.next = false
	ren.exit = true
end




function ren.get.pos(str)
	if str:sub(str:len()) == ":" then
		reader.pos = reader.pos + 1
		return reader.file[reader.fName].line[reader.pos]:denote():trim():expr_exec():eval()
	else
		return nil
	end
end
function ren.py.transform(str)
	return ('{'..str..'}'):eval()
end
function ren.py.GetLine()
	return reader.pos()
end
function ren.py.ConvertToData(data)
	return tostring(data)
end
function ren.py.renpy.deleteFile(path)
	files.delete(path)
end
function ren.py.Character(str)
	local obj = ('{'..str..'}')
	:gsub('[%[%(]','{')
	:gsub('[%)%]]','}')
	:eval()
	
	obj.name = table.splice(obj,1,1)[1]
	return obj
end
--OS Functions
function ren.py.OS_TIME(type)
	if type == "Hour" then 
		return getHour()
	elseif type == "Minute" then
		return getMinute()
	elseif type == "Second" then
		return getSecond()
	else
		return getHour()
	end
end
function ren.py.OS_NICKNAME()
	return tostring(os.nick())
end
function ren.py.im.Composite(str)
	local obj = ('{'..str..'}')
	:gsub('[%[%(]','{')
	:gsub('[%)%]]','}')
	:eval()
	local result = {}
	
	if type(obj[1]) == "number" then -- func(w, h, path)
		result = {{
			obj[3],
			{0, 0},
			{obj[1], obj[2]},
			255
		}}
	else -- func((w, h), (x, y), path, (x2, y2), path2, ...)
		local size = obj[1]
		for i = 2, #obj, 2 do
			table.insert(result, {
				obj[i+1],
				obj[i],
				size,
				255
			})
		end
	end
	
	return result
end
function ren.py.im.Anim(str)
	local obj = ('{'..str..'}')
	:gsub('[%[%(]','{')
	:gsub('[%)%]]','}')
	:eval()
	local resultAnim = {}
	
	if type(obj[1]) == "number" then
		resultAnim = {{
			obj[3],
			{0, 0},
			{obj[1], obj[2]},
			255
		}}
	else
		local size = obj[1]
		for i = 2, #obj, 2 do
			table.insert(resultAnim, {
				obj[i+1],
				obj[i],
				size,
				255
			})
		end
	end
	
	return resultAnim
end
function ren.py.ConditionSwitch(str)
	--local condition1 = str:gsub('.-"(.-)",.*', "%1")
 	--...
end

function ren.py.gui.update(str)
	--error2({"it's $ gui.update()"})
end

function ren.py.reload_names(str)
	--do nothing yet
end

function ren.py.set_mode_nvl(str)
	ren.settings.dialog.box.limit = 56
	ren.settings.dialog.box.mode = "choice"
	ren.settings.dialog.box.pos = {0,0}
	ren.settings.dialog.box.namepos = {0,-20}
	ren.settings.dialog.box.textpos = {39,40}
	ren.gui.dialog.image = API.image.load("resources/images/gui/choice_box/prologue/choice_box.png")
	msg = timeText("")
end

function ren.py.set_mode_adv(str)
	ren.settings.dialog.box.limit = 68
	ren.settings.dialog.box.mode = "dialogue"
	ren.settings.dialog.box.pos = {0,203}
	ren.settings.dialog.box.namepos = {3,204}
	ren.settings.dialog.box.textpos = {3,221}
	ren.gui.dialog.image = API.image.load("resources/images/gui/dialogue_box/prologue/dialogue_box.png")
	msg = timeText("")
end

function ren.func.nvl(str)
	local clear = str:match('^.- (.*)$')
	msg = timeText("")
end



function ren.py.prolog_time()
	ren.gui.menu.box = API.image.load("resources/images/gui/choice_box/prologue/choice_box.png")
		ren.settings.dialog.box.time = 'prologue'
		API.color.var = API.gfx.color(176, 224, 230)
		API.color.grey = API.gfx.color(44, 62, 64)
	end
	function ren.py.day_time()
	ren.gui.menu.box = API.image.load("resources/images/gui/choice_box/prologue/choice_box.png")
		ren.settings.dialog.box.time = 'day'
		API.color.var = API.gfx.color(196, 246, 102)
		API.color.grey = API.gfx.color(77, 115, 55)
	end
	function ren.py.sunset_time()
	ren.gui.menu.box = API.image.load("resources/images/gui/choice_box/prologue/choice_box.png")
		ren.settings.dialog.box.time = 'sunset'
		API.color.var = API.gfx.color(230, 215, 80)
		API.color.grey = API.gfx.color(173, 168, 116)
	end
	function ren.py.night_time()
	ren.gui.menu.box = API.image.load("resources/images/gui/choice_box/prologue/choice_box.png")
		ren.settings.dialog.box.time = 'night'
		API.color.var = API.gfx.color(0, 210, 174)
		API.color.grey = API.gfx.color(12, 108, 90)
	end
	function ren.py.gui_update()
		ren.gui.dialogue_box = ren.settings.var.gui.dialogue_box
		ren.gui.char_box = ren.settings.var.gui.char_box
		ren.gui.ingame_menu_idle = ren.settings.var.gui.ingame_menu_idle
		ren.gui.ingame_menu_hover = ren.settings.var.gui.ingame_menu_hover
		ren.gui.cursorpath = ren.settings.var.gui.cursorpath
	end
	function ren.py.new_chapter(str)
	    ren.settings.chapter = ('{'..str..'}'):eval()[2]
	end


	function ren.py.save_load()
		save_load(true)
	end