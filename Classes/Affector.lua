local Affector = {}
Affector.__index = Affector


function Affector:new()
  local obj = setmetatable({}, self)
  
  obj.affectors = {}

  return obj
end

function Affector:trigger(trigger,attribute)
  if self.affectors[trigger] == nil then return attribute end
  --print("before " .. attribute)
  local returnAttribute = attribute
  for i, event in ipairs(self.affectors[trigger]) do
    returnAttribute = event.event(attribute)
  end
  --print("after " .. returnAttribute)
  return returnAttribute
end

function Affector:add(trigger,func)
  if self.affectors[trigger] == nil then 
    self.affectors[trigger] = {}
  end
  table.insert(self.affectors[trigger],{
    event = func
  })
  return #self.affectors[trigger]
end

function Affector:remove(trigger,id)
    if self.affectors[trigger] == nil then return end
    table.remove(self.affectors[trigger],id) 
    return nil
end



return Affector