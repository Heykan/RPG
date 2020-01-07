local screenWidth, screenHeight = love.graphics.getDimensions()

local camera = {}
camera.x = 0
camera.y = 0
camera.scale = 2

local MAX_SCALE = 4
local MIN_SCALE = 2

local nextScale = 2

local isSmooth = true

function GetCamera(pData)
  if pData == "x" then
    return camera.x
  elseif pData == "y" then
    return camera.y
  elseif pData == "xy" then
    return camera.x, camera.y
  elseif pData == "scale" then
    return camera.scale
  end
end

function SetCamera(pData, pValue)
  if pData == "x" then
    camera.x = pValue
  elseif pData == "y" then
    camera.y = pValue
  elseif pData == "scale" then
    camera.scale = pValue
  end
end

function UpdateCamera(dt)
  if nextScale < MIN_SCALE then
    nextScale = MIN_SCALE
  end
  if nextScale > MAX_SCALE then
    nextScale = MAX_SCALE
  end

  if camera.scale < nextScale then
    camera.scale = camera.scale + 1*10*dt
    if camera.scale > nextScale then
      camera.scale = nextScale
    end
  end
  if camera.scale > nextScale then
    camera.scale = camera.scale - 1*10*dt
    if camera.scale < nextScale then
      camera.scale = nextScale
    end
  end

  isSmooth = camera.scale == nextScale

  local player = nil
  if #GetPlayerList() > 0 then
    player = GetPlayer(1)
  end

  if player then
    local difX = (screenWidth/(2*camera.scale)) - (player.x+camera.x)
    local difY = (screenHeight/(2*camera.scale)) - (player.y+camera.y)

    if isSmooth then
      if math.abs(difX) > 2 then
        camera.x = camera.x + (difX/20)*60*dt
      end

      if math.abs(difY) > 2 then
        camera.y = camera.y + (difY/20)*60*dt
      end

      if love.mouse.isDown(4) then
        print("wheel up")
      end
    else
      camera.x = camera.x + difX
      camera.y = camera.y + difY
    end
  end
end

function love.wheelmoved(x, y)
  if GetPlayState() == "gameplay" then
    if y > 0 then
        nextScale = nextScale + 0.5
    elseif y < 0 then
        nextScale = nextScale - 0.5
    end
  end
end
