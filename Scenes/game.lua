local game = {
    Player = nil,
    Observer = nil,
    Affector = nil,
    lookouts = {},
    round = 1,
    pause = false,
    maxSpeed = 50,
    seed = 1,
}

game.stats = {
    ["Dud Damage"] = {
        get = function() return game.Player.gun.duds.bullet.damage end,
        mode = "multiply",
    },
    ["Bullet Damage"] = {
        get = function() return game.Player.gun.bullets.bullet.damage end,
        mode = "multiply",
    },
    ["Dud Chance"] = {
        get = function() return game.Player.dudPercentage end,
        mode = "multiply",
    },
    ["Fire Rate"] = {
        get = function() return game.Player.gun.fireRate end,
        mode = "divide",
    },
    ["Parachute Chance"] = {
        get = function() return game.Player.parachuteOdds end,
        mode = "multiply",
    },
    ["Reload Rate"] = {
        get = function() return game.Player.gun.reloadRate end,
        mode = "divide",
    },
    ["Dud Fire Damage"] = {
        get = function() return game.Player.gun.duds.fire.damage end,
        mode = "multiply",
    },
    ["Dud Fire Duration"] = {
        get = function() return game.Player.gun.duds.fire.duration end,
        mode = "multiply",
    },
    ["Bullet Fire Damage"] = {
        get = function() return game.Player.gun.bullets.fire.damage end,
        mode = "multiply",
    },
    ["Bullet Fire Duration"] = {
        get = function() return game.Player.gun.bullets.fire.duration end,
        mode = "multiply",
    },
    ["Automatic Reloading"] = {
        get = function() return game.Player.automaticReloading end,
        mode = "bool",
    },
    ["Max Ammo"] = {
        get = function() return game.Player.gun.maxAmmo end,
        mode = "multiply",
    },
    ["Fire Damage"] = {
        get = function() return game.Player.gun.fireDamageMult end,
        mode = "multiply",
    },
    ["Fire Duration"] = {
        get = function() return game.Player.gun.fireDurationMult end,
        mode = "multiply",
    },
    ["Parachute Equipment Rarity"] = {
        get = function() return game.Player.parachuteEquipmentRarity end,
        mode = "multiply",
    },
    ["Bullet Stun Duration"] = {
        get = function() return game.Player.gun.bullets.stun.duration end,
        mode = "multiply",
    },
    ["Dud Stun Duration"] = {
        get = function() return game.Player.gun.duds.stun.duration end,
        mode = "multiply",
    },
    ["Grenade Damage"] = {
        get = function() return game.Player.explosionProperties.explosion.damage end,
        mode = "multiply",
    },
    ["Grenade Radius"] = {
        get = function() return game.Player.explosionProperties.explosion.radius end,
        mode = "multiply",
    },
    ["Grenade Cost"] = {
        get = function() return game.Player.grenadeCost end,
        mode = "multiply",
    },
    ["Max Grenade Count"] = {
        get = function() return game.Player.maxGrenades end,
        mode = "multiply",
    },
    ["Resource"] = {
        get = function() return game.Player.resourceMultiplier end,
        mode = "multiply",
    },
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

function game:getVariable(name)
    local stat = self.stats[name]
    if not stat then return nil end
    return stat.get(), stat.mode
end

function game:createLookout(enemies,difficulty,artifacts,images)
    self.lookouts[1] = Lookout.new(enemies,difficulty,artifacts,images)
end

function game:createTutorial()
    self.lookouts[1] = TutorialLookout.new()
end

function game:endRound(artifacts)
    endofround:getReport(self.lookouts[1].Report,artifacts)
    love.audio.stop()
    Scene = "endofround"
end

function game:load()
  self.canvas = love.graphics.newCanvas(window.GameWidth,window.GameHeight)
  self.Player = Player.new()
  self.Player:ChangeGun("cannon")

  self.Affector = Affector.new(self)
  self.Observer = Observer.new()

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

    love.graphics.setColor(.1,.1,.1,1)
    love.graphics.rectangle("fill",0,0,window.GameWidth,window.GameHeight)

    --Draw lookouts
    self.lookouts[1]:draw()

    love.graphics.setCanvas(mainCanvas)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.canvas)
end

return game