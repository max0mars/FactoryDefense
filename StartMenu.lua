local StartMenu = {
    currentMenu = StartMenu
}

OptionsMenu = require("OptionsMenu")

function StartMenu:load()
    self.buttons = {
        { label = "Start", action = function() print("Start Game") end },
        { label = "Options", action = function() self:openOptions() end },
        { label = "Quit", action = function() love.event.quit() end }
    }
    self.selected = 1
    OptionsMenu:load()
end

function StartMenu:openOptions()
    self.currentMenu = OptionsMenu
end

local last = 0;
function StartMenu:update(dt)
    -- Handle input for navigating the menu
    print("Last:" .. last)
    if love.keyboard.isDown("up") then
        if last == 0 then
            last = 1
            cooldown = cooldownTime
            self.selected = self.selected > 1 and self.selected - 1 or #self.buttons
        end
    elseif love.keyboard.isDown("down") then
        if last == 0 then
            last = 1
            cooldown = cooldownTime
            self.selected = self.selected < #self.buttons and self.selected + 1 or 1
        end
    elseif love.keyboard.isDown("return") then
        if last == 0 then
            last = 1
            cooldown = cooldownTime
            self.buttons[self.selected].action()
        end
    else
        last = 0;
    end
end

function StartMenu:draw()
    love.graphics.clear(0.1, 0.1, 0.1) -- Background color
    local font = love.graphics.newFont(32)
    love.graphics.setFont(font)
    for i, button in ipairs(self.buttons) do
        if i == self.selected then
            love.graphics.setColor(1, 1, 0) -- Highlight selected button
        else
            love.graphics.setColor(1, 1, 1) -- Default button color
        end
        love.graphics.printf(button.label, 0, 100 + (i - 1) * 40, love.graphics.getWidth(), "center")
    end
end

return StartMenu