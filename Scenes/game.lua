local game = {
    Player = nil,
    Observer = Observer:new(),
    Affector = Affector:new(),
    lookouts = {},
    round = 1,
    pause = false,
}

--[[
    Get Methods
]]
function game:getHandler(lookoutNum)
    local lookoutNum = lookoutNum or 1
    return self.lookouts[lookoutNum].handler
end

function game:getReloadShelf(lookoutNum)
    local lookoutNum = lookoutNum or 1
    return self.lookouts[lookoutNum].ReloadShelf
end

function game:getPlayerGun()
    return self.Player.gun
end


----------

function game:endRound()
    endofround:getReport(self.lookouts[1].Report)
    Scene = "endofround"
end

function game:load()
  self.canvas = love.graphics.newCanvas(Width,Height)
  self.Player = Player:new()
  self.Player:ChangeGun("pistol")
  table.insert(self.lookouts, Lookout:new(self.round))
end

function game:update(dt)

    if pClick then
        game.paused = not game.paused
    end

    --observer
    game.Observer:trigger("update")
  --update player
    if self.Player then
        self.Player:update(dt)
    end

    --Update lookouts
    if not game.paused then
        self.lookouts[1]:update(dt)
    end

    --Stat panel
    statpanel:update(dt)
end

function game:draw()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()

    love.graphics.setBackgroundColor(0.1,0.1,0.1)

    --Draw lookouts
    self.lookouts[1]:draw()

    love.graphics.setCanvas(mainCanvas)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.canvas)
end

return game