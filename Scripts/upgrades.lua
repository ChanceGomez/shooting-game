local upgrades = {
    upgrades = {},
    keys = {},
    upgradesCount = 0,
}

function upgrades:load()
    --load upgrades
    self.upgrades.upgradeMaxAmmo = {
        clicked = function()
            game.Player.gun:increaseMaxAmmo(1)
        end,
        image = assetloader:getImage("upgrademaxammo_shop_icon"),
        description = "Increase max ammo by 1",
        width = assetloader:getImage("upgrademaxammo_shop_icon"):getWidth(),
        height = assetloader:getImage("upgrademaxammo_shop_icon"):getHeight(),
    }
    self.upgrades.upgradeDamage = {
        clicked = function()
            game.Player.gun:increaseDamage(10)
        end,
        image = assetloader:getImage("upgradedamage_shop_icon"),
        description = "Increase damage by 10",
        width = assetloader:getImage("upgradedamage_shop_icon"):getWidth(),
        height = assetloader:getImage("upgradedamage_shop_icon"):getHeight(),
    }
    --get count of how many upgrades
    for i, upgrade in pairs(self.upgrades) do
        self.upgradesCount = self.upgradesCount + 1
    end
    --get keys`
    for key in pairs(self.upgrades) do
        self.keys[#self.keys+1] = key
    end
end


function upgrades:getRandomUpgrade()
    local key = self.keys[math.random(#self.keys)]
    return self.upgrades[key]
end

return upgrades