local gun = {
    images = {},
    equipmentSlots = {},
    offsetX = 160,
    offsetY = 24,
    Inventory = nil,
    EquipmentInventory = nil,
}

function gun:load()
    self.images.background = al:getImage("background_gun")
    self.images.gun = al:getImage("gun")
    self.images.gunLines = al:getImage("gun_lines")

    --Create inventories
    self.EquipmentInventory = EquipmentInventory:new({
        barrel = {328+self.offsetX,240+self.offsetY},
        stabalizer = {376+self.offsetX,32+self.offsetY},
        antenna = {136+self.offsetX,24+self.offsetY},
        recoil = {56+self.offsetX,224+self.offsetY},
        base = {160+self.offsetX,264+self.offsetY},
    })
    self.Inventory = Inventory:new(14,40,3,7,self.equipmentSlots)

    --debug
    self.Inventory:addItem(equipment:getRandomEquipment())
    self.Inventory:addItem(equipment:getRandomEquipment())
    self.Inventory:addItem(equipment:getRandomEquipment())

    --Link the inventories
    self.EquipmentInventory:linkInventory(self.Inventory)
end

function gun:update(dt)
    tab:update(dt)

    for i, slot in pairs(self.equipmentSlots) do
        slot:update()
    end

    self.Inventory:update(dt)
    self.EquipmentInventory:update(dt)

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
    self.EquipmentInventory:draw()

    --tab
    tab:draw()

    --cursor
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(al:getImage("cursor"),CursorX,CursorY)
end

return gun