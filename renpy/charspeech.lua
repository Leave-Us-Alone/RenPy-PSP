function character_speech(str, level, extraChars)
    local varName = str:match("^[%a_][%w_]*")
    if not ren.settings.character[varName] then
        ren.settings.character[varName] = {name="", color="FFFF00"}
    end
    local text = str:sub(varName:len()+1):eval()
    local name = ren.settings.character[varName].name
    local clr = ren.settings.character[varName].color:toRGB()
    
    if varName == "th" then text = "~"..text.."~" end
	
	ren.history.current.text = text
	ren.history.current.pos = reader.pos
	msg_new(text)
    ren.settings.dialog.box.name = name
    ren.settings.dialog.box.name_clr = clr
    
    ren.next = false
end

function ren.func.define(str)
	local name = str:match("define ([%w%s_]-) = .*")
	local result = str:match("define [%w%s_]- = (.*)"):expr_exec():eval()
  
  ren.settings.character[name] = result
  ren.func[name] = character_speech
end