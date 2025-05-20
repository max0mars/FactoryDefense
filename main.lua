require('button')

local Start = require('StartScene')
local scaling = require('scaling')
local GameScene = require('GameScene')
--io.stdout:setvbuf("no") May or may not be needed for print statements
local defaultDimensions = {width = 1280, height = 800}

local CurrentScene = Start
local args = {
	scalingreset = 0,
	newScene = nil,
	sceneData = nil
}

function love.load()
	love.window.setTitle('Factory Defense')
	love.window.setMode(defaultDimensions.width, defaultDimensions.height, {resizable=true})
	scaling.init(defaultDimensions.width, defaultDimensions.height)
	CurrentScene:load()
	pause = false
end

function love.update(dt)
	CurrentScene:update(dt, args)
	if args.newScene == "NewGame" then
		CurrentScene = GameScene
		args.newScene = nil
		args.scalingreset = 1
		CurrentScene:load(args.sceneData)
		args.sceneData = nil
	end
end

function love.draw()
    love.graphics.clear(0.2, 0.2, 0.2)
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