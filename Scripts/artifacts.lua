local artifacts = {
    artifacts = {},
    keys = {},
    artifactsCount = 0,
}

function artifacts:load()
    --load artifacts
    
    --get count of how many artifacts
    for i, upgrade in pairs(self.artifacts) do
        self.artifactsCount = self.artifactsCount + 1
    end
    --get keys`
    for key in pairs(self.artifacts) do
        self.keys[#self.keys+1] = key
    end
end


function artifacts:getRandomUpgrade()
    local key = self.keys[math.random(#self.keys)]
    return self.artifacts[key]
end

return artifacts