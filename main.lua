require('building')
require('entity')
require('minebot')
require('factory')
require('defensebot')
require('enemybot')
require('bullet')
require('button')
require('EnemyBase')
--io.stdout:setvbuf("no") May or may not be needed for print statements

function love.load()
    love.window.setTitle('Factory Defense')
    love.window.setMode(800, 600)

    mine = building:new(20, 200, 30, 30, {r = 139, g = 69, b = 19}, 'm')

    factory = factory:new(100, 200, 50, 300)
    enemybase = EnemyBase:new(750, 200, 50, 300)

    minebots = {}
    table.insert(minebots, minebot:new(mine, factory))

    bullets = {}
    defensebots = {}
    enemybots = {}
    buttons = {}

    GameState = 0 -- 0 = ingame, 1 = win, 2 = loss
    pause = false
    upgradeMenu = false

    spawnrate = 0.1
    waverate = 15
    wavecount = 1
    spawnsremaining = 0
    counter = spawnrate
    counter2 = waverate

    table.insert(minebots, m1)

    table.insert(buttons, button:new(400, 550, 100, 50, 'DefenseBot', 5, function() 
            table.insert(defensebots, defensebot:new(bullets))
        end)
    )

    table.insert(buttons, button:new(0, 550, 100, 50, 'MineBot', 25, function() 
        table.insert(minebots, minebot:new(mine, factory))
    end, 1.33)
    )

    table.insert(buttons, button:new(0, 550, 100, 50, 'Upgrade', 25, function() 
        --open menu
        upgradeMenu = not upgradeMenu
        end
        )
    )

    try_again = button:new(400, 500, 100, 50, 'Try Again', 0, function() 
            init()
        end)

end

function love.update(dt)
    if(pause) then return end
    if(factory.health <= 0) then GameState = 2 end
    if(enemybase.health <= 0) then GameState = 1 end
    if(GameState == 0) then
        for i in ipairs(enemybots) do
            enemybots[i]:update(dt, defensebots, factory)
        end
        for i in ipairs(defensebots) do
            defensebots[i]:update(dt, enemybots, enemybase)
        end
        for i in ipairs(minebots) do
            minebots[i]:update(dt)
        end
        for i in ipairs(bullets) do
            bullets[i]:update(dt)
        end
        waveupdate(dt)
        keydown(dt) -- keyboard input for holding down a button
        CleanTable(defensebots)
        CleanTable(enemybots)
        CleanTable(bullets)   
    end 
end

function love.draw()
    if pause then love.graphics.print("Paused", 400, 150) end
    if GameState == 1 then
        love.graphics.print("You Win!", 400, 300)
        try_again:draw()
    elseif GameState == 2 then
        local txt = "You Lose!\n" .. "Better Luck Next Time!"
        love.graphics.print(txt, 400 - font:getWidth(txt)/2, 300 - font:getHeight(txt)/2)
        try_again:draw()
    elseif(GameState == 0) then 
        --if upgradeMenu then
            
        mine:draw()
        factory:draw()
        enemybase:draw()
        for i in ipairs(enemybots) do
            enemybots[i]:draw()
        end
        for i in ipairs(defensebots) do
            defensebots[i]:draw()
        end
        for i in ipairs(minebots) do
            minebots[i]:draw()
        end
        for i in ipairs(bullets) do
            bullets[i]:draw()
        end
        for i in ipairs(buttons) do
            buttons[i]:draw()
        end
        love.graphics.setColor(0,1,0)
        love.graphics.line(0, 200, 800, 200)
        love.graphics.line(0, 500, 800, 500)
    end
    

end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
       love.event.quit()
    elseif key == "p" then
        pause = not pause
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if(pause) then return end
    if button == 1 then -- Left mouse button
        if GameState == 0 then
            for i in ipairs(buttons) do
                factory.metal = buttons[i]:click(x, y, factory.metal)
            end
        else
            try_again:click(x, y)
        end
    end
end

function waveupdate(dt)
    counter2 = counter2 - dt
    if(counter2 < 0) then
        print("wave " .. wavecount)
        spawnsremaining = wavecount * wavecount * 0.5
        wavecount = wavecount + 1
        counter2 = waverate
    end

    counter = counter - dt
        if(counter < 0 and spawnsremaining > 0) then
            table.insert(enemybots, enemybot:new(bullets))
            spawnsremaining = spawnsremaining - 1
            counter = spawnrate
        end
end

function keydown(dt)
    if love.keyboard.isDown('1') then
        counter = counter - dt
        if(counter < 0) then
            table.insert(defensebots, defensebot:new(bullets))
            counter = spawnrate
        end
    end


    if love.keyboard.isDown('2') then
        counter2 = counter2 - dt
        if(counter2 < 0) then
            table.insert(enemybots, enemybot:new(bullets))
            counter2 = spawnrate
        end
    end
end


function CleanTable(t) -- removes any elements marked for deletion
    local j = 1
    n = #t
    for i = 1, n do
        if t[i].delete then
            t[i] = nil --delete an item
        else
            if (i ~= j) then
                t[j] = t[i]
                t[i] = nil
            end
            j = j + 1
        end
    end
end

function init()
    mine = building:new(20, 200, 30, 30, {r = 139, g = 69, b = 19}, 'm')

    factory = factory:new(100, 200, 50, 300)
    enemybase = EnemyBase:new(750, 200, 50, 300)

    minebots = {}
    table.insert(minebots, minebot:new(mine, factory))

    bullets = {}

    defensebots = {}

    enemybots = {}

    buttons = {}

    GameState = 0 -- 0 = ingame, 1 = win, 2 = loss

    spawnrate = 0.1
    waverate = 15
    wavecount = 1
    spawnsremaining = 0
    counter = spawnrate
    counter2 = waverate

    table.insert(minebots, m1)

    table.insert(buttons, button:new(350, 550, 100, 50, 'DefenseBot', 5, function() 
            table.insert(defensebots, defensebot:new(bullets))
        end)
    )

    table.insert(buttons, button:new(150, 550, 100, 50, 'MineBot', 25, function() 
        table.insert(minebots, minebot:new(mine, factory))
    end, 1.33)
    )
end