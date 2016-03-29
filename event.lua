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

local listeners = { lone = {} }

--[[
{
	UID = {
		keypressed = {
			1 = callback = function,
			2 = callback = function,
		}
	},
	-1073(lone) = {
		...
	}
}
]]

for k,v in pairs(hooks) do
	love[k] = function(...)
		local BREAKOUT = false
		local args = {...}
		local argct = #args
		for kk,vv in ipairs(screen.getFocusList()) do
			if listeners[vv[2]] then
				if listeners[vv[2]][k] then
					for kkk,vvv in pairs(listeners[vv[2]][k]) do
						if type(vvv) == "function" then
							local cap = {false,"whyamihere"}
                            --log("What is cap: "..tostring(cap))
                            if k=="mousepressed" then
                            log("YO ["..k.."] : "..args[3])
                                end
							args[argct+1]=cap
                            --log("What is it rly tho: "..tostring(args[argct+1]))
							vvv(unpack(args))
                            
							if cap[1] then
								BREAKOUT = true
							end
						end
					end
				end
			end
			if BREAKOUT then
				break
			end
		end

		--[[if listeners[-1073][k] then
			for kk,vv in pairs(listeners[-1073][k]) do
				if type(vv) == "function" then
					vv(unpack(args))
				end
			end
		end]]
	end

	--listeners[-1073] = {}
end

function events.registerListener(sEvent, fCallback, nUID, bLonerCatch)
	if type(bLonerCatch)~="nil" then error("NOT BACKWARDS COMPATIBLE!!!",2) end
	if type(sEvent) ~= "string" or type(fCallback) ~= "function" or type(nUID) ~= "number" then
		log("Incorrect registering synatax, events:registerListener(sEvent, fCallback, nUID)","CRITICAL")
		log("Register INFO for trace: sEvent:"..tostring(sEvent)..", nUID:"..tostring(nUID),"CRITICAL")
		error("BAD",2)
		return
	end
	if not listeners[nUID] then
		listeners[nUID] = {}
	end
	if not listeners[nUID][sEvent] then
		listeners[nUID][sEvent] = {count = 0}
	end
	listeners[nUID][sEvent].count = listeners[nUID][sEvent].count + 1
	listeners[nUID][sEvent][listeners[nUID][sEvent].count] = fCallback
	return listeners[nUID][sEvent].count
end

function events.unregisterListener(sEvent, nID, nUID)
	if type(sEvent) ~= "string" or type(nID) ~= "number" or type(nUID) ~= "number" then
		log("Incorrect deregistering synatax, events:registerListener(sEvent, nID, nUID)","CRITICAL")
		log("Register INFO for trace: sEvent:"..tostring(sEvent)..", nUID:"..tostring(nUID),"CRITICAL")
	end

	if listeners[nUID] then
		if listeners[nUID][sEvent] then
			if listeners[nUID][sEvent][nID] then
				listeners[nUID][sEvent][nID] = nil
			end
		end
	end
end