function ren.get.point(str) return str:match("at ([%a_][%w_]*)") end
function ren.func.show(str, level)
	local name = ren.get.name(str)
	local ID = name:match('^[%a_][%w_]*')
	if not (ID == "anim" or ID == "bg" or ID == "cg") then
		ren.func.hide("hide "..ID, true)
		IMAGE_RESET(ren.settings.image[name])
	end
	
	spritepos = ren.get.point(str)
	
	switch = {
		cs = function() -- Viola
		ren.history.current.sprite1 = ren.get.name(str)
		ren.history.current.point1 = ren.get.point(str) end,
		dv = function() -- Alisa
		ren.history.current.sprite2 = ren.get.name(str)
		ren.history.current.point2 = ren.get.point(str) end,
		mi = function() -- Miku
		ren.history.current.sprite3 = ren.get.name(str)
		ren.history.current.point3 = ren.get.point(str) end,
		mt = function() -- Olga
		ren.history.current.sprite4 = ren.get.name(str)
		ren.history.current.point4 = ren.get.point(str) end,
		mz = function() -- )|(enya
		ren.history.current.sprite5 = ren.get.name(str)
		ren.history.current.point5 = ren.get.point(str) end,
		sl = function() -- Slavya
		ren.history.current.sprite6 = ren.get.name(str)
		ren.history.current.point6 = ren.get.point(str) end,
		un = function() -- Lena
		ren.history.current.sprite7 = ren.get.name(str)
		ren.history.current.point7 = ren.get.point(str) end,
		us = function() -- Ulyana
		ren.history.current.sprite8 = ren.get.name(str)
		ren.history.current.point8 = ren.get.point(str) end,
	}
	if switch[ID] then
	switch[ID]()
	end

	if not (ID == "cs" or ID == "dv" or ID == "mi" or ID == "mt" or ID == "mz" or ID == "sl" or ID == "un" or ID == "us") then
	ren.history.current.picture = ren.get.name(str)
	end

	ren.pause = true
	if not ren.settings.image[name] then error2({reader.fName..'->'..reader.pos, 'No variable: '..name}) end
	
	local at = ren.get.at(str) or ren.get.pos(str) or {240, 0}
	
	table.concat(ren.settings.show.images_new, ren.settings.image[name])
	IMAGE_LOAD(ren.settings.image[name])
	IMAGE_ALPHA(ren.settings.image[name], 0)
	IMAGE_MOVE(ren.settings.image[name], at[1], at[2])
	
	current_block_show_final = ren.block_show
	local final = function()
		if not current_block_show_final then
			current_block_show_final = true
			table.concat(ren.settings.show.images, ren.settings.show.images_new)
			ren.settings.show.images_new = {}
			ren.pause = false
			ren.next = true
			ren.gui.flash = nil
			ren.block_show_final = false
			ren.block_hide_final = false
			ren.block_hide = false
		end
	end
	
	local with = ren.get.with(str) or getNextWith() or "none"
	if with and with[1] then
		with = with[1]
		ren.block_show_final = true
		ren.block_hide = true
	else
		ren.next = false
	end
	
	if not ren.block_show then
		--фикс на случай если текущие картинки это новые
		IMAGE_ALPHA(ren.settings.show.images, 255)
		if not ren.effect[with] then with = "none" end
		ren.effect[with]('show', name, final)
	end
end