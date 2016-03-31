local testwin = window.new("Memory Solver",360,180)
do
    
    testwin:setBackgroundColor(200,200,200)
    local status = "1"
    local font = love.graphics.newFont("arial.ttf")
    
    local button1 = UIElement.UIButton.new("1",40,40,40,40)
    local button2 = UIElement.UIButton.new("2",120,40,40,40)
    local button3 = UIElement.UIButton.new("3",200,40,40,40)
    local button4 = UIElement.UIButton.new("4",280,40,40,40)
    
    testwin.callbacks.draw = function()
        love.graphics.setColor(100,100,100,255)
        love.graphics.rectangle("fill",0,15,360,15)
        love.graphics.setColor(230,230,230,255)
        printc("Stage "..status,180,15,font,15)
        button1:draw()
        button2:draw()
        button3:draw()
        button4:draw()
    end
    testwin.callbacks.mousepressed = function(x,y)
        button1:checkClicked(x,y)
    end
    button1:setCallback(function()
        testwin.callbacks.draw = safeAppend(testwin.callbacks.draw,function()
            love.graphics.setColor(0,0,0,255)
            love.graphics.print("YOU CLICKED ME!",10,60)
        end)
    end)
end
testwin:setVisible(true)