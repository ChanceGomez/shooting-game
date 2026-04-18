local Nest = {}
Nest.__index = Nest

local images = {
    body = assetloader:getImage("nest_body"),
    arm1 = assetloader:getImage("nest_arm1"),
    arm2 = assetloader:getImage("nest_arm2"),
    arm3 = assetloader:getImage("nest_arm3"),
    arm4 = assetloader:getImage("nest_arm4"),
}
local imageData = {
    body = assetloader:getImageData("nest_body"),
    arm1 = assetloader:getImageData("nest_arm1"),
    arm2 = assetloader:getImageData("nest_arm2"),
    arm3 = assetloader:getImageData("nest_arm3"),
    arm4 = assetloader:getImageData("nest_arm4"),
}

local polygons = {
    body = assetloader:getPolygon("nest_body"),
    arm1 = assetloader:getPolygon("nest_arm1"),
    arm2 = assetloader:getPolygon("nest_arm2"),
    arm3 = assetloader:getPolygon("nest_arm3"),
    arm4 = assetloader:getPolygon("nest_arm4"),
}

function Nest.new(x,y,handler)
    local obj = setmetatable({},Nest)


    obj.polygon = true
    obj.images = images
    obj.imageData = imageData
    obj.polygons = polygons
    obj.color = {1,1,1,1}
    obj.isAlive = true
    obj.handler = handler
    obj.enemies = {}
    obj.spawnTimer = 0
    obj.resources = 500
    obj.spawnInterval = 5
    obj.arms = {}
    table.insert(obj.arms,Enemies.NestArm.new(obj.images.arm1,obj.imageData.arm1,obj,obj.polygons.arm1))
    table.insert(obj.arms,Enemies.NestArm.new(obj.images.arm2,obj.imageData.arm2,obj,obj.polygons.arm2))
    table.insert(obj.arms,Enemies.NestArm.new(obj.images.arm3,obj.imageData.arm3,obj,obj.polygons.arm3))
    table.insert(obj.arms,Enemies.NestArm.new(obj.images.arm4,obj.imageData.arm4,obj,obj.polygons.arm4))
    obj.body = Enemies.NestBody.new(obj.images.body,obj.imageData.body,obj,obj.polygons.body)


    return obj
end

function Nest:checkCircleCollision(circle,properties)
    local valid = false
    --check collision of arms
    for i, arm in ipairs(self.arms) do
        local temp = arm:checkCircleCollision(circle,properties)
        if valid == false then
            valid = temp
        end
    end
    local temp = self.body:checkCircleCollision(circle,properties)
    if valid == false then
        valid = temp
    end

    return valid
end

function Nest:delete()
    game.Player:addResources(self.resources)
    if self.handler then
        self.handler:removeEnemy(self)
    end
end

function Nest:deleteBody(arm)
    self.body = nil
    self:delete()
end

function Nest:deleteArm(arm)
    for i, instance in ipairs(self.arms) do
        if instance == arm then
            table.remove(self.arms,i)
        end
    end
    if #self.arms == 0 then
        self:delete()
    end
end

function Nest:isCollision(properties)
    --check collision of arms
    local valid = false
    for i, arm in ipairs(self.arms) do
        if arm:isCollision(properties) then
            valid = true
        end
    end
    if self.body:isCollision(properties) then
        valid = true
    end
    return valid
end

function Nest:hit(properties)

end

function Nest:newEnemy()
    local facing = false
    local r = math.random(1,2) 
    if r == 1 then facing = true end
    self.handler:newEnemy("Bird",self.body.centerX,self.body.centerY+100,facing)
end

function Nest:update(dt)
    self.spawnTimer = self.spawnTimer + dt
    --spawn enemies
    if self.spawnTimer >= self.spawnInterval then
        self.spawnInterval = self.spawnInterval * .95
        self.spawnTimer = 0
        self:newEnemy()
    end
    --update arms
    for i, arm in ipairs(self.arms) do
        arm:update(dt)
    end
    self.body:update(dt)
end

function Nest:draw()
    --draw layers
    for i, arm in ipairs(self.arms) do
        arm:draw()
    end
    self.body:draw()
end

return Nest