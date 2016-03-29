local x = {...}
local emes = x[1]

local win = window:new("Error",nil,18)
do
	local font = love.graphics.getFont()
	if font:getWidth(emes)+6 > win.width then
		win.width = font:getWidth(emes)+6
	end

	win:setBackgroundColor(250,250,250)
	win.callbacks.draw = function()
		love.graphics.setColor(0,0,0,255)
		love.graphics.print(emes,2,3)
	end
end
win:setVisible(true)