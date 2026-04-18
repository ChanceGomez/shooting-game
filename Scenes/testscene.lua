 local testscene = {}

 function testscene:load()
    self.Affector = Affector.new()
    self.transparency = 0
    self.collider = {
        x = 100,
        y = 100,
        imageData = assetloader:getImageData("animation_bird_dying1"),
        image = assetloader:getImage("animation_bird_dying1")
    }

    local image = assetloader:getImageData("nest_arm1")
    self.poly = assetloader:getPolygon("nest_body")
 end

function testscene:update(dt)
    if collision.polygon(addToAll(self.poly,100,100)) then
  
    end
    if wheelUp then
        self.transparency = self.transparency + .1
    elseif wheelDown then
        self.transparency = self.transparency - .1
    end
end

 function testscene:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.polygon("line",flatten(addToAll(self.poly,100,100)))


    love.graphics.polygon("line",flatten(assetloader:getPolygon("nest_arm1")))
    love.graphics.polygon("line",flatten(assetloader:getPolygon("nest_arm2")))
    love.graphics.polygon("line",flatten(assetloader:getPolygon("nest_arm3")))
    love.graphics.polygon("line",flatten(assetloader:getPolygon("nest_arm4")))
    love.graphics.polygon("line",flatten(assetloader:getPolygon("nest_body")))

    love.graphics.setColor(1,1,1,self.transparency)
    love.graphics.draw(assetloader:getImage("nest_body"),100,100)
    


    love.graphics.draw(assetloader:getImage("cursor"),CursorX,CursorY)
 end

 return testscene