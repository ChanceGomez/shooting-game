local polygon = {}

local function traceContour(imageData,alphaThreshold)
    if imageData == nil then error("Invalid image data",imageData) end
    local points = {}

    --Get the threshold that determines if a certain alpha is solid or not
    local alphaThreshold = alphaThreshold or 0
    --Get dimensions
    local imageDataWidth = imageData:getWidth()
    local imageDataHeight = imageData:getHeight()

    --Function to check if point is solid or not
    local function isSolid(x,y)
        --Guard rails
        if x < 0 or y < 0 or x >= imageDataWidth or y >= imageDataHeight then return false end
        --Get the alpha of the pixel
        local r,g,b,a = imageData:getPixel(x,y) 
        --return if alpha exists
        return a > alphaThreshold
    end

    --Starting variables 
    local startX,startY
    --Cycle through to get the start x,y
    for x = 0, imageDataWidth - 1 do
        for y = 0, imageDataHeight - 1 do
            --Check to see if the pixel is a solid and make sure the one to the left is not.
            if isSolid(x,y) and not isSolid(x-1,y) then
                startX,startY = x,y
                break
            end
        end
        --Break through loops if start is found
        if startX then break end
    end

    --If there was no startX then return empty table
    if startX == nil then return {} end

    --Directional charter tables 
    local directionsX = {1, 0, -1, 0}
    local directionsY = {0, 1, 0, -1}

    --new coordinates
    local x,y = startX,startY
    local countour = {}
    local direction = 1
    local maxSteps = imageDataWidth * imageDataHeight * 4

    --loop through the images pixels
    for _ = 1, maxSteps do
        --insert the coordinates (starts with the starting x,y)
        table.insert(countour,{x,y})

        --Start looking in different directions
        local turned = false
        for attempt = 0, 3 do
            local newDirection = ((direction - 2 + attempt)%4) + 1
            local newX = x + directionsX[newDirection]
            local newY = y + directionsY[newDirection]

            if isSolid(newX,newY) then
                direction = newDirection
                x,y = newX,newY
                turned = true
                break
            end
        end
        if not turned then break end

        --Check to see if we are back at the start now
        if x == startX and y == startY then break end
    end

    return countour
end

-- Douglas-Peucker simplification (run after tracing)
local function perpendicularDist(point, lineStart, lineEnd)
    local dx = lineEnd[1] - lineStart[1]
    local dy = lineEnd[2] - lineStart[2]
    local len = math.sqrt(dx*dx + dy*dy)
    if len == 0 then
        return math.sqrt((point[1]-lineStart[1])^2 + (point[2]-lineStart[2])^2)
    end
    return math.abs(dx*(lineStart[2]-point[2]) - (lineStart[1]-point[1])*dy) / len
end

local function simplify(points, epsilon)
    if #points <= 2 then return points end

    local maxDist, maxIdx = 0, 1
    for i = 2, #points - 1 do
        local d = perpendicularDist(points[i], points[1], points[#points])
        if d > maxDist then
            maxDist = d
            maxIdx = i
        end
    end

    if maxDist > epsilon then
        local left  = simplify({unpack(points, 1, maxIdx)}, epsilon)
        local right = simplify({unpack(points, maxIdx)}, epsilon)
        -- Merge (avoid duplicating the split point)
        for i = 2, #right do table.insert(left, right[i]) end
        return left
    else
        return {points[1], points[#points]}
    end
end

function polygon.imageToPolygon(imageData, epsilon)
    epsilon = epsilon or 1  -- higher = fewer points, less accurate
    local imageData = imageData
    local raw = traceContour(imageData)
    return simplify(raw, epsilon)
end


return polygon