local testwin = window:new("Sine Wave")
do
	testwin:setMinDimensions(nil,180)
	local timer = 0
	local r,g,b = math.random(0,255),math.random(0,255),math.random(0,255)
	events.registerListener("update",function(dt)
		timer = timer + dt
	end,testwin.UID)
	testwin.callbacks.draw = function()
		--TODO
		--print("CALLED!")
		love.graphics.setColor(r,g,b,255)
		for i=0,testwin.height/10+1 do
			love.graphics.rectangle("fill",((testwin.width-20)/2)+math.sin((timer-(i*0.1))*1.4)*((testwin.width-20)/2),i*10,20,10)
		end
	end
end
testwin:setVisible(true)