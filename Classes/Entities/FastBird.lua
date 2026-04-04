local FastBird = {}
FastBird.__index = FastBird

-- Static images
local flyingAnimation = assetloader:getAnimation("animation_fastbird_flying")
local dyingAnimation = assetloader:getAnimation("animation_fastbird_dying")

function FastBird.new(x,y,handler,difficulty,facing)
    local obj = Enemies.Bird.new(x,y,handler,difficulty,facing) 

    --Power scaling
    obj.health = 10 * (math.max(difficulty/2,1))
    obj.speed = 40 * math.min((math.max(difficulty/6,1)),70)
    obj.resources = 5

    obj.animations = {
        flying = flyingAnimation,
        dying = dyingAnimation,
    }

    return setmetatable(obj,FastBird)
end

return FastBird