local ExplosionBird = {}
ExplosionBird.__index = ExplosionBird

setmetatable(ExplosionBird,{__index = Bird})

-- Static images
local flyingAnimation = assetloader:getAnimation("animation_explosionbird_flying")

function ExplosionBird.new(x,y,handler,difficulty,facing)
    local obj = Enemies.Bird.new(x,y,handler,difficulty,facing) 

    --Power scaling
    obj.health = 30 * (math.max(difficulty/2,1))
    obj.speed = 15 * (math.max(difficulty/6,1))
    obj.explosionRadius = 25
    obj.explosionDamage = 25
    obj.explosionDuration = .5
    obj.resources = 5

    obj.animations = {
        flying = flyingAnimation,
    }

    return setmetatable(obj,ExplosionBird)
end

function ExplosionBird:die()
    Enemy.die(self)
    game:getHandler():newExplosion(self.x+self.width/2,self.y+self.height/2,self.explosionRadius,self.explosionDamage,self.explosionDuration)
    Enemy.delete(self)
end

return ExplosionBird