_G.UIElement.UICheckbox = {}
local pointer = _G.UIElement.UICheckbox

function pointer.new(parent,rx,ry,w,h,cfg,cbg)
    cfg = cfg or {0,0,0,255}
    cbg = cbg or {0,0,0,255}
    local superclass = UIElement:new(parent)
    local bu = {checked=false,rx=rx,ry=ry,w=w,h=h,cfg=cfg,cbg=cbg,superclass=superclass,callback=function()end}
  
    local mousec = events.registerListener("mousepressed",function(x,y)
      x,y = superclass:convertCoordinates(x,y)
      if screen.hasFocus(parent.UID) then
        if x>=bu.rx and y>=bu.ry and x<bu.rx+bu.w and y<bu.ry+bu.h then
          bu.checked = not bu.checked
          if bu.callback then
            bu.callback(bu.checked)
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

function pointer:draw()
  love.graphics.setColor(unpack(self.cbg))
  love.graphics.setLineWidth(1)
  love.graphics.setLineStyle("rough")
  love.graphics.rectangle("line",self.rx,self.ry,self.w,self.h)
  if self.checked then
    love.graphics.setColor(unpack(self.cfg))
    love.graphics.rectangle("fill",self.rx + 1, self.ry + 2, self.w - 3, self.h - 3)
  end
end
