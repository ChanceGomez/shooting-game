local infopanel = {
	defaultCursorOffsetX = 12,
	defaultCursorOffsetY = 12,
	margin = 8,
	textOffsetX = 4,
	textOffsetY = 4,
}

function infopanel:load()

end

function infopanel.drawAll(tbl,x,y,width,height)
	for i, panel in pairs(tbl) do
		infopanel:draw(panel,nil,x,y,width,height)
	end
end

function infopanel:draw(obj,panelMaxSize,cameraX,cameraY,width,height) 

	local panelMaxSize = panelMaxSize or 316
	local offsetX = self.defaultCursorOffsetX
	local offsetY = self.defaultCursorOffsetY
	local cameraX,cameraY = cameraX or 0, cameraY or 0
	local font = nil
	local text = nil
	local Width = width or Width
	local Height = height or Height

  	local x,y = CursorX + offsetX,CursorY + offsetY
	
	if font == nil and obj.description then
		font = obj.description.font
	end
	if font == nil and obj.info then
		font = obj.info.font
	end
	if text == nil and obj.description then 
		if type(obj.description) == "string" then
			text = obj.description
		elseif obj.description.text then
			text = obj.description.text
		end
	end
	if text == nil and obj.info then 
		if type(obj.info) == "string" then
			text = obj.info
		elseif obj.info.text then
			text = obj.info.text
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

	if obj.held == true or obj.isHovered == false then
		return
	end

	
	local width,height = customtext:getDimensions(text,font,x+4,y+4,panelMaxSize,{0,0,0,1})

	--figure out of panel would go over the border
	if (y+cameraY) > Height - height - self.margin then
		y = Height - height - self.margin + cameraY
	end

	if (x+cameraX) > Width - width then
		x = Width - width - cameraX
  	end

	
	--draw panel and text
  	love.graphics.setColor(.9,.9,.9,1)
	love.graphics.rectangle("fill",x+cameraX,y+cameraY,width+8,height+self.margin)
	customtext:draw(text,font,x+self.textOffsetX+cameraX,y+self.textOffsetY+cameraY,panelMaxSize,{0,0,0,1})
	
end




return infopanel