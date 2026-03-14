local InventorySlot = {}
InventorySlot.__index = InventorySlot

local staticInventoryBackground = al:getImage("background_equipment")
local staticInventoryBackgroundHovered = al:getImage("background_equipment_hovered")


function InventorySlot:new(col,row,x,y,margin)
    local obj = setmetatable({},InventorySlot)

    local image = staticInventoryBackground
    local width = image:getWidth()
    local height = image:getHeight()

    obj.col = col 
    obj.row = row 

    obj.x = (col-1) * (width+margin) + x
    obj.y = (row-1) * (height+margin) + y
    obj.width = width
    obj.height = height

    obj.item = nil

    obj.images = {}
    obj.images.background = image
    obj.images.backgroundHovered = staticInventoryBackgroundHovered

    return obj
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