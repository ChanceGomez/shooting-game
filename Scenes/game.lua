local game = {
    Player = nil,
    Observer = Observer:new(),
    lookouts = {},
    scene = 1,
    camera = { x = 0, y = 0 },
    round = 4,
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

function game:sceneUp()
    if self.scene > 1 then
        self.scene = self.scene - 1
        tweenTo(self.camera,.5,"linear",Width*(self.scene-1),0)
    end
end

function game:sceneDown()
    if self.scene < 2 then
        self.scene = self.scene + 1
        tweenTo(self.camera,.5,"linear",Width*(self.scene-1),0)
    end
end

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

    --observer
    game.Observer:trigger("update")
  --update player
    if self.Player then
        self.Player:update(dt)
    end

    --Update lookouts
    self.lookouts[1]:update(dt)

    if rClick then
        self:endRound()
    end

    if left then
        self:sceneUp()
    elseif right then
        self:sceneDown()
    end
end

function game:draw()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()

    love.graphics.setBackgroundColor(0.1,0.1,0.1)

    love.graphics.push()
    love.graphics.translate(-self.camera.x,-self.camera.y)

    --Draw lookouts
    self.lookouts[1]:draw()

    love.graphics.pop()

    love.graphics.setCanvas(mainCanvas)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.canvas)
end

return game