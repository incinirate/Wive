--require 'UI\\UIElement'
local ok, chunk, result
ok, chunk = pcall( love.filesystem.load, "UI/UIElement.lua" )
if ok then chunk()
else
    love.filesystem.load("ewin.lua")(tostring(ok).."| CRITICAL ERROR: "..tostring(chunk))
end

function _G.printc(t,x,y,f,va)
    local width = f:getWidth(t)
    if va then
        local height = f:getHeight(t)
        y = y+(va/2)-1-(height/2)
    end
    love.graphics.print(t,x-(width/2),y)
end