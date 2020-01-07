local lstFx = {}

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

function UpdateFx(dt)
  for i=#lstFx, 1, -1 do
    local fx = lstFx[i]
    fx.timerFrame = fx.timerFrame + dt
    if fx.timerFrame >= fx.intervalFrame then
      fx.timerFrame = 0
      fx.currentFrame = fx.currentFrame + 1
      if fx.currentFrame >= fx.maxFrame then
        fx.isRemovable = true
      end
    end

    if fx.isRemovable then
      fx.currentFrame = 1
      table.remove(lstFx, i)
    end
  end
end

function DrawFx()
  for i=#lstFx, 1, -1 do
    local camX,camY = GetCamera("xy")
    local fx = lstFx[i]
    local quad = fx.quad[fx.currentFrame]
    love.graphics.draw(fx.image, quad.data, fx.target.x + camX, fx.target.y + camY, 0, 1, 1, quad.originX, quad.originY)
  end
end

function CreateFx(pId, pWidth, pHeight, pMaxFrame, pInterval)
  local fx = {}
  fx.image = love.graphics.newImage("images/fx/"..tostring(pId)..".png")
  fx.quad = createQuad(fx.image, pWidth, pHeight)

  fx.target = nil

  fx.currentFrame = 1
  fx.maxFrame = pMaxFrame
  fx.timerFrame = 0
  fx.intervalFrame = pInterval or 0.12

  fx.isRemovable = false

  return fx
end

function PlayFx(pFx, pTarget)
  pFx.target = pTarget
  pFx.isRemovable = false
  table.insert(lstFx, pFx)
end
