local hooks = {
	["keypressed"] = true,
	["keyreleased"] = true,
	["textinput"] = true,
	["mousepressed"] = true,
	["mousereleased"] = true,
	["mousemoved"] = true,
	["update"] = true,
}

_G.events = {}

local isGiving = false
local toAdd = {}

for k,v in pairs(hooks) do
	events[k] = {}
	love[k] = function(...)
		isGiving = true
		local BREAKOUT = false
		local args = {...}
		local argct = #args
		for kkk,vvv in ipairs(screen.getFocusList()) do
			--print(#screen.getFocusList())
			--print(screen.getFocusList()[1][2])
			--print("AMILOOPING")
			for kk,vv in pairs(events[k]) do
				if vvv[2] == vv[2] then
					local cap = {false}
					args[argct+1] = cap
					--pcall(vv[1],unpack(args))
					vv[1](unpack(args))
					if cap[1] then
						BREAKOUT = true
						break
					end
				end
			end
			if BREAKOUT then
				break
			end
		end

		for kk,vv in pairs(events[k]) do
			if vv[3] then
				vv[1](unpack(args))
			end
		end
		isGiving = false
		for x=1,#toAdd do
			print("CLEARED BARIER")
			table.insert(events[toAdd[x][1]],toAdd[x][2])
		end
		toAdd = {}
	end
end

function events.registerListener(sEvent, fCallback, nUID, bLoner)
	if not nUID then
		error("Y U NO EXIST!?",2)
	end
	bLoner = bLoner or false
	if hooks[sEvent] then
		table.insert(events[sEvent],{fCallback,nUID,bLoner})
		local toRet = #events[sEvent]
		if isGiving then
			print("PREVENTION!")
			table.insert(toAdd,{sEvent,events[sEvent][toRet]})
			table.remove(events[sEvent],toRet)
		end
		return toRet
	else
		log("Attempt to register listener for nonexistant event","CRITICAL")
		return false
	end
end

function events.unregisterListener(sEvent, nId)
	if hooks[sEvent] then
		if events[sEvent][nId] then
			events[sEvent][nId] = nil
			--table.remove(events[sEvent],nId)
			if debug then
				log("Unregistered "..nId.." for "..sEvent,"DEBUG")
			end
			return true
		else
			log("Attempt to unregister "..sEvent.." listener '"..nId.."' which does not exist.","CRITICAL")
		end
	else
		log("Attempt to unregister listener for nonexistant event","CRITICAL")
		return false
	end
end