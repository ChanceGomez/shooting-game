local EquipmentSlot = {}
EquipmentSlot.__index = EquipmentSlot

setmetatable(EquipmentSlot,{__index == InventorySlot})

local staticBackground = assetloader:getImage("background_equipment")
local staticBackgroundHovered = assetloader:getImage("background_equipment_hovered")
local staticBackgroundAvailable = assetloader:getImage("background_equipment_available")

function EquipmentSlot.new(x,y,type)
    local obj = InventorySlot.new(x,y)

    obj.type = type

    return setmetatable(obj,EquipmentSlot)
end

function EquipmentSlot:getItem()
    return InventorySlot.getItem(self)
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
    self.color = "normal"
    if self.available then
        self.color = "available"
    end

    self.available = false
    InventorySlot.update(self,dt)
end

function EquipmentSlot:draw()
    InventorySlot.draw(self)
end

return EquipmentSlot