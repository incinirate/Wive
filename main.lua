io.stdout:setvbuf("no")

_G.debug = false
--Setup Logger
local logTagQueue = {}
function setLogLevel(sLevel)
	if not sLevel then
		error("Attempt to set nil log level",2)
	end
	sLevel = tostring(sLevel)
	table.insert(logTagQueue,sLevel)
end

function clearLogLevel()
	if #logTagQueue < 1 then
		error("Attempt to clear log level when none was set!",2)
	end
	table.remove(logTagQueue,#logTagQueue)
end

function log(sMess, sLevel, dateOverride)
	if #logTagQueue > 0 and not sLevel then
		sLevel = logTagQueue[#logTagQueue]
	else
		sLevel = tostring(sLevel) or "UNK"
	end
	if not sMess then
		print("[FINE] Attempt to log a nil message!")
		return
	end
    local dateToPut = "DateSkipped"
    if not dateOverride then
        dateToPut = os.date("%x %X")
    end
	sMess = tostring(sMess)
	print("["..sLevel:upper().."] "..sMess)
    local succ,err = love.filesystem.append("logfile.log","{"..dateToPut.."}["..sLevel:upper().."] "..sMess.."\r\n")
    if not succ then
        love.filesystem.write("logfile.log","No logfile, creating...")
        love.filesystem.append("logfile.log","{"..dateToPut.."}["..sLevel:upper().."] "..sMess.."\r\n")
    end
end

function safeAppend(func, appendie)
    local oldfunc = func or function() end
    func = function() oldfunc() appendie() end
    return func
end

local uidCount = 0
function getUID()
	uidCount = uidCount + 1
	return uidCount
end

--Requires
_G.utf8 = require 'utf8'
require 'event'
require 'screen'
require 'cursors'
require 'window'
require 'gpuex'

log("  ---==[ SYSTEM INITIALIZATION ]==--","SYSTEM")

--Global Functions


--print(2^46+1)

--Main variables
local placeholder = "Iamaplaceholder"

local backgroundUID = getUID()

local backgroundID = screen.addElement({
	getName = function() return "bgsetter" end,
	isVisible = function() return true end,
	draw = function() love.graphics.setBackgroundColor(7, 6, 87, 255) end,
},backgroundUID)

events.registerListener("mousepressed",function(x,y,b)
    --screen.focusOn(backgroundID)
    log("GOT AN EVENT")
	if b==2 then
		--dofile("progs/run.lua")
		love.filesystem.load("progs/run.lua")()
	end
end,backgroundUID)

love.window.setTitle("Window Environment")
love.window.setMode(1280,720,{resizable=true,vsync=false})
love.keyboard.setKeyRepeat(true)

if debug then
	log("Debug mode is enabled!", "WARN")
	setLogLevel("DEBUG")
	
	do
		local testwin = window:new("Debug Window")
		testwin:setVisible(true)
		log(testwin:isVisible() and "Visible Setter Functional" or "Visible Setter Dysfunctional")
		testwin:setVisible(false)
		testwin.testMetaMethods = "not working"
		log("Window Metamethod status: "..(testwin.testMetaMethods or "working"))
		dofile("progs/wave.lua")
		events.registerListener("mousepressed",function(x,y,b,c) if not c[1] then log("Mouse pressed! ("..x..","..y..","..b..")","DEBUG") end end)
	end
	
	clearLogLevel()
end

love.quit = function() log("  ---==[ SYSTEM SHUTDOWN ]==---","SYSTEM") end