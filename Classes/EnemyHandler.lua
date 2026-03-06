--[[
    Author: Chance Francisco Gomez | chance.f.gomez@gmail.com
    File: EnemyHandler

    ---------------------------------------------------------------------


]]

local EnemyHandler = {}
EnemyHandler.__index = EnemyHandler

function EnemyHandler:new(enemies,difficulty)
    local obj = setmetatable({}, EnemyHandler)
  
    local enemies = enemies or 5 -- Amount of enemies that are gonna spawn during the round
    local difficulty = difficulty or 1 -- Difficulty for the round


    obj.enemies = enemies
    obj.difficulty = difficulty

    obj.isRoundActive = true
    obj.enemySpawnTimer = 0
    obj.enemyQueue = {}

  return obj
end

-- Start the round 
function EnemyHandler:startRound()
    --Set round to active
    self.isRoundActive = true
    
    --Spawn in enemies as a queue
    for i = 1, self.enemies do
        local interval = math.random(1,5)
        event:addQueue({
            t = interval,
            event = function()
                --game.lookouts[1].handler:newEnemy("Bird",math.random(200,Width-200),Height+30,game.lookouts[1].handler.difficulty)
                --Testing to see if you can pass through self through reference
                EnemyHandler.newEnemy(self,"Bird",math.random(200,Width-200),Height+30,game.lookouts[1].handler.difficulty)
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
    self.enemies = self.enemies - 1
    table.insert(game.lookouts[1].enemies, Enemies[enemy]:new(x,y,self,difficulty))

end

-- Removes enemy from lookouts
function EnemyHandler:removeEnemy(enemy)
    for i, e in pairs(game.lookouts[1].enemies) do
        if e == enemy then
            table.remove(game.lookouts[1].enemies, i)
            return
        end
    end
end

function EnemyHandler:update(dt)
    for i, enemy in pairs(game.lookouts[1].enemies) do
        enemy:update(dt)
    end

    --print(self.enemies,self.isRoundActive,#self.enemyQueue,#game.lookouts[1].enemies)
    --Checks to see if round is over
    if self.enemies <= 0 and self.isRoundActive and #self.enemyQueue == 0 and #game.lookouts[1].enemies == 0 then
        self.isRoundActive = false
    end 
end

function EnemyHandler:draw()
    for i, enemy in pairs(game.lookouts[1].enemies) do
        enemy:draw()
    end
end


return EnemyHandler