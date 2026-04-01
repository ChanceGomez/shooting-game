local FastBird = {}
FastBird.__index = FastBird

-- Static images
local flyingAnimation = al:getAnimation("animation_fastbird_flying")
local dyingAnimation = al:getAnimation("animation_fastbird_dying")

function FastBird:new(x,y,handler,difficulty,facing)
    local obj = Enemies.Bird:new(x,y,handler,difficulty,facing) 

    --Power scaling
    obj.health = 10 * (math.max(difficulty/2,1))
    obj.speed = 40 * math.min((math.max(difficulty/6,1)),70)
    obj.resources = 5

    obj.animations = {
        flying = flyingAnimation,
        dying = dyingAnimation,
    }

    return obj
end

function FastBird:escape()
    Enemy.escape(self)
end

function FastBird:die()
    Enemies.Bird.die(self)
end

function FastBird:hit(damage)
    Enemies.Bird.hit(self, damage)
end

function FastBird:hitColor(dt)
    Enemies.Bird.hitColor(self,dt)
end

function FastBird:isCollision()
    return Enemies.Bird.isCollision(self)
end

function FastBird:update(dt)
    Enemies.Bird.update(self,dt)
end

function FastBird:draw()
    Enemies.Bird.draw(self)
end

return FastBird