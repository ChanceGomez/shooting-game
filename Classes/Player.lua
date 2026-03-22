local Player = {}
Player.__index = Player

function Player:new()
  local obj = setmetatable({}, Player)
  
  obj.gun = nil
  obj.resources = 0
  obj.parachuteOdds = 75
  obj.dudPercentage = 20
  obj.health = 3
  
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
   if love.mouse.isDown(1) then
        self:fireGun()
   end 

   if self.gun then
        self.gun:update(dt)
   end
end

function Player:draw()
    --get easy access variables
    local x,y = CursorX,CursorY

    love.graphics.setColor(1,1,1,1)
    --draw the cursor if hovering over a button
    if game.lookouts[1].isHoveringButton then
        local cursorImage = al:getImage("cursor")
        local cursorWidth, crosshairHeight = cursorImage:getDimensions()
        love.graphics.draw(cursorImage,x,y)
    --draw the crosshair
    else
        --Ease of access vars
        local gun = self.gun
        local crosshairImage = al:getImage("crosshair")
        local crosshairWidth, crosshairHeight = crosshairImage:getDimensions()
        
        --Check to see if there is ammo in the gun, if not than gray out the crosshair
        if #gun.ammo > 0 and gun.fireRateTimer > gun.fireRate then
            love.graphics.setColor(1,1,1,1)
        else
            love.graphics.setColor(0.6,.6,.6,1)
        end

        -- Draw the crosshair
        love.graphics.draw(crosshairImage,x,y,0,1,1,crosshairWidth/2,crosshairHeight/2)

        --draw the reloadrate beside the crosshair
        local margin = 2
        local width = 2
        local height = -math.min(math.max(gun.fireRateTimer/gun.fireRate,0) * crosshairHeight,crosshairHeight)
        local x = x + crosshairWidth/2 + margin
        local y = y + crosshairHeight/2
        love.graphics.rectangle("fill",x,y,width,height)
    end



    if self.gun then
        self.gun:draw()
    end
end 

return Player