local map = {
    map = nil,
    camera = {x=0,y=0},
    cameraYMax = 300,
    cameraYMin = 0,
}

function map:getVariables(node)
    local seed = node.seed
    local generation = node.nodeY
    local artifact = false

    local returnTbl = {
        artifacts = {},
        enemies = {},
        difficulty = generation,
        color = {1,1,1,1},
        images = {},
        isEndnode = false
    }

    --get a random check to see if it becomes a artifact node
    local random = math.random(1,10)
    if random < 7 then 
        artifact = true
        returnTbl.artifacts = {3,1}
        returnTbl.color = {.3,.3,.2,1}
    end

    
    if artifact then generation = generation + 1 returnTbl.difficulty = generation end
    local enemies = EnemyHandler.decodeSeed(seed,generation)

    local generator = love.math.newRandomGenerator(seed)

    --get background
    local random = generator:random(1,#self.backgrounds)
    returnTbl.images.background = self.backgrounds[random]
    returnTbl.images.clouds = self.clouds[random % 2]

    returnTbl.enemies = enemies

    --if end node then get special artifact and boss enemy
    if node.isEndNode then
        returnTbl.artifacts = {3,2}
        returnTbl.enemies = {}
        table.insert(returnTbl.enemies,"Nest")
        returnTbl.color = {.3,.5,.2,1}
    end

    --create description
    returnTbl.description = "Enemies " .. #returnTbl.enemies
    
    if #returnTbl.artifacts > 0 then
        returnTbl.description = returnTbl.description .. " /nHas an artifact"
    end

    
    return returnTbl
end

function map:nodeClicked(variables,seed)
    local enemies = variables.enemies
    local difficulty = variables.difficulty
    local artifacts = variables.artifacts
    local images = variables.images
    local isEndnode = variables.isEndnode

    --Stop any sounds that were playing
    love.audio.stop()

    game:createLookout(seed,difficulty,artifacts,images)

    if isEndnode then
        self.map:expand()
    end

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
        [3] = assetloader:getImage("night_sky_background"),
    }
    self.clouds = {
        [1] = assetloader:getImage("background_clouds_night"),
        [2] = assetloader:getImage("background_clouds_layer1"),
    }
    if not settings.loadMap then
        return
    end
    self.map = Map.new(game.seed,3,9,self)
end

function map:update(dt)
    tab:update(dt)

    if love.keyboard.isDown("up") or wheelUp then
        local offsetY = 100
        self.camera.y = math.max(self.camera.y - 5000 * dt,self.map.maxHeight-offsetY)
    elseif love.keyboard.isDown("down") or wheelDown then
        self.camera.y = math.min(self.camera.y + 5000 * dt,self.cameraYMin)
    end

    self.map:update(dt,self.camera)
end

function map:draw()

    love.graphics.push()
    love.graphics.translate(-self.camera.x,-self.camera.y)

    love.graphics.setColor(.1,.1,.1,1)
    love.graphics.rectangle("fill",0,window.GameHeight,window.GameWidth,-window.GameHeight*10)

    self.map:draw(self.camera)

    love.graphics.pop()

    tab:draw()


    drawCursor()
end

return map