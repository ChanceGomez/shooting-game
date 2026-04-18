local endofround = {
    report = nil,
    buttons = {},
    resourcesEarned = 0,
}

function endofround:getReport(report,artifacts)
    game.Player.gun.ammo = {}
    self.report = report
    self.artifacts = artifacts
end

function endofround:load()
    local endshiftImage = assetloader:getImage("endshift_button")
    self.endRoundButton = Button.new({
        x = 0,
        y = window.GameHeight-32,
        width = 128,
        height = 32,
        description = {
            text = "End Round",
        },
        visible = true,
        clicked = function()
            Scene = "shop"
            if #self.artifacts > 0 then
                shop:displayArtifacts(self.artifacts)
            end
        end,
    })
end

function endofround:update()
    self.endRoundButton:update()
end

function endofround:draw()
    love.graphics.setBackgroundColor(.1,.1,.1,1)

    if self.report then
        local x = 5
        local report = self.report
        love.graphics.setColor(1,1,1,1)
        love.graphics.setFont(perfect_dos_16)
        love.graphics.print("Damage Dealt: " .. report.damageDealt,x,5)
        love.graphics.print("Enemies Killed: " .. report.enemyKilled,x,25)
        love.graphics.print("Shots Fired: " .. report.shotFired,x,45)
        love.graphics.print("Bullets Loaded: " .. report.loadedBullet,x,65)
        love.graphics.print("Bullets Discarded: " .. report.discardedBullet,x,85)
        love.graphics.print("Shots hit: " .. report.shotHit,x,105)
        love.graphics.setFont(perfect_dos_32)
        love.graphics.print("Resources Earned: " .. report.resources,x,155)


    end

    self.endRoundButton:draw()


    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(assetloader:getImage("cursor"),CursorX,CursorY)
end



return endofround