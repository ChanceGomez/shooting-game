local Gun = {}
Gun.__index = Gun

function Gun:new()
  local obj = setmetatable({}, Gun)
  
    obj.damage = 0
    obj.fireRate = 0    
    obj.fireRateTimer = 1000
    obj.ammo = 0
    obj.maxAmmo = 0
    obj.reloadTimer = 0
    obj.reloadTime = 0

  return obj
end

function Gun:fire()
    if game.lookouts[1].isHoveringButton then
        return false
    end
   self.ammo = self.ammo - 1
   game.lookouts[1].handler:checkHit(self.damage)
end

function Gun:update(dt)
    --update fire rate timer
    self.fireRateTimer = self.fireRateTimer + dt
    --Check to see if ammo is 0
    if self.ammo == 0 and not self.isReloading then
        self.isReloading = true
    end
    --if reloading start reload
    if self.isReloading then
        self.reloadTimer = self.reloadTimer + dt
        if self.reloadTimer >= self.reloadTime then
            self.ammo = self.maxAmmo
            self.reloadTimer = 0
            self.isReloading = false
        end
    end
end


return Gun