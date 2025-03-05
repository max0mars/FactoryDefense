entity = {}
entity.__index = entity
-- delete system: every entity gets a unique value starting at 1
-- the key of the entity in a table is always the unique value

function entity:new(x, y, health, tag)
    o = {}
    setmetatable(o, self)

    o.x = 0
    o.y = 0
    o.alive = true
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
    self.health = self.health - damage
    if self.health <= 0 then
        self.alive = false
    end
end