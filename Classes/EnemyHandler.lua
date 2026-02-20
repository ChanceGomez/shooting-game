local EnemyHandler = {}
EnemyHandler.__index = EnemyHandler

function EnemyHandler:new(lookout)
  local obj = setmetatable({}, EnemyHandler)

  obj.enemySpawnTimer = 0
  obj.enemyQueue = {}
  obj.isRoundActive = false
  obj.lookout = lookout


  return obj
end

function EnemyHandler:startRound(numberOfEnemies)
    local numberOfEnemies = numberOfEnemies or 5

    self.isRoundActive = true

    for i = 1, numberOfEnemies do
        local interval = math.random(0,5)
        event:addQueue({
            t = interval,
            event = function()
                self:newEnemy("Bird",math.random(200,Width-200),Height+30)
            end
         })
    end
end


function EnemyHandler:checkHit(damage)
    for i, enemy in pairs(self.lookout.enemies) do
        if collision.rect(enemy) and enemy.isAlive then
            enemy:hit(damage) 
        end
    end
end

function EnemyHandler:newEnemy(enemy,x,y)
    local x = x or 320
    local y = y or 360
    local enemy = enemy or "Bird"
    table.insert(self.lookout.enemies, Enemies[enemy]:new(x,y,self))
end

function EnemyHandler:removeEnemy(enemy)
    for i, e in pairs(self.lookout.enemies) do
        if e == enemy then
            table.remove(self.lookout.enemies, i)
            return
        end
    end
end

function EnemyHandler:update(dt)
    for i, enemy in pairs(self.lookout.enemies) do
        enemy:update(dt)
    end

    if #self.lookout.enemies == 0 and self.isRoundActive then
        self.isRoundActive = false
    end 
end

function EnemyHandler:draw()
    for i, enemy in pairs(self.lookout.enemies) do
        enemy:draw()
    end
end


return EnemyHandler