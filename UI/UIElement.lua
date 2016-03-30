_G.UIElement = {}

function UIElement:new(parentWindow)
	if not parentWindow then
		log("UIElement init without parent element, skipping...","CRITICAL")
		return
	end
	local t = {UID=parentWindow.UID,parent=parentWindow,focused=false,eventHandles={}}
	setmetatable(t,{__index=UIElement})
	return t
end

function UIElement:checkFocus()
	return screen.hasFocus(self.UID)
end

function UIElement:convertCoordinates(x,y)
  return x - self.parent.x, y - self.parent.y - 18
end

function UIElement:unregisterHandles()
  for k,v in ipairs(self.eventHandles) do
    events.unregisterListener(v[2], v[1], self.parent.UID)
  end
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