local Label = {}
Label.__index = Label

function Label.new(tbl)
    local obj = setmetatable({},Label)

    --Dimensions/Position
    obj.x = tbl.x or 0
    obj.y = tbl.y or 0
    obj.width = tbl.width or 128
    obj.height = tbl.height or 32
    obj.outlineWidth = tbl.outlineWidth or 1

    --Color
    obj.color = tbl.color or {0,0,0,1}
    obj.outlineColor = tbl.outlineColor or {1,1,1,1}

    --Text
    obj.text = {
        text = tbl.text.text or "Default",
        font = tbl.text.font or dogica_8,
        color = tbl.text.color or {1,1,1,1},
        x = tbl.text.x or 4,
        y = tbl.text.y or 4,
    }

    --Lifetime
    obj.timer = 0
    obj.lifetime = tbl.lifetime or "infinite"
    obj.dead = false

    --Hovered/Clicked
    obj.isHovered = false
    obj.executable = tbl.clicked or function() end

    return obj
end

function Label:delete()
    self.dead = true
end

function Label:clicked()
    self:executable()
end 

function Label:update(dt)
    self.timer = self.timer + dt

    if self.lifetime ~= "infinite" and self.timer > self.lifetime then
        self:delete()
    end

    --Check to see if hovered
    if collision.rect(self) then
        self.isHovered = true
        if leftClick then
            self:clicked()
            leftClick = false
        end
    else
       self.isHovered = false 
    end
end

function Label:draw()
    --Background 
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill",self.x,self.y,self.width,self.height)
    
    --Text
    customtext:draw({
        font = self.text.font,
        text = self.text.text,
        color = self.text.color,
        limit = self.width-8,
        x = self.x + self.text.x,
        y = self.y + self.text.y,
    })

    --Outline
    love.graphics.setColor(self.outlineColor)
    love.graphics.setLineWidth(self.outlineWidth)
    love.graphics.rectangle("line",self.x,self.y,self.width,self.height)
end

return Label
