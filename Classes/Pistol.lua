local Pistol = {}
Pistol.__index = Pistol

function Pistol:new()
  local obj = setmetatable(Gun:new(), Pistol)
  
  obj.damage = 10
  obj.fireRate = 0.4
  obj.ammo = 4
  obj.maxAmmo = 4
  obj.reloadTime = 1.5
  obj.isReloading = false
  obj.crosshairImage = al:getImage("crosshair_pistol")
  obj.bulletAnimation = al:getAnimation("pistol_bullet_animation")

  return obj
end

function Pistol:fire()
    --Make sure gun can fire
    if self.isReloading or self.fireRateTimer < self.fireRate then
        return
    end
    --extract first frame and then get dimensions for adjustment on crosshair
    local extractionFrame = self.bulletAnimation[1]
    local w,h = extractionFrame:getDimensions()
    if Gun.fire(self,CursorX,CursorY) == false then return end
    ap:drawGroup("pistol",self.bulletAnimation,.05,CursorX - w/2,CursorY - h/2)
    self.fireRateTimer = 0
end

function Pistol:update(dt)
    Gun.update(self,dt)
end

function Pistol:draw()
    ap:drawGroup("pistol")
end


return Pistol