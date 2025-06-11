local Start = require('./Scripts/StartScene')
local scaling = require('./Scripts/scaling')
--io.stdout:setvbuf("no") May or may not be needed for print statements

local width = 1280
local height = 800

local CurrentScene = Start
local args = {
	scalingreset = 0,
	newScene = nil,
	sceneData = nil
}

function love.load()
	love.window.setTitle('Factory Defense')
	love.window.setMode(width, height, {resizable=true})
	scaling.init(width, height)
	CurrentScene:load(width, height)
	pause = false
end

function love.update(dt)
	CurrentScene:update(dt, args)
	if args.newScene then
		if(args.newScene == 'newgame') then
			CurrentScene = require('./Scripts/NewGameScene')
		elseif(args.newScene == 'loadgame') then
			CurrentScene = require('./Scripts/LoadGameScene')
		end
		CurrentScene = args.newScene
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
	scaling.applyTransform()
	CurrentScene:draw()
	scaling.resetTransform()
end

function love.keypressed(key, scancode, isrepeat)
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