local Affector = {}
Affector.__index = Affector

local function checkTrigger(self,trigger)
    if self.affectors[trigger] == nil then 
        self.affectors[trigger] = {
            add = {},
            mult = {},
            bool = {},
        }
    end
end

function Affector.new(handler)
    local obj = setmetatable({}, Affector)

    obj.handler = handler
    obj.affectors = {}
    obj.colors = {
    add = {0,0,.6,1},
    mult = {.6,0,0,1},
    bool = {0,.6,0,1},
    }

    return obj
end

function Affector:getColor(type) 
    return self.colors[type]
end

function Affector:getFormattedTrigger(trigger)
    return customtext:formatString(trigger,{.2,.2,.4,1}) .. ": "
end

function Affector:getDescription(ids)
    local desc = ""
    --Cycle through the ids
    for i, id in ipairs(ids) do
        local trigger = id[1]
        local type = id[2]
        local variable = id[3]

        local beforeStat = self:getFormattedTrigger(trigger) .. trim(self:getRaw(trigger,type),2)
        self:add(trigger,type,variable)
        local afterStat = trim(self:getRaw(trigger,type),2) .. game:getUnit(trigger)
        self:remove(trigger,type,variable)

        -- get before variable
        desc = desc .. " /n" .. beforeStat
        -- get after
        desc = desc .. " -> " .. afterStat
    end 
    
    return desc
end

function Affector:getBool(trigger,attribute)
    if self.affectors[trigger] == nil then return attribute end
    local returnAttribute = attribute 
    if returnAttribute == nil then return end

    for i, bool in ipairs(self.affectors[trigger].bool) do
        returnAttribute = bool.event(returnAttribute)
    end

    return returnAttribute
end

function Affector:getAdd(trigger,attribute)
    if self.affectors[trigger] == nil then return attribute end
    local returnAttribute = attribute 
    if returnAttribute == nil then return end

    for i, add in ipairs(self.affectors[trigger].add) do
        returnAttribute = add.event(returnAttribute)
    end

    return returnAttribute
end

function Affector:getMult(trigger,attribute)
    if self.affectors[trigger] == nil then return attribute end
    local returnAttribute = attribute 
    if returnAttribute == 0 then returnAttribute = 1 end
    if returnAttribute == nil then returnAttribute = 0 end

    for i, mult in ipairs(self.affectors[trigger].mult) do
        returnAttribute = mult.event(returnAttribute)
    end

    return returnAttribute
end

function Affector:getStat(trigger,type)
    local type = type or "all"

    local str = customtext:formatString(trigger,{.2,.2,.4,1}) .. ": "
    local attribute = game:getVariable(trigger)

    if type == "add" then
        str = str .. self:getAdd(trigger,attribute) 
    elseif type == "mult" then
        str = str .. self:getMult(trigger,attribute)
    elseif type == "bool" then
        str = str .. self:getBool(trigger,attribute)
    elseif type == "all" then
        str = str .. self:trigger(trigger,attribute)
    end
    return str .. game:getUnit(trigger) 
end

function Affector:getRaw(trigger,type)
    if type == "add" then
        return self:getAdd(trigger,game:getVariable(trigger)) 
    elseif type == "mult" then
        return  self:getMult(trigger,game:getVariable(trigger))
    elseif type == "bool" then
        return  self:getBool(trigger,game:getVariable(trigger))
    elseif type == "both" then
        return  self:trigger(trigger,game:getVariable(trigger))
    end
end

function Affector:getStats(ids)
    local str = ""

    for i, id in ipairs(ids) do
        local trigger = id[1]
        local type = id[2]
        str = str .. ' /n'.. self:getStat(trigger,type)
    end

    return str
end

function Affector:addIDs(ids) 
    for i, id in ipairs(ids) do
        self:addID(id)
    end
end

function Affector:addID(id)
    self:add(id[1],id[2],id[3])
end

function Affector:removeIDs(ids)
    for i, id in ipairs(ids) do
        self:removeID(id)
    end
end

function Affector:removeID(id)
    self:remove(id[1],id[2],id[3])
end

function Affector:trigger(trigger,attribute)
    local attribute = attribute or self.handler:getVariable(trigger)
    if self.affectors[trigger] == nil then return attribute end
    
    local returnAttribute = attribute 
    if returnAttribute == nil then returnAttribute = 0 end

    --get add
    returnAttribute = self:getAdd(trigger,returnAttribute)

    --get mult
    returnAttribute = self:getMult(trigger,returnAttribute)

    --get bool
    returnAttribute = self:getBool(trigger,returnAttribute)

  
    return returnAttribute
end

function Affector:add(trigger,type,variable)
    checkTrigger(self,trigger)
    table.insert(self.affectors[trigger][type],{
        variable = variable, 
        event = function(attribute)
            if type == "add" then
                return attribute + variable
            elseif type == "mult" then
                return attribute * variable
            elseif type == "bool" then
                return variable
            end
        end,
    })
  return #self.affectors[trigger]
end

function Affector:mult(trigger,variable)
    checkTrigger(self,trigger)
    table.insert(self.affectors[trigger].mult,{
        variable = variable,
        event = function(attribute)
            return attribute * variable
        end,
    })
end

function Affector:remove(trigger,type,variable)
    if self.affectors[trigger] == nil then return end
    
    for i, affector in ipairs(self.affectors[trigger][type]) do
        if variable == affector.variable then
            table.remove(self.affectors[trigger][type],i)
            return
        end
    end

    return nil
end



return Affector