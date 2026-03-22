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
        ids = {},
        add = function(self)
            self.ids["fireRateCheck"] = game.Affector:add("fireRateCheck",
                function(fireRate)
                    return fireRate * .75
                end
            )
        end,
        remove = function(self)
            self.ids["fireRateCheck"] = game.Affector:remove("fireRateCheck",self.affectorID)
        end,
        description = {
            text = "{.2,.2,.5}Titanium {.2,.2,.5}Barrel: " .. "Increase Fire Rate by 25%",
        },
        image = al:getImage("equipment_barrelimprovement"),
    }
    self.equipments.titaniumStabalizer = {
        rarity = 1,
        type = "stabalizer",
        ids = {},
        add = function(self)
            self.ids["dudCheck"] = game.Affector:add("dudCheck",
                function(dud)
                    return dud * .75
                end
            )
        end,
        remove = function(self)
            self.ids["dudCheck"] = game.Affector:remove("dudCheck",self.affectorID)
        end,
        description = {
            text = "{.2,.2,.5}Titanium {.2,.2,.5}Stabilizer: " .. "Decrease dud chance by 25%",
        },
        image = al:getImage("equipment_barrelimprovement"),
    }
    self.equipments.titaniumReloader = {
        rarity = 1,
        type = "reloader",
        ids = {},
        add = function(self)
            self.ids["reloadRateCheck"] = game.Affector:add("reloadRateCheck",
                function(reload)
                    return reload * .75
                end
            )
        end,
        remove = function(self)
            self.ids["reloadRateCheck"] = game.Affector:remove("reloadRateCheck",self.ids["reloadRateCheck"])
        end,
        description = {
            text = "{.2,.2,.5}Titanium {.2,.2,.5}Reloader: " .. "Increase reload rate by 25%",
        },
        image = al:getImage("equipment_barrelimprovement"),
    }
    self.equipments.titaniumAntenna = {
        rarity = 1,
        type = "antenna",
        ids = {},
        add = function(self)
            self.ids["parachuteCheck"] = game.Affector:add("parachuteCheck",
                function(parachute)
                    return parachute * .75
                end
            )
        end,
        remove = function(self)
            self.ids["parachuteCheck"] = game.Affector:remove("parachuteCheck",self.affectorID)
        end,
        description = {
            text = "{.2,.2,.5}Titanium {.2,.2,.5}Antenna: " .. "Increase parachutes by 25%",
        },
        image = al:getImage("equipment_barrelimprovement"),
    }
    self.equipments.titaniumBase = {
        rarity = 1,
        type = "base",
        ids = {},
        add = function(self)
            self.ids["reloadRateCheck"] = game.Affector:add("reloadRateCheck",
                function(reload)
                    return reload * .90
                end
            )
            self.ids["fireRateCheck"] = game.Affector:add("fireRateCheck",
                function(fireRate)
                    return fireRate * .90
                end
            )
        end,
        remove = function(self)
            self.ids["reloadRateCheck"] = game.Affector:remove("reloadRateCheck",self.ids["reloadRateCheck"])
            self.ids["fireRateCheck"] = game.Affector:remove("fireRateCheck",self.ids["fireRateCheck"])

        end,
        description = {
            text = "{.2,.2,.5}Titanium {.2,.2,.5}Base: " .. "Increase reload rate by 10%, fire rate by 10%",
        },
        image = al:getImage("equipment_barrelimprovement"),
    }
    self.equipments.jankyBase = {
        rarity = 1,
        type = "base",
        ids = {},
        add = function(self)
            self.ids["dudCheck"] = game.Affector:add("dudCheck",
                function(dud)
                    return dud * 1.50
                end
            )
            self.ids["dudDamage"] = game.Affector:add("dudDamage",
                function(damage)
                    return damage * 1.50
                end
            )
        end,
        remove = function(self)
            self.ids["dudCheck"] = game.Affector:remove("dudCheck",self.ids["dudCheck"])
            self.ids["dudDamage"] = game.Affector:remove("dudDamage",self.ids["dudDamage"])

        end,
        description = {
            text = "{.2,.2,.5}Janky {.2,.2,.5}Base: " .. "Increase dud chance by 50%, increase dud damage by 50%",
        },
        image = al:getImage("equipment_barrelimprovement"),
    }


    --get count of how many artifacts and get there widths/heights aswell as add the fonts for description
    for i, equipment in pairs(self.equipments) do
        self.equipmentCount = self.equipmentCount + 1
        equipment.width = equipment.image:getWidth()
        equipment.height = equipment.image:getHeight()
        if not equipment.description.font then
            equipment.description.font = perfect_dos_16
        end
    end
    --get keys
    for key in pairs(self.equipments) do
        self.keys[#self.keys+1] = key
    end
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