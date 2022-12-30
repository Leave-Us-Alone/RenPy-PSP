function ren.Image(name, path, pos, size, alpha)
	return {name=name, path=path, pos0={pos[1], pos[2]}, pos=pos, size=size, alpha=alpha}
end

function ren.func.image(str)
	local name = str:gsub("image ([%w%s_]-) =.*", "%1")
  local result = str:gsub("image [%w%s_]- = (.*)", "%1"):expr_exec():eval()
	
	if type(result) == 'string' then
		ren.settings.image[name] = {ren.Image(name, result, {0,0}, {0,0}, 255)}
	else
		for i, args in ipairs(result) do
			result[i] = ren.Image(name, args[1], args[2], args[3], args[4])
		end
		ren.settings.image[name] = result
	end
end