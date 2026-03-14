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
        type = "barrel",
        clicked = function(self)
            game.Observer:add("damageDealtBefore",{
                event = function(self,damage)
                    print(damage)
                end,
            })
        end,
        description = {
            text = "Increase Fire Rate by 25%",
        },
        image = al:getImage(""),
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


function equipment:getRandomEquipment()
    local key = self.keys[math.random(#self.keys)]
    if self.equipments[key].used then
        return self:getRandomEquipment()
    end
    return self.equipments[key]
end

return equipment