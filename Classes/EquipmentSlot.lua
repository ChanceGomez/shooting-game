local EquipmentSlot = {}
EquipmentSlot.__index = EquipmentSlot

local staticBackground = al:getImage("background_equipment")
local staticBackgroundHovered = al:getImage("background_equipment_hovered")

function EquipmentSlot:new(x,y)
    local obj = setmetatable({},EquipmentSlot)


    local x,y = x or 0, y or 0

    obj.x = x
    obj.y = y
    obj.width = staticBackground:getWidth()
    obj.height = staticBackground:getHeight()
    obj.equipment = nil


    return obj
end

function EquipmentSlot:update(dt)
    if collision.rect(self) then
        self.hovered = true
    else
        self.hovered = false
    end
end

function EquipmentSlot:draw()
    love.graphics.setColor(1,1,1,1)
    local image = staticBackground 
    if self.hovered then image = staticBackgroundHovered end
    love.graphics.draw(image,self.x,self.y)
end

return EquipmentSlot