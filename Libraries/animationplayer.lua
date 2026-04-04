local AnimationPlayer = {}
AnimationPlayer.__index = AnimationPlayer

function AnimationPlayer:new(images,animation,timeBetweenFrames,isLooped,flipped,scale)
    local obj = setmetatable({},AnimationPlayer)

    obj.isPaued = false
    obj.animation = animation
    obj.images = images
    obj.x = 0
    obj.y = 0
    obj.isFlipped = flipped or false
    obj.timeBetweenFrames = timeBetweenFrames or .5 
    obj.scale = scale or 1
    obj.isLooped = isLooped or false

    obj.timer = 0
    obj.frame = 1

    return obj
end

function AnimationPlayer:setTimeBetweenFrames(time)
    self.timeBetweenFrames = time
end

function AnimationPlayer:setIsLooped(isLooped)
    self.isLooped = isLooped
end

function AnimationPlayer:setImages(images)
    self.images = images
end

function AnimationPlayer:setScale(scale)
    self.scale = scale
end

function AnimationPlayer:setAnimation(animation)
    if self.images[animation] == nil then return end
    self.animation = animation
    self.frame = 1
end

function AnimationPlayer:play()
    self.isPaused = false
end

function AnimationPlayer:pause()
    self.isPaused = true
end

function AnimationPlayer:update(dt)
    self.timer = self.timer + dt
    if self.timer >= self.timeBetweenFrames then
      self.timer = 0
      self.frame = self.frame + 1
      if self.frame > #self.images[self.animation] and self.isLooped then
        self.frame = 1
      elseif self.frame > #self.images[self.animation] and not self.isLooped then
        self.frame = #self.images[self.animation]
      end
    end
end

function AnimationPlayer:draw(x,y)
    if self.images == nil then return end
    

    local frameImage = self.images[self.animation][self.frame]
    if frameImage == nil then error("Bad frame, bad animation",self.animation,self.frame) end
    local oX, oY = frameImage:getDimensions()
    
    if self.isFlipped then
        love.graphics.draw(frameImage,x,y,0,-self.scale,self.scale,oX)
    else
        love.graphics.draw(frameImage,x,y,0,self.scale,self.scale)
    end
end

return AnimationPlayer