function string:spaces() return self:gsub("^(%s*).-$","%1"):len() end
function getLevel(str, fName, pos)
	local level = str:spaces()
	if level%4 ~= 0 then 
    --error("File \""..tostring(fName).."\", line "..tostring(pos)..": need repair spaces, your level = "..tostring(level%4), 2)
	end
	return 1 + level / 4
end
function string:denote() return self:gsub("(.-)#[^\"]*$","%1") end