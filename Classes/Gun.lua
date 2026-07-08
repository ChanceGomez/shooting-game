local Gun = {}
Gun.__index = Gun

function Gun.new()
  local obj = setmetatable({}, Gun)
  
    obj.bullets = {
        bullet = {
            type = "Bullet",
            interval = 0,
            damage = 10,
            duration = 0,
            executable = function(effect,enemy)
                enemy:damage(effect.damage)
            end,
        },
        fire = {
            type = "Bullet Fire",
            interval = 1,
            damage = 0,
            duration = 0,
            executable = function(effect,enemy)
                enemy:damage(effect.damage)
            end
        },
        stun = {
            type = "Bullet Stun",
            interval = 0,
            damage = 0,
            duration = 0,
            executable = function(effect,enemy)
                enemy:stun()
            end
        },
    }
    obj.duds = {
        bullet = {
            type = "Dud",
            interval = 0,
            damage = 0,
            duration = 0,
            executable = function(effect,enemy)
                enemy:damage(effect.damage)
            end,
        },
        fire = {
            type = "Dud Fire",
            interval = 1,
            damage = 0,
            duration = 0,
            executable = function(effect,enemy)
                enemy:damage(effect.damage)
            end
        },
        stun = {
            type = "Dud Stun",
            interval = 0,
            damage = 0,
            duration = 0,
            executable = function(self,enemy)
                enemy:stun()
            end
        },
    }
    obj.fireRate = 0    
    obj.fireRateTimer = 1000
    obj.ammo = {}
    obj.maxAmmo = 0
    obj.canReload = false
    obj.reloadRate = 2
    obj.fireDamageMult = 1
    obj.fireDurationMult = 1

    obj.audios = {
        shot = assetloader:getAudio("bulletshot")
    }
    obj.audios.shot:setPitch(cosmeticRandom:random(.95,1))
    obj.audios.shot:setVolume(.25)

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


    --Get bullets properties
    local properties = self.ammo[1].properties
    
    --Calculate all the effects
    for i, effect in pairs(properties) do 
        effect.damage = game.Affector:trigger(effect.type .. " Damage")
        effect.duration = game.Affector:trigger(effect.type .. " Duration")
    end

    --Send each effect to the enemy
    game.lookouts[1].handler:checkHit(properties)


    --Report an action
    game.lookouts[1].Report:action("shotFired")

    --remove bullet
    table.remove(self.ammo,1)

    --Play sound
    love.audio.play(self.audios.shot)
end

function Gun:update(dt)
    --update canReload bool
    self.canReload = #self.ammo < game.Affector:trigger("Max Ammo",self.maxAmmo)
    --update fire rate timer
    self.fireRateTimer = self.fireRateTimer + dt

    
end


return Gun