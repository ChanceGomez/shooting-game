local gun = {
    images = {},
    equipmentSlots = {},
    offsetX = 160,
    offsetY = 24,
    Inventory = nil,
}

function gun:load()
    self.images.background = al:getImage("background_gun")
    self.images.gun = al:getImage("gun")
    self.images.gunLines = al:getImage("gun_lines")

    self.equipmentSlots.barrel = EquipmentSlot:new(328+self.offsetX,240+self.offsetY)
    self.equipmentSlots.stabalizer = EquipmentSlot:new(376+self.offsetX,32+self.offsetY)
    self.equipmentSlots.antenna = EquipmentSlot:new(136+self.offsetX,24+self.offsetY)
    self.equipmentSlots.recoil = EquipmentSlot:new(56+self.offsetX,224+self.offsetY)
    self.equipmentSlots.base = EquipmentSlot:new(160+self.offsetX,264+self.offsetY)

    self.Inventory = Inventory:new(14,40,7,3)
    self.Inventory:addItem(equipment:getRandomEquipment())
end

function gun:update(dt)
    tab:update(dt)

    for i, slot in pairs(self.equipmentSlots) do
        slot:update()
    end

    self.Inventory:update(dt)

end

function gun:draw()
    local x,y = self.offsetX,self.offsetY
    
    love.graphics.setBackgroundColor(.1,.1,.1,1)


    --background
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.images.background,x,y)

    --gun layering
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.images.gun,x,y)
    love.graphics.draw(self.images.gunLines,x,y)

    for i, slot in pairs(self.equipmentSlots) do
        slot:draw()
    end

    self.Inventory:draw()

    --tab
    tab:draw()

    --cursor
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(al:getImage("cursor"),CursorX,CursorY)
end

return gun