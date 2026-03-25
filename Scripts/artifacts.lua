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
        ids = {
            {"Automatic Reloading","bool",true},
            {"Reload Rate","mult",1.25}
        },
        description = {
            text = "start " .. getFormat("positive") .. "automatically reloading the chamber, " .. getFormat("negative") .. "-25% reload rate",
        },
        image = al:getImage("artifact_autoreload"),
    }
    self.artifacts.improvedAmmunition = {
        rarity = 2,
        ids = {
            {"Dud Damage","mult",1.50},
            {"Bullet Damage","mult",1.50},
            {"Dud Chance","mult",.75},
        },
        description = {
            text = "Increase damage from all bullets by " .. getFormat("positive") .. "50% aswell as " .. getFormat("positive") .. "-25% duds",
        },
        image = al:getImage("upgrademaxammo_shop_icon"),
    }
    self.artifacts.railGun = {
        rarity = 1,
        ids = {
            {"Bullet Damage","mult",5},
            {"Fire Rate","mult",3},
        },
        description = {
            text = "Increase bullet damage by " .. getFormat("positive") .. "500% but fire rate is increased by " .. getFormat("negative") .. "300%",
        },
        image = al:getImage("upgrademaxammo_shop_icon"),
    }
    self.artifacts.extendedMagazine = {
        rarity = 1,
        ids = {
            {"Max Ammo","add",3},
        },
        description = {
            text = "Increase ammo capacity by " .. getFormat("positive") .. "+3",
        },
        image = al:getImage("upgrademaxammo_shop_icon")
    }
    self.artifacts.increasedFireRate = {
        rarity = 1,
        ids = {
            {"Fire Rate","mult",.50},
            {"Bullet Damage","mult",.50},
            {"Dud Damage","mult",.50},
        },
        description = {
            text = "Increase fire rate by " .. getFormat("positive") .. "200% but reduce damage of all bullets by " .. getFormat("negative") .. "50%",  
        },
        image = al:getImage("upgrademaxammo_shop_icon")
    }
    self.artifacts.halfLifeDuds = {
        rarity = 1,
        ids = {
            {"Dud Damage","add",5},
            {"Dud Chance","mult",1.10},
        },
        description = {
            text = "Increase dud bullet damage by " .. getFormat("positive") .. "5 but increase duds by " .. getFormat("negative") .. "10%",
        },
        image = al:getImage("upgrademaxammo_shop_icon")
    }
    self.artifacts.lighterBullets = {
        rarity = 1,
        ids = {
            {"Bullet Damage","mult",.75},
            {"Reload Rate","mult",.55},
        },
        description = {
            text = "Increase reload rate by " .. getFormat("positive") .. "45% but reduce damage of all bullets by " .. getFormat("negative") .. "25%"
        },
        image = al:getImage("upgrademaxammo_shop_icon")
    }   
    self.artifacts.flamingDuds = {
        rarity = 1,
        ids = {
            {"Dud Fire Damage","add",5},
            {"Dud Fire Duration","add",3},
        },
        description = {
            text = "Duds now inflame enemies for " .. getFormat("positive") .. "+5 damage every second for " .. getFormat("positive") .. "+3 seconds"
        },
        image = al:getImage("upgrademaxammo_shop_icon")
    }
    self.artifacts.methaneAir = {
        rarity = 2,
        ids = {
            {"Dud Fire Damage","add",3},
            {"Dud Fire Duration","add",2},
            {"Bullet Fire Damage","add",3},
            {"Bullet Fire Duration","add",2},
            {"Fire Damage","mult",2},
        },
        description = {
            text = "All bullets now do " .. getFormat("positive") .. "+3 fire damage every second for " .. getFormat("positive") .. "+2 seconds, and increase fire damage " .. 
                getFormat("positive") .. "200%"
        },
        image = al:getImage("upgrademaxammo_shop_icon")
    }
    self.artifacts.extraSupplies = {
        rarity = 1,
        ids = {
            {"Parachute Chance","mult",1.5},
            {"Parachute Equipment Rarity","add",1},
        },
        description = {
            text = "Increase parachute chances by " .. getFormat("positive") .. "50% " .. "Increase equipment rarity by " .. 
                getFormat("positive") .. "1"
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
        --Get the artifact count
        self.artifactsCount = self.artifactsCount + 1
        --Get dimensions
        artifact.width = artifact.image:getWidth()
        artifact.height = artifact.image:getHeight()
        --default vars
        artifact.active = false
        --get default font
        if not artifact.description.font then
            artifact.description.font = dogica_8
        end

        if artifact.add == nil then
            artifact.add = function(self)
                self.active = true
                game.Affector:addIDs(self.ids)
                game.Player:addArtifact(self)
            end
        end
        if artifact.remove == nil then
            artifact.remove = function(self)
                self.active = false
                game.Affector:removeIDs(self.ids)
                game.Player:removeArtifact(self)
            end
        end
        --Create the update text function
        artifact.updateText = function(self)
            local ids = self.ids
            if self.active then return self.description.text .. '/n' .. game.Affector:getStats(ids) end
            return self.description.text .. " /n " .. game.Affector:getDescription(ids)
        end
    end
    --get keys
    for key in pairs(self.artifacts) do
        self.keys[#self.keys+1] = key
    end
end

function artifacts:activateArtifact(name)
    local artifact = deepCopy(self.artifacts[name]:add())
end

function artifacts:activateAllArtifacts()
    for name, artifact in pairs(self.artifacts) do
        self:activateArtifact(name)
    end
end

function artifacts:getArtifact(name)
    return self.artifacts[name]
end

function artifacts:getAllArtifacts()
    local tbl = {}
    for i, artifact in pairs(self.artifacts) do
        table.insert(tbl,artifact)
    end
    return tbl
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