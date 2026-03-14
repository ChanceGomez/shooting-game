local Inventory = {}
Inventory.__index = Inventory


local function getNextEmptySlot(self)
    for i, slot in ipairs(self.slots) do
        if slot.item == nil then
            return slot
        end
    end
end

local function generateSlots(cols,rows,x,y,margin)
    local tbl = {}

    for row = 1, rows do
        for col = 1, cols do
            table.insert(tbl,InventorySlot:new(row,col,x,y,margin))
        end
    end

    return tbl
end

function Inventory:new(x,y,cols,rows)
    local obj = setmetatable({},Inventory)

    local margin = 4
    local rows,cols = rows or 1, cols or 1 

    obj.rows = rows
    obj.cols = cols

    obj.x = x or 0
    obj.y = y or 0

    obj.slots = generateSlots(cols,rows,x,y,margin)



    return obj
end

function Inventory:addItem(item)
    slot = getNextEmptySlot(self)
    slot.item = item
end

function Inventory:update(dt)
    for i, slot in ipairs(self.slots) do
        slot:update(dt)
    end
    --drag:update(self.slots)
end

function Inventory:draw()
    for i, slot in ipairs(self.slots) do
        slot:draw()
    end
end

return Inventory