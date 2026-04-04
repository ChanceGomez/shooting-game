local losescreen = {
    buttons = {},
}

function losescreen:load()
    table.insert(self.buttons,Button.new({
        visible = true,
        clicked = function()
            Scene = "title"
        end,
        width = 128,
        height = 48,
        x = 640-128-4,
        y = 360-48-4,
        description = {
            text = "try again?",
        },
    }))
end

function losescreen:update(dt)
    for i, button in ipairs(self.buttons) do
        button:update(dt)
    end
end

function losescreen:draw()
    love.graphics.setBackgroundColor(.1,.1,.1,1)
    love.graphics.setFont(dogica_64)
    love.graphics.setColor(1,1,1,1)
    love.graphics.print("Lost",4,4)

    for i, button in ipairs(self.buttons) do
        button:draw()
    end


    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(assetloader:getImage("cursor"),CursorX,CursorY)
end

return losescreen