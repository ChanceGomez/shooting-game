local NestArm = {}
NestArm.__index = NestArm

function NestArm:new(image,imageData,nest)
    local obj = setmetatable(Enemy:new(0,0,nest.handler),NestArm)

    obj.image = image
    obj.imageData = imageData
    obj.color = {1,1,1,1}
    obj.health = 40
    obj.nest = nest

    return obj
end

function NestArm:die()
    Enemy.die(self)
end

function NestArm:delete()
    self.nest:deleteArm(self)
end

function NestArm:hit(properties)
    Enemy.hit(self,properties)
end

function NestArm:isCollision()
    if collision.color(self) then
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
    love.graphics.setColor(self.color)
    love.graphics.draw(self.image)
end

return NestArm