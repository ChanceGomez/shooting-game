local InfectedBird = {}
InfectedBird.__index = InfectedBird

setmetatable(InfectedBird,{__index = Bird})

-- Static images
local flyingAnimation = assetloader:getAnimation("animation_infectedbird_flying")
local dyingAnimation = assetloader:getAnimation("animation_infectedbird_dying")

function InfectedBird.new(x,y,handler,difficulty,facing)
    local obj = Bird.new(x,y,handler,difficulty,facing)

    --Power scaling
    obj.health = 30 * (math.max(difficulty/2,1))
    obj.speed = math.min(30 * (math.max(difficulty/6,1)),game.maxSpeed)
    obj.resources = 15

    local animations = {
        flying = flyingAnimation,
        dying = dyingAnimation,
    }
    obj.AnimationPlayer:setImages(animations)

    return setmetatable(obj,InfectedBird)
end

return InfectedBird