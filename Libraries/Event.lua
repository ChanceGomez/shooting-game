--Event.lua

local Event = {}
Event.__index = Event

function Event.new()
    local obj = setmetatable({},Event)

    obj.queueEvents = {}

    return obj
end

function Event:addQueue(tbl)
    if not tbl.timer then
    tbl.timer = 0
    end
    if not tbl.t then
    tbl.t = 1
    end
    table.insert(self.queueEvents,tbl)
end

function Event:update(dt)
    --queued events
    if #self.queueEvents > 0 then
        local event = self.queueEvents[1]
        event.timer = event.timer + dt
        if event.t < event.timer then
        event:event(self)
        table.remove(self.queueEvents,1)
        end
    end
end

return Event