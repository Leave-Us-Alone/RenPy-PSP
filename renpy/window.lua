function ren.func.window(str)
	if ren.ground then
		ren.ground_new = nil
		ren.ground = nil
		ren.hover = nil
		ren.gui.cursor = nil
	end
	msg_clear()
	
	ren.pause = true
	ren.next = false
	
	local dialog = ren.settings.dialog
	local visible = dialog.visible
	local box = dialog.box
	
	if str:match("[%w_]* ([%w_]*)") == "show" then
		visible.text = true
		visible.box = true
		asyncCycle:new(0, 255, 12, 1,
			function(i)
				box.alpha = i
				if i == 255 then
					ren.pause = false
					ren.next = true
				end
			end
		)
	else
		visible.text = false
		asyncCycle:new(255, 0, -12, 1,
			function(i)
				box.alpha = i
				if i == 0 then
					visible.box = false
					ren.pause = false
					ren.next = true
				end
			end
		)
	end
end