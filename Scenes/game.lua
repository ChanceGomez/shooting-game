local game = {
    Player = nil,
    Enemies = {},
    lookouts = {},
    scene = 1,
    camera = { x = 0, y = 0 }
}

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

function game:load()
  self.canvas = love.graphics.newCanvas(Width,Height)
  self.Player = Player:new()
  self.Player:ChangeGun("pistol")
  table.insert(self.lookouts, Lookout:new())
end

function game:update(dt)
  --update player
    if self.Player then
        self.Player:update(dt)
    end
    for i, enemy in pairs(self.Enemies) do
        enemy:update(dt)
    end

    --Update lookouts
    for i, lookout in pairs(self.lookouts) do
        lookout:update(dt)
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