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
    love.graphics.setColor(255, 255, 255, 1)
    love.graphics.print("Game Home Scene", 100, 100)
end

function StartScene:keypressed(key)
   if key == "escape" then
        --"Are you sure you want to exit?" type popup
   end
end

function StartScene:mousepressed(x, y, buttonPressed)
    
end

return GameHomeScene