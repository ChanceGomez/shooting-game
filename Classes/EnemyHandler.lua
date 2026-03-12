--[[
    Author: Chance Francisco Gomez | chance.f.gomez@gmail.com
    File: EnemyHandler

    ---------------------------------------------------------------------


]]

local EnemyHandler = {}
EnemyHandler.__index = EnemyHandler

function EnemyHandler:new(lookout,enemyCount,difficulty)
    local obj = setmetatable({}, EnemyHandler)
  
    local enemyCount = enemyCount or 5 -- Amount of enemies that are gonna spawn during the round
    local difficulty = difficulty or 1 -- Difficulty for the round

    obj.lookout = lookout

    obj.enemyCount = enemyCount
    obj.difficulty = difficulty
    
    obj.EventHandler = Event:new()

    obj.isRoundActive = false
    obj.enemySpawnTimer = 0
    obj.enemyQueue = {}

  return obj
end

-- Start the round 
function EnemyHandler:startRound()
    local round = game.round
    --Set round to active
    self.isRoundActive = true

    --Get enemies
    local enemies = {}

    for i = 1, self.enemyCount do
        if round > 3 then
            local weight = 50 + ((round-3) * 10)
            local random = math.random(0,100)
            if weight < random then
                table.insert(enemies,"InfectedBird")
            else
                table.insert(enemies,"Bird")
            end
        else
            table.insert(enemies,"Bird")
        end
    end
    
    --Spawn in enemies as a queue
    for i = 1, self.enemyCount do
        local interval = math.random(1,5-self.difficulty)
        self.EventHandler:addQueue({
            t = interval,
            event = function()
                self:newEnemy(enemies[i],math.random(200,Width-200),Height+30,self.difficulty)
            end
         })
    end
end

--[[
    Checks to see if enemy is hit by collision detection
]]
function EnemyHandler:checkHit(damage)
    for i, enemy in pairs(game.lookouts[1].enemies) do
        if collision.rect(enemy) and enemy.isAlive then
            enemy:hit(damage) 
        end
    end
end

-- Spawn in an enemy
function EnemyHandler:newEnemy(enemy,x,y,difficulty)
    local x = x or 320
    local y = y or 360
    local enemy = enemy or "Bird"
    self.enemyCount = self.enemyCount - 1
    table.insert(self.lookout.enemies, Enemies[enemy]:new(x,y,self,difficulty))
end

-- Removes enemy from lookouts
function EnemyHandler:removeEnemy(enemy)
    for i, e in pairs(self.lookout.enemies) do
        if e == enemy then
            table.remove(self.lookout.enemies, i)
            return
        end
    end
end

function EnemyHandler:update(dt)
    self.EventHandler:update(dt)
    
    if self.isRoundActive then
        for i, enemy in pairs(self.lookout.enemies) do
            enemy:update(dt)
        end
    end

    --Checks to see if round is over
    if self.enemyCount <= 0 and self.isRoundActive and #self.enemyQueue == 0 and #self.lookout.enemies == 0 then
        self.isRoundActive = false
    end 
end

function EnemyHandler:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.print(tostring(self.isRoundActive) .. ' ' .. self.enemyCount,20,20)
    for i, enemy in pairs(game.lookouts[1].enemies) do
        enemy:draw()
    end
end


return EnemyHandler