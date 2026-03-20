local animationplayer = {
  animations = {},
  groupedAmimations = {},
}

function animationplayer:update(dt)
  for i, animation in pairs(self.animations) do
    animation.timer = animation.timer + dt
    if animation.timer >= animation.timeBetweenFrames then
      animation.timer = 0
      animation.frame = animation.frame + 1
      if animation.frame > #animation.images and animation.looping then
        animation.frame = 1
      elseif animation.frame > #animation.images and not animation.looping then
        animation.frame = #animation.images
        self.animations[animation] = nil
      end
    end
  end

  for i, group in pairs(self.groupedAmimations) do
    for j, animation in pairs(group) do
      animation.timer = animation.timer + dt
      if animation.timer >= animation.timeBetweenFrames then
        animation.timer = 0
        animation.frame = animation.frame + 1
        if animation.frame > #animation.images and animation.looping then
          animation.frame = 1
        elseif animation.frame > #animation.images and not animation.looping then
          animation.frame = #animation.images
          table.remove(group, j)
        end
      end
    end
  end
end

function animationplayer:draw(name,images,timeBetweenFrames,x,y,looping,flipped,size)
  local looping = looping or false
  local flipped = flipped or false
  local size = size or 1
  local name = name or "default"


  if self.animations[name] then
    --get the animation
    local animation = self.animations[name]

    --Check to see if there is new data to update
      local oldX,oldY = animation.x, animation.y
      if oldX ~= x then
        animation.x = x
      end
      if oldY ~= y then
        animation.y = y
      end
      if images[1] ~= animation.images[1] then
        animation.images = images
        animation.frame = 1
      end
      if looping ~= animation.looping then
        animation.looping = looping
      end
      if flipped ~= animation.flipped then
        animation.flipped = flipped
      end
    
    --draw the animation
    if flipped then
      local oX, oY = animation.images[animation.frame]:getDimensions()
      love.graphics.draw(animation.images[animation.frame],animation.x,animation.y,0,-size,size,oX)
    else
      love.graphics.draw(animation.images[animation.frame],animation.x,animation.y,0,size,size)
    end
    return
  end

  if images == nil then
    return
  end

  self.animations[name] = {
    looping = looping,
    images = images,
    timeBetweenFrames = timeBetweenFrames,
    timer = 0,
    x = x,
    y = y,
    frame = 1,
  }  
end

function animationplayer:drawGroup(group,images,timeBetweenFrames,x,y,looping)
  local looping = looping or false
  local group = group or "default"
  
  if self.groupedAmimations[group] and images == nil then
    for i, animation in pairs(self.groupedAmimations[group]) do
      love.graphics.setColor(1,1,1,1)
      love.graphics.draw(animation.images[animation.frame],animation.x,animation.y)
    end
    return
  end

  if images == nil then
    return
  end

  local animation = {
    looping = looping,
    images = images,
    timeBetweenFrames = timeBetweenFrames,
    timer = 0,
    x = x,
    y = y,
    frame = 1,
  }

  if not self.groupedAmimations[group] then
    self.groupedAmimations[group] = {}
  end
  table.insert(self.groupedAmimations[group], animation)
end

return animationplayer