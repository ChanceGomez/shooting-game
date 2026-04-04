local upgradedud = {
    upgradeButtons = {},
}

function upgradedud:load(x,y,width,height)
    self.Width = width or Width
    self.Height = height or Height
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
            cost = 50,
            stat = "",
            id = {"Dud Damage","add",1}
        },
        description = {text = "upgrade damage"},
        clicked = function(self)
            if self.wrapper.level < self.wrapper.maxLevel and game.Player:purchase(self.wrapper.cost) then
                self.wrapper.cost = self.wrapper.cost * 2
                self.wrapper.level = self.wrapper.level + 1
                game.Affector:addID(self.wrapper.id)
            end
        end,
        updateText = function(self)
            local function meow()
                return 1,"hello"
            end
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
    self.upgradeButtons.dud = Button.new({
        x = 15,
        y = 58,
        width = 64,
        height = 32,
        wrapper = {
            level = 0,
            maxLevel = 100,
            cost = 50,
            stat = "",
            id = {"Dud Chance","add",1}
        },
        description = {text = "upgrade damage"},
        clicked = function(self)
            if self.wrapper.level < self.wrapper.maxLevel and game.Player:purchase(self.wrapper.cost) then
                self.wrapper.cost = self.wrapper.cost * 2
                self.wrapper.level = self.wrapper.level + 1
                game.Affector:addID(self.wrapper.id)
            end
        end,
        updateText = function(self)
            local trigger = self.wrapper.id[1]
            local beforeStat = game.Affector:getAdd(trigger,game:getVariable(trigger))
            local ignore,afterString = game:getVariable(trigger)
            afterString = afterString or ""
            game.Affector:addID(self.wrapper.id)
            local afterStat = game.Affector:getAdd(trigger,game:getVariable(trigger))
            game.Affector:removeID(self.wrapper.id)

            self.wrapper.stat = trigger .. " : " .. beforeStat .. " -> " .. afterStat .. afterString
        end,
    })
end

function upgradedud:update(dt)
    Button.updateAll(self.upgradeButtons,nil,self.x,self.y)
end

function upgradedud:draw()
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

    love.graphics.setColor(1,0,0,1)
    love.graphics.draw(assetloader:getImage("background_bullet"))

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

return upgradedud