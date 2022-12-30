function ren.func.init(str)
	--do nothing
end
function ren.func.check_mod_state(str)
	visual.choicebox = 3
end
ren.func["return"] = function(str)
	ren.func.jump("jump mus_start")
	ren.eval(reader:next())
	API.color.grey = API.gfx.color(57, 57, 57)
	API.color.var = API.gfx.color(176, 224, 230)
end
function ren.func.check_set_state(str)
	visual.choicebox = 2
end
function ren.func.close_mod_state(str)
	visual.choicebox = 1
end
function ren.func.next(str)
	reader:next()
end
function ren.func.label(str)
	--do nothing
end