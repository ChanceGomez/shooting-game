local ReloadShelfDudBullet = {}
ReloadShelfDudBullet.__index = ReloadShelfDudBullet

function ReloadShelfDudBullet:new(ReloadShelf,x,y)
    local obj = setmetatable(ReloadShelfBullet:new(ReloadShelf,x,y),ReloadShelfDudBullet)

    obj.damage = game.Affector:trigger("dudDamage",game.Player.gun.dudDamage)
    obj.color = {1,0,0,1}

    return obj
end


function ReloadShelfDudBullet:delete()
    ReloadShelfBullet.delete(self)
end

function ReloadShelfDudBullet:loadingAnimation()
    ReloadShelfBullet.loadingAnimation(self)
end

function ReloadShelfDudBullet:discardAnimation()
    ReloadShelfBullet.discardAnimation(self)
end


function ReloadShelfDudBullet:update()
    ReloadShelfBullet.update(self)
end

function ReloadShelfDudBullet:draw()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.image,self.x,self.y)
end

return ReloadShelfDudBullet