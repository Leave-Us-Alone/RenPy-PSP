regulared = font.load('fonts/oneFont.pgf')

function print(x, y, clr, str, size)
	if not x or not y or not clr or not str then
		error('x, y, color, string expected, got: '..tostring(x)..','..tostring(y)..','..tostring(clr)..','..tostring(str), 2)
	end
	if size == nil then size = 0.7 end
	API.font.print(regulared, x, y, clr, str, size)
end


function printcenter(x, y, clr, str)
	if not x or not y or not clr or not str then
		error('x, y, color, string expected, got: '..tostring(x)..','..tostring(y)..','..tostring(clr)..','..tostring(str), 2)
	end
	screen.print(regulared, x, y, str, 0.7, clr, 0, __ACENTER)
end