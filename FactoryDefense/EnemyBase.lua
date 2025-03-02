EnemyBase = {
    color = {
        r = 153,
        g = 0,
        b = 45
    },
    name = 'e',
}
font = love.graphics.newFont()

function EnemyBase.new(self, x, y, w, h)
    o = {}
    setmetatable(o, self)
    self.__index = self

    o.x = x
    o.y = y
    o.w = w
    o.h = h
    o.health = 1000
    o.textx = o.x + o.w/2
    o.texty = o.y + o.h/2

    return o
end

function EnemyBase.takeDamage(self, damage)
    self.health = self.health - damage
    if self.health <= 0 then
        -- You Win!
    end
end

function EnemyBase.draw(self)
    love.graphics.setColor(love.math.colorFromBytes(self.color.r, self.color.g, self.color.b))
    love.graphics.rectangle("line", self.x, self.y, self.w,self.h)
    love.graphics.print(self.name, self.textx - font:getWidth(self.name)/2, self.texty - font:getHeight(self.name)/2)

    love.graphics.setColor(1, 1, 1)
    local healthtext = 'Health\n ' .. self.health
    love.graphics.print(healthtext, 775 - font:getWidth(healthtext)/2, 170 - font:getHeight(healthtext)/2)
end