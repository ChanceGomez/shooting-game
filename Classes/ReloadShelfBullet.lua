local ReloadShelfBullet = {}
ReloadShelfBullet.__index = ReloadShelfBullet

local bulletImage = al:getImage("bullet")

function ReloadShelfBullet:new(reloadShelf,x,y,isDud)
    local obj = setmetatable({},ReloadShelfBullet)

    obj.image = bulletImage
    obj.width = bulletImage:getWidth()
    obj.height = bulletImage:getHeight()
    obj.x = x or 0
    obj.y = y or 0
    obj.hovered = false
    obj.damage = 1
    obj.inAnimation = false
    obj.reloadShelf = reloadShelf
    obj.isDud = isDud or false
    obj.color = {1,1,1,1}

    if obj.isDud then
        obj.color = {1,0,0,1}
    end

    return obj
end

function ReloadShelfBullet:delete()
    if self.inAnimation then
        for i = #self.reloadShelf.deletedBullets, #self.reloadShelf.deletedBullets, -1 do
            local bullet = self.reloadShelf.deletedBullets[i]
            if bullet == self then
                table.remove(self.reloadShelf.deletedBullets,i)
            end
        end
    end
end

function ReloadShelfBullet:loadingAnimation()
    self.inAnimation = true
    local x,y = self.x,self.y - 64
    tweenTo(self,game.Player.gun.reloadTime,"linear",x,y,
    function() 
        self:delete() if self.isDud then return end 
        game.Player.gun:loadBullet(self) 
        game.lookouts[1].Report:action("loadedBullet")
    end)
end

function ReloadShelfBullet:discardAnimation()
    self.inAnimation = true
    local x,y = self.x,self.y + 64
    tweenTo(self,game.Player.gun.reloadTime,"linear",x,y,
    function() 
        self:delete() 
        game.lookouts[1].Report:action("discardedBullet")
    end)
end


function ReloadShelfBullet:update()
    if collision.rect(self) then
        self.hovered = true
    else
        self.hovered = false
    end
end

function ReloadShelfBullet:draw()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.image,self.x,self.y)
end

return ReloadShelfBullet