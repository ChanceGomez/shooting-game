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
        images = {},
    }

    --get background
    local random = generator:random(1,#self.backgrounds)
    returnTbl.images.background = self.backgrounds[random]
    returnTbl.images.clouds = self.clouds[random % 2]

    --get a random check to see if it becomes a artifact node
    local random = math.random(1,10)
    if random < 7 then 
        returnTbl.artifacts = artifacts:getUniqueArtifacts(3,1)
        returnTbl.color = {.3,.3,.2,1}
    end

    local enemyWeight = generator:random(math.floor(3+(generation/2)),5+generation)


    if node.isEndNode then
        enemyWeight = enemyWeight * 2
    end

    while enemyWeight > 0 do
        local random = generator:random(1,100)

        if random < math.min(100-(generation*5),10) then
            table.insert(returnTbl.enemies,"Bird")
            enemyWeight = enemyWeight - 1
        end
        if random < math.min((generation*5)-15,10) then
            table.insert(returnTbl.enemies,"FastBird")
            enemyWeight = enemyWeight - 2
        end
        if random < math.min((generation*5)-30,10) then
            table.insert(returnTbl.enemies,"ExplosionBird")
        end
        if random < -20 + (generation*5) then
            table.insert(returnTbl.enemies,"BigBird")
            enemyWeight = enemyWeight - 3
        end
        if random < -30 + (generation*7) then
            table.insert(returnTbl.enemies,"InfectedBird")
            enemyWeight = enemyWeight - 3
        end
        if random < -30 + (generation*4) then
            table.insert(returnTbl.enemies,"InfectedBird")
            enemyWeight = enemyWeight - 5
        end
    end


    --if end node then get special artifact and boss enemy
    if node.isEndNode then
        returnTbl.artifacts = artifacts:getUniqueArtifacts(3,2)
        returnTbl.enemies = {}
        table.insert(returnTbl.enemies,"Nest")
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
    local images = variables.images

    game:createLookout(enemies,difficulty,artifacts,images)

    Scene = "game"
end

function map:activateCurrentNode()
    local node = self.map.nodes[self.map.playerLocation]
    self:nodeClicked(node.variables)
end

function map:load()
    self.backgrounds = {
        [1] = assetloader:getImage("background_night_level1"),
        [2] = assetloader:getImage("background_day_level2"),
    }
    self.clouds = {
        [1] = assetloader:getImage("background_clouds_night"),
        [2] = assetloader:getImage("background_clouds_layer1"),
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
    love.graphics.draw(assetloader:getImage("cursor"), math.floor(CursorX),math.floor(CursorY))
end

return map