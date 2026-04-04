--[[
  Programmer: Chance Gomez | chance.f.gomez@gmail.com
  File: main.lua | Project: shooting game
]]
  
  
 
--Scripts
  event = require("Scripts/events")
  popup = require("Scripts/popup")
  artifacts = require("Scripts/artifacts")
  equipment = require("Scripts/equipment")
  tab = require("Scripts/tab")

--Libraries
  Observer = require("Libraries/Observer")
  Affector = require("Libraries/Affector")
  Event = require("Libraries/Event")
  Button = require("Libraries/Button")
  customtext = require("Libraries/customtext")
  assetloader = require("Libraries/assetloader")
  collision = require("Libraries/collision")
  controls = require("Libraries/controls")
  tween = require("Libraries/tween")
  array = require("Libraries/array")
  animationplayer = require("Libraries/animationplayer")
  Inventory = require("Libraries/Inventory")
  InventorySlot = require("Libraries/InventorySlot")
  EquipmentInventory = require("Libraries/EquipmentInventory")
  EquipmentSlot = require("Libraries/EquipmentSlot")
  DamagePopup = require("Libraries/DamagePopup")
  infopanel = require("Libraries/infopanel")



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
  info = require("Scenes/info")
  losescreen = require("Scenes/losescreen")
  buyequipment = require("Scenes/buyequipment")
  upgradebullet = require("Scenes/upgradebullet")
  upgradedud = require("Scenes/upgradedud")

--Global vars
Width,Height = 640,360
Scale = 3
mainCanvas = nil
settings = {
  volume = .6, -- Global volume
  hitbox = false, -- Display hitboxes on enemies
  showHealth = false,
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
  info = {
    draw = function() info:draw() end,
    load = function() info:load() end,
    update = function(dt) info:update(dt) end,
  },
  losescreen = {
    draw = function() losescreen:draw() end,
    load = function() losescreen:load() end,
    update = function(dt) losescreen:update(dt) end,
  },
}
Scene = "shop" -- Current scene

-- Independant random for cosmetic purposes
cosmeticRandom = love.math.newRandomGenerator(os.time())

-- local functions

local function loadAssets()
  --images
    assetloader:loadImages("Assets/Sprites")
    assetloader:loadAudios("Assets/Audios")
  
    --perfect dos font
    perfect_dos_12 = love.graphics.newFont("Assets/Fonts/perfect_dos_vga_437/Perfect DOS VGA 437 Win.ttf",12)
    perfect_dos_16 = love.graphics.newFont("Assets/Fonts/perfect_dos_vga_437/Perfect DOS VGA 437 Win.ttf",16)
    perfect_dos_20 = love.graphics.newFont("Assets/Fonts/perfect_dos_vga_437/Perfect DOS VGA 437 Win.ttf",28)
    perfect_dos_32 = love.graphics.newFont("Assets/Fonts/perfect_dos_vga_437/Perfect DOS VGA 437 Win.ttf",32)

    --dogica font
    dogica_8 = love.graphics.newFont("Assets/Fonts/dogica/TTF/dogica.ttf",8)
    dogica_16 = love.graphics.newFont("Assets/Fonts/dogica/TTF/dogica.ttf",16)
    dogica_32 = love.graphics.newFont("Assets/Fonts/dogica/TTF/dogica.ttf",32)
    dogica_64 = love.graphics.newFont("Assets/Fonts/dogica/TTF/dogica.ttf",64)
end

local function loadClasses()
    Lookout = require("Classes/Lookout")
    Report = require("Classes/Report")
    BackgroundHandler = require("Classes/BackgroundHandler")
    ReloadShelf = require("Classes/ReloadShelf")
    ReloadShelfBullet = require("Classes/ReloadShelfBullet")
    ReloadShelfDudBullet = require("Classes/ReloadShelfDudBullet")
    EnemyHandler = require("Classes/EnemyHandler")
    Player = require("Classes/Player")
    Enemy = require("Classes/Entities/Enemy")
    ParachuteCrate = require("Classes/Entities/ParachuteCrate")
    Enemies = {
        Bird = require("Classes/Entities/Bird"),
        InfectedBird = require("Classes/Entities/InfectedBird"),
        BigBird = require("Classes/Entities/BigBird"),
        BigInfectedBird = require("Classes/Entities/BigInfectedBird"),
        FastBird = require("Classes/Entities/FastBird"),
        ExplosionBird = require("Classes/Entities/ExplosionBird"),
        Nest = require("Classes/Entities/Nest"),
        NestArm = require("Classes/Entities/NestArm"),
        NestBody = require("Classes/Entities/NestBody")
    }
    Gun = require("Classes/Gun")
    Guns = {
        pistol = require("Classes/Cannon"),
    }
  
    Lazor = require("Classes/Lazor")
    Map = require("Classes/MapNode/Map")
    Node = require("Classes/MapNode/Node")
    Explosion = require("Classes/Explosion")
end

-- love functions

function love.load()
    --graphics
    love.window.setVSync(false)
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.mouse.setVisible(false) -- set cursor to invisible

    --Get main canvas
    mainCanvas = love.graphics.newCanvas(Width,Height)

    --load assets
    loadAssets()

    --load scripts
    artifacts:load()
    equipment:load()
    infopanel:load()
    customtext:load()
    tab:load()

    --Load classes
    loadClasses()

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
	animationplayer:update(dt)
	controls:update()
	event:update(dt)
	tween:update(dt)
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
	love.graphics.print(math.floor(love.timer.getFPS()),4,24)
	love.graphics.print(CursorX .. ' ' .. CursorY, 4,4)
end


