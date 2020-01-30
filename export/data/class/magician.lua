local magician = {}

magician.baseLife = 250
magician.baseMana = 200
magician.baseExperience = 780

magician.regenHpPerSecond = 0.05
magician.bonusRegenHp = 0

magician.regenManaPerSecond = 0.02
magician.bonusRegenMana = 0

magician.experience = 0

magician.str = 8
magician.int = 9
magician.agi = 5
magician.wis = 11
magician.shd = 8
magician.atkSpeed = 0.6

magician.lvlLife = 0.5
magician.lvlMana = 0.3

magician.lvlRegenHp = 0.03
magician.lvlRegenMana = 0.02

magician.lvlStr = 0.05
magician.lvlInt = 0.2
magician.lvlAgi = 0.1
magician.lvlWis = 0.1
magician.lvlShd = 0.3
magician.lvlAtkSpeed = 0.01

magician.spells = {}

AddSpell(magician, "lightning")
AddSpell(magician, "spiritFire")
AddSpell(magician, "nightmare")
AddSpell(magician, "fireHell")
AddSpell(magician, "blueFire")
AddSpell(magician, "lotus")

function magician.updateClass(pPlayer, pTarget, dt)
  if pPlayer.isCastSpell and pPlayer.life > 0 then
    if pTarget then
      pPlayer.isFlip = pTarget.x < pPlayer.x
    end
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
