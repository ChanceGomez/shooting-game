local NestBody = {}
NestBody.__index = NestBody 

setmetatable(NestBody,{__index = Enemy})


function NestBody.new(image,imageData,nest,polygon)
    local obj = Enemy.new(0,0,nest.handler)

    obj.polygon = polygon
    obj.image = image
    obj.imageData = imageData
    obj.health = 300
    obj.nest = nest
    obj.centerX = obj.image:getWidth()/2
    obj.centerY = obj.image:getHeight()/2

    return setmetatable(obj,NestBody)
end

function NestBody:checkCircleCollision(circle,properties)
    if collision.ciclePoly(circle,self.polygon) then
        self:hit(properties)
        return true
    end
    return false
end

function NestBody:delete()
    self.nest:deleteBody(self)
end

function NestBody:isCollision(properties)
    if collision.color(self) then
        self:hit(properties)
        return true
    else
        return false
    end
end

function NestBody:update(dt)
    Enemy.hitColor(self,dt)
    Enemy.effectUpdate(self,dt)
    if not self.isAlive then
        self:delete()
    end
end

function NestBody:draw()
    love.graphics.setColor(self.colors[self.color])
    love.graphics.draw(self.image)
end


return NestBody