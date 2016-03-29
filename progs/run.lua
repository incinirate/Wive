local win = window:new("Run Program",nil,40)
do
	win:setResizable(false)
	local inputBox = UIElement.UITextbox.new(win,nil,20)
    inputBox:focusOn()

    inputBox:setCallback(function(keyIn) 
        if love.filesystem.isFile("progs/"..keyIn) then
            local ok, chunk, result
            ok, chunk = pcall( love.filesystem.load, "progs/"..keyIn ) -- load the chunk safely

            if not ok then
                ok=tostring(ok)
              print(ok..'| The following error happend: ' .. tostring(chunk))
              love.filesystem.load("ewin.lua")(ok.."| Error: "..tostring(chunk))
            else
              ok, result = pcall(chunk) -- execute the chunk safely

              if not ok then -- will be false if there is an error
                        ok=tostring(ok)
                print(ok..'| The following error happened: ' .. tostring(result))
                love.filesystem.load("ewin.lua")(ok.."| Error: "..tostring(result))
              else
                print('The result of loading is: ' .. tostring(result))
              end
            end
        else
            if love.filesystem.isDirectory("progs/"..keyIn) then
                love.filesystem.load("ewin.lua")("Error: progs/"..keyIn.." is a directory!")
            else
                love.filesystem.load("ewin.lua")("Error: progs/"..keyIn.." does not exist!")
            end
        end
        win.close()
    end)
    
	win.callbacks.exit = function()
		inputBox:exit()
	end

	win.callbacks.draw = function()
		--TODO
		--print("CALLED!")
		
        win:setBackgroundColor(250,250,250)
        
		love.graphics.setColor(0,0,0,255)
		love.graphics.print("Type the name of a program to open:",3,3)
		
        inputBox:draw()
	end
end
win:setVisible(true)

--"cmd": ["C:\\LOVE\\love.exe", "C:\\Users\\Bryan\\Documents\\TIGM"]