local drag = {
  grabbed = nil,
  holding = false,
  }


function drag:dragged(obj, objects)
  self.grabbed = obj
  self.holding = true
  


  obj.held = true
end

function drag:update(objects,camera)
  for i = #objects, 1, -1 do
    local obj = objects[i]
    local camera = camera or {x=0,y=0}
    local isDraggable = obj.isDraggable or true
    
    local offsetX,offsetY = 0,0

    
    if isDraggable then
      if not self.holding then
        local hover = false
        if obj.radius then
          hover = collision.circle(obj,camera.x,camera.y)
        else
          hover = collision.rect(obj,camera.x,camera.y)

        end
        --Update obj hover condition
        obj.hovered = hover
        
        
        if love.mouse.isDown(1) and hover then
          self:dragged(obj,objects)
        end
        
        if love.mouse.isDown(2) and hover then
          obj.rightHeld = true
        end
        
      end
      --make sure mouse is not down
      if not love.mouse.isDown(1) then
        self.holding = false
        obj.held = false
        --check to see if obj has a dropped function
        if type(obj.dropped) == 'function' then
          obj:dropped()
        end
      end
      if not love.mouse.isDown(2) then
        obj.rightHeld = false
      end
      
      --check to see if object is being grabbed
      if self.grabbed == obj and self.holding then
        if not obj.radius then
          offsetX,offsetY = obj.width/2,obj.height/2
        end
        obj.x = CursorX + camera.x - offsetX
        obj.y = CursorY + camera.y - offsetY
      end
    end
  end
end





return drag