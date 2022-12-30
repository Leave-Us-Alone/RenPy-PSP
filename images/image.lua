function IMAGE_KILL(arr, cond)
	if not cond then cond = function() return true end end
	local n = 0
	for i = 1, #arr do
		local image = arr[i-n]
		if cond(image) then
			ren.path[image.path] = nil
			table.splice(arr, i-n, 1)
			n = n + 1
		end
	end
end
function IMAGE_RESET(arr)
	for _, image in ipairs(arr) do
		image.alpha = 255
		image.pos[1] = image.pos0[1]
		image.pos[2] = image.pos0[2]
	end
end
function IMAGE_ALPHA(arr, i, cond)
	if i == nil then error("IMAGE_ALPHA: got nil alpha channel",2) end
	if arr == nil then error("IMAGE_ALPHA: got nil array",2) end
	if not cond then cond = function() return true end end
	for _, image in ipairs(arr) do
		if cond(image) then
			image.alpha = i
		end
	end
end
function IMAGE_MOVE(arr, dx, dy)
	for _, image in ipairs(arr) do
		image.pos[1] = image.pos[1] + dx
		image.pos[2] = image.pos[2] + dy
	end
end
function IMAGE_LOAD(arr)
	for _, image in ipairs(arr) do
		if not ren.path[image.path] then
			ren.path[image.path] = API.image.load(image.path)
		end
	end
end
--local was = 1
function HIDE_COND(name,isName)
	return function(image)
		--was = was + 1
		--if was == 6 then error2({reader.pos,name,isName,image}) end
		return (isName and name == image.name) or (not isName and image.name:match('^'..name:escape()))
	end
end