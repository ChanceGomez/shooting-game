local upgradegrenade = {
    upgradeButtons = {},
}

function upgradegrenade:load(x,y,width,height)
    self.Width = width or window.GameWidth
    self.Height = height or window.GameHeight
    self.x = x or 0
    self.y = y or 0

    self.Canvas = love.graphics.newCanvas(self.Width,self.Height)

    self.upgradeButtons.damage = Button.new({
        x = 15,
        y = 20,
        width = 64,
        height = 32,
        wrapper = {
            level = 0,
            maxLevel = 100,
            cost = 0,
            stat = "",
            id = {"Grenade Damage","add",1}
        },
        description = {text = "upgrade damage"},
        clicked = function(self)
            if self.wrapper.level < self.wrapper.maxLevel and game.Player:purchase(game.Player.grenadeDamageCost) then
                game.Player.grenadeDamageCost = game.Player.grenadeDamageCost * 2
                self.wrapper.cost = game.Player.grenadeDamageCost
                self.wrapper.level = self.wrapper.level + 1
                game.Affector:addID(self.wrapper.id)
            end
        end,
        updateText = function(self)
            self.wrapper.cost = game.Player.grenadeDamageCost

            local trigger = self.wrapper.id[1]
            local ignore,afterString = game:getVariable(trigger) or ""
            afterString = afterString or ""

            local beforeStat = game.Affector:getAdd(trigger,game:getVariable(trigger))
            game.Affector:addID(self.wrapper.id)
            local afterStat = game.Affector:getAdd(trigger,game:getVariable(trigger))
            game.Affector:removeID(self.wrapper.id)

            self.wrapper.stat = trigger .. " : " .. beforeStat .. " -> " .. afterStat .. afterString
        end,
    })
    self.upgradeButtons.buyGrenade = Button.new({
        x = 15,
        y = 58,
        width = 64,
        height = 32,
        wrapper = {
            level = 3,
            maxLevel = 100,
            cost = 0,
            stat = "",
        },
        description = {text = "buy grenade"},
        clicked = function(self)
            if game.Player.grenades < game.Player.maxGrenades and game.Player:purchase(game.Affector:trigger("Grenade Cost")) then
                game.Player.grenades = game.Player.grenades + 1
            end
        end,
        updateText = function(self)
            --update cost
            self.wrapper.cost = game.Affector:trigger("Grenade Cost")
            if game.Player.grenades >= game.Player.maxGrenades then self.wrapper.stat = game.Player.grenades .. " Maxed" return end
            self.wrapper.stat = game.Player.grenades .. " -> " .. game.Player.grenades + 1
        end,
    })
    self.upgradeButtons.upgradeRadius = Button.new({
        x = 15,
        y = 96,
        width = 64,
        height = 32,
        wrapper = {
            level = 3,
            maxLevel = 100,
            cost = 0,
            stat = "",
            id = {"Grenade Radius","add",5},
        },
        description = {text = "buy grenade"},
        clicked = function(self)
            if game.Player:purchase(game.Player.grenadeRadiusCost) then
                game.Player.grenadeRadiusCost = game.Player.grenadeRadiusCost * 2
                self.wrapper.cost = game.Player.grenadeRadiusCost
                game.Affector:addID(self.wrapper.id)
            end
        end,
        updateText = function(self)
            self.wrapper.cost = game.Player.grenadeRadiusCost

            local trigger = self.wrapper.id[1]
            local ignore,afterString = game:getVariable(trigger) or ""
            afterString = afterString or ""

            local beforeStat = game.Affector:getAdd(trigger,game:getVariable(trigger))
            game.Affector:addID(self.wrapper.id)
            local afterStat = game.Affector:getAdd(trigger,game:getVariable(trigger))
            game.Affector:removeID(self.wrapper.id)

            self.wrapper.stat = trigger .. " : " .. beforeStat .. " -> " .. afterStat .. afterString
        end,
    })
end

function upgradegrenade:update(dt)
    Button.updateAll(self.upgradeButtons,nil,self.x,self.y)
end

function upgradegrenade:draw()
    local oldCanvas = love.graphics.getCanvas()

    love.graphics.setCanvas(self.Canvas)
    love.graphics.clear()

    --background
        --fill
        love.graphics.setColor(.1,.1,.1,1)
        love.graphics.rectangle("fill",0,0,self.Width,self.Height)
        --outline
        love.graphics.setColor(1,1,1,1)
        love.graphics.rectangle("line",0,0,self.Width,self.Height)

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(assetloader:getImage("background_bomb"))

    Button.drawAll(self.upgradeButtons)

    --draw stats
    local margin = 8
    local font = dogica_8

    for i, button in pairs(self.upgradeButtons) do
        local text = "Cost: " .. button.wrapper.cost .. " /n" .. button.wrapper.stat
        local x,y = button.x + button.width + margin,button.y
        customtext:draw({
            text = text,
            x = x,
            y = y,
            font = font,
        })
    end

    love.graphics.setCanvas(oldCanvas)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.Canvas,self.x,self.y)
end

return upgradegrenade