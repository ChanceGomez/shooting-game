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
        clicked = function()
            shop:artifactClicked()
            game.Observer:add("update",{
                event = function()
                    game.lookouts[1].ReloadShelf.autoReload = true
                    game.Player.reloadRate = game.Player.gun.reloadRate * 1.25
                end,
            })
        end,
        description = {
            text = "start " .. getFormat("positive") .. "automatically reloading the chamber, " .. getFormat("negative") .. "-25% reload speed",
        },
        image = al:getImage("upgrademaxammo_shop_icon"),
    }
    print(self.artifacts.autoReload.description.text)
    self.artifacts.improvedAmmunition = {
        clicked = function()
            shop:artifactClicked()
            --Improve the damage of the bullets
            game.Player.gun.damage = game.Player.gun.damage * 1.50
            --Reduce amount of duds
            game.lookouts[1].ReloadShelf.dudPercentage = game.lookouts[1].ReloadShelf.dudPercentage * .75
        end,
        description = {
            text = "Increase damage from bullet by " .. getFormat("positive") .. "50% aswell as " .. getFormat("positive") .. "-25% duds",
        },
        image = al:getImage("upgrademaxammo_shop_icon"),
    }
    self.artifacts.railGun = {
        clicked = function()
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
    --get count of how many artifacts and get there widths/heights aswell as add the fonts for description
    for i, artifact in pairs(self.artifacts) do
        self.artifactsCount = self.artifactsCount + 1
        artifact.width = artifact.image:getWidth()
        artifact.height = artifact.image:getHeight()
        artifact.description.font = perfect_dos_16
    end
    --get keys
    for key in pairs(self.artifacts) do
        self.keys[#self.keys+1] = key
    end
end


function artifacts:getRandomArtifact()
    local key = self.keys[math.random(#self.keys)]
    print(key,self.artifacts[key])
    return self.artifacts[key]
end

return artifacts