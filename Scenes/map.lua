local map = {
    map = nil,
    camera = {x=0,y=0},
}

function map:getVariables(node)
    local enemies = {}
    local generation = node.nodeY
    local seed = node.seed 
    local generator = love.math.newRandomGenerator(seed)

    local returnTbl = {
        artifacts = {},
        enemies = {},
        difficulty = generation,
        color = {1,1,1,1},
    }

    --get a random check to see if it becomes a artifact node
    local random = math.random(1,10)
    if random < 3 then 
        table.insert(returnTbl.artifacts,artifacts:getRandomArtifact(1))
        table.insert(returnTbl.artifacts,artifacts:getRandomArtifact(1))
        table.insert(returnTbl.artifacts,artifacts:getRandomArtifact(1))
        returnTbl.color = {.3,.3,.2,1}
    end

    local enemyCount = generator:random(math.floor(5+(generation/2)),10+generation)

    if node.isEndNode then
        enemyCount = enemyCount * 2
    end

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
        table.insert(returnTbl.enemies,enemy)
    end

    --if end node then get special artifact
    if node.isEndNode then
        --reset table
        returnTbl.artifacts = {}
        table.insert(returnTbl.artifacts,artifacts:getRandomArtifact(2))
        table.insert(returnTbl.artifacts,artifacts:getRandomArtifact(2))
        table.insert(returnTbl.artifacts,artifacts:getRandomArtifact(2))

        returnTbl.color = {.3,.5,.2,1}
    end

    --create description
    returnTbl.description = "Enemies " .. #returnTbl.enemies 
    
    if #returnTbl.artifacts > 0 then
        returnTbl.description = returnTbl.description .. " /nHas Artifact"
    end

    return returnTbl
end

function map:nodeClicked(variables)
    local enemies = variables.enemies
    local difficulty = variables.difficulty
    local artifacts = variables.artifacts
    game:createLookout(enemies,difficulty,artifacts)

    Scene = "game"
end

function map:load()
    self.map = Map:new(0,3,9,self)
end

function map:update(dt)
    tab:update(dt)

    if love.keyboard.isDown("up") or wheelUp then
        self.camera.y = self.camera.y - 5000 * dt
    elseif love.keyboard.isDown("down") or wheelDown then
        self.camera.y = self.camera.y + 5000 * dt
    end

    self.map:update(dt,self.camera)
end

function map:draw()

    love.graphics.push()
    love.graphics.translate(-self.camera.x,-self.camera.y)

    love.graphics.setBackgroundColor(.1,.1,.1)

    self.map:draw(self.camera)

    love.graphics.pop()

    tab:draw()


    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(al:getImage("cursor"), math.floor(CursorX),math.floor(CursorY))
end

return map