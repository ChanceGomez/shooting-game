local InventorySlot = {}
InventorySlot.__index = InventorySlot

--Static width/heights
local static_inventorySlotWidth = 40
local static_inventorySlotHeight = 40

function InventorySlot.new(x,y)
    local obj = setmetatable({},InventorySlot)


    obj.col = col 
    obj.row = row 

    obj.x = x
    obj.y = y
    obj.width = static_inventorySlotWidth
    obj.height = static_inventorySlotHeight
    obj.rightClicked = false

    obj.colors = {
        normal = {.5,.5,.5,1},
        available = {0,.6,0,1},
        hovered = {.5,.5,.5,1},
    }
    obj.color = "normal"
    obj.item = nil


    return obj
end

function InventorySlot:addItem(item)
    if self.item then return false end
    self.item = item
    return true
end

function InventorySlot:removeItem()
    self.item = nil
end

function InventorySlot:update()
    if collision.rect(self) then
        self.hovered = true
    else
        self.hovered = false
    end
end

function InventorySlot:draw()
    love.graphics.setColor(self.colors[self.color])
    love.graphics.rectangle("fill",self.x,self.y,self.width,self.height)

    if self.item then
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(self.item.image,self.x,self.y)
    end
end

return InventorySlot