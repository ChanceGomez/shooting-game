local BigInfectedBird = {}
BigInfectedBird.__index = BigInfectedBird

-- Static images
local flyingAnimation = al:getAnimation("animation_infectedbird_flying")
local dyingAnimation = al:getAnimation("animation_infectedbird_dying")

function BigInfectedBird:new(x,y,handler,difficulty)
    local obj = setmetatable(Enemies.Bird:new(x,y,handler,difficulty),InfectedBird)

    --Power scaling
    obj.health = 30 * (math.max(difficulty/1.5,1))
    obj.speed = 30 * (math.max(difficulty/2.8,1))
    obj.resources = 15

    obj.animations = {
        flying = flyingAnimation,
        dying = dyingAnimation,
    }

    obj.width = flyingAnimation[1]:getWidth()*2
    obj.height = flyingAnimation[1]:getHeight()*2

    return obj
end

function BigInfectedBird:die()
    Enemies.Bird.die(self)
end

function BigInfectedBird:escape()
    Enemy.escape(self)
end

function BigInfectedBird:hit(damage)
    Enemies.Bird.hit(self, damage)
end

function BigInfectedBird:hitColor(dt)
    Enemies.Bird.hitColor(self,dt)
end

function BigInfectedBird:isCollision()
    return Enemies.Bird.isCollision(self)
end

function BigInfectedBird:update(dt)
    Enemies.Bird.update(self,dt)
end

function BigInfectedBird:draw()
    local flipped = self.facing ~= -1
    love.graphics.setColor(self.color)
    local speed = 5/self.speed
    ap:draw("bird" .. self.id,self.animations[self.animation],speed,math.floor(self.x),math.floor(self.y),self.isAlive,flipped,2)
    Enemy.draw(self)
end

return BigInfectedBird