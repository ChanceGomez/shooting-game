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
        end,
        description = "start automatically reloading the chamber",
        image = al:getImage("upgrademaxammo_shop_icon"),
        width = al:getImage("upgrademaxammo_shop_icon"):getWidth(),
        height = al:getImage("upgrademaxammo_shop_icon"):getHeight(),
    }
    --get count of how many artifacts
    for i, upgrade in pairs(self.artifacts) do
        self.artifactsCount = self.artifactsCount + 1
    end
    --get keys`
    for key in pairs(self.artifacts) do
        self.keys[#self.keys+1] = key
    end
end


function artifacts:getRandomArtifact()
    local key = self.keys[math.random(#self.keys)]
    return self.artifacts[key]
end

return artifacts