local artifacts = {
    artifacts = {},
    keys = {},
    artifactsCount = 0,
    colorFormat = {
        positive = {0,.7,0,1},
        negative = {.7,0,0,1},
    }
}

local function getFormat(name)
    local returnString = "{"
    for i, number in ipairs(artifacts.colorFormat[name]) do
        returnString = returnString .. number
        if i == 4 then
            returnString = returnString .. "}"
            break
        end
        returnString = returnString .. ","
    end
    return returnString
end

function artifacts:load()
    --load artifacts
    self.artifacts.autoReload = {
        rarity = 2,
        used = false,
        event = function(self)
            game.Observer:add("lookoutUpdate",{
                event = function()
                    game:getReloadShelf().autoReload = true
                end,
            })
            artifacts.artifacts.autoReload.used = true
            game.Player.gun.reloadRate = game.Player.gun.reloadRate * 1.25
        end,
        description = {
            text = "start " .. getFormat("positive") .. "automatically reloading the chamber, " .. getFormat("negative") .. "-25% reload speed",
        },
        image = al:getImage("artifact_autoreload"),
    }
    self.artifacts.improvedAmmunition = {
        rarity = 2,
        event = function(self)
            --Improve the damage of the bullets
            local bullet = game:getPlayerGun().bullets
            bullet.damage = bullet.damage * 1.50
            --Reduce amount of duds
            game.Player.dudPercentage = game.Player.dudPercentage * .75
        end,
        description = {
            text = "Increase damage from bullet by " .. getFormat("positive") .. "50% aswell as " .. getFormat("positive") .. "-25% duds",
        },
        image = al:getImage("upgrademaxammo_shop_icon"),
    }
    self.artifacts.railGun = {
        rarity = 1,
        event = function(self)
            --Add damage multiplier
            local bullet = game:getPlayerGun().bullets
            bullet.damage = bullet.damage * 5
            --Add the firerate penalty
            game.Player.gun.fireRate = game.Player.gun.fireRate * 3.0
        end,
        description = {
            text = "Increase bullet damage by " .. getFormat("positive") .. "500% but fire rate is increased by " .. getFormat("negative") .. "300%",
        },
        image = al:getImage("upgrademaxammo_shop_icon"),
    }
    self.artifacts.extendedMagazine = {
        rarity = 1,
        event = function(self)
            game:getPlayerGun().maxAmmo = game:getPlayerGun().maxAmmo *3.0
        end,
        description = {
            text = "Increase ammo capacity by " .. getFormat("positive") .. "300%",
        },
        image = al:getImage("upgrademaxammo_shop_icon")
    }
    self.artifacts.increasedFireRate = {
        rarity = 1,
        event = function(self)
            game:getPlayerGun().fireRate = game:getPlayerGun().fireRate / 2.0

            local dud = game:getPlayerGun().duds
            dud.damage = dud.damage * .50
            local bullet = game:getPlayerGun().bullets
            bullet.damage = bullet.damage * .50
        end,
        description = {
            text = "Increase fire rate by " .. getFormat("positive") .. "200% but reduce damage of all bullets by " .. getFormat("negative") .. "50%",  
        },
        image = al:getImage("upgrademaxammo_shop_icon")
    }
    self.artifacts.halfLifeDuds = {
        rarity = 1,
        event = function(self)
            local dud = game:getPlayerGun().duds
            dud.damage = dud.damage + 5

            game.Player.dudPercentage = game.Player.dudPercentage * 1.10
        end,
        description = {
            text = "Increase dud bullet damage by " .. getFormat("positive") .. "5 but increase duds by " .. getFormat("negative") .. "10%",
        },
        image = al:getImage("upgrademaxammo_shop_icon")
    }
    self.artifacts.lighterBullets = {
        rarity = 1,
        event = function(self)
            local dud = game:getPlayerGun().duds
            dud.damage = dud.damage * .75
            local bullet = game:getPlayerGun().bullets
            bullet.damage = bullet.damage * .75


            game.Player.gun.reloadRate = game.Player.gun.reloadRate * .55
        end,
        description = {
            text = "Increase reload rate by " .. getFormat("positive") .. "45% but reduce damage of all bullets by " .. getFormat("negative") .. "25%"
        },
        image = al:getImage("upgrademaxammo_shop_icon")
    }   
    self.artifacts.flamingDuds = {
        rarity = 1,
        event = function(self) 
            local dud = game:getPlayerGun().duds.fire
            dud.damage = dud.damage + 5
            dud.duration = dud.duration + 3
        end,
        description = {
            text = "Duds now inflame enemies for " .. getFormat("positive") .. "+5 damage every second for " .. getFormat("positive") .. "+3 seconds"
        },
        image = al:getImage("upgrademaxammo_shop_icon")
    }
    self.artifacts.methaneAir = {
        rarity = 2,
        event = function(self)
            local dud = game:getPlayerGun().duds.fire
            dud.damage = dud.damage + 3
            dud.duration = dud.duration + 2
            local bullet = game:getPlayerGun().bullets.fire
            bullet.damage = bullet.damage + 3
            bullet.duration = bullet.duration + 2

            game.Affector:add("fireDamage",function(damage)
                return damage * 2
            end)
        end,
        description = {
            text = "All bullets now do " .. getFormat("positive") .. "+3 fire damage every second for " .. getFormat("positive") .. "+2 seconds, and increase fire damage " .. 
                getFormat("positive") .. "200%"
        },
        image = al:getImage("upgrademaxammo_shop_icon")
    }
    --[[

    self.artifacts.horizontalLazer = {
        timer = 0,
        event = function(self)
            game.Observer:add("lookoutUpdate",{event = function(self,wrapper)
                artifacts.artifacts.horizontalLazer.timer = artifacts.artifacts.horizontalLazer.timer + wrapper.dt
                if artifacts.artifacts.horizontalLazer.timer > 3 then
                    table.insert(game.lookouts[1].lazors,Lazor:new(0,math.random(40,320),3))
                end
            end,})
        end,
        description = {
            text = "Every 5 seconds a horizontal lazer appears on the screen and lasts 3 seconds. deals 10 damage per tick"
        },
        image = al:getImage("upgrademaxammo_shop_icon")
    }
        ]]
    --get count of how many artifacts and get there widths/heights aswell as add the fonts for description
    for i, artifact in pairs(self.artifacts) do
        self.artifactsCount = self.artifactsCount + 1
        artifact.width = artifact.image:getWidth()
        artifact.height = artifact.image:getHeight()
        if not artifact.description.font then
            artifact.description.font = perfect_dos_16
        end
    end
    --get keys
    for key in pairs(self.artifacts) do
        self.keys[#self.keys+1] = key
    end
end

function artifacts:activateArtifact(name)
    self.artifacts[name]:event()
end


function artifacts:getRandomArtifact(rarity)
    local key = self.keys[math.random(#self.keys)]
    if self.artifacts[key].rarity ~= rarity then 
        return self:getRandomArtifact(rarity)
    end
    if self.artifacts[key].used then
        return self:getRandomArtifact(rarity)
    end
    return self.artifacts[key]
end

return artifacts