local Bird = {}
Bird.__index = Bird


local flyingAnimation = al:getAnimation("animation_bird_flying")
local dyingAnimation = al:getAnimation("animation_bird_dying")
local staticID = 1

function Bird:new(x,y,handler)
  local obj = setmetatable(Enemy:new(x,y,handler), Bird)
  
  obj.health = 20
  obj.speed = 25
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
        self.x = self.x + self.speed * self.facing * dt
        self.y = self.y - (self.speed + (math.sin(love.timer.getTime() * 5) * 20)) * dt
    else
        self.y = self.y + 55 * dt
    end
end

function Bird:draw()
    local flipped = self.facing ~= -1
    love.graphics.setColor(self.color)
    ap:draw("bird" .. self.id,self.animations[self.animation],.15,math.floor(self.x),math.floor(self.y),self.isAlive,flipped)
    Enemy.draw(self)
end

return Bird