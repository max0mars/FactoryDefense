local GameScene = {
    activeTab = 1 -- Default to first tab (Workshop)
}

function GameScene:load(gameData)
    -- Initialize data for the three tabs/screens
    self.tabs = {
        {name = "Workshop"},
        {name = "Shop"},
        {name = "Map"}
    }
    
    -- Current selections
    self.hoveredItem = nil
    self.selected = nil
    
    -- For scrolling content
    self.scroll = {0, 0, 0} -- Scroll position for each tab
    
    -- Load font for UI
    self.font = love.graphics.newFont(16)
    self.titleFont = love.graphics.newFont(24)
    self.smallFont = love.graphics.newFont(12)
    
    -- Button definitions
    self.buttons = {}
end

function GameScene:update(dt, args)
    -- Clear buttons for each frame
    self.buttons = {}
    
    -- Update hover state
    self.hoveredItem = nil
    
    -- Get mouse position
    local mx, my = love.mouse.getPosition()
    
    -- Check tab buttons
    local tabWidth = love.graphics.getWidth() / #self.tabs
    for i, tab in ipairs(self.tabs) do
        if mx >= (i-1) * tabWidth and mx <= i * tabWidth and my >= 40 and my <= 80 then
            if love.mouse.isDown(1) then
                self.activeTab = i
            end
        end
    end
end

function GameScene:mousePressed(x, y, button)
    if button == 1 then -- Left click
        -- Check buttons
        for _, btn in ipairs(self.buttons) do
            if x >= btn.x and x <= btn.x + btn.width and y >= btn.y and y <= btn.y + btn.height then
                btn.action()
                return
            end
        end
    end
end

function GameScene:draw()
    local time = love.timer.getTime()
    local pulse = (math.sin(time * 1.5) + 1) * 0.3 + 0.4 -- Value between 0.4 and 1.0
    
    -- Cycle through colors over time (slow transition)
    local colorSpeed = 0.2 -- Controls how fast colors change
    self.r = math.sin(time * colorSpeed) * 0.5 + 0.5
    self.g = math.sin(time * colorSpeed + 2.1) * 0.5 + 0.5
    self.b = math.sin(time * colorSpeed + 4.2) * 0.5 + 0.5
    -- Draw header with tabs
    neonColor = {r = self.r, g = self.g, b = self.b}
    self:drawTabs(neonColor)
    
    -- Draw content based on active tab
    if self.activeTab == 1 then
        self:drawWorkshopTab()
    elseif self.activeTab == 2 then
        self:drawShopTab()
    elseif self.activeTab == 3 then
        self:drawMapTab()
    end
end

function GameScene:drawTabs(neonColor)
    local tabWidth = love.graphics.getWidth() / #self.tabs
    love.graphics.setFont(self.titleFont)
    
    for i, tab in ipairs(self.tabs) do
        -- Draw tab background
        if i == self.activeTab then
            love.graphics.setColor(neonColor.r, neonColor.g, neonColor.b)
        else
            love.graphics.setColor(0, 0, 0)
        end
        love.graphics.rectangle("fill", (i-1) * tabWidth, 0, tabWidth, 40)
        
        -- Draw tab border
        love.graphics.setColor(0.4, 0.4, 0.5)
        love.graphics.rectangle("line", (i-1) * tabWidth, 0, tabWidth, 40)
        
        -- Draw tab text
        if i == self.activeTab then
            love.graphics.setColor(1, 1, 1)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.printf(tab.name, (i-1) * tabWidth, 0, tabWidth, "center")
    end
    
    -- Draw content area background
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 80, love.graphics.getWidth(), love.graphics.getHeight() - 120)
    love.graphics.setColor(0.3, 0.3, 0.4)
    love.graphics.rectangle("line", 0, 80, love.graphics.getWidth(), love.graphics.getHeight() - 120)
end

function GameScene:drawWorkshopTab()
    love.graphics.setFont(self.titleFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Mining Equipment", 0, 90, love.graphics.getWidth(), "center")
end

function GameScene:drawShopTab()
    love.graphics.setFont(self.titleFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Equipment Shop", 0, 90, love.graphics.getWidth(), "center")
end

function GameScene:drawMapTab()
    love.graphics.setFont(self.titleFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Planet Selection", 0, 90, love.graphics.getWidth(), "center")
end

return GameScene