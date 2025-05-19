require('button')

local Start = require('StartScene')
local scaling = require('scaling')
--io.stdout:setvbuf("no") May or may not be needed for print statements

local CurrentScene = Start
local args = {
    scalingreset = 0
}

function love.load()
    love.window.setTitle('Factory Defense')
    love.window.setMode(1280, 800, {resizable=true})
    scaling.init(1280, 800)
    CurrentScene:load()
    pause = false
end

function love.update(dt)
    CurrentScene:update(dt, args)
end

function love.draw()
    if(args.scalingreset == 1) then
        scaling.recalculate()
        args.scalingreset = 0
    end
    scaling.applyTransform()

    CurrentScene:draw()
    scaling.resetTransform()
end

-- function CleanTable(t) -- dereferences any elements marked for deletion
--     local j = 1
--     n = #t
--     for i = 1, n do
--         if t[i].delete then
--             t[i] = nil --delete an item
--         else
--             if (i ~= j) then
--                 t[j] = t[i]
--                 t[i] = nil
--             end
--             j = j + 1
--         end
--     end
-- end