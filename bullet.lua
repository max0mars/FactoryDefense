bullet = {}
bullet.__index = bullet

function bullet:new(startspot, tar, damage, bspeed)
    local tarx, tary
    if tar.name == 'f' or tar.name == 'e' then
        tarx = tar.x + tar.w / 2
        tary = startspot.y
    else
        tarx = tar.x
        tary = tar.y
    end
    local b = {
        target = tar,
        tarx = tarx,
        tary = tary,
        damage = damage,
        x = startspot.x,
        y = startspot.y,
        speed = bspeed,
        delete = false,
        size = 2
    }
    setmetatable(b, bullet)
    return b
end

function bullet:update(dt)
    if self.delete then return end
    local direction_x = self.tarx - self.x
    local direction_y = self.tary - self.y
    local distance = math.sqrt(direction_x * direction_x + direction_y * direction_y)

    if distance < self.speed * dt then
        self:hitTarget()
    else
        self.x = self.x + (direction_x / distance) * self.speed * dt
        self.y = self.y + (direction_y / distance) * self.speed * dt
    end
end

function bullet:draw()
    if self.delete then return end
    love.graphics.setColor(255, 0, 0)
    love.graphics.circle('fill', self.x, self.y, self.size)
end

function bullet:hitTarget()
    if self.target.takeDamage ~= nil then
        self.target:takeDamage(self.damage)
    end
    self.delete = true
end

function abs(val)
    if val < 0 then return -val end
    return val
end