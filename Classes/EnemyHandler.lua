local EnemyHandler = {}
EnemyHandler.__index = EnemyHandler

function EnemyHandler:new(enemies,difficulty)
    local obj = setmetatable({}, EnemyHandler)
  

    local enemies = enemies or 5
    local difficulty = difficulty or 1


    obj.enemies = enemies
    obj.difficulty = difficulty
    obj.enemySpawnTimer = 0
    obj.enemyQueue = {}
    obj.isRoundActive = true


  return obj
end

function EnemyHandler:startRound()
    self.isRoundActive = true
    
    for i = 1, self.enemies do
        local interval = math.random(0,5)
        event:addQueue({
            t = interval,
            event = function()
                game.lookouts[1].handler:newEnemy("Bird",math.random(200,Width-200),Height+30,game.lookouts[1].handler.difficulty)
            end
         })
    end
end


function EnemyHandler:checkHit(damage)
    for i, enemy in pairs(game.lookouts[1].enemies) do
        if collision.rect(enemy) and enemy.isAlive then
            enemy:hit(damage) 
        end
    end
end

function EnemyHandler:newEnemy(enemy,x,y,difficulty)
    local x = x or 320
    local y = y or 360
    local enemy = enemy or "Bird"
    self.enemies = self.enemies - 1
    table.insert(game.lookouts[1].enemies, Enemies[enemy]:new(x,y,self,difficulty))

end

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