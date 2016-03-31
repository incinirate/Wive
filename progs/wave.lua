local testwin = window.new("Sine Wave")
do
	testwin:setMinDimensions(nil,180)
	local timer = 0
	local r,g,b = math.random(0,255),math.random(0,255),math.random(0,255)
  local orr,org,orb = r,g,b
  local tr,tg,tb = math.random(0,255),math.random(0,255),math.random(0,255)
  local totim = 0.5
  local atrit = 0
	events.registerListener("update",function(dt)
		timer = timer + dt
    atrit = atrit + dt
    if atrit>totim then atrit = totim end
    do
      --Lerp to the new rgb
      r,g,b = orr + ((atrit / totim) * (tr-orr)),  org + ((atrit / totim) * (tg-org)),  orb + ((atrit / totim) * (tb-orb))
      if r==tr and g==tg and b==tb then
        tr,tg,tb = math.random(0,255),math.random(0,255),math.random(0,255)
        orr,org,orb = r,g,b
        atrit = 0
      end
    end
	end,testwin.UID)
	testwin.callbacks.draw = function()
		--TODO
		--print("CALLED!")
		love.graphics.setColor(r,g,b,255)
		for i=0,testwin.height/10-1 do
			love.graphics.rectangle("fill",((testwin.width-20)/2)+math.sin((timer-(i*0.1))*1.4)*((testwin.width-20)/2),i*10,20,10)
		end
	end
end
testwin:setVisible(true)