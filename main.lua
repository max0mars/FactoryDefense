require('building')
require('minebot')
require('factory')
require('Enemy')
require('bullet')
require('button')

local scaling = require('scaling')
--io.stdout:setvbuf("no") May or may not be needed for print statements

function love.load()
    love.window.setTitle('Factory Defense')
    love.window.setMode(800, 600)

    GameState = 0 -- 0 = ingame, 1 = win, 2 = loss
    pause = false

    table.insert(minebots, m1)
end

function love.update(dt)
end

function love.draw()

end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
       love.event.quit()
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