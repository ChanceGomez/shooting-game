local artifacts = {
    artifacts = {},
    keys = {},
    artifactsCount = 0,
}

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
            text = "start {0,1,0,1}automatically reloading the chamber, {1,0,0,1}-25% reload speed",
        },
        image = al:getImage("upgrademaxammo_shop_icon"),
    }
    self.artifacts.improvedAmmunition = {
        clicked = function()
            shop:artifactClicked()
            --Improve the damage of the bullets
            game.Player.gun.damage = game.Player.gun.damage * 1.50
            --Reduce amount of duds
            game.lookouts[1].ReloadShelf.dudPercentage = game.lookouts[1].ReloadShelf.dudPercentage * .75
        end,
        description = {
            text = "Increase damage from bullet by {0,1,0,1}50% aswell as {0,1,0,1}-25% duds",
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
            text = "Increase damage by {0,1,0,1}500% but fire rate is increased by {1,0,0,1}300%",
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