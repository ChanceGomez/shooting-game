--collision.lua | library
--[[
  This library is for collisions, drag & drop behaviors. 
  for rectangular collision:
    collision.rect(x,y,obj) | obj being the object with an x,y,width,height | x,y being any camera transfomrations
  
  for circular collisions: 
    collision.cricle(x,y,obj) | obj being the object with an x,y,radius | x,y being any camera transfomrations
    
]]



local collision = {
  holding = false,
  holdingObj = nil,
  heldItem = nil

}

function collision.twoCircle(c1, c2)
    local dx = c1.x - c2.x
    local dy = c1.y - c2.y
    local distanceSq = dx * dx + dy * dy
    local radiusSum = c1.radius + c2.radius

    return distanceSq < radiusSum * radiusSum
end

function collision.circleRect(circle, rect)
    local cx, cy, r = circle.x, circle.y, circle.radius
    local rx, ry, rw, rh = rect.x, rect.y, rect.width, rect.height

    -- find closest point on the rectangle to the circle center
    local closestX = math.max(rx, math.min(cx, rx + rw))
    local closestY = math.max(ry, math.min(cy, ry + rh))

    -- distance from circle center to closest point
    local dx = cx - closestX
    local dy = cy - closestY

    return (dx * dx + dy * dy) <= (r * r)
end



function collision.twoRect(obj1,obj2)
  local x1 = obj1.x
  local y1 = obj1.y
  local w1 = obj1.width or obj1.image:getWidth()
  local h1 = obj1.height or obj1.image:getHeight()
  
  local x2 = obj2.x
  local y2 = obj2.y
  local w2 = obj2.width or obj2.image:getWidth()
  local h2 = obj2.height or obj2.image:getHeight()
  
  return x1 < x2 + w2 and
         x1 + w1 > x2 and
         y1 < y2 + h2 and
         y1 + h1 > y2
end

function collision.rect(obj,x,y,cameraX,cameraY)
    local cameraX = cameraX or 0
    local cameraY = cameraY or 0

    local x1 = x or CursorX
    local y1 = y or CursorY
  
    x1 = x1 + cameraX
    y1 = y1 + cameraY

  local x2 = obj.x
  local y2 = obj.y
  
  local width = obj.width 
  local height = obj.height

  if width == nil then
    width = obj.image:getWidth()
  end

  if height == nil then
    height = obj.image:getHeight()
  end
  
  return x1 >= x2 and x1 <= x2 + width
    and y1 >= y2 and y1 <= y2 + height
end

function collision.circleColor(circle,img)
    local radius = circle.radius 
    local imageData = img.imageData
    local iX = img.x or 0
    local iY = img.y or 0
    local cX = circle.x
    local cY = circle.y
    -- Sample points inside the circle
    local step = 2 -- pixel step, lower = more accurate but slower

    for dy = -radius, radius, step do
        for dx = -radius, radius, step do
            -- Check if sample point is inside the circle
            if dx*dx + dy*dy <= radius*radius then
                -- Convert world position to image local position
                local px = math.floor((cX + dx) - iX)
                local py = math.floor((cY + dy) - iY)

                if collision.color(img,px,py) then
                    return true
                end
            end
        end
    end

    return false
end

function collision.circle(obj,x,y)
  local x = x or 0
  local y = y or 0
  
  local x1 = CursorX + x
  local y1 = CursorY + y
  
  local x2 = obj.x
  local y2 = obj.y
  local radius = obj.radius
  
  
  local dx = x1 - x2
  local dy = y1 - y2
  local distance = math.sqrt(dx*dx+dy*dy)
  
  
  return distance <= radius
end

function collision.color(obj,x,y)
    if false then --not collision.rect(obj,x,y) then
        return false
    end
    if obj.imageData == nil then
        return
    end
    local image = obj.imageData
    local x = x or math.floor(CursorX - obj.x)
    local y = y or math.floor(CursorY - obj.y)
    
    local r,g,b,a = image:getPixel(x,y)    
    if color then
        return color[1] == r and color[2] == g and color[3] == b and color[4] == a
    else
        return a ~= 0
    end
end

function collision.circleRect(circle,rect)
    local rX,rY = rect.x,rect.y
    local cX,cY = circle.x,circle.y

    if rX == nil or rY == nil or cX == nil or cY == nil then
        return
    end
-- Find the closest point on the rect to the circle's center
    local closestX = math.max(rect.x, math.min(circle.x, rect.x + rect.width))
    local closestY = math.max(rect.y, math.min(circle.y, rect.y + rect.height))

    -- Distance from circle center to that closest point
    local dx = circle.x - closestX
    local dy = circle.y - closestY
    local distSq = dx * dx + dy * dy

    if distSq >= circle.radius * circle.radius then
        return false
    end

    -- Optionally compute separation data for physics response
    local dist = math.sqrt(distSq)
    local nx, ny, depth

    if dist == 0 then
        -- Circle center is inside the rect — push out on shortest axis
        local overlapL = circle.x - rect.x
        local overlapR = (rect.x + rect.width) - circle.x
        local overlapT = circle.y - rect.y
        local overlapB = (rect.y + rect.height) - circle.y
        local minOverlap = math.min(overlapL, overlapR, overlapT, overlapB)

        if minOverlap == overlapL then
            nx, ny = -1, 0
        elseif minOverlap == overlapR then
            nx, ny =  1, 0
        elseif minOverlap == overlapT then
            nx, ny = 0, -1
        else
            nx, ny = 0,  1
        end
        depth = circle.radius + minOverlap
    else
        nx   = dx / dist
        ny   = dy / dist
        depth = circle.radius - dist
    end

    return true, nx, ny, depth
end

function collision:rectCicle(rect,circle)
    return collision:circleRect(circle,rect)
end

return collision