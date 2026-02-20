local Lookout = {}
Lookout.__index = Lookout

function Lookout:new()
  local obj = setmetatable({}, Lookout)
  
  obj.enemies = {}
  obj.canvas = love.graphics.newCanvas(Width,Height)
  obj.handler = EnemyHandler:new(obj)
  obj.handler:startRound(5)
  obj.x = 0
  obj.y = 0
  obj.cloudsTimer = 0
  obj.buttons = {}
  obj.isHoveringButton = false
  obj.reloadShelfOpen = false
  obj.reloadShelf = {
    x = -128,
    y = obj.y + Height - 132,
    images = {
        background = al:getImage("reloadshelf_background"),
    },
  }

    --load buttons
    table.insert(obj.buttons, {
        x = obj.x + 4,
        y = obj.y + Height - 100,
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

  return obj
end

function Lookout:openReloadShelf()
    --animate button
    tweenTo(self.buttons[1],.2,"linear",128,self.buttons[1].y)
    tweenTo(self.reloadShelf,.2,"linear",0,self.reloadShelf.y)
end

function Lookout:closeReloadShelf()
    --animate button
    tweenTo(self.buttons[1],.2,"linear",4,self.buttons[1].y)
    tweenTo(self.reloadShelf,.2,"linear",-128,self.reloadShelf.y)
end

function Lookout:update(dt)
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

    self.handler:update(dt)
    self.cloudsTimer = self.cloudsTimer + dt
end

function Lookout:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()

    --background color
        love.graphics.setBackgroundColor(0.2,0.2,0.25)

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
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.reloadShelf.images.background,self.reloadShelf.x,self.reloadShelf.y)

    --draw crosshair
    game.Player:draw()



    love.graphics.setColor(.9,.9,.9,1)
    love.graphics.draw(al:getImage("background_hud_layer1"),0,0)


    love.graphics.setCanvas(game.canvas)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.canvas,self.x,self.y)
end


return Lookout