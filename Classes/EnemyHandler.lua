--[[
    Author: Chance Francisco Gomez | chance.f.gomez@gmail.com
    File: EnemyHandler

    ---------------------------------------------------------------------


]]

local EnemyHandler = {}
EnemyHandler.__index = EnemyHandler

function EnemyHandler.new(lookout,enemies,difficulty)
    local obj = setmetatable({}, EnemyHandler)
  
    local difficulty = difficulty or 1 -- Difficulty for the round

    obj.isParachute = math.random(1,100) < game.Affector:trigger("Parachute Chance",game.Player.parachuteOdds)

    obj.lookout = lookout

    obj.enemyCount = 0
    obj.enemyList = enemies
    obj.difficulty = difficulty
    
    obj.EventHandler = Event.new()

    obj.isRoundActive = false
    obj.enemySpawnTimer = 0
    obj.enemyQueue = {}

    obj.parachutes = {}
    obj.enemies = {}
    obj.damagePopups = {}
    obj.Explosions = {}

  return obj
end

-- Start the round 
function EnemyHandler:startRound()
    local round = game.round
    --Set round to active
    self.isRoundActive = true

    --check to see if parachute is true
    if self.isParachute then
        table.insert(self.enemies,ParachuteCrate.new(math.random(100,540),0,game.Affector:trigger("Parachute Equipment Rarity",game:getVariable("Parachute Equipment Rarity")),self))
        --table.insert(self.parachutes,ParachuteCrate.new(math.random(100,540),0,1,self))
    end

    --[[
    self.EventHandler:addQueue({
            t = interval,
            event = function()
                local random = math.random(1,2)
                local facing = 1 
                if random == 2 then 
                    facing = -1
                end
                self:newEnemy("Nest",math.random(200,window.GameWidth-200),window.GameHeight+30,self.difficulty,facing)
            end
         })
    ]]
    
    --Spawn in enemies as a queue
    for i = 1, #self.enemyList do
        local interval = math.random(2,math.max(8-self.difficulty,math.random(1,3)))
        self.EventHandler:addQueue({
            t = interval,
            event = function()
                local random = math.random(1,2)
                local facing = true 
                if random == 2 then 
                    facing = false
                end
                self:newEnemy(self.enemyList[i],math.random(200,window.GameWidth-200),window.GameHeight+30,facing)
            end
         })
    end
end

function EnemyHandler:enemyDied()
    self.lookout.enemyCount = self.lookout.enemyCount - 1
end

function EnemyHandler:deletePopup(popup)
    for i, instance in pairs(self.damagePopups) do
        if popup == instance then
            table.remove(self.damagePopups,i)
        end
    end
end

--[[
    Checks to see if enemy is hit by collision detection
]]
function EnemyHandler:checkHit(properties)
    for i, enemy in pairs(self.enemies) do
        if enemy:isCollision(properties) and enemy.isAlive then
            enemy:hit(properties) 
        end
    end

    for i, parachute in pairs(self.parachutes) do
        if parachute:isCollision(properties) and parachute.isAlive then
            parachute:hit(properties) 
        end
    end

end

function EnemyHandler:newExplosion(x,y,radius,damage,duration)
    table.insert(self.Explosions,GrenadeExplosion.new(self,x,y))
end

-- Spawn in an enemy
function EnemyHandler:newEnemy(enemy,x,y,facing)
    local x = x or 320
    local y = y or 360
    local enemy = enemy or "Bird"
    self.enemyCount = self.enemyCount + 1
    table.insert(self.enemies, Enemies[enemy].new(x,y,self,self.difficulty,facing))
end

-- Removes enemy from lookouts
function EnemyHandler:removeEnemy(enemy)
    for i, e in pairs(self.enemies) do
        if e == enemy then
            table.remove(self.enemies, i)
            return
        end
    end
end

function EnemyHandler:removeExplosion(explosion) 
    for i, e in pairs(self.Explosions) do
        if e == explosion then
            table.remove(self.Explosions,i)
            return
        end
    end
end

function EnemyHandler:update(dt)
    self.EventHandler:update(dt)
    
    if self.isRoundActive then
        for i, enemy in pairs(self.enemies) do
            enemy:update(dt)
        end
        for i, parachute in pairs(self.parachutes) do
            parachute:update(dt)
        end
        for i, damagePopup in pairs(self.damagePopups) do
            damagePopup:update(dt)
        end
        for i, explosion in pairs(self.Explosions) do
            explosion:update(dt)
        end
    end

    --Checks to see if round is over
    if #self.enemies <= 0 and self.enemyCount >= #self.enemyList then
        self.isRoundActive = false
    end 
end

function EnemyHandler:draw()
    love.graphics.setColor(1,1,1,1)
    if settings.debug then
        local txt = tostring(self.isRoundActive) .. ' ' .. self.enemyCount .. ' ' .. #self.enemies .. ' ' .. #self.enemyQueue
        love.graphics.print(txt,20,20)
    end
    for i, enemy in pairs(self.enemies) do
        enemy:draw()
    end
    for i, parachute in pairs(self.parachutes) do
        parachute:draw()
    end
    for i, damagePopup in pairs(self.damagePopups) do
        damagePopup:draw()
    end
    for i, explosion in pairs(self.Explosions) do
            explosion:draw()
        end
end


return EnemyHandler