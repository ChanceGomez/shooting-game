local ReloadShelf = {}
ReloadShelf.__index = ReloadShelf

--Static images
local backgroundImage = al:getImage("reloadshelf_background")
local outlineImage = al:getImage("reloadshelf_outline")


function ReloadShelf:new(x,y)
    local obj = setmetatable({}, ReloadShelf)

    obj.canvas = love.graphics.newCanvas(backgroundImage:getWidth(),backgroundImage:getHeight())
    obj.x = x or 0
    obj.y = y or 0
    obj.images = {
        background = backgroundImage,
        outline = outlineImage
    }
    obj.width = backgroundImage:getWidth()
    obj.height = backgroundImage:getHeight()
    obj.reloading = false
    obj.bullet = nil
    obj.buttons = {}
    obj.deletedBullets = {}
    obj.dudPercentage = 30
    obj.autoReload = false
    table.insert(obj.buttons, {
        x = obj.x,
        y = obj.y,
        image = al:getImage("loadbullet_button"),
        visible = true,
        clicked = function()
            obj:loadBullet()    
        end,
    })
    table.insert(obj.buttons, {
        x = 0,
        y = 0,
        image = al:getImage("discardbullet_button"),
        visible = true,
        clicked = function()
            obj:discardBullet()
        end
    })

    return obj 
end

function ReloadShelf:reload()
    self.reloading = true
    --get random for dud chance
    local random = math.random(1,100)
    self.bullet = ReloadShelfBullet:new(self,-128,8,random < self.dudPercentage)
end

function ReloadShelf:loadBullet()
    if self.bullet == nil or self.bullet.tweening then return end
    if game.Player.gun.canReload then
        table.insert(self.deletedBullets,self.bullet)
        self.deletedBullets[#self.deletedBullets]:loadingAnimation()
        self.bullet = nil
        self:reload()
    end
end

function ReloadShelf:discardBullet()
    if self.bullet == nil or self.bullet.tweening then return end

    table.insert(self.deletedBullets,self.bullet)
    self.deletedBullets[#self.deletedBullets]:discardAnimation()
    self.bullet = nil
    self:reload()

end

function ReloadShelf:update(dt)
    
    
    --update buttons
    button:updateAll(self.buttons)
    self.buttons[1].x = self.x + 59
    self.buttons[1].y = self.y + 5
    self.buttons[2].x = self.x + 59
    self.buttons[2].y = self.y + 36

    if self.bullet == nil and not self.reloading then
        self:reload()
    end

    --if autoreload
    if self.autoReload then
        if self.bullet and not self.reloading then
            if self.bullet.isDud then
                self:discardBullet()
            else
                self:loadBullet()
            end
        end
    end

    --update soon to be deleted bullets
    for i, bullet in ipairs(self.deletedBullets) do
        bullet:update()
    end

    if self.bullet and not self.bullet.held and not self.bullet.tweening then
        tweenTo(self.bullet,game.Player.gun.reloadRate,"linear",9,8,function() self.reloading = false end)
    end
end

function ReloadShelf:draw()

    local oldCanvas = love.graphics.getCanvas()

    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()


    --Background
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.images.background)

    --draw soon to be deleted bullets
    for i, bullet in ipairs(self.deletedBullets) do
        bullet:draw()
    end

    
    --Bullet
    if self.bullet then
        love.graphics.setColor(1,1,1,1)
        self.bullet:draw()
    end

    --draw outline above so that nothign goes above it
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.images.outline)

    
    love.graphics.setCanvas(oldCanvas)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.canvas,self.x,self.y)

    --draw buttons
    button:drawAll(self.buttons)
end


return ReloadShelf