local Node = {}
Node.__index = Node

function Node:new(x,y,nodeX,nodeY,map,seed,isEndNode)
    local obj = setmetatable({},Node)

    obj.isEndNode = isEndNode or false
    obj.x = x or 100
    obj.y = y or 100
    obj.nodeX = nodeX
    obj.nodeY = nodeY
    obj.key = nodeX .. ' ' .. nodeY
    obj.radius = 10
    obj.nodes = {}
    obj.color = {1,1,1,1}
    obj.map = map
    obj.isPlayer = false
    obj.enabled = true
    obj.seed = seed

    obj.enemies,obj.isArtifact = obj.map.handler:getEnemies(obj.nodeY,obj.seed)
    obj.description = {
        text = "Enemies: " .. #obj.enemies
    }
    if obj.isArtifact then
        obj.description.text = obj.description.text .. " {.2,.2,.4,1}Artifact"
    end

    return obj
end

function Node:clicked()
    for i, node in ipairs(self.nodes) do
        if self.map.playerLocation == node.key and node.nodeY < self.nodeY then
            self.map.playerLocation = self.key
            node.enabled = false
            self.map.handler:nodeClicked(self.enemies,self.nodeY,self.isArtifact,self.isEndNode)
        end
    end
end

function Node:update(camera)
    if self.isArtifact then
        self.color = {.3,.3,.2,1}
    else
        self.color = {1,1,1,1}
    end

    if collision.circle(self,camera.x,camera.y) then
        self.color = {.3,.2,.2,1}
        self.hovered = true
        if leftClick then
            self:clicked()
        end
    else
        self.hovered = false
    end

    if self.map.playerLocation == self.key then
        self.color = {.2,.2,.3,1}
        self.isPlayer = true
    else
        self.isPlayer = false
    end

    if not self.enabled then
        self.color = {.2,.2,.2,1}
    end
end

function Node:draw()
    love.graphics.setColor(self.color)
    love.graphics.circle("fill",self.x,self.y,self.radius)
end

return Node