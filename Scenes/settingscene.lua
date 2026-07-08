local settingscene = {
    buttons = {},
    sliders = {},
    oldScene = "title",
}

function settingscene:switchScene(_Scene)
    self.oldAudio = love.audio.pause()
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
            text = "Fullscreen",
            format = "center",
        },
        clicked = function()
            window.fullscreen(not settings.isFullscreen)
        end,
    })
    self.buttons.vsync = Button.new({
        x = 0,
        y = 32,
        width = 128,
        height = 32,
        colors = {
            --normal = {1,1,1,1},
        },
        description = {
            text = "Vsync",
            format = "center",
        },
        clicked = function(self)
            local currentVsync = love.window.getVSync()
            local newVsync = 0
            if currentVsync == 0 then
                self.description.text = "Vsync: true"
                newVsync = 1
            else
                self.description.text = "Vsync: false"
                newVsync = 0
            end 

            love.window.setVSync(newVsync)
        end,
    })
    self.sliders.volume = Slider.new({
        x = 0,
        y = 80,
        height = 8,
        slider = {
            width = 16,
            height = 16,
            min = 0,
            max = 100,
            value = settings.volume*100,
        },
        clicked = function(self)
            love.audio.setVolume(self.slider.value/100)
        end,
    })
    self.buttons.mainmenu = Button.new({
        x = 0,
        y = 360-32,
        width = 128,
        height = 32,
        colors = {
            --normal = {1,1,1,1},
        },
        description = {
            text = "Main Menu",
            format = "center",
        },
        clicked = function(self)
            Scene = "title"
        end,
    })
    self.buttons.back = Button.new({
        x = 640-128,
        y = 0,
        width = 128,
        height = 32,
        colors = {
            --normal = {1,1,1,1},
        },
        description = {
            text = "Back",
            format = "center",
        },
        clicked = function(self)
            settingscene:resumeScene()
        end,
    })

    self.buttons.advancedTooltips = Button.new({
        x = 148,
        y = 0,
        width = 128,
        height = 32,
        description = {
            text = "Advanced Tooltips:",
            y = 4,
        },
        clicked = function(self)
            if not settings.advancedTooltips then
                self.description.text = "Advanced Tooltips:/n on"
                settings.advancedTooltips = true
            else
                self.description.text = "Advanced Tooltips:/n off"
                settings.advancedTooltips = false
            end 
        end,
    })

    --Set the colors of the buttons
    for i, button in pairs(self.buttons) do
        button.colors.normal = {.2,.2,.4,1}
    end

    local isVsync = ""
    local vsync = love.window.getVSync()
    if vsync == 1 then
        isVsync = "true"
    elseif vsync == 0 then
        isVsync = "false"
    end
    self.buttons.vsync.description.text = "Vsync: " .. isVsync
end

function settingscene:resumeScene()
    Scene = self.oldScene or "title"
    if self.oldAudio then
        love.audio.play(self.oldAudio)
    end
end

function settingscene:update(dt)
    for i, button in pairs(self.buttons) do
        button:update(dt)
    end
    for i, slider in pairs(self.sliders) do
        slider:update(dt)
    end

    if escapeClick then
        escapeClick = false
        self:resumeScene()
    end
end

function settingscene:draw()
    love.graphics.setColor(.1,.1,.1,1)
    love.graphics.rectangle("fill",0,0,window.GameWidth,window.GameHeight)

    for i, button in pairs(self.buttons) do
        button:draw()
    end
    for i, slider in pairs(self.sliders) do
        slider:draw()
    end

    --Volume label
    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(dogica_8)
    love.graphics.print("Volume: " .. self.sliders.volume.slider.value,self.sliders.volume.x,self.sliders.volume.y-14)


    drawCursor()
end

return settingscene