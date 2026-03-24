local infopanel = {
	defaultCursorOffsetX = 12,
	defaultCursorOffsetY = 12,
	margin = 8,
	textOffsetX = 4,
	textOffsetY = 4,
}

function infopanel:load()

end

function infopanel:draw(obj,panelMaxSize,cameraX,cameraY) 
	local panelMaxSize = panelMaxSize or 256
	local offsetX = self.defaultCursorOffsetX
	local offsetY = self.defaultCursorOffsetY
	local cameraX,cameraY = cameraX or 0, cameraY or 0
	local font = obj.font or nil
  
	local x,y = CursorX + offsetX,CursorY + offsetY
	local text = obj.info
	if font == nil and obj.description then
		font = obj.description.font
	end
	if text == nil and obj.description then 
		if type(obj.description) == "string" then
			text = obj.description
		elseif obj.description.text then
			text = obj.description.text
		end
	end

	--update text if there is an updateText function
	if obj.updateText then
		text = nil
		text = obj:updateText()
	end
	
	if text == nil then
		return
	end
	if obj.held then
		return
	end
  
	local width,height = ct:getDimensions(text,font,x+4,y+4,panelMaxSize,{0,0,0,1})

	--figure out of panel would go over the border
	if y > Height - height - self.margin then
		y = Height - height - self.margin
	end

	if x > Width - width then
		x = Width - width
  	end

	
	--draw panel and text
  	love.graphics.setColor(.9,.9,.9,1)
	love.graphics.rectangle("fill",x+cameraX,y+cameraY,width,height+self.margin)
	ct:draw(text,font,x+self.textOffsetX+cameraX,y+self.textOffsetY+cameraY,panelMaxSize,{0,0,0,1})
	
end




return infopanel