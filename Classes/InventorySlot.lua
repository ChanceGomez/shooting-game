local InventorySlot = {}
InventorySlot.__index = InventorySlot


function InventorySlot:new(x,y,images)
    local obj = setmetatable({},InventorySlot)


    obj.col = col 
    obj.row = row 

    obj.x = x
    obj.y = y
    obj.width = images.background:getWidth()
    obj.height = images.background:getHeight()
    obj.rightClicked = false

    obj.item = nil

    obj.images = images

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

function InventorySlot:update(dt)
    if collision.rect(self) then
        self.hovered = true
    else
        self.hovered = false
    end
end

function InventorySlot:draw()
    love.graphics.setColor(1,1,1,1)
    local image = self.images.background
    if self.hovered then image = self.images.backgroundHovered end
    love.graphics.draw(image,self.x,self.y)

    if self.item then
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(self.item.image,self.x,self.y)
    end
end

return InventorySlot