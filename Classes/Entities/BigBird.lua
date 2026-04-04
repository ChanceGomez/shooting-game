local BigBird = {}
BigBird.__index = BigBird

setmetatable(BigBird,{__index = Bird})

-- Static images
local flyingAnimation = assetloader:getAnimation("animation_bird_flying")
local dyingAnimation = assetloader:getAnimation("animation_bird_dying")

function BigBird.new(x,y,handler,difficulty,facing)
    local obj = Enemies.Bird.new(x,y,handler,difficulty,facing) 

    --Power scaling
    obj.difficulty = difficulty
    obj.health = 60 * (math.max(difficulty/1.7,1))
    obj.speed = 20 * (math.max(difficulty/8,1))
    obj.resources = 30

    obj.animations = {
        flying = flyingAnimation,
        dying = dyingAnimation,
    }

    obj.width = flyingAnimation[1]:getWidth()*2
    obj.height = flyingAnimation[1]:getHeight()*2

    return setmetatable(obj,BigBird)
end

function BigBird:die()
    Enemies.Bird.die(self)

    game:getHandler():newEnemy("Bird",self.x+15,self.y,1)
    game:getHandler():newEnemy("Bird",self.x+15,self.y,-1)
end

function BigBird:escape()
    Enemy.escape(self)
end

function BigBird:hit(damage)
    Enemies.Bird.hit(self, damage)
end

function BigBird:hitColor(dt)
    Enemies.Bird.hitColor(self,dt)
end

function BigBird:isCollision()
    return Enemies.Bird.isCollision(self)
end

function BigBird:update(dt)
    Enemies.Bird.update(self,dt)
end

function BigBird:draw()
    local flipped = self.facing ~= -1
    local speed = 5/self.speed
    Enemy.draw(self)
    animationplayer:draw("bird" .. self.id,self.animations[self.animation],speed,math.floor(self.x),math.floor(self.y),self.isAlive,flipped,2)
end

return BigBird