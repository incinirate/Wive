_G.UIElement.UIButton = {}
local pointer = _G.UIElement.UIButton

function pointer.new(parent,t,rx,ry,w,h,ctx,cbg)
    ctx = ctx or {52,52,52,255}
    cbg = cbg or {222,222,222,255}
    local superclass = UIElement:new(parent)
    local bu = {t=t,rx=rx,ry=ry,w=w,h=h,ctx=ctx,cbg=cbg,superclass=superclass,callback=function()end}
  
    local mousec = events.registerListener("mousepressed",function(x,y)
      x,y = superclass:convertCoordinates(x,y)
      if screen.hasFocus(parent.UID) then
        if x>=bu.rx and y>=bu.ry and x<bu.rx+bu.w and y<bu.ry+bu.h then
          if bu.callback then
            bu.callback()
          end
        end
      end
    end,parent.UID)
    table.insert(bu.superclass.eventHandles,{mousec,"mousepressed"})
    
    setmetatable(bu, {
		__index=function(t,k) if rawget(pointer,k) then return rawget(pointer, k) end end,
		__newindex = function(t,k,v) return false end,
	})
    return bu
end

local font = love.graphics.newFont(12)
function pointer:draw()
    love.graphics.setColor(unpack(self.cbg))
    love.graphics.rectangle("fill",self.rx,self.ry,self.w,self.h or 15)
    love.graphics.setColor(unpack(self.ctx))
    printc(self.t,self.rx+(self.w/2),self.ry,font,self.h or 15)
end

function pointer:setCallback(func)
    self.callback = func
end

function pointer:setAttr(tatr)
    for k,v in pairs(tatr) do
        self.k = v
    end
end