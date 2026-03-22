local splashscreen = {
    timer = 0,
    splashScreen = 5,
}

function splashscreen:load()
    
end

function splashscreen:update(dt)
    self.timer = self.timer + dt
    if self.timer >= self.splashScreen then
        Scene = "title"
    end
end 

function splashscreen:draw()

end

return splashscreen