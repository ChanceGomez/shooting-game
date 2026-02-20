--[[
	programmer: Chance Gomez | chance.f.gomez@gmail.com
	file: 		buttons.lua
	purpose:	updates and draws buttons from scenes. 
]]

local buttons = {}

local function isHover(obj,x,y)
	x = x or 0
	y = y or 0
	return CursorX >= (obj.x + x) and CursorX <= (obj.x + x + obj.width) and
	       CursorY >= (obj.y + y) and CursorY <= (obj.y + y + obj.height)
end

function buttons:add(tbl,name,x,y,image,clicked,hovered)
	tbl[name] = {
		x = x,
		y = y,
		image = image,
	}
end

function buttons:update(button,x,y)
	local x = x or 0
	local y = y or 0
  
  
  if button.image == nil then
      return
  else
    if button.width == nil or button.height == nil then
      button.width = button.image:getWidth()
      button.height = button.image:getHeight()

    end
  end
  local valid = true
  if not button.visible and button.visible ~= nil then
    valid = false
  end
  if valid then
    if isHover(button,x,y) and leftClick then
      button:clicked()
    end
  end

  
end

function buttons:updateAll(tbl,x,y)
	local x = x or 0
	local y = y or 0
	
	for i, button in pairs(tbl) do
    if button.image == nil then
      return
    else
      if button.width == nil or button.height == nil then
        button.width = button.image:getWidth()
        button.height = button.image:getHeight()

      end
    end
		local valid = true
		if not button.visible and button.visible ~= nil then
			valid = false
		end
		if valid then
			if isHover(button,x,y) and leftClick then
				button:clicked()
			end
		end
	end
end

function buttons:draw(button,arg1,arg2)
  --Check to see if any relative positions
  local x = 0
  local y = 0
  if type(arg1) == "number" then x = arg1 end
  if type(arg2) == "number" then x = arg2 end
  
  local isShader = false
  local shader = nil
  if type(arg1) == "userdata" then
    isShader = true
    shader = arg1
  end
  --Check to see if color
  local buttonColor = button.color or {1,1,1,1}
  
  --Make sure button has width/height vars for collision detection
  if button.width == nil and button.image == nil then
      button.width = 1
    elseif button.width == nil and button.image then
      button.width = button.image:getWidth()
    end
    if button.height == nil and button.image == nil then
      button.height = 1
    elseif button.height == nil and button.image then
      button.height = button.image:getHeight()
  end
  
  --Button logic
  local valid = true
		if not button.visible and button.visible ~= nil then
			valid = false
		end

		if valid then
			love.graphics.setColor(buttonColor)
      if isShader then love.graphics.setShader(shader) end
			if isHover(button,x,y) then
        if button.hoveredImage then
          love.graphics.draw(button.hoveredImage,button.x,button.y)
        else
          love.graphics.draw(button.image,button.x,button.y)
        end
				if button.hovered ~= nil then
					button.hovered = true
				end 
				
			else
				love.graphics.draw(button.image,button.x,button.y)
				if button.hovered ~= nil then
					button.hovered = false
				end 
			end
		end
		
    --button text
		if button.text ~= nil then
      local bX = button.text.x or 0
      local bY = button.text.y or 0
      local limit = button.text.limit or 20
			local x = button.x + bX
			local y = button.y + bY
			local color = button.text.color or {1,1,1,1}
			if button.hovered then
				color = button.text.hoveredColor
			end
			love.graphics.setColor(color)
			love.graphics.printf(button.text.text,x,y,limit)
		end
    
    if isShader then love.graphics.setShader() end
end


function buttons:drawAll(tbl,x,y)
	local x = x or 0
	local y = y or 0
	
	for i, button in pairs(tbl) do
		local buttonColor = button.color or {1,1,1,1}
    if button.width == nil and button.image == nil then
      button.width = 1
    elseif button.width == nil and button.image then
      button.width = button.image:getWidth()
    end
    if button.height == nil and button.image == nil then
      button.height = 1
    elseif button.height == nil and button.image then
      button.height = button.image:getHeight()
    end
	
		local valid = true
		if not button.visible and button.visible ~= nil then
			valid = false
		end

		if valid then
			love.graphics.setColor(buttonColor)
			if isHover(button,x,y) then
        if button.hoveredImage then
          love.graphics.draw(button.hoveredImage,button.x,button.y)
        else
          love.graphics.draw(button.image,button.x,button.y)
        end
				if button.hovered ~= nil then
					button.hovered = true
				end 
				
			else
				love.graphics.draw(button.image,button.x,button.y)
				if button.hovered ~= nil then
					button.hovered = false
				end 
			end
		end
		
    --button text
		if button.text ~= nil then
      local bX = button.text.x or 0
      local bY = button.text.y or 0
      local limit = button.text.limit or 20
			local x = button.x + bX
			local y = button.y + bY
			local color = button.text.color or {1,1,1,1}
			if button.hovered then
				color = button.text.hoveredColor
			end
			love.graphics.setColor(color)
			love.graphics.printf(button.text.text,x,y,limit)
		end
	end
end



return buttons