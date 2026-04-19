local artifacts = {
    artifacts = {},
    keys = {},
    artifactsCount = 0,
    colorFormat = {
        positive = {0,.7,0,1},
        negative = {.7,0,0,1},
    }
}

local function camelToReadable(s)
    s = s:gsub("(%u)", " %1")
    s = s:sub(1,1):upper() .. s:sub(2)
    return s
end

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
    self.artifacts.improvedAmmunition = {
        rarity = 2,
        ids = {
            {"Dud Damage","mult",.50},
            {"Bullet Damage","mult",.50},
            {"Dud Chance","mult",-.25},
        },
        description = {
            text = customtext:formatString("Improved Ammunition:", {.2,.2,.5,1}) ..
                " /n" .. getFormat(1) .. "Increases all bullet damage " .. getFormat(1) .. "and decreases dud chance",
        },
        image = assetloader:getImage("upgrademaxammo_shop_icon"),
    }

    self.artifacts.railGun = {
        rarity = 1,
        ids = {
            {"Bullet Damage","mult",5},
            {"Fire Rate","mult",-2},
        },
        description = {
            text = customtext:formatString("Rail Gun:", {.2,.2,.5,1}) ..
                " /n" .. getFormat(1) .. "Massively increases bullet damage " .. getFormat(-1) .. "but Massively decreases fire rate",
        },
        image = assetloader:getImage("upgrademaxammo_shop_icon"),
    }

    self.artifacts.extendedMagazine = {
        rarity = 1,
        ids = {
            {"Max Ammo","add",3},
        },
        description = {
            text = customtext:formatString("Extended Magazine:", {.2,.2,.5,1}) ..
                " /n" .. getFormat(1) .. "Increases ammo capacity",
        },
        image = assetloader:getImage("upgrademaxammo_shop_icon"),
    }

    self.artifacts.increasedFireRate = {
        rarity = 1,
        ids = {
            {"Fire Rate","mult",.50},
            {"Bullet Damage","mult",-.50},
            {"Dud Damage","mult",-.50},
        },
        description = {
            text = customtext:formatString("Increased Fire Rate:", {.2,.2,.5,1}) ..
                " /n" .. getFormat(1) .. "Increases fire rate " .. getFormat(-1) .. "but reduces all bullet damage",
        },
        image = assetloader:getImage("upgrademaxammo_shop_icon"),
    }

    self.artifacts.halfLifeDuds = {
        rarity = 1,
        ids = {
            {"Dud Damage","add",5},
            {"Dud Chance","mult",.10},
        },
        description = {
            text = customtext:formatString("Half Life Duds:", {.2,.2,.5,1}) ..
                " /n" .. getFormat(1) .. "Increases dud damage " .. getFormat(-1) .. "but increases dud chance",
        },
        image = assetloader:getImage("upgrademaxammo_shop_icon"),
    }

    self.artifacts.lighterBullets = {
        rarity = 1,
        ids = {
            {"Bullet Damage","mult",.25},
            {"Reload Rate","mult",.55},
        },
        description = {
            text = customtext:formatString("Lighter Bullets:", {.2,.2,.5,1}) ..
                " /n" .. getFormat(1) .. "Increases reload rate " .. getFormat(-1) .. "but reduces bullet damage",
        },
        image = assetloader:getImage("upgrademaxammo_shop_icon"),
    }

    self.artifacts.flamingDuds = {
        rarity = 1,
        ids = {
            {"Dud Fire Damage","add",5},
            {"Dud Fire Duration","add",3},
        },
        description = {
            text = customtext:formatString("Flaming Duds:", {.2,.2,.5,1}) ..
                " /n" .. getFormat(1) .. "Duds now ignite enemies dealing fire damage over time",
        },
        image = assetloader:getImage("upgrademaxammo_shop_icon"),
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
            text = customtext:formatString("Methane Air:", {.2,.2,.5,1}) ..
                " /n" .. getFormat(1) .. "All bullets ignite enemies and greatly increases fire damage",
        },
        image = assetloader:getImage("upgrademaxammo_shop_icon"),
    }

    self.artifacts.extraSupplies = {
        rarity = 1,
        used = false,
        ids = {
            {"Parachute Chance","add",25},
            {"Parachute Equipment Rarity","add",1},
        },
        description = {
            text = customtext:formatString("Extra Supplies:", {.2,.2,.5,1}) ..
                " /n" .. getFormat(1) .. "Increases parachute chance and improves equipment rarity from drops",
        },
        image = assetloader:getImage("upgrademaxammo_shop_icon"),
    }

    self.artifacts.dudSurplus = {
        rarity = 1,
        used = false,
        ids = {
            {"Dud Chance","add",100},
            {"Dud Damage","add",2},
            {"Fire Rate","mult",.5},
            {"Reload Rate","mult",.5},
            {"Automatic Reloading","bool",true},
        },
        description = {
            text = customtext:formatString("Dud Surplus:", {.2,.2,.5,1}) ..
                " /n" .. getFormat(-1) .. "Massively increases dud chance " .. getFormat(1) .. "but increases dud damage, fire rate, reload rate, and enables automatic reloading",
        },
        image = assetloader:getImage("upgrademaxammo_shop_icon"),
    }

    self.artifacts.ammoInspection = {
        rarity = 2,
        used = false,
        ids = {
            {"Dud Chance","add",-100},
            {"Bullet Damage","add",5},
            {"Reload Rate","mult",.20},
        },
        description = {
            text = customtext:formatString("Ammo Inspection:", {.2,.2,.5,1}) ..
                " /n" .. getFormat(1) .. "Massively decreases dud chance, increases bullet damage and reload rate",
        },
        image = assetloader:getImage("upgrademaxammo_shop_icon"),
    }

    self.artifacts.incendiaryRounds = {
        rarity = 2,
        ids = {
            {"Bullet Fire Damage","add",10},
            {"Bullet Fire Duration","add",5},
            {"Reload Rate","mult",.20},
        },
        description = {
            text = customtext:formatString("Incendiary Rounds:", {.2,.2,.5,1}) ..
                " /n" .. getFormat(1) .. "Bullets ignite enemies dealing heavy fire damage and increases reload rate",
        },
        image = assetloader:getImage("upgrademaxammo_shop_icon"),
    }

    self.artifacts.grenadeSurplus = {
        rarity = 1,
        ids = {
            {"Grenade Damage","add",10},
            {"Max Grenade Count","add",1},
            {"Grenade Cost","mult",-.50},
        },
        description = {
            text = customtext:formatString("Grenade Surplus:", {.2,.2,.5,1}) ..
                " /n" .. getFormat(1) .. "Increases grenade damage and capacity and reduces grenade cost",
        },
        image = assetloader:getImage("upgrademaxammo_shop_icon"),
    }

    self.artifacts.biggerGrenades = {
        rarity = 1,
        ids = {
            {"Grenade Damage","add",10},
            {"Grenade Radius","mult",1},
        },
        description = {
            text = customtext:formatString("Bigger Grenades:", {.2,.2,.5,1}) ..
                " /n" .. getFormat(1) .. "Increases grenade damage and doubles explosion radius",
        },
        image = assetloader:getImage("upgrademaxammo_shop_icon"),
    }

    self.artifacts.resourceful = {
        rarity = 2,
        ids = {
            {"Resource","mult",1},
        },
        description = {
            text = customtext:formatString("Resourceful:", {.2,.2,.5,1}) ..
                " /n" .. getFormat(1) .. "Doubles all resources gained",
        },
    }

    self.artifacts.explodingBirds = {
        rarity = 1,
        observerID = 0,
        used = false,
        event = {
            event = function(self, enemy)
                enemy.handler.newExplosion(enemy.handler, enemy.x+enemy.width/2, enemy.y+enemy.height/2, 15, 10)
            end
        },
        add = function(self)
            self.observerID = game.Observer:add("birdDied", self.event)
        end,
        remove = function(self)
            game.Observer:remove("birdDied", self.event)
        end,
        description = {
            text = customtext:formatString("Exploding Birds:", {.2,.2,.5,1}) ..
                " /n" .. getFormat(1) .. "Birds explode on death dealing damage in an area",
        },
    }

    self.artifacts.riskAndReward = {
        rarity = 1,
        ids = {
            {"Dud Chance","add",40},
            {"Bullet Damage","add",25},
        },
        description = {
            text = customtext:formatString("Risk And Reward:", {.2,.2,.5,1}) ..
                " /n" .. getFormat(-1) .. "Increases dud chance " .. getFormat(1) .. "but greatly increases bullet damage",
        },
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

        artifact.name = camelToReadable(i)


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
        print"hello"
        return self:getRandomArtifact(rarity)
    end
    return self.artifacts[key]
end

return artifacts