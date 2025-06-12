local button = require 'Scripts/button'

local GLOBAL = 0
local ARMOURY = 1
local MAP = 2
local WORKSHOP = 3

local GameHomeScene = {
    state = MAP
}

function GameHomeScene:load(sceneData)
    if(sceneData) then
        self.sceneData = sceneData
        self.newGame = 0
    else
        self.newGame = 1 -- cutscene?
    end
    self.buttons = {
        button:new(50, 50, 200, 50, GLOBAL, function() state = ARMOURY end),
        button:new(450, 50, 200, 50, GLOBAL, function() state = MAP end),
        button:new(850, 50, 200, 50, GLOBAL, function() state = WORKSHOP end)
    }

end

function GameHomeScene:update(dt, args)
    self.debug = args.debug or false

    button.checkhoverlist(self.buttons, self.state, love.mouse.getPosition())

    if self.state == ARMOURY then
        
    else if self.state == MAP then

    else if self.state == WORKSHOP then

    end
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