local dropbutton = {}


function dropbutton:drop(button)
  
end

function dropbutton:held(button)
  local colliding = false
  if collision.rect(button) then
    colliding = true
  end
  if not colliding then
    return
  end
  if drag.holding and colliding then
    button.event()
  end
end

function dropbutton:draw(button)
  love.graphics.setColor(1,1,1,1)
  love.graphics.draw(button.image,button.x,button.y)
end

return dropbutton