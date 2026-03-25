local info = {
    artifacts = {},
}

function info:load()

end

function info:update(dt)
    
end

function info:draw()
    --draw the artifacts
    local x,y = 10,10
    for i, artifact in ipairs(game.Player.artifacts) do
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(artifact.image,x+(i*artifact.width),y)
    end
end

return info