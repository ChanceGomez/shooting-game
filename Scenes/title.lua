local title = {
    buttons = {},
    backgroundImages = {},
    backgroundTimer = 0,
    backgroundInterval = 2,
    frame = 2,
}

function title:load()
    --load background images
    table.insert(self.backgroundImages,assetloader:getImage("background_title_left"))
    table.insert(self.backgroundImages,assetloader:getImage("background_title_middle"))
    table.insert(self.backgroundImages,assetloader:getImage("background_title_right"))

    table.insert(self.buttons,{
        x = 24,
        y = 300,
        color = {1,1,1,1},
        image = assetloader:getImage("button_agree"),
        hoveredImage = assetloader:getImage("button_agree_hovered"),
        width = assetloader:getImage("button_agree"):getWidth(),
        height = assetloader:getImage("button_agree"):getHeight(),
        visible = true,
        description = "Start the game",
        clicked = function()
            Scene = "difficultyselection"
        end
    })
end

function title:update(dt)
    --timer
    self.backgroundTimer = self.backgroundTimer + dt
    --buttons
    button:updateAll(self.buttons)
end

function title:draw()
    if self.backgroundTimer > self.backgroundInterval then
        self.backgroundTimer = 0
        self.frame = cosmeticRandom:random(1,#self.backgroundImages)
    end

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.backgroundImages[self.frame],0,0,0,2)

    
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(assetloader:getImage("background_title_text"))


    button:drawAll(self.buttons)
    

    --Cursor
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(assetloader:getImage("cursor"),CursorX,CursorY)
end

return title