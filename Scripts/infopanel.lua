local infopanel = {
	image = nil,
  defaultCursorOffsetX = 12,
  defaultCursorOffsetY = 12,
}

function infopanel:load()
	self.image = al:getImage('infopanel')
end

function infopanel:draw(obj) 
	local offsetX = self.defaultCursorOffsetX
	local offsetY = self.defaultCursorOffsetY
	local font = obj.description.font or obj.font or nil
  
	local x,y = CursorX + offsetX,CursorY + offsetY
	local text = obj.info
	if text == nil then 
		if type(obj.description) == "string" then
			text = obj.description
		elseif obj.description.text then
			text = obj.description.text
		end
	end
	
	if text == nil then
		return
	end
	if obj.held then
		return
	end
  
	--figure out of panel would go over the border
	if y > Height - self.image:getHeight() then
		y = Height - self.image:getHeight()
	end

	if x > Width - self.image:getWidth() then
		x = Width - self.image:getWidth()
  end

	
	--draw panel and text
  	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(self.image,x,y)
	ct:draw(text,font,x+4,y+4,self.image:getWidth()-8,{0,0,0,1})
end




return infopanel