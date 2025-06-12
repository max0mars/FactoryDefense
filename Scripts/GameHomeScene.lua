local button = require 'Scripts/button'

local GameHomeScene = {

}

function GameHomeScene:load(sceneData)
    if(sceneData) then
        self.sceneData = sceneData
        self.newGame = 0
    else
        self.newGame = 1
    end
end

function GameHomeScene:update(dt, args)
    
end

function GameHomeScene:draw()
    love.graphics.clear(0, 0, 0, 255)
    love.graphics.setColor(255, 0, 0)
    love.graphics.print("Armoury", 80, 10)
    love.graphics.print("Map", 600, 10)
    love.graphics.print("Workshop", 1000, 10)
    if(not love.mouse.isVisible()) then
        love.graphics.setColor(1, 0, 0, 0.5)
        love.graphics.circle('fill', love.mouse.getX(), love.mouse.getY(), 4)
    end
end

function GameHomeScene:keypressed(key)
   if key == "escape" then
        --"Are you sure you want to exit?" type popup
   end
end

function GameHomeScene:mousepressed(x, y, buttonPressed)
    
end

return GameHomeScene