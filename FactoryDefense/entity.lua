entity = {}

-- delete system: every entity gets a unique value starting at 1
-- the key of the entity in a table is always the unique value

function entity.new(self, color)
    o = {}
    setmetatable(o, self)
    self.__index = self

    o.x = 0
    o.y = 0
    o.radius = 4
    o.target = nil
    o.alive = true
    o.color = {
        r = 20,
        g = 200,
        b = 20
    }
    if(color) then
        o.color = color
    end

    --stats
    o.speed = 5
    o.health = 100
    o.range = 15
    o.damage = 25
    o.attackspeed = 1
    
    return o
end

function entity.clone(self, ent)
    ent = {}
    for k, v in pairs(self) do
          ent[k] = v
    end
    setmetatable(ent, self)
    return ent
end

function entity:draw()
    love.graphics.setColor(love.math.colorFromBytes(self.color.r, self.color.g, self.color.b))
    love.graphics.circle('line', self.x, self.y, self.radius)
end