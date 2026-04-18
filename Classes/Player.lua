local Player = {}
Player.__index = Player

function Player.new()
    local obj = setmetatable({}, Player)

    obj.gun = nil
    obj.resources = 0
    obj.parachuteOdds = 20
    obj.dudPercentage = 20
    obj.health = 3
    obj.automaticReloading = false
    obj.artifacts = {}
    obj.parachuteEquipmentRarity = 1
    obj.grenades = 3
    obj.maxGrenades = 3

    --costs
    obj.grenadeCost = 50
    obj.grenadeRadiusCost = 20
    obj.grenadeDamageCost = 5


    obj.resourceMultiplier = 1
    obj.explosionProperties = {
        explosion = {
            type = "Grenade",
            interval = 0,
            damage = 20,
            radius = 20,
            duration = 0,
            executable = function(self,enemy)
                enemy:damage(self.damage) 
            end
        }
    }

    if settings.debug then
        obj.resources = 1000000
    end

    return obj
end

function Player:checkLose()
    if self.health <= 0 and settings.canDie then
        Scene = "losescreen"
    end
end

function Player:addResources(resources)
    local resources = resources * game.Affector:trigger("Resource")
    game.Player.resources = game.Player.resources + resources
    game.lookouts[1].Report:action("resources",resources)
end

function Player:addArtifact(artifact)
    table.insert(self.artifacts,artifact)
end

function Player:removeArtifact(artifact)
    for i, instance in ipairs(self.artifacts) do
        if instance == artifact then
            table.remove(self.artifacts,i)
        end
    end
end

function Player:ChangeGun(gun)
    self.gun = Guns[gun].new()
end

function Player:fireGun()
    if self.gun and love.mouse.isDown(1) then
        self.gun:fire()
    end
end

function Player:useExplosion()
    if self.grenades <= 0 then return end
    self.grenades = self.grenades - 1
    local explosion = self.explosionProperties
    game:getHandler():newExplosion(CursorX,CursorY,explosion.radius,explosion.damage,explosion.duration)
end

function Player:purchase(cost)
    if self.resources >= cost then
        self.resources = self.resources - cost
        return true
    end
    return false
end

function Player:update(dt)
    self:checkLose()

    if leftHeld then
        self:fireGun()
    end 

    if rightReleased then
        self:useExplosion()
    end

    if self.gun then
        self.gun:update(dt)
    end
end

function Player:draw()
    --get easy access variables
    local x,y = CursorX,CursorY

    --draw explosion area
    if love.mouse.isDown(2) and self.grenades > 0 then
        love.graphics.setColor(.7,.7,.7,.5)
        love.graphics.circle("fill",CursorX,CursorY,game.Affector:trigger("Grenade Radius"))   
    end

    love.graphics.setColor(1,1,1,1)
    --draw the cursor if hovering over a button
    if game.lookouts[1].isHoveringButton then
        local cursorImage = assetloader:getImage("cursor")
        local cursorWidth, crosshairHeight = cursorImage:getDimensions()
        love.graphics.draw(cursorImage,x,y)
    --draw the crosshair
    else
        --Ease of access vars
        local gun = self.gun
        local crosshairImage = assetloader:getImage("crosshair")
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


    --draw ammo count
        --make max ammo background
        local x,y = 4,296
        local width,height = 24,8
        local margin = 4
        for i = 1, game.Affector:trigger("Max Ammo",game.Player.gun.maxAmmo) do
            local color = {.4,.4,.4,.7}
            love.graphics.setColor(color)
            love.graphics.rectangle("fill",x,y-(i*(height+margin)),width,height)
        end

        --show current ammo
        local x,y = 4,296
        local width,height = 24,8
        local margin = 4
        for i, bullet in ipairs(game.Player.gun.ammo) do
            local color = {1,1,1,1}
            if bullet.isDud then
                color = {.6,0,0,1}
            end
            love.graphics.setColor(color)
            love.graphics.rectangle("fill",x,y-(i*(height+margin)),width,height)
        end

    --Draw explosion count
        local x,y = 36,window.GameHeight
        local margin = 2
        local image = assetloader:getImage("bomb_ammo")
        
        for i = 1, self.grenades do
            local bombX,bombY = x, y - (i*(image:getWidth()+margin))
            love.graphics.setColor(1,1,1,1)
            love.graphics.draw(image,bombX,bombY)
        end


    if self.gun then
        self.gun:draw()
    end
end 

return Player