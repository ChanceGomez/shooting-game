local settingscene = {
    buttons = {},
    oldScene = "title",
}

function settingscene:switchScene(_Scene)
    self.oldScene = Scene
    Scene = "settingscene"
end

function settingscene:load()
    self.buttons.fullscreen = Button.new({
        x = 0,
        y = 0,
        width = 128,
        height = 32,
        description = {
            text = "Fullscreen"
        },
        clicked = function()
            window.fullscreen(not settings.isFullscreen)
        end,
    })
end

function settingscene:update(dt)
    for i, button in pairs(self.buttons) do
        button:update(dt)
    end

    if escapeClick then
        escapeClick = false
        Scene = self.oldScene
    end
end

function settingscene:draw()
    love.graphics.setBackgroundColor(.1,.1,.1,1)
    for i, button in pairs(self.buttons) do
        button:draw()
    end



    drawCursor()
end

return settingscene