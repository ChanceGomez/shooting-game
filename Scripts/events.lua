local events = {
  events = {},
  queueEvents = {},
  conditionalEvents = {},
  timedConditionalEvents = {},
}

function events:add(tbl)
  if not tbl.timer then
    tbl.timer = 0
  end
  if not tbl.t then
    tbl.t = 1
  end
  table.insert(self.events,tbl)
end

function events:addQueue(tbl)
  if not tbl.timer then
    tbl.timer = 0
  end
  if not tbl.t then
    tbl.t = 1
  end
  table.insert(self.queueEvents,tbl)
end

function events:addConditional(tbl)
  table.insert(self.conditionalEvents,tbl)
end

function events:addTimedConditional(tbl)
  if not tbl.timer then
    tbl.timer = 0
  end
  if not tbl.t then
    tbl.t = 1
  end
  table.insert(self.timedConditionalEvents,tbl)
end


function events:update(dt)
  for i = #self.events, 1, -1 do
    local event = self.events[i]
    event.timer = event.timer + dt
    if event.t < event.timer then
      event:event(self)
      table.remove(self.events,i)
    end
  end
  
  if #self.queueEvents > 0 then
    local event = self.queueEvents[1]
    event.timer = event.timer + dt
    if event.t < event.timer then
      event:event(self)
      table.remove(self.queueEvents,1)
    end
  end
  
  for i = #self.conditionalEvents, 1, -1 do
    local event = self.conditionalEvents[i]
    if event:event(self) then
      table.remove(self.conditionalEvents,i)
    end
  end
  
  for i = #self.timedConditionalEvents, 1, -1 do
    local event = self.timedConditionalEvents[i]
    event.timer = event.timer + dt
    if event.t < event.timer then
      if event:event(self) then
        table.remove(self.timedConditionalEvents,i)
      end
    end
  end
  
  
end

return events