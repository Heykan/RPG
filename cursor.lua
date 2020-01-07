local spriteHover = {}

local function getCursor(pFilename, pHotX, pHotY)
  local hotx = pHotX or 0
  local hoty = pHotY or 0
  return love.mouse.newCursor("images/ui/cursor_"..pFilename..".png", hotx, hoty)
end

local cursors = {}
cursors["ally"] = getCursor("ally")
cursors["enemy"] = getCursor("enemy")
cursors["hand"] = getCursor("hand")
cursors["hand2"] = getCursor("hand2")
cursors["normal"] = getCursor("normal")
cursors["shop"] = getCursor("shop")
cursors["ui"] = getCursor("ui")

function GetCursor(pName)
  return cursors[pName]
end

function GetCurrentCursor()
  return love.mouse.getCursor()
end

function SetCursor(pName, pSprite)
  if pSprite then
    table.insert(spriteHover, pSprite)
  end
  love.mouse.setCursor(GetCursor(pName))
end

function GetCursorPosition()
  local scale = GetCamera("scale")
  local mx,my = love.mouse.getX()/scale, love.mouse.getY()/scale
  return mx,my
end
