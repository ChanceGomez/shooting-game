local ReloadShelfDudBullet = {}
ReloadShelfDudBullet.__index = ReloadShelfDudBullet

function ReloadShelfDudBullet:new(ReloadShelf,x,y)
    local obj = setmetatable(ReloadShelfBullet:new(ReloadShelf,x,y),ReloadShelfDudBullet)

    obj.isDud = true
    obj.properties = {
        damage = game.Affector:trigger("Dud Damage",game.Player.gun.duds.damage),
        fire = {
            damage = game.Affector:trigger("Dud Fire Damage",game.Player.gun.duds.fire.damage),
            duration = game.Affector:trigger("Dud Fire Duration",game.Player.gun.duds.fire.duration),
        },
    }
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