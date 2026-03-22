local BackgroundHandler = {}
BackgroundHandler.__index = BackgroundHandler

function BackgroundHandler:new()
    local obj = setmetatable({},BackgroundHandler)

    return obj
end

function BackgroundHandler:update()

end

function BackgroundHandler:draw()

end


return BackgroundHandler