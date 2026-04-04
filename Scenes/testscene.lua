 local testscene = {}

 function testscene:load()
    self.Affector = Affector.new()
    
    self.collider = {
        x = 100,
        y = 100,
        imageData = assetloader:getImageData("animation_bird_dying1"),
        image = assetloader:getImage("animation_bird_dying1")
    }

 end

 function testscene:update(dt)
    if collision.color(self.collider) then
    end
 end

 function testscene:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.collider.image,self.collider.x,self.collider.y)
 end

 return testscene