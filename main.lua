--[[
  Programmer: Chance Gomez | chance.f.gomez@gmail.com
  File: main.lua | Project: shooting game
]]
  
  
 
--Scripts
al = require("scripts/assetloader")
drag = require("scripts/drag")
collision = require("scripts/collision")
controls = require("scripts/controls")
tween = require("scripts/tween")
array = require("scripts/array")
button = require("scripts/buttons")
zdraw = require("scripts/zdraw")
event = require("scripts/events")
infopanel = require("scripts/infopanel")
popup = require("scripts/popup")
ap = require("scripts/animationplayer")
roundscript = require("scripts/roundscript")
upgrades = require("scripts/upgrades")
artifacts = require("scripts/artifacts")
equipment = require("scripts/equipment")
ct = require("scripts/customtext")
statpanel = require("scripts/statpanel")
tab = require("scripts/tab")

--Preloaded classes
Observer = require("classes/Observer")
Affector = require("classes/Affector")
Event = require("Classes/Event")
Button = require("classes/Button")

--Scenes  
  game = require("Scenes/game")
  title = require("Scenes/title")
  endofround = require("Scenes/endofround")
  shop = require("Scenes/shop")
  gun = require("Scenes/gun")
  difficultyselection = require("Scenes/difficultyselection")
  
--Global vars
Width,Height = 640,360
Scale = 3
mainCanvas = nil
GameSpeed = 1

--Game setting
settings = {
  volume = .5, -- Global volume
  hitbox = true, -- Display hitboxes on enemies
  showHealth = true,
  showAlive = false,
  debug = true,
  difficulty = 'easy',
  loadShopOnStart = true,
  crt = false,
}

-- All scenes
Scenes = {
  game = {
    draw = function() game:draw() end,
    load = function() game:load() end,
    update = function(dt) game:update(dt) end,
    },
  title = {
    draw = function() title:draw() end,
    load = function() title:load() end,
    update = function(dt) title:update(dt) end,
    },
  endofround = {
    draw = function() endofround:draw() end,
    load = function() endofround:load() end,
    update = function(dt) endofround:update(dt) end,
  },
  shop = {
    draw = function() shop:draw() end,
    load = function() shop:load() end,
    update = function(dt) shop:update(dt) end,
  },
  gun = {
    draw = function() gun:draw() end,
    load = function() gun:load() end,
    update = function(dt) gun:update(dt) end,
  },
  difficultyselection = {
    draw = function() difficultyselection:draw() end,
    load = function() difficultyselection:load() end,
    update = function(dt) difficultyselection:update(dt) end,
  },
}
Scene = "game" -- Current scene

--Global Observer
GlobalObserver = nil

-- Independant random for cosmetic purposes
cosmeticRandom = love.math.newRandomGenerator(os.time())

-- local functions

local function loadAssets()
  --images
    al:loadImages("assets/Sprites")
    al:loadAudios("assets/Audios")
  
    --perfect dos font
    perfect_dos_12 = love.graphics.newFont("assets/Fonts/perfect_dos_vga_437/Perfect DOS VGA 437 Win.ttf",12)
    perfect_dos_16 = love.graphics.newFont("assets/Fonts/perfect_dos_vga_437/Perfect DOS VGA 437 Win.ttf",16)
    perfect_dos_20 = love.graphics.newFont("assets/Fonts/perfect_dos_vga_437/Perfect DOS VGA 437 Win.ttf",28)
    perfect_dos_32 = love.graphics.newFont("assets/Fonts/perfect_dos_vga_437/Perfect DOS VGA 437 Win.ttf",32)

    --dogica font
    dogica_8 = love.graphics.newFont("Assets/Fonts/dogica/TTF/dogica.ttf",8)
    dogica_16 = love.graphics.newFont("Assets/Fonts/dogica/TTF/dogica.ttf",16)
end

-- love functions

function love.load()
  --graphics
  love.window.setVSync(false)
  love.graphics.setDefaultFilter("nearest", "nearest")
  love.mouse.setVisible(false) -- set cursor to invisible
  
  mainCanvas = love.graphics.newCanvas(Width,Height)

  --load assets
  loadAssets()
  
  --load scripts
  upgrades:load()
  artifacts:load()
  equipment:load()
  infopanel:load()
  ct:load()
  statpanel:load()
  tab:load()

  --Load classes
    Inventory = require("classes/Inventory")
    InventorySlot = require("classes/InventorySlot")
    Lookout = require("classes/Lookout")
    Report = require("classes/Report")
    ReloadShelf = require("classes/ReloadShelf")
    ReloadShelfBullet = require("classes/ReloadShelfBullet")
    EnemyHandler = require("classes/EnemyHandler")
    Player = require("classes/Player")
    Enemy = require("classes/Enemy")
    Enemies = {
        Bird = require("classes/Bird"),
        InfectedBird = require("classes/InfectedBird"),
        BigBird = require("classes/BigBird"),
    }
    Gun = require("classes/Gun")
    Guns = {
        pistol = require("classes/Pistol"),
    }
    EquipmentInventory = require("classes/EquipmentInventory")
    EquipmentSlot = require("classes/EquipmentSlot")
    ParachuteCrate = require("classes/ParachuteCrate")
  
  --get global observer
  GlobalObserver = Observer:new()
  
  --load all scenes
  for i, scene in pairs(Scenes) do
    scene:load()
  end


  --set global audio
  love.audio.setVolume(settings.volume)
end

function love.update(dt)
  --debug exit
  if qClick and settings.debug then love.event.quit() end
  
  --update scene
  Scenes[Scene].update(dt)
  
  --update scripts
  ap:update(dt)
  controls:update()
  event:update(dt)
  tween:update(dt)
  zdraw:update()
end

function love.draw()
  love.graphics.setCanvas(mainCanvas)
  love.graphics.clear()
  
  
  --scenes
  Scenes[Scene]:draw()
  

  
  love.graphics.setCanvas()
  love.graphics.setColor(1,1,1,1)
  love.graphics.draw(mainCanvas,0,0,0,Scale)
  
  
  --gui debug
  if not settings.debug then return end
  love.graphics.setColor(1,1,1,1)
  love.graphics.setFont(perfect_dos_16)
  love.graphics.print(math.floor(love.timer.getFPS()),640-32,22)
  love.graphics.print(CursorX .. ' ' .. CursorX, 640-32,33)
  love.graphics.print("round: " .. game.round, 640-32,43)
  
end


