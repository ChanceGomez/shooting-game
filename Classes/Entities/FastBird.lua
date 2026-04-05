local FastBird = {}
FastBird.__index = FastBird

setmetatable(FastBird,{__index = Bird})

-- Static images
local flyingAnimation = assetloader:getAnimation("animation_fastbird_flying")
local dyingAnimation = assetloader:getAnimation("animation_fastbird_dying")

function FastBird.new(x,y,handler,difficulty,facing)
    local obj = Bird.new(x,y,handler,difficulty,facing) 

    --Power scaling
    obj.health = 4 * (math.max(difficulty/2,1))
    obj.speed = 40 * math.min((math.max(difficulty/6,1)),70)
    obj.resources = 5

    local animations = {
        flying = flyingAnimation,
        dying = dyingAnimation,
    }
    obj.AnimationPlayer:setImages(animations)

    
    return setmetatable(obj,FastBird)
end

return FastBird