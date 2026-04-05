local BigInfectedBird = {}
BigInfectedBird.__index = BigInfectedBird

setmetatable(BigInfectedBird,{__index = Bird})


-- Static images
local flyingAnimation = assetloader:getAnimation("animation_infectedbird_flying")
local dyingAnimation = assetloader:getAnimation("animation_infectedbird_dying")

function BigInfectedBird.new(x,y,handler,difficulty,facing)
    local obj = Bird.new(x,y,handler,difficulty,facing) 

    --Power scaling
    obj.difficulty = difficulty
    obj.health = 30 * (math.max(difficulty/1.5,1))
    obj.speed = 20 * (math.max(difficulty/8,1))
    obj.resources = 15

    local animations = {
        flying = flyingAnimation,
        dying = dyingAnimation,
    }
    obj.AnimationPlayer:setImages(animations)
    obj.AnimationPlayer:setScale(2)

    obj.width = flyingAnimation[1]:getWidth()*2
    obj.height = flyingAnimation[1]:getHeight()*2

    return setmetatable(obj,BigInfectedBird)
end

function BigInfectedBird:die()
    Enemies.Bird.die(self)
    game:getHandler():newEnemy("InfectedBird",self.x+15,self.y,true)
    game:getHandler():newEnemy("InfectedBird",self.x+15,self.y,false)
end

function BigInfectedBird:draw()
    local flipped = self.facing ~= -1
    local speed = 5/self.speed
    Enemy.Draw(self)
end

return BigInfectedBird