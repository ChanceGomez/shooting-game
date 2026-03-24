local ReloadShelfBullet = {}
ReloadShelfBullet.__index = ReloadShelfBullet

--Static images
local bulletImage = al:getImage("bullet")

function ReloadShelfBullet:new(ReloadShelf,x,y)
    local obj = setmetatable({},ReloadShelfBullet)

    obj.isDud = false
    obj.image = bulletImage
    obj.width = bulletImage:getWidth()
    obj.height = bulletImage:getHeight()
    obj.x = x or 0
    obj.y = y or 0
    obj.hovered = false
    obj.properties = {
        damage = game.Affector:trigger("Bullet Damage",game.Player.gun.bullets.damage),
        fire = {
            damage = game.Affector:trigger("Bullet Fire Damage",game.Player.gun.bullets.fire.damage),
            duration = game.Affector:trigger("Bullet Fire Duration",game.Player.gun.bullets.fire.duration),
        },
    }
    obj.inAnimation = false
    obj.ReloadShelf = ReloadShelf
    obj.color = {1,1,1,1}

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
    tweenTo(self,game.Affector:trigger("Reload Rate",game.Player.gun.reloadRate),"linear",x,y,
    function() 
        game.Player.gun:loadBullet(self) 
        game.lookouts[1].Report:action("loadedBullet")
        self:delete() 
    end)
end

function ReloadShelfBullet:discardAnimation()
    self.inAnimation = true
    local x,y = self.x,self.y + 64
    tweenTo(self,game.Affector:trigger("Reload Rate",game.Player.gun.reloadRate),"linear",x,y,
    function() 
        self:delete() 
        game.lookouts[1].Report:action("discardedBullet")
    end)
end


function ReloadShelfBullet:update()

end

function ReloadShelfBullet:draw()
    love.graphics.setColor({1,1,1,1})
    love.graphics.draw(self.image,self.x,self.y)
end

return ReloadShelfBullet