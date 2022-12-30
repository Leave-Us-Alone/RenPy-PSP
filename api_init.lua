API = {}
API.mp3 = {}
API.mp3.looper_global = false
API.wav = {}
API.gfx = {}
API.image = {}
API.font = {}
API.timer = {}

function API.gfx.start()
end
function API.gfx.clear(color)
	if not color then color = API.gfx.color(0,0,0) end
	screen:clear()
end
function API.gfx.color(r, g, b, a)
	if a == nil then a = 255 end
	return color.new(r, g, b)
end
function API.gfx.color2(r, g, b, a)
	if a == nil then a = 255 end
	return color.new(r, g, b, a)
end
function API.gfx.stop()
end
function API.gfx.swap()
	screen.flip()
end
function API.image.load(path)
	return image.load(path)
end
function API.image.activate(i)
end
function API.image.width(i)
	return image.getw(i)
end
function API.image.height(i)
	return image.geth(i)
end
function API.image.draw(i, x,y, w,h, sx,sy, sw,sh, r,a)
	
	if w == nil then
		w = API.image.width(i)
		h = API.image.height(i)
	end
	
	if sx == nil then
		sx = 0
		sy = 0
		sw = API.image.width(i)
		sh = API.image.height(i)
	end
	
	if r == nil then r = 0 end
	if a == nil then a = 255 end

	i:blit(x, y, sx, sy, sw, sh, a)
end
function API.image.draweasy(i,x,y,r,a)
	API.image.draw(i, x,y, API.image.width(i),API.image.height(i), 0,0, API.image.width(i),API.image.height(i), r,a)
end
function API.image.drawTint(i,x,y,c)
	i:blittint(x,y,c)
end
function API.image.free(i)
end

function API.font.load(path, size)
	return font.load(path)
end
function API.font.activate(font)
end
function API.font.print(font, x, y, color, text, text_size)
	if text_size == nil then text_size = 0.7 end
	screen.print(font, x, y+text_size, text, text_size, color)
end
function API.font.measure(font,text)
	return screen.textwidth(font, text)
end
function API.font.free(font)
end
function API.mp3.play(path)
	mp3_track = sound.load(path)
	sound.play(mp3_track)
end
function API.mp3.loop(looper)
	if API.mp3.looper_global == looper then
		--nothing
	else
		sound.loop(mp3_track)
		API.mp3.looper_global = looper
	end
end
function API.mp3.volume(vol)
	sound.vol(mp3_track, vol)
end
function API.mp3.stop()
	sound.stop(mp3_track)
end
function API.wav.load(path)
	return sound.load(path)
end
function API.wav.play(obj)
	sound.play(obj)
end
function API.wav.loop(obj)
	sound.loop(obj)
end	
function API.wav.volume(obj, vol)
	sound.vol(obj, vol)
end
function API.timer.new()
	local timered = timer.new()
	timered:start()
	return timered
end
function API.timer.update(timered)
	timered:reset()
	timered:start()
end
function API.timer.time(timered)
	return timered:time()
end
function API.timer.free(timered)
end

API.color = {
	black = API.gfx.color(0, 0, 0),
	white = API.gfx.color(255, 255, 255),
	red = API.gfx.color(255, 0, 0),
	green = API.gfx.color(0, 255, 0),
	yellow = API.gfx.color(255, 255, 153),
	blue = API.gfx.color(176, 224, 230),
	grey = API.gfx.color(57, 57, 57),
	var = API.gfx.color(176, 224, 230),
	grey = API.gfx.color(57, 57, 57),
	gray = API.gfx.color(128,128,128),
	lightGray = API.gfx.color(191,191,191),
	brown = API.gfx.color(139, 69, 19),
	lightBrown = API.gfx.color(165, 99, 54)
}