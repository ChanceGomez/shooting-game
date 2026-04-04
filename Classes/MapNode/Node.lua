local Node = {}
Node.__index = Node

function Node.new(x,y,nodeX,nodeY,map,seed,isEndNode)
    local obj = setmetatable({},Node)

    obj.isEndNode = isEndNode
    obj.x = x or 100
    obj.y = y or 100
    obj.nodeX = nodeX
    obj.nodeY = nodeY
    obj.key = nodeX .. ' ' .. nodeY
    obj.radius = 10
    obj.nodes = {}
    obj.tempColor = nil
    obj.map = map
    obj.isPlayer = false
    obj.enabled = true
    obj.seed = seed
    obj.color = {1,1,1,1}

    obj.variables = obj.map.handler:getVariables(obj)

    --check to see if variables has a description
    if obj.variables.description then
        obj.description = obj.variables.description
    end
    if obj.variables.color then
        obj.color = obj.variables.color
    end

    return obj
end

function Node:clicked()
    for i, node in ipairs(self.nodes) do
        if self.map.playerLocation == node.key and node.nodeY < self.nodeY then
            self.map.playerLocation = self.key
            node.enabled = false
            self.map.handler:nodeClicked(self.variables)
        end
    end
end

function Node:update(camera)
    self.tempColor = nil
    if collision.circle(self,camera.x,camera.y) then
        self.tempColor = {.3,.2,.2,1}
        self.hovered = true
        if leftClick then
            self:clicked()
        end
    else
        self.hovered = false
    end

    if self.map.playerLocation == self.key then
        self.tempColor = {.2,.2,.3,1}
        self.isPlayer = true
    else
        self.isPlayer = false
    end

    if not self.enabled then
        self.color = {.2,.2,.2,1}
    end
end

function Node:draw()
    local color = self.color
    if self.tempColor then
        color = self.tempColor
    end
    love.graphics.setColor(color)
    love.graphics.circle("fill",self.x,self.y,self.radius)
    if not self.enabled then
        love.graphics.setColor(.1,.1,.1,1)
        love.graphics.circle("fill",self.x,self.y,self.radius-2)
    end
end

return Node