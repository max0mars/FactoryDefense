local StartScene = {
}

function StartScene:load()
    -- Available window sizes
    self.windowSizes = {
        { width = 800, height = 600, label = "800x600" },
        { width = 1280, height = 800, label = "1280x800" },
        { width = 1920, height = 1080, label = "1920x1080" }
    }
    
    self.buttons = {
        { label = "Start", action = function() print("Start Game") end },
        { label = "Window Size", action = function() self:toggleWindowSizeSelection() end },
        { label = "Quit", action = function() love.event.quit() end }
    }
    
    self.selected = 1
    self.sizeSelected = 1 -- Default selected window size
    self.showWindowSizes = false -- Whether to show window size selection
    self.currentWindowSizeIndex = 1 -- Track current window size
    
    -- Find current window size in the list
    local w, h = love.window.getMode()
    for i, size in ipairs(self.windowSizes) do
        if size.width == w and size.height == h then
            self.currentWindowSizeIndex = i
            break
        end
    end
end

local last = 0
local cooldownTime = 0.2
local cooldown = 0

function StartScene:toggleWindowSizeSelection()
    self.showWindowSizes = not self.showWindowSizes
    if self.showWindowSizes then
        self.sizeSelected = self.currentWindowSizeIndex
    end
end

function StartScene:update(dt, args)
    -- Update cooldown
    if cooldown > 0 then
        cooldown = cooldown - dt
    end
    
    -- Handle input for navigating the menu
    if cooldown <= 0 then
        if self.showWindowSizes then
            -- Window size selection mode
            if love.keyboard.isDown("left") then
                cooldown = cooldownTime
                self.sizeSelected = self.sizeSelected > 1 and self.sizeSelected - 1 or #self.windowSizes
            elseif love.keyboard.isDown("right") then
                cooldown = cooldownTime
                self.sizeSelected = self.sizeSelected < #self.windowSizes and self.sizeSelected + 1 or 1
            elseif love.keyboard.isDown("return") then
                cooldown = cooldownTime
                -- Apply the selected window size
                local size = self.windowSizes[self.sizeSelected]
                love.window.setMode(size.width, size.height)
                self.currentWindowSizeIndex = self.sizeSelected
                self.showWindowSizes = false -- Hide window size selection
                args.scalingreset = 1 -- Trigger scaling recalculation in main.lua
            elseif love.keyboard.isDown("escape") then
                cooldown = cooldownTime
                self.showWindowSizes = false -- Hide window size selection without changing
            end
        else
            -- Main menu navigation
            if love.keyboard.isDown("up") then
                cooldown = cooldownTime
                self.selected = self.selected > 1 and self.selected - 1 or #self.buttons
            elseif love.keyboard.isDown("down") then
                cooldown = cooldownTime
                self.selected = self.selected < #self.buttons and self.selected + 1 or 1
            elseif love.keyboard.isDown("return") then
                cooldown = cooldownTime
                self.buttons[self.selected].action()
            end
        end
    end
end

function StartScene:draw()
    love.graphics.clear(0, 0, 0) -- Background color
    love.graphics.setColor(0.2, 0.2, 0.2) -- Dark gray for the background
    love.graphics.rectangle("fill", 0, 0, 800, 600)
    local font = love.graphics.newFont(32)
    love.graphics.setFont(font)
    
    if self.showWindowSizes then
        -- Draw window size selection screen
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Select Window Size", 0, 50, 800, "center")
        
        -- Draw navigation hint
        local smallFont = love.graphics.newFont(16)
        love.graphics.setFont(smallFont)
        love.graphics.printf("Use LEFT/RIGHT to select, ENTER to confirm, ESC to cancel", 0, 100, 800, "center")
        
        -- Draw window size options
        love.graphics.setFont(font)
        for i, size in ipairs(self.windowSizes) do
            if i == self.sizeSelected then
                love.graphics.setColor(1, 1, 0) -- Highlight selected size
            else
                love.graphics.setColor(0.7, 0.7, 0.7) -- Default color
            end
            
            local x = (800 / (#self.windowSizes + 1)) * i
            love.graphics.printf(size.label, x - 100, 200, 200, "center")
        end
    else
        -- Draw main menu
        for i, button in ipairs(self.buttons) do
            if i == self.selected then
                love.graphics.setColor(1, 1, 0) -- Highlight selected button
            else
                love.graphics.setColor(1, 1, 1) -- Default button color
            end
            
            -- Show current window size next to the Window Size button
            local buttonText = button.label
            if i == 2 then -- Window Size button
                buttonText = button.label .. " (" .. self.windowSizes[self.currentWindowSizeIndex].label .. ")"
            end
            
            love.graphics.printf(buttonText, 0, 100 + (i - 1) * 60, 800, "center")
        end
    end
end

return StartScene