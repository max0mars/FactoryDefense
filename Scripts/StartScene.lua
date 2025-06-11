local button = require 'Scripts/button'

local StartScene = {
    state,
    timer,
    logo,
    title,
    start = 0,
    load = 0
}
local LOGO = 0
local TITLE = 1
local OPTIONS = 2
local debug = false

local dragging = 0
local drag_start = {x = 0, y = 0}
local drag_end = {x = 0, y = 0}
function StartScene:load(width, height)
    love.mouse.setVisible(false)
    self.width = width
    self.height = height
    self.logo = {}
    self.logo.fadein = 1
    self.logo.hold = 0
    self.logo.fadeout = 1
    self.logo.state = 0
    self.logo.fadeAmount = 0
    self.logo.img = love.graphics.newImage('Images/Logo.JPEG')



    self.title = {}
    self.title.fadein = 2
    self.title.fadeAmount = 0
    self.title.state = 0
    self.title.img = love.graphics.newImage('Images/Title.JPEG')
    self.state = 0
    self.timer = self.logo.fadein
    self.title.buttons = {}
    table.insert(self.title.buttons, button:new(504, 536, 250, 50, function()
        self.start = 1
    end))
    table.insert(self.title.buttons, button:new(495, 593, 267, 50, function()
        self.load = 1
    end))
    table.insert(self.title.buttons, button:new(555, 673, 150, 33, function()
        print('Options clicked')
        self.state = OPTIONS
    end))
    table.insert(self.title.buttons, button:new(586, 709, 80, 25, function()
        love.event.quit()
    end))
end

function StartScene:update(dt, args)
    if(self.start == 1) then
        self.start = 0
        args.newScene = 'newgame'
    elseif(self.load == 1) then
        self.start = 0
        args.newScene = 'loadgame'
    end
    if(dragging == 1) then
        drag_end.x = love.mouse.getX()
        drag_end.y = love.mouse.getY()
    end
    if(self.state == LOGO) then
        self.timer = self.timer - dt
        if(self.logo.state == 0) then
            self.logo.fadeAmount = 1 - self.timer/self.logo.fadein
            if(self.timer <= 0) then
                self.logo.state = 1
                self.timer = self.logo.hold
            end
        elseif(self.logo.state == 1) then -- logo hold
            if(self.timer <= 0) then
                self.logo.state = 2
                self.timer = self.logo.fadeout
            end
        elseif(self.logo.state == 2) then -- logo fadeout
            self.logo.fadeAmount = self.timer/self.logo.fadeout
            if(self.timer <= 0) then
                self.state = TITLE
                self.timer = self.title.fadein
            end
        end
    elseif(self.state == TITLE) then
        self.timer = self.timer - dt
        if(self.title.state == 0) then
            self.title.fadeAmount = 1 - self.timer/self.title.fadein
            if(self.timer <= 0) then
                self.title.state = 1
            end
        elseif(self.title.state == 1) then -- logo hold
            local mx, my = love.mouse.getPosition()
            for _, button in pairs(self.title.buttons) do
                button:checkhover(mx, my)
            end
        end
    end
end

function StartScene:draw()
    if(self.state == LOGO) then
        love.graphics.setColor(255, 255, 255, self.logo.fadeAmount)
        love.graphics.draw(self.logo.img, 300, 80)
    elseif (self.state == TITLE) then
        love.graphics.setColor(255, 255, 255, self.title.fadeAmount)
        love.graphics.draw(self.title.img, 200, 0)
        for _, button in pairs(self.title.buttons) do
            if(button.hovered) then
                love.graphics.setColor(1, 1, 1)
                love.graphics.rectangle('line', button.x, button.y, button.width, button.height)
            end
        end
    elseif (self.state == OPTIONS) then
        -- love.graphics.setColor(255, 255, 255, self.title.fadeAmount)
        -- love.graphics.draw(self.options.img, 200, 0)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print('Options not implemented yet', 200, 0)
    else

    end
    if(not love.mouse.isVisible()) then
        love.graphics.setColor(1, 0, 0, 0.5)
        love.graphics.circle('fill', love.mouse.getX(), love.mouse.getY(), 4)
    end
    if(debug) then
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle('line', drag_start.x, drag_start.y, drag_end.x - drag_start.x, drag_end.y - drag_start.y)
        love.graphics.setColor(1, 0, 0)
        love.graphics.print('Mouse = (' .. love.mouse.getX() .. ', ' .. love.mouse.getY() .. ')', 0, 0)
        love.graphics.print('pos = (' .. math.min(drag_start.x, drag_end.x) .. ', ' .. math.min(drag_start.y, drag_end.y) .. ')', 0, 20)
        love.graphics.print('size = (' .. math.abs(drag_end.x - drag_start.x) .. ', ' .. math.abs(drag_end.y - drag_start.y) .. ')', 0, 40)
        love.graphics.print('dragging = ' .. dragging, 0, 60)
        love.graphics.print('state = ' .. self.state, 0, 80)
    end
end

function StartScene:keypressed(key)
   if key == "tab" then
        debug = not debug
   end
   if key == "escape" then
        self.state = TITLE
   end
end

function StartScene:mousepressed(x, y, buttonPressed)
    if (dragging == 0 and buttonPressed == 1 and debug) then
        dragging = 1
        drag_start.x = x
        drag_start.y = y
        drag_end.x = x
        drag_end.y = y
    else
        dragging = 0
    end
    if(self.state == TITLE) then
        for _, button in pairs(self.title.buttons) do
            button:checkClick()
        end
    end
end

function StartScene:newGame()
    local newScene = require 'Scripts/PlayScene'
    args.newScene = newScene
    args.sceneData = sceneData
    return true
end

return StartScene