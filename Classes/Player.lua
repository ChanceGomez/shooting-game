local Player = {}
Player.__index = Player

function Player:new()
  local obj = setmetatable({}, Player)
  
  obj.gun = nil
  obj.resources = 0
  
  return obj
end

function Player:ChangeGun(gun)
    self.gun = Guns[gun]:new()
end

function Player:fireGun()
    if self.gun then
        self.gun:fire()
    end
end

function Player:update(dt)
   if leftClick then
        self:fireGun()
   end 

   if self.gun then
        self.gun:update(dt)
   end
end

function Player:draw()
    --draw crosshair
    local x,y = CursorX,CursorY
    love.graphics.setColor(1,1,1,1)
    if game.lookouts[1].isHoveringButton then
        local crosshairImage = al:getImage("cursor")
        local crosshairWidth, crosshairHeight = crosshairImage:getDimensions()
        love.graphics.draw(crosshairImage,x,y,0,1,1,crosshairWidth/2,crosshairHeight/2)
    else
        local crosshairImage = al:getImage("crosshair")
        local crosshairWidth, crosshairHeight = crosshairImage:getDimensions()
        love.graphics.draw(crosshairImage,x,y,0,1,1,crosshairWidth/2,crosshairHeight/2)
    end



    if self.gun then
        self.gun:draw()
    end
end 

return Player