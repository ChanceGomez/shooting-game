local difficultyselction = {
    buttons = {}
}


function difficultyselction:load()
    self.buttons.easy = {
        x = Width/2 - al:getImage("button_easy"):getWidth(),
        y = 128,
        visible = true,
        image = al:getImage("button_easy"),
        clicked = function()
            settings.difficulty = 'easy'
            Scene = "game"
            game.round = 1
        end,
        description = {
            text = "Easy mode",
        },
    }
end

function difficultyselction:update(dt)
    button:updateAll(self.buttons)

    if escapeClick then 
        Scene = "title"
    end
end

function difficultyselction:draw()
    love.graphics.setBackgroundColor(.1,.1,.1,1)

    --Text
    love.graphics.setColor(1,1,1,1)
    local font = perfect_dos_32
    local text = "Select Difficulty:"
    love.graphics.setFont(perfect_dos_32)
    love.graphics.print(text,Width/2-(font:getWidth(text)/2),48)

    --draw buttons
    button:drawAll(self.buttons)
    --infopanel for buttons
    for i, button in pairs(self.buttons) do
        if collision.rect(button) then
            infopanel:draw(button)
        end
    end

    --Cursor
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(al:getImage("cursor"),CursorX,CursorY)
end


return difficultyselction