local Gun = {}
Gun.__index = Gun

function Gun:new()
  local obj = setmetatable({}, Gun)
  
    obj.bullets = {
        damage = 10,
        fire = {
            damage = 0,
            duration = 0,
        }
    }
    obj.duds = {
        damage = 0,
        fire = {
            damage = 0,
            duration = 0,
        }
    }
    obj.fireRate = 0    
    obj.fireRateTimer = 1000
    obj.ammo = {}
    obj.maxAmmo = 0
    obj.canReload = false
    obj.reloadRate = 2
    obj.fireDamageMult = 1
    obj.fireDurationMult = 1


  return obj
end

function Gun:loadBullet(bullet)
    if #self.ammo >= game.Affector:trigger("Max Ammo",self.maxAmmo) then return end
    table.insert(self.ammo,bullet)
end

function Gun:fire()
    if self.ammo[1] == nil then return false end
    if game.lookouts[1].isHoveringButton then
        return false
    end
   game.lookouts[1].handler:checkHit(self.ammo[1].properties)
   game.lookouts[1].Report:action("shotFired")
   table.remove(self.ammo,1)
end

function Gun:update(dt)
    --update canReload bool
    self.canReload = #self.ammo < game.Affector:trigger("Max Ammo",self.maxAmmo)
    --update fire rate timer
    self.fireRateTimer = self.fireRateTimer + dt

    
end


return Gun