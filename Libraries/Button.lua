local Button = {}
Button.__index = Button

function Button.new(tbl)
    local obj = setmetatable({},Button)

    obj.x,obj.y = tbl.x or 0,tbl.y or 0
    obj.visible = tbl.visible


    --check to see if wrapper if so assign it
    if tbl.wrapper then
        obj.wrapper = tbl.wrapper
    end
    --Get the color map or make the default one
    local normal,hovered,clicked = {0,0,0,1},{1,1,1,1},{.5,.5,.5,1}
    if tbl.colors then
        normal = tbl.colors.normal or normal
        hovered = tbl.colors.hovered or hovered
        clicked = tbl.colors.clicked or clicked
    end
    local colors = {
        normal = normal,
        hovered = hovered,
        clicked = clicked
    }
    obj.colors = {
        hovered = colors.hovered,
        normal = colors.normal,
        clicked = colors.clicked
    }
    obj.color = "normal"

    --Check to see if button is visible
    if obj.visible == nil then
        obj.visible = true
    end
    
    --Check tosee if there is an image/hoveredImage
    obj.image = tbl.image or false
    obj.hoveredImage = tbl.hoveredImage or false
    
    obj.width,obj.height = tbl.width or 128,tbl.height or 48
    
    --If an image change the width/height of the obj
    if obj.image then
        obj.width,obj.height = obj.image:getDimensions()
    end

    --check to see if there is a description
    obj.description = tbl.description or false
    --Check to see if description is true
    if obj.description then
        obj.description.font = obj.description.font or dogica_8
    end
    --Offset x,y for description text
    obj.descriptionX = 0
    obj.descriptionY = 0
    obj.isText = tbl.isText
    if obj.isText == nil then obj.isText = true end

    obj.executable = tbl.clicked
    obj.updateText = tbl.updateText

    return obj
end

function Button:hovered(passthrough) 
    self.isHovered = true
    self.color = "hovered"
end

function Button:clicked(passThrough)
    if self.executable == self.clicked then 
        error("When Creating a Button you used Button:new() instead of Button.new()")
    end
    self.color = "clicked"
    self:executable(passThrough)
end

function Button:update(passthrough,x,y)
    self.color = "normal"
    --x & y are offsets for collision
    local x = x or 0
    local y = y or 0
    
    if not self.visible then return end
    --get collision with offset being added
    if collision.rect({x=self.x+x,y=self.y+y,width = self.width,height = self.height,image = self.image}) then
        self:hovered(passthrough)
        if leftClick then
            self:clicked(passthrough)
        end
    else
        self.isHovered = false
    end

    --update the text
    if self.updateText then
        self:updateText(passthrough)
    end
    
    if self.description then
        local x,y = self.description.x or 0,self.description.y or 0

        local text = self.description.text
        local format = self.description.format
        local font = self.description.font

        if format == "center" then
            local width = font:getWidth(text)
            self.descriptionX = (self.width - width)/2 + self.x
            local height = font:getHeight(text)
            self.descriptionY = (self.height - height)/2 + self.y
        else
            self.descriptionX = x + self.x
            self.descriptionY = y + self.y
        end
    end
end

function Button:draw()
    if not self.visible then return end
    
    local x,y = self.x,self.y

    if self.image then
        local image = self.image
        if self.hoveredImage and self.isHovered then image = self.hoveredImage end
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(image,x,y)
    else
        local width,height = self.width,self.height
        if self.isHovered then color = {1,1,1,1} end
        love.graphics.setColor(self.colors[self.color])
        love.graphics.rectangle("fill",x,y,width,height)
    end

    --draw text
    if self.description and self.isText then
        local desc = self.description
        local color = self.defaultColor or {1,1,1,1}
        if self.isHovered then color = {0,0,0,1} end
        local text,font,x,y,limit,defaultColor = desc.text,desc.font,self.descriptionX,self.descriptionY,desc.limit or self.width,color
        customtext:draw(text,font,x,y,limit,defaultColor)
    end
end

function Button.updateAll(tbl,passthrough,x,y)
    for i, button in pairs(tbl) do
        button:update(passthrough,x,y)
    end
end

function Button.drawAll(tbl)
    for i, button in pairs(tbl) do
        button:draw()
    end
end

return Button