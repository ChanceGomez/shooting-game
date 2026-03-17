local EquipmentInventory = {}
EquipmentInventory.__index = EquipmentInventory

local function generateSlots(tbl)
    local returnTbl = {}

    for i, slot in pairs(tbl) do
        returnTbl[i] = EquipmentSlot:new(slot[1],slot[2])
    end

    return returnTbl 
end

function EquipmentInventory:new(tbl)
    local obj = setmetatable(Inventory:new(),EquipmentInventory)

    obj.slots = generateSlots(tbl)

    return obj
end

function EquipmentInventory:addItem(item,slot)
    local valid = false
    local slot = slot or self:getNextSlot()
    for i, instance in pairs(self.slots) do
        if instance == slot and item.type == i then
            valid = slot:addItem(item)
        end
    end
    return valid
end

function EquipmentInventory:linkInventory(inventory)
    Inventory.linkInventory(self,inventory)
end

function EquipmentInventory:unlinkInventory(inventory)
    Inventory.unlinkInventory(self,inventory)
end

function EquipmentInventory:drag()
    Inventory.drag(self)
end

function EquipmentInventory:update(dt)
    Inventory.update(self,dt)
    --Check to see if helditem can go in any slots
    if self.heldItem then
        for i, slot in pairs(self.slots) do
            if self.heldItem.type == i and slot.item == nil then
                slot.available = true
            end
        end
    end
end

function EquipmentInventory:drawHeldItem(item)
    Inventory.drawHeldItem(self,item)
end

function EquipmentInventory:draw()
    Inventory.draw(self)
end

return EquipmentInventory