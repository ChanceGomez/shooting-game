local Bird = {}
Bird.__index = Bird


local flyingAnimation = al:getAnimation("animation_bird_flying")
local dyingAnimation = al:getAnimation("animation_bird_dying")
local staticID = 1

function Bird:new(x,y,handler,difficulty)
  local obj = setmetatable(Enemy:new(x,y,handler), Bird)

  if difficulty == nil then error() end
  local difficulty = difficulty or 1

  obj.health = 20 * (math.max(difficulty/1.6,1))
  obj.speed = 25 * (math.max(difficulty/3,1))

  obj.passive = true
  obj.animation = "flying"
  obj.animations = {
    flying = flyingAnimation,
    dying = dyingAnimation
  }
  obj.facing = math.random(0,1) == 0 and -1 or 1
  obj.width = obj.animations['flying'][1]:getWidth()
  obj.height = obj.animations['flying'][1]:getHeight()
  obj.id = staticID
  obj.lifeTimer = 0

  
    staticID = staticID + 1

  return obj
end

function Bird:die()
    Enemy.die(self)
end

function Bird:hit(damage)
    Enemy.hit(self, damage)
end

function Bird:update(dt)
    Enemy.update(self, dt)
    --update position
    if self.isAlive then
        local speed = self.speed
        if self.isHit then
            speed = speed/2
        end
        self.x = self.x + speed * self.facing * dt
        self.y = self.y - (speed + (math.sin(love.timer.getTime() * 5) * 20)) * dt
    else
        self.y = self.y + 55 * dt
    end
end

function Bird:draw()
    local flipped = self.facing ~= -1
    love.graphics.setColor(self.color)
    local speed = 5/self.speed
    ap:draw("bird" .. self.id,self.animations[self.animation],speed,math.floor(self.x),math.floor(self.y),self.isAlive,flipped)
    Enemy.draw(self)
end

return Bird