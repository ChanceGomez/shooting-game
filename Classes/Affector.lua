local Affector = {}
Affector.__index = Affector


function Affector:new()
  local obj = setmetatable({}, self)
  
  obj.affectors = {}

  return obj
end

function Affector:getDescription(ids)
    local desc = ""
    --Cycle through the ids
    for i, id in ipairs(ids) do
        local trigger = id[1]
        local type = id[2]
        local variable = id[3]
        -- get before variable
        desc = desc .. " /n" .. ct:formatString(trigger,{.2,.2,.4,1}) .. ": " .. tostring(self:trigger(trigger,game.Player:getVariable(trigger)))
        -- get after
        self:add(trigger,type,variable)
        desc = desc .. " -> " .. tostring(self:trigger(trigger,game.Player:getVariable(trigger)))
        self:remove(trigger,type,variable)
    end 
    return desc
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

  --check for add
    
    for i, add in ipairs(self.affectors[trigger].add) do
        returnAttribute = add.event(returnAttribute)
    end

  --check for mult 
    for i, mult in ipairs(self.affectors[trigger].mult) do
        returnAttribute = mult.event(returnAttribute)
    end

    --check for booleans
    for i, bool in ipairs(self.affectors[trigger].bool) do
        returnAttribute = bool.event(returnAttribute)
    end 
  
    return returnAttribute
end

local function checkTrigger(self,trigger)
    if self.affectors[trigger] == nil then 
        self.affectors[trigger] = {
            add = {},
            mult = {},
            bool = {},
        }
    end
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