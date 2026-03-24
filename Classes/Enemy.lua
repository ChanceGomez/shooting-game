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
  obj.resources = 0
  obj.effects = {}

  return obj
end

function Enemy:die()
    --change animation to die animation
    self.isAlive = false
    self.color = {0.7,0.5,0.5,1}
    self.handler:enemyDied()
    game.lookouts[1].Report:action("resources",self.resources)
    if self.animation then
        self.animation = "dying"
    end
end

function Enemy:escape()
    game.Player.health = game.Player.health - 1
    Enemy.delete(self)
end

function Enemy:delete()
    if self.handler then
        self.handler:removeEnemy(self)
    end
end

function Enemy:hit(properties)
    local damage = properties.damage or 0
    local fireDamage = properties.fire.damage or 0
    local fireDuration = properties.fire.duration or 0


    self.isHit = true

    --Check to see if there is just instant damage 
    if damage > 0 then
        Enemy.damage(self,damage)
    end

    --Check to see if fire damage
    if fireDamage > 0 then
        table.insert(self.effects,{
            type = "Fire",
            ticks = 0,
            interval = 1,
            timer = 0,
            damage = fireDamage,
            duration = fireDuration,
        })
    end

    game.lookouts[1].Report:action("shotHit")
end

function Enemy:damage(damage,type)
    if not self.isAlive then return end
    local type = type or ""

    self.isHit = true

    --Observer/Affector
    local damage = game.Affector:trigger(type .. ' '.. "Damage",damage)
    game.lookouts[1].Report:action("damageDealt", damage)

    self.health = self.health - damage

    if self.health <= 0 then
        self:die()
        game.lookouts[1].Report:action("enemyKilled")
    end

    --damage popup
    table.insert(self.handler.damagePopups,DamagePopup:new(self.handler,self.x,self.y,damage))
end

function Enemy:hitColor(dt)
    self.lifeTimer = self.lifeTimer + dt    
    if self.isHit then 
        self.color = {1,0,0,1}
        self.hitTimer = self.hitTimer + dt
        if self.hitTimer >= self.hitDuration then
            self.hitTimer = 0
            self.isHit = false
            self.color = {1,1,1,1}
        end
    end
end

function Enemy:isCollision()
    if collision.rect(self) then
        return true
    else
        return false
    end
end

function Enemy:deadColor()
    if not self.isHit and not self.isAlive then
        self.color = {.6,.6,.6,1}
    end
end

function Enemy:update(dt)
    Enemy.hitColor(self,dt)

    --check for effects
    for i, effect in ipairs(self.effects) do
        effect.timer = effect.timer + dt
        if effect.timer > 1 then
            effect.timer = 0
            effect.ticks = effect.ticks + 1
            Enemy.damage(self,effect.damage,effect.type)
            if effect.ticks >= effect.duration then
                table.remove(self.effects,i)
            end
        end
    end

    local sideMargin = 8
    if not collision.twoRect({x=-sideMargin,y=-sideMargin,width=Width+sideMargin,height=Height+sideMargin},self) and self.lifeTimer > 5 then
        Enemy.escape(self)
    end
end

function Enemy:draw()
    if settings.hitbox then
        love.graphics.setLineWidth(1)
        love.graphics.rectangle("line",self.x-1,self.y-1,self.width+2,self.height+2)
        love.graphics.setFont(dogica_8)
        if settings.showAlive then
            love.graphics.print(self.isAlive and "alive" or "dead",self.x+self.width + 2, self.y)
        end
        if settings.showHealth then
            love.graphics.print("health: " .. self.health,self.x+self.width + 2, self.y+6)
        end
    end
end

return Enemy