--SOUND_CHANNEL = {music=1,sound_loop=2,ambience=3,sound=4,sound2=5}
SOUND = {mp3=Mp3,wav=Wav,ogg=Ogg,at3=At3}

function soundPlay(l)
	if l == "music" then
		sound.play(music_track, 1)
		if sound.looping(music_track) == true then
			--nothing, because it's already looped
		elseif sound.looping(music_track) == false then
			sound.loop(music_track)
		end
	elseif l == "sound_loop" then
		sound.play(sound_loop_track, 2)
		if sound.looping(sound_loop_track) == true then
			--nothing, because it's already looped
		elseif sound.looping(sound_loop_track) == false then
			sound.loop(sound_loop_track)
		end
	elseif l == "ambience" then
		sound.play(ambience_track, 3)
		if sound.looping(ambience_track) == true then
			--nothing, because it's already looped
		elseif sound.looping(ambience_track) == false then
			sound.loop(ambience_track)
		end
	elseif l == "sound" then
		sound.play(sound_track, 4)
	elseif l == "sound2" then
		sound.play(sound2_track, 5)
	end
	collectgarbage()
end
function soundPrepare(path, l)
	if not path then error("no path",2) end
	if l == "music" then
		music_track = sound.load(path)
	elseif l == "sound_loop" then
		sound_loop_track = sound.load(path)
	elseif l == "ambience" then
		ambience_track = sound.load(path)
	elseif l == "sound" then
		sound_track = sound.load(path)
	elseif l == "sound2" then
		sound2_track = sound.load(path)
	end
	collectgarbage()
end
function soundVolume(v, type)
	if type == "music" then
		sound.vol(music_track, v)
	elseif type == "sound_loop" then
		sound.vol(sound_loop_track, v)
	elseif type == "ambience" then
		sound.vol(ambience_track, v)
	elseif type == "" then
		--ты шо ебобо? нахуй ты звуку громкость меняешь?
	end
end

function soundStop(type)
	if type == "music" then
		if sound.playing(music_track) then
			sound.stop(music_track)
		end
	elseif type == "sound_loop" then
		if sound.playing(sound_loop_track) then
			sound.stop(sound_loop_track)
		end
	elseif type == "ambience" then
		if sound.playing(ambience_track) then
			sound.stop(ambience_track)
		end
	elseif type == "sound" then
		if sound.playing(sound_track) then
			sound.stop(sound_track)
		end
	end
end

SOUND_VOLUME_ALL = function(v)
	for c in ipairs(ren.settings.track) do soundVolume(v, c-1) end
end
SOUND_STOP_ALL = function()
	for c in ipairs(ren.settings.track) do soundStop(c-1) end
end

function ren.func.play(str)
	local type = str:match("^.-%s(.-)%s.*")
	local fadein = ren.get.fadein(str)
	
	local list = str:match("music_list%[['\"](.-)['\"]%]")
	local path = ""
	
	if list then
		path = ren.settings.var.music_list[list]
	else
		path = ren.settings.var[str:gsub("^.-%s.-%s([%w%s_]*)","%1"):gsub("^([%w%s_]-) fade.*","%1")]
	end
	
	-- music, ambience, sound_loop - loop,
	-- sound - !loop
	soundPrepare(path, type)
	-- fadein
	if type == "music" then
		sound.vol(music_track, 0)
	elseif type == "sound_loop" then
		sound.vol(sound_loop_track, 0)
	elseif type == "ambience" then
		sound.vol(ambience_track, 0)
	elseif type == "" then
		--ты шо ебобо? нахуй ты звуку громкость меняешь?
	end

	soundPlay(type)

	asyncCycle:new(0, 100, 1, fadein*1e3,
	function(v)
		soundVolume(v, type)
	end)
end
	
function ren.func.stop(str)
	local type = str:match("^.-%s(.-)%s.*") or str:match("^.-%s(.*)")
	local fadeout = ren.get.fadeout(str)
	
	-- fadeout
	asyncCycle:new(100, 0, -1, fadeout*1e3,
	function(v)
		if type == "all" then
			SOUND_VOLUME_ALL(v/100)
			if i == 0 then SOUND_STOP_ALL() end
		else
			soundVolume(v, type)
			if i == 0 then soundStop(type) end
		end
	end)
end

function ren.py.volume(volume, channel)
	if channel == "music" then
		sound.vol(music_track, volume)
	elseif channel == "sound_loop" then	
		sound.vol(sound_loop_track, volume)
	elseif channel == "ambience" then	
		sound.vol(ambience_track, volume)
	end
end