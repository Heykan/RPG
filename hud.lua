local screenWidth, screenHeight = GetScreenDimensions()
local leftMouseReleased = false
local player = nil

-- Player ui
local character_ui = {
  image = love.graphics.newImage("images/ui/character_ui.png"),
  x = 5,
  y = 5
}
character_ui.w = character_ui.image:getWidth()
character_ui.h = character_ui.image:getHeight()

local health_bar = {
  image = love.graphics.newImage("images/ui/health_bar.png"),
  x = character_ui.x + 84,
  y = character_ui.y + 6
}
health_bar.w = health_bar.image:getWidth()
health_bar.h = health_bar.image:getHeight()

local mana_bar = {
  image = love.graphics.newImage("images/ui/mana_bar.png"),
  x = health_bar.x,
  y = health_bar.y + 20
}
mana_bar.w = mana_bar.image:getWidth()
mana_bar.h = mana_bar.image:getHeight()

local experience_bar = {
  image = love.graphics.newImage("images/ui/experience_bar.png"),
  x = health_bar.x,
  y = mana_bar.y + 20
}
experience_bar.w = experience_bar.image:getWidth()
experience_bar.h = experience_bar.image:getHeight()
--------

-- Target Ui
local target_ui = {
  image = love.graphics.newImage("images/ui/target_ui.png"),
  x = character_ui.x + character_ui.w + 5,
  y = 5
}
target_ui.w = target_ui.image:getWidth()
target_ui.h = target_ui.image:getHeight()

local target_health_bar = {
  image = love.graphics.newImage("images/ui/target_health_bar.png"),
  x = target_ui.x + 73,
  y = target_ui.y + 15
}
target_health_bar.w = target_health_bar.image:getWidth()
target_health_bar.h = target_health_bar.image:getHeight()

local target_mana_bar = {
  image = love.graphics.newImage("images/ui/target_mana_bar.png"),
  x = target_health_bar.x,
  y = target_health_bar.y + 20
}
target_mana_bar.w = target_mana_bar.image:getWidth()
target_mana_bar.h = target_mana_bar.image:getHeight()

-- Drop ui
local drop_ui = {
  image = love.graphics.newImage("images/ui/drop_ui.png")
}
drop_ui.x = screenWidth - drop_ui.image:getWidth()*2.5
drop_ui.y = screenHeight/2 - drop_ui.image:getHeight()/2
drop_ui.w = drop_ui.image:getWidth()
drop_ui.h = drop_ui.image:getHeight()

local round_button = {
  image = love.graphics.newImage("images/ui/round_button.png"),
  x = drop_ui.x + 128,
  y = drop_ui.y
}
round_button.w = round_button.image:getWidth()
round_button.h = round_button.image:getHeight()

local round_button_hover = {
  image = love.graphics.newImage("images/ui/round_button_hover.png"),
  x = drop_ui.x + 128,
  y = drop_ui.y
}
round_button_hover.w = round_button_hover.image:getWidth()
round_button_hover.h = round_button_hover.image:getHeight()

local round_button_clicked = {
  image = love.graphics.newImage("images/ui/round_button_clicked.png"),
  x = drop_ui.x + 128,
  y = drop_ui.y
}
round_button_clicked.w = round_button_clicked.image:getWidth()
round_button_clicked.h = round_button_clicked.image:getHeight()

-- Inventory
local inventory_ui = {
  image = love.graphics.newImage("images/ui/inventory_ui.png")
}
inventory_ui.x = screenWidth/2 - inventory_ui.image:getWidth()/2
inventory_ui.y = screenHeight/2 - inventory_ui.image:getHeight()/2
inventory_ui.w = inventory_ui.image:getWidth()
inventory_ui.h = inventory_ui.image:getHeight()

local small_round_button = {
  image = love.graphics.newImage("images/ui/small_round_button.png"),
  x = inventory_ui.x + 467,
  y = inventory_ui.y + 5
}
small_round_button.w = small_round_button.image:getWidth()
small_round_button.h = small_round_button.image:getHeight()

local small_round_button_hover = {
  image = love.graphics.newImage("images/ui/small_round_button_hover.png"),
  x = small_round_button.x,
  y = small_round_button.y
}
small_round_button_hover.w = small_round_button_hover.image:getWidth()
small_round_button_hover.h = small_round_button_hover.image:getHeight()

local small_round_button_clicked = {
  image = love.graphics.newImage("images/ui/small_round_button_clicked.png"),
  x = small_round_button.x,
  y = small_round_button.y
}
small_round_button_clicked.w = small_round_button_clicked.image:getWidth()
small_round_button_clicked.h = small_round_button_clicked.image:getHeight()
--------

--- Boolean
local showItemDrop = false
local showInventory = false
-------

function UpdateHUD(dt)

end

function DrawHUD()
  love.graphics.setFont(GetFont("number_shadow"))
  local scale = GetCamera("scale")
  if #GetPlayerList() > 1 and GetPlayer(1).isControllable then
    player = GetPlayer(1)
  end

  local health_percent = player.life/player.maxLife*100
  local mana_percent = player.mana/player.maxMana*100
  local experience_percent = player.experience/player.maxExperience*100

  local health_width = health_bar.w * health_percent / 100
  local mana_width = mana_bar.w * mana_percent / 100
  local experience_width = experience_bar.w * experience_percent / 100

  local health_quad = love.graphics.newQuad(0, 0, health_width, health_bar.h, health_bar.w, health_bar.h)
  local mana_quad = love.graphics.newQuad(0, 0, mana_width, mana_bar.h, mana_bar.w, mana_bar.h)
  local experience_quad = love.graphics.newQuad(0, 0, experience_width, experience_bar.h, experience_bar.w, experience_bar.h)

  love.graphics.push()
  love.graphics.scale(1.4, 1.4)
  -- HUD selected sprite
  if GetSelectedSprite() ~= nil and GetSelectedSprite().isSelected then
    local target = GetSelectedSprite()
    local target_health_percent = target.life/target.maxLife*100
    local target_mana_percent = target.mana/target.maxMana*100

    local target_health_width = target_health_bar.w * target_health_percent / 100
    local target_mana_width = target_mana_bar.w * target_mana_percent / 100

    local target_health_quad = love.graphics.newQuad(0, 0, target_health_width, target_health_bar.h, target_health_bar.w, target_health_bar.h)
    local target_mana_quad = love.graphics.newQuad(0, 0, target_mana_width, target_mana_bar.h, target_mana_bar.w, target_mana_bar.h)

    love.graphics.draw(target_ui.image, target_ui.x, target_ui.y)
    love.graphics.draw(target.icon, target_ui.x+12, target_ui.y+16)
    love.graphics.printf(tostring(target.level), target_ui.x+32, target_ui.y+64, 30, "center")
    love.graphics.draw(target_health_bar.image, target_health_quad, target_health_bar.x, target_health_bar.y)
    love.graphics.draw(target_mana_bar.image, target_mana_quad, target_mana_bar.x, target_mana_bar.y)
  end

  -- Character HUD
  love.graphics.draw(character_ui.image, character_ui.x, character_ui.y)
  love.graphics.draw(player.icon, character_ui.x+12, character_ui.y+16)
  love.graphics.printf(tostring(player.level), character_ui.x+32, character_ui.y+64, 30, "center")

  love.graphics.draw(health_bar.image, health_quad, health_bar.x, health_bar.y)
  love.graphics.draw(mana_bar.image, mana_quad, mana_bar.x, mana_bar.y)
  love.graphics.draw(experience_bar.image, experience_quad, experience_bar.x, experience_bar.y)

  love.graphics.printf(tostring(math.floor(player.life)).."/"..tostring(math.floor(player.maxLife)), health_bar.x+health_bar.w/2-64, health_bar.y+2, 170, "center", 0, 0.8, 0.8)
  love.graphics.printf(tostring(math.floor(player.mana)).."/"..tostring(math.floor(player.maxMana)), mana_bar.x+mana_bar.w/2-64, mana_bar.y+2, 170, "center", 0, 0.8, 0.8)
  love.graphics.printf(tostring(math.floor(player.experience)).."/"..tostring(math.floor(player.maxExperience)), experience_bar.x+experience_bar.w/2-64, experience_bar.y+2, 170, "center", 0, 0.8, 0.8)
  love.graphics.pop()

  -- Drop Item
  if showItemDrop then
    DrawItemDrop()
  end

  -- Show inventory
  if showInventory then
    DrawInventory()
  end
  love.graphics.setFont(GetFont("normal"))
end

function DrawItemDrop()
  love.graphics.push()
  love.graphics.draw(drop_ui.image, drop_ui.x, drop_ui.y)
  love.graphics.setFont(GetFont("shadow"))
  love.graphics.printf("item drop", drop_ui.x + drop_ui.w/2 - 125/2, drop_ui.y + 25, 125, "center")
  love.graphics.setFont(GetFont("number_shadow"))

  -- Check mouse click on button
  local mx,my = love.mouse.getPosition()
  local hover, down = false, false
  if mx >= round_button.x + 20 and mx <= round_button.x + round_button.w
     and my >= round_button.y + 8 and my <= round_button.y + round_button.h then
       hover = true
       SetCursor("hand")
       if love.mouse.isDown(1) then
         down = true
         love.graphics.draw(round_button_clicked.image, round_button_clicked.x, round_button_clicked.y)
       else
         love.graphics.draw(round_button_hover.image, round_button_hover.x, round_button_hover.y)
       end
  else
    love.graphics.draw(round_button.image, round_button.x, round_button.y)
    SetCursor("normal")
  end
  if down and hover then
    leftMouseReleased = true
  end
  if leftMouseReleased and not hover then
    leftMouseReleased = false
  end
  if leftMouseReleased and hover and not love.mouse.isDown(1) then
    leftMouseReleased = false
    CloseItemDrop()
  end
  love.graphics.pop()
end

function DrawInventory()
love.graphics.push()

  -- Check mouse click on button
  local mx,my = love.mouse.getPosition()
  if mx >= inventory_ui.x and
     my >= inventory_ui.y and
     mx <= inventory_ui.x + inventory_ui.w and
     my <= inventory_ui.y + inventory_ui.h then
    SetCursor("hand")
  else
    SetCursor("normal")
  end

  local hover, down = false, false
  if mx >= small_round_button.x and mx <= small_round_button.x + small_round_button.w
     and my >= small_round_button.y and my <= small_round_button.y + small_round_button.h then
       hover = true
       if love.mouse.isDown(1) then
         down = true
         love.graphics.draw(small_round_button_clicked.image, small_round_button_clicked.x, small_round_button_clicked.y)
       else
         love.graphics.draw(small_round_button_hover.image, small_round_button_hover.x, small_round_button_hover.y)
       end
  else
    love.graphics.draw(small_round_button.image, small_round_button.x, small_round_button.y)
  end

  love.graphics.draw(inventory_ui.image, inventory_ui.x, inventory_ui.y)
  love.graphics.setFont(GetFont("shadow"))
  love.graphics.printf("inventory", inventory_ui.x + inventory_ui.w/2 - 125/2, inventory_ui.y + 8, 125, "center")
  love.graphics.printf(tostring(GetPlayer(1).gold), inventory_ui.x + 28, inventory_ui.y + 354, 250, "left")

  if down and hover then
    leftMouseReleased = true
  end
  if leftMouseReleased and not hover then
    leftMouseReleased = false
  end
  if leftMouseReleased and hover and not love.mouse.isDown(1) then
    leftMouseReleased = false
    CloseInventory()
  end
  love.graphics.pop()
end

-- Drop
function ShowItemDrop(pSprite, pId)
  showItemDrop = true
end

function CloseItemDrop()
  showItemDrop = false
end

-- Inventory
function ShowInventory(pSprite, pId)
  showInventory = true
end

function CloseInventory()
  showInventory = false
end

function GetHUDState(pData)
  if pData == "item_drop" then
    return showItemDrop
  elseif pData == "inventory" then
    return showInventory
  end
end
