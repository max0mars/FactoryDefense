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

    GameState = 0 -- 0 = ingame, 1 = win, 2 = loss
    pause = false

    table.insert(minebots, m1)
end

function love.update(dt)
    if(pause) then return end
    if(factory.health <= 0) then GameState = 2 end
    if(GameState == 0) then
        for i in ipairs(Enemies) do
            Enemies[i]:update(dt, defensebots, factory)
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
        CleanTable(Enemies)
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
        for i in ipairs(Enemies) do
            Enemies[i]:draw()
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
    
end


function CleanTable(t) -- dereferences any elements marked for deletion
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

end