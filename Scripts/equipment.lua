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
        image = al:getImage("equipment_barrelimprovement"),
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
        image = al:getImage("equipment_barrelimprovement"),
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
        image = al:getImage("equipment_barrelimprovement"),
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
        image = al:getImage("equipment_barrelimprovement"),
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
        image = al:getImage("equipment_barrelimprovement"),
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
        image = al:getImage("equipment_barrelimprovement"),
    }


    --loop through to init variables/functions
    for i, equipment in pairs(self.equipments) do
        --count up for total equipment
        self.equipmentCount = self.equipmentCount + 1
        --get height/width
        equipment.width = equipment.image:getWidth()
        equipment.height = equipment.image:getHeight()

        --set default font
        if not equipment.description.font then
            equipment.description.font = dogica_8
        end

        --create the add/remove functions
        equipment.add = function(self)
            game.Affector:addIDs(self.ids)
        end
        equipment.remove = function(self)
            game.Affector:removeIDs(self.ids)
        end

        --Create the update text function
        equipment.updateText = function(self)
            local ids = self.ids
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
        if self.equipments[key].rarity == 1 then 
            return self.equipments[key]
        else
            self:getRandomEquipment(rarity)
        end
    end

    return self.equipments[key]
end

return equipment