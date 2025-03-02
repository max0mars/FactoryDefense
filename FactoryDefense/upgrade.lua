upgrade = {}
upgrade.__index = upgrade

function upgrade:new()
    local o = {
         
    }
    setmetatable(o, upgrade)
    return o
end