local Lookout = {}
Lookout.__index = Lookout

function Lookout:new(enemies,difficulty)
  local obj = setmetatable({}, Lookout)
  
  local enemies = enemies or 5
  local difficulty = difficulty or 1

  obj.enemies = enemies
  obj.difficulty = difficulty
  obj.enemies = {}
  obj.canvas = love.graphics.newCanvas(Width,Height)
  obj.handler = EnemyHandler:new(enemies,difficulty)
  obj.handler:startRound()
  obj.x = 0
  obj.y = 0
  obj.roundTimer = 0
  obj.cloudsTimer = 0
  obj.Report = Report:new()
  obj.buttons = {}
  obj.isHoveringButton = false
  obj.reloadShelfOpen = true
  obj.reloadShelf = ReloadShelf:new(-128,obj.y + Height - 68)
    --load buttons
    table.insert(obj.buttons, {
        x = obj.x + 4,
        y = obj.y + Height - 68,
        image = al:getImage("button_ammoreload"),
        hoveredImage = al:getImage("button_ammoreload_hovered"),
        width = al:getImage("button_ammoreload"):getWidth(),
        height = al:getImage("button_ammoreload"):getHeight(),
        visible = true,
        clicked = function()
            obj.reloadShelfOpen = not obj.reloadShelfOpen
            if obj.reloadShelfOpen then
                obj:openReloadShelf()
            else
                obj:closeReloadShelf()
            end
        end
    })

    obj:openReloadShelf()

  return obj
end

function Lookout:openReloadShelf()
    --animate button
    tweenTo(self.buttons[1],.2,"linear",127,self.buttons[1].y)
    tweenTo(self.reloadShelf,.2,"linear",0,self.reloadShelf.y)
end

function Lookout:closeReloadShelf()
    --animate button
    tweenTo(self.buttons[1],.2,"linear",4,self.buttons[1].y)
    tweenTo(self.reloadShelf,.2,"linear",-128,self.reloadShelf.y)
end

function Lookout:removeEnemy(enemy)
    for i, instance in ipairs(self.enemies) do
        if instance == enemy then
            table.remove(self.enemies,i)
        end
    end
end

function Lookout:update(dt)
    --update timer
    self.roundTimer = self.roundTimer + dt

    self.isHoveringButton = false
    --update buttons
    button:updateAll(self.buttons)

    --check if cursor is hovering button
    for i, button in ipairs(self.buttons) do
        if collision.rect(button) then
            self.isHoveringButton = true
        else
            self.isHoveringButton = false
        end
    end
    if collision.rect(self.reloadShelf) then
        self.isHoveringButton = true
    end

    if not self.handler.isRoundActive then
        game:endRound()
    end

    --update reload shelf
    self.reloadShelf:update(dt)


    self.handler:update(dt)
    self.cloudsTimer = self.cloudsTimer + dt
end

function Lookout:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()

    --background color
        love.graphics.setBackgroundColor(0.2,0.2,math.min(math.max(self.roundTimer/120+.25,.25),.40))

    --clouds background
        local img = al:getImage("background_clouds_layer1")
        local speed = -(self.cloudsTimer * 1) % img:getWidth()
        local sway = math.sin(love.timer.getTime()/4 * 1) * 1

        love.graphics.setColor(.8,.8,.8,1)
        love.graphics.draw(img,speed,sway)
        love.graphics.draw(img,speed-img:getWidth(),sway)
        if math.abs(speed) > img:getWidth() then
            self.cloudsTimer = 0
        end
    --mountain background
        love.graphics.setColor(.5,.5,.5,1)
        love.graphics.draw(al:getImage("background_mountains_layer1"),0,0)
        love.graphics.setColor(.4,.4,.4,1)
        love.graphics.draw(al:getImage("background_mountains_layer2"),0,0)

    --draw enemies
        self.handler:draw()
    
    --vegetation background
        love.graphics.setColor(.9,.9,.9,1)
        love.graphics.draw(al:getImage("background_vegetation_layer3"),0,0)
        love.graphics.setColor(.8,.8,.8,1)
        love.graphics.draw(al:getImage("background_vegetation_layer2"),0,0)
        love.graphics.setColor(.6,.6,.6,1)
        love.graphics.draw(al:getImage("background_vegetation"),0,0)

    --draw buttons
    button:drawAll(self.buttons)

    --draw reloadshelf
    self.reloadShelf:draw()

    --draw crosshair
    game.Player:draw()

    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(perfect_dos_16)
    love.graphics.print("ammo " .. #game.Player.gun.ammo .. "/" .. game.Player.gun.maxAmmo,10,270)

    love.graphics.print("enemies " .. #game.lookouts[1].enemies, 10,250)

    love.graphics.setColor(.9,.9,.9,1)
    love.graphics.draw(al:getImage("background_hud_layer1"),0,0)


    love.graphics.setCanvas(game.canvas)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.canvas,self.x,self.y)
end


return Lookout