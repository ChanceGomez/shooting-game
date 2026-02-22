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
Observer = require("scripts/observer")
popup = require("scripts/popup")
ap = require("scripts/animationplayer")
upgrades = require("scripts/upgrades")
roundscript = require("scripts/roundscript")
artifacts = require("scripts/artifacts")


--Scenes  
  game = require("Scenes/game")
  title = require("Scenes/title")
  endofround = require("Scenes/endofround")
  shop = require("Scenes/shop")
  
--Global vars
Width,Height = 640,360
Scale = 3
mainCanvas = nil
GameSpeed = 1

settings = {
  volume = .5,
  hitbox = true,
  }

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
}
Scene = "title"
independentRandom = love.math.newRandomGenerator(os.time())

--Functions

local function loadAssets()

  --images
    al:loadImages("assets/Sprites")
  
    --perfect dos font
    perfect_dos_12 = love.graphics.newFont("assets/Fonts/perfect_dos_vga_437/Perfect DOS VGA 437 Win.ttf",12)
    perfect_dos_16 = love.graphics.newFont("assets/Fonts/perfect_dos_vga_437/Perfect DOS VGA 437 Win.ttf",16)
    perfect_dos_32 = love.graphics.newFont("assets/Fonts/perfect_dos_vga_437/Perfect DOS VGA 437 Win.ttf",32)
end

function love.load()
  --graphics
  love.window.setVSync(false)
  love.graphics.setDefaultFilter("nearest", "nearest")
  
  love.mouse.setVisible(false)
  
  mainCanvas = love.graphics.newCanvas(Width,Height)

  --load assets
  loadAssets()
  
  --scripts 
  infopanel:load()

  --Load classes
    Lookout = require("classes/Lookout")
    Report = require("classes/Report")
    ReloadShelf = require("classes/ReloadShelf")
    ReloadShelfBullet = require("classes/ReloadShelfBullet")
    EnemyHandler = require("classes/EnemyHandler")
    Player = require("classes/Player")
    Enemy = require("classes/Enemy")
    Enemies = {
        Bird = require("classes/Bird"),
    }
    Gun = require("classes/Gun")
    Guns = {
        pistol = require("classes/Pistol"),
    }
  
  
  --load all scenes
  for i, scene in pairs(Scenes) do
    scene:load()
  end
  
  --load scripts
  upgrades:load()
  artifacts:load()

  --set global audio
  love.audio.setVolume(settings.volume)
end

function love.update(dt)
  --debug exit
  if qClick then love.event.quit() end
  
  

  
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
  love.graphics.setColor(1,1,1,1)
  love.graphics.print(math.floor(love.timer.getFPS()),640-32,10)
  
end


