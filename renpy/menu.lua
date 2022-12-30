function ren.func.menu(str, level)
	ren.settings.level[level+1] = {keyword="case"}
	ren.settings.level[level+2] = ren.keyword.switch[reader.fName][tostring(reader.pos)]
	ren.settings.level[level+2].keyword = "menu"
	ren.settings.current_menu = ren.settings.level[level+2]
	ren.settings.current_menu.sel = 1
	ren.next = false
	ren.pause = true
end
function ren.func.pass(str, level) -- menu only
	--level == "scenario", level-1 == "case", level-2 == switch{}
	reader:toLine(ren.settings.level[level].pass)
	ren.settings.level[level-1] = nil
	ren.settings.level[level] = nil
end