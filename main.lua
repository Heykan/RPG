math.randomseed(os.time())

local screenWidth, screenHeight = love.graphics.getDimensions()

-- Default math function
function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end
function math.round(value, nbDecimal)
  local mult = 10^(nbDecimal or 1)
  return math.floor(value * mult + 0.5) / mult
end

function table.contains(pTable, pValue)
  for k,v in pairs(pTable) do
    if v == pValue then
      return true
    end
  end
  return false
end

function GetScreenDimensions()
  return screenWidth, screenHeight
end

-- Default filter
love.graphics.setDefaultFilter("nearest")

-- Main start
json = require "library/json"
require "cursor"
require "sprite"
require "player"
require "enemy"
require "camera"
require "spell"
require "fx"
require "audio"
require "map"
require "hud"

local playState = "gameplay"

-- font
local font_normal = love.graphics.getFont()
local font_shadow = love.graphics.newImageFont("images/font/font_shadow.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,§?-+/():;%&`'*#=[]")
local font_number_shadow = love.graphics.newImageFont("images/font/font_number.png", "/0234567891+-")


function LoadGameplay()
  LoadMap("debug_map")

  local player = CreatePlayer(6*32, 5*32,"Witch_Sprite_Sheet", true)
  to2 = CreatePlayer(8*32, 5*32,"Witch_Sprite_Sheet", false)
  UpLevel(player, 50)
  UpLevel(to2, 50)
  -- Movement
  player.key["left"] = {"q", "left"}
  player.key["down"] = {"s", "down"}
  player.key["right"] = {"d", "right"}
  player.key["up"] = {"z", "up"}
  -- Other
  player.key["inventory"] = {"i", ""}
  -- Spell
  player.key["spell1"] = "1"
  player.key["spell2"] = "2"
  player.key["spell3"] = "3"
  player.key["spell4"] = "4"
  player.key["spell5"] = "5"
  player.key["spell6"] = "6"
  player.key["object"] = "a"

  SpawnMonster()
  SpawnMonster()
  --SpawnMonster()
  --SpawnMonster()

  SetCamera("scale", 2)

  PlayBGM("epic_loop", 0.3)
end

function love.load(args)
  SetCursor("normal")
  LoadGameplay()
end

function love.update(dt)
  if playState == "gameplay" then
    --UpdateMap(dt)
    UpdateSprite(dt)
    UpdatePlayer(dt)
    UpdateEnemy(dt)
    UpdateFx(dt)
    UpdateHUD(dt)
    UpdateCamera(dt)
  end
end

function love.draw()
  if playState == "gameplay" then
    local scale = GetCamera("scale")
    love.graphics.push()
    love.graphics.scale(scale,scale)
    DrawMap()
    DrawSprite()
    DrawFx()
    DrawDamage()
    love.graphics.pop()
    love.graphics.push()
    DrawHUD()
    love.graphics.pop()
  end
end

function GetPlayState()
  return playState
end

function SetPlayState(pValue)
  playState = pValue
end

function GetFont(pFontName)
  if pFontName == "shadow" then
    return font_shadow
  elseif pFontName == "normal" then
    return font_normal
  elseif pFontName == "number_shadow" then
    return font_number_shadow
  end
end
