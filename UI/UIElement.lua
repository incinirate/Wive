_G.UIElement = {}

function UIElement:new(parentWindow)
	if not parentWindow then
		log("UIElement init without parent element, skipping...","CRITICAL")
		return
	end
	local t = {UID=parentWindow.UID,parent=parentWindow,focused=false}
	setmetatable(t,{__index=UIElement})
	return t
end

function UIElement:checkFocus()
	return screen.hasFocus(self.UID)
end

for i,v in ipairs(love.filesystem.getDirectoryItems("UI/Elements")) do
    local file = "UI/Elements/"..v
    local ok, chunk, result
    ok, chunk = pcall( love.filesystem.load, file )
    if ok then
        chunk()
    else
        love.filesystem.load("ewin.lua")(tostring(ok).."| CRITICAL ERROR: "..tostring(chunk))
    end
end