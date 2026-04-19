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

--[[
    Descriptions oriented functions
]]

local function getColor(affector,type) 
    return self.colors[type]
end

local function getFormattedMult(variable)
    return tostring(variable .. "%")
end

local function getDescriptionVariable(affector,trigger,type)
    local variable = affector:getRaw(trigger,type)

    if type == "mult" then
        variable = variable * 100
        variable = tostring(variable .. "%")
    elseif type == "add" then
        
    end

    return tostring(variable)
end 

local function getFormattedTrigger(trigger,type)
    local str = ""
    if type == "add" then
        str = trigger 
    elseif type == "bool" then
        str = trigger
    elseif type == "mult" then
        str = trigger .. " Multiplier"
    end
    return customtext:formatString(str,{.2,.2,.4,1}) .. ": "
end

--Gets the description of the ids
function Affector:getDescription(ids)
    local desc = ""
    --Cycle through the ids
    for i, id in ipairs(ids) do
        local trigger = id[1]
        local type = id[2]
        local variable = id[3]

        local formattedTrigger = getFormattedTrigger(trigger,type)
        local beforeStat = formattedTrigger .. trim(getDescriptionVariable(self,trigger,type),2)
        self:add(trigger,type,variable)
        local afterStat = getDescriptionVariable(self,trigger,type)
        self:remove(trigger,type,variable)

        -- get before variable
        desc = desc .. " /n" .. beforeStat
        -- get after
        desc = desc .. " -> " .. afterStat
    end 
    
    return desc
end

--[[
    Logic oriented functions
]]

function Affector:getBool(trigger)
    local attribute = self.handler:getVariable(trigger)
    if self.affectors[trigger] == nil then return attribute end
    local returnAttribute = attribute 
    if returnAttribute == nil then return end

    for i, bool in ipairs(self.affectors[trigger].bool) do
        returnAttribute = bool.event(returnAttribute)
    end

    return returnAttribute
end

function Affector:getAdd(trigger)
    local attribute = self.handler:getVariable(trigger)
    if self.affectors[trigger] == nil then return attribute end
    local returnAttribute = attribute 
    if returnAttribute == nil then return end

    for i, add in ipairs(self.affectors[trigger].add) do
        returnAttribute = add.event(returnAttribute)
    end

    return math.max(returnAttribute,0)
end

function Affector:getMult(trigger)
    if self.affectors[trigger] == nil then return 0 end
    local returnAttribute = 0 

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
    return str
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

--[[

Id logic

]]

function Affector:addIDs(ids) 
    for i, id in ipairs(ids) do
        self:addID(id)
    end
end

function Affector:addID(id)
    local trigger = id[1]
    local type = id[2]
    local attribute = id[3]
    --print(trigger,type,attribute)
    self:add(trigger,type,attribute)
end

function Affector:removeIDs(ids)
    for i, id in ipairs(ids) do
        self:removeID(id)
    end
end

function Affector:removeID(id)
    self:remove(id[1],id[2],id[3])
end

--Triggers the entire line
function Affector:trigger(trigger,attribute)
    local attribute,multType = self.handler:getVariable(trigger)
    if self.affectors[trigger] == nil then return attribute end
    
    local returnAttribute = attribute 
    if returnAttribute == nil then returnAttribute = 0 end

    --Check to see if the attribute is a boolean
    if type(returnAttribute) == "boolean" then
        --get bool
        return self:getBool(trigger,returnAttribute)
    end
    --get add
    returnAttribute = self:getAdd(trigger,returnAttribute)

    --get mult
    if multType == "divide" then
        local variable = self:getMult(trigger,returnAttribute)
        if variable > 0 then
            returnAttribute = returnAttribute / (1 + math.abs(self:getMult(trigger,returnAttribute)))
        else
            returnAttribute = returnAttribute * (1 + math.abs(self:getMult(trigger,returnAttribute)))
        end
    else
        returnAttribute = returnAttribute * (1 + self:getMult(trigger,returnAttribute))
    end
    

  
    return returnAttribute
end

--Add a new variable
function Affector:add(trigger,type,variable)
    checkTrigger(self,trigger)
    table.insert(self.affectors[trigger][type],{
        variable = variable, 
        event = function(attribute)
            if type == "add" then
                return attribute + variable
            elseif type == "mult" then
                return attribute + variable
            elseif type == "bool" then
                return variable
            end
        end,
    })
  return #self.affectors[trigger]
end

--Remove a variable
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