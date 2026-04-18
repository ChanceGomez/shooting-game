local window = {
    Scale = 1,
    Width = 1920,
    Height = 1080,
    GameWidth = 1920,
    GameHeight = 1080,
}

--function to calculate scale and resolution change
function love.resize(width,height)
    local scale = width/window.GameWidth
    window.Scale = scale
end

function  window.fullscreen(bool)
    print(bool)
    love.window.setFullscreen(bool)
    settings.isFullscreen = bool

    --Lower the window so user can move it around and resize
    if bool == false then
        love.window.setPosition(0,32)
    end
end

function window.calculateScale()
    local width = love.graphics.getDimensions()
    local scale = width/window.GameWidth
    window.Scale = scale
end

function window.resolution(width,height)
    love.window.setMode(width,height)
end

function window.borderless(bool)

end

return window