--[[
  Programmer: Chance Gomez | chance.f.gomez@gmail.com
  File: main.lua | Project: shooting game
]]
  
  
 
--Scripts
al = require("Scripts/assetloader")
drag = require("Scripts/drag")
collision = require("Scripts/collision")
controls = require("Scripts/controls")
tween = require("Scripts/tween")
array = require("Scripts/array")
button = require("Scripts/buttons")
zdraw = require("Scripts/zdraw")
event = require("Scripts/events")
infopanel = require("Scripts/infopanel")
popup = require("Scripts/popup")
ap = require("Scripts/animationplayer")
roundscript = require("Scripts/roundscript")
upgrades = require("Scripts/upgrades")
artifacts = require("Scripts/artifacts")
equipment = require("Scripts/equipment")
ct = require("Scripts/customtext")
statpanel = require("Scripts/statpanel")
tab = require("Scripts/tab")

--Preloaded classes
Observer = require("Classes/Observer")
Affector = require("Classes/Affector")
Event = require("Classes/Event")
Button = require("Classes/Button")

--Scenes  
  game = require("Scenes/game")
  title = require("Scenes/title")
  endofround = require("Scenes/endofround")
  shop = require("Scenes/shop")
  gun = require("Scenes/gun")
  difficultyselection = require("Scenes/difficultyselection")
  splashscreen = require("Scenes/splashscreen")
  map = require("Scenes/map")
  testscene = require("Scenes/testscene")

--Global vars
Width,Height = 640,360
Scale = 3
mainCanvas = nil
GameSpeed = 1

--Game setting
settings = {
  volume = .6, -- Global volume
  hitbox = false, -- Display hitboxes on enemies
  showHealth = false,
  showAlive = false,
  debug = true,
  difficulty = 'easy',
  loadShopOnStart = false,
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
  splashscreen = {
    draw = function() splashscreen:draw() end,
    load = function() splashscreen:load() end,
    update = function(dt) splashscreen:update(dt) end,
  },
  map = {
    draw = function() map:draw() end,
    load = function() map:load() end,
    update = function(dt) map:update(dt) end,
  },
  testscene = {
    draw = function() testscene:draw() end,
    load = function() testscene:load() end,
    update = function(dt) testscene:update(dt) end,
  },
}
Scene = "shop" -- Current scene

--Global Observer
GlobalObserver = nil

-- Independant random for cosmetic purposes
cosmeticRandom = love.math.newRandomGenerator(os.time())

-- local functions

local function loadAssets()
  --images
    al:loadImages("Assets/Sprites")
    al:loadAudios("Assets/Audios")
  
    --perfect dos font
    perfect_dos_12 = love.graphics.newFont("Assets/Fonts/perfect_dos_vga_437/Perfect DOS VGA 437 Win.ttf",12)
    perfect_dos_16 = love.graphics.newFont("Assets/Fonts/perfect_dos_vga_437/Perfect DOS VGA 437 Win.ttf",16)
    perfect_dos_20 = love.graphics.newFont("Assets/Fonts/perfect_dos_vga_437/Perfect DOS VGA 437 Win.ttf",28)
    perfect_dos_32 = love.graphics.newFont("Assets/Fonts/perfect_dos_vga_437/Perfect DOS VGA 437 Win.ttf",32)

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
    Inventory = require("Classes/Inventory")
    InventorySlot = require("Classes/InventorySlot")
    Lookout = require("Classes/Lookout")
    Report = require("Classes/Report")
    BackgroundHandler = require("Classes/BackgroundHandler")
    ReloadShelf = require("Classes/ReloadShelf")
    ReloadShelfBullet = require("Classes/ReloadShelfBullet")
    ReloadShelfDudBullet = require("Classes/ReloadShelfDudBullet")
    EnemyHandler = require("Classes/EnemyHandler")
    Player = require("Classes/Player")
    Enemy = require("Classes/Enemy")
    Enemies = {
        Bird = require("Classes/Bird"),
        InfectedBird = require("Classes/InfectedBird"),
        BigBird = require("Classes/BigBird"),
        BigInfectedBird = require("Classes/BigInfectedBird"),
    }
    Gun = require("Classes/Gun")
    Guns = {
        pistol = require("Classes/Cannon"),
    }
    EquipmentInventory = require("Classes/EquipmentInventory")
    EquipmentSlot = require("Classes/EquipmentSlot")
    ParachuteCrate = require("Classes/ParachuteCrate")
    Lazor = require("Classes/Lazor")
    Map = require("Classes/MapNode/Map")
    Node = require("Classes/MapNode/Node")
    DamagePopup = require("Classes/DamagePopup")

  
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


