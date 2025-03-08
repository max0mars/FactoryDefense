entity = {}
entity.__index = entity


function entity:new(x, y, health, tag)
    o = {}
    setmetatable(o, self)

    o.x = 0
    o.y = 0
    o.delete = falses
    o.health = 100
    o.tag = tag
    return o
end

function entity:clone()
    ent = {}
    for k, v in pairs(self) do
          ent[k] = v
    end
    setmetatable(ent, {__index = self})
    return ent
end

function takeDamage(damage)
    if(self.delete) then return false end
    self.health = self.health - damage
    if self.health <= 0 then
        self.delete = true
    end
    return true
end