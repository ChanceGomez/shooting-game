--[[
    Author: Chance Francisco Gomez | chance.f.gomez@gmail.com
    File: Enemy.lua 
]]

local Enemy = {}
Enemy.__index = Enemy

function Enemy.new(x,y,handler)
  local obj = setmetatable({}, Enemy)
  obj.x = x or 0
  obj.y = y or 0
  obj.health = 100
  obj.handler = handler
  obj.speed = 10
  obj.hitTimer = 0
  obj.isHit = false
  obj.stunned = false
  obj.hitDuration = .3
  obj.colors = {
    hit = {1,0,0,1},
    dead = {.6,.6,.6,1},
    normal = {1,1,1,1},
    stunned = {1,1,0,1},
  }
  obj.color = "normal"
  obj.lifeTimer = 0 
  obj.isAlive = true
  obj.resources = 0
  obj.effects = {}

  return obj
end

function Enemy:die()
    --change animation to die animation
    self.isAlive = false
    self.color = "dead"
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
    self.isHit = true
    
    --Insert effects 
    for i, effect in pairs(properties) do
        table.insert(self.effects,{
            type = effect.type,
            ticks = 0,
            interval = effect.interval or 1,
            timer = 0,
            damage = effect.damage or 0,
            duration = effect.duration or 0,
            executable = function(enemy)
                effect:executable(enemy) 
            end,
        })
    end

    game.lookouts[1].Report:action("shotHit")
end

function Enemy:damage(damage,type)
    print(damage,type)
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
    table.insert(self.handler.damagePopups,DamagePopup.new(self.handler,self.x,self.y,damage))
end

function Enemy:stun()
    --Do not apply stun if dead
    if not self.isAlive then return end
    self.isStunned = true    
end

function Enemy:hitColor(dt)
    self.lifeTimer = self.lifeTimer + dt    
    
    if self.isStunned then
        self.color = "stunned"
    end
    if self.isHit then 
        self.color = "hit"
        self.hitTimer = self.hitTimer + dt
        if self.hitTimer >= self.hitDuration then
            self.hitTimer = 0
            self.isHit = false
            self.color = "normal"
        end
    end

    if not self.isAlive then
        self.color = "dead"
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
        self.color = "dead"
    end
end

function Enemy:effectUpdate(dt)
    --check for effects
    for i, effect in ipairs(self.effects) do
        effect.timer = effect.timer + dt
        if effect.timer > 1 then
            effect.timer = 0
            effect.ticks = effect.ticks + 1
            effect.executable(self)
            if effect.ticks >= effect.duration then
                table.remove(self.effects,i)
            end
        elseif effect.interval == 0 and effect.ticks == 0 then
            effect.ticks = effect.ticks + 1
            effect.executable(self)
        end
    end
end

function Enemy:update(dt)
    Enemy.hitColor(self,dt)

    --check for effects
    Enemy.effectUpdate(self,dt)

    --clean up
    if not self.isAlive and self.y > Height then
        Enemy.delete(self)
    end

    local sideMargin = 32
    if not collision.twoRect({x=-sideMargin,y=-sideMargin,width=Width+sideMargin,height=Height+sideMargin},self) and self.y < Height-40 and self.lifeTimer > 5 then
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
            love.graphics.print("health: " .. math.floor(self.health),self.x+self.width + 2, self.y+6)
        end
    end

    love.graphics.setColor(self.colors[self.color])
end

return Enemy