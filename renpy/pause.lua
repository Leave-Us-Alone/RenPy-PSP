function ren.py.renpy.pause(str)--here's only time var
	str = tonumber(str:match("^[%d%.]*"))
	ren.next = false
	ren.pause = true
	asyncCycle:new(0,1,1,str*10000*1e3,function(i) if i == 1 then ren.pause = false ren.next = true end end)
end
function ren.py.modsActivate(str)
	visual.choicebox = "mods"
end