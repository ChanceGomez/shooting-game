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

    local name = name

    if name == 1 then
        name = "positive"
    elseif name == -1 then
        name = "negative"
    end
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
    --[[
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
    }]]
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
        image = assetloader:getImage("upgrademaxammo_shop_icon"),
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
        image = assetloader:getImage("upgrademaxammo_shop_icon"),
    }
    self.artifacts.extendedMagazine = {
        rarity = 1,
        ids = {
            {"Max Ammo","add",3},
        },
        description = {
            text = "Increase ammo capacity by " .. getFormat("positive") .. "+3",
        },
        image = assetloader:getImage("upgrademaxammo_shop_icon")
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
        image = assetloader:getImage("upgrademaxammo_shop_icon")
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
        image = assetloader:getImage("upgrademaxammo_shop_icon")
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
        image = assetloader:getImage("upgrademaxammo_shop_icon")
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
        image = assetloader:getImage("upgrademaxammo_shop_icon")
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
        image = assetloader:getImage("upgrademaxammo_shop_icon")
    }
    self.artifacts.extraSupplies = {
        rarity = 1,
        used = false,
        ids = {
            {"Parachute Chance","mult",1.5},
            {"Parachute Equipment Rarity","add",1},
        },
        description = {
            text = "Increase parachute chances by " .. getFormat("positive") .. "50% " .. "Increase equipment rarity by " .. 
                getFormat("positive") .. "1"
        },
        image = assetloader:getImage("upgrademaxammo_shop_icon")
    }
    self.artifacts.dudSurplus = {
        rarity = 1,
        ids = {
            {"Dud Chance","add",1000},
            {"Dud Damage","add",2},
            {"Fire Rate","mult",.5},
            {"Reload Rate","mult",.5},
            {"Automatic Reloading","bool",true},
        },
        used = false,
        description = {
            text = "Increase dud chance by " .. getFormat("negative") .. "1000 " .. " but Increase dud damage by " .. 
                getFormat("positive") .. "+2" .. " Increase fire rate & reload rate by ".. getFormat("positive") .. "50%" .. " and " .. getFormat("positive") .. "automatic loading"
        },
        image = assetloader:getImage("upgrademaxammo_shop_icon")
    }
    self.artifacts.ammoInspection = {
        rarity = 2,
        ids = {
            {"Dud Chance","add",-1000},
            {"Bullet Damage","add",5},
            {"Reload Rate","mult",.8},
        },
        used = false,
        description = {
            text = "Decrease dud chance by " .. getFormat("positive") .. "1000 " .. " but Increase bullet damage by " .. 
                getFormat("positive") .. "+5" .. " Increase reload rate by ".. getFormat("positive") .. "20%"
        },
        image = assetloader:getImage("upgrademaxammo_shop_icon")
    }
    self.artifacts.incendiaryRounds = {
        rarity = 2,
        ids = {
            {"Bullet Fire Damage","add",10},
            {"Bullet Fire Duration","add",5},
            {"Reload Rate","mult",.8},
        },
        description = {
            text = "Increase Fire Damage by " .. getFormat(1) .. "+10" .. " Increase Fire Duration by " .. getFormat(1) .. "+5" .. " and increase Reload Rate by " .. getFormat(1) .. "20%"
        },
        image = assetloader:getImage("upgrademaxammo_shop_icon")
    }
    self.artifacts.grenadeSurplus = {
        rarity = 1,
        ids = {
            {"Grenade Damage","add",10},
            {"Max Grenade Count","add",1},
            {"Grenade Cost","mult",.5},
        },
        description = {
            text = "Increase grenade damage by +10, max grenade count by +1, reduce grenade cost by 50%"
        },
        image = assetloader:getImage("upgrademaxammo_shop_icon")
    }
    self.artifacts.biggerGrenades = {
        rarity = 1,
        ids = {
            {"Grenade Damage","add",10},
            {"Grenade Radius","mult",2},
        },
        description = {
            text = "Increase grenade damage by +5 and double the radius of grenades"
        },
        image = assetloader:getImage("upgrademaxammo_shop_icon")
    }
    self.artifacts.resourceful = {
        rarity = 2,
        ids = {
            {"Resource","mult",2}
        },
        description = {
            text = "Increase resources gained by x2",
        },
    }
    self.artifacts.explodingBirds = {
        rarity = 1,
        observerID = 0,
        used = false,
        event = {
            event = function(self,enemy)
                enemy.handler.newExplosion(enemy.handler,enemy.x+enemy.width/2,enemy.y+enemy.height/2,15,10)
            end
        },
        add = function(self)
            self.observerID = game.Observer:add("birdDied",self.event)
        end,
        remove = function(self)
            game.Observer:remove("birdDied",self.event)
        end,
        description = {
            text = "Birds now explode on death bird explosions: radius + 15, damage + 10"
        }
    }
    self.artifacts.riskAndReward = {
        rarity = 1,
        ids = {
            {"Dud Chance","add",40},
            {"Bullet Damage","add",25},
        },
        description = {
            text = "Increase dud chance +50 points but increase bullet damage by +25"
        }
    }
    
    --[[
self.artifacts. = {

    }
    self.artifacts.horizontalLazer = {
        timer = 0,
        event = function(self)
            game.Observer:add("lookoutUpdate",{event = function(self,wrapper)
                artifacts.artifacts.horizontalLazer.timer = artifacts.artifacts.horizontalLazer.timer + wrapper.dt
                if artifacts.artifacts.horizontalLazer.timer > 3 then
                    table.insert(game.lookouts[1].lazors,Lazor.new(0,math.random(40,320),3))
                end
            end,})
        end,
        description = {
            text = "Every 5 seconds a horizontal lazer appears on the screen and lasts 3 seconds. deals 10 damage per tick"
        },
        image = assetloader:getImage("upgrademaxammo_shop_icon")
    }
        ]]


    --get count of how many artifacts and get there widths/heights aswell as add the fonts for description
    for i, artifact in pairs(self.artifacts) do
        --Get the artifact count
        self.artifactsCount = self.artifactsCount + 1

        artifact.id = self.artifactsCount

        --check to see if image if not load default
        if artifact.image == nil then
            artifact.image = assetloader:getImage("upgrademaxammo_shop_icon")
        end
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
                if artifact.used == false then 
                    artifact.used = true
                end

                self.active = true
                game.Affector:addIDs(self.ids)
                game.Player:addArtifact(self)
            end
        end
        if artifact.remove == nil then
            artifact.remove = function(self)
                if artifact.removed == true then 
                    artifact.used = false
                end
                self.active = false
                game.Affector:removeIDs(self.ids)
                game.Player:removeArtifact(self)
            end
        end
        --Create the update text function
        artifact.updateText = function(self)
            local ids = artifact.ids
            if ids == nil or type(ids) ~= "table" then return self.description.text end
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

function artifacts:getUniqueArtifacts(amount,rarity)
    local rarity = rarity or 1
    local amount = amount or 1
    local tbl = {}

    --Start with random first selection
    table.insert(tbl,self:getRandomArtifact(rarity))
    local recursiveCount = 0
    while #tbl < amount and recursiveCount < 100 do
        recursiveCount = recursiveCount + 1
        local valid = true
        local artifact = self:getRandomArtifact(rarity)
        for i, instance in ipairs(tbl) do
            if instance == artifact then
                valid = false
            end
        end

        if valid then 
            table.insert(tbl,artifact) 
        end
    end

    return tbl
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