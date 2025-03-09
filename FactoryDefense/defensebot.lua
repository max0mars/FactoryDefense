require('bullet')
require ('robot')
--require('entity')

--[[
    - Spawn outside factory with a set y value
    - move diagnal until at y value then move horizontal
    - check for enemies in range, then stop and shoot
    - once reach a certain x value, get destroyed
]]

defensebot = {}

function defensebot:new(bullets)

    o = robot:new(150, 350, 100, "defensebot")
    setmetatable(o, self)

    o.yvalue = love.math.random(200, 500)
    if(o.yvalue < 300) then o.yvalue = o.yvalue + 50
    elseif o.yvalue > 400 then o.yvalue = o.yvalue - 50 end
    o.ydir = 1
    o.radius = 4
    if(o.yvalue < 350) then
        o.ydir = -1
    end
    return o
end


function defensebot:update(dt, enemybots, base)
    if self.delete then return end
    self.counter = self.counter + dt
    if not self:attack(enemybots, base) then
        self:move(dt)
    else
        if(self.counter > self.attackspeed) then
            self.counter = 0
            self:shoot()
        end
    end
end

function defensebot:move(dt)
    if(abs(self.y - self.yvalue) > 3) then
        self.y = self.y + self.speed*dt*self.ydir
    end
    self.x = self.x + self.speed*dt
    if(self.x > 780) then
        self.delete = true
    end
end

function defensebot:shoot()
    --create bullet
    table.insert(self.bullets, bullet:new({x = self.x, y = self.y}, self.target, self.damage, self.bulletSpeed))
end

--[[
    checks for targets in range and sets target to closest
    returns true if enemy found, otherwise false
    ** untested! **
]]
function defensebot:attack(enemybots, base)
    if(enemybots == nil) then return false end

    self.target = nil
    prev = 999999999
    for i, enemy in ipairs(enemybots) do
        x = enemy.x - self.x
        y = enemy.y - self.y
        dist = x*x + y*y
        if dist < self.rangeSq then
            if(dist < prev) then
                self.target = enemybots[i]
                prev = dist
            end
        end
    end
    if base then
        local x = base.x + base.w/2 - self.x
        dist = x*x
        if dist < self.rangeSq then
            if(dist < prev) then
                self.target = base
                prev = dist
            end
        end
    end
    if (self.target) then return true 
    else return false end
end

function defensebot:draw()
    love.graphics.setColor(love.math.colorFromBytes(self.color.r, self.color.g, self.color.b))
    love.graphics.circle('line', self.x, self.y, self.radius)
end

function defensebot:takeDamage(damage)
    self.health = self.health - damage
    if self.health <= 0 then
        self.delete = true
    end
end

function abs(val)
    if val < 0 then return -val end
    return val
end