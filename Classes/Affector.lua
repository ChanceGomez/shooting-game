local Affector = {}
Affector.__index = Affector


function Affector:new()
  local obj = setmetatable({}, self)
  
  obj.affectors = {}

  return obj
end

function Affector:trigger(trigger,attribute)
  if self.affectors[trigger] == nil then return end
  for i, event in ipairs(self.affectors[trigger]) do
    event:event(attribute)
  end
  return attribute
end

function Affector:add(trigger,func)
  if self.affectors[trigger] == nil then 
    self.affectors[trigger] = {}
  end
  table.insert(self.affectors[trigger],func)
end

function Affector:remove(trigger,func)
    if self.affectors[trigger] == nil then return end
    for i, affector in ipairs(self.affectors[trigger]) do
        if affector == func then
            table.remove(self.affectors[trigger],i)
            return
        end
    end
end



return Affector