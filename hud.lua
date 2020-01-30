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

-- Spell
local spell_ui = {
  image = love.graphics.newImage("images/ui/spell_ui.png")
}
spell_ui.scale = 1.5
spell_ui.x = screenWidth/2 - (spell_ui.image:getWidth()*1.5)/2
spell_ui.y = screenHeight - (spell_ui.image:getHeight()*1.5)-20

local spell_round_key = {
  image = love.graphics.newImage("images/ui/spell_round_key.png"),
  x = spell_ui.x,
  y = spell_ui.y
}

local empty_panel_ui = {
  image = love.graphics.newImage("images/ui/empty_panel_ui.png"),
  x = -1,
  y = -1
}
empty_panel_ui.w = empty_panel_ui.image:getWidth()
empty_panel_ui.h = empty_panel_ui.image:getHeight()

local spells = {}

--- Boolean
local showItemDrop = false
local showInventory = false
local showSpellInfoBulle = false
local alreadyOnSpell = false
local mouseDownOnDrop = false
-------

--- number
local spellInfo = -1

--- timer
local timerInfoBulle = 0
local intervalInfoBulle = 0.5

function CreateSpell(pPlayer)
  spells = {}
  if pPlayer.spells[1] then
    spells[1] = {
      image = love.graphics.newImage("images/spells/"..pPlayer.spells[1].image..".png"),
      border = love.graphics.newImage("images/spells/"..pPlayer.spells[1].border..".png"),
      scale = 0.19
    }
    spells[1].w = spells[1].image:getWidth()
    spells[1].h = spells[1].image:getHeight()
    spells[1].x = (spell_ui.x + 7)
    spells[1].y = (spell_ui.y + 6)
  end
  if pPlayer.spells[2] then
    spells[2] = {
      image = love.graphics.newImage("images/spells/"..pPlayer.spells[2].image..".png"),
      border = love.graphics.newImage("images/spells/"..pPlayer.spells[2].border..".png"),
      scale = 0.19
    }
    spells[2].w = spells[2].image:getWidth()
    spells[2].h = spells[2].image:getHeight()
    spells[2].x = (spell_ui.x + 40*spell_ui.scale)
    spells[2].y = (spell_ui.y + 6)
  end
  if pPlayer.spells[3] then
      spells[3] = {
        image = love.graphics.newImage("images/spells/"..pPlayer.spells[3].image..".png"),
        border = love.graphics.newImage("images/spells/"..pPlayer.spells[3].border..".png"),
        scale = 0.19
      }
      spells[3].w = spells[3].image:getWidth()
      spells[3].h = spells[3].image:getHeight()
      spells[3].x = (spell_ui.x + 76*spell_ui.scale)
      spells[3].y = (spell_ui.y + 6)
  end
  if pPlayer.spells[4] then
        spells[4] = {
          image = love.graphics.newImage("images/spells/"..pPlayer.spells[4].image..".png"),
          border = love.graphics.newImage("images/spells/"..pPlayer.spells[4].border..".png"),
          scale = 0.19
        }
        spells[4].w = spells[4].image:getWidth()
        spells[4].h = spells[4].image:getHeight()
        spells[4].x = (spell_ui.x + 112*spell_ui.scale)
        spells[4].y = (spell_ui.y + 6)
  end
  if pPlayer.spells[5] then
      spells[5] = {
        image = love.graphics.newImage("images/spells/"..pPlayer.spells[5].image..".png"),
        border = love.graphics.newImage("images/spells/"..pPlayer.spells[5].border..".png"),
        scale = 0.19
      }
      spells[5].w = spells[5].image:getWidth()
      spells[5].h = spells[5].image:getHeight()
      spells[5].x = (spell_ui.x + 148*spell_ui.scale)
      spells[5].y = (spell_ui.y + 6)

  end
  if pPlayer.spells[6] then
        spells[6] = {
          image = love.graphics.newImage("images/spells/"..pPlayer.spells[6].image..".png"),
          border = love.graphics.newImage("images/spells/"..pPlayer.spells[6].border..".png"),
          scale = 0.19
        }
        spells[6].w = spells[6].image:getWidth()
        spells[6].h = spells[6].image:getHeight()
        spells[6].x = (spell_ui.x + 184*spell_ui.scale)
        spells[6].y = (spell_ui.y + 6)
  end
end

function UpdateHUD(dt)
  local mx,my = love.mouse.getPosition()

  for i=#spells, 1, -1 do
    if spells[i] then
      if mx >= spells[i].x and mx <= spells[i].x + spells[i].w*spells[i].scale and
        my >= spells[i].y and my <= spells[i].y + spells[i].h*spells[i].scale then
          timerInfoBulle = timerInfoBulle + dt
          alreadyOnSpell = true
          if timerInfoBulle >= intervalInfoBulle then
            showSpellInfoBulle = true
            spellInfo = i
          end
          SetCursor("hand")
        else
          if alreadyOnSpell and spellInfo == i then
            alreadyOnSpell = false
            showSpellInfoBulle = false
            timerInfoBulle = 0
            spellInfo = -1
            SetCursor("normal")
          end
        end
      end
    end
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

  -- Player spell
  DrawSpell(player)

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

-- Other draw function
function DrawSpell(pPlayer)
  local mx, my = love.mouse.getPosition()
  love.graphics.setFont(GetFont("shadow"))
  love.graphics.draw(spell_ui.image, spell_ui.x, spell_ui.y, 0, 1.5, 1.5)

  -- Spell Icon
  for i=#spells, 1, -1 do
    if spells[i] then
      if pPlayer.mana < pPlayer.spells[i].cost then
        love.graphics.setColor(0.3,0.3,0.3)
      end
      love.graphics.draw(spells[i].image, spells[i].x, spells[i].y, 0, spells[i].scale, spells[i].scale)
      love.graphics.draw(spells[i].border, spells[i].x, spells[i].y, 0, spells[i].scale, spells[i].scale)
      love.graphics.setColor(1,1,1)
      love.graphics.setFont(GetFont("number_shadow"))
      love.graphics.print(pPlayer.spells[i].cost, spells[i].x + 2, spells[i].y + 2)
      love.graphics.setFont(GetFont("shadow"))
      if not pPlayer.spells[i].isReady then
        local percent = pPlayer.spells[i].timerCooldown/pPlayer.spells[i].cooldown
        love.graphics.push()
        love.graphics.setColor(0.5,0.3,0.8,0.8)
        love.graphics.arc("fill", "pie", spells[i].x + (spells[i].w*spells[i].scale)/2, spells[i].y + (spells[i].h*spells[i].scale)/2, 20, (math.pi*2), (math.pi*2)*percent)
        love.graphics.setColor(1,1,1,1)
        love.graphics.pop()
      end
    end
  end

  love.graphics.draw(spell_round_key.image, spell_round_key.x, spell_round_key.y, 0, 1.5, 1.5)
  -- Spell key
  love.graphics.print(string.upper(pPlayer.key["spell1"]), spell_round_key.x + (28*1.5), spell_round_key.y + (27*1.5))
  love.graphics.print(string.upper(pPlayer.key["spell2"]), spell_round_key.x + (66*1.5), spell_round_key.y + (27*1.5))
  love.graphics.print(string.upper(pPlayer.key["spell3"]), spell_round_key.x + (102*1.5), spell_round_key.y + (27*1.5))
  love.graphics.print(string.upper(pPlayer.key["spell4"]), spell_round_key.x + (138*1.5), spell_round_key.y + (27*1.5))
  love.graphics.print(string.upper(pPlayer.key["spell5"]), spell_round_key.x + (172*1.5), spell_round_key.y + (27*1.5))
  love.graphics.print(string.upper(pPlayer.key["spell6"]), spell_round_key.x + (208*1.5), spell_round_key.y + (27*1.5))
  love.graphics.print(string.upper(pPlayer.key["object"]), spell_round_key.x + (252*1.5), spell_round_key.y + (27*1.5))

  -- Spell data
  if showSpellInfoBulle then
    local offset = 10
    empty_panel_ui.x = mx
    empty_panel_ui.y = my - empty_panel_ui.h*1.5
    love.graphics.draw(empty_panel_ui.image, empty_panel_ui.x, empty_panel_ui.y, 0, 1.5, 1.5)
    love.graphics.draw(spells[spellInfo].image, empty_panel_ui.x + offset, empty_panel_ui.y + offset+13, 0, spells[spellInfo].scale, spells[spellInfo].scale)
    love.graphics.draw(spells[spellInfo].border, empty_panel_ui.x + offset, empty_panel_ui.y + offset+13, 0, spells[spellInfo].scale, spells[spellInfo].scale)
    love.graphics.print("Name: "..pPlayer.spells[spellInfo].name, empty_panel_ui.x + spells[spellInfo].w*spells[spellInfo].scale + offset + 1, empty_panel_ui.y + offset)
    love.graphics.print("Mana: "..tostring(pPlayer.spells[spellInfo].cost), empty_panel_ui.x + spells[spellInfo].w*spells[spellInfo].scale + offset + 1, empty_panel_ui.y + offset + offset*2)
    love.graphics.print("Cooldown: "..tostring(pPlayer.spells[spellInfo].cooldown).." seconds", empty_panel_ui.x + spells[spellInfo].w*spells[spellInfo].scale + offset + 1, empty_panel_ui.y + offset + offset*4)
    love.graphics.print("Damage: "..tostring(pPlayer.spells[spellInfo].damage), empty_panel_ui.x + spells[spellInfo].w*spells[spellInfo].scale + offset + 1, empty_panel_ui.y + offset + offset*6)
    love.graphics.printf(pPlayer.spells[spellInfo].description, empty_panel_ui.x + offset, empty_panel_ui.y + spells[spellInfo].h*spells[spellInfo].scale + offset*5, empty_panel_ui.w*1.5-offset)
  end
  love.graphics.setFont(GetFont("number_shadow"))
end

function DrawItemDrop()
  local mx,my = love.mouse.getPosition()
  local hover, down = false, false
  local target = GetSelectedSprite()

  love.graphics.push()
  love.graphics.draw(drop_ui.image, drop_ui.x, drop_ui.y)
  love.graphics.setFont(GetFont("shadow"))
  love.graphics.printf("Item Drop", drop_ui.x + drop_ui.w/2 - 125/2, drop_ui.y + 25, 125, "center")
  love.graphics.setFont(GetFont("number_shadow"))

  if #target.inventory > 0 then

    for i=#target.inventory,1,-1 do
      local item = target.inventory[i]
      local image = GetItemImage()
      local quad = GetItemQuad(item.iconId)
      local itemX, itemY = drop_ui.x + 22, drop_ui.y + 67 + (37 * (i-1)) + i
      love.graphics.draw(image, quad.data, itemX, itemY)
      love.graphics.setFont(GetFont("shadow"))
      love.graphics.printf(item.name, drop_ui.x + 50, drop_ui.y + 67 + (37 * (i-1)) + i*2, 102, "center")
      love.graphics.setFont(GetFont("number_shadow"))

      if mx >= itemX and mx <= itemX + 124
      and my >= itemY and my <= itemY + 30 then
        if love.mouse.isDown(2) then
          mouseDownOnDrop = true
        end
        if not love.mouse.isDown(2) and mouseDownOnDrop then
          mouseDownOnDrop = false
          if #GetPlayer(1).inventory < 72 then
            table.insert(GetPlayer(1).inventory, item)
            table.remove(target.inventory, i)
          end
        end
      end
    end
  end

  -- Check mouse click on button
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
  local player = GetPlayer(1)
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
  love.graphics.printf("Inventory", inventory_ui.x + inventory_ui.w/2 - 125/2, inventory_ui.y + 8, 125, "center")
  love.graphics.printf(tostring(player.gold), inventory_ui.x + 28, inventory_ui.y + 354, 250, "left")

  if #player.inventory > 0 then
    for i=#player.inventory,1,-1 do
      local item = player.inventory[i]
      local image = GetItemImage()
      local quad = GetItemQuad(item.iconId)
      local itemX, itemY = inventory_ui.x + 195 + (37 * (i-1)), inventory_ui.y + 41
      love.graphics.draw(image, quad.data, itemX, itemY)

      if mx >= itemX and mx <= itemX + 124
      and my >= itemY and my <= itemY + 30 then
        if love.mouse.isDown(2) then
          mouseDownOnDrop = true
        end
        if not love.mouse.isDown(2) and mouseDownOnDrop then
          mouseDownOnDrop = false
        end
      end
    end
  end

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
  SetCursor("hand")
  showInventory = false
end

function GetHUDState(pData)
  return showInventory or showItemDrop or showSpellInfoBulle
end
