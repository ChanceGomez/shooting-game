local tab = {
    images = {},
    buttons = {},
}

function tab:load()
    tab.images.background = al:getImage("background_tab")

    tab.buttons.shop = {
        x = 0,
        y = 0,
        image = al:getImage("shop_button"),
        hoveredImage = al:getImage("shop_button_hovered"),
        clicked = function()
            if Scene ~= "shop" then
                Scene = "shop"
            end
        end,   
    }
    tab.buttons.gun = {
        x = Width/2,
        y = 0,
        image = al:getImage("gun_button"),
        hoveredImage = al:getImage("gun_button_hovered"),
        clicked = function()
            if Scene ~= "gun" then
                Scene = "gun"
            end
        end,   
    }
end

function tab:update(dt)
    button:updateAll(self.buttons)
end

function tab:draw()
    --draw background
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.images.background,0,0)

    button:drawAll(self.buttons)
end

return tab