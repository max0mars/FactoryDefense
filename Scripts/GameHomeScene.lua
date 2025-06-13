local button = require 'Scripts/button'

local GLOBAL = 0
local ARMOURY = 1
local MAP = 2
local WORKSHOP = 3

local GameHomeScene = {
    screen = MAP
}

function GameHomeScene:load(sceneData)
    if(sceneData) then
        self.sceneData = sceneData
        self.newGame = 0
    else
        self.newGame = 1 -- cutscene?
    end
    self.buttons = {
        button:new(50, 0, 200, 50, GLOBAL, function() self.screen = ARMOURY end),
        button:new(450, 0, 200, 50, GLOBAL, function() self.screen = MAP end),
        button:new(850, 0, 200, 50, GLOBAL, function() self.screen = WORKSHOP end),

        button:new(0, 300, 200, 50, ARMOURY, function() return end),
        button:new(0, 400, 200, 50, ARMOURY, function() return end),
        button:new(0, 500, 200, 50, ARMOURY, function() return end),
        button:new(0, 600, 200, 50, ARMOURY, function() return end),

        button:new(300, 400, 200, 200, MAP, function() return end),
        button:new(633, 200, 200, 200, MAP, function() return end),
        button:new(800, 600, 200, 200, MAP, function() return end),

        button:new(0, 300, 200, 50, WORKSHOP, function() return end),
        button:new(0, 400, 200, 50, WORKSHOP, function() return end),
        button:new(0, 500, 200, 50, WORKSHOP, function() return end),
        button:new(0, 600, 200, 50, WORKSHOP, function() return end)
    }

end

function GameHomeScene:update(dt, args)
    self.debug = args.debug or false

    button.checkhoverlist(self.buttons, self.screen, love.mouse.getPosition())

    -- if self.state == ARMOURY then
        
    -- elseif self.state == MAP then

    -- elseif self.state == WORKSHOP then

    -- end
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
    button.drawButtons(self.buttons, self.screen)
    if(self.debug) then
        love.graphics.setColor(1, 0, 0)
        love.graphics.print('Mouse = (' .. love.mouse.getX() .. ', ' .. love.mouse.getY() .. ')', 0, 0)
        love.graphics.print('screen = ' .. self.screen, 0, 20)
        love.graphics.line(640, 0, 640, 800)
        love.graphics.line(0, 400, 1280, 400)
        button.debug(self.buttons, self.screen)
    end
end

function GameHomeScene:keypressed(key)
    if key == "escape" then
        --"Are you sure you want to exit?" type popup
    end
end

function GameHomeScene:mousepressed(x, y, buttonPressed)
    button.clickbuttons(self.buttons, self.state, x, y)
end

function GameHomeScene:keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "tab" then
        self.screen = self.screen + 1
        if self.screen > 3 then self.screen = 1 end
    end
end

return GameHomeScene