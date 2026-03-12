local InfectedBird = {}
InfectedBird.__index = InfectedBird

-- Static images
local flyingAnimation = al:getAnimation("animation_infectedbird_flying")
local dyingAnimation = al:getAnimation("animation_infectedbird_dying")

function InfectedBird:new(x,y,handler,difficulty)
    print("yay infected")
    local obj = setmetatable(Enemies.Bird:new(x,y,handler,difficulty),InfectedBird)

    --Power scaling
    obj.health = 30 * (math.max(difficulty/1.5,1))
    obj.speed = 30 * (math.max(difficulty/2.8,1))

    obj.animations = {
        flying = flyingAnimation,
        dying = dyingAnimation,
    }

    return obj
end

function InfectedBird:die()
    Enemies.Bird.die(self)
end

function InfectedBird:hit(damage)
    Enemies.Bird.hit(self, damage)
end

function InfectedBird:update(dt)
    Enemies.Bird.update(self,dt)
end

function InfectedBird:draw()
    Enemies.Bird.draw(self)
end

return InfectedBird