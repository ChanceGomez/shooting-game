local EquipmentSlot = {}
EquipmentSlot.__index = EquipmentSlot

local staticBackground = assetloader:getImage("background_equipment")
local staticBackgroundHovered = assetloader:getImage("background_equipment_hovered")
local staticBackgroundAvailable = assetloader:getImage("background_equipment_available")

function EquipmentSlot.new(x,y)
    local obj = setmetatable(InventorySlot.new(x,y),EquipmentSlot)

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