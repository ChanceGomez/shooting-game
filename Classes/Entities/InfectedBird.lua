local InfectedBird = {}
InfectedBird.__index = InfectedBird

setmetatable(InfectedBird,{__index = Bird})

-- Static images
local flyingAnimation = assetloader:getAnimation("animation_infectedbird_flying")
local dyingAnimation = assetloader:getAnimation("animation_infectedbird_dying")

function InfectedBird:new(x,y,handler,difficulty,facing)
    local obj = Enemies.Bird:new(x,y,handler,difficulty,facing)

    --Power scaling
    obj.health = 30 * (math.max(difficulty/2,1))
    obj.speed = math.min(30 * (math.max(difficulty/6,1)),game.maxSpeed)
    obj.resources = 15

    obj.animations = {
        flying = flyingAnimation,
        dying = dyingAnimation,
    }

    return obj
end

function InfectedBird:escape()
    Enemy.escape(self)
end

function InfectedBird:die()
    Enemies.Bird.die(self)
end

function InfectedBird:hit(damage)
    Enemies.Bird.hit(self, damage)
end

function InfectedBird:hitColor(dt)
    Enemies.Bird.hitColor(self,dt)
end

function InfectedBird:isCollision()
    return Enemies.Bird.isCollision(self)
end

function InfectedBird:update(dt)
    Enemies.Bird.update(self,dt)
end

function InfectedBird:draw()
    Enemies.Bird.draw(self)
end

return InfectedBird