local Map = {}
Map.__index = Map

local function generateNodes(obj,generation,length)
    local tbl = {}


    local function generateNode(nodeX,nodeY,node,isEnd)
        local key = nodeX .. ' ' .. nodeY

        local function linkNode()
            if node then
                table.insert(node.nodes,tbl[key])
                table.insert(tbl[key].nodes,node)
            end
        end
        
        --Make sure node doesn't already exist
        if tbl[key] then
            linkNode()
            return tbl[key]
        end
        local x,y = (nodeX * obj.unitsBetweenX) + obj.midPointX,(-nodeY * obj.unitsBetweenY) + obj.midPointY
        tbl[key] = Node:new(x,y,nodeX,nodeY,obj,obj.generator:random(1,1000),isEnd)

        linkNode()

        return tbl[key]
    end

    local function generateOutwardGeneration(node,iteration)
        if node == nil then return end
        local iteration = iteration or 0
        if generation <= iteration then return end
        iteration = iteration + 1
        --Child 1 
        local nodeX,nodeY = node.nodeX - 1, node.nodeY + 1
        generateOutwardGeneration(generateNode(nodeX,nodeY,node),iteration)

        --Child 2
        local nodeX,nodeY = node.nodeX + 1, node.nodeY + 1
        generateOutwardGeneration(generateNode(nodeX,nodeY,node),iteration)

    end

    local function generateDownwardGeneration(node,iteration)
        if node == nil then return end
        local iteration = iteration or 0
        if generation <= iteration then 
            generateNode(node.nodeX,node.nodeY-1,node)
            return
        end
        iteration = iteration + 1

        --Child 1 
        local nodeX,nodeY = node.nodeX - 1, node.nodeY - 1
        generateDownwardGeneration(generateNode(nodeX,nodeY,node),iteration)

        --Child 2
        local nodeX,nodeY = node.nodeX + 1, node.nodeY - 1
        generateDownwardGeneration(generateNode(nodeX,nodeY,node),iteration)
    end

    local function generateSingleGeneration(node,iteration)
        local iteration = iteration or 0
        if iteration >= length-(generation*2)-2 then
            return
        end
        iteration = iteration + 1

        local nodeX,nodeY = node.nodeX,node.nodeY + 1
        generateSingleGeneration(generateNode(nodeX,nodeY,node),iteration)
    end

    --Create parent node
    generateNode(0,0)


    --Generate all exterior children nodes
    generateOutwardGeneration(tbl["0" .. " " .. "0"])

    
    local endNodes = {}
    local extremeMin = -generation
    for i = 1, generation + 1 do
        local key = (extremeMin+((i-1) * 2)) .. " " .. generation
        table.insert(endNodes,key)
    end
    
    for i, key in ipairs(endNodes) do
        generateSingleGeneration(tbl[key],0,tbl[key])
    end

    --generate end node and start downward generation
    generateDownwardGeneration(generateNode(0,length-1,nil,true))

    return tbl
end

function Map:new(seed,generation,length,handler)
    local obj = setmetatable({},Map)

    obj.midPointX = Width/2
    obj.midPointY = 300

    obj.unitsBetweenX = 30
    obj.unitsBetweenY = 35

    obj.handler = handler

    obj.generator = love.math.newRandomGenerator(seed or 1)
    obj.nodes = generateNodes(obj,generation or 3,length or 8)

    obj.playerLocation = 0 .. ' ' .. 0

    return obj
end

function Map:update(dt,camera)
    for i, node in pairs(self.nodes) do
        node:update(camera)
    end
end

function Map:draw()
    --draw previous nodes lines
    for i, node in pairs(self.nodes) do
        if not node.enabled then
            for i, connectingNode in ipairs(node.nodes) do
                if not connectingNode.enabled or connectingNode.isPlayer then
                    love.graphics.setColor(.6,.6,.6,1)
                    love.graphics.line(node.x,node.y,connectingNode.x,connectingNode.y)
                end
            end
        end
    end

    for i, node in pairs(self.nodes) do
        if node.hovered or node.isPlayer then
            for i, connectingNode in ipairs(node.nodes) do
                if connectingNode.nodeY > node.nodeY then
                    love.graphics.setColor(1,1,1,1)
                    love.graphics.line(node.x,node.y,connectingNode.x,connectingNode.y)
                end
            end
        end
    end

    for i, node in pairs(self.nodes) do
        node:draw()
    end

    for i, node in pairs(self.nodes) do
        if node.hovered then
            infopanel:draw(node,128)
        end
    end
end

return Map