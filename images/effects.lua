function ren.effect.none(fname, name, final)
	if fname == "with" then
		IMAGE_ALPHA(ren.settings.scene.images, 255)
		IMAGE_ALPHA(ren.settings.show.images, 255)
	else
		IMAGE_ALPHA(ren.settings.scene.images_new, 255)
		IMAGE_ALPHA(ren.settings.show.images_new, 255)
	end
	final()
end

function fadeTemplate(fname, name, final, step, time)
	if fname == "scene" then
		asyncCycle:new(255, 0, -step, time,
			function(i)
				IMAGE_ALPHA(ren.settings.scene.images, i)
				IMAGE_ALPHA(ren.settings.show.images, i)
				if i == 0 then
					asyncCycle:new(0, 255, step, time, 
						function(i)
							IMAGE_ALPHA(ren.settings.scene.images_new, i)
							IMAGE_ALPHA(ren.settings.show.images_new, i)
							if i == 255 then final() end
						end
					)
				end
			end
		)
	elseif fname == "show" then
		asyncCycle:new(0, 255, step, time, 
			function(i)
				IMAGE_ALPHA(ren.settings.show.images_new, i, function(image) return image.name == name end)
				if i == 255 then final() end
			end
		)
	elseif fname == "hide" then
		local ID = name:match('^[%a_][%w_]*')
		local isName = #name:split(' ') > 1
		asyncCycle:new(255, 0, -step, time,
			function(i)
				IMAGE_ALPHA(ren.settings.show.images, i, HIDE_COND(name,isName))
				if i == 0 then final() end
			end
		)
	elseif fname == "with" then
		asyncCycle:new(255, 0, -step, time,
			function(i)
				IMAGE_ALPHA(ren.settings.scene.images, i)
				IMAGE_ALPHA(ren.settings.show.images, i)
				if i == 0 then
					asyncCycle:new(0, 255, step, time, 
						function(i)
							IMAGE_ALPHA(ren.settings.scene.images, i)
							IMAGE_ALPHA(ren.settings.show.images, i)
							if i == 255 then final() end
						end
					)
				end
			end
		)
	end
end
function ren.effect.fade(fname, name, final)
	fadeTemplate(fname, name, final, 8, 2)
end
function ren.effect.fade2(fname, name, final)
	fadeTemplate(fname, name, final, 6, 3)
end
function ren.effect.fade3(fname, name, final)
	fadeTemplate(fname, name, final, 3, 6)
end
function ren.effect.flash(fname, name, final)
	ren.gui.flash = API.image.load("resources/images/bg/white.png")
	fadeTemplate(fname, name, final, 10, 5)
end
function ren.effect.flash_red(fname, name, final)
	ren.gui.flash = API.image.load("resources/images/bg/red.png")
	fadeTemplate(fname, name, final, 10, 5)
end

function dissolveTemplate(fname, name, final, step, time)
	if fname == "scene" then
		asyncCycle:new(255, 0, -step, time,
			function(i)
				IMAGE_ALPHA(ren.settings.scene.images, i)
				IMAGE_ALPHA(ren.settings.show.images, i)
				IMAGE_ALPHA(ren.settings.scene.images_new, 255-i)
				IMAGE_ALPHA(ren.settings.show.images_new, 255-i)
				if i == 0 then final() end
			end
		)
	elseif fname == "show" then
		asyncCycle:new(0, 255, step, time,
			function(i)
				IMAGE_ALPHA(ren.settings.show.images_new, i, function(image) return image.name == name end)
				if i == 255 then final() end
			end
		)
	elseif fname == "hide" then
		asyncCycle:new(255, 0, -step, time,
			function(i)
				IMAGE_ALPHA(ren.settings.show.images, i, HIDE_COND(name,isName))
				if i == 0 then final() end
			end
		)
	elseif fname == "with" then
		asyncCycle:new(0, 255, step, time,
			function(i)
				IMAGE_ALPHA(ren.settings.scene.images, i)
				IMAGE_ALPHA(ren.settings.show.images, i)
				if i == 255 then final() end
			end
		)
	end
end
function ren.effect.dissolve(fname, name, final)
	dissolveTemplate(fname, name, final, 13, 2)
end
function ren.effect.dissolve2(fname, name, final)
	dissolveTemplate(fname, name, final, 2, 8)
end
function ren.effect.dissolve3(fname, name, final)
	dissolveTemplate(fname, name, final, 3, 1)
end
function ren.effect.dspr(fname, name, final)
	dissolveTemplate(fname, name, final, 25, 1)
end
function ren.effect.none(fname, name, final)
	dissolveTemplate(fname, name, final, 255, 1)
end
function ren.effect.vpunch(fname, name, final)
	
end
function ren.effect.hpunch(fname, name, final)
	
end