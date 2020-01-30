local ITEM_SIZE = 32

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

local lstItems = {}

local itemIcon = {}
itemIcon.image = love.graphics.newImage("images/sprite/itemIcon"..tostring(ITEM_SIZE)..".png")
itemIcon.quad = createQuad(itemIcon.image, ITEM_SIZE, ITEM_SIZE)

function AddItem(pSprite, pItem, pQuantity)
  local item = dofile("data/items/"..pItem..".lua")
  item.quantity = pQuantity
  table.insert(pSprite.inventory, item)
end

function GetItemQuad(pId)
  return itemIcon.quad[pId]
end

function GetItemImage(pId)
  return itemIcon.image
end
