function ren.get.name(str) 
	return str:gsub("(.-) at.*", "%1")
	:gsub("(.-) with.*", "%1")
	:gsub("^.-%s([%w%s_]*)","%1")
	:gsub("(.-):?","%1")
end
function ren.get.fadein(str) return tonumber(str:match("fadein ([%a_][%w_]*)")) or 0 end
function ren.get.fadeout(str) return tonumber(str:match("fadeout ([%a_][%w_]*)")) or 0 end
function ren.get.at(str) return	ren.settings.var[str:match("at ([%a_][%w_]*)")] end
function ren.get.with(str) return str:match("with ([%a_][%w_]*)") end