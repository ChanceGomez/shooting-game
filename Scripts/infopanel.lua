local infopanel = {
	image = nil,
  defaultCursorOffset = 4
}

function infopanel:load()
	self.image = al:getImage('infopanel')
end

function infopanel:draw(obj) 
  local offset = self.defaultCursorOffset
  
	local x,y = CursorX + offset,CursorY
	local text = obj.info
	
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
	love.graphics.setFont(perfect_dos_16)
	love.graphics.setColor(0,0,0,1)
	love.graphics.printf(text,x+8,y+8,self.image:getWidth()-8)
end




return infopanel