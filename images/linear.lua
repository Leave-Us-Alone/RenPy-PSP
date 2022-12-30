function ren.func.linear_show(str)
	secs_show = tonumber(str:match("[%w_]* ([%S_]*)"))
	keyword_posword = str:match("[%w_]* [%S_]* ([%w_]*)")
	keyword_pos = str:match("[%w_]* [%S_]* [%w_]* ([%A_]*)")
	posit_x = tonumber(keyword_pos:match("([%S_]*)"):sub(2):reverse():sub(2):reverse())
	posit_y = tonumber(keyword_pos:match("[%w_]* ([%S_]*)"):reverse():sub(2):reverse())
	positions = {posit_x,posit_y}
	for_who = tostring(str:match("[%w_]* [%S_]* [%w_]* [%A_]* [%w_]* ([%w_]*)"))

	linear_show = {}
	linear_show.time = secs_show
	linear_show.pos = {positions[1],positions[2]}
	for _, image in ipairs(ren.settings.show.images) do
		if image.name:match("([%w_]*)") == for_who then
			linear_show.startpos = {image.pos[1],image.pos[2]}
		end
	end
	linear_show.sx = linear_show.pos[1] - linear_show.startpos[1]
	linear_show.sy = linear_show.pos[2] - linear_show.startpos[2]
	linear_show.ticks = linear_show.time*60
	linear_show.stepx = linear_show.sx/linear_show.ticks
	linear_show.stepy = linear_show.sy/linear_show.ticks

	ren.pause = true
	ren.next = false
		
	asyncCycle:new(0, linear_show.ticks, 1, 1, function(i)
		for _, image in ipairs(ren.settings.show.images) do
			if image.name:match("([%w_]*)") == for_who then
				image.pos[1] = image.pos[1] + linear_show.stepx
				image.pos[2] = image.pos[2] + linear_show.stepy
			end
		end
		if i == linear_show.ticks then
			ren.pause = false
			ren.next = true
		end 
	end)
end
function ren.func.linear(str)
    secs = tonumber(str:match("[%w_]* ([%S_]*)"))
	if str:match("[%w_]* [%S_]* ([%w_]*)") == "pos" then
	    keyword_posword = str:match("[%w_]* [%S_]* ([%w_]*)")
		keyword_pos = str:match("[%w_]* [%S_]* [%w_]* ([%A_]*)")
		posit_x = tonumber(keyword_pos:match("([%S_]*)"):sub(2):reverse():sub(2):reverse())
		posit_y = tonumber(keyword_pos:match("[%w_]* ([%S_]*)"):reverse():sub(2):reverse())
		positions = {posit_x,posit_y}
		
		linear = {}
		linear.time = secs
		linear.pos = {positions[1],positions[2]}
		for _, image in ipairs(ren.settings.scene.images) do
			linear.startpos = {image.pos[1],image.pos[2]}
		end
		linear.sx = linear.pos[1] - linear.startpos[1]
		linear.sy = linear.pos[2] - linear.startpos[2]
		linear.ticks = linear.time*60
		linear.stepx = linear.sx/linear.ticks
		linear.stepy = linear.sy/linear.ticks
	
		ren.pause = true
		ren.next = false
		
		asyncCycle:new(0, linear.ticks, 1, 1, function(i)
			IMAGE_MOVE(ren.settings.scene.images, linear.stepx, linear.stepy)
			if i == linear.ticks then
				ren.pause = false
				ren.next = true
			end 
		end)
	elseif str:match("[%w_]* [%S_]* ([%w_]*)") == "xalign" then
		posto = tonumber(str:match("[%w_]* [%S_]* [%w_]* ([%S_]*)"))*480
		
		linear = {}
		linear.time = secs
		linear.pos = {posto,0}
		for _, image in ipairs(ren.settings.scene.images) do
			linear.startpos = {image.pos[1],image.pos[2]}
		end
		linear.sx = linear.pos[1] - linear.startpos[1]
		linear.ticks = linear.time*60
		linear.stepx = linear.sx/linear.ticks
	
		ren.pause = true
		ren.next = false
		
		asyncCycle:new(0, linear.ticks, 1, 1, function(i)
			IMAGE_MOVE(ren.settings.scene.images, linear.stepx, 0)
			if i == linear.ticks then
				ren.pause = false
				ren.next = true
			end 
		end)
	elseif str:match("[%w_]* [%S_]* ([%w_]*)") == "yalign" then
		posto = tonumber(str:match("[%w_]* [%S_]* [%w_]* ([%S_]*)"))*272
		
		linear = {}
		linear.time = secs
		linear.pos = {0,posto}
		for _, image in ipairs(ren.settings.scene.images) do
			linear.startpos = {image.pos[1],image.pos[2]}
		end
		linear.sy = linear.pos[2] - linear.startpos[2]
		linear.ticks = linear.time*60
		linear.stepy = linear.sy/linear.ticks
	
		ren.pause = true
		ren.next = false
		
		asyncCycle:new(0, linear.ticks, 1, 1, function(i)
			IMAGE_MOVE(ren.settings.scene.images, 0, linear.stepy)
			if i == linear.ticks then
				ren.pause = false
				ren.next = true
			end 
		end)
	end
end