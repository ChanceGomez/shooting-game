local equipment = {
    equipments = {},
    keys = {},
    equipmentCount = 0,
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

function equipment:load()
    
    self.equipments.titaniumBarrel = {
        rarity = 1,
        name = camelToReadable("titaniumBarrel"),
        type = "barrel",
        ids = {
            {"Fire Rate","mult",.25},
        },
        description = {
            text = customtext:formatString("Titanium Barrel:", {.2,.2,.5,1}) ..
                " /n" .. getFormat(1) .. "Increases fire rate",
        },
        image = assetloader:getImage("equipment_barrelimprovement"),
    }

    self.equipments.titaniumStabalizer = {
        rarity = 1,
        name = camelToReadable("titaniumStabalizer"),
        type = "stabalizer",
        ids = {
            {"Dud Chance","mult",-.25},
        },
        description = {
            text = customtext:formatString("Titanium Stabilizer:", {.2,.2,.5,1}) ..
                " /n" .. getFormat(1) .. "Decreases dud chance",
        },
        image = assetloader:getImage("equipment_barrelimprovement"),
    }

    self.equipments.titaniumReloader = {
        rarity = 1,
        name = camelToReadable("titaniumReloader"),
        type = "reloader",
        ids = {
            {"Reload Rate","mult",.25},
        },
        description = {
            text = customtext:formatString("Titanium Reloader:", {.2,.2,.5,1}) ..
                " /n" .. getFormat(1) .. "Increases reload rate",
        },
        image = assetloader:getImage("equipment_barrelimprovement"),
    }

    self.equipments.titaniumAntenna = {
        rarity = 1,
        name = camelToReadable("titaniumAntenna"),
        type = "antenna",
        ids = {
            {"Parachute Chance","mult",.25},
        },
        description = {
            text = customtext:formatString("Titanium Antenna:", {.2,.2,.5,1}) ..
                " /n" .. getFormat(1) .. "Increases parachute chance",
        },
        image = assetloader:getImage("equipment_barrelimprovement"),
    }

    self.equipments.titaniumBase = {
        rarity = 1,
        name = camelToReadable("titaniumBase"),
        type = "base",
        ids = {
            {"Reload Rate","mult",.10},
            {"Fire Rate","mult",.10},
        },
        description = {
            text = customtext:formatString("Titanium Base:", {.2,.2,.5,1}) ..
                " /n" .. getFormat(1) .. "Increases reload rate and fire rate",
        },
        image = assetloader:getImage("equipment_barrelimprovement"),
    }

    self.equipments.jankyBase = {
        rarity = 1,
        name = camelToReadable("jankyBase"),
        type = "base",
        ids = {
            {"Dud Chance","mult",.50},
            {"Dud Damage","mult",.50},
        },
        description = {
            text = customtext:formatString("Janky Base:", {.2,.2,.5,1}) ..
                " /n" .. getFormat(-1) .. "Increases dud chance " .. getFormat(1) .. "and increases dud damage",
        },
        image = assetloader:getImage("equipment_barrelimprovement"),
    }

    self.equipments.greasedBarrel = {
        rarity = 1,
        name = camelToReadable("greasedBarrel"),
        type = "barrel",
        ids = {
            {"Fire Rate","mult",.15},
            {"Reload Rate","mult",.15},
        },
        description = {
            text = customtext:formatString("Greased Barrel:", {.2,.2,.5,1}) ..
                " /n" .. getFormat(1) .. "Increases fire rate and reload rate",
        },
        image = assetloader:getImage("equipment_barrelimprovement"),
    }

    self.equipments.igniterStabilizer = {
        rarity = 2,
        name = camelToReadable("igniterStabilizer"),
        type = "stabalizer",
        ids = {
            {"Dud Fire Damage","add",5},
            {"Bullet Fire Damage","add",5},
            {"Bullet Fire Duration","add",1},
            {"Dud Fire Duration","add",1},
        },
        description = {
            text = customtext:formatString("Igniter Stabilizer:", {.2,.2,.5,1}) ..
                " /n" .. getFormat(1) .. "Increases fire damage and burn duration for bullets and duds",
        },
    }

    self.equipments.railgunBase = {
        rarity = 2,
        name = camelToReadable("railgunBase"),
        type = "base",
        ids = {
            {"Bullet Damage","add",10},
            {"Dud Damage","add",10},
            {"Reload Rate","mult",-.50},
        },
        description = {
            text = customtext:formatString("Railgun Base:", {.2,.2,.5,1}) ..
                " /n" .. getFormat(1) .. "Increases bullet and dud damage " .. getFormat(-1) .. "but decreases reload rate",
        },
    }

    self.equipments.higheffieciencyReloader = {
        rarity = 2,
        name = camelToReadable("higheffieciencyReloader"),
        type = "reloader",
        ids = {
            {"Reload Rate","mult",.66},
            {"Fire Rate","mult",.25},
            {"Bullet Damage","mult",-.30},
            {"Dud Damage","mult",-.30},
            {"Fire Damage","mult",-.5},
        },
        description = {
            text = customtext:formatString("High Efficiency Reloader:", {.2,.2,.5,1}) ..
                " /n" .. getFormat(1) .. "Greatly increases reload and fire rate " .. getFormat(-1) .. "but reduces all damage",
        },
    }


    --loop through to init variables/functions
    for i, equipment in pairs(self.equipments) do
        --count up for total equipment
        self.equipmentCount = self.equipmentCount + 1

        if equipment.image == nil then
            equipment.image = assetloader:getImage("equipment_barrelimprovement")
        end

        equipment.name = camelToReadable(i)

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