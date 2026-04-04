local ParachuteCrate = {}
ParachuteCrate.__index = ParachuteCrate

setmetatable(ParachuteCrate,{__index = Enemy})


local staticCrateImage = assetloader:getImage("parachute_crate")
local staticParachuteImage = assetloader:getImage("parachute")

function ParachuteCrate.new(x,y,rarity,handler)
    local obj = Enemy.new(x,y,handler)

    obj.x = x or 0
    obj.y = y or 0
    obj.rarity = rarity or 1

    obj.speed = 20 * (rarity)
    obj.health = 10 * rarity
    obj.isAlive = true

    obj.item = equipment:getRandomEquipment(obj.rarity)

    obj.crate = {
        width = staticCrateImage:getWidth(),
        height = staticCrateImage:getHeight(),
        image = staticCrateImage,
        x = 0,
        y = 0,
    }

    obj.parachute = {
        width = staticParachuteImage:getWidth(),
        height = staticParachuteImage:getHeight(),
        image = staticParachuteImage,
        x = 0,
        y = 0,
    }
    obj.width = obj.crate.width
    obj.height = obj.crate.height

    return setmetatable(obj,ParachuteCrate)
end

function ParachuteCrate:die()
    if not self.isAlive then return end
    self.speed = 150
    self.isAlive = false
    gun.Inventory:addItem(self.item)
end

function ParachuteCrate:isCollision()
    return collision.rect(self.crate) or collision.rect(self.parachute)
end

function ParachuteCrate:update(dt)
    Enemy.hitColor(self,dt)
    --check for effects
    Enemy.effectUpdate(self,dt)
    self:deadColor()
    self.y = self.y + self.speed * dt

    self.parachute.x = self.x
    self.parachute.y = self.y

    self.crate.x = self.x + ((self.parachute.width-self.crate.width)/2)
    self.crate.y = self.y + self.parachute.height

    if self.y > Height then 
        self:delete()
    end
end

function ParachuteCrate:draw()
    local x,y = self.x,self.y

    Enemy.draw(self)
    local parachute = self.parachute
    love.graphics.draw(parachute.image,parachute.x,parachute.y)
    local crate = self.crate
    love.graphics.draw(crate.image,crate.x,crate.y)
end

return ParachuteCrate