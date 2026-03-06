local ReloadShelfBullet = {}
ReloadShelfBullet.__index = ReloadShelfBullet

--Static images
local bulletImage = al:getImage("bullet")

function ReloadShelfBullet:new(ReloadShelf,x,y,isDud)
    local obj = setmetatable({},ReloadShelfBullet)

    obj.image = bulletImage
    obj.width = bulletImage:getWidth()
    obj.height = bulletImage:getHeight()
    obj.x = x or 0
    obj.y = y or 0
    obj.hovered = false
    obj.damage = 1
    obj.inAnimation = false
    obj.ReloadShelf = ReloadShelf
    obj.isDud = isDud or false
    obj.color = {1,1,1,1}

    if obj.isDud then
        obj.color = {1,0,0,1}
    end

    return obj
end

function ReloadShelfBullet:delete()
    if self.inAnimation then
        for i = #self.ReloadShelf.deletedBullets, #self.ReloadShelf.deletedBullets, -1 do
            local bullet = self.ReloadShelf.deletedBullets[i]
            if bullet == self then
                table.remove(self.ReloadShelf.deletedBullets,i)
            end
        end
    end
end

function ReloadShelfBullet:loadingAnimation()
    self.inAnimation = true
    local x,y = self.x,self.y - 64
    tweenTo(self,game.Player.gun.reloadRate,"linear",x,y,
    function() 
        self:delete() if self.isDud then return end 
        game.Player.gun:loadBullet(self) 
        game.lookouts[1].Report:action("loadedBullet")
    end)
end

function ReloadShelfBullet:discardAnimation()
    self.inAnimation = true
    local x,y = self.x,self.y + 64
    tweenTo(self,game.Player.gun.reloadRate,"linear",x,y,
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