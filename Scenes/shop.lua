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
        artifact.x = Width/2 - width/2 + ((width+margin) * i)
        artifact.y = Height/2 - width/2

        --create clicked function
        artifact.clicked = function()
            artifact:add()
            self:artifactClicked()
        end

        --Insert artifact into the artifacts table
        table.insert(self.artifacts,Button:new({
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
            end
        }))
    end

    --change position accordingly
    local midPoint = Width/2
    local startPoint = midPoint - totalWidth/2
    for i, artifact in ipairs(self.artifacts) do
        artifact.x = startPoint + ((i-1) * (artifact.width+margin))
    end
end

function shop:drawArtifactSelection()
    --draw artifact if in artifact selection
    if self.isArtifact then
        --draw grayed out background
        love.graphics.setColor(.1,.1,.1,.9)
        love.graphics.rectangle("fill",0,0,Width,Height)

        --draw the text
        love.graphics.setColor(1,1,1,1)
        local font = perfect_dos_32
        local text = "Choose an Artifact:"
        love.graphics.setFont(perfect_dos_32)
        love.graphics.print(text,Width/2-(font:getWidth(text)/2),64)


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

function shop:loadShop()

end

function shop:artifactClicked()
    if self.isArtifact then
        self.artifacts = {}
        self.isArtifact = false
    end
end

function shop:load()
    --This button is seperate from other buttons so it can be drawn 
    -- above the tint layer in artifact selection
    self.skipArtifactButton = Button:new({
        x = Width/2-64,
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

    --[[

    self.buttons["increase_health"] = Button:new({
        x = 500,
        y = 70,
        level = 1,
        maxLevel = 50,
        cost = 10,
        image = assetloader:getImage("add_button"),
        visible = true,
        description = {text = ""},
        clicked = function(self)
            if game.Player.health >= 3 then
                --return
            end
            if game.Player.resources >= self.cost then
                game.Player.health = game.Player.health + 1
                game.Player.resources = game.Player.resources - self.cost
                self.cost = self.cost * 3
            end            
        end,
        updateText = function(self)
            self.description.text = "Increase Health /n"
            
            self.description.text = self.description.text .. " /nCost: " .. self.cost

            return self.description.text
        end 
    })
    ]]
    --[[
    self.buttons["increase_health"] = {
        x = 500,
        y = 70,
        level = 1,
        maxLevel = 50,
        cost = 10,
        image = assetloader:getImage("add_button"),
        visible = true,
        description = {text = ""},
        clicked = function(self)
            if game.Player.health >= 3 then
                --return
            end
            if game.Player.resources >= self.cost then
                game.Player.health = game.Player.health + 1
                game.Player.resources = game.Player.resources - self.cost
                self.cost = self.cost * 3
            end            
        end,
        updateText = function(self)
            self.description.text = "Increase Health /n"
            
            self.description.text = self.description.text .. " /nCost: " .. self.cost

            return self.description.text
        end
    }

    --upgrades
    self.buttons["increase_maxAmmo"] ={
        x = 70,
        y = 70,
        image = assetloader:getImage("add_button"),
        visible = true,
        ids = {
            {"Max Ammo","add",1},
        },
        level = 0,
        maxLevel = 50,
        cost = 5,
        description = {text = ""},
        clicked = function(self)
            if self.level >= self.maxLevel then return end
            if game.Player.resources >= self.cost then
                game.Player.resources = game.Player.resources - self.cost
                self.cost = self.cost * 2
            else
                return
            end
            self.level = self.level + 1
            game.Affector:addIDs(self.ids)
        end,
        updateText = function(self)
            self.description.text = "Upgrade max ammo " 
            local ids = self.ids
            
            if self.level >= self.maxLevel then
                self.description.text = self.description.text .. "/nCost: " .. "{.1,.1,.4,1}Maxed {.1,.1,.4,1}Out"
                return self.description.text .. " /n " .. game.Affector:getStats(ids)
            else
                self.description.text = self.description.text .. "/nCost: " .. self.cost
                return self.description.text .. " /n " .. game.Affector:getDescription(ids)
            end
        end,
    }

    self.buttons["increase_damage"] = {
        x = 70,
        y = 70+32,
        image = assetloader:getImage("add_button"),
        visible = true,
        description = {text = ""},
        ids = {
            {"Bullet Damage","add",1},
        },
        level = 0,
        maxLevel = 50,
        cost = 5,
        clicked = function(self)
            if self.level >= self.maxLevel then return end
            if game.Player.resources >= self.cost then
                game.Player.resources = game.Player.resources - self.cost
                self.cost = self.cost * 2
            else
                return
            end
            self.level = self.level + 1
            game.Affector:addIDs(self.ids)
        end,
        updateText = function(self)
            self.description.text = "Upgrade bullet damage "
            local ids = self.ids
            
            if self.level >= self.maxLevel then
                self.description.text = self.description.text .. "/nCost: " .. "{.1,.1,.4,1}Maxed {.1,.1,.4,1}Out"
                return self.description.text .. " /n " .. game.Affector:getStats(ids)
            else
                self.description.text = self.description.text .. "/nCost: " .. self.cost
                return self.description.text .. " /n " .. game.Affector:getDescription(ids)
            end
        end,
    }

    self.buttons["increase_reloadRate"] ={
        x = 70,
        y = 70+64,
        image = assetloader:getImage("add_button"),
        visible = true,
        ids = {
            {"Reload Rate","mult",.90},
    },
        level = 0,
        maxLevel = 50,
        cost = 5,
        description = {text = ""},
        clicked = function(self)
            if self.level >= self.maxLevel then return end
            if game.Player.resources >= self.cost then
                game.Player.resources = game.Player.resources - self.cost
                self.cost = self.cost * 2
            else
                return
            end
            self.level = self.level + 1
            game.Affector:addIDs(self.ids)
        end,
        updateText = function(self)
            self.description.text = "Upgrade the reload rate of your gun "  
            local ids = self.ids

            if self.level >= self.maxLevel then
                self.description.text = self.description.text .. "/nCost: " .. "{.1,.1,.4,1}Maxed {.1,.1,.4,1}Out"
                return self.description.text .. " /n " .. game.Affector:getStats(ids)
            else
                self.description.text = self.description.text .. "/nCost: " .. self.cost
                return self.description.text .. " /n " .. game.Affector:getDescription(ids)
            end
        end,
    }

    self.buttons["increase_fireRate"] ={
        x = 70,
        y = 70+96,
        image = assetloader:getImage("add_button"),
        visible = true,
        ids = {
            {"Fire Rate","mult",.90},
        },
        level = 0,
        maxLevel = 50,
        cost = 5,
        description = {text = ""},
        clicked = function(self)
            if self.level >= self.maxLevel then return end
            if game.Player.resources >= self.cost then
                game.Player.resources = game.Player.resources - self.cost
                self.cost = self.cost * 2
            else
                return
            end
            self.level = self.level + 1
            game.Affector:addIDs(self.ids)
        end,
        updateText = function(self)
            self.description.text = "Upgrade the fire rate of your gun "  
            local ids = self.ids
            
            if self.level >= self.maxLevel then
                self.description.text = self.description.text .. "/nCost: " .. "{.1,.1,.4,1}Maxed {.1,.1,.4,1}Out"
                return self.description.text .. " /n " .. game.Affector:getStats(ids)
            else
                self.description.text = self.description.text .. "/nCost: " .. self.cost
                return self.description.text .. " /n " .. game.Affector:getDescription(ids)
            end
        end,
    }

    ]]

    if settings.loadShopOnStart then
        self:displayArtifacts(artifacts:getAllArtifacts())
    end
end

function shop:update(dt)
    tab:update(dt)

    self.skipArtifactButton:update()
    if #self.artifacts > 0 then
        for i, artifact in ipairs(self.artifacts) do
            artifact:update()
        end
    end
end

function shop:draw()
    love.graphics.setBackgroundColor(.1,.1,.1,1)

    --Upgrade text
    love.graphics.setFont(perfect_dos_32)
    love.graphics.print("Upgrades:",60,25)



    --draw upgrade
    for i = 1, self.maxAmmoLevel do
        local upgrade = self.buttons.increase_maxAmmo
        local x,y = upgrade.x,upgrade.y

        love.graphics.setColor(1,1,1,1)
        love.graphics.rectangle("fill",x+24+(i*12),y,10,24)
    end

    for i = 1, self.damageLevel do
        local upgrade = self.buttons.increase_damage
        local x,y = upgrade.x,upgrade.y

        love.graphics.setColor(1,1,1,1)
        love.graphics.rectangle("fill",x+24+(i*12),y,10,24)
    end

    for i = 1, self.reloadRateLevel do
        local upgrade = self.buttons.increase_reloadRate
        local x,y = upgrade.x,upgrade.y

        love.graphics.setColor(1,1,1,1)
        love.graphics.rectangle("fill",x+24+(i*12),y,10,24)
    end

    --draw resource count
    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(perfect_dos_16)
    local text = "Resources: " .. game.Player.resources
    local font = perfect_dos_16

    love.graphics.print(text,Width-font:getWidth(text)-4,28)

    for i, button in pairs(self.buttons) do
        if button.description and collision.rect(button) and not self.isArtifact then
            infopanel:draw(button)
        end
    end

    --draw artifacts
    self:drawArtifactSelection()

    --draw tab
    tab:draw()

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(assetloader:getImage("cursor"),CursorX,CursorY)
end


return shop