local StartScene = {
    r,g,b = 0,0,0
}

local buttonSpacing = 70
local button_yOffset = 400

function StartScene:load()
    -- Available window sizes
    self.windowSizes = {
        { width = 800, height = 600, label = "800x600" },
        { width = 1280, height = 800, label = "1280x800" },
        { width = 2560, height = 1600, label = "2560x1600" }
    }
    
    -- Add volume settings with default values
    self.musicVolume = 50
    self.sfxVolume = 50
    
    self.buttons = {
        { label = "New Game", action = function(args) self:NewGame(args) end },
        { label = "Load Game", action = function(args) self:LoadGame(args) end },
        { label = "Window Size", action = function() self:toggleWindowSizeSelection() end },
        { label = "Volume", action = function() self:toggleSoundSettings() end },
        { label = "Quit", action = function() love.event.quit() end }
    }
    
    self.selected = 1
    self.sizeSelected = 1 -- Default selected window size
    self.soundOptionSelected = 1 -- Default sound option (1 = Music, 2 = SFX)
    self.showWindowSizes = false -- Whether to show window size selection
    self.showSoundSettings = false -- Whether to show sound settings
    self.currentWindowSizeIndex = 2 -- Track current window size
    
    -- Find current window size in the list
    local w, h = love.window.getMode()
    for i, size in ipairs(self.windowSizes) do
        if size.width == w and size.height == h then
            self.currentWindowSizeIndex = i
            break
        end
    end
end

function StartScene:NewGame(args)
    -- Placeholder for starting a new game
    args.newScene = "NewGame"
end

function StartScene:LoadGame(args)
    -- Placeholder for loading a game
    args.newScene = "LoadGame"
end

local last = 0
local cooldownTime = 0.2
local cooldown = 0

function StartScene:toggleSoundSettings()
    self.showSoundSettings = not self.showSoundSettings
    self.showWindowSizes = false
    self.soundOptionSelected = 1 -- Default to Music volume
end

function StartScene:toggleWindowSizeSelection()
    self.showWindowSizes = not self.showWindowSizes
    self.showSoundSettings = false
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
            -- Window size selection mode - changed to up/down controls
            if love.keyboard.isDown("up") then
                cooldown = cooldownTime
                self.sizeSelected = self.sizeSelected > 1 and self.sizeSelected - 1 or #self.windowSizes
            elseif love.keyboard.isDown("down") then
                cooldown = cooldownTime
                self.sizeSelected = self.sizeSelected < #self.windowSizes and self.sizeSelected + 1 or 1
            elseif love.keyboard.isDown("return") then
                cooldown = cooldownTime
                -- Apply the selected window size
                args.scalingreset = 1 -- Reset scaling
                local size = self.windowSizes[self.sizeSelected]
                love.window.setMode(size.width, size.height, {resizable=true})
                self.currentWindowSizeIndex = self.sizeSelected
                self.showWindowSizes = false -- Hide window size selection
                args.scalingreset = 1 -- Trigger scaling recalculation in main.lua
            elseif love.keyboard.isDown("escape") then
                cooldown = cooldownTime
                self.showWindowSizes = false -- Hide window size selection without changing
            end
        elseif self.showSoundSettings then
            -- Sound settings navigation
            if love.keyboard.isDown("up") then
                cooldown = cooldownTime
                self.soundOptionSelected = self.soundOptionSelected > 1 and self.soundOptionSelected - 1 or 2
            elseif love.keyboard.isDown("down") then
                cooldown = cooldownTime
                self.soundOptionSelected = self.soundOptionSelected < 2 and self.soundOptionSelected + 1 or 1
            elseif love.keyboard.isDown("left") then
                cooldown = cooldownTime
                if self.soundOptionSelected == 1 then
                    self.musicVolume = self.musicVolume - 10
                    if self.musicVolume < 0 then self.musicVolume = 0 end
                else
                    self.sfxVolume = self.sfxVolume - 10
                    if self.sfxVolume < 0 then self.sfxVolume = 0 end
                end
            elseif love.keyboard.isDown("right") then
                cooldown = cooldownTime
                if self.soundOptionSelected == 1 then
                    self.musicVolume = self.musicVolume + 10
                    if self.musicVolume > 100 then self.musicVolume = 100 end
                else
                    self.sfxVolume = self.sfxVolume + 10
                    if self.sfxVolume > 100 then self.sfxVolume = 100 end
                end
            elseif love.keyboard.isDown("escape") then
                cooldown = cooldownTime
                self.showSoundSettings = false -- Hide sound settings without changing
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
                self.buttons[self.selected].action(args)
            end
        end
    end
end

function StartScene:draw()
    love.graphics.clear(0.2, 0.2, 0.2) -- Background color
    love.graphics.setColor(0, 0, 0) -- black for the background
    love.graphics.rectangle("fill", 0, 0, 1280, 800)
    
    -- Draw neon glow effect around the edges
    self:drawNeonEdges()

    -- Draw center pulsing circle
    self:drawNeonCircle()
    
    local font = love.graphics.newFont(45)
    love.graphics.setFont(font)
    
    if self.showWindowSizes then
        -- Draw window size selection screen
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Select Window Size", 0, 50, 1280, "center")
        
        -- Draw navigation hint
        local smallFont = love.graphics.newFont(16)
        love.graphics.setFont(smallFont)
        love.graphics.printf("Use UP/DOWN to select, ENTER to confirm, ESC to cancel", 0, 120, 1280, "center")
        
        -- Draw window size options in a vertical list
        love.graphics.setFont(font)
        for i, size in ipairs(self.windowSizes) do
            if i == self.sizeSelected then
                love.graphics.setColor(self.r, self.g, self.b) -- Highlight selected size with neon color
            else
                love.graphics.setColor(0.7, 0.7, 0.7) -- Default color
            end
            
            -- Calculate vertical position for each option
            local y = 200 + (i - 1) * 80
            love.graphics.printf(size.label, 0, y, 1280, "center")
        end
    elseif self.showSoundSettings then
        -- Draw sound settings screen
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Sound Settings", 0, 50, 1280, "center")
        
        -- Draw navigation hint
        local smallFont = love.graphics.newFont(16)
        love.graphics.setFont(smallFont)
        love.graphics.printf("Use UP/DOWN to select, ENTER to adjust, ESC to cancel", 0, 120, 1280, "center")
        
        -- Draw sound options in a vertical list
        love.graphics.setFont(font)
        local soundOptions = { "Music Volume: " .. self.musicVolume, "SFX Volume: " .. self.sfxVolume }
        for i, option in ipairs(soundOptions) do
            if i == self.soundOptionSelected then
                love.graphics.setColor(self.r, self.g, self.b) -- Highlight selected option with neon color
            else
                love.graphics.setColor(0.7, 0.7, 0.7) -- Default color
            end
            
            -- Calculate vertical position for each option
            local y = 200 + (i - 1) * 80
            love.graphics.printf(option, 0, y, 1280, "center")
        end
    else
        -- Draw main menu
        for i, button in ipairs(self.buttons) do
            if i == self.selected then
                love.graphics.setColor(self.r, self.g, self.b) -- Highlight selected button
            else
                love.graphics.setColor(1, 1, 1) -- Default button color
            end
            
            -- Show current window size next to the Window Size button
            local buttonText = button.label
            if i == 3 then -- Window Size button
                buttonText = button.label .. " (" .. self.windowSizes[self.currentWindowSizeIndex].label .. ")"
            end
            
            love.graphics.printf(buttonText, 0, button_yOffset + (i - 1) * buttonSpacing, 1280, "center")
        end
    end
end

-- Add this new method to draw a pulsing neon circle in the center
function StartScene:drawNeonCircle()
    local centerX, centerY = 640, 250 -- Center of the screen (top area)
    local time = love.timer.getTime()
    
    -- Base radius with breathing effect
    local baseRadius = 120
    local breathSpeed = 0.8
    local breathAmount = 10
    local radius = baseRadius + math.sin(time * breathSpeed) * breathAmount
    
    -- Pulse for glow intensity (similar to edge effect)
    local pulse = (math.sin(time * 1.5) + 1) * 0.3 + 0.4
    
    -- Draw multiple circles with decreasing alpha for glow effect
    for i = 30, 0, -1 do
        local alpha = (i / 30) * pulse
        local extraRadius = (30 - i) * 1.2
        
        love.graphics.setColor(self.r, self.g, self.b, alpha)
        love.graphics.circle("fill", centerX, centerY, radius + extraRadius)
    end
    
    -- Draw solid inner circle
    love.graphics.setColor(0, 0, 0) -- Black center
    love.graphics.circle("fill", centerX, centerY, radius - 10)
    
    -- Draw thin circle outline
    love.graphics.setColor(self.r, self.g, self.b, 1)
    love.graphics.circle("line", centerX, centerY, radius)
    love.graphics.circle("line", centerX, centerY, radius - 5)
    
    -- Optional: Add some "rays" for extra effect
    local rayCount = 8
    local rayLength = 40
    local rayWidth = 3
    
    for i = 1, rayCount do
        local angle = (i / rayCount) * math.pi * 2 + time * 0.5 -- Rotate rays slowly
        local rayX1 = centerX + math.cos(angle) * (radius + 5)
        local rayY1 = centerY + math.sin(angle) * (radius + 5)
        local rayX2 = centerX + math.cos(angle) * (radius + rayLength)
        local rayY2 = centerY + math.sin(angle) * (radius + rayLength)
        
        -- Draw with decreasing alpha
        for j = rayWidth, 1, -1 do
            local alpha = (j / rayWidth) * pulse
            love.graphics.setColor(self.r, self.g, self.b, alpha)
            love.graphics.setLineWidth(j)
            love.graphics.line(rayX1, rayY1, rayX2, rayY2)
        end
    end
    
    -- Reset line width for other drawing operations
    love.graphics.setLineWidth(1)
end

-- Add this new method to draw the neon glow edges
function StartScene:drawNeonEdges()
    -- Get window dimensions
    local width = 1280
    local height = 800
    local borderWidth = 5
    local glowSize = 20
    
    -- Time-based color pulsing and transitioning effect
    local time = love.timer.getTime()
    local pulse = (math.sin(time * 1.5) + 1) * 0.3 + 0.4 -- Value between 0.4 and 1.0
    
    -- Cycle through colors over time (slow transition)
    local colorSpeed = 0.2 -- Controls how fast colors change
    self.r = math.sin(time * colorSpeed) * 0.5 + 0.5
    self.g = math.sin(time * colorSpeed + 2.1) * 0.5 + 0.5
    self.b = math.sin(time * colorSpeed + 4.2) * 0.5 + 0.5
    
    -- Top edge glow
    for i = 0, glowSize, 1 do
        local alpha = 1 - (i / glowSize)
        love.graphics.setColor(self.r, self.g, self.b, pulse * alpha)
        love.graphics.rectangle("fill", 0, i, width, 1)
    end
    
    -- Bottom edge glow
    for i = 0, glowSize, 1 do
        local alpha = 1 - (i / glowSize)
        love.graphics.setColor(self.r, self.g, self.b, pulse * alpha)
        love.graphics.rectangle("fill", 0, height - i, width, 1)
    end
    
    -- Left edge glow
    for i = 0, glowSize, 1 do
        local alpha = 1 - (i / glowSize)
        love.graphics.setColor(self.r, self.g, self.b, pulse * alpha)
        love.graphics.rectangle("fill", i, 0, 1, height)
    end
    
    -- Right edge glow
    for i = 0, glowSize, 1 do
        local alpha = 1 - (i / glowSize)
        love.graphics.setColor(self.r, self.g, self.b, pulse * alpha)
        love.graphics.rectangle("fill", width - i, 0, 1, height)
    end
    
    -- Draw solid borders for contrast
    love.graphics.setColor(self.r, self.g, self.b, 1) -- Solid color at full intensity
    
    -- Top border
    love.graphics.rectangle("fill", 0, 0, width, borderWidth)
    
    -- Bottom border
    love.graphics.rectangle("fill", 0, height - borderWidth, width, borderWidth)
    
    -- Left border
    love.graphics.rectangle("fill", 0, 0, borderWidth, height)
    
    -- Right border
    love.graphics.rectangle("fill", width - borderWidth, 0, borderWidth, height)
end

return StartScene