local NestBody = {}
NestBody.__index = NestBody 

function NestBody:new(image,imageData,nest)
    local obj = setmetatable(Enemy:new(0,0,nest.handler),NestBody)

    obj.image = image
    obj.imageData = imageData
    obj.color = {1,1,1,1}
    obj.health = 300
    obj.nest = nest
    obj.centerX = obj.image:getWidth()/2
    obj.centerY = obj.image:getHeight()/2

    return obj
end

function NestBody:die()
    Enemy.die(self)
end

function NestBody:delete()
    self.nest:deleteArm(self)
end

function NestBody:hit(properties)
    Enemy.hit(self,properties)
end

function NestBody:isCollision()
    if collision.color(self) then
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
    love.graphics.setColor(self.color)
    love.graphics.draw(self.image)
end


return NestBody