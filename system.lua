--New Functions For Lua
dofile("renpy/betterlua.lua")
--New Functions For PGE
dofile("renpy/betterpge.lua")
--New String Functions
dofile("renpy/text/string.lua")
--New Print Function
dofile("renpy/text/print.lua")
--Animated Text Library
dofile("renpy/text/anim.lua")
--Basic Reader For RPY Files
dofile("renpy/reader/reader.lua")

rpy_res = {"resources.rpy", "sprites.rpy"}
rpy_sce = {}
rpy_files = {}
mods = {}
--GoToTypes(".rpy", rpy_files)

readMods("mods", mods)
for i, mod in pairs(mods) do
	local files = mods[i].rpy_resources
	local files2 = mods[i].rpy_scenario
	local folder = mods[i].folder

	for file, name in pairs(files) do
		table.insert(rpy_res, folder.."/"..files[file])
	end
	for file, name in pairs(files2) do
		table.insert(rpy_sce, folder.."/"..files2[file])
	end
end
for i, res in pairs(rpy_res) do
	table.insert(rpy_files, rpy_res[i])
end
table.insert(rpy_files, "options.rpy")
table.insert(rpy_files, "scenario.rpy")
for i, res in pairs(rpy_sce) do
	table.insert(rpy_files, rpy_sce[i])
end
readFiles(rpy_files)

--PyExec Library (By Exnonull)
dofile("renpy/pyexec.lua")
--RenPy Functions
dofile("renpy/renpy.lua")
			
			buttons.interval()
			timer_gone = 1
			msg = timeText("") --uses ren.settings.dialog.box.limit
			ren.py.loadDefault()
			ren.eval(reader:next())

			Iterator = 1
			local DEBUG = true
			local ALLOW_START_LINE = 65
			local ALLOW_SAVE_LINE = 65
			local CURSOR_SPEED = 4
			visual = {
				choicebox = 1
			}
			
			function check(fName)
				local file = io.open(fName, "r")
				if file then
					file:close()
					return true
				end
				return false
			end
			--Persistent SaveFILE Check
			if check("saves/persistent") then 
				dofile("saves/persistent")
			else
				ren.file = io.open("saves/persistent", "a")
				ren.file:write("ren.settings.var.persistent.firstrun=false\nren.settings.var.persistent.endings = {}\nren.settings.var.persistent.endings[\"main_good\"] = false\nren.settings.var.persistent.endings[\"main_bad\"] = false\nren.settings.var.persistent.endings[\"dv_good\"] = false\nren.settings.var.persistent.endings[\"dv_bad\"] = false\nren.settings.var.persistent.endings[\"sl_good\"] = false\nren.settings.var.persistent.endings[\"sl_bad\"] = false\nren.settings.var.persistent.endings[\"un_good\"] = false\nren.settings.var.persistent.endings[\"un_bad\"] = false\nren.settings.var.persistent.endings[\"us_good\"] = false\nren.settings.var.persistent.endings[\"us_bad\"] = false\nren.settings.var.persistent.endings[\"mi\"] = false\nren.settings.var.persistent.endings[\"uv_city\"] = false\nren.settings.var.persistent.endings[\"uv_unknown_fucken_shit\"] = false\n")
				ren.file:close()
				ren.settings.var.persistent.firstrun = true 
			end
			function metasave(id)
				if id < 1 then return "Пусто" end
				if not check("saves/metasave_"..id..".lua") then return "Пусто" end
				dofile("saves/metasave_"..id..".lua")
				return meta_chapter
			end
			
			function delete_cell(id)
				if id < 1 or not check("saves/save_"..id..".lua") then return nil end
				files.delete("saves/save_"..id..".lua")
				files.delete("saves/metasave_"..id..".lua")
				return true
			end
			
			function save_cell(id)
				if id < 1 then return nil end
				ren.file = io.open("saves/save_"..id..".lua", "w")
				ren.file:write("ren.settings.scene=")
				dumpfile(ren.file, ren.settings.scene)
				ren.file:write("\nren.settings.show=")
				dumpfile(ren.file, ren.settings.show)
				ren.file:write("\nren.settings.reader=")
				dumpfile(ren.file, ren.settings.reader)
				ren.file:write("\nren.settings.var=")
				dumpfile(ren.file, ren.settings.var)
				ren.file:write("\nren.settings.msg=")
				dumpfile(ren.file, ren.settings.msg)
				ren.file:write("\nren.settings.dialog=")
				dumpfile(ren.file, ren.settings.dialog)
				ren.file:write("\nren.history=")
				dumpfile(ren.file, ren.history)
				ren.file:close()
				
			
				ren.file = io.open("saves/metasave_"..id..".lua", "w")
				ren.file:write('meta_chapter="'..ren.settings.chapter..'"')
				ren.file:close()
				
				return true
			end
			
			function load_cell(id)
				if id < 1 or not check("saves/save_"..id..".lua") then return nil end
				
				if music_track then
					soundStop("music")
				end
				if sound_loop_track then
					soundStop("sound_loop")
				end
				if ambience_track then
					soundStop("ambience")
				end
				ren.gui = {menu = {}, dialog = {}}
				ren.settings.show = {images = {}, images_new = {}}
				ren.settings.scene = {images = {}, images_new = {}}
				
				dofile("saves/save_"..id..".lua")
				
				msg:load(ren.settings.msg)--text
				reader.pos = ren.settings.reader.pos--reader
				
				--[[for type, path in pairs(ren.settings.music_play) do
					if type == "music" then
						if path then
							ren.path[path] = true
							pge.mp3.loop(true)
							pge.mp3.play(path)
						end
					elseif type == "sound_loop" or type == "ambience" then
						if path then
							ren.path[path] = pge.wav.load(path)
							pge.wav.loop(ren.path[path])
							pge.wav.play(ren.path[path])
						end
					end
				end]]--
				ren.next = false
				ren.pause = false
				visible.text = true
				visible.box = true
				return true
			end
			
			function save_load(load)
				if reader.pos < ALLOW_SAVE_LINE then
					load = true
				end
				local x = ren.settings.map.x
				local y = ren.settings.map.y
				local chapters = {}
				for i2 = 1,3 do
					for i = 1,4 do
						chapters[i+(i2-1)*4] = metasave(i+(i2-1)*4)
					end
				end
				local spots = {
					{12,23,93,14,"settings"},
					{380,25,88,12,"switch"},
					{9,237,68,12,"back"},
					{179,236,122,15,"activator"},
					{391,236,76,14,"delete"}
				}
				
				local cursor = API.image.load("resources/images/gui/cursor/cursor.png")
				local cell = API.image.load("resources/images/gui/save_load/thumbnail_idle.png")
				local cell_on = API.image.load("resources/images/gui/save_load/thumbnail_hover.png")
				local cell_sel = API.image.load("resources/images/gui/save_load/thumbnail_selected.png")
				
				local screen = "save"
				local bg = API.image.load("resources/images/gui/save_load/save_bg.png")
				local hg = API.image.load("resources/images/gui/save_load/save_"..tostring(ren.settings.var.persistent.lang).."_idle.png")
				local hg_on = API.image.load("resources/images/gui/save_load/save_"..tostring(ren.settings.var.persistent.lang).."_hover.png")
				
				local activated = {0,0}
				local activatedId = activated[1]+(activated[2]-1)*4
				if load then
					screen = "load"
					local hg = API.image.load("resources/images/gui/save_load/load_"..tostring(ren.settings.var.persistent.lang).."_idle.png")
					local hg_on = API.image.load("resources/images/gui/save_load/load_"..tostring(ren.settings.var.persistent.lang).."_hover.png")
					bg = API.image.load("resources/images/gui/save_load/load_bg.png")
				end
				
				while not ren.exit do
					ren.settings.map.x = x
					ren.settings.map.y = y
					
					buttons.read()
					
					API.image.activate(bg)
					API.image.draweasy(bg,0,0,0,255)
					
					API.image.activate(hg)
					API.image.draweasy(hg,0,0,0,255)
					
					if math.abs(buttons.analogx) > 60 or math.abs(buttons.analogy) > 60 then
						x = x + CURSOR_SPEED*buttons.analogx/100
						y = y + CURSOR_SPEED*buttons.analogy/100
					end
					if buttons.held.left then x = x - CURSOR_SPEED end
					if buttons.held.up then y = y - CURSOR_SPEED end
					if buttons.held.right then x = x + CURSOR_SPEED end
					if buttons.held.down then y = y + CURSOR_SPEED end
					if x < 0 then x = 0 end
					if y < 0 then y = 0 end
					if x > 480 then x = 480 end
					if y > 272 then y = 272 end
					
					API.image.activate(hg_on)
					for _, spot in ipairs(spots) do
						if not (x < spot[1] or y < spot[2] or x > spot[1] + spot[3] or y > spot[2] + spot[4]) then
							API.image.draw(hg_on, spot[1],spot[2],spot[3],spot[4], spot[1],spot[2],spot[3],spot[4])
							if buttons.cross then
								if spot[5] == "settings" then
									return nil
								elseif spot[5] == "switch" and reader.pos >= ALLOW_SAVE_LINE then
									if screen == "save" then
										screen = "load"
										local hg = API.image.load("resources/images/gui/save_load/load_"..tostring(ren.settings.var.persistent.lang).."_idle.png")
										local hg_on = API.image.load("resources/images/gui/save_load/load_"..tostring(ren.settings.var.persistent.lang).."_hover.png")
										bg = API.image.load("resources/images/gui/save_load/load_bg.png")
									else
										screen = "save"
										local hg = API.image.load("resources/images/gui/save_load/save_"..tostring(ren.settings.var.persistent.lang).."_idle.png")
										local hg_on = API.image.load("resources/images/gui/save_load/save_"..tostring(ren.settings.var.persistent.lang).."_hover.png")
										bg = API.image.load("resources/images/gui/save_load/save_bg.png")
									end
								elseif spot[5] == "back" then
									visible.text = true
									visible.box = true
									return nil
								elseif spot[5] == "activator" and activatedId > 0 then
									if screen == "save" then
										save_cell(activatedId)
										chapters[activatedId] = ren.settings.chapter
									else
										if load_cell(activatedId) then
											cursor = nil
											bg = nil
											hg = nil
											hg_on = nil
											cell_sel = nil
											cell_on = nil
											cell = nil
											spots = nil
											chapters = nil
											activated = nil
											ren.settings.dialog.visible.text = true
											ren.settings.dialog.visible.box = true
											visible = ren.settings.dialog.visible
											return nil
										end
									end
								elseif spot[5] == "delete" and activatedId > 0 then
									delete_cell(activatedId)
									chapters[activatedId] = "Пусто"
								end
							end
						end
					end
					
					for i2 = 1,3 do
						for i = 1,4 do
							local cx = 65+(i-1)*(API.image.width(cell)+15)
							local cy = 56+(i2-1)*(API.image.height(cell)+12)
							
							local sel = not (x < cx or y < cy or x > cx + API.image.width(cell) or y > cy + API.image.height(cell))
							local act = i == activated[1] and i2 == activated[2]
							
							if act then
								if sel and buttons.cross then
									activated = {0, 0}
									activatedId = activated[1]+(activated[2]-1)*4
								end
								API.image.activate(cell_sel)
								API.image.draweasy(cell_sel, cx, cy)
								print(cx+2, cy+2, API.color.white, tostring(i+(i2-1)*4)..'. '..chapters[i+(i2-1)*4], 0.6)
							elseif sel then
								if buttons.cross then
									activated = {i, i2}
									activatedId = activated[1]+(activated[2]-1)*4
								end
								API.image.activate(cell_on)
								API.image.draweasy(cell_on, cx, cy)
								print(cx+2, cy+2, API.color.white, tostring(i+(i2-1)*4)..'. '..chapters[i+(i2-1)*4], 0.6)
							else
								API.image.activate(cell)
								API.image.draweasy(cell, cx, cy)
								print(cx+2, cy+2, API.color.lightGray, tostring(i+(i2-1)*4)..'. '..chapters[i+(i2-1)*4], 0.6)
							end
						end
					end

					API.image.activate(cursor)
					API.image.draweasy(cursor, x, y)
					API.gfx.swap()
				end
			end
function pressed(name)
	return buttons[name]
end
while not ren.exit do
	asyncCycle:update()
	buttons.read()
	if ren.next then ren.eval(reader:next()) end
	
	if not (ren.pause or ren.next) and not ren.gate.active and not ren.gate_c.active and not ren.history.active then
		if buttons.cross then
			if msg:next() then 
				ren.history.previous[#ren.history.previous+1] = {
					image = ren.history.current.image,
					music = ren.history.current.music,
					sound = ren.history.current.sound,
					sound_loop = ren.history.current.sound_loop,
					ambience = ren.history.current.ambience,
					text = ren.history.current.text,
					pos = ren.history.current.pos,
					sprites = ren.history.current.sprites
				}
				ren.eval(reader:next()) 
			end
		elseif buttons.held.r then
			if msg:next() then 
				ren.history.previous[#ren.history.previous+1] = {
					image = ren.history.current.image,
					music = ren.history.current.music,
					sound = ren.history.current.sound,
					sound_loop = ren.history.current.sound_loop,
					ambience = ren.history.current.ambience,
					text = ren.history.current.text,
					pos = ren.history.current.pos
				}
				ren.eval(reader:next())
			end
		elseif buttons.l then
			ren.eval(reader:previous())
		elseif buttons.select then
			ren.history.active = true
			ren.history.bg = API.image.load("resources/images/gui/o_rly/history.png")
			ren.history.cur = 2
			ren.history.count = 8
			ren.history.allprev = tonumber(#ren.history.previous)
			visible.box = false
			visible.text = false
		end
	end
	
	if ren.gui.flash then
		API.image.activate(ren.gui.flash)
		API.image.draweasy(ren.gui.flash, 0, 0)
	end
	
	--scene
	for _, image in ipairs(ren.settings.scene.images) do
		local img = ren.path[image.path]
		if img ~= nil then
			API.image.activate(img)
			API.image.draweasy(img, image.pos[1], image.pos[2], 0, image.alpha)
		end
	end
	
	--show
	for __, image in ipairs(ren.settings.show.images) do --array, order important => ipairs, but not pairs
		local img = ren.path[image.path]
		if ren.settings.var.persistent.sprite_time == "day" then
			--do nothing :)
		elseif ren.settings.var.persistent.sprite_time == "sunset" then
			API.color.sunset_sprite = API.gfx.color2(240, 209, 255, image.alpha)
		elseif ren.settings.var.persistent.sprite_time == "night" then
			API.color.night_sprite = API.gfx.color2(161, 199, 209, image.alpha)
		elseif ren.settings.var.persistent.sprite_time == "red" then
			API.color.red_sprite = API.gfx.color2(255, 0, 0, image.alpha)
		end
		if img ~= nil then
			if ren.settings.var.persistent.sprite_time == "day" then
				API.image.activate(img)
				API.image.draweasy(img, image.pos[1]-API.image.width(img)/2, image.pos[2], 0, image.alpha)
			elseif ren.settings.var.persistent.sprite_time == "sunset" then
				API.image.activate(img)
				API.image.drawTint(img, image.pos[1]-API.image.width(img)/2, image.pos[2], API.color.sunset_sprite)
			elseif ren.settings.var.persistent.sprite_time == "night" then
				API.image.activate(img)
				API.image.drawTint(img, image.pos[1]-API.image.width(img)/2, image.pos[2], API.color.night_sprite)
			elseif ren.settings.var.persistent.sprite_time == "red" then
				API.image.activate(img)
				API.image.drawTint(img, image.pos[1]-API.image.width(img)/2, image.pos[2], API.color.red_sprite)
			end
		end
	end
	
	--scene 2
	for _, image in ipairs(ren.settings.scene.images_new) do
		local img = ren.path[image.path]
		if img ~= nil then
			API.image.activate(img)
			API.image.draweasy(img, image.pos[1], image.pos[2], 0, image.alpha)
		end
	end
	
	--show 2
	for __, image in ipairs(ren.settings.show.images_new) do
		local img = ren.path[image.path]
		if ren.settings.var.persistent.sprite_time == "day" then
			--do nothing :)
		elseif ren.settings.var.persistent.sprite_time == "sunset" then
			API.color.sunset_sprite = API.gfx.color2(240, 209, 255, image.alpha)
		elseif ren.settings.var.persistent.sprite_time == "night" then
			API.color.night_sprite = API.gfx.color2(161, 199, 209, image.alpha)
		elseif ren.settings.var.persistent.sprite_time == "red" then
			API.color.red_sprite = API.gfx.color2(255, 0, 0, image.alpha)
		end
		if img ~= nil then
			if ren.settings.var.persistent.sprite_time == "day" then
				API.image.activate(img)
				API.image.draweasy(img, image.pos[1]-API.image.width(img)/2, image.pos[2], 0, image.alpha)
			elseif ren.settings.var.persistent.sprite_time == "sunset" then
				API.image.activate(img)
				API.image.drawTint(img, image.pos[1]-API.image.width(img)/2, image.pos[2], API.color.sunset_sprite)
			elseif ren.settings.var.persistent.sprite_time == "night" then
				API.image.activate(img)
				API.image.drawTint(img, image.pos[1]-API.image.width(img)/2, image.pos[2], API.color.night_sprite)
			elseif ren.settings.var.persistent.sprite_time == "red" then
				API.image.activate(img)
				API.image.drawTint(img, image.pos[1]-API.image.width(img)/2, image.pos[2], API.color.red_sprite)
			end
		end
	end

--menu
	local menu = ren.settings.current_menu
	if menu.case then
		if not ren.gui.menu.box then
			ren.gui.menu.box = API.image.load("resources/images/gui/choice_box/prologue/choice_box.png")
		end
		if visual.choicebox == 1 then
			API.image.activate(ren.gui.menu.box)
			API.image.draw(ren.gui.menu.box, 0, 94, 480, 272, 0, 35, 500, 48 + 15 * (#menu.case - 1))
		end
		if visual.choicebox ~= "mods" then
			for i, case in ipairs(menu.case) do
				if visual.choicebox == 1 then
					local color = (i == menu.sel and API.color.var) or API.color.grey
					printcenter(240, 93 + i*17, color, case.name:sub(2, case.name:len()-1))
				elseif visual.choicebox == 2 then
					local color = (i == menu.sel and API.color.lightBrown) or API.color.grey
					printcenter(135, 53 + i*18, color, case.name:sub(2, case.name:len()-1))
				elseif visual.choicebox == 3 then
					local color = (i == menu.sel and API.color.lightBrown) or API.color.grey
					print(135, 53 + i*14, color, case.name:sub(2, case.name:len()-1))
				end
			end
			if not ren.gate.active and not ren.history.active and not ren.gate_c.active then
				if pressed('down') then
					menu.sel = menu.sel + 1
					if menu.sel > #menu.case then menu.sel = 1 end
				elseif pressed('up') then
					menu.sel = menu.sel - 1
					if menu.sel < 1 then menu.sel = #menu.case end
				end
			
				if pressed('cross') then
					ren.next = true
					ren.pause = false
					reader:toLine(menu.case[menu.sel].pos)
					ren.settings.current_menu = {}
				end
			end
		else
			for id, mode in pairs(mods) do
				local color = (id == menu.sel and API.color.lightBrown) or API.color.grey
				color2 = (id+1 == menu.sel and API.color.lightBrown) or API.color.grey
				print(135, 53 + id*14, color, mods[id].name)
			end
			if #mods == 0 then
				color2 = (1 == menu.sel and API.color.lightBrown) or API.color.grey
			end
			print(135, 53 + (#mods+1)*14, color2, menu.case[2].name:sub(2, menu.case[2].name:len()-1))
			if not ren.gate.active and not ren.history.active and not ren.gate_c.active then
				if pressed('down') then
					menu.sel = menu.sel + 1
					if menu.sel > #mods+1 then menu.sel = #mods+1 end
				elseif pressed('up') then
					menu.sel = menu.sel - 1
					if menu.sel < 1 then menu.sel = 1 end
				end
			
				if pressed('cross') then
					if menu.sel == #mods+1 then
						ren.func.jump("jump settings_main")
						ren.eval(reader:next())
					else
						ren.next = true
						ren.pause = false
						ren.func.jump("jump "..mods[menu.sel].label)
						ren.eval(reader:next())
						ren.func.close_mod_state("Похуй, не ебёт")
						ren.settings.current_menu = {}
					end
				end
			end
		end

	elseif ren.gui.menu.box ~= nil then
		ren.gui.menu.box = nil
	end
	
	--window
	local dialog = ren.settings.dialog
	visible = dialog.visible
	local box = dialog.box
	local guibox = ren.gui.dialog
	if visible.box then
		if guibox.image == nil then
			if ren.settings.dialog.box.mode == "dialogue" then
				guibox.image = API.image.load("resources/images/gui/dialogue_box/"..ren.settings.dialog.box.time.."/dialogue_box.png")
			else
				guibox.image = API.image.load("resources/images/gui/choice_box/prologue/choice_box.png")
			end
		end
		API.image.activate(guibox.image)
		API.image.draweasy(guibox.image, box.pos[1], box.pos[2], 0, box.alpha)
		
		if box.name ~= "" then
			if guibox.image_char == nil then
				guibox.image_char = API.image.load("resources/images/gui/dialogue_box/"..ren.settings.dialog.box.time.."/chr.png")
			end
			API.image.activate(guibox.image_char)
			API.image.draweasy(guibox.image_char, box.pos[1], box.pos[2], 0, box.alpha)
		elseif guibox.image_char ~= nil then
			guibox.image_char = nil
		end
	elseif guibox.image ~= nil then
		guibox.image = nil
		guibox.image_char = nil
	end
	
	local map = ren.settings.map
	if map.active then
		if not ren.gate.active and not ren.gate_c.active and not ren.history.active and (math.abs(buttons.analogx) > 60 or math.abs(buttons.analogy) > 60) then
			map.x = map.x + CURSOR_SPEED*buttons.analogx/100
			map.y = map.y + CURSOR_SPEED*buttons.analogy/100
		end
		if buttons.held.left then map.x = map.x - CURSOR_SPEED end
		if buttons.held.up then map.y = map.y - CURSOR_SPEED end
		if buttons.held.right then map.x = map.x + CURSOR_SPEED end
		if buttons.held.down then map.y = map.y + CURSOR_SPEED end
		if map.x < 0 then map.x = 0 end
		if map.y < 0 then map.y = 0 end
		if map.x > 480 then map.x = 480 end
		if map.y > 272 then map.y = 272 end
		
		if ren.ground_new == nil then
			API.image.activate(ren.ground)
			API.image.draweasy(ren.ground, 0, 0, 0, map.ground)
			API.image.activate(ren.hover)
			for i, spot in ipairs(map.hotspot) do
				if not (map.x < spot.x or map.y < spot.y or map.x > spot.x+spot.w or map.y > spot.y+spot.h) then
					API.image.draw(ren.hover, spot.x,spot.y,spot.w,spot.h, spot.x,spot.y,spot.w,spot.h)
					if not spot.was then
						spot.hovered()
						spot.was = true
					end
					if not ren.gate.active and buttons.cross and map.ground_new == 0 and not ren.gate_c.active and not ren.history.active then
						spot.jump()
					end
				else
					spot.was = false
				end
			end
		else
			if ren.ground ~= nil then
				API.image.activate(ren.ground)
				API.image.draweasy(ren.ground, 0, 0, 0, map.ground)
			end
			API.image.activate(ren.ground_new)
			API.image.draweasy(ren.ground_new, 0, 0, 0, map.ground_new)
		end
		API.image.activate(ren.gui.cursor)
		API.image.draweasy(ren.gui.cursor, map.x, map.y, 0, map.ground)
	end
	
	--text
	if visible.text then
		for i, str in ipairs(msg:get():split("\n")) do
			API.font.print(regulared, box.textpos[1], box.textpos[2]+3+(i-1)*12, API.color.yellow, str, 0.7)
		end
		API.font.print(regulared, box.namepos[1], box.namepos[2]+2, API.gfx.color(box.name_clr[1], box.name_clr[2], box.name_clr[3]), box.name, 0.7)
	end
	
	if ren.gate.active then
		visible.box = false
		visible.text = false
		if buttons.start and not ren.gate_c.active then
            visible.box = true
			visible.text = true
			ren.gate = {}
		else
			if buttons.down and not ren.gate_c.active then
				ren.gate.cur = ren.gate.cur + 1
				if ren.gate.cur > ren.gate.count then ren.gate.cur = 1 end
			elseif buttons.up and not ren.gate_c.active then
				ren.gate.cur = ren.gate.cur - 1
				if ren.gate.cur < 1 then ren.gate.cur = ren.gate.count end
			end
		
			local x = 480/2-API.image.width(ren.gate.menu)/2
			local y = 272/2-API.image.height(ren.gate.menu)/2
			API.image.activate(scr_image)
			API.image.draweasy(scr_image,0,0)
			API.image.activate(ren.gate.menu)
			API.image.draweasy(ren.gate.menu,x,y)
			
			local w = API.image.width(ren.gate.sel)
			local h = (API.image.height(ren.gate.sel)-35)/ren.gate.count --35 - free space on sprite
			API.image.activate(ren.gate.sel)
			API.image.draw(ren.gate.sel,x,y+21+(ren.gate.cur-1)*h,w,h,0,21+(ren.gate.cur-1)*h,w,h)
			
			if buttons.cross then
				local cur = ren.gate.cur
				ren.gate = {}
				({
					function()
						ren.gate_c.active = true
						ren.gate_c.menu = API.image.load("resources/images/gui/o_rly/base.png")
						ren.gate_c.sel_yes = API.image.load("resources/images/gui/o_rly/base_activate_yes.png")
						ren.gate_c.sel_no = API.image.load("resources/images/gui/o_rly/base_activate_no.png")
						ren.gate_c.cur = 1
						ren.gate_c.count = 2 -- main_menu
						--[[ren.func.jump("jump mus_start")
						ren.eval(reader:next())]]--
					end,
					function() -- save_screen
						save_load(false)
					    visible.box = true
						visible.text = true
					end,
					function() -- load_screen
						save_load(true)
					    visible.box = true
						visible.text = true
					end,
					function() -- settings_screen
					    visible.box = true
						visible.text = true
					end,
					function() -- exit
						ren.exit = true
					end
				})[cur]()
			end
		end
	elseif buttons.start and not ren.pause and not ren.next and reader.pos >= ALLOW_START_LINE and not ren.history.active and not ren.gate_c.active then
		ren.gate.active = true
		ren.gate.menu = API.image.load("resources/images/gui/ingame_menu/"..ren.settings.dialog.box.time.."/ingame_menu.png")
		ren.gate.sel = API.image.load("resources/images/gui/ingame_menu/"..ren.settings.dialog.box.time.."/ingame_sel.png")
		ren.gate.cur = 1
		ren.gate.count = 5
	end
	if ren.gate_c.active then
		timer_gone += 1
		API.image.activate(ren.gate_c.menu)
		API.image.draweasy(ren.gate_c.menu, 0,0)
		API.image.activate(ren.gate_c.sel_yes)
		if ren.gate_c.cur == 1 then
			API.image.draweasy(ren.gate_c.sel_yes, 0,0)
			if buttons.cross and timer_gone > 20 then ren.func.jump("jump mus_start") ren.eval(reader:next()) ren.gate_c = {} timer_gone = 1 end
		else
			API.image.activate(ren.gate_c.sel_no)
			API.image.draweasy(ren.gate_c.sel_no, 0,0)
			if buttons.cross and timer_gone > 20 then ren.gate = {} ren.gate_c = {} visible.box = true visible.text = true timer_gone = 1 end
		end
		if buttons.left then
			ren.gate_c.cur = 1
		elseif buttons.right then
			ren.gate_c.cur = 2
		end
	end
	if ren.history.active then
		API.image.activate(ren.history.bg)
		API.image.draweasy(ren.history.bg, 0,0)
		if buttons.circle then
			ren.history.bg = nil
			visible.box = true
			visible.text = true
			ren.history.active = false
		end
		if buttons.down and ren.history.cur < #ren.history.previous then
			ren.history.cur = ren.history.cur + 1
		elseif buttons.up and ren.history.cur > 2 then
			ren.history.cur = ren.history.cur - 1
		elseif buttons.cross then
			ren.eval(reader:history_back(ren.history.cur))
			ren.history.active = false
			ren.history.bg = nil
			visible.box = true
			visible.text = true
		end
		for i in pairs(ren.history.previous) do
			if i ~= 1 then
				if ren.history.cur == i then
					print(40, 7+15*i, API.color.green, tostring("\""..ren.history.previous[i].text.."\""))
				else
					print(40, 7+15*i, API.color.yellow, tostring("\""..ren.history.previous[i].text.."\""))
				end
			end
		end
	end
	--[[print(0,3,API.color.white,"Free RAM: "..tostring(os.ram()))
	print(0,15+3,API.color.white,"Current RenFile: "..tostring(reader.fName))
	print(0,30+3,API.color.white,"Current RenPosition: "..tostring(reader.cur))
	print(0,45+3,API.color.white,"Fuck: "..tostring(2+2))
	print(0,60+3,API.color.white,"Fuck: "..tostring(3+3))
	print(0,75+3,API.color.white,"Fuck: "..tostring(4+4))]]--
	API.gfx.swap()
end
--ren.py.save()