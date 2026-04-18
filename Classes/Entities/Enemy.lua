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
  obj.AnimationPlayer = AnimationPlayer:new()

  return obj
end

function Enemy:die()
    --change animation to die animation
    self.isAlive = false
    self.color = "dead"
    self.handler:enemyDied()
    self.isStunned = false
    game.Player:addResources(self.resources)
    self.AnimationPlayer:setAnimation("dying")
    self.AnimationPlayer:setIsLooped(false)
    
end

function Enemy:checkCircleCollision(circle)
    return collision.circleRect(circle,self)
end

function Enemy:escape()
    game.Player.health = game.Player.health - 1
    Enemy.delete(self)
    game.Player:checkLose()
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
        --Trigger the damage/duration
        local damage = game.Affector:trigger(effect.type .. " Damage") or 0
        local duration = game.Affector:trigger(effect.type .. " Duration") or 0

        --Insert effect into effects
        table.insert(self.effects,{
            type = effect.type or "",
            ticks = 0,
            interval = effect.interval or 1,
            timer = 0,
            damage = damage,
            duration = duration,
            executable = function(passthroughEffect,enemy)
                effect.executable(passthroughEffect,enemy) 
            end,
        })
    end

    --For report
    game.lookouts[1].Report:action("shotHit")
end

function Enemy:damage(damage,type)
    --Check to see if is still alive
    if not self.isAlive then return end
    --Make sure damage is valid
    if damage == 0 or damage == nil then return end


    --local damage = game.Affector:trigger(type .. " Damage")
    --Flags
    self.isHit = true
    --Health reductions
    self.health = self.health - damage
    
    --For report
    game.lookouts[1].Report:action("damageDealt", damage)

    --Check if now dead
    if self.health <= 0 then
        self:die()
        --For report
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
    for i = #self.effects, 1, -1 do 
        local effect = self.effects[i]
        local remove = false
        effect.timer = effect.timer + dt


        --Tick system based off of 1 second
        if effect.timer >= 1 then
            effect.timer = 0
            effect.ticks = effect.ticks + 1
            effect.executable(effect,self)
            
            if effect.ticks >= effect.duration then
                remove = true
            end
        end

        --Tick system based off of instant effects
        if effect.interval == 0 and effect.duration > 0 then
            effect.executable(effect,self)
        end

        --Instant effect but instant removal check
        if effect.interval == 0 and effect.duration == 0 then
            effect.executable(effect,self)
                if effect.type == "Dud Fire" then error(2) end
            remove = true
        end

        --remove instant execute effects at the end of loop
        if effect.interval == 0 and effect.ticks >= effect.duration then
                if effect.type == "Dud Fire" then error(3) end

            remove = true
        end

        if remove then
            table.remove(self.effects,i)
        end
    end
end

function Enemy:update(dt)
    Enemy.hitColor(self,dt)

    self.AnimationPlayer:update(dt)

    self.isStunned = false
    --check for effects
    self:effectUpdate(dt)
    
    --clean up
    if not self.isAlive and self.y > window.GameHeight then
        Enemy.delete(self)
    end

    local sideMargin = 32
    if not collision.twoRect({x=-sideMargin,y=-sideMargin,width=window.GameWidth+sideMargin,height=window.GameHeight+sideMargin},self) and self.y < window.GameHeight-40 and self.lifeTimer > 5 then
        self:escape()
    end
end

function Enemy:draw()
    if settings.hitbox then
        love.graphics.setLineWidth(1)
        love.graphics.setColor(1,1,1,1)
        love.graphics.rectangle("line",self.x-1,self.y-1,math.floor(self.width+2),math.floor(self.height+2))
        love.graphics.setFont(dogica_8)
        if settings.showAlive then
            love.graphics.print(self.isAlive and "alive" or "dead",self.x+self.width + 2, self.y)
        end
        if settings.showHealth then
            love.graphics.print("health: " .. math.floor(self.health),self.x+self.width + 2, self.y+6)
        end
    end

    love.graphics.setColor(self.colors[self.color])
    self.AnimationPlayer:draw(math.floor(self.x),math.floor(self.y))
end

return Enemy