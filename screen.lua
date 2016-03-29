--Screen Handler

_G.screen = {}

local elements = {}
local focus = {}

local count = 0

function love.draw()
	for v=#focus,1,-1 do
		if elements[focus[v][1]] then
			local vv = elements[focus[v][1]][1]
			if vv:isVisible() then
				vv:draw()
			end
		end
	end

end

function screen.addElement(tElement, nUID)
	if not tElement.getName then
		log("Element requested addition to draw queue does not fit format (Does not contain a 'getName' method), skipping...","CRITICAL")
		return false
	elseif not tElement.isVisible then
		log("Element '"..(tostring(tElement:getName()) or "Unknown Name").."' does not contain a 'isVisible' method! Skipping...","CRITICAL")
		return false
	elseif not tElement.draw then
		log("Element '"..(tostring(tElement:getName()) or "Unknown Name").."' does not contain a 'draw' method! Skipping...","CRITICAL")
		return false
	elseif not nUID then
        log("Element '"..(tostring(tElement:getName()) or "Unknown Name").."' did not give a UID when registering for screen draw","CRITICAL")
        return false
    else
		count = count + 1
		--table.insert(elements,{tElement,nUID})
		elements[count] = {tElement, nUID}
		table.insert(focus,1,{count,nUID})
		return count
	end
end

function screen.removeElement(nId)
	if elements[nId] then
		elements[nId] = nil
		for k,v in pairs(focus) do
			if v[1]==nId then
				table.remove(focus,k)
				break
			end
		end
		if debug then
			log("Removed "..nId.." from the draw queue!","DEBUG")
		end
		return true
	else
		log("Attempt to remove non-existand element ("..nId..") from draw queue","CRITICAL")
		return false
	end
end

function screen.elementExists(nId)
	return elements[nId] and true or false
end

function screen.focusOn(nId)
	for k,v in pairs(focus) do
		if v[1]==nId then
			table.remove(focus,k)
			table.insert(focus,1,v)
			break
		end
	end
end

function screen.hasFocus(nUID)
	return focus[1][2]==nUID
end

function screen.getFocusList()
	--[[local fl = {}
	setmetatable(fl,{
		__index = focus,
		__newindex = function() return false end,
	})]]
	return focus
end