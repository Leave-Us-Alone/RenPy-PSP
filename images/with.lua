function getNextWith()
	local i = reader.pos + 1
	local line = ""
	local funcName = ''
	while true do
		line = reader.file[reader.fName].line[i]
		funcName = line:match('^%s*(.-)%s.*')
		if funcName == 'with' then
			return {line:match('.*%s(.-)$')}
		elseif funcName == 'scene' or funcName == 'show' or funcName == 'hide' or funcName:match("^pos") then
			i = i+1
		else
			return nil
		end
	end
end
function ren.func.with(str)
    local prev = reader.file[reader.fName].line[reader.pos-1]
    local func = prev:denote():trim():match("^(.-)%s.-")
    if not (func == "scene" or func == "show" or func == "hide") then
        local with = str:match('^with (.*)') or "none"
        local final = function()
            ren.pause = false
            ren.next = next
        end
        ren.effect[with]('with','',final)
    end
    ren.pause = true
    ren.next = false
end