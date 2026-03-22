local map = {
    map = nil,
    camera = {x=0,y=0},
}

function map:getEnemies(generation,seed)
    local enemies = {}
    local difficulty = math.max(generation,1)
    local generator = love.math.newRandomGenerator(seed)

    local enemyCount = generator:random(math.floor(5+(generation/2)),10+generation)

    for i = 1, enemyCount do
        local random = generator:random(1,100)
        local enemy = "Bird"
        
        if random < 5 + (generation*5) then
            enemy = "BigBird"
        end

        if random < -20 + (generation*10) then
            enemy = "InfectedBird"
        end

        if random < -20 + (generation*5) then
            enemy = "BigInfectedBird"
        end
        table.insert(enemies,enemy)
    end

    local random = math.random(1,10)
    local isArtifact = false
    if random < 3 then
        isArtifact = true
    end

    return enemies,isArtifact
end

function map:nodeClicked(enemies,difficulty,isArtifact,isEndNode)
    game:createLookout(enemies,difficulty,isArtifact)

    Scene = "game"

    if isEndNode then
        self.map = Map:new(0,3,20,self)
    end
end

function map:load()
    self.map = Map:new(0,3,15,self)
end

function map:update(dt)
    if love.keyboard.isDown("up") then
        self.camera.y = self.camera.y - 100 * dt
    elseif love.keyboard.isDown("down") then
        self.camera.y = self.camera.y + 100 * dt
    end

    self.map:update(dt,self.camera)
end

function map:draw()
    love.graphics.push()
    love.graphics.translate(-self.camera.x,-self.camera.y)

    love.graphics.setBackgroundColor(.1,.1,.1)

    self.map:draw()

    love.graphics.pop()

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(al:getImage("cursor"), math.floor(CursorX),math.floor(CursorY))
end

return map