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

function Nest.new(x,y,handler)
    local obj = setmetatable({},Nest)


    
    obj.images = images
    obj.imageData = imageData
    obj.color = {1,1,1,1}
    obj.isAlive = true
    obj.handler = handler
    obj.enemies = {}
    obj.spawnTimer = 0
    obj.resources = 500
    obj.spawnInterval = 5
    obj.arms = {}
    table.insert(obj.arms,Enemies.NestArm.new(obj.images.arm1,obj.imageData.arm1,obj))
    table.insert(obj.arms,Enemies.NestArm.new(obj.images.arm2,obj.imageData.arm2,obj))
    table.insert(obj.arms,Enemies.NestArm.new(obj.images.arm3,obj.imageData.arm3,obj))
    table.insert(obj.arms,Enemies.NestArm.new(obj.images.arm4,obj.imageData.arm4,obj))
    obj.body = Enemies.NestBody.new(obj.images.body,obj.imageData.body,obj)


    return obj
end

function Nest:delete()
    game.lookouts[1].Report:action("resources",self.resources)
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

function Nest:isCollision()
    --check collision of arms
    local valid = false
    for i, arm in ipairs(self.arms) do
        if arm:isCollision() then
            valid = true
        end
    end
    if self.body:isCollision() then
        valid = true
    end
    return valid
end

function Nest:hit(properties)
    if #self.arms > 0 then
        for i, arm in ipairs(self.arms) do
            if arm:isCollision() then
                arm:hit(properties)
            end
        end
    end
    if self.body:isCollision() then
        self.body:hit(properties)
    end
end

function Nest:newEnemy()
    local facing = -1
    local r = math.random(1,2) 
    if r == 1 then facing = 1 end
    self.handler:newEnemy("Bird",self.body.centerX,self.body.centerY+100,facing)
end

function Nest:update(dt)
    self.spawnTimer = self.spawnTimer + dt
    --spawn enemies
    if self.spawnTimer >= self.spawnInterval then
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