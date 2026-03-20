local Inventory = {
    margin = 4,
}
Inventory.__index = Inventory


--Static images 
local static_inventorySlotBackgroundImage = al:getImage("background_equipment")
local static_inventorySlotBackgroundImageHovered = al:getImage("background_equipment_hovered")
--Static width/heights
local static_inventorySlotWidth = static_inventorySlotBackgroundImage:getWidth()
local static_inventorySlotHeight = static_inventorySlotBackgroundImage:getHeight()




local function generateSlots(cols,rows,x,y,margin)
    local tbl = {}

    local x,y = x or 0, y or 0 
    local margin = margin or 0

    for row = 1, rows do
        for col = 1, cols do
            local x = (col-1) * (static_inventorySlotWidth+margin) + x
            local y = (row-1) * (static_inventorySlotHeight+margin) + y
            
            table.insert(tbl,InventorySlot:new(x,y,
            {
                background = static_inventorySlotBackgroundImage,
                backgroundHovered = static_inventorySlotBackgroundImageHovered,
            }))
        end
    end

    return tbl
end

local function generateFunctions(self,functions)
    --table to return with basic function
    local tbl = {}

    local width = self.rightClickPanel.width
    local height = 16

    table.insert(tbl,Button:new({
        x = 0,
        y = 0,
        visible = false,
        color = {0,0,0,1},
        width = width,
        description = {
            text = "Close",
            font = dogica_8,
            x = 0,
            y = 1,
            limit = width,
            defaultColor = {1,1,1,1},
        },
        height = 16,
        clicked = function()
            self.isRightClick = false
        end,
    }))

    for i, func in ipairs(functions) do
        func.description.limit = width
        table.insert(tbl,Button:new({
            x = 0,
            y = 0,
            visible = false,
            color = {0,0,0,1},
            width = width,
            description = func.description,
            height = 16,
            clicked = function()
                func.clicked(self.rightClickedSlot)
            end,
        }))
        height = height + 16
    end

    self.rightClickPanel.height = height

    return tbl
end

local function generateSlotsByPos(tbl) 
    local returnTbl = {}
    for i, slot in ipairs(tbl) do
        --table.insert(returnTbl,InventorySlot)
    end

    return returnTbl
end

local function link(a, b, keys)
  local shared = {}
  for _, key in ipairs(keys) do
    shared[key] = a[key] or b[key]
  end

  local function isLinked(key)
    for _, k in ipairs(keys) do
      if k == key then return true end
    end
    return false
  end

  local function makeProxy(t)
    t._originalMeta = getmetatable(t)
    local originalMeta = t._originalMeta
    local proxy = {}

    proxy.__index = function(_, key)
      if isLinked(key) then
        return shared[key]
      end
      if originalMeta then
        local orig = originalMeta.__index
        if type(orig) == "function" then return orig(t, key)
        elseif type(orig) == "table" then return orig[key]
        end
      end
      return rawget(t, key)
    end

    proxy.__newindex = function(t, key, value)
      if isLinked(key) then
        shared[key] = value
      else
        rawset(t, key, value)
      end
    end

    return proxy
  end

  setmetatable(a, makeProxy(a))
  setmetatable(b, makeProxy(b))

  a._linked_proxy = true
  b._linked_proxy = true
  a._linked_keys = keys  -- store so unlink doesn't need them passed in
  b._linked_keys = keys
end

local function unlink(a, b)
  local keys = a._linked_keys  -- retrieve stored keys

  local lastValues = {}
  for _, key in ipairs(keys) do
    lastValues[key] = a[key]
  end

  setmetatable(a, a._originalMeta)
  setmetatable(b, b._originalMeta)

  for _, key in ipairs(keys) do
    a[key] = lastValues[key]
    b[key] = lastValues[key]
  end

  a._linked_proxy = nil
  b._linked_proxy = nil
  a._originalMeta = nil
  b._originalMeta = nil
  a._linked_keys = nil
  b._linked_keys = nil
end

function Inventory:new(x,y,col,row,functions)
    local obj = setmetatable({},Inventory)

    local cols,rows = col or 0,row or 0
    local functions = functions or {}
        

    obj.rows = rows
    obj.cols = cols

    obj.isRightClicked = false
    obj.rightClickedSlot = nil
    obj.rightClickPanel = {
        width = 96,
        height = 32, 
        x = 0,
        y = 0,
        functions = {},
    }
    obj.rightClickPanel.functions = generateFunctions(obj,functions)

    obj.heldItem = nil
    obj.heldItemOriginalSlot = nil

    obj.inventories = {}

    obj.x = x or 0
    obj.y = y or 0

    if rows then 
        obj.slots = generateSlots(cols,rows,x,y,obj.margin)
    end


    return obj
end

function Inventory:rightClickPanelClicked()
    self.isRightClick = false
    self.rightClickedSlot = nil
end

function Inventory:getNextEmptySlot()
    for i, slot in ipairs(self.slots) do
        if slot.item == nil then
            return slot
        end
    end
end

function Inventory:drag()
    --Check to see if mouse is dropped and is holding an item
    if not love.mouse.isDown(1) and self.heldItem then
        local isHovered = false
        --Cycle through all the slots to see if one is being hovered to drop item in there
        for i, slot in pairs(self.slots) do
            if slot.hovered and slot.item == nil then
                isHovered = slot:addItem(self.heldItem)
            end
        end
        --Check other inventory that can be hovered
        for _, inventory in ipairs(self.inventories) do
            for i, slot in pairs(inventory.slots) do
                if slot.hovered then
                    --Check to see if other inventory rejects item
                    isHovered = inventory:addItem(self.heldItem,slot)
                end
            end
        end
        --If there was no slot being held then return to original slot
        if not isHovered then
            self.heldItemOriginalSlot:addItem(self.heldItem)
        end

        --remove item from inventory held variable
        self.heldItem = nil
    end


    for i, slot in pairs(self.slots) do
        --See if slot meets requirements to be held
        if slot.hovered and love.mouse.isDown(1) and self.heldItem == nil then
            --Set helditem to the slots item
            self.heldItem = slot.item
            self.heldItemOriginalSlot = slot
            --Remove item from the slot
            slot:removeItem()
        end
        -- See if slot can be rightclicked
        if slot.hovered and rightClick and self.heldItem == nil and slot.item then
            self.isRightClick = true
            self.rightClickedSlot = slot
        end
    end

    --If item is being held then deal with position logic
    if self.heldItem then
        local heldItem = self.heldItem
        local x,y = CursorX-(heldItem.width/2),CursorY-(heldItem.height/2)
        heldItem.x,heldItem.y = x,y
    end
end

function Inventory:linkInventory(inventory)
    table.insert(self.inventories,inventory)
    table.insert(inventory.inventories,self)
    link(self,inventory, {"heldItem","heldItemOriginalSlot"})
end

function Inventory:unlinkInventory(inventory)
    --remove from self
    for i, instance in ipairs(self.inventories) do
        if instance == inventory then
            table.remove(self.inventories,i)
        end
    end

    --remove from other inventory
    for i, instance in ipairs(inventory.inventories) do
        if instance == self then
            table.remove(inventory.inventories,i)
        end
    end
    unlink(self,inventory)
end

function Inventory:addItem(item,slot)
    slot = slot or self:getNextEmptySlot()
    slot:addItem(item)
end

function Inventory:update(dt)
    --Deal with dragging
    self:drag()
    for i, slot in pairs(self.slots) do
        slot:update(dt)
    end

    --Upate rightclick buttons
    if self.isRightClick then
        local slot = self.rightClickedSlot
        self.rightClickPanel.x,self.rightClickPanel.y = slot.x + slot.width/2, slot.y + slot.height/2
        local x,y = self.rightClickPanel.x,self.rightClickPanel.y
        for i, button in pairs(self.rightClickPanel.functions) do
            button.visible = true

            button.x = x
            button.y = y + ((i-1)*16)
            button:update()
        end
    else
        for i, button in pairs(self.rightClickPanel.functions) do
            button.visible = false
        end
    end

    if love.mouse.isDown(1) and self.isRightClick then
        self.isRightClick = false
    end
end

function Inventory:drawHeldItem(item)
    if item then
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(item.image,item.x,item.y)
    end
end

function Inventory:draw()
    for i, slot in pairs(self.slots) do
        slot:draw()
    end

    --draw infopanels
    for i, slot in pairs(self.slots) do
        if slot.hovered and slot.item and self.heldItem == nil then
            infopanel:draw(slot.item)
        end
    end

    --Draw right click panel
    if self.isRightClick then
        local slot = self.rightClickedSlot
        local rightClickPanel = self.rightClickPanel

        love.graphics.setColor(1,1,1,1)
        love.graphics.rectangle("fill",rightClickPanel.x,rightClickPanel.y,rightClickPanel.width,rightClickPanel.height)

        --draw buttons
        for i, button in ipairs(self.rightClickPanel.functions) do
            button:draw()
        end
    end

    --draw held item
    self:drawHeldItem(self.heldItem)
end

return Inventory