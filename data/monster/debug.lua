local debug = {}

debug.baseLife = 180
debug.baseMana = 220
debug.baseExperience = 780

debug.distanceToDetect = 70
debug.maxDistanceToDetect = 180

debug.regenHpPerSecond = 0.5
debug.bonusRegenHp = 0

debug.regenManaPerSecond = 0.2
debug.bonusRegenMana = 0

debug.experience = 48

debug.str = 3
debug.int = 9
debug.agi = 7
debug.wis = 1
debug.shd = 12
debug.atkSpeed = 0.6

debug.lvlLife = 1.2
debug.lvlMana = 0.8

debug.lvlRegenHp = 0.03
debug.lvlRegenMana = 0.02

debug.lvlStr = 0.05
debug.lvlInt = 0.2
debug.lvlAgi = 0.1
debug.lvlWis = 0.1
debug.lvlShd = 0.3
debug.lvlAtkSpeed = 0.01

debug.dropableItem = {"healthPotion", "bronzePiece"}

debug.spells = {}

AddSpell(debug, "lightning")
AddSpell(debug, "spiritFire")

function debug.updateClass(pPlayer, pTarget, dt)
  if pPlayer.isCastSpell and pPlayer.life > 0 then
    pPlayer.isFlip = pTarget.x < pPlayer.x
    if not pPlayer.canMove then
      StartAnimation(pPlayer, "cast")
      if pPlayer.currentAnimation == "cast" and (pPlayer.currentFrame >= #pPlayer.animation["cast"].frames) then
        PlaySpell(pPlayer, pPlayer.spells[pPlayer.spellId], pTarget)
        pPlayer.canMove = true
        pPlayer.isCastSpell = false
        pPlayer.spellId = -1
      end
    else
      PlaySpell(pPlayer, pPlayer.spells[pPlayer.spellId], pTarget)
      pPlayer.isCastSpell = false
      pPlayer.spellId = -1
    end
  end
end

return debug
