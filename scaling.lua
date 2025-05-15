local scaling = {}

-- Default values for the drawing area
scaling.DRAW_WIDTH = 800
scaling.DRAW_HEIGHT = 600
scaling.PIXEL_SCALE = 1
scaling.DRAW_SCALE = 1
scaling.LEFT_OFFSET = 0
scaling.TOP_OFFSET = 0

-- Initialize the scaling system
function scaling.init(drawWidth, drawHeight)
    scaling.DRAW_WIDTH = drawWidth or scaling.DRAW_WIDTH
    scaling.DRAW_HEIGHT = drawHeight or scaling.DRAW_HEIGHT
    scaling.recalculate()
end

-- Recalculate scaling and offsets based on window size
function scaling.recalculate()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    
    -- Calculate scaling factors
    local scaleHorizontal = w / scaling.DRAW_WIDTH
    local scaleVertical = h / scaling.DRAW_HEIGHT

    -- Determine the appropriate scale to maintain aspect ratio
    if scaling.DRAW_WIDTH / scaling.DRAW_HEIGHT <= w / h then
        scaling.DRAW_SCALE = scaleVertical
    else
        scaling.DRAW_SCALE = scaleHorizontal
    end

    -- Calculate offsets for centering the drawing area
    scaling.LEFT_OFFSET = (w - (scaling.DRAW_WIDTH * scaling.DRAW_SCALE)) / 2
    scaling.TOP_OFFSET = (h - (scaling.DRAW_HEIGHT * scaling.DRAW_SCALE)) / 2

    -- Handle HighDPI scaling
    scaling.PIXEL_SCALE = love.window.getDPIScale()
end

-- Apply transformations for drawing
function scaling.applyTransform()
    love.graphics.push()
    love.graphics.translate(scaling.LEFT_OFFSET, scaling.TOP_OFFSET)
    love.graphics.scale(scaling.DRAW_SCALE)
end

-- Reset transformations after drawing
function scaling.resetTransform()
    love.graphics.pop()
end

return scaling