function ren.func.jump(str)
	local label = ren.keyword.label[str:match("jump (.*)")]
	reader:toFile(label.fName)
	reader:toLine(label.pos)
	ren.settings.level = {{keyword="label"}}
end