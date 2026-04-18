--[[
    Author: Chance Francisco Gomez | chance.f.gomez@gmail.com
    File: Bird.lua | Parent Class: Enemy.lua
]]
local Bird = {}
Bird.__index = Bird

setmetatable(Bird,{__index = Enemy})

-- Static images
local flyingAnimation = assetloader:getAnimation("animation_bird_flying")
local dyingAnimation = assetloader:getAnimation("animation_bird_dying")

-- Static ID
local staticID = 1

function Bird.new(x,y,handler,difficulty,isFlipped)
    local obj = Enemy.new(x,y,handler)

    if difficulty == nil then error() end
    local difficulty = difficulty or 1

    obj.health = 20 * (math.max(difficulty/3,1))
    obj.speed = math.min(25 * (math.max(difficulty/6,1)),game.maxSpeed)

    obj.resources = 5

    local images = {
        flying = flyingAnimation,
        dying = dyingAnimation
    }
    obj.isFlipped = isFlipped or false
    obj.AnimationPlayer = AnimationPlayer:new(images,"flying",5/obj.speed,true,obj.isFlipped,1)
    obj.sounds = { 
        hit = assetloader:getAudio("birdhit"),
        die = assetloader:getAudio("birddie"),
    }
    obj.width = images['flying'][1]:getWidth()
    obj.height = images['flying'][1]:getHeight()
    obj.id = staticID
    obj.lifeTimer = 0

    --increase static id
    staticID = staticID + 1

    return setmetatable(obj,Bird)
end

function Bird:die()
    Enemy.die(self)
    love.audio.play(self.sounds.die)
    
    game.Observer:trigger("birdDied",self)
end

function Bird:hit(damage)
    Enemy.hit(self, damage)
    love.audio.play(self.sounds.hit:clone())
end

function Bird:update(dt)
    Enemy.update(self, dt)
    --update position
    if self.isAlive and not self.isStunned then
        local speed = self.speed
        if self.isHit then
            speed = speed/2
        end
        local flipNum = -1
        if self.isFlipped then
            flipNum = 1
        end
        self.x = self.x + speed * flipNum * dt
        self.y = self.y - (speed + (math.sin(love.timer.getTime() * 5) * 20)) * dt
    elseif not self.isAlive then
        self.y = self.y + 55 * dt
    end
end

function Bird:draw()
    local flipped = self.facing ~= -1
    local speed = 5/self.speed
    Enemy.draw(self)
    --animationplayer:draw("bird" .. self.id,self.animations[self.animation],speed,math.floor(self.x),math.floor(self.y),self.isAlive,flipped)
end

return Bird