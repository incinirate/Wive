_G.UIElement.UITextbox = {}
local pointer = _G.UIElement.UITextbox

function pointer.new(parent,x,y,w,ctx,cbg,btx)
    local superclass = UIElement:new(parent)
    x = x or 3
    w = w or superclass.parent.width - 6
    ctx = ctx or {0,0,0,255}
    cbg = cbg or {195,195,195,255}
    btx = btx or ""
    local bu = {x=x,y=y,w=w,ctx=ctx,cbg=cbg,btx=btx,t="",tpos=0,poff=0,tick=true,focus=false,fon=love.graphics.getFont(),canvas=love.graphics.newCanvas(w,18),eventHandles={},parent=parent,callback=function()end}
    
    local timer = 0
	local upe = events.registerListener("update",function(dt)
		timer = timer + dt
		if timer > 0.5 then
			bu.tick = not bu.tick
			timer = 0
		end
	end,parent.UID)
    table.insert(bu.eventHandles,{upe,"update"})
	local fon = love.graphics.getFont()
	local tie = events.registerListener("textinput",function(char)
		if screen.hasFocus(parent.UID) and bu.focus then
			bu.t = bu.t:sub(1,bu.tpos) .. char .. bu.t:sub(bu.tpos+1)
            bu.tpos = bu.tpos+1
			bu.tick = true
			timer = 0
            if bu.fon:getWidth(bu.t:sub(1,bu.tpos))+bu.x+bu.poff >= bu.x+bu.w-5 then
                bu.poff = bu.w-bu.fon:getWidth(bu.t:sub(1,bu.tpos))-5
            end
		end
	end,parent.UID)
    table.insert(bu.eventHandles,{tie,"textinput"})
    local mousec = events.registerListener("mousepressed",function(x,y)
        if screen.hasFocus(parent.UID) then
            if x-parent.x >= bu.x and y- parent.y - 18 >= bu.y and y- parent.y - 18 < bu.y+18 and x-parent.x < bu.x+bu.w then
                bu.focus = true
            else
                bu.focus = false
            end
        end
    end,parent.UID)
    table.insert(bu.eventHandles,{mousec,"mousepressed"})
	local keye = events.registerListener("keypressed",function(key)
		if key == "backspace" then
			if screen.hasFocus(parent.UID) and bu.focus then
		        local byteoffset = utf8.offset(bu.t, bu.tpos)
		 
		        if byteoffset then
		            bu.tick = true
		            timer = 0
		            bu.t = string.sub(bu.t, 1, byteoffset - 1)..string.sub(bu.t, byteoffset+1)
                    bu.tpos = bu.tpos - 1
                    if bu.fon:getWidth(bu.t:sub(1,bu.tpos))+bu.x+bu.poff < bu.x then
                        bu.poff = 15-bu.fon:getWidth(bu.t:sub(1,bu.tpos))
                        if bu.poff > 0 then
                            bu.poff = 0
                        end
                    end
				end
			end
		elseif key == "return" then
            if screen.hasFocus(parent.UID) and bu.focus then
                bu.callback(bu.t)
            end
        elseif key == "right" then
            if screen.hasFocus(parent.UID) and bu.focus then
                if bu.tpos < #bu.t then
                    bu.tpos = bu.tpos+1
                    if bu.fon:getWidth(bu.t:sub(1,bu.tpos))+bu.x+bu.poff >= bu.x+bu.w-5 then
                        bu.poff = bu.w-bu.fon:getWidth(bu.t:sub(1,bu.tpos))-5
                    end
                    bu.tick = true
                    timer = 0
                end
            end
        elseif key == "left" then
            if screen.hasFocus(parent.UID) and bu.focus then
                if bu.tpos > 0 then
                    bu.tpos = bu.tpos-1
                    if bu.fon:getWidth(bu.t:sub(1,bu.tpos))+bu.x+bu.poff < bu.x then
                        bu.poff = -bu.fon:getWidth(bu.t:sub(1,bu.tpos))
                    end
                    bu.tick = true
                    timer = 0
                end
            end
		end
	end,parent.UID)
    table.insert(bu.eventHandles,{keye,"keypressed"})
    
    setmetatable(bu, {
		__index=function(t,k) if rawget(pointer,k) then return rawget(pointer, k) end end,
		__newindex = function(t,k,v) return false end,
	})
    return bu
end

function pointer:exit()
    for k,v in ipairs(self.eventHandles) do
        events.unregisterListener(v[2], v[1], self.parent.UID)
    end
end

function pointer:draw()
    local stencilFunc = function()
        love.graphics.rectangle("fill",self.x,self.y,self.w,18)
    end
    
    love.graphics.stencil(stencilFunc, "replace", 1)
    love.graphics.setStencilTest("greater", 0)
        love.graphics.setColor(unpack(self.cbg))
        love.graphics.rectangle("fill",self.x,self.y,self.w,18)
        love.graphics.setColor(unpack(self.ctx))
        love.graphics.print(self.t,self.x+2+self.poff,self.y+2)
        if self.tick and self.focus then
            love.graphics.print("|",self.fon:getWidth(self.t:sub(1,self.tpos))+self.x+self.poff,self.y+1)
        end
    love.graphics.setStencilTest()
end

function pointer:focusOn()
    self.focus = true
end

function pointer:unfocusOn()
    self.focus = false
end

function pointer:setCallback(func)
    self.callback = func
end