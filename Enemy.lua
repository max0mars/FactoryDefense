require('entity')

Enemy = setmetatable({}, {__index = Enemy})
Enemy.__index = entity
-- Enemy is a subclass of entity

function Enemy:new(x, y, health, tag, bullets)
    o = entity:new(tag, x, y, health, 'circle', {radius = 4})
    setmetatable(o, self)
    o.speed = 50
    o.health = 100
    o.range = 150
    o.rangeSq = o.range * o.range
    o.damage = 25
    o.bulletSpeed = 500
    o.attackspeed = 1
    o.target = nil
    o.bullets = bullets
    o.counter = 0
    o.color = {
        r = 20,
        g = 200,
        b = 200
    }

    setmetatable(o, self)
    return o
end


-- dt is the time since the last frame
-- targets is a table of entities to attack
-- base is the base to attack

-- First, check if the Enemy is dead
-- Then, check if the Enemy has an enemy in range
-- If not, move the Enemy
-- If so, check if the Enemy can attack
-- If so, shoot
function Enemy:update(dt, targets, base)
    if self.delete then return end
    self.counter = self.counter + dt
    if not self:attack(targets, base) then
        self:move(dt)
    else
        if self.counter > self.attackspeed then
            self.counter = 0
            self:shoot()
        end
    end
end


-- targets is a table of entities to attack
-- base is the base to attack

-- first check if targets is nil
-- then check if the Enemy is in range of the target
-- if so, set the target to the closest target
-- if base is not nil, check if the Enemy is in range of the base
function Enemy:attack(targets, base)
    if targets == nil then return false end
    
    self.target = nil
    local prev = 999999999 --must be larger than range*range
    for i, target in ipairs(targets) do
        local x = target.x - self.x
        local y = target.y - self.y
        local dist = x*x + y*y
        if dist < self.rangeSq then
            if dist < prev then
                self.target = targets[i]
                prev = dist
            end
        end
    end
    
    if base then
        local x = base.x + base.w/2 - self.x
        local dist = x*x
        if dist < self.rangeSq then
            if dist < prev then
                self.target = base
                prev = dist
            end
        end
    end
    return self.target ~= nil
end


-- speed should be positive or negative
-- depending on the direction the Enemy is moving
function Enemy:move(dt)
    self.x = self.x + self.speed*dt
end


-- default shape is circle outline. Vary in size and color and shape?
function Enemy:draw()
    love.graphics.setColor(love.math.colorFromBytes(self.color.r, self.color.g, self.color.b))
    love.graphics.circle('line', self.x, self.y, self.radius)
end