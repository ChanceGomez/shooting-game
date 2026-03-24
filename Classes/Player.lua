local Player = {}
Player.__index = Player

function Player:new()
  local obj = setmetatable({}, Player)
  
  obj.gun = nil
  obj.resources = 11110
  obj.parachuteOdds = 30
  obj.dudPercentage = 20
  obj.health = 3
  obj.automaticReloading = false
  
  return obj
end

function Player:getVariable(name)
    if name == "Dud Damage" then
        return self.gun.duds.damage
    elseif name == "Bullet Damage" then
        return self.gun.bullets.damage
    elseif name == "Dud Chance" then 
        return self.dudPercentage
    elseif name == "Fire Rate" then
        return self.gun.fireRate
    elseif name == "Parachute Chance" then
        return self.parachuteOdds
    elseif name == "Reload Rate" then
        return self.gun.reloadRate
    elseif name == "Dud Fire Damage" then
        return self.gun.duds.fire.damage
    elseif name == "Dud Fire Duration" then
        return self.gun.duds.fire.duration
    elseif name == "Bullet Fire Damage" then
        return self.gun.bullets.fire.damage
    elseif name == "Bullet Fire Duration" then
        return self.gun.bullets.fire.duration
    elseif name == "Automatic Reloading" then
        return self.automaticReloading
    elseif name == "Max Ammo" then
        return self.gun.maxAmmo
    elseif name == "Fire Damage" then
        return self.gun.fireDamage
    end

    return -1
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