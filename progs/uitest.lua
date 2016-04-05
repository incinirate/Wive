local testwin = window.new("Debug Window")
 


do
    local buttonTest = UIElement.UIButton.new(testwin,"Press me!",10,10,90,35)
    local textTest = UIElement.UITextbox.new(testwin,10,100,300,nil,nil,"Type Here")
    local checkTest = UIElement.UICheckbox.new(testwin,120,10,15,15)
    
    testwin:setBackgroundColor(250,250,250)
    testwin.callbacks.draw = function()
        buttonTest:draw()
        textTest:draw()
        checkTest:draw()
    end
    --testwin.callbacks.mousepressed = function(x,y)
    --    buttonTest:checkClicked(x,y)
    --end
    
    local tdt = ""
    buttonTest:setCallback(function()
        testwin.callbacks.draw = safeAppend(testwin.callbacks.draw,function()
            love.graphics.setColor(0,0,0,255)
            love.graphics.print("YOU CLICKED ME!",10,60)
            if tdt ~= "" then
              love.graphics.print("You typed: '"..tdt.."'",10,75)
            end
        end)
            log("YOU CLICKED ME!","DEBUG")
    end)
    
    textTest:setCallback(function(txt)
      --pointer:unfocusOn()
      textTest:unfocusOn()
      tdt = txt
    end)
    
    testwin.callbacks.exit = function()
        buttonTest:exit()
        textTest:exit()
    end
end
testwin:setVisible(true)