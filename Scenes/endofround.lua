local endofround = {
    report = nil,
    buttons = {},
}

function endofround:getReport(report)
    self.report = report
end

function endofround:load()
    local endshiftImage = al:getImage("endshift_button")
    table.insert(self.buttons,{
        x = Width/2-endshiftImage:getWidth()/2,
        y = 360 - endshiftImage:getHeight() - 10,
        image = endshiftImage,
        visible = true,
        clicked = function()
            Scene = "shop"
            shop:loadShop()
        end,
    })
end

function endofround:update()
    button:updateAll(self.buttons)
end

function endofround:draw()
    love.graphics.setBackgroundColor(.1,.1,.1,1)

    if self.report then
        local x = 5
        local report = self.report
        love.graphics.setColor(1,1,1,1)
        love.graphics.print("Damage Dealt: " .. report.damageDealt,x,5)
        love.graphics.print("Enemies Killed: " .. report.enemyKilled,x,25)
        love.graphics.print("Shots Fired: " .. report.shotFired,x,45)
        love.graphics.print("Bullets Loaded: " .. report.loadedBullet,x,65)
        love.graphics.print("Bullets Discarded: " .. report.discardedBullet,x,85)
        love.graphics.print("Shots hit: " .. report.shotHit,x,105)


    end

    button:drawAll(self.buttons)


    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(al:getImage("cursor"),CursorX,CursorY)
end



return endofround