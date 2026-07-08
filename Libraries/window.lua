local window = {
    Scale = 1,
    Width = 1920,
    Height = 1080,
    GameWidth = 1920,
    GameHeight = 1080,
    windowX = 0,
    windowY = 0,
}

--function to calculate scale and resolution change
function love.resize(width,height)
    local xScale = width/window.GameWidth
    local yScale = height/window.GameHeight
    local newScale = 1

    if xScale >= yScale then
        newScale = yScale
    else 
        newScale = xScale
    end

    window.windowX = (width - (window.GameWidth * newScale))/2
    window.windowY = (height - (window.GameHeight * newScale))/2
    

    window.Scale = newScale
end

function  window.fullscreen(bool)
    local _bool
    if bool == nil then
        _bool = not love.window.getFullscreen()
    else
        _bool = bool
    end

    love.window.setFullscreen(_bool)
    settings.isFullscreen = _bool

    --Lower the window so user can move it around and resize
    if _bool == false then
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