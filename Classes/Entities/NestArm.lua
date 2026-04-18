local NestArm = {}
NestArm.__index = NestArm

setmetatable(NestArm,{__index = Enemy})


function NestArm.new(image,imageData,nest,polygon)
    local obj = Enemy.new(0,0,nest.handler)

    obj.polygon = polygon
    obj.image = image
    obj.imageData = imageData
    obj.health = 80
    obj.nest = nest

    return setmetatable(obj,NestArm)
end

function NestArm:delete()
    self.nest:deleteArm(self)
end

function NestArm:checkCircleCollision(circle,properties)
    if collision.ciclePoly(circle,self.polygon) then
        self:hit(properties)
        return true
    end
    return false
end

function NestArm:isCollision(properties)
    if collision.color(self) then
        self:hit(properties)
        return true
    else
        return false
    end
end

function NestArm:update(dt)
    Enemy.hitColor(self,dt)
    Enemy.effectUpdate(self,dt)
    if not self.isAlive then
        self:delete()
    end
end

function NestArm:draw()
    love.graphics.setColor(self.colors[self.color])
    love.graphics.draw(self.image)
end

return NestArm