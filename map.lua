local map = {}
local tilesheet = {}

local TILE_SIZE = 16
local MAX_MONSTER = 7
local COLLIDE_TILE = 1327

local collide_layer = {}

local timerSpawnMonster = 0
local intervalSpawnMonster = math.random(3, 4)

local function createQuad(pImage, pWidth, pHeight)
  local quads = {}
  local iWidth, iHeight = pImage:getWidth(), pImage:getHeight()
  local nbX, nbY = math.floor(iWidth/pWidth), math.floor(iHeight/pHeight)
  local id = 1
  for i=1, nbY do
    for j=1, nbX do
      local quad = love.graphics.newQuad((j-1)*pWidth, (i-1)*pHeight, pWidth, pHeight, iWidth, iHeight)
      quads[id] = {}
      quads[id].data = quad
      quads[id].width = pWidth
      quads[id].height = pHeight
      quads[id].originX = pWidth/2
      quads[id].originY = pHeight/2
      id = id + 1
    end
  end
  return quads
end

function LoadMap(pMap)
  map = require("maps/"..pMap)
  tilesheet.image = love.graphics.newImage(map.tilesets[1].image)
  tilesheet.quad = createQuad(tilesheet.image, TILE_SIZE, TILE_SIZE)
  for k,layer in pairs(map.layers) do
    if layer.name == "collide_layer" then
      collide_layer = layer
    end
  end
end

function UpdateMap(dt)
  if #GetEnemiesList() < MAX_MONSTER then
    timerSpawnMonster = timerSpawnMonster + dt
    if timerSpawnMonster >= intervalSpawnMonster then
      timerSpawnMonster = 0
      intervalSpawnMonster = math.random(7, 12)
        SpawnMonster()
    end
  end
end

function DrawMap()
  local camX,camY = GetCamera("xy")
  for k,layer in pairs(map.layers) do
    if string.find(layer.name, "ground") then
      for i=1,layer.height do
        for j=1,layer.width do
          local id = layer.data[layer.width * (i-1) + (j-1) + 1]
          if id ~= 0 then
            love.graphics.draw(tilesheet.image, tilesheet.quad[id].data, (j-1)*TILE_SIZE + camX, (i-1)*TILE_SIZE + camY)
          end
        end
      end
    end
  end
end

function DrawUpperMap()
  local camX,camY = GetCamera("xy")
  for k,layer in pairs(map.layers) do
    if string.find(layer.name, "upper") then
      for i=1,layer.height do
        for j=1,layer.width do
          local id = layer.data[layer.width * (i-1) + (j-1) + 1]
          if id ~= 0 then
            love.graphics.draw(tilesheet.image, tilesheet.quad[id].data, (j-1)*TILE_SIZE + camX, (i-1)*TILE_SIZE + camY)
          end
        end
      end
    end
  end
end

function GetTileSize()
  return TILE_SIZE
end

function GetTileAt(pX, pY)
  local layer = collide_layer
  local c,l = math.floor(pX/TILE_SIZE), math.floor(pY/TILE_SIZE)
  return layer.data[layer.width * l + c + 1]
end

function IsSolideZone(pX, pY, pW, pH)
  for k,layer in pairs(map.layers) do
    if layer.name == "collide_layer" then
      return GetTileAt(pX-pW, pY) == COLLIDE_TILE or
             GetTileAt(pX-pW, pY+pH) == COLLIDE_TILE or
             GetTileAt(pX+pW, pY+pH) == COLLIDE_TILE or
             GetTileAt(pX+pW, pY) == COLLIDE_TILE
    end
  end
end

function GetEmptyPosition()
  local l,c = 0,0
  repeat
    l = math.random(5, map.height-5)
    c = math.random(5, map.width-5)
  until GetTileAt(c*GetTileSize(), l*GetTileSize()) == 0
  return c*GetTileSize(), l*GetTileSize()
end

function SpawnMonster()
  local x,y = GetEmptyPosition()
  CreateEnemy(x, y, "Witch_Sprite_Sheet")
end
