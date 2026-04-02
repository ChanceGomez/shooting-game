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

function Affector:new()
  local obj = setmetatable({}, self)
  
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

function Affector:getDescription(ids)
    local desc = ""
    --Cycle through the ids
    for i, id in ipairs(ids) do
        local trigger = id[1]
        local type = id[2]
        local variable = id[3]

        local beforeStat = trim(self:getStat(trigger,type),2)
        self:add(trigger,type,variable)
        local afterStat = trim(self:getStat(trigger,type),2)


        -- get before variable
        desc = desc .. " /n" .. customtext:formatString(trigger,{.2,.2,.4,1}) .. ": " .. customtext:formatString(tostring(beforeStat),self:getColor(type))
        -- get after
        desc = desc .. " -> " .. customtext:formatString(tostring(afterStat),self:getColor(type))
        self:remove(trigger,type,variable)
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
    if returnAttribute == nil then returnAttribute = 0 end

    for i, mult in ipairs(self.affectors[trigger].mult) do
        returnAttribute = mult.event(returnAttribute)
    end

    return returnAttribute
end

function Affector:getStat(trigger,type)
    local type = type or "all"

    if type == "add" then
        return self:getAdd(trigger,game:getVariable(trigger))
    elseif type == "mult" then
        return self:getMult(trigger,game:getVariable(trigger))
    elseif type == "bool" then
        return self:getBool(trigger,game:getVariable(trigger))
    elseif type == "both" then
        return self:trigger(trigger,game:getVariable(trigger))
    end
end

function Affector:getStats(ids)
    local str = ""

    for i, id in ipairs(ids) do
        local trigger = id[1]
        local type = id[2]
        str = str .. ' /n'.. customtext:formatString(trigger,{.2,.2,.4,1}) .. ': ' .. tostring(self:getStat(trigger,type))
    end

    return str
end

function Affector:addIDs(ids) 
    for i, id in ipairs(ids) do
        self:add(id[1],id[2],id[3])
    end
end

function Affector:removeIDs(ids)
    for i, id in ipairs(ids) do
        self:remove(id[1],id[2],id[3])
    end
end

function Affector:trigger(trigger,attribute)
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