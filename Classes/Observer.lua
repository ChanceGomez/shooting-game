local Observer = {}
Observer.__index = Observer



function Observer:new()
  local obj = setmetatable({}, self)
  
  obj.events = {}

  return obj
end


function Observer:trigger(name,tbl)
  local wrapper = tbl or false
  if self.events[name] == nil then return end
  for i, event in ipairs(self.events[name]) do
    if wrapper then
      event:event(wrapper)
    else
      event:event()
    end
  end
end

function Observer:add(trigger,obj)
  if self.events[trigger] == nil then 
    self.events[trigger] = {}
  end
  table.insert(self.events[trigger],obj)
  
  for i, event in pairs(self.events) do

  end
end



return Observer