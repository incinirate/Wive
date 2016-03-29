local testwin = window:new("Beats MP3 Player")
testwin:setBackgroundColor(250,250,250)
local winspeed = 300

do
    local allfiles = love.filesystem.getDirectoryItems("documents/music")
    
    local playing = true
    local winy = 0
    
    events.registerListener("update",function(dt)
		if playing and winy > -50 then
            winy = winy - dt*winspeed
            if winy<-50 then winy=-50 end
        elseif not playing and winy < 0 then
            winy = winy + dt*winspeed     
            if winy>0 then winy=0 end
        end
	end,testwin.UID)
    
    
    --local playbutton = UIElement.UIButton.new(testwin,"▶",rx,ry,w,h,ctx,cbg)
    
    
	testwin:setMinDimensions(320,180)
	testwin.callbacks.draw = function()
        local stencilFunc = function()
            love.graphics.rectangle("fill",0,0,testwin.width,testwin.height)
        end

        love.graphics.stencil(stencilFunc, "replace", 1)
        love.graphics.setStencilTest("greater", 0)

            love.graphics.setColor(0,0,0,255)
            for k,v in ipairs(allfiles) do
                love.graphics.print(v,3,(k-1)*18+2)
            end
        
            love.graphics.setColor(17,144,232,255)
            love.graphics.rectangle("fill",0,testwin.height+winy,testwin.width,testwin.height+50+winy)
        
            love.graphics.push("all")
            love.graphics.translate(0,testwin.height+winy)
                love.graphics.setColor(52,60,255,255)
                love.graphics.rectangle("fill",10,10,30,30)
                love.graphics.setColor(230,230,230,255)
                --love.graphics.print("▶",15,15)
                love.graphics.polygon("line", 18,17, 32,25, 18,33)
            love.graphics.pop()
        
        love.graphics.setStencilTest()
	end
end
testwin:setVisible(true)