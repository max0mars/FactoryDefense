local OptionsMenu = {}

function OptionsMenu:load()
    self.buttons = {
        { label = "800x600", action = function() love.window.setMode(800, 600) end },
        { label = "1024x768", action = function() love.window.setMode(1024, 768) end },
        { label = "Fullscreen", action = function() love.window.setFullscreen(true) end },
        { label = "Back", action = function() self:goBack() end }
    }
    self.selected = 1
end

function OptionsMenu:goBack()
    require("StartMenu"):load()
    love.currentMenu = "start"
end

function OptionsMenu:update(dt)
    if love.keyboard.isDown("up") then
        self.selected = self.selected > 1 and self.selected - 1 or #self.buttons
    elseif love.keyboard.isDown("down") then
        self.selected = self.selected < #self.buttons and self.selected + 1 or 1
    elseif love.keyboard.isDown("return") then
        self.buttons[self.selected].action()
    end
end

function OptionsMenu:draw()
    love.graphics.clear(0.1, 0.1, 0.1)
    local font = love.graphics.newFont(32)
    love.graphics.setFont(font)
    for i, button in ipairs(self.buttons) do
        if i == self.selected then
            love.graphics.setColor(1, 1, 0)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.printf(button.label, 0, 100 + (i - 1) * 50, love.graphics.getWidth(), "center")
    end
end

return OptionsMenu