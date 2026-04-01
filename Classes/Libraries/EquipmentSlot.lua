local EquipmentSlot = {}
EquipmentSlot.__index = EquipmentSlot

local staticBackground = al:getImage("background_equipment")
local staticBackgroundHovered = al:getImage("background_equipment_hovered")
local staticBackgroundAvailable = al:getImage("background_equipment_available")

function EquipmentSlot:new(x,y)
    local obj = setmetatable(InventorySlot:new(x,y,{
        background = staticBackground,
        backgroundHovered = staticBackgroundHovered,
    }),EquipmentSlot)

    obj.images.backgroundAvailable = staticBackgroundAvailable


    return obj
end

function EquipmentSlot:addItem(item)
    local valid = InventorySlot.addItem(self,item)
    if valid then
        item:add()
        return true
    else
        return false
    end
end

function EquipmentSlot:removeItem()
    if self.item then
        self.item:remove()
    end
    InventorySlot.removeItem(self)
end

function EquipmentSlot:update(dt)
    self.available = false
    InventorySlot.update(self,dt)
end

function EquipmentSlot:draw()
    local image = self.images.background 
    if self.available then image = self.images.backgroundAvailable end
    if self.hovered then image = self.images.backgroundHovered end
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(image,self.x,self.y)

    if self.item then
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(self.item.image,self.x,self.y)
    end
end

return EquipmentSlot