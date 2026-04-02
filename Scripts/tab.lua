local tab = {
    images = {},
    buttons = {},
}

function tab:load()
    tab.images.background = assetloader:getImage("background_tab")

    local height = 28
    local color = {.2,.2,.2,1}
    local y = -1
    local textY = 8
    local textX = 90

    tab.buttons.shop = Button:new({
        x = 0,
        y = y,
        width = 640/3,
        height = height,
        color = color,
        description = {
            font = dogica_16,
            text = "Shop",
            x = textX,
            y = textY,
        },
        clicked = function()
            if Scene ~= "shop" then
                Scene = "shop"
            end
        end,   
    })
    tab.buttons.gun = Button:new({
        x = Width - (Width/3)*2,
        y = y,
        width = 640/3,
        height = height,
        color = color,
        description = {
            font = dogica_16,
            text = "Gun",
            x = textX,
            y = textY,
        },
        clicked = function()
            if Scene ~= "gun" then
                Scene = "gun"
            end
        end,   
    })
    tab.buttons.map = Button:new({
        x = Width - Width/3,
        y = y,
        width = 640/3,
        height = height,
        color = color,
        description = {
            font = dogica_16,
            text = "Map",
            x = textX,
            y = textY,
        },
        clicked = function()
            if Scene ~= "map" then
                Scene = "map"
            end
        end,   
    })
end

function tab:update(dt)
    for i, button in pairs(self.buttons) do
        button:update()
    end
end

function tab:draw()
    --draw background
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.images.background,0,0)

    for i, button in pairs(self.buttons) do
        button:draw()
    end
end

return tab