local rnd = math.random

local lstEnemies = {}

local function MouseEnter(pSprite, pId)
  SetCursor("enemy")
end

local function MouseLeftClick(pSprite, pId)
  SelectSprite(pId)
end

local function MouseRightClick(pSprite, pId)
  SelectSprite(pId)
  if pSprite.life <= 0 then
    for k,player in pairs(GetPlayerList()) do
      if table.contains(pSprite.killBy, player) and player.isControllable then
        ShowItemDrop(pSprite, pId)
      end
    end
  end
end

local function MouseLeave(pSprite, pId)
  SetCursor("normal")
end

local function getEmptyPosition(pEnemy)
  local l,c = math.floor(pEnemy.y/GetTileSize()),math.floor(pEnemy.x/GetTileSize())
  repeat
    l = math.random(l-5, l+5)
    c = math.random(c-5, c+5)
  until GetTileAt(c*GetTileSize(), l*GetTileSize()) == 0
  return c*GetTileSize(), l*GetTileSize()
end

function CreateEnemy(pX, pY, pImage)
  local enemy = GetSprite("witch")
  enemy.x = pX
  enemy.y = pY

  enemy.spells = {}
  AddSpell(enemy, "lightning")
  AddSpell(enemy, "spiritFire")

  enemy.spellId = -1
  enemy.speed = 0.5

  enemy.isAttackable = true
  enemy.isPlayerDetected = false
  enemy.moveToPlayer = false
  enemy.moveToNewPos = false
  enemy.canMove = true
  enemy.isCastSpell = false
  enemy.isReadyToCast = true

  enemy.EventMouseEnter = MouseEnter
  enemy.EventLeftMouseClick = MouseLeftClick
  enemy.EventRightMouseClick = MouseRightClick
  enemy.EventMouseLeave = MouseLeave

  enemy.timerToMove = 0
  enemy.intervalToMove = rnd(5,7)

  enemy.timerBeforeNext = 0
  enemy.intervalBeforeNext = 0.2

  enemy.timerBeforeEachSpell = 0
  enemy.intervalBeforeEachSpell = rnd(2, 4)

  enemy.timerResetKillBy = 0
  enemy.intervalResetKillBy = 10

  enemy.newX, enemy.newY = getEmptyPosition(enemy)

  enemy.level = math.random(1,5)

  SetDefaultStat(enemy, "enemy", "debug")

  enemy.isExperienceGiven = false

  enemy.killBy = {}

  enemy.powerType = "int"

  enemy.gold = math.random(3, 13) * enemy.level
  enemy.isGoldGiven = false

  enemy.isInventoryGenerated = false

  table.insert(lstEnemies, enemy)
  return enemy
end

function UpdateEnemy(dt)
  for i=#lstEnemies, 1, -1 do
    local enemy = lstEnemies[i]
    local player = GetNearestPlayer(enemy)

    if enemy.canMove and enemy.life > 0 then
      local dX, dY = 0, 0

      -- Check if player is in range
      local distToPlayer = player and math.dist(player.x,player.y, enemy.x,enemy.y) or 45000
      if (not enemy.isPlayerDetected and distToPlayer <= enemy.distanceToDetect) or (enemy.isPlayerDetected and distToPlayer <= enemy.maxDistanceToDetect) then
        enemy.isPlayerDetected = true
      else
        enemy.isPlayerDetected = false
      end

      if #enemy.killBy > 0 and enemy.killBy[1].life > 0 then
        player = enemy.killBy[1]
        distToPlayer = math.dist(player.x,player.y, enemy.x,enemy.y)
        if distToPlayer <= enemy.maxDistanceToDetect then
          enemy.isPlayerDetected = true
        else
          enemy.isPlayerDetected = false
        end
      end

      if enemy.isPlayerDetected then
        -- Move to player if can
        enemy.moveToPlayer = true
        enemy.moveToNewPos = false
        enemy.isFlip = player.x < enemy.x

        -- Use spell if possible
        if not enemy.isReadyToCast then
          enemy.timerBeforeEachSpell = enemy.timerBeforeEachSpell + dt
          if enemy.timerBeforeEachSpell >= enemy.intervalBeforeEachSpell then
            -- Reset timer and interval to launch
            enemy.timerBeforeEachSpell = 0
            enemy.intervalBeforeEachSpell = rnd(2, 4)
            enemy.isReadyToCast = true
          end
        end

        for k,spell in pairs(enemy.spells) do
          if enemy.spellId == -1 and spell.isReady and player.isAttackable and spell.range >= distToPlayer and enemy.mana >= enemy.spells[k].cost and enemy.isReadyToCast then
            PlaySE("spell")
            enemy.isCastSpell = true
            enemy.spellId = k
            enemy.canMove = enemy.spells[enemy.spellId].canMove
            enemy.spells[enemy.spellId].isRemovable = false
            enemy.isReadyToCast = false
          end
        end
      else
        enemy.moveToPlayer = false
      end

      -- If nothing then move to a random position
      -- Todo : add collision detection
      if not enemy.moveToNewPos and not enemy.moveToPlayer then
        enemy.timerToMove = enemy.timerToMove + dt
        if enemy.timerToMove >= enemy.intervalToMove then
          enemy.timerToMove = 0
          enemy.moveToNewPos = true

          enemy.intervalToMove = rnd(5,7)

          enemy.newX, enemy.newY= getEmptyPosition(enemy)

          enemy.isFlip = enemy.newX < enemy.x
        end
      end

      if enemy.moveToNewPos then
        if enemy.newX < enemy.x then
          dX = -enemy.speed
        end
        if enemy.newX > enemy.x then
          dX = enemy.speed
        end
        if enemy.newY < enemy.y then
          dY = -enemy.speed
        end
        if enemy.newY > enemy.y then
          dY = enemy.speed
        end
      end

      if enemy.moveToPlayer and distToPlayer >= 50 then
        if player.x < enemy.x and (enemy.x - player.x > 1) then
          dX = -enemy.speed
        end
        if player.x > enemy.x and (player.x - enemy.x > 1) then
          dX = enemy.speed
        end
        if player.y < enemy.y and (enemy.y - player.y > 1) then
          dY = -enemy.speed
        end
        if player.y > enemy.y and (player.y - enemy.y > 1) then
          dY = enemy.speed
        end
      end

      local norm = math.sqrt(dX*dX + dY*dY)

      if dX ~= 0 or dY ~= 0 then
        StartAnimation(enemy, "run")
        local quadId = enemy.animation[enemy.currentAnimation].frames[enemy.currentFrame]
        dX = dX / norm
        dY = dY / norm

        if not IsSolideZone(enemy.x + enemy.speed * dX * 60*dt, enemy.y, enemy.quad[quadId].originX, enemy.quad[quadId].originY) then
          enemy.x = enemy.x + enemy.speed * dX * 60*dt
        else
          dX = 0
        end
        if not IsSolideZone(enemy.x, enemy.y + enemy.speed * dY * 60*dt, enemy.quad[quadId].originX, enemy.quad[quadId].originY) then
          enemy.y = enemy.y + enemy.speed * dY * 60*dt
        else
          dY = 0
        end

        if (enemy.newX < enemy.x and enemy.x - enemy.newX < 1) or (enemy.newX > enemy.x and enemy.newX - enemy.x < 1) then
          dX = 0
        end
        if (enemy.newY < enemy.y and enemy.y - enemy.newY < 1) or (enemy.newY > enemy.y and enemy.newY - enemy.y < 1) then
          dY = 0
        end

        -- Stop moving if enemy is on wall
        local isStuck = false
        enemy.timerBeforeNext = enemy.timerBeforeNext + dt
        if enemy.timerBeforeNext >= enemy.intervalBeforeNext then
          enemy.timerBeforeNext = 0
          if dX == 0 and dY == 0 then
            isStuck = true
          end
          if isStuck then
            enemy.moveToPlayer = false
            enemy.moveToNewPos = false
            enemy.timerToMove = 0
          end
        end
      else
        StartAnimation(enemy, "idle")
      end

      if math.dist(enemy.x,enemy.y, enemy.newX,enemy.newY) < 2 then
        enemy.moveToNewPos = false
      end
    else
      if enemy.life <= 0 then
      StartAnimation(enemy, "death")

        -- Generate item drop
        if not enemy.isInventoryGenerated then
          enemy.isInventoryGenerated = true
          local qtyItem = rnd(0, 4)
          if qtyItem > 0 then
            for i=1, qtyItem do
              local item = enemy.dropableItem[rnd(1, #enemy.dropableItem)]
              AddItem(enemy, item, 1)
            end
          end
        end

        -- Start give gold and xp
        local enemyReduceXp = false
        for k,p in pairs(enemy.killBy) do
          if p.life > 0 then
            if not enemy.isExperienceGiven then
              if enemy.experience > 0 then
                p.experience = p.experience + 1 * (p.wis*0.2)
                enemy.experience = enemy.experience - 1
                enemyReduceXp = true
              end
            end
            if not enemy.isGoldGiven then
              if enemy.gold > 0 then
                p.gold = p.gold + math.floor(enemy.gold/#enemy.killBy)
                enemy.gold = enemy.gold - math.floor(enemy.gold/#enemy.killBy)
              end
            end
          end
        end

        if enemy.gold <= 0 then
          enemy.isGoldGiven = true
        end
        if not enemyReduceXp then
          enemy.experience = 0
          enemy.isExperienceGiven = true
        end
      end
    end

    -- Cast spell
    if enemy.isCastSpell and enemy.life > 0 then
      if player then
        enemy.isFlip = player.x < enemy.x
      end
      if not enemy.canMove then
        StartAnimation(enemy, "cast")
        if enemy.currentAnimation == "cast" and (enemy.currentFrame >= #enemy.animation["cast"].frames) then
          PlaySpell(enemy, enemy.spells[enemy.spellId], player)
          enemy.canMove = true
          enemy.isCastSpell = false
          enemy.spellId = -1
        end
      else
        PlaySpell(enemy, enemy.spells[enemy.spellId], player)
        enemy.isCastSpell = false
        enemy.spellId = -1
      end
    end

    -- Reset killBy
    if #enemy.killBy > 0 and not enemy.isPlayerDetected then
      enemy.timerResetKillBy = enemy.timerResetKillBy + dt
      if enemy.timerResetKillBy >= enemy.intervalResetKillBy then
        enemy.timerResetKillBy = 0
        enemy.killBy = {}
      end
    end

    if enemy.isRemovable then
      table.remove(lstEnemies, i)
    end
  end
end

function DrawTest()
  for i=#lstEnemies, 1, -1 do
    local enemy = lstEnemies[i]
    local camX, camY = GetCamera("xy")
    love.graphics.rectangle("fill", enemy.newX-16+camX, enemy.newY-16+camY, 32, 32)
  end
end

function GetEnemy(pId)
  return lstEnemies[pId]
end

function GetEnemiesList()
  return lstEnemies
end
