function ren.py.renpy.screenshot(str)
	local path = str:match("^[%s%.]*")
	screen.shot(path)
end