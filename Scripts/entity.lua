entity = {}
entity.__index = entity


function entity:new(tag, x, y, health, hitboxType, hitboxdimensions)
    local o = {}
    setmetatable(o, self)

    o.x = x
    o.y = y
    o.hitboxType = hitboxType -- hitboxType is a string that can be "circle" or "rectangle" 
    o.hitboxdimensions = hitboxdimensions -- hitboxdimensions is a table that contains the dimensions of the hitbox (different for circle and rectangle)
    o.delete = false
    o.health = health
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