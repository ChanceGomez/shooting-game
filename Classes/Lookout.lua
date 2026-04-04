local Lookout = {}
Lookout.__index = Lookout

local crt_shader = love.graphics.newShader("Assets/Shaders/crt.glsl")
crt_shader:send("screen_size", {love.graphics.getDimensions()})

function Lookout.new(enemies,difficulty,artifacts,images)
    local obj = setmetatable({}, Lookout)

    obj.images = images
    obj.artifacts = artifacts
    obj.difficulty = difficulty
    obj.enemyCount = #enemies
    obj.enemies = {}
    obj.canvas = love.graphics.newCanvas(Width,Height)
    obj.handler = EnemyHandler.new(obj,enemies,difficulty)
    obj.handler:startRound()
    obj.x = 0
    obj.y = 0
    obj.roundTimer = 0
    obj.cloudsTimer = 0
    obj.Report = Report.new()
    obj.buttons = {}
    obj.isHoveringButton = false
    obj.reloadShelfOpen = true
    obj.ReloadShelf = ReloadShelf.new(-128,obj.y + Height - 64)
    obj.BackgroundHandler = BackgroundHandler.new()
    obj.outlineMargin = 0

    obj:openReloadShelf()

    return obj
end

function Lookout:openReloadShelf()
    --animate button
    tweenTo(self.ReloadShelf,.2,"linear",-1,self.ReloadShelf.y)
end

function Lookout:closeReloadShelf()
    --animate button
    tweenTo(self.ReloadShelf,.2,"linear",-128,self.ReloadShelf.y)
end

function Lookout:removeEnemy(enemy)
    for i, instance in ipairs(self.enemies) do
        if instance == enemy then
            table.remove(self.enemies,i)
        end
    end
end

function Lookout:update(dt)
    game.Observer:trigger("lookoutUpdate",{dt = dt})
    --update timer
    self.roundTimer = self.roundTimer + dt

    self.isHoveringButton = false

    --check if cursor is hovering button
    for i, button in ipairs(self.buttons) do
        if collision.rect(button) then
            self.isHoveringButton = true
        else
            self.isHoveringButton = false
        end
    end
    if collision.rect(self.ReloadShelf) then
        self.isHoveringButton = true
    end

    if not self.handler.isRoundActive then
        game:endRound(self.artifacts)
    end

    --update reload shelf
    self.ReloadShelf:update(dt)


    self.handler:update(dt)
    self.cloudsTimer = self.cloudsTimer + dt
end

function Lookout:draw()

    love.graphics.setColor(1,1,1,1)
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()


    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.images.background)

    --clouds 

    --[[
    local img = self.images.clouds
    local speed = -(self.cloudsTimer * 1) % img:getWidth()
    local sway = math.sin(love.timer.getTime()/4 * 1) * 1

    love.graphics.setColor(.8,.8,.8,1)
    love.graphics.draw(img,speed,sway)
    love.graphics.draw(img,speed-img:getWidth(),sway)
    if math.abs(speed) > img:getWidth() then
        self.cloudsTimer = 0
    end

    ]]
    self.handler:draw()


    --draw reloadshelf
    self.ReloadShelf:draw()

    --draw crosshair
    game.Player:draw()

    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(perfect_dos_16)
    
    

    love.graphics.setColor(1,1,1,1)
    love.graphics.print("enemies: " .. self.enemyCount, 400,20)
    --love.graphics.print("reloadrate: " .. math.floor(game.Affector:trigger("Reload Rate",game.Player.gun.reloadRate)*100)/100, 10,210) 




    love.graphics.setCanvas(game.canvas)
    love.graphics.setColor(1,1,1,1)
    if settings.crt then
        love.graphics.setShader(crt_shader)
    end
    love.graphics.draw(self.canvas,self.x,self.y)
    love.graphics.setShader()

    love.graphics.setColor(.9,.9,.9,1)
    love.graphics.draw(assetloader:getImage("background_hud_layer1"),0,0)

    love.graphics.setColor(1,1,1,1)
    local font = dogica_8
    local text = "Health:"
    love.graphics.setFont(font)
    love.graphics.print(text,(Width/2)-(font:getWidth(text)/2),15)

    local width,height,margin = 4,16,2
    local totalWidth = (width+margin) * game.Player.health
    for i = 1, game.Player.health do
        love.graphics.setColor(1,1,1,1)
        love.graphics.rectangle("fill",Width/2+(i*(width+margin))-totalWidth,25,width,height)
    end
    
end


return Lookout