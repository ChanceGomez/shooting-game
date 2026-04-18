local shop = {
    buttons = {},
    isArtifact = false,
    artifacts = {},
    maxAmmoLevel = 0,
    maxAmmoCost = 0,
    damageLevel = 0,
    damageCost = 0,
    reloadRateLevel = 0,
    reloadRateCost = 0,
    maxLevel = 5,
}


function shop:displayArtifacts(artifacts)
    self.artifacts = {}
    self.isArtifact = true
    self.skipArtifactButton.visible = true

    --positioning variables
    local totalWidth = 0
    local margin = 16

    for i = 1, #artifacts do
        local artifact = deepCopy(artifacts[i])
        local width = artifact.width

        totalWidth = totalWidth + width + margin
        --Change x to correct pos
        artifact.x = window.GameWidth/2 - width/2 + ((width+margin) * i)
        artifact.y = window.GameHeight/2 - width/2

        --create clicked function
        artifact.clicked = function()
            artifact:add()
            self:artifactClicked()
        end
        
        --Insert artifact into the artifacts table
        table.insert(self.artifacts,Button.new({
            x = artifact.x,
            y = artifact.y,
            width = artifact.width,
            height = artifact.height,
            image = artifact.image,
            description = artifact.description,
            isText = false,
            color = {1,1,1,1},
            clicked = function()
                artifact:add()
                self:artifactClicked()
            end,
            updateText = function(self)
                return artifact.updateText(self)
            end,
        }))
    end

    --change position accordingly
    local midPoint = window.GameWidth/2
    local startPoint = midPoint - totalWidth/2
    for i, artifact in ipairs(self.artifacts) do
        artifact.x = startPoint + ((i-1) * (artifact.width+margin))
    end
end

function shop:drawArtifactSelection()
    --draw artifact if in artifact selection
    if self.isArtifact then
        --draw grayed out background
        love.graphics.setColor(.1,.1,.1,1)
        love.graphics.rectangle("fill",0,0,window.GameWidth,window.GameHeight)

        --draw the text
        love.graphics.setColor(1,1,1,1)
        local font = perfect_dos_32
        local text = "Choose an Artifact:"
        love.graphics.setFont(perfect_dos_32)
        love.graphics.print(text,window.GameWidth/2-(font:getWidth(text)/2),64)


        --draw artifacts
         for i, artifact in ipairs(self.artifacts) do
            artifact:draw()
        end
        --draw skip button
        self.skipArtifactButton:draw()
        --Infopanel
        for i, artifact in ipairs(self.artifacts) do
            if collision.rect(artifact) then
                infopanel:draw(artifact)
            end
        end
    end
end

function shop:artifactClicked()
    if self.isArtifact then
        self.artifacts = {}
        self.isArtifact = false
    end
end

function shop:load()
    self.Scene = "none"
    self.Scenes = {
        none = {
            draw = function() end,
            load = function() end,
            update = function(dt) end,
        },
        buyequipment = {
            draw = function() buyequipment:draw() end,
            load = function(x,y,width,height) buyequipment:load(x,y,width,height) end,
            update = function(dt) buyequipment:update(dt) end,
        },
        upgradebullet = {
            draw = function() upgradebullet:draw() end,
            load = function(x,y,width,height) upgradebullet:load(x,y,width,height) end,
            update = function(dt) upgradebullet:update(dt) end,
        },
        upgradedud = {
            draw = function() upgradedud:draw() end,
            load = function(x,y,width,height) upgradedud:load(x,y,width,height) end,
            update = function(dt) upgradedud:update(dt) end,
        },
        upgradegrenade = {
            draw = function() upgradegrenade:draw() end,
            load = function(x,y,width,height) upgradegrenade:load(x,y,width,height) end,
            update = function(dt) upgradegrenade:update(dt) end,
        },
    }
    --load sub-scenes
    for i, scene in pairs(self.Scenes) do
        scene.load(140,48,480,220)
    end
    --This button is seperate from other buttons so it can be drawn 
    -- above the tint layer in artifact selection
    self.skipArtifactButton = Button.new({
        x = window.GameWidth/2-64,
        y = 300,
        width = 128,
        height = 32,
        description = {
            text = "Skip"
        },
        clicked = function()
            self:artifactClicked()
        end,
    })

    --Sub scene buttons
    self.buttons.buyEquipment = Button.new({
        x = 10,
        y = 48,
        width = 128,
        height = 32,
        colors = {
            normal = {.3,.3,.3,1},
            hovered = {.5,.5,.5,1},
        },
        description = {
            text = "Buy Equipment"
        },
        clicked = function()
            if self.Scene == "buyequipment" then
                self.Scene = "none"
                return
            end
            self.Scene = "buyequipment"
        end,
    })

    self.buttons.upgradeBullet = Button.new({
        x = 10,
        y = 84,
        width = 128,
        height = 32,
        colors = {
            normal = {.3,.3,.3,1},
            hovered = {.5,.5,.5,1},
        },
        description = {
            text = "Upgrade Bullet"
        },
        clicked = function()
            if self.Scene == "upgradebullet" then
                self.Scene = "none"
                return
            end
            self.Scene = "upgradebullet"
        end,
    })

    self.buttons.upgradeDud = Button.new({
        x = 10,
        y = 120,
        width = 128,
        height = 32,
        colors = {
            normal = {.3,.3,.3,1},
            hovered = {.5,.5,.5,1},
        },
        description = {
            text = "Upgrade Dud"
        },
        clicked = function()
            if self.Scene == "upgradedud" then
                self.Scene = "none"
                return
            end
            self.Scene = "upgradedud"
        end,
    })

    self.buttons.upgradeGrenade = Button.new({
        x = 10,
        y = 156,
        width = 128,
        height = 32,
        colors = {
            normal = {.3,.3,.3,1},
            hovered = {.5,.5,.5,1},
        },
        description = {
            text = "Upgrade Grenade"
        },
        clicked = function()
            if self.Scene == "upgradegrenade" then
                self.Scene = "none"
                return
            end
            self.Scene = "upgradegrenade"
        end,
    })

    if settings.loadShopOnStart then
        --self:displayArtifacts(artifacts:getAllArtifacts())
        self:displayArtifacts(artifacts:getUniqueArtifacts(5,2))
    end
end

function shop:update(dt)
    if rClick and settings.debug then
        self:displayArtifacts(artifacts:getUniqueArtifacts(10))
    end
    --update sub scenes
    self.Scenes[self.Scene]:update(dt)

    --draw buttons
    if not self.isArtifact then
        Button.updateAll(self.buttons)
        tab:update(dt)
    else
        for i, artifact in ipairs(self.artifacts) do
            artifact:update()
        end
        self.skipArtifactButton:update()
    end
end

function shop:draw()
    love.graphics.setBackgroundColor(.1,.1,.1,1)

     --draw sub scenes
    self.Scenes[self.Scene]:draw()

    --draw resource count
    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(perfect_dos_16)
    local text = "Resources: " .. game.Player.resources
    local font = perfect_dos_16

    love.graphics.print(text,window.GameWidth-font:getWidth(text)-4,28)

    --draw tab
    tab:draw()

    Button.drawAll(self.buttons)

    --draw artifacts
    self:drawArtifactSelection()

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(assetloader:getImage("cursor"),CursorX,CursorY)
end


return shop