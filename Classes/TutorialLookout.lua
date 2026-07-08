local TutorialLookout = {}
TutorialLookout.__index = TutorialLookout

setmetatable(TutorialLookout,{__index = Lookout})

function TutorialLookout.new()
    local obj = Lookout.new(nil,1,nil)

    obj.labels = {}

    
    local label_5 = Label.new({
        x = window.GameWidth/2 - 196/2,
        y = 50,
        width = 196,
        height = 40,
        text = {
            text = "This is your health, if it reaches 0 you lose."
        },
        clicked = function(self)
            self:delete()
            --table.insert(obj.labels,label_6)
        end,    
    })
    local label_4 = Label.new({
        x = 70,
        y = 310,
        width = 196,
        height = 40,
        text = {
            text = "These are your grenades, use right click to use them"
        },
        clicked = function(self)
            self:delete()
            table.insert(obj.labels,label_5)
        end,    
    })
    local label_3 = Label.new({
        x = 40,
        y = 300,
        width = 196,
        height = 48,
        text = {
            text = "If the bullet is red that is a dud, if it is white it is a normal bullet"
        },
        clicked = function(self)
            self:delete()
            table.insert(obj.labels,label_4)
        end,    
    })
    local label_2 = Label.new({
        x = 40,
        y = 310,
        text = {
            text = "This is what is in your chamber"
        },
        clicked = function(self)
            self:delete()
            table.insert(obj.labels,label_3)
        end,    
    })
    local label_1 = Label.new({
        x = 40,
        y = 250,
        text = {
            text = "This is your current ammo"
        },
        clicked = function(self)
            self:delete()
            table.insert(obj.labels,label_2)
        end,    
    })
    table.insert(obj.labels,label_1)

    return setmetatable(obj,TutorialLookout)
end

function TutorialLookout:update(dt)
    local isLabel = false

    --Delete labels that are dead
    for i = #self.labels, 1, -1 do
        local label = self.labels[i]
        if label.dead then
            table.remove(self.labels,i)
        end
    end

    --Cycle through labels to update them
    for i, label in ipairs(self.labels) do
        isLabel = true
        label:update(dt)
    end

    if not self.handler.isRoundActive then
        Scene = "title"
        love.audio.stop()
        return
    end

    if not isLabel then
        Lookout.update(self,dt)
    end
end

function TutorialLookout:draw()
    Lookout.draw(self)

    for i, label in ipairs(self.labels) do
        label:draw()
    end

    drawCursor()
end 

return TutorialLookout