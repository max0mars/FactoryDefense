local GameScene = {
    activeTab = 1 -- Default to first tab (Workshop)
}

function GameScene:load(gameData)
    -- Initialize data for the three tabs/screens
    self.tabs = {
        { name = "Workshop", icon = "🔧" },
        { name = "Shop", icon = "🛒" },
        { name = "Map", icon = "🌎" }
    }
    
    -- Initialize game resources and state
    self.resources = {
        metal = gameData and gameData.metal or 100,
        energy = gameData and gameData.energy or 50,
        credits = gameData and gameData.credits or 200
    }
    
    -- Player's current equipment
    self.equipment = {
        drill = { name = "Basic Drill", power = 5, efficiency = 1 },
        shield = { name = "Standard Shield", defense = 10 },
        engine = { name = "Basic Engine", speed = 3 }
    }
    
    -- Available items in the shop
    self.shopItems = {
        { name = "Advanced Drill", type = "drill", cost = 150, power = 10, efficiency = 1.5, 
          description = "Mines resources 50% faster than the basic model" },
        { name = "Energy Drill", type = "drill", cost = 300, power = 15, efficiency = 2, 
          description = "High-powered drill with excellent efficiency" },
        { name = "Reinforced Shield", type = "shield", cost = 120, defense = 20, 
          description = "Provides better protection against environmental hazards" },
        { name = "Energy Shield", type = "shield", cost = 280, defense = 35, 
          description = "Advanced shield with superior defensive capabilities" },
        { name = "Improved Engine", type = "engine", cost = 100, speed = 5, 
          description = "Travel between mining sites more quickly" },
        { name = "Quantum Engine", type = "engine", cost = 250, speed = 8, 
          description = "State-of-the-art propulsion for rapid planet traversal" }
    }
    
    -- Available planets to mine
    self.planets = {
        { name = "Iron Planet", type = "metal", difficulty = 1, 
          rewards = { metal = 50, energy = 10 }, 
          image = "iron_planet.png",
          description = "Rich in metal deposits, low environmental hazards" },
        { name = "Energy Core", type = "energy", difficulty = 2, 
          rewards = { metal = 20, energy = 60 }, 
          image = "energy_planet.png",
          description = "Abundant energy sources, moderate environmental hazards" },
        { name = "Crystal Moon", type = "mixed", difficulty = 3, 
          rewards = { metal = 40, energy = 40, crystals = 5 }, 
          image = "crystal_moon.png",
          description = "Rare crystal deposits and balanced resources, higher hazards" }
    }
    
    -- Current selections
    self.hoveredItem = nil
    self.selectedEquipment = nil
    self.selectedShopItem = nil
    self.selectedPlanet = nil
    
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
    -- Update game logic (resource production, etc.)
    self:updateGameLogic(dt)
    
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
    
    -- Check content-specific buttons based on active tab
    if self.activeTab == 1 then
        self:updateWorkshopTab(mx, my)
    elseif self.activeTab == 2 then
        self:updateShopTab(mx, my)
    elseif self.activeTab == 3 then
        self:updateMapTab(mx, my)
    end
    
    -- Check for back button
    if mx >= 20 and mx <= 120 and my >= love.graphics.getHeight() - 40 and my <= love.graphics.getHeight() - 10 then
        if love.mouse.isDown(1) then
            args.newScene = "MainMenu"
            args.sceneData = {
                metal = self.resources.metal,
                energy = self.resources.energy,
                credits = self.resources.credits,
                equipment = self.equipment
            }
        end
    end
end

function GameScene:updateWorkshopTab(mx, my)
    -- Check equipment slots
    local y = 140
    local equipmentTypes = {"drill", "shield", "engine"}
    
    for i, eqType in ipairs(equipmentTypes) do
        -- Equipment title area
        if mx >= 20 and mx <= love.graphics.getWidth() - 20 and 
           my >= y and my <= y + 50 then
            self.hoveredItem = {type = "equipment", equipType = eqType}
            
            if love.mouse.isDown(1) then
                self.selectedEquipment = eqType
            end
        end
        y = y + 120 -- Move to next equipment slot
    end
end

function GameScene:updateShopTab(mx, my)
    local y = 140 - self.scroll[2]
    
    for i, item in ipairs(self.shopItems) do
        -- Shop item area
        if mx >= 20 and mx <= love.graphics.getWidth() - 20 and 
           my >= y and my <= y + 80 then
            self.hoveredItem = {type = "shop", index = i}
            
            if love.mouse.isDown(1) then
                self.selectedShopItem = i
            end
        end
        
        -- Buy button
        if mx >= love.graphics.getWidth() - 120 and mx <= love.graphics.getWidth() - 30 and 
           my >= y + 20 and my <= y + 50 and self.resources.credits >= item.cost then
            table.insert(self.buttons, {
                x = love.graphics.getWidth() - 120, y = y + 20, 
                width = 90, height = 30, text = "Buy", 
                action = function() self:buyItem(i) end
            })
            
            if love.mouse.isDown(1) then
                self:buyItem(i)
            end
        end
        
        y = y + 100 -- Move to next shop item
    end
    
    -- Handle scrolling
    if #self.shopItems * 100 > love.graphics.getHeight() - 140 then
        if love.mouse.isDown(1) then
            -- Scroll bar
            local scrollBarHeight = love.graphics.getHeight() - 140
            local contentHeight = #self.shopItems * 100
            local scrollBarY = 140 + (self.scroll[2] / contentHeight) * scrollBarHeight
            local scrollBarSize = (scrollBarHeight / contentHeight) * scrollBarHeight
            
            if mx >= love.graphics.getWidth() - 15 and mx <= love.graphics.getWidth() - 5 and
               my >= scrollBarY and my <= scrollBarY + scrollBarSize then
                -- Drag scrollbar
            elseif mx >= love.graphics.getWidth() - 15 and mx <= love.graphics.getWidth() - 5 and
                   my >= 140 and my <= love.graphics.getHeight() - 40 then
                -- Click on scrollbar track
                local clickPos = (my - 140) / scrollBarHeight
                self.scroll[2] = clickPos * contentHeight
            end
        end
    end
end

function GameScene:updateMapTab(mx, my)
    local y = 140 - self.scroll[3]
    
    for i, planet in ipairs(self.planets) do
        -- Planet selection area
        if mx >= 20 and mx <= love.graphics.getWidth() - 20 and 
           my >= y and my <= y + 150 then
            self.hoveredItem = {type = "planet", index = i}
            
            if love.mouse.isDown(1) then
                self.selectedPlanet = i
            end
        end
        
        -- Launch mission button
        if mx >= love.graphics.getWidth() - 200 and mx <= love.graphics.getWidth() - 30 and 
           my >= y + 100 and my <= y + 130 and self.selectedPlanet == i then
            table.insert(self.buttons, {
                x = love.graphics.getWidth() - 200, y = y + 100, 
                width = 170, height = 30, text = "Launch Mining Mission", 
                action = function() self:launchMission(i) end
            })
            
            if love.mouse.isDown(1) then
                self:launchMission(i)
            end
        end
        
        y = y + 180 -- Move to next planet
    end
end

function GameScene:updateGameLogic(dt)
    -- Add any game logic updates here
    -- This could include things like passive resource generation
end

function GameScene:buyItem(index)
    local item = self.shopItems[index]
    if self.resources.credits >= item.cost then
        self.resources.credits = self.resources.credits - item.cost
        self.equipment[item.type] = {
            name = item.name,
            power = item.power,
            defense = item.defense,
            speed = item.speed,
            efficiency = item.efficiency
        }
    end
end

function GameScene:launchMission(index)
    local planet = self.planets[index]
    
    -- Calculate mining success based on equipment and planet difficulty
    local miningPower = self.equipment.drill.power * self.equipment.drill.efficiency
    local survivalChance = self.equipment.shield.defense / (planet.difficulty * 10)
    
    -- Apply rewards
    self.resources.metal = self.resources.metal + planet.rewards.metal * miningPower
    self.resources.energy = self.resources.energy + planet.rewards.energy
    self.resources.credits = self.resources.credits + (planet.rewards.metal + planet.rewards.energy)
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

function GameScene:mouseWheel(x, y)
    if self.activeTab == 2 then -- Shop tab
        self.scroll[2] = math.max(0, self.scroll[2] - y * 30)
        local maxScroll = #self.shopItems * 100 - (love.graphics.getHeight() - 180)
        if maxScroll > 0 then
            self.scroll[2] = math.min(self.scroll[2], maxScroll)
        else
            self.scroll[2] = 0
        end
    elseif self.activeTab == 3 then -- Map tab
        self.scroll[3] = math.max(0, self.scroll[3] - y * 30)
        local maxScroll = #self.planets * 180 - (love.graphics.getHeight() - 180)
        if maxScroll > 0 then
            self.scroll[3] = math.min(self.scroll[3], maxScroll)
        else
            self.scroll[3] = 0
        end
    end
end

function GameScene:draw()
    -- Draw background
    love.graphics.setBackgroundColor(0.1, 0.1, 0.15)
    
    -- Draw header with tabs
    self:drawTabs()
    
    -- Draw content based on active tab
    if self.activeTab == 1 then
        self:drawWorkshopTab()
    elseif self.activeTab == 2 then
        self:drawShopTab()
    elseif self.activeTab == 3 then
        self:drawMapTab()
    end
    
    -- Draw resources bar at the top
    self:drawResourcesBar()
    
    -- Draw back button
    love.graphics.setColor(0.3, 0.3, 0.4)
    love.graphics.rectangle("fill", 20, love.graphics.getHeight() - 40, 100, 30)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 20, love.graphics.getHeight() - 40, 100, 30)
    love.graphics.print("Back", 55, love.graphics.getHeight() - 35)
    
    -- Draw buttons
    self:drawButtons()
    
    -- Draw mouse cursor (optional)
    -- love.graphics.circle("fill", love.mouse.getX(), love.mouse.getY(), 5)
end

function GameScene:drawTabs()
    local tabWidth = love.graphics.getWidth() / #self.tabs
    love.graphics.setFont(self.titleFont)
    
    for i, tab in ipairs(self.tabs) do
        -- Draw tab background
        if i == self.activeTab then
            love.graphics.setColor(0.3, 0.3, 0.4)
        else
            love.graphics.setColor(0.2, 0.2, 0.25)
        end
        love.graphics.rectangle("fill", (i-1) * tabWidth, 40, tabWidth, 40)
        
        -- Draw tab border
        love.graphics.setColor(0.4, 0.4, 0.5)
        love.graphics.rectangle("line", (i-1) * tabWidth, 40, tabWidth, 40)
        
        -- Draw tab text
        if i == self.activeTab then
            love.graphics.setColor(1, 1, 1)
        else
            love.graphics.setColor(0.7, 0.7, 0.7)
        end
        love.graphics.printf(tab.icon .. " " .. tab.name, (i-1) * tabWidth, 48, tabWidth, "center")
    end
    
    -- Draw content area background
    love.graphics.setColor(0.15, 0.15, 0.2)
    love.graphics.rectangle("fill", 0, 80, love.graphics.getWidth(), love.graphics.getHeight() - 120)
    love.graphics.setColor(0.3, 0.3, 0.4)
    love.graphics.rectangle("line", 0, 80, love.graphics.getWidth(), love.graphics.getHeight() - 120)
end

function GameScene:drawResourcesBar()
    -- Draw resources background
    love.graphics.setColor(0.15, 0.15, 0.2)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), 40)
    love.graphics.setColor(0.3, 0.3, 0.4)
    love.graphics.rectangle("line", 0, 0, love.graphics.getWidth(), 40)
    
    -- Draw resource values
    love.graphics.setFont(self.font)
    
    -- Metal
    love.graphics.setColor(0.7, 0.7, 0.8)
    love.graphics.print("Metal: " .. math.floor(self.resources.metal), 20, 12)
    
    -- Energy
    love.graphics.setColor(1, 0.9, 0.2)
    love.graphics.print("Energy: " .. math.floor(self.resources.energy), love.graphics.getWidth()/3, 12)
    
    -- Credits
    love.graphics.setColor(0.3, 1, 0.3)
    love.graphics.print("Credits: " .. math.floor(self.resources.credits), 2*love.graphics.getWidth()/3, 12)
end

function GameScene:drawWorkshopTab()
    love.graphics.setFont(self.titleFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Mining Equipment", 0, 90, love.graphics.getWidth(), "center")
    
    love.graphics.setFont(self.font)
    
    local equipmentTypes = {
        {name = "Drill", current = self.equipment.drill},
        {name = "Shield", current = self.equipment.shield},
        {name = "Engine", current = self.equipment.engine}
    }
    
    local y = 140
    
    for i, eq in ipairs(equipmentTypes) do
        local isSelected = self.selectedEquipment == eq.name:lower()
        local isHovered = self.hoveredItem and self.hoveredItem.type == "equipment" and 
                         self.hoveredItem.equipType == eq.name:lower()
        
        -- Draw equipment slot background
        if isSelected then
            love.graphics.setColor(0.3, 0.3, 0.5)
        elseif isHovered then
            love.graphics.setColor(0.25, 0.25, 0.4)
        else
            love.graphics.setColor(0.2, 0.2, 0.3)
        end
        love.graphics.rectangle("fill", 20, y, love.graphics.getWidth() - 40, 100)
        love.graphics.setColor(0.4, 0.4, 0.5)
        love.graphics.rectangle("line", 20, y, love.graphics.getWidth() - 40, 100)
        
        -- Draw equipment name
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(eq.name .. ":", 30, y + 10)
        love.graphics.print(eq.current.name, 120, y + 10)
        
        -- Draw equipment stats
        love.graphics.setColor(0.7, 0.7, 0.8)
        if eq.name == "Drill" then
            love.graphics.print("Power: " .. eq.current.power, 40, y + 40)
            love.graphics.print("Efficiency: " .. eq.current.efficiency .. "x", 40, y + 70)
        elseif eq.name == "Shield" then
            love.graphics.print("Defense: " .. eq.current.defense, 40, y + 40)
        elseif eq.name == "Engine" then
            love.graphics.print("Speed: " .. eq.current.speed, 40, y + 40)
        end
        
        y = y + 120 -- Move down for next equipment slot
    end
end

function GameScene:drawShopTab()
    love.graphics.setFont(self.titleFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Equipment Shop", 0, 90, love.graphics.getWidth(), "center")
    
    -- Apply scroll offset for shop items
    love.graphics.translate(0, -self.scroll[2])
    
    local y = 140
    for i, item in ipairs(self.shopItems) do
        local isSelected = self.selectedShopItem == i
        local isHovered = self.hoveredItem and self.hoveredItem.type == "shop" and self.hoveredItem.index == i
        
        -- Draw shop item background
        if isSelected then
            love.graphics.setColor(0.3, 0.3, 0.5)
        elseif isHovered then
            love.graphics.setColor(0.25, 0.25, 0.4)
        else
            love.graphics.setColor(0.2, 0.2, 0.3)
        end
        love.graphics.rectangle("fill", 20, y, love.graphics.getWidth() - 40, 80)
        love.graphics.setColor(0.4, 0.4, 0.5)
        love.graphics.rectangle("line", 20, y, love.graphics.getWidth() - 40, 80)
        
        -- Draw item info
        love.graphics.setFont(self.font)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(item.name, 30, y + 10)
        
        -- Draw item type
        love.graphics.setColor(0.7, 0.9, 1)
        love.graphics.print("Type: " .. item.type:sub(1,1):upper() .. item.type:sub(2), 30, y + 35)
        
        -- Draw cost
        love.graphics.setColor(0.3, 1, 0.3)
        love.graphics.print("Cost: " .. item.cost .. " credits", 30, y + 55)
        
        -- Draw stats based on item type
        if item.type == "drill" then
            love.graphics.setColor(1, 0.7, 0.7)
            love.graphics.print("Power: " .. item.power, 230, y + 35)
            love.graphics.print("Efficiency: " .. item.efficiency .. "x", 230, y + 55)
        elseif item.type == "shield" then
            love.graphics.setColor(0.7, 0.7, 1)
            love.graphics.print("Defense: " .. item.defense, 230, y + 35)
        elseif item.type == "engine" then
            love.graphics.setColor(0.7, 1, 0.7)
            love.graphics.print("Speed: " .. item.speed, 230, y + 35)
        end
        
        -- Draw description
        love.graphics.setColor(0.8, 0.8, 0.8)
        love.graphics.setFont(self.smallFont)
        love.graphics.printf(item.description, 350, y + 35, love.graphics.getWidth() - 470, "left")
        
        -- Draw buy button
        if self.resources.credits >= item.cost then
            love.graphics.setColor(0.2, 0.6, 0.2)
        else
            love.graphics.setColor(0.6, 0.2, 0.2)
        end
        love.graphics.rectangle("fill", love.graphics.getWidth() - 120, y + 20, 90, 30)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", love.graphics.getWidth() - 120, y + 20, 90, 30)
        love.graphics.setFont(self.font)
        love.graphics.print("Buy", love.graphics.getWidth() - 100, y + 25)
        
        y = y + 100 -- Move to next shop item
    end
    
    -- Reset translation
    love.graphics.translate(0, self.scroll[2])
    
    -- Draw scrollbar if needed
    if #self.shopItems * 100 > love.graphics.getHeight() - 140 then
        local scrollBarHeight = love.graphics.getHeight() - 180
        local contentHeight = #self.shopItems * 100
        local scrollBarY = 140 + (self.scroll[2] / contentHeight) * scrollBarHeight
        local scrollBarSize = math.max(30, (scrollBarHeight / contentHeight) * scrollBarHeight)
        
        love.graphics.setColor(0.3, 0.3, 0.3)
        love.graphics.rectangle("fill", love.graphics.getWidth() - 15, 140, 10, scrollBarHeight)
        love.graphics.setColor(0.5, 0.5, 0.6)
        love.graphics.rectangle("fill", love.graphics.getWidth() - 15, scrollBarY, 10, scrollBarSize)
    end
end

function GameScene:drawMapTab()
    love.graphics.setFont(self.titleFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Planet Selection", 0, 90, love.graphics.getWidth(), "center")
    
    -- Apply scroll offset for planets
    love.graphics.translate(0, -self.scroll[3])
    
    local y = 140
    for i, planet in ipairs(self.planets) do
        local isSelected = self.selectedPlanet == i
        local isHovered = self.hoveredItem and self.hoveredItem.type == "planet" and self.hoveredItem.index == i
        
        -- Draw planet background
        if isSelected then
            love.graphics.setColor(0.3, 0.3, 0.5)
        elseif isHovered then
            love.graphics.setColor(0.25, 0.25, 0.4)
        else
            love.graphics.setColor(0.2, 0.2, 0.3)
        end
        love.graphics.rectangle("fill", 20, y, love.graphics.getWidth() - 40, 150)
        love.graphics.setColor(0.4, 0.4, 0.5)
        love.graphics.rectangle("line", 20, y, love.graphics.getWidth() - 40, 150)
        
        -- Draw planet info
        love.graphics.setFont(self.font)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(planet.name, 140, y + 10)
        
        -- Draw planet type
        love.graphics.setFont(self.smallFont)
        if planet.type == "metal" then
            love.graphics.setColor(0.7, 0.7, 0.8)
            love.graphics.print("Metal-rich planet", 140, y + 40)
        elseif planet.type == "energy" then
            love.graphics.setColor(1, 0.9, 0.2)
            love.graphics.print("Energy-rich planet", 140, y + 40)
        else
            love.graphics.setColor(0.9, 0.7, 1)
            love.graphics.print("Mixed resources", 140, y + 40)
        end
        
        -- Draw difficulty
        love.graphics.setColor(1, 0.7, 0.7)
        love.graphics.print("Difficulty: " .. string.rep("⚠️", planet.difficulty), 140, y + 60)
        
        -- Draw rewards
        love.graphics.setColor(0.7, 1, 0.7)
        love.graphics.print("Rewards:", 140, y + 80)
        love.graphics.setColor(0.8, 0.8, 0.8)
        local rewards = ""
        if planet.rewards.metal > 0 then rewards = rewards .. planet.rewards.metal .. " metal, " end
        if planet.rewards.energy > 0 then rewards = rewards .. planet.rewards.energy .. " energy" end
        if planet.rewards.crystals and planet.rewards.crystals > 0 then 
            rewards = rewards .. ", " .. planet.rewards.crystals .. " crystals" 
        end
        love.graphics.print(rewards, 200, y + 80)
        
        -- Draw description
        love.graphics.setColor(0.8, 0.8, 0.8)
        love.graphics.printf(planet.description, 140, y + 100, love.graphics.getWidth() - 370, "left")
        
        -- Draw planet image placeholder
        love.graphics.setColor(0.3, 0.3, 0.4)
        love.graphics.rectangle("fill", 30, y + 10, 100, 100)
        love.graphics.setColor(0.5, 0.5, 0.6)
        love.graphics.rectangle("line", 30, y + 10, 100, 100)
        
        -- Draw mission launch button if selected
        if isSelected then
            love.graphics.setColor(0.2, 0.4, 0.7)
            love.graphics.rectangle("fill", love.graphics.getWidth() - 200, y + 100, 170, 30)
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("line", love.graphics.getWidth() - 200, y + 100, 170, 30)
            love.graphics.setFont(self.font)
            love.graphics.print("Launch Mining Mission", love.graphics.getWidth() - 195, y + 105)
        end
        
        y = y + 180 -- Move to next planet
    end
    
    -- Reset translation
    love.graphics.translate(0, self.scroll[3])
    
    -- Draw scrollbar if needed
    if #self.planets * 180 > love.graphics.getHeight() - 140 then
        local scrollBarHeight = love.graphics.getHeight() - 180
        local contentHeight = #self.planets * 180
        local scrollBarY = 140 + (self.scroll[3] / contentHeight) * scrollBarHeight
        local scrollBarSize = math.max(30, (scrollBarHeight / contentHeight) * scrollBarHeight)
        
        love.graphics.setColor(0.3, 0.3, 0.3)
        love.graphics.rectangle("fill", love.graphics.getWidth() - 15, 140, 10, scrollBarHeight)
        love.graphics.setColor(0.5, 0.5, 0.6)
        love.graphics.rectangle("fill", love.graphics.getWidth() - 15, scrollBarY, 10, scrollBarSize)
    end
end

function GameScene:drawButtons()
    for _, btn in ipairs(self.buttons) do
        love.graphics.setColor(btn.color or {0.3, 0.3, 0.4})
        love.graphics.rectangle("fill", btn.x, btn.y, btn.width, btn.height)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", btn.x, btn.y, btn.width, btn.height)
        
        love.graphics.printf(btn.text, btn.x, btn.y + btn.height/4, btn.width, "center")
    end
end

return GameScene