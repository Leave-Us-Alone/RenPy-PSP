function ren.func.hide(str, showOrLevel)
	if ren.ground then
		ren.ground_new = nil
		ren.ground = nil
		ren.hover = nil
		ren.gui.cursor = nil
	end
	msg_clear()
	ren.pause = true
	
	name = ren.get.name(str)
	ID = name:match('^[%a_][%w_]*')
	isName = #name:split(' ') > 1
	
	switch = {
		cs = function() -- Viola
		ren.history.current.sprite1 = "none" end,
		dv = function() -- Alisa
		ren.history.current.sprite2 = "none" end,
		mi = function() -- Miku
		ren.history.current.sprite3 = "none" end,
		mt = function() -- Olga
		ren.history.current.sprite4 = "none" end,
		mz = function() -- )|(enya
		ren.history.current.sprite5 = "none" end,
		sl = function() -- Slavya
		ren.history.current.sprite6 = "none" end,
		un = function() -- Lena
		ren.history.current.sprite7 = "none" end,
		us = function() -- Ulyana
		ren.history.current.sprite8 = "none" end,
		}
	if switch[ID] then
	switch[ID]()
	end
	
	if not (ID == "cs" or ID == "dv" or ID == "mi" or ID == "mt" or ID == "mz" or ID == "sl" or ID == "un" or ID == "us") then
	ren.history.current.picture = "none" 
	end

	current_block_hide_final = ren.block_hide_final
	local final = function()
		IMAGE_KILL(ren.settings.show.images, HIDE_COND(name,isName))
		--if not was then was = true else error2({'h'}) end
			if not ren.block_hide then -- в случае если анимация вместе со show, но он стоит выше
				ren.pause = false
				ren.next = true
				ren.gui.flash = nil
				ren.block_hide_final = false
			end
	end
	
	local with = ren.get.with(str) or getNextWith() or "none"
	if with and with[1] then
		with = with[1]
		ren.block_hide_final = true
	else
		ren.next = false
	end
	
	--фикс на случай если текущие картинки это новые
	IMAGE_ALPHA(ren.settings.show.images, 255)
	
	if not ren.effect[with] then with = "none" end
	if showOrLevel == true then final()
	else ren.effect[with]('hide', name, final) end
end