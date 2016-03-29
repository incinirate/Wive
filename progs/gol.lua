local gx = 45
local gy = 45
local gscale = 13

local win = window:new("Game Of Life",gx*gscale,gy*gscale+16)
do
	--win:setMinDimensions(gx*gscale,gy*gscale+16)
	win:setResizable(false)
	local grid = {}

	for i=1,gx do
		grid[i] = {}
		for j=1,gy do
			grid[i][j] = false
		end
	end

	local running = false

	local lastmx,lastmy = -1,-1
	local limt = true
	local speed = 10
	local bench = 10

	local floor = math.floor

	win.callbacks.draw = function()
		--love.graphics.setBackgroundColor(100,100,100)
		win:setBackgroundColor(100,100,100)
		--draw cells
		for i=1,gx do
			for j=1,gy do
				if grid[i][j] then
					if lastmx == i or lastmy == j then
						love.graphics.setColor(232,201,0)
					else
						love.graphics.setColor(255,251,36)
					end
				else
					if lastmx == i or lastmy == j then
						love.graphics.setColor(80,80,80)
					else
						love.graphics.setColor(100,100,100)
					end
				end
				love.graphics.rectangle("fill",(i-1)*gscale+1,(j-1)*gscale+2,gscale-1,gscale-1)
			end
		end

		--draw grid
		love.graphics.setColor(50,50,50,255)
		for i=1,gx-1 do
			love.graphics.line(i*gscale+1,1,i*gscale+1,gy*gscale)
		end
		for i=1,gy do
			love.graphics.line(1,i*gscale+2,gx*gscale-1,i*gscale+2)
		end

		love.graphics.setColor(250,250,250,255)
		love.graphics.rectangle("fill",0,gy*gscale+2,gx*gscale,14)

		love.graphics.setColor(0,0,0,255)
		love.graphics.print(lastmx..","..lastmy,3,gy*gscale+2)
		love.graphics.print("Max Speed: "..(limt and speed or "∞").."e/s",75,gy*gscale+2)
		love.graphics.print("Actual Speed: "..(running and floor(bench/2).."e/s" or "Not Running"),200,gy*gscale+2)
		--love.graphics.print("Running: "..tostring(running),340,gy*gscale+2)
	end

	local mpress = false
	local lastzx,lastzy = -1,-1
	

	win.callbacks.mousepressed = function(x,y,b)
		local zx,zy = floor(x/gscale)+1,floor(y/gscale)+1
		if grid[zx]~= nil and grid[zx][zy] ~= nil then
			grid[zx][zy] = not grid[zx][zy]
			lastzx = zx
			lastzy = zy
			mpress = true
		end
	end

	win.callbacks.mousereleased = function(x,y,b)
		mpress = false
	end

	win.callbacks.mousemoved = function(x,y)
		local zx,zy = floor(x/gscale)+1,floor(y/gscale)+1
		if zx > gx then zx=gx end
		if zy > gy then zy=gy end
		if mpress then
			if lastzx ~= zx or lastzy ~= zy then
				if grid[zx]~= nil and grid[zx][zy] ~= nil then
					grid[zx][zy] = not grid[zx][zy]
				end
			end
			lastzx = zx
			lastzy = zy
		end
		lastmx,lastmy = zx,zy
	end

	--[[win.callbacks.resize = function(dx,dy,fw,fh)
		local maxs = 0
		if dx < 0 or dy < 0 then
			maxs = math.min(fw,fh)
		else
			maxs = math.max(fw,fh)
		end
		win:setDimensions(maxs,maxs+16)
		gscale = maxs/gx
	end]]

	function getNCount( gxx,gyy )
		local count = 0
		local gpx = gxx + 2
		local gpy = gyy + 2
		for i=1,3 do
			if grid[gpx-i] then
				for j=1,3 do
					if grid[gpx-i][gpy-j] then
						count = count + 1
					end
				end
			end
		end
		if grid[gxx][gyy] then count = count - 1 end
		return count
	end

	local timer = 0
	local last = 0

	events.registerListener("keypressed",function(key)
		if screen.hasFocus(win.UID) then
			if key == " " then
				running = not running
			elseif key == "right" then
			--	if speed == 10 then speed = 20
			--	elseif speed == 5 then speed = 10 end
				speed = speed + 1
		--		timer = 0
				last = 0
			elseif key == "left" then
			--	if speed == 10 then speed = 5
			--	elseif speed == 20 then speed = 10 end
				speed = speed - 1
		--		timer = 0
				last = 0
			elseif key == "r" then
				for i=1,gx do
					grid[i] = {}
					for j=1,gy do
						grid[i][j] = false
					end
				end
			elseif key == "u" then
				limt = not limt
			end
		end
	end,win.UID)

	local evolutions = 0
	local lastbench = 0
	local lastcheckbench = 0

	events.registerListener("update",function(upd)
		if running then
			timer = timer + upd
			local proc = floor(timer*(speed)) > last
			if not limt then proc = true end
			lastbench = lastbench + upd
			if floor(lastbench) > lastcheckbench+1 then
				lastcheckbench = floor(lastbench)
				bench = evolutions
				evolutions = 0
			end
			if proc then
				evolutions = evolutions + 1

				local buff = {}
				for i=1,gx do
					buff[i] = {}
					for j=1,gy do
						local cnt = getNCount(i,j)
						if grid[i][j] then
							if cnt < 2 then
								buff[i][j] = false
							elseif cnt > 3 then
								buff[i][j] = false
							else
								buff[i][j] = true
							end
						elseif cnt == 3 then
							buff[i][j] = true
						else
							buff[i][j] = false
						end
					end
				end
				for i=1,gx do
					for j=1,gy do
						grid[i][j] = buff[i][j]
					end
				end
				last = floor(timer*(speed)) 
			end
		end
	end,win.UID)
end

win:setVisible(true)