local leftBtnPressed = false
local rightBtnPressed = false
local lstSprites = {}
local selectedSprite = -1

-- local funtion
local function sortY(pA, pB)
  return pA.y > pB.y
end

local function readFile(pFilename)
  local file,err = io.open(pFilename)
  local content = file:read("*all")
  file:close()
  return content
end

local spriteData = json.decode(readFile("images/sprite/data.json"))
local function createQuad(pName)
  local quads = {}
  local data = spriteData[pName]
  for i=1, tonumber(data.count) do
    local frame = data.frames[tostring(i)]
    local quad = love.graphics.newQuad(tonumber(frame.x), tonumber(frame.y), tonumber(frame.w), tonumber(frame.h), tonumber(data.w), tonumber(data.h))
    quads[i] = {}
    quads[i].data = quad
    quads[i].width = tonumber(frame.w)
    quads[i].height = tonumber(frame.h)
    quads[i].originX = tonumber(frame.w)/2
    quads[i].originY = tonumber(frame.h)/2
  end
  return quads
end
-- end local function

function CreateSprite(pX, pY, pImage)
  local sprite = {}
  sprite.x = pX or 0
  sprite.y = pY or 0

  sprite.scaleX = 1
  sprite.scaleY = 1

  sprite.image = love.graphics.newImage("images/sprite/"..pImage..".png")
  sprite.icon = love.graphics.newImage("images/sprite/"..pImage.."_icon.png")

  sprite.quad = createQuad(pImage)

  sprite.animation = {}
  sprite.currentAnimation = "idle"
  sprite.currentFrame = 1
  sprite.timerAnimation = 0

  sprite.timerShowDamage = 0
  sprite.intervalShowDamage = 1.2

  sprite.timerDeath = 0
  sprite.intervalDeath = 45

  sprite.isRemovable = false
  sprite.isMouseHover = false
  sprite.alreadyExit = false
  sprite.isFlip = false
  sprite.isAttackable = false
  sprite.isSelected = false
  sprite.canMove = true
  sprite.isCastSpell = false
  sprite.isNpc = false
  sprite.showDamage = false

  sprite.EventMouseEnter = nil
  sprite.EventMouseLeave = nil
  sprite.EventLeftMouseClick = nil
  sprite.EventRightMouseClick = nil

  sprite.updateClass = nil

  sprite.spells = {}

  sprite.spellId = -1

  sprite.maxLevel = 50
  sprite.level = 1
  sprite.life = 1
  sprite.maxLife = 1
  sprite.regenHpPerSecond = 0
  sprite.bonusRegenHp = 0
  sprite.damageTaken = 0

  sprite.mana = 1
  sprite.maxMana = 1
  sprite.regenManaPerSecond = 0
  sprite.bonusRegenMana = 0

  sprite.baseLife = 1
  sprite.baseMana = 1

  sprite.experience = 0

  sprite.str = 5
  sprite.int = 5
  sprite.agi = 5
  sprite.wis = 5
  sprite.shd = 5
  sprite.atkSpeed = 0

  sprite.lvlLife = 0
  sprite.lvlMana = 0

  sprite.lvlRegenMana = 0
  sprite.lvlRegenHp = 0

  sprite.lvlStr = 0
  sprite.lvlInt = 0
  sprite.lvlAgi = 0
  sprite.lvlWis = 0
  sprite.lvlShd = 0
  sprite.lvlAtkSpeed = 0

  sprite.bonusStr = 0
  sprite.bonusInt = 0
  sprite.bonusAgi = 0
  sprite.bonusWis = 0
  sprite.bonusShd = 0
  sprite.bonusAtkSpeed = 0

  sprite.powerType = "null"

  sprite.inventory = {}

  sprite.gold = 0

  table.insert(lstSprites, sprite)
  return sprite
end

local function updateAnimation(pSprite, dt)
  local sprite = pSprite
  sprite.timerAnimation = sprite.timerAnimation + dt
  if sprite.timerAnimation >= sprite.animation[sprite.currentAnimation].interval then
    sprite.timerAnimation = 0
    sprite.currentFrame = sprite.currentFrame + 1
    if sprite.currentFrame > #sprite.animation[sprite.currentAnimation].frames then
      if sprite.animation[sprite.currentAnimation].isLoop then
        sprite.currentFrame = 1
      else
        sprite.currentFrame = #sprite.animation[sprite.currentAnimation].frames
      end
    end
  end
end

function UpdateSprite(dt)
  table.sort(lstSprites, sortY)

  for i=#lstSprites, 1, -1 do
    local sprite = lstSprites[i]

    if sprite.canMove then
      sprite.canMove = sprite.life > 0
    end
    if sprite.life <= 0 or sprite.isNpc then
      sprite.isAttackable = false
    end

    if sprite.isSelected then
      selectedSprite = i
    end
    -- Animation
    updateAnimation(sprite, dt)
    local quadId = sprite.animation[sprite.currentAnimation].frames[sprite.currentFrame]

    -- Check mouse postion
    if sprite.quad[quadId] then
      local camX,camY = GetCamera("xy")
      local mx,my = GetCursorPosition()
      if mx >= (sprite.x - sprite.quad[quadId].width/2) + camX and
              mx <= (sprite.x + sprite.quad[quadId].width/2) + camX and
              my >= (sprite.y - sprite.quad[quadId].height/2) + camY and
              my <= (sprite.y + sprite.quad[quadId].height/2) + camY then
                sprite.isMouseHover = true
      else
        sprite.isMouseHover = false
      end
    end

    -- Check mouse enter on sprite
    if sprite.EventMouseEnter and sprite.isMouseHover and not GetHUDState("item_drop") and not GetHUDState("inventory") then
      sprite.EventMouseEnter(sprite, i)
      sprite.alreadyExit = false
    end

    -- Check mouse click
    leftBtnPressed = not love.mouse.isDown(1)
    rightBtnPressed = not love.mouse.isDown(2)

    if sprite.EventLeftMouseClick and sprite.isMouseHover and love.mouse.isDown(1) and not leftBtnPressed and not GetHUDState() then
      sprite.EventLeftMouseClick(sprite, i)
    end

    if sprite.EventRightMouseClick and sprite.isMouseHover and love.mouse.isDown(2) and not rightBtnPressed and not GetHUDState() then
      sprite.EventRightMouseClick(sprite, i)
    end

    if sprite.EventLeftMouseClick and not sprite.isMouseHover and love.mouse.isDown(1) and not leftBtnPressed and not GetHUDState() then
      if sprite.isSelected then
        sprite.isSelected = false
        selectedSprite = -1
      end
    end

    -- Check mouse leave sprite
    if sprite.EventMouseLeave and not sprite.isMouseHover and not sprite.alreadyExit and not GetHUDState() then
      sprite.EventMouseLeave(sprite, i)
      sprite.alreadyExit = true
    end

    -- Reset spell cooldown
    for k,spell in pairs(sprite.spells) do
      if not spell.isReady then
        spell.timerCooldown = spell.timerCooldown + dt
        if spell.timerCooldown >= spell.cooldown then
          spell.timerCooldown = 0
          spell.isReady = true
          spell.isRemovable = true
        end
      end
    end


    -- Regen hp and mana
    if sprite.life < sprite.maxLife and sprite.life > 0 then
      sprite.life = sprite.life + (sprite.regenHpPerSecond+sprite.bonusRegenHp)*dt
    elseif sprite.life > sprite.maxLife then
      sprite.life = sprite.maxLife
    end

    if sprite.mana < sprite.maxMana and sprite.life > 0 then
      sprite.mana = sprite.mana + (sprite.regenManaPerSecond+sprite.bonusRegenMana)*dt
    elseif sprite.mana > sprite.maxMana then
      sprite.mana = sprite.maxMana
    end

    -- Disappear if sprite is dead
    if sprite.life <= 0 then
      sprite.mana = 0
      sprite.timerDeath = sprite.timerDeath + dt
      if sprite.timerDeath >= sprite.intervalDeath then
        if #sprite.inventory == 0 then
          sprite.isRemovable = true
          local fx = CreateFx("smoke", 32, 32, 4, 0.07)
          PlayFx(fx, sprite)
          PlaySE("sand")
        end
      end
    end

    -- Check if show damage
    if sprite.showDamage then
      sprite.timerShowDamage = sprite.timerShowDamage + dt
      if sprite.timerShowDamage >= sprite.intervalShowDamage then
        sprite.timerShowDamage = 0
        sprite.showDamage = false
      end
    end

    -- Remove sprite
    if sprite.isRemovable then
      table.remove(lstSprites, i)
    end
  end
end

function DrawSprite()
  love.graphics.setFont(GetFont("shadow"))
  local camX, camY = GetCamera("xy")
  for i=#lstSprites, 1, -1 do
    local sprite = lstSprites[i]
    local quadId = sprite.animation[sprite.currentAnimation].frames[sprite.currentFrame]

    if sprite.isSelected then
      love.graphics.setColor(1,0.5,0.5,0.6)
      love.graphics.ellipse("fill", sprite.x+camX, sprite.y+camY+sprite.quad[quadId].originY, 10, 2)
      love.graphics.setColor(1,1,1,1)
    end

    if sprite.isFlip then
      love.graphics.draw(sprite.image, sprite.quad[quadId].data, sprite.x+camX, sprite.y+camY, 0, -sprite.scaleX, sprite.scaleX, sprite.quad[quadId].originX, sprite.quad[quadId].originY)
    else
      love.graphics.draw(sprite.image, sprite.quad[quadId].data, sprite.x+camX, sprite.y+camY, 0, sprite.scaleX, sprite.scaleX, sprite.quad[quadId].originX, sprite.quad[quadId].originY)
    end
  end
  love.graphics.setFont(GetFont("normal"))
end

function DrawDamage()
  love.graphics.setFont(GetFont("shadow"))
  local camX, camY = GetCamera("xy")
  for i=#lstSprites, 1, -1 do
    local sprite = lstSprites[i]
    local quadId = sprite.animation[sprite.currentAnimation].frames[sprite.currentFrame]
    if sprite.showDamage then
      love.graphics.printf(tostring(sprite.damageTaken), sprite.x+camX-30, sprite.y-(sprite.quad[quadId].originY)-(sprite.timerShowDamage*10)+camY, 60, "center")
    end
  end
    love.graphics.setFont(GetFont("normal"))
end

function CreateAnimation(pSprite, pAnimationName, pFrames, pIsLoop, pInterval)
  local animation = {}
  animation.frames = pFrames
  animation.interval = pInterval or 0.12
  animation.isLoop = pIsLoop
  pSprite.animation[pAnimationName] = animation
end

function StartAnimation(pSprite, pAnimationName)
  if pSprite.currentAnimation ~= pAnimationName then
    pSprite.currentFrame = 1
    pSprite.currentAnimation = pAnimationName
    pSprite.timerAnimation = 0
  end
end

function SelectSprite(pId)
  for i=#lstSprites, 1, -1 do
    if i == pId then
      lstSprites[i].isSelected = true
    else
      lstSprites[i].isSelected = false
    end
  end
end

function GetSelectedSprite()
  return lstSprites[selectedSprite]
end

function GetSprite(pName)
  return dofile("data/sprite/"..pName..".lua")
end

function SetDefaultStat(pSprite, pType, pClass)
  if pType == "player" then
    local class = dofile("data/class/"..pClass..".lua")
    pSprite.baseLife = class.baseLife
    pSprite.baseMana = class.baseMana
    pSprite.baseExperience = class.baseExperience

    pSprite.maxLife = class.baseLife
    pSprite.maxMana = class.baseMana

    pSprite.regenHpPerSecond = class.regenHpPerSecond
    pSprite.bonusRegenHp = class.bonusRegenHp

    pSprite.regenManaPerSecond = class.regenManaPerSecond
    pSprite.bonusRegenMana = class.bonusRegenMana

    pSprite.experience = class.experience

    pSprite.str = class.str
    pSprite.int = class.int
    pSprite.agi = class.agi
    pSprite.wis = class.wis
    pSprite.shd = class.shd

    pSprite.lvlLife = class.lvlLife
    pSprite.lvlMana = class.lvlMana

    pSprite.lvlRegenHp = class.lvlRegenHp
    pSprite.lvlRegenMana = class.lvlRegenMana

    pSprite.lvlStr = class.lvlStr
    pSprite.lvlInt = class.lvlInt
    pSprite.lvlAgi = class.lvlAgi
    pSprite.lvlWis = class.lvlWis
    pSprite.lvlShd = class.lvlShd

    for k,spell in pairs(class.spells) do
      table.insert(pSprite.spells,spell)
    end
    CreateSpell(pSprite)

    pSprite.updateClass = class.updateClass
  else
    local class = dofile("data/monster/"..pClass..".lua")
    pSprite.baseLife = class.baseLife
    pSprite.baseMana = class.baseMana
    pSprite.baseExperience = class.baseExperience

    pSprite.maxLife = class.baseLife
    pSprite.maxMana = class.baseMana

    pSprite.life = pSprite.maxLife
    pSprite.mana = pSprite.maxMana

    pSprite.regenHpPerSecond = class.regenHpPerSecond
    pSprite.bonusRegenHp = class.bonusRegenHp

    pSprite.regenManaPerSecond = class.regenManaPerSecond
    pSprite.bonusRegenMana = class.bonusRegenMana

    pSprite.experience = class.experience

    pSprite.str = class.str
    pSprite.int = class.int
    pSprite.agi = class.agi
    pSprite.wis = class.wis
    pSprite.shd = class.shd

    pSprite.lvlLife = class.lvlLife
    pSprite.lvlMana = class.lvlMana

    pSprite.lvlRegenHp = class.lvlRegenHp
    pSprite.lvlRegenMana = class.lvlRegenMana

    pSprite.lvlStr = class.lvlStr
    pSprite.lvlInt = class.lvlInt
    pSprite.lvlAgi = class.lvlAgi
    pSprite.lvlWis = class.lvlWis
    pSprite.lvlShd = class.lvlShd

    pSprite.distanceToDetect = class.distanceToDetect
    pSprite.maxDistanceToDetect = class.maxDistanceToDetect

    for k,spell in pairs(class.spells) do
      table.insert(pSprite.spells,spell)
    end

    pSprite.updateClass = class.updateClass
  end
end

function LoseHp(pOwner, pTarget, pHp)
  local pui = 0
  if pOwner.powerType == "int" then
    pui = pOwner.int + pOwner.bonusInt
  elseif pOwner.powerType == "str" then
    pui = pOwner.str + pOwner.bonusStr
  elseif pOwner.powerType == "agi" then
    pui = pOwner.agi+ pOwner.bonusAgi
  end

  pTarget.timerShowDamage = 0
  pTarget.showDamage = true

  pTarget.damageTaken = math.floor((((pTarget.level * 0.4 + 2) * pui * (pOwner.level/15) * pHp) / (pTarget.shd * (pTarget.level/15) * 50 / 100)) + 2)-- Ajouter critique plus tard
  pTarget.life = pTarget.life - pTarget.damageTaken

  if pTarget.killBy then
    if not table.contains(pTarget.killBy, pOwner) then
      table.insert(pTarget.killBy, pOwner)
    end
    if not table.contains(pTarget.killBy, to2) then
      table.insert(pTarget.killBy, to2)
    end
  end

  if pTarget.life < 0 then
    pTarget.life = 0
  end
end

function DropItem()

end
