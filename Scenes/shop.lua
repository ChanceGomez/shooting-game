local shop = {
    buttons = {},
    isArtifact = false,
    artifact = nil,
    maxAmmoLevel = 0,
    maxAmmoCost = 0,
    damageLevel = 0,
    damageCost = 0,
    reloadRateLevel = 0,
    reloadRateCost = 0,
    maxLevel = 10,
}



function shop:displayArtifact()
    self.isArtifact = true
    local artifact = artifacts:getRandomArtifact()
    artifact.x = Width/2 - artifact.image:getWidth()/2
    artifact.y = Height/2 - artifact.image:getHeight()/2
    self.artifact = artifact
end

function shop:loadShop()
    self:displayArtifact()
    if game.round % 3 == 0 then
        self:displayArtifact()
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
    if self.artifact then
        self.artifact = nil
    end
end

function shop:load()
    table.insert(self.buttons,{
        x = 640-138,
        y = 360-58,
        image = al:getImage("nextday_button"),
        visible = true,
        clicked = function()
            game.round = game.round + 1
            table.remove(game.lookouts)

            table.insert(game.lookouts,Lookout:new(roundscript:getData(game.round)))

            Scene = "game"
        end,
    })
    self:loadShop()

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
            if game.Player.resources > self.maxAmmoCost then
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
            if game.Player.resources > self.damageCost then
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
            if game.Player.resources > self.reloadRateCost then
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
    if self.artifact then 
        button:update(self.artifact)
    else
        button:updateAll(self.buttons)
    end
end

function shop:draw()
    love.graphics.setBackgroundColor(.1,.1,.1,1)

    button:drawAll(self.buttons)

    --text
    love.graphics.setFont(perfect_dos_32)
    love.graphics.print("Upgrades",60,25)

    --draw artifact if artifact
    if self.artifact then
        love.graphics.setColor(.3,.3,.3,.8)
        love.graphics.rectangle("fill",0,0,Width,Height)
        button:draw(self.artifact)
        if collision.rect(self.artifact) then
            infopanel:draw(self.artifact)
        end
    end


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


    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(al:getImage("cursor"),CursorX,CursorY)

    for i, button in pairs(self.buttons) do
        if button.description and collision.rect(button) then
            infopanel:draw(button)
        end
    end
end


return shop