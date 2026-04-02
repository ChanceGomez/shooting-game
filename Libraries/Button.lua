local Button = {}
Button.__index = Button

function Button:new(tbl)
    local obj = setmetatable({},Button)

    obj.x,obj.y = tbl.x or 0,tbl.y or 0
    obj.visible = tbl.visible
    obj.color = tbl.color or {0,0,0,1}

    if obj.visible == nil then
        obj.visible = true
    end
    
    obj.image = tbl.image or false
    obj.hoveredImage = tbl.hoveredImage or false
    
    obj.width,obj.height = tbl.width or 128,tbl.height or 48
    obj.description = tbl.description or false
    obj.descriptionX = 0
    obj.descriptionY = 0
    obj.isText = tbl.isText
    if obj.isText == nil then obj.isText = true end

    obj.executable = tbl.clicked

    return obj
end

function Button:clicked(passThrough)
    self.executable(passThrough)
end

function Button:update()
    if not self.visible then return end
    if collision.rect(self) then
        self.hovered = true
        if leftClick then
            self:clicked()
        end
    else
        self.hovered = false
    end
    
    if self.description then
        local x,y = self.description.x or 0,self.description.y or 0

        self.descriptionX = x + self.x
        self.descriptionY = y + self.y
    end
end

function Button:draw()
    if not self.visible then return end
    local color = self.color
    
    local x,y = self.x,self.y
    if self.image then
        local image = self.image
        if self.hoveredImage and self.hovered then image = self.hoveredImage end
        love.graphics.setColor(color)
        love.graphics.draw(image,x,y)
    else
        local width,height = self.width,self.height
        if self.hovered then color = {1,1,1,1} end
        love.graphics.setColor(color)
        love.graphics.rectangle("fill",x,y,width,height)
    end

    --draw text
    if self.description and self.isText then
        local desc = self.description
        local color = self.defaultColor or {1,1,1,1}
        if self.hovered then color = {0,0,0,1} end
        local text,font,x,y,limit,defaultColor = desc.text,desc.font,self.descriptionX,self.descriptionY,desc.limit,color
        customtext:draw(text,font,x,y,limit,defaultColor)
    end
end

return Button