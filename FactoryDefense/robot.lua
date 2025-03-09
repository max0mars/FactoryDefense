requrie('entity')

robot = setmetatable({}, entity)
robot.__index = robot

function robot:new(x, y, health, tag, bullets)
    o = entity:new(x, y, health, tag)
    o.speed = 50
    o.health = 100
    o.range = 150
    o.rangeSq = o.range * o.range
    o.damage = 25
    o.bulletSpeed = 500
    o.attackspeed = 1

    o.radius = 4 --maybe the radius is length if it is square shaped?

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

-- First, check if the robot is dead
-- Then, check if the robot has an enemy in range
-- If not, move the robot
-- If so, check if the robot can attack
-- If so, shoot
function robot:update(dt, targets, base)
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
-- then check if the robot is in range of the target
-- if so, set the target to the closest target
-- if base is not nil, check if the robot is in range of the base
function robot:attack(targets, base)
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
-- depending on the direction the robot is moving
function robot:move(dt)
    self.x = self.x + self.speed*dt
end


-- default shape is circle outline. Vary in size and color and shape?
function robot:draw()
    love.graphics.setColor(love.math.colorFromBytes(self.color.r, self.color.g, self.color.b))
    love.graphics.circle('line', self.x, self.y, self.radius)
end