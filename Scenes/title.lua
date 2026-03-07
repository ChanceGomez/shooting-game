local title = {
    buttons = {},
}

function title:load()
    table.insert(self.buttons,{
        x = 24,
        y = 300,
        color = {1,1,1,1},
        image = al:getImage("button_agree"),
        hoveredImage = al:getImage("button_agree_hovered"),
        width = al:getImage("button_agree"):getWidth(),
        height = al:getImage("button_agree"):getHeight(),
        visible = true,
        description = "Start the game",
        clicked = function()
            Scene = "difficultyselection"
        end
    })
end

function title:update(dt)
    button:updateAll(self.buttons)
end

function title:draw()
    
    
    love.graphics.setBackgroundColor(.1,.1,.1,1)
    
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(al:getImage("background_title_text"))


    button:drawAll(self.buttons)
    

    --Cursor
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(al:getImage("cursor"),CursorX,CursorY)
end

return title