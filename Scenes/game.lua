local game = {
    Player = nil,
    Observer = nil,
    Affector = nil,
    lookouts = {},
    round = 1,
    pause = false,
    maxSpeed = 50,
}

--[[
    Get Methods
]]
function game:getHandler(lookoutNum)
    local lookoutNum = lookoutNum or 1
    return self.lookouts[lookoutNum].handler
end

function game:getReloadShelf(lookoutNum)
    local lookoutNum = lookoutNum or 1
    return self.lookouts[lookoutNum].ReloadShelf
end

function game:getPlayerGun()
    return self.Player.gun
end

--Charter system
function game:getVariable(name)
    local player = self.Player
    local gun = player.gun

    if name == "Dud Damage" then
        return player.gun.duds.bullet.damage
    elseif name == "Bullet Damage" then
        return player.gun.bullets.bullet.damage
    elseif name == "Dud Chance" then 
        return player.dudPercentage
    elseif name == "Fire Rate" then
        return player.gun.fireRate 
    elseif name == "Parachute Chance" then
        return player.parachuteOdds 
    elseif name == "Reload Rate" then
        return player.gun.reloadRate 
    elseif name == "Dud Fire Damage" then
        return player.gun.duds.fire.damage
    elseif name == "Dud Fire Duration" then
        return player.gun.duds.fire.duration 
    elseif name == "Bullet Fire Damage" then
        return player.gun.bullets.fire.damage
    elseif name == "Bullet Fire Duration" then
        return player.gun.bullets.fire.duration 
    elseif name == "Automatic Reloading" then
        return player.automaticReloading
    elseif name == "Max Ammo" then
        return player.gun.maxAmmo
    elseif name == "Fire Damage" then
        return player.gun.fireDamageMult
    elseif name == "Fire Duration" then
        return player.gun.fireDurationMult 
    elseif name == "Parachute Equipment Rarity" then
        return player.parachuteEquipmentRarity
    elseif name == "Bullet Stun Duration" then
        return player.gun.bullets.stun.duration
    elseif name == "Dud Stun Duration" then
        return player.gun.duds.stun.duration
    elseif name == "Grenade Damage" then
        return player.explosionProperties.explosion.damage
    elseif name == "Grenade Radius" then
        return player.explosionProperties.explosion.radius
    elseif name == "Grenade Cost" then
        return player.grenadeCost
    elseif name == "Max Grenade Count" then
        return player.maxGrenades
    elseif name == "Resource" then
        return player.resourceMultiplier
    end


    return nil
end

----------
function game:createLookout(enemies,difficulty,artifacts,images)
    self.lookouts[1] = Lookout.new(enemies,difficulty,artifacts,images)
end


function game:endRound(artifacts)
    endofround:getReport(self.lookouts[1].Report,artifacts)
    Scene = "endofround"
end

function game:load()
  self.canvas = love.graphics.newCanvas(window.GameWidth,window.GameHeight)
  self.Player = Player.new()
  self.Player:ChangeGun("pistol")

  self.Affector = Affector.new(self)
  Observer.new()

  --artifacts:activateAllArtifacts()
  --artifacts:activateArtifact("flamingDuds")
  --artifacts:activateArtifact("dudSurplus")
  --artifacts:activateArtifact("riskAndReward")
  -- artifacts:activateArtifact("flamingDuds")
end

function game:update(dt)

    if pClick then
        game.paused = not game.paused
    end

    --observer
    game.Observer:trigger("update")
  --update player
    if self.Player then
        self.Player:update(dt)
    end

    --Update lookouts
    if not game.paused then
        self.lookouts[1]:update(dt)
    end
end

function game:draw()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()

    love.graphics.setBackgroundColor(0.1,0.1,0.1)

    --Draw lookouts
    self.lookouts[1]:draw()

    love.graphics.setCanvas(mainCanvas)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.canvas)
end

return game