local map = {
    map = nil,
    camera = {x=0,y=0},
    cameraYMax = 1000,
    cameraYMin = 0,
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

    --get background
    local random = generator:random(1,#self.backgrounds)
    returnTbl.background = self.backgrounds[random]


    --get a random check to see if it becomes a artifact node
    local random = math.random(1,10)
    if random < 2 then 
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
        
        if random < -5 + (generation*5) then
            table.insert(returnTbl,"BigBird")
        end

        if random < -20 + (generation*10) then
            
            table.insert(returnTbl,"InfectedBird")
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
    local background = variables.background

    game:createLookout(enemies,difficulty,artifacts,background)

    Scene = "game"
end

function map:activateCurrentNode()
    local node = self.map.nodes[self.map.playerLocation]
    self:nodeClicked(node.variables)
end

function map:load()
    self.backgrounds = {
        [1] = al:getImage("background_night_level1"),
        [2] = al:getImage("background_day_level2"),
    }
    self.map = Map:new(0,3,9,self)
    self.map:expand()
    self.map:expand()
    self.map:expand()
    self.map:expand()
    self.map:expand()
end

function map:update(dt)
    tab:update(dt)

    if love.keyboard.isDown("up") or wheelUp then
        self.camera.y = math.min(self.camera.y - 5000 * dt,self.cameraYMax)
    elseif love.keyboard.isDown("down") or wheelDown then
        self.camera.y = math.min(self.camera.y + 5000 * dt,self.cameraYMin)
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