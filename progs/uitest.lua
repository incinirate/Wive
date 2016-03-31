local testwin = window.new("Debug Window")
 


do
    local buttonTest = UIElement.UIButton.new(testwin,"Press me!",10,10,90,35)
    local textTest = UIElement.UITextbox.new(testwin,10,100,300,nil,nil,"Type Here")
    testwin:setBackgroundColor(250,250,250)
    testwin.callbacks.draw = function()
        buttonTest:draw()
        textTest:draw()

    end
    --testwin.callbacks.mousepressed = function(x,y)
    --    buttonTest:checkClicked(x,y)
    --end
    
    buttonTest:setCallback(function()
        testwin.callbacks.draw = safeAppend(testwin.callbacks.draw,function()
            love.graphics.setColor(0,0,0,255)
            love.graphics.print("YOU CLICKED ME!",10,60)
            
        end)
            log("YOU CLICKED ME!","DEBUG")
    end)
    
    testwin.callbacks.exit = function()
        buttonTest:exit()
        textTest:exit()
    end
end
testwin:setVisible(true)