local function order(pA, pB)
  return pA.order > pB.order
end

local lstUi = {}

function CreateElement(pType, pX, pY, pScale, pOrder, ...)
  local argCount = tableLength(arg)
  local ui = {
    x = pX,
    y = pY,
    type = pType,
    scale = pScale
    order = pOrder or 1
  }
  if pType == "label" then
    ui.text = arg[1]
  else
    ui.image = love.graphics.newImage("images/ui/"..arg[1]..".png")
  end

  table.insert(lstUi, ui)
  table.sort(lstUi, order)
  return ui
end

function DrawUI()
  for k,ui in pairs(lstUi) do
    if ui.type == "button" then
      love.graphics.draw(ui.image, ui.x, ui.y, 0, ui.scale, ui.scale)
    elseif ui.type == "panel" then
      love.graphics.draw(ui.image, ui.x, ui.y, 0, ui.scale, ui.scale)
    elseif ui.type == "label" then
      love.graphics.print(ui.text, ui.x, ui.y)
    end
  end
end
