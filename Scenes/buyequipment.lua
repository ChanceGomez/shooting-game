local buyequipment = {
    equipmentButtons = {},
    buttons = {},
    priceMult = 100,
}

function buyequipment:load(x,y,width,height)
    self.x = x or 0
    self.y = y or 0
    self.Width = width or window.GameWidth
    self.Height = height or window.GameHeight


    self.Canvas = love.graphics.newCanvas(self.Width,self.Height)

    --create all the equipments
    local oX,oY = 10,10
    local maxWidth = self.Width-oX
    local totalWidth = 0
    local count = 0
    local nextRowCount = 0
    local collumnCount = 0
    local priceMult = self.priceMult

    local margin = 16
    for  name, instance in pairs(equipment.equipments) do
        local item = equipment:getEquipment(name)
        local name = item.name
        local image = item.image
        local width = item.width + margin
        local height = image:getHeight()
        local x = width * collumnCount
        totalWidth = totalWidth + width
        if totalWidth > maxWidth then
            x = 0
            totalWidth = 0
            collumnCount = 0
            nextRowCount = nextRowCount + 1
        end
        local y = nextRowCount * height
        local button = Button.new({
            x = x+oX,
            y = y+oY,
            image = image,
            clicked = function(self)
                if game.Player.resources >= item.rarity * priceMult then
                    if gun.Inventory:addItem(item) then
                        game.Player.resources = game.Player.resources - (item.rarity * priceMult) 
                    end
                end
            end,
        })
        button.info = {
            text = name .. ' cost: ' .. (item.rarity * priceMult),
        }
        button.updateText = function(self)
            if item.ids == nil then return button.info.text end
            local ids = item.ids

            return button.info.text .. " /n " .. game.Affector:getDescription(ids)
        end
        self.equipmentButtons[name] = button
        count = count + 1
        collumnCount = collumnCount + 1
    end
end

function buyequipment:update(dt)
    Button.updateAll(self.equipmentButtons,nil,self.x,self.y)
end

function buyequipment:draw()
    oldCanvas = love.graphics.getCanvas()

    love.graphics.setCanvas(self.Canvas)
    love.graphics.clear()

    --background
        --fill
        love.graphics.setColor(.1,.1,.1,1)
        love.graphics.rectangle("fill",0,0,self.Width,self.Height)
        --outline
        love.graphics.setColor(1,1,1,1)
        love.graphics.rectangle("line",0,0,self.Width,self.Height)

    Button.drawAll(self.buttons)
    Button.drawAll(self.equipmentButtons)
    infopanel.drawAll(self.equipmentButtons,-self.x,-self.y,self.Width,self.Height)
    



    love.graphics.setCanvas(oldCanvas)
    love.graphics.setColor(1,1,1,1)
    local x = (window.GameWidth-self.Width)/2
    local y = (window.GameHeight-self.Height)/2
    love.graphics.draw(self.Canvas,self.x,self.y)
end

return buyequipment