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

    table.insert(self.buttons,Button.new({
        x = 24,
        y = 300,
        width = 128,
        height = 32,
        description = {
            text = "Play",
            font = dogica_16,
            format = "center",
        },
        visible = true,
        clicked = function(self)
            Scene = "difficultyselection"
        end
    }))
    table.insert(self.buttons,Button.new({
        x = 640-128-32,
        y = 300,
        width = 128,
        height = 32,
        description = {
            text = "Settings",
            format = "center",
            font = dogica_16
        },
        visible = true,
        clicked = function(self)
            settingscene:switchScene("settingscene")
        end
    }))
    table.insert(self.buttons,Button.new({
        x = 640-128-32,
        y = 300-48,
        width = 128,
        height = 32,
        description = {
            text = "Quit",
            font = dogica_16,
            format = "center",
        },
        visible = true,
        clicked = function(self)
            love.event.quit()
        end
    }))
end

function title:update(dt)
    --timer
    self.backgroundTimer = self.backgroundTimer + dt
    --buttons
    Button.updateAll(self.buttons)
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


    Button.drawAll(self.buttons)
    

    --Cursor
    drawCursor()
end

return title