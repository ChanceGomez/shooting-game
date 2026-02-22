local Gun = {}
Gun.__index = Gun

function Gun:new()
  local obj = setmetatable({}, Gun)
  
    obj.damage = 0
    obj.fireRate = 0    
    obj.fireRateTimer = 1000
    obj.ammo = {}
    obj.maxAmmo = 0
    obj.canReload = false

  return obj
end

function Gun:loadBullet(bullet)
    if #self.ammo >= self.maxAmmo then return end
    table.insert(self.ammo,bullet)
end

function Gun:increaseDamage(damage)
    local damage = damage or 1
    if damage >= 1 then
        self.damage = self.damage + damage
    end
end

function Gun:increaseMaxAmmo(ammo)
    local ammo = ammo or 1
    if ammo >= 1 then
        self.maxAmmo = self.maxAmmo + ammo
    end
end

function Gun:fire()
    if self.ammo[1] == nil then return false end
    if game.lookouts[1].isHoveringButton then
        return false
    end
   game.lookouts[1].handler:checkHit(self.ammo[1].damage * self.damage)
   game.lookouts[1].Report:action("shotFired")
   table.remove(self.ammo,1)
end

function Gun:update(dt)
    --update canReload bool
    self.canReload = #self.ammo < self.maxAmmo
    --update fire rate timer
    self.fireRateTimer = self.fireRateTimer + dt
end


return Gun