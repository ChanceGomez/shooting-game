--[[
    Author: Chance Francisco Gomez | chance.f.gomez@gmail.com
    File: EnemyHandler

    ---------------------------------------------------------------------


]]

local EnemyHandler = {}
EnemyHandler.__index = EnemyHandler

-- Spawn pacing helpers. Declared here (before .new/:startRound use them)
-- because Lua resolves `local` references lexically at parse time, not by
-- call order — a local declared further down the file isn't visible to
-- code written above it, even if that code only runs later.
local ClumpSizes = {
    { size = 1, weight = 10, heat = 1 }, -- lone straggler, common
    { size = 2, weight = 6,  heat = 2 },
    { size = 3, weight = 3,  heat = 3 },
    { size = 5, weight = 1,  heat = 5 }, -- swarm, rare
}

local function pickClumpSize()
    local total = 0
    for _, c in ipairs(ClumpSizes) do total = total + c.weight end
    local roll = math.random() * total
    for _, c in ipairs(ClumpSizes) do
        roll = roll - c.weight
        if roll <= 0 then return c end
    end
    return ClumpSizes[#ClumpSizes]
end

local function shuffle(list)
    local shuffled = {}
    for i, v in ipairs(list) do shuffled[i] = v end
    for i = #shuffled, 2, -1 do
        local j = math.random(1, i)
        shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
    end
    return shuffled
end

function EnemyHandler.new(lookout,seed,difficulty)
    local obj = setmetatable({}, EnemyHandler)
  
    local difficulty = difficulty or 1 -- Difficulty for the round

    obj.isParachute = math.random(1,100) < game.Affector:trigger("Parachute Chance",game.Player.parachuteOdds)

    obj.lookout = lookout

    obj.enemyCount = 0
    obj.enemyList = obj.decodeSeed(seed,difficulty)
    obj.difficulty = difficulty
    
    obj.EventHandler = Event.new()

    obj.isRoundActive = false
    obj.enemySpawnTimer = 0
    obj.enemyQueue = {}

    obj.parachutes = {}
    obj.enemies = {}
    obj.damagePopups = {}
    obj.Explosions = {}

    -- Spawn pacing state (heat/clump director)
    obj.spawnRoster = {}
    obj.spawnCursor = 1
    obj.spawnHeat = 0
    obj.spawnIdleTimer = 0
    obj.spawnCo = nil
    obj.spawnWaitTimer = 0

  return obj, #obj.enemyList
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

    -- Shuffle a copy of the generated roster so release order is independent
    -- of whatever order decodeSeed happened to draw enemies in (enemyList
    -- itself is left untouched in case anything else reads it), and reset
    -- the director's pacing state for this round.
    self.spawnRoster = shuffle(self.enemyList)
    self.spawnCursor = 1
    self.spawnHeat = 0
    self.spawnIdleTimer = 2
    self.spawnCo = nil
    self.spawnWaitTimer = 0
end

local EnemyTypes = {
    { name = "Bird",          minLevel = 0, cost = 1, weight = 10 },
    { name = "FastBird",      minLevel = 3, cost = 2, weight = 8  },
    { name = "BigBird",       minLevel = 4, cost = 3, weight = 6  },
    { name = "InfectedBird",  minLevel = 5, cost = 5, weight = 4  },
    { name = "BigInfectedBird",  minLevel = 5, cost = 7, weight = 3  },
    { name = "ExplosionBird", minLevel = 6, cost = 2, weight = 5  },
}

local function pickWeighted(pool, generator)
    local total = 0
    for _, e in ipairs(pool) do total = total + e.weight end
    local roll = generator:random() * total
    for _, e in ipairs(pool) do
        roll = roll - e.weight
        if roll <= 0 then return e end
    end
    return pool[#pool]
end

function EnemyHandler.decodeSeed(seed, generation)
    local generator = love.math.newRandomGenerator(seed)
    local returnTbl = { enemies = {} }

    local eligible = {}
    for _, e in ipairs(EnemyTypes) do
        if e.minLevel <= generation then table.insert(eligible, e) end
    end

    local budget = generator:random(math.floor(4 + generation / 2), 4 + math.floor(generation*2))

    while true do
        local affordable = {}
        for _, e in ipairs(eligible) do
            if e.cost <= budget then table.insert(affordable, e) end
        end
        if #affordable == 0 then break end -- nothing left fits; stop cleanly, no infinite risk

        local pick = pickWeighted(affordable, generator)
        table.insert(returnTbl.enemies, pick.name)
        budget = budget - pick.cost
    end

    return returnTbl.enemies
end

function EnemyHandler:spawnRemaining()
    return #self.spawnRoster - self.spawnCursor + 1
end

function EnemyHandler:takeClump(size)
    local clump = {}
    for i = 1, math.min(size, self:spawnRemaining()) do
        table.insert(clump, self.spawnRoster[self.spawnCursor])
        self.spawnCursor = self.spawnCursor + 1
    end
    return clump
end

function EnemyHandler:updateSpawning(dt)
    self.spawnHeat = math.max(0, self.spawnHeat - dt * 0.5)

    if self.spawnCo then
        self.spawnWaitTimer = self.spawnWaitTimer - dt
        if self.spawnWaitTimer <= 0 then
            local ok, wait = coroutine.resume(self.spawnCo)
            if coroutine.status(self.spawnCo) == "dead" then
                self.spawnCo = nil
            else
                self.spawnWaitTimer = wait or 0
            end
        end
        return
    end

    if self:spawnRemaining() <= 0 then return end -- roster spent for this round

    self.spawnIdleTimer = self.spawnIdleTimer - dt
    if self.spawnIdleTimer > 0 then return end

    local clumpDef = pickClumpSize()
    local clump = self:takeClump(clumpDef.size)
    if #clump == 0 then return end

    self.spawnHeat = self.spawnHeat + clumpDef.heat
    -- difficulty still tightens the base pace, same intent your old interval
    -- formula had; heat still forces a longer breather after a big clump
    self.spawnIdleTimer = math.max(0.3, 4 + self.spawnHeat * 0.3 - self.difficulty * 0.15)

    self.spawnCo = coroutine.create(function()
        for i, enemyName in ipairs(clump) do
            local random = math.random(1,2)
            local facing = true
            if random == 2 then facing = false end
            self:newEnemy(enemyName, math.random(200,window.GameWidth-200), window.GameHeight+30, facing)
            if i < #clump then coroutine.yield(0.15) end -- stagger within the clump
        end
    end)
    self.spawnWaitTimer = 0
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

--Report system
function EnemyHandler:onHit()
    game.lookouts[1].Report:action("shotHit")
end

function EnemyHandler:onDamage(damage)
    game.lookouts[1].Report:action("damageDealt", damage)
end

function EnemyHandler:onKilled()
    game.lookouts[1].Report:action("enemyKilled")
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
    self:updateSpawning(dt)
    
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
    for i, explosion in pairs(self.Explosions) do
        explosion:draw()
    end
    for i, damagePopup in pairs(self.damagePopups) do
        damagePopup:draw()
    end
end


return EnemyHandler