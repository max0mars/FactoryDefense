local Start = require('./Scripts/StartScene')
local scaling = require('./Scripts/scaling')
--io.stdout:setvbuf("no") May or may not be needed for print statements

local width = 1280
local height = 800

local debug = false
local time = 1

local CurrentScene = Start
local args = {
	scalingreset = 0,
	newScene = nil,
	sceneData = nil
}

function love.load()
	love.mouse.setVisible(false)
	love.mouse.setGrabbed(true)
	love.window.setTitle('Factory Defense')
	love.window.setMode(width, height, {resizable=true})
	scaling.init(width, height)
	CurrentScene:load(width, height)
	pause = false
end

function love.update(dt)
	args.debug = debug
	CurrentScene:update(dt * time, args)
	if args.newScene then
		if(args.newScene == 'newgame') then
			CurrentScene = require('./Scripts/GameHomeScene')
		elseif(args.newScene == 'loadgame') then
			CurrentScene = require('./Scripts/LoadGameScene')
		end
		args.newScene = nil
		args.scalingreset = 1
		CurrentScene:load(args.sceneData)
		args.sceneData = nil
	end
end

function love.draw()
	if(args.scalingreset == 1) then
		scaling.recalculate()
		args.scalingreset = 0
	end
	scaling.recalculate()
	scaling.applyTransform()
	CurrentScene:draw()
	scaling.resetTransform()
end

function love.keypressed(key, scancode, isrepeat)
	if key == "tab" then
        debug = not debug
        if(time == 0) then
            time = 1
        else
            time = 0
        end
    end
	if key == "q" then
		love.mouse.setVisible(not love.mouse.isVisible())
		love.mouse.setGrabbed(not love.mouse.isGrabbed())
	end
	CurrentScene:keypressed(key, scancode, isrepeat)
end

function love.mousepressed(x, y, button, istouch, presses)
	CurrentScene:mousepressed(x, y, button, istouch, presses)
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