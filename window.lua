--Window UI Element

_G.window = {}

function window:new(sName,nWidth,nHeight)
	nWidth,nHeight = nWidth or 320,nHeight or 180
	local w = {callbacks={},visible=false,width=nWidth,height=nHeight,x=0,y=0,mino=false,maxo=false,cloo=false,resizeable=true,bg={0,0,0,255}}
	local fon = love.graphics.getFont()
	if sName then w["name"] = sName else w["name"] = "Untitled" end

	w.minw = fon:getWidth(w.name) + 3 + 51
	w.minh = 1

	local screenID
	local UID = getUID()
--	print("NEWUID: "..UID)
	do
		local beingDragged = false
		local beingResized = false
		local listeners = {}

		table.insert(listeners,{"mousepressed",events.registerListener("mousepressed",function(x,y,button,cwut,capture)
			if x >= w.x and x < w.x+w.width-48 then
				print(w.x+w.width-2)
				if y >= w.y and y < w.y+17 then
					--DRAGTIME!!!
					beingDragged = true
					capture[1] = true
				end
			elseif x >= w.x+w.width-18 and x < w.x+w.width-2 and y >= w.y and y < w.y+17 then
					capture[1] = true
					w.close()
					return
			end
			if w.resizeable then
				local setc = false
				if x >= w.x-3 and x <= w.x+3 then
					if y > w.y+17 and y < w.y+w.height+17 then
						beingResized = 1
						setc = true
					end
				elseif x > w.x+w.width-3 and x < w.x+w.width+3 then
					if y > w.y+17 and y < w.y+w.height+17 then
						beingResized = 3
						setc = true
					end
				elseif x >= w.x and x < w.x+w.width then
					if y > w.y+w.height+14 and y < w.y+w.height+20 then
						beingResized = 2
						setc = true
					end
				end
				if not setc then
					beingResized = false
				end
			end

			if x >= w.x and x < w.x+w.width then
				if y > w.y+17 and y < w.y+w.height+17 then
					if w.callbacks.mousepressed then
						w.callbacks.mousepressed(x-w.x,y-w.y-18,button)
					end
					capture[1] = true
				end
			end
            if not w then return end
			if x >= w.x and x < w.x+w.width and y >= w.y and y < w.y+w.height+18 then
				screen.focusOn(screenID)
				capture[1] = true
			end
		end,UID)})

		table.insert(listeners,{"mousemoved",events.registerListener("mousemoved",function(mx,my,dx,dy,cwut,capture)
			if beingDragged then
				w.x = w.x + dx
				w.y = w.y + dy
				capture[1] = true
				return
			elseif beingResized then
				local recalc = fon:getWidth(w.name) + 3 + 51
				if w.minw < recalc then w.minw = recalc end
				if beingResized==3 then --e
					w.width = w.width + dx
					love.mouse.setCursor(cursors.sizewe)
				elseif beingResized==2 then --ns
					w.height = w.height + dy
					love.mouse.setCursor(cursors.sizens)
				elseif beingResized==1 then --w
					w.width = w.width - dx
					love.mouse.setCursor(cursors.sizewe)
					w.x = w.x + dx
				end
				print(w.minw)
				if w.width < w.minw then
					w.width = w.minw
				end
				if w.height < w.minh then
					w.height = w.minh
				end
				if w.callbacks.resize then
					local dxg = dx
					local dyg = dy
					if beingResized == 2 then
						dxg = 0
					else
						dyg = 0
					end
					w.callbacks.resize(dxg,dyg,w.width,w.height)
				end
				return
			end

			if mx >= w.x and mx < w.x+w.width then
				if my > w.y+17 and my < w.y+w.height+17 then
					if w.callbacks.mousemoved then
						w.callbacks.mousemoved(mx-w.x,my-w.y-18,dx,dy)
					end
					capture[1] = true
				end
			end
            if not w then return end
			local setc = false
			if w.resizeable then
				if (mx >= w.x-3 and mx <= w.x+3) or (mx > w.x+w.width-3 and mx < w.x+w.width+3) then
					if my > w.y+17 and my < w.y+w.height+17 then
						love.mouse.setCursor(cursors.sizewe)
						setc = true
					end
				elseif mx >= w.x and mx < w.x+w.width then
					if my > w.y+w.height+14 and my < w.y+w.height+20 then
						love.mouse.setCursor(cursors.sizens)
						setc = true
					end
				end
			end
			if not setc then
				love.mouse.setCursor(cursors.arrow)
			end

			if mx >= w.x+w.width-48 then
				if my >= w.y and my < w.y+17 then
					--DRAGTIME!!!
					if mx < w.x+w.width-37 then
						w.mino = true
						w.maxo = false
						w.cloo = false
					elseif mx < w.x+w.width-19 then
					    w.maxo = true
					    w.mino = false
					    w.cloo = false
				    elseif mx < w.x+w.width-2 then
				    	w.cloo = true
				    	w.mino = false
				    	w.maxo = false
					else
						w.mino = false
						w.maxo = false
						w.cloo = false
					end
					capture[1] = true
				else
					w.mino = false
					w.maxo = false
					w.cloo = false
				end
			else
				w.mino = false
				w.maxo = false
				w.cloo = false
			end
		end,UID)})

		table.insert(listeners,{"mousereleased",events.registerListener("mousereleased",function(x,y,button,cwut,capture)
			beingDragged = false
			beingResized = false
			if x >= w.x and x < w.x+w.width then
				if y > w.y+17 and y < w.y+w.height+17 then
					if w.callbacks.mousereleased then
						w.callbacks.mousereleased(x-w.x,y-w.y-18,button)
					end
					capture[1] = true
				end
			end
		end,UID)})

		w.close = function()
			if w.callbacks.exit then
				w.callbacks.exit()
			end
			for k,v in pairs(listeners) do
				events.unregisterListener(v[1],v[2],UID)
			end
			if screen.elementExists(screenID) then
				screen.removeElement(screenID)
			end
			w = nil
		end
	end

	w["UID"] = UID

	setmetatable(w, {
		__index=function(t,k) if rawget(window,k) then return rawget(window, k) end end,
		__newindex = function(t,k,v) return false end,
	})

	screenID = screen.addElement(w,UID)
	w["screenID"] = screenID
	
	return w,screenID,UID
end

function window:draw()
	love.graphics.setColor(180,180,180,255)
	if screen.getFocusList()[1][2] == self.UID then
		love.graphics.setColor(240,240,240,255)
	end
	love.graphics.rectangle("fill", self.x, self.y, self.width+2, 18)
	love.graphics.setLineWidth(1)
	love.graphics.rectangle("fill", self.x, self.y+17, self.width+2, self.height+2)
	love.graphics.setColor(0,0,0,255)
	love.graphics.print(self.name, self.x+3, self.y+1)

	love.graphics.push()
	love.graphics.setColor(unpack(self.bg))
	love.graphics.translate(self.x+1,self.y+18)
	love.graphics.rectangle("fill",0,0,self.width,self.height)
	if self.callbacks.draw then
		self.callbacks.draw()
	end
	love.graphics.pop()

	love.graphics.setColor(0,0,0,255)
	
	-- 'x'
	local endf = self.x+self.width

	if self.cloo then
		love.graphics.setColor(255, 0, 0, 255)
		love.graphics.rectangle("fill", endf-14, self.y+2, 14, 14)
		love.graphics.setColor(255,255,255,255)
	end
	love.graphics.line(endf-12,self.y+3,endf-2,self.y+14)
	love.graphics.line(endf-2,self.y+3,endf-12,self.y+14)
	love.graphics.setColor(0,0,0,255)
	-- '[]'
	if self.maxo then
		love.graphics.setColor(150, 150, 150, 255)
		love.graphics.rectangle("fill", endf-33, self.y+2, 17, 14)
		love.graphics.setColor(0,0,0,255)
	end
	love.graphics.rectangle("line", endf-30, self.y+3, 11, 11)
	-- '_'
	if self.mino then
		love.graphics.setColor(150, 150, 150, 255)
		love.graphics.rectangle("fill", endf-51, self.y+2, 17, 14)
		love.graphics.setColor(0,0,0,255)
	end
	love.graphics.line(endf-48, self.y+14, endf-37, self.y+14)
end

function window:setVisible(bVis)
	rawset(self, "visible", bVis)
end

function window:isVisible()
	return rawget(self, "visible")
end

function window:setName(sName)
	rawset(self, "name", sName)
end

function window:getName()
	return "{WINDOW}-"..(rawget(self,"name") or "UnknownPName")
end

function window:focus()
	screen.focusOn(self.screenID)
end

function window:setDimensions(w,h)
	self.width = w
	self.height = h
end

function window:setResizable(rbl)
	self.resizeable = rbl
end

function window:setMinDimensions(w,h)
	if w then print("HI") self.minw = w end
	print(self.minw)
	if h then print("YO") self.minh = h end
end

function window:getBackgroundColor()
	return unpack(self.bg)
end

function window:setBackgroundColor(r,g,b)
	self.bg = {r,g,b,255}
end
