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
    maxLevel = 10,
}


--Get the artifacts and insert them into the artifacts table
function shop:getArtifact(amountOfArtifacts)
    local amountOfArtifacts = amountOfArtifacts or 3 -- amount of artifacts to create

    self.artifacts = {} -- reset table to empty just in case
    self.isArtifact = true -- Shop is now in artifact selection

    --positioning variables
    local totalWidth = 0
    local margin = 16

    -- Create all artifacts 
    for i = 0, amountOfArtifacts-1 do
        local artifact = deepCopy(artifacts:getRandomArtifact()) -- Create a deep copy to avoid references
        local width = artifact.width
        
        totalWidth = totalWidth + width + margin
        --Change x to correct pos
        artifact.x = Width/2 - width/2 + ((width+margin) * i)
        artifact.y = Height/2 - width/2

        --Insert artifact into the artifacts table
        table.insert(self.artifacts,artifact)
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

        --Draw all the artifacts
        button:drawAll(self.artifacts)

        --draw skip button
        button:draw(self.skipArtifactButton)
        --Infopanel
        for i, artifact in ipairs(self.artifacts) do
            if collision.rect(artifact) then
                infopanel:draw(artifact)
            end
        end


    end
end

function shop:loadShop()
    self:getArtifact()
    if game.round % 3 == 0 then
        self:getArtifact()
    end
end

function shop:upgradeClicked()
    --update costs
    self.maxAmmoCost = 5*(self.maxAmmoLevel+1)
    self.damageCost = 5*(self.damageLevel+1)
    self.reloadRateCost = 5*(self.reloadRateLevel+1)

    --update descriptions
    self.buttons["increase_maxAmmo"].description = "Upgrade the max ammo of your gun, Cost: " .. self.maxAmmoCost
    self.buttons["increase_damage"].description = "Upgrade the damage of your gun, Cost: " .. self.damageCost
    self.buttons["increase_reloadRate"].description = "Upgrade the reload rate of your gun, Cost: " .. self.reloadRateCost
end

function shop:artifactClicked()
    if self.isArtifact then
        self.artifacts = {}
        self.isArtifact = false
    end
end

function shop:load()
    if settings.loadShopOnStart then
        self:loadShop()
    end
    self.buttons["next_day"] = {
        x = 640-138,
        y = 360-58,
        image = al:getImage("nextday_button"),
        visible = true,
        clicked = function()
            game.round = game.round + 1
            table.remove(game.lookouts)

            table.insert(game.lookouts,Lookout:new(roundscript:getData(game.round,settings.difficulty)))

            Scene = "game"
        end,
    }
    self.skipArtifactButton = {
        x = Width/2 - al:getImage("skipartifact_button"):getWidth()/2,
        y = 300,
        image = al:getImage("skipartifact_button"),
        visible = self.isArtifact,
        clicked = function()
            self:artifactClicked()
        end
    }

    --max ammo
    self.buttons["increase_maxAmmo"] ={
        x = 70,
        y = 70,
        image = al:getImage("add_button"),
        visible = true,
        description = "Upgrade the max ammo of your gun, Cost: " .. self.maxAmmoCost,
        clicked = function()
            self:upgradeClicked()
            if self.maxAmmoLevel >= self.maxLevel then return end
            if game.Player.resources >= self.maxAmmoCost then
                game.Player.resources = game.Player.resources - self.maxAmmoCost
            else
                return
            end
            self.maxAmmoLevel = self.maxAmmoLevel + 1
            game.Player.gun:increaseMaxAmmo(1)
        end
    }

    self.buttons["increase_damage"] = {
        x = 70,
        y = 70+32,
        image = al:getImage("add_button"),
        visible = true,
        description = "Upgrade the damage of your gun, Cost: " .. self.damageCost,
        clicked = function()
            self:upgradeClicked()
            if self.damageLevel >= self.maxLevel then return end
            if game.Player.resources >= self.damageCost then
                game.Player.resources = game.Player.resources - self.damageCost
            else
                return
            end
            self.damageLevel = self.damageLevel + 1
            game.Player.gun:increaseDamage(1)
        end
    }

    self.buttons["increase_reloadRate"] ={
        x = 70,
        y = 70+64,
        image = al:getImage("add_button"),
        visible = true,
        description = "Upgrade the reload rate of your gun, Cost: " .. self.reloadRateCost,
        clicked = function()
            self:upgradeClicked()
            if self.reloadRateLevel >= self.maxLevel then return end
            if game.Player.resources >= self.reloadRateCost then
                game.Player.resources = game.Player.resources - self.reloadRateCost
            else
                return
            end
            self.reloadRateLevel = self.reloadRateLevel + 1
            game.Player.gun:increaseReloadRate(.15)
        end
    }

    self:upgradeClicked()
end

function shop:update()
    if self.isArtifact then 
        button:updateAll(self.artifacts)
        button:update(self.skipArtifactButton)
    else
        button:updateAll(self.buttons)
    end
end

function shop:draw()
    love.graphics.setBackgroundColor(.1,.1,.1,1)

    button:drawAll(self.buttons)

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
    love.graphics.print("Resources: " .. game.Player.resources,640-128,10)

    for i, button in pairs(self.buttons) do
        if button.description and collision.rect(button) then
            infopanel:draw(button)
        end
    end

    --draw artifacts
    self:drawArtifactSelection()

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(al:getImage("cursor"),CursorX,CursorY)
end


return shop