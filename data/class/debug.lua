local magician = {}

magician.baseLife = 2500
magician.baseMana = 4500
magician.baseExperience = 780

magician.regenHpPerSecond = 0.5
magician.bonusRegenHp = 0

magician.regenManaPerSecond = 0.2
magician.bonusRegenMana = 0

magician.experience = 0

magician.str = 8
magician.int = 9
magician.agi = 5
magician.wis = 11
magician.shd = 8

magician.lvlLife = 1.2
magician.lvlMana = 0.8

magician.lvlRegenHp = 0.03
magician.lvlRegenMana = 0.02

magician.lvlStr = 0.05
magician.lvlInt = 0.2
magician.lvlAgi = 0.1
magician.lvlWis = 0.1
magician.lvlShd = 0.3

magician.spells = {}

AddSpell(magician, "lightning")

function magician.updateClass(pPlayer, pTarget, dt)
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

return magician
