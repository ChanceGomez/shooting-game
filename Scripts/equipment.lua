local equipment = {
    equipments = {},
    keys = {},
    equipmentCount = 0,
    colorFormat = {
        positive = {0,.7,0,1},
        negative = {.7,0,0,1},
    }
}

local function getFormat(name)
    local returnString = "{"
    for i, number in ipairs(equipment.colorFormat[name]) do
        returnString = returnString .. number
        if i == 4 then
            returnString = returnString .. "}"
            break
        end
        returnString = returnString .. ","
    end
    return returnString
end

function equipment:load()
    --load artifacts
    self.equipments.titaniumBarrel = {
        rarity = 1,
        type = "barrel",
        ids = {
            {"Fire Rate","mult",.75},
        },
        description = {
            text = "{.2,.2,.5}Titanium {.2,.2,.5}Barrel: " .. "/nIncrease Fire Rate by 25%",
        },
        image = assetloader:getImage("equipment_barrelimprovement"),
    }
    self.equipments.titaniumStabalizer = {
        rarity = 1,
        type = "stabalizer",
        ids = {
            {"Dud Chance","mult",.75},
        },
        description = {
            text = "{.2,.2,.5}Titanium {.2,.2,.5}Stabilizer: " .. "/nDecrease dud chance by 25%",
        },
        image = assetloader:getImage("equipment_barrelimprovement"),
    }
    self.equipments.titaniumReloader = {
        rarity = 1,
        type = "reloader",
        ids = {
            {"Reload Rate","mult",.75},
        },
        description = {
            text = "{.2,.2,.5}Titanium {.2,.2,.5}Reloader: " .. "/nIncrease reload rate by 25%",
        },
        image = assetloader:getImage("equipment_barrelimprovement"),
    }
    self.equipments.titaniumAntenna = {
        rarity = 1,
        type = "antenna",
        ids = {
            {"Parachute Chance","mult",1.25},
        },
        description = {
            text = "{.2,.2,.5}Titanium {.2,.2,.5}Antenna: " .. "/nIncrease parachutes by 25%",
        },
        image = assetloader:getImage("equipment_barrelimprovement"),
    }
    self.equipments.titaniumBase = {
        rarity = 1,
        type = "base",
        ids = {
            {"Reload Rate","mult",.90},
            {"Fire Rate","mult",.90},
        },
        description = {
            text = "{.2,.2,.5}Titanium {.2,.2,.5}Base: " .. "/nIncrease reload rate by 10%, fire rate by 10%",
        },
        image = assetloader:getImage("equipment_barrelimprovement"),
    }
    self.equipments.jankyBase = {
        rarity = 1,
        type = "base",
        ids = {
            {"Dud Chance","mult",1.50},
            {"Dud Damage","mult",1.50},
        },
        description = {
            text = "{.2,.2,.5}Janky {.2,.2,.5}Base: " .. "/nIncrease dud chance by 50%, increase dud damage by 50%", 
        },
        image = assetloader:getImage("equipment_barrelimprovement"),
    }
    self.equipments.greasedBarrel = {
        rarity = 1,
        type = "barrel",
        ids = {
            {"Fire Rate","mult",.85},
            {"Reload Rate","mult",.85},
        },
        description = {
            text = customtext:formatString("Greased Barrel:",{.2,.2,.5,1}) .. " /nIncrease fire rate and reload rate by 15%",
        }
    }
    self.equipments.igniterStabilizer = {
        rarity = 2,
        type = "stabalizer",
        ids = {
            {"Fire Damage","add",5},
            {"Fire Duration","mult",2},
        },
        description = {
            text = customtext:formatString("Igniter Stabilizer:",{.2,.2,.5,1}) .. " /nIncrease fire damage by +5, and double fire duration"
        }
    }
    self.equipments.railgunBase = {
        rarity = 2,
        type = "base",
        ids = {
            {"Bullet Damage","add",10},
            {"Dud Damage","add",10},
            {"Reload Rate","mult",2},
        },
        description = {
            text = customtext:formatString("Railgun Base:",{.2,.2,.5,1}) .. " /nIncrease all bullet damage by + 10, but -50% reload rate"
        }
    }
    self.equipments.higheffieciencyReloader = {
        rarity = 2,
        type = "reloader",
        ids = {
            {"Reload Rate","mult",.33},
            {"Fire Rate","mult",.75},
            {"Bullet Damage","mult",.70},
            {"Dud Damage","mult",.70},
            {"Fire Damage","mult",.5},
        },
        description = {
            text = customtext:formatString("High Effieciency Reloader:",{.2,.2,.5,1}) .. " /nDecrease reload rate by 66%, and decrease fire rate by 25%, but -30% damage, -50% fire damage"
        }
    }
    self.equipments.advancedIntel = {
        rarity = 1,
        type = "antenna",
        add = function()
            self.active = true
            settings.hitbox = true
            settings.showHealth = true
        end,
        remove = function()
            self.active = false
            settings.hitboxe = false
            settings.showHealth = false
        end,
        description = {
            text = customtext:formatString("Advanced Intel Antenna:",{.2,.2,.5,1}) .. " /nShow enemy health and hitboxes"
        }
    }


    --loop through to init variables/functions
    for i, equipment in pairs(self.equipments) do
        --count up for total equipment
        self.equipmentCount = self.equipmentCount + 1

        if equipment.image == nil then
            equipment.image = assetloader:getImage("equipment_barrelimprovement")
        end

        --get height/width
        equipment.width = equipment.image:getWidth()
        equipment.height = equipment.image:getHeight()

        --default vars
        equipment.active = false

        --set default font
        if not equipment.description.font then
            equipment.description.font = dogica_8
        end

        --create the add/remove functions
        if equipment.add == nil then
            equipment.add = function(self)
                self.active = true
                game.Affector:addIDs(self.ids)
            end
        end
        if equipment.remove == nil then
            equipment.remove = function(self)
                self.active = false
                game.Affector:removeIDs(self.ids)
            end
        end

        --Create the update text function
        equipment.updateText = function(self)
            if self.ids == nil then return self.description.text end
            local ids = self.ids
            if self.active then return self.description.text .. '/n' .. game.Affector:getStats(ids) end
            return self.description.text .. " /n " .. game.Affector:getDescription(ids)
        end
    end
    --get keys
    for key in pairs(self.equipments) do
        self.keys[#self.keys+1] = key
    end
end

function equipment:getAllEquipment()
    return deepCopy(self.equipments)
end

function equipment:getEquipment(name)
    return self.equipments[name]
end

function equipment:getRandomEquipment(rarity)
    local rarity = rarity or false

    local key = self.keys[math.random(#self.keys)]

    if rarity then
        if self.equipments[key].rarity == rarity then 
            return self.equipments[key]
        else
            self:getRandomEquipment(rarity)
        end
    end

    return self.equipments[key]
end

return equipment