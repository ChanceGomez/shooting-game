local statpanel = {
    x = 0,
    y = 0,
    images = {},
    button = nil
}

function statpanel:load()
    local backgroundImage = al:getImage("background_statpanel")
    local buttonImage = al:getImage("statpanel_button")
    self.x,self.y = Width,52
    self.images.background = backgroundImage
    self.width = backgroundImage:getWidth()
    self.height = backgroundImage:getHeight()

    self.isOpen = false
    self.button = {
        x = Width-buttonImage:getWidth(),
        y = 52,
        image = buttonImage,
        width = buttonImage:getWidth(),
        height = buttonImage:getHeight(),
        clicked = function()
            self.isOpen = not self.isOpen
            if self.isOpen then
                self:open()
            else
                self:close()
            end
        end,
    }
end

function statpanel:open()
    tweenTo(self,.5,"linear",Width-self.images.background:getWidth(),self.y)
    tweenTo(self.button,.5,"linear",Width-self.images.background:getWidth()-self.button.width,self.y)
end

function statpanel:close()
    tweenTo(self,.5,"linear",Width,self.y)
    tweenTo(self.button,.5,"linear",Width-self.button.width,self.y)

end

function statpanel:update(dt)
    button:update(self.button)
end

function statpanel:draw()
    local x,y = self.x,self.y

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.images.background,x,y)

    love.graphics.setColor(0,0,0,1)
    local font = dogica_8
    ct:draw("Reload Rate:" .. " {.8,0,0,1}" .. game:getPlayerGun().reloadRate,font,x+4,y+4,90,{0,0,0,1})
    ct:draw("Max Ammo:" .. " {.8,0,0,1}" .. game:getPlayerGun().maxAmmo,font,x+4,y+28,90,{0,0,0,1})
    ct:draw("Damage:" .. " {.8,0,0,1}" .. game:getPlayerGun().damage,font,x+4,y+42,90,{0,0,0,1})
    ct:draw("Fire Rate:" .. " {.8,0,0,1}" .. game:getPlayerGun().fireRate,font,x+4,y+56,90,{0,0,0,1})


    
    button:draw(self.button)
end


return statpanel