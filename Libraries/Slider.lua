local Slider = {}
Slider.__index = Slider

local sliderHeld = false

local function sliderToValue(sliderPos, min, max)
    return math.floor(min + sliderPos * (max - min) + 0.5)
end

local function valueToSlider(value, min, max)
    return (value - min) / (max - min)
end

function Slider.new(tbl)
    local obj = setmetatable({},Slider)

    obj.x,obj.y = tbl.x or 0,tbl.y or 0
    obj.visible = tbl.visible

    local slider = tbl.slider or {
        width = 16,
        height = 16,
        min = 0,
        max = 100,
        value = 0,
    }

    obj.slider = {
        x = obj.x,
        y = obj.y,
        width = slider.width or 16,
        height = slider.height or 16,
        min = slider.min or 0,
        max = slider.max or 100,
        value = slider.value or 0,
        margin = slider.margin or 8,
        percent = 0,
    }
    obj.slider.percent = valueToSlider(obj.slider.value,obj.slider.min,obj.slider.max)
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
    
    obj.width,obj.height = tbl.width or 128,tbl.height or 32
    

    obj.executable = tbl.clicked
    obj.updateText = tbl.updateText

    return obj
end

function Slider:update()
    local oldValue = self.slider.value
    if not self.visible then return end

    --Check to see if hovered
    if collision.rect(self.slider) and sliderHeld == false then
        self.slider.isHovered = true
        if love.mouse.isDown(1) then
            sliderHeld = true
            self.slider.isHeld = true
        end
    else
        self.slider.isHovered = false
    end

    if not love.mouse.isDown(1) then
        self.slider.isHeld = false
        sliderHeld = false
    end

    

    if self.slider.isHeld then
        local difference = CursorX - self.x
        local percent = difference/self.width
        --make sure the percent doesn't go beyond 0% or 100%
        self.slider.percent = math.max(math.min(percent,1),0)
    end

    self.slider.value = sliderToValue(self.slider.percent,self.slider.min,self.slider.max)


    --Change x based on percent
    self.slider.x = self.x + valueToSlider(self.slider.value,self.slider.min,self.slider.max)*self.width - self.slider.margin
    self.slider.y = self.y - self.slider.height/4


    --Update text
    if self.updateText then
        self:updateText()
    end

    if oldValue ~= self.slider.value then
        self:executable()
    end
end

function Slider:draw()
    if not self.visible then return end
    --draw background slider
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("fill",self.x,self.y,self.width,self.height)

    --Draw slider
    love.graphics.setColor(0,0,0,1)
    local slider = self.slider
    love.graphics.rectangle("fill",slider.x,slider.y,slider.width,slider.height)

end

return Slider