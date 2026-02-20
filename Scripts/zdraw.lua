--[[
  Draws items in a z-order.
  
]]

local zdraw = {
  objects = {},
  drawObjects = {},
}

function zdraw:draw(object)
  --make sure object has a draw function
  if object.draw == nil then
    error("object in zdraw:draw() does not have a draw function")
  end
  
  --add object to table
  object.z = object.z or 0
  object.onTop = object.onTop or false
  object.cursorTop = object.cursorTop or false

  table.insert(self.objects,object)
end

function zdraw:update()
  local heldObject = nil
  
  
  for i, object in ipairs(self.objects) do
      if object.held then
          heldObject = object
      end
      object.onTop = false
      object.cursorTop = false
      object.visualTop = false
      --Cosmetic draw
      if collision.rect(object) then
        object.visualTop = true
        for _, compareObject in ipairs(self.objects) do
          if collision.rect(compareObject) and compareObject.z > object.z then
            object.visualTop = false
            break
          end
        end
      end
  end
  
  -- Sort the draw list based on Z (visual order)
  table.sort(self.objects, function(a, b)
      return a.z < b.z
  end)
  
  -- Run the N^2 collision check on the sorted list (using the new index i)
  for i, object in ipairs(self.objects) do
      local min_i = i
      local max_i = i

      for j, object2 in ipairs(self.objects) do -- Loop through the same list
          if i ~= j and collision.twoRect(object, object2) then
              min_i = math.min(min_i, j)
              max_i = math.max(max_i, j)
          end
          
          if collision.twoRect(object, object2) and collision.rect(object) and not collision.rect(object2) then
            object.cursorTop = true
            object2.cursorTop = false
          elseif collision.twoRect(object, object2) and collision.rect(object) and collision.rect(object2) and j > i then
            object2.cursorTop = true
          end
      end

      -- Final status check
      if i == max_i then
          object.onTop = true
      end
  end
  
  self.heldObject = heldObject
  
  self.drawObjects = self.objects
  self.objects = {}
end

function zdraw:drawAll()
  -- Draw objects based on the order determined in the updateStatus function
    for i, object in ipairs(self.drawObjects) do
        object:draw()
    end
    
    -- Draw the held object last
    if self.heldObject then
        self.heldObject:draw()
    end
end

return zdraw