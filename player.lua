-- Key pressed
local spell1Pressed = false
local spell2Pressed = false
local spell3Pressed = false
local spell4Pressed = false
local spell5Pressed = false
local spell6Pressed = false

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
  pPlayer.maxLife = pPlayer.baseLife + pPlayer.baseLife * (pPlayer.lvlLife * (pPlayer.level-1))
  pPlayer.maxMana = pPlayer.baseMana + pPlayer.baseMana * (pPlayer.lvlMana * (pPlayer.level-1))

  pPlayer.life = pPlayer.maxLife
  pPlayer.mana = pPlayer.maxMana

  pPlayer.regenHpPerSecond = math.round(pPlayer.regenHpPerSecond + pPlayer.lvlRegenHp * (pPlayer.level-1))
  pPlayer.regenManaPerSecond = math.round(pPlayer.regenManaPerSecond + pPlayer.lvlRegenMana * (pPlayer.level-1))

  pPlayer.experience = 0
  pPlayer.maxExperience = pPlayer.baseExperience + math.floor((pPlayer.baseExperience * 1.2)) * (pPlayer.level-1)

  pPlayer.str = pPlayer.str + pPlayer.lvlStr * (pPlayer.level-1)
  pPlayer.int = pPlayer.int + pPlayer.lvlInt * (pPlayer.level-1)
  pPlayer.agi = pPlayer.agi + pPlayer.lvlAgi * (pPlayer.level-1)
  pPlayer.wis = pPlayer.wis + pPlayer.lvlWis * (pPlayer.level-1)
  pPlayer.shd = pPlayer.shd + pPlayer.lvlShd * (pPlayer.level-1)
end

function CreatePlayer(pX, pY, pSprite, pClass, pIsControllable)
  local player = GetSprite(pSprite)

  player.x = pX
  player.y = pY

  player.speed = 1

  player.key = {}

  player.EventMouseEnter = MouseEnter
  player.EventLeftMouseClick = MouseLeftClick
  player.EventMouseLeave = MouseLeave

  player.isAttackable = true
  player.canMove = true
  player.isCastSpell = false
  player.spellId = -1
  player.isControllable = pIsControllable or false

  player.level = 1

  SetDefaultStat(player, "player", pClass)

  player.maxExperience = player.baseExperience

  player.powerType = "int"

  player.gold = 0

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
          if not GetHUDState("inventory") then
            ShowInventory()
          else
            CloseInventory()
          end
        end


        -- Spell
        if not love.keyboard.isDown(player.key["spell1"]) then spell1Pressed = false end
        if not love.keyboard.isDown(player.key["spell2"]) then spell2Pressed = false end
        if not love.keyboard.isDown(player.key["spell3"]) then spell3Pressed = false end
        if not love.keyboard.isDown(player.key["spell4"]) then spell4Pressed = false end
        if not love.keyboard.isDown(player.key["spell5"]) then spell5Pressed = false end
        if not love.keyboard.isDown(player.key["spell6"]) then spell6Pressed = false end


        if love.keyboard.isDown(player.key["spell1"]) and not player.isCastSpell and player.spells[1] and player.spells[1].isReady and target and target.isAttackable and math.dist(player.x,player.y, target.x,target.y) <= player.spells[1].range and player.mana >= player.spells[1].cost and target and not spell1Pressed then
          spell1Pressed = true
          CastSpell(player, 1)
        end

        if love.keyboard.isDown(player.key["spell2"]) and not player.isCastSpell and player.spells[2] and player.spells[2].isReady and target and target.isAttackable and math.dist(player.x,player.y, target.x,target.y) <= player.spells[2].range and player.mana >= player.spells[2].cost and target and not spell2Pressed then
          spell2Pressed = true
          CastSpell(player, 2)
        end

        if love.keyboard.isDown(player.key["spell3"]) and not player.isCastSpell and player.spells[3] and player.spells[3].isReady and target and target.isAttackable and math.dist(player.x,player.y, target.x,target.y) <= player.spells[3].range and player.mana >= player.spells[3].cost and target and not spell3Pressed then
          spell3Pressed = true
          CastSpell(player, 3)
        end

        if love.keyboard.isDown(player.key["spell4"]) and not player.isCastSpell and player.spells[4] and player.spells[4].isReady and target and target.isAttackable and math.dist(player.x,player.y, target.x,target.y) <= player.spells[4].range and player.mana >= player.spells[4].cost and target and not spell4Pressed then
          spell4Pressed = true
          CastSpell(player, 4)
        end

        if love.keyboard.isDown(player.key["spell5"]) and not player.isCastSpell and player.spells[5] and player.spells[5].isReady and target and target.isAttackable and math.dist(player.x,player.y, target.x,target.y) <= player.spells[5].range and player.mana >= player.spells[5].cost and target and not spell5Pressed then
          spell5Pressed = true
          CastSpell(player, 5)
        end

        if love.keyboard.isDown(player.key["spell6"]) and not player.isCastSpell and player.spells[6] and player.spells[6].isReady and target and target.isAttackable and math.dist(player.x,player.y, target.x,target.y) <= player.spells[6].range and player.mana >= player.spells[6].cost and target and not spell6Pressed then
          spell6Pressed = true
          CastSpell(player, 6)
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
    player.updateClass(player, target, dt)

    if player.isRemovable then
      table.remove(lstPlayers, i)
    end
  end
end

function CastSpell(pPlayer, pSpellId)
  pPlayer.isCastSpell = true
  pPlayer.spellId = pSpellId
  pPlayer.canMove = pPlayer.spells[pPlayer.spellId].canMove
  pPlayer.spells[pPlayer.spellId].isRemovable = false
  PlaySE("spell")
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
