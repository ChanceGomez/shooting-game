local GrenadeExplosion = {}
GrenadeExplosion.__index = GrenadeExplosion

setmetatable(GrenadeExplosion,{__index = Explosion})

function GrenadeExplosion.new(handler,x,y)
    local obj = Explosion.new(handler,x,y)

    obj.properties = game.Player.explosionProperties
    obj.radius = game.Affector:trigger("Grenade Radius",obj.properties.explosion.radius)

    return obj
end

return GrenadeExplosion