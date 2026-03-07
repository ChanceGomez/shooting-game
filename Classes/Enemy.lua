--[[
    Author: Chance Francisco Gomez | chance.f.gomez@gmail.com
    File: Enemy.lua 
]]

local Enemy = {}
Enemy.__index = Enemy

function Enemy:new(x,y,handler)
  local obj = setmetatable({}, Enemy)
  obj.x = x or 0
  obj.y = y or 0
  obj.health = 100
  obj.handler = handler
  obj.speed = 10
  obj.passive = false
  obj.hitTimer = 0
  obj.isHit = false
  obj.hitDuration = .3
  obj.color = {1,1,1,1}
  obj.lifeTimer = 0 
  obj.isAlive = true

  return obj
end

function Enemy:die()
    --change animation to die animation
    self.isAlive = false
    self.color = {0.7,0.5,0.5,1}
    if self.animation then
        self.animation = "dying"
    end
end

function Enemy:delete()
    if self.handler then
        self.handler:removeEnemy(self)
    end
end

function Enemy:hit(damage)
    local damage = damage or 0
    self.health = self.health - damage
    self.isHit = true
    game.lookouts[1].Report:action("damageDealt", damage)
    game.lookouts[1].Report:action("shotHit")
    if self.health <= 0 then
        self:die()
        game.lookouts[1].Report:action("enemyKilled")
    end
end

function Enemy:update(dt)
    self.lifeTimer = self.lifeTimer + dt
    if self.isHit and self.isAlive then 
        self.color = {1,0,0,1}
        self.hitTimer = self.hitTimer + dt
        if self.hitTimer >= self.hitDuration then
            self.hitTimer = 0
            self.isHit = false
            self.color = {1,1,1,1}
        end
    end

    if not collision.twoRect({x=0,y=0,width=Width,height=Height},self) and self.lifeTimer > 5 then
        Enemy.delete(self)
    end
end

function Enemy:draw()
    if settings.hitbox then
        love.graphics.setLineWidth(1)
        love.graphics.rectangle("line",self.x-1,self.y-1,self.width+2,self.height+2)
        love.graphics.setFont(perfect_dos_16)
        love.graphics.print(self.isAlive and "alive" or "dead",self.x+self.width + 2, self.y)
    end
end

return Enemy