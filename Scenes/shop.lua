local shop = {
    buttons = {},
    isUpgrade = false,
    upgrade = nil,
}



function shop:displayUpgrade()
    self.isUpgrade = true
    local upgrade = upgrades:getRandomUpgrade()
    upgrade.x = 100
    upgrade.y = 100
    self.upgrade = upgrade
end

function shop:loadShop()
    self:displayUpgrade()
    if game.round % 5 == 0 then
        self:displayUpgrade()
    end
end

function shop:upgradeClicked()
    if self.upgrade then
        self.upgrade = nil
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
end

function shop:update()
    button:updateAll(self.buttons)
    if self.upgrade then 
        button:update(self.upgrade)
    end
end

function shop:draw()
    love.graphics.setBackgroundColor(.1,.1,.1,1)

    button:drawAll(self.buttons)

    --text
    love.graphics.setFont(perfect_dos_32)
    love.graphics.print("Upgrades",60,25)

    --draw upgrade if upgrade
    if self.upgrade then
        button:draw(self.upgrade)
        if collision.rect(self.upgrade) then
            infopanel:draw(self.upgrade)
        end
    end

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(al:getImage("cursor"),CursorX,CursorY)
end


return shop