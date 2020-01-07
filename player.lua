-- Key pressed
local spell1Pressed = false
local spell2Pressed = false
local spell3Pressed = false
local spell4Pressed = false

local inventoryPressed = false
--------------

local lstPlayers = {}

local function MouseEnter(pSprite, pId)
  SetCursor("ally")
end

local function MouseLeftClick(pSprite, pId)
  SelectSprite(pId)
end

local function MouseLeave(pSprite, pId)
  SetCursor("normal")
end

function SetPlayerStat(pPlayer)
  pPlayer.maxLife = pPlayer.baseLife * (1.2 * pPlayer.level)
  pPlayer.maxMana = pPlayer.baseMana * (0.8 * pPlayer.level)

  pPlayer.life = pPlayer.maxLife
  pPlayer.mana = pPlayer.maxMana

  pPlayer.regenHpPerSecond = math.round(pPlayer.regenHpPerSecond + 0.03 * (pPlayer.level-1))
  pPlayer.regenManaPerSecond = math.round(pPlayer.regenManaPerSecond + 0.02 * (pPlayer.level-1))

  pPlayer.experience = 0
  pPlayer.maxExperience = math.floor((pPlayer.baseExperience * 1.2)) * pPlayer.level

  pPlayer.str = pPlayer.str + 0.05 * (pPlayer.level-1)
  pPlayer.int = pPlayer.int + 0.2 * (pPlayer.level-1)
  pPlayer.agi = pPlayer.agi + 0.1 * (pPlayer.level-1)
  pPlayer.wis = pPlayer.wis + 0.1 * (pPlayer.level-1)
  pPlayer.shd = pPlayer.shd + 0.3 * (pPlayer.level-1)
end

function CreatePlayer(pX, pY, pImage, pIsControllable)
  local player = CreateSprite(pX, pY, pImage)

  CreateAnimation(player, "idle", {1, 2, 3, 4}, true)
  CreateAnimation(player, "run", {5, 6, 7, 8, 9, 10, 11, 12}, true)
  CreateAnimation(player, "cast", {13, 14, 15, 16, 17, 18, 19, 20}, false)
  CreateAnimation(player, "hit", {21, 22, 23, 24}, false)
  CreateAnimation(player, "death", {25, 26, 27, 28, 29, 30, 31, 32, 33, 34}, false)

  player.speed = 1

  player.key = {}

  player.EventMouseEnter = MouseEnter
  player.EventLeftMouseClick = MouseLeftClick
  player.EventMouseLeave = MouseLeave

  AddSpell(player, "lightning")
  AddSpell(player, "spiritFire")

  player.isAttackable = true
  player.canMove = true
  player.isCastSpell = false
  player.spellId = -1
  player.isControllable = pIsControllable or false

  player.baseLife = 250
  player.baseMana = 450
  player.baseExperience = 780

  player.level = 1
  player.regenHpPerSecond = 0.5
  player.bonusRegenHp = 0

  player.regenManaPerSecond = 0.2
  player.bonusRegenMana = 0

  player.experience = 0
  player.maxExperience = 780

  player.str = 8
  player.int = 9
  player.agi = 5
  player.wis = 11
  player.shd = 8

  player.powerType = "int"

  SetPlayerStat(player)

  table.insert(lstPlayers, player)
  return player
end

function UpdatePlayer(dt)
  for i=#lstPlayers, 1, -1 do
    local player = lstPlayers[i]
    local target = GetSelectedSprite()
    local distToTarget = target and math.dist(player.x,player.y, target.x,target.y) or 45000

    if player.canMove and player.life > 0 then
      local dX, dY = 0, 0
      if player.isControllable then
        -- Mouse position
        local camX,camY = GetCamera("xy")
        local mx,my = GetCursorPosition()
        player.isFlip = mx < player.x + camX

        -- Movement
        if love.keyboard.isDown(player.key["up"][1]) or love.keyboard.isDown(player.key["up"][2]) then
          dY = -player.speed
        end
        if love.keyboard.isDown(player.key["left"][1]) or love.keyboard.isDown(player.key["left"][2]) then
          dX = -player.speed
        end
        if love.keyboard.isDown(player.key["down"][1]) or love.keyboard.isDown(player.key["down"][2]) then
          dY = player.speed
        end
        if love.keyboard.isDown(player.key["right"][1]) or love.keyboard.isDown(player.key["right"][2]) then
          dX = player.speed
        end

        -- Move character if possible
        local norm = math.sqrt(dX*dX + dY*dY)

        if dX ~= 0 or dY ~= 0 then
          local quadId = player.animation[player.currentAnimation].frames[player.currentFrame]

          StartAnimation(player, "run")

          dX = dX / norm
          dY = dY / norm
          if not IsSolideZone(player.x + player.speed * dX * 60*dt, player.y, player.quad[quadId].originX, player.quad[quadId].originY) then
            player.x = player.x + player.speed * dX * 60*dt
          end
          if not IsSolideZone(player.x, player.y + player.speed * dY * 60*dt, player.quad[quadId].originX, player.quad[quadId].originY) then
            player.y = player.y + player.speed * dY * 60*dt
          end
        else
          if not player.isCastSpell then
            StartAnimation(player, "idle")
          end
        end

        if love.keyboard.isDown("u") then
          player.bonusRegenHp, player.bonusRegenMana = 5,5
        else
          player.bonusRegenHp, player.bonusRegenMana = 0,0
        end

        if not love.keyboard.isDown(player.key["inventory"][1]) then
          inventoryPressed = false
        end

        -- Other
        if love.keyboard.isDown(player.key["inventory"][1]) and not inventoryPressed then
          inventoryPressed = true
          ShowInventory()
        end


        -- Spell
        spell1Pressed = not love.keyboard.isDown(player.key["spell1"])
        spell2Pressed = not love.keyboard.isDown(player.key["spell2"])
        spell3Pressed = not love.keyboard.isDown(player.key["spell3"])
        spell4Pressed = not love.keyboard.isDown(player.key["spell4"])


        if love.keyboard.isDown(player.key["spell1"]) and not player.isCastSpell and player.spells[1] and player.spells[1].isReady and target and target.isAttackable and math.dist(player.x,player.y, target.x,target.y) <= player.spells[1].range and player.mana >= player.spells[1].cost and target and not spell1Pressed then
          player.isCastSpell = true
          player.spellId = 1
          player.canMove = player.spells[player.spellId].canMove
          player.spells[player.spellId].isRemovable = false
          PlaySE("spell")
        end

        if love.keyboard.isDown(player.key["spell2"]) and not player.isCastSpell and player.spells[2] and player.spells[2].isReady and target and target.isAttackable and math.dist(player.x,player.y, target.x,target.y) <= player.spells[2].range and player.mana >= player.spells[2].cost and target and not spell2Pressed then
          player.isCastSpell = true
          player.spellId = 2
          player.canMove = player.spells[player.spellId].canMove
          player.spells[player.spellId].isRemovable = false
          PlaySE("spell")
        end
      end
    else
      if player.life <= 0 then
        if player.isControllable then
          CloseItemDrop()
        end
        StartAnimation(player, "death")
      end
    end


    -- Gestion de l'experience
    if player.experience >= player.maxExperience and player.level < player.maxLevel then
      UpLevel(player)
    else
      if player.level == player.maxLevel then
        player.experience = player.maxExperience
      end
    end

    --print(distToTarget)
    if distToTarget > 35 and player.isControllable then
      CloseItemDrop()
    end

    -- Casting spell
    if player.isCastSpell and player.life > 0 then
      player.isFlip = target.x < player.x
      if not player.canMove then
        StartAnimation(player, "cast")
        if player.currentAnimation == "cast" and (player.currentFrame >= #player.animation["cast"].frames) then
          PlaySpell(player, player.spells[player.spellId], target)
          player.canMove = true
          player.isCastSpell = false
          player.spellId = -1
        end
      else
        PlaySpell(player, player.spells[player.spellId], target)
        player.isCastSpell = false
        player.spellId = -1
      end
    end

    if player.isRemovable then
      table.remove(lstPlayers, i)
    end
  end
end

function GetPlayer(pId)
  return lstPlayers[pId]
end

function GetPlayerList()
  return lstPlayers
end

function GetNearestPlayer(pEnemy)
  local distToEnemy = 45000
  local target = nil
  for k,player in pairs(lstPlayers) do
    if math.dist(pEnemy.x,pEnemy.y, player.x,player.y) < distToEnemy and player.life > 0 then
      distToEnemy = math.dist(pEnemy.x,pEnemy.y, player.x,player.y)
      target = player
    end
  end
  return target
end

function UpLevel(pPlayer, pLevel)
  local level = pLevel or 1
  if level > 0 then
    if pPlayer.level < pPlayer.maxLevel then
      local fx = CreateFx("10", 100, 100, 31, 0.01)
      PlaySE("zap")
      PlayFx(fx, pPlayer)
      pPlayer.level = pPlayer.level + level
      if pPlayer.level > pPlayer.maxLevel then
        pPlayer.level = pPlayer.maxLevel
      end
      SetPlayerStat(pPlayer)

      --local text = "=====New stat :\nLevel : "..pPlayer.level.."\nLife : "..pPlayer.maxLife.."\nMana : "..pPlayer.maxMana.."\nExp : "..pPlayer.maxExperience.."\n==============="
      --print(text)
    end
  else
    if pPlayer.level > 1 then
      local fx = CreateFx("10", 100, 100, 31, 0.01)
      PlaySE("zap")
      PlayFx(fx, pPlayer)
      pPlayer.level = pPlayer.level + level
      if pPlayer.level < 0 then
        pPlayer.level = 1
      end

      SetPlayerStat(pPlayer)
    end
  end
end
