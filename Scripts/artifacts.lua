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
        used = false,
        clicked = function(self)
            shop:artifactClicked()
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
        clicked = function(self)
            shop:artifactClicked()
            --Improve the damage of the bullets
            game.Player.gun.damage = game.Player.gun.damage * 1.50
            --Reduce amount of duds
            game.Player.dudPercentage = game.Player.dudPercentage * .75
        end,
        description = {
            text = "Increase damage from bullet by " .. getFormat("positive") .. "50% aswell as " .. getFormat("positive") .. "-25% duds",
        },
        image = al:getImage("upgrademaxammo_shop_icon"),
    }
    self.artifacts.railGun = {
        clicked = function(self)
            shop:artifactClicked()
            --Add damage multiplier
            game.Player.gun.damage = game.Player.gun.damage * 5
            --Add the firerate penalty
            game.Player.gun.fireRate = game.Player.gun.fireRate * 3.0
        end,
        description = {
            text = "Increase damage by " .. getFormat("positive") .. "500% but fire rate is increased by " .. getFormat("negative") .. "300%",
        },
        image = al:getImage("upgrademaxammo_shop_icon"),
    }
    self.artifacts.extendedMagazine = {
        clicked = function(self)
            shop:artifactClicked()
            game:getPlayerGun().maxAmmo = game:getPlayerGun().maxAmmo *2.0
        end,
        description = {
            text = "Increase ammo capacity by " .. getFormat("positive") .. "200%",
        },
        image = al:getImage("upgrademaxammo_shop_icon")
    }
    self.artifacts.increasedFireRate = {
        clicked = function(self)
            shop:artifactClicked()
            game:getPlayerGun().fireRate = game:getPlayerGun().fireRate / 2.0
            game.Player.gun.damage = game.Player.gun.damage * .50
        end,
        description = {
            text = "Increase fire rate by " .. getFormat("positive") .. "200% but reduce damage by " .. getFormat("negative") .. "50%",  
        },
        image = al:getImage("upgrademaxammo_shop_icon")
    }
    self.artifacts.halfLifeDuds = {
        clicked = function(self)
            game.Player.gun.dudDamage = 6
            game.Player.dudPercentage = game.Player.dudPercentage * 1.10
        end,
        description = {
            text = "Increase dud bullet damage by " .. getFormat("positive") .. "5 but increase duds by " .. getFormat("negative") .. "10%",
        },
        image = al:getImage("upgrademaxammo_shop_icon")
    }
    self.artifacts.lighterBullets = {
        clicked = function(self)
            game.Player.gun.damage = game.Player.gun.damage * .75
            game.Player.gun.reloadRate = game.Player.gun.reloadRate * .55
        end,
        description = {
            text = "Increase reload rate by " .. getFormat("positive") .. "45% but reduce damage by " .. getFormat("negative") .. " 25%"
        },
        image = al:getImage("upgrademaxammo_shop_icon")
    }
    --[[
    self.artifacts.flamingDuds = {
        clicked = function(self) 
        
        end,
        description = {
            text = ""
        },
        image = al:getImage("upgrademaxammo_shop_icon")
    }
    self.artifacts.horizontalLazer = {
        timer = 0,
        clicked = function(self)
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
    self.artifacts[name]:clicked()
end


function artifacts:getRandomArtifact()
    local key = self.keys[math.random(#self.keys)]
    if self.artifacts[key].used then
        return self:getRandomArtifact()
    end
    return self.artifacts[key]
end

return artifacts